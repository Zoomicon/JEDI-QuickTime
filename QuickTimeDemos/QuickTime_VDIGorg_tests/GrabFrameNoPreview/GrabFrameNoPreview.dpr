//
//	VDIG.ORG test application. (see http://www.vdig.org)
//
//
//	Grab 25 frames of size 320,240 from the camera. No preview at all.
//	The data is placed in a handle which we just destroy. This is really
//	basic stuff. All VDIGs should support.
//

{$APPTYPE CONSOLE}

uses
 SGSettings in '..\Common\SGSettings.pas',
 common in '..\Common\common.pas',
 qt_Movies,
 Windows,
 qt_MacTypes,
 qt_QuickTimeComponents,
 qt_Components,
 qt_QDOffscreen,
 qt_QuickDraw,
 qt_ImageCompression,
 qt_QTML,
 C_Types,
 SysUtils;

procedure doSimpleSingleFrameGrab;
var err:OSErr;
    mSGComponent:SeqGrabComponent;
    mVideoChannel:SGChannel;
    //canOffscreen:Boolean;
    //mResourceID:short;
    theDesc:ComponentDescription;
    sgCompID:Component;
    mMacGWorld:GWorldPtr;
    mSaveDevice:GDHandle;
    mSavePort:CGrafPtr;
    startTime:dword; //long
    i:integer;
    p:PicHandle;
    interval:long;
    seconds:double;
    mFrame:Rect;
const R:Rect=(top:0;left:0;bottom:240;right:320);
      APPL=(((ord('a') shl 8 +ord('p'))shl 8 +ord('p'))shl 8 +ord('l')); {'appl'}
begin
 writeln('GrabFrameNoPreview...');

 //canOffscreen:=false;
 //mResourceID:=0;     // force a search for the first movie resource ID.

 theDesc.componentType:=SeqGrabComponentType;
 theDesc.componentSubType:=0;
 theDesc.componentManufacturer:=APPL;
 theDesc.componentFlags:=0;
 theDesc.componentFlagsMask:=0;

 sgCompID:=FindNextComponent(nil,theDesc);
 if(sgCompID<>nil) then
  mSGComponent:=OpenComponent(sgCompID)
 else
  mSGComponent:=nil;

try

 if(mSGComponent=nil) then raise Exception.Create('mSGComponent=nil');

 CheckErr('SGInitialize', SGInitialize(mSGComponent));
 CheckErr('SGNewChannel', SGNewChannel(mSGComponent, VideoMediaType, mVideoChannel));

 ShowSettings(mSGComponent,mVideoChannel);


 //
 //	Why is SGDisposeChannel necessary?????
 //
 //	The documentation in IM QT Components for SGGrabPict
 //	states that it will use any allocated channels (if they exist). My assumption is
 //	that pre-allocating a channel would speed up digitizing, and allow features like
 //	automatic exposure time to work. I.e. it would be A Good Thing To Do.
 //
 //	Try commnting the following line out. Most VDIGs give a divide by zero error deep
 //	inside SGGrabPict.
 //
 CheckErr('SGDisposeChannel', SGDisposeChannel(mSGComponent, mVideoChannel));

 mFrame:=R;

 CheckErr('QTNewGWorld', QTNewGWorld(mMacGWorld, 32, mFrame, nil, nil, 0));
 LockPixels(GetGWorldPixMap(mMacGWorld));

 GetGWorld(mSavePort, mSaveDevice);
 SetGWorld(mMacGWorld, nil);

 writeln('Capturing a single frame...');
 startTime:=GetTickCount; //clock()

 for i:=0 to 25 do
  begin
  writeln(format('Frame#\t%d',[i]));
  CheckErr('SGSetGWorld', SGSetGWorld(mSGComponent,CGrafPtr(mMacGWorld),nil));
  err:=SGGrabPict(mSGComponent, p, mFrame, 0, 0);
  if (err<>0) or (p=nil) then CheckErr('SGGrabPict',err);
  KillPicture(p);
  SetGWorld(mSavePort, mSaveDevice);
  end;
  writeln(format('Picture Handle: %d',[p]));

  interval:=GetTickCount-startTime; //clock()
  seconds:=interval/1000; //CLOCKS_PER_SEC=1000, since GetTickCount returns time in msec (whereas MacOS's clock() returns time in clock ticks)
  writeln(format('Time Taken (25 frames): %f',[seconds]));

  CheckErr('CloseComponent', CloseComponent(mSGComponent));

  writeln('SUCCEEDED');
 except
  MessageBeep(MB_ICONHAND);
  writeln('FAILED');
 end;
end;

begin
 InitializeQTML(0);
 Initialize;
 doSimpleSingleFrameGrab();
 ExitMovies;
 TerminateQTML;
end.

