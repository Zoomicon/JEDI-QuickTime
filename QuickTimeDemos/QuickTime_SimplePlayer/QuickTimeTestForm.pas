(***********************************************************************************
This is an example on the usage of the QuickTime headers from http://www.deplhi-jedi.org
To compile it needs the QuickTime DCUs accessible in the library search path

- for more on QuickTime for Delphi visit http://members.fortunecity.com/birbilis/QT4Delphi
- for any questions contact birbilis@kagi.com

(C)opyright 1998-2002 George Birbilis / Agrinio Club


HISTORY:
---------
17Sep2001 - added GetPortFromWindowReference and a call to MacSetPort at FormCreate
          - added a call to MCSetControllerBoundsRect at OpenMovie
          - added a call to SetMovieGWorld at OpenMovie
          - cleaned up the code a bit
          - added a call to MCIdle at the end of OpenMovie to repaint
 2Dec2001 - copied the WndProc from the latest TQTControl of QT4Delphi
13Apr2002 - minor changes to work with the newest JEDI-QuickTime header versions

***********************************************************************************)

unit QuickTimeTestForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Menus,
  qt_QuickDraw,
  qt_Files,
  qt_Movies,
  qt_MacTypes,
  qt_QuickTimeVR;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Close1: TMenuItem;
    Exit1: TMenuItem;
    btnLeft: TButton;
    About1: TMenuItem;
    QTVersion1: TMenuItem;
    btnRight: TButton;
    Button1: TButton;
    Button2: TButton;
    N1: TMenuItem;
    rawQT4Delphidemo1: TMenuItem;
    Label1: TLabel;
    StaticText1: TStaticText;
    httpwwwdelphijediorg1: TMenuItem;
    byGeorgeBirbilisbirbilisctigr1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure btnLeftClick(Sender: TObject);
    procedure QTVersion1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnRightClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
  private
    qtInited:boolean;
    cgp:GrafPtr;
    fs:FSSpec;
    movieResFile:short;
    theMovie:Movie;
    theMC:MovieController;
    theMovieRect:Rect;
    //QTVR//
    myTrack:Track;
    myInstance:QTVRInstance;
  protected
    procedure WndProc(var winmsg: TMessage);override;
  public
    procedure OpenMovie;
    procedure CloseMovie;
  end;

var
  Form1: TForm1;

implementation
 uses
  C_Types,
  qt_QTML,
  qt_QDOffScreen,
  qt_Events,
  QTime,
  QTUtils;

{$R *.DFM}

//////////
//
// GetPortFromWindowReference
// Return the graphics port associated with a window reference.
//
//////////

function GetPortFromWindowReference (theWindow:HWND):GrafPtr;
begin
 if (theWindow <> 0) then
  result:=GrafPtr(GetNativeWindowPort(theWindow)) //same as GetHWNDPort
 else result:=nil;
end;

//////////////////////////////////////////////////////////////////

procedure TForm1.FormCreate(Sender: TObject);
begin
 InitializeQTML(0); //Initialize QTML
 cgp:=CreatePortAssociation(pointer(Handle),nil,0); //Register Windows with QTML
 MacSetPort(GetPortFromWindowReference(WindowHandle)); //???got from WinFrameWork.c from QTShell demo
 EnterMovies; //Initialize QuickTime
 InitializeQTVR;
 qtInited:=true;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 CloseMovie; //!!!
 DestroyPortAssociation({cgp}CGrafPtr(getNativeWindowPort(handle)));
 TerminateQTVR();
 ExitMovies; //Terminate QuickTime
 TerminateQTML; //Terminate QTML
end;

//////////////////////////////////////////////////////////////////

procedure TForm1.OpenMovie;
var myResID:short; //the QTUtils.GetMovie sets it to 0 to get the 1st movie
begin
 CloseMovie;
 SetGWorld(CGrafPtr(GetNativeWindowPort(handle)),nil);
 
 theMovie:=QTUtils.GetMovie(@fs,@movieResFile,@myResID);
 CloseMovieFile(movieResFile);
 if (theMovie<>nil) then // Create the movie controller
  begin

  // make sure the movie uses the window GWorld in all situations //??? found in WinFrameWork.c from QTShell.c
  SetMovieGWorld(theMovie, CGrafPtr(GetPortFromWindowReference(WindowHandle)), GetGWorldDevice(CGrafPtr(GetPortFromWindowReference(WindowHandle))));

  theMovieRect.top:=0; theMovieRect.left:=0;
  theMovieRect.right:=width-1; theMovieRect.bottom:=height-1 -45;
  theMC:=NewMovieController(theMovie,@theMovieRect, mcTopLeftMovie);
  if(theMC=nil) then exit;
  MCSetControllerBoundsRect(theMC,theMovieRect); //needed, else the above doesn't make the movie fit the control

  //--- QTVR ---//
  myTrack:=QTVRGetQTVRTrack(theMovie,1);
  if(myTrack<>nil) then
   begin
   QTVRGetQTVRInstance(myInstance,myTrack,theMC);
   if(myInstance<>nil) then
    begin
    QTVRSetAngularUnits(myInstance,kQTVRDegrees);
    end;
   end;
  end;

 try
  SetMovieRate(theMovie,getMoviePreferredRate(theMovie)); //the getMoviePreferredRate throws a division-by-zero when used with vr01.mov ???
  MCIdle(theMC); //tell the controller to paint itself (needed for plain sound/music controllers)
 except //catching the exception (only occuring with QTVR panoramas?)
 end;

end;

procedure WinMessageToNativeEvent(const winmsg:TMessage;var nativeEvent:TMsg);
var point:integer;
begin
 with nativeEvent do
  begin
  message := winmsg.msg;
  wParam := winmsg.wParam;
  lParam := winmsg.lParam;
  time := GetMessageTime();
  point := GetMessagePos();
  with pt do
   begin
   x := LOWORD(point);
   y := HIWORD(point);
   end;
  end;
end;

procedure TForm1.WndProc(var winmsg: TMessage);
var nativeEvent:TMsg;
    macEvent:EventRecord;
begin //WindowHandle should be faster than Handle property
 inherited WndProc(winmsg); //pass message to the VCL (do first to avoid garbage on the movie when dialogs pass over it!)
 if (qtInited) then //don't do anything unless form has been created and QT initialized!!!
  if(handleAllocated and (GetNativeWindowPort(WindowHandle)<>nil)) then
   begin
   WinMessageToNativeEvent(winmsg,nativeEvent);
   nativeEvent.hwnd := (*hWnd*)WindowHandle;
   NativeEventToMacEvent(nativeEvent, macEvent);  // Convert the message to a QTML event
   //if we have a Movie Controller, pass it the QTML event
   MCIsPlayerEvent(theMC,EventRecordPtr(@macEvent));
 end;
end;

procedure TForm1.CloseMovie;
begin
 if (theMC<>nil) then
  begin
  DisposeMovieController(theMC); //might be a picture
  theMC:=nil; //must make nil, so that we won't try to dispose it again
  end;
 if (theMovie<>nil) then
  begin
  DisposeMovie(theMovie);
  theMovie:=nil; //must make nil, so that we won't try to dispose it again
  end;
 repaint; //!!!
end;

///////////////////////

procedure TForm1.Exit1Click(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
 CloseMovie;
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
 OpenMovie;
end;

procedure TForm1.QTVersion1Click(Sender: TObject);
begin
 ShowMessage('QT Version='+intToStr(getQTVersion));
end;

procedure TForm1.FormResize(Sender: TObject);
var box:Rect;
begin
 with box do
  begin
  top:=0;
  left:=0;
  right:=width-1;
  bottom:=height-1  -45;
  end;
 //SetMovieBox(theMovie,box);
 MCSetControllerBoundsRect(theMC,box);
end;

procedure TForm1.btnLeftClick(Sender: TObject);
begin
 QTVRSetPanAngle(myInstance,QTVRGetPanAngle(myInstance)-1);
 QTVRUpdate(myInstance,kQTVRStatic);
end;

procedure TForm1.btnRightClick(Sender: TObject);
begin
 QTVRSetPanAngle(myInstance,QTVRGetPanAngle(myInstance)+1);
 QTVRUpdate(myInstance,kQTVRStatic);
end;

procedure TForm1.btnUpClick(Sender: TObject);
begin
 QTVRSetTiltAngle(myInstance,QTVRGetTiltAngle(myInstance)+1);
 QTVRUpdate(myInstance,kQTVRStatic);
end;

procedure TForm1.btnDownClick(Sender: TObject);
begin
 QTVRSetTiltAngle(myInstance,QTVRGetTiltAngle(myInstance)-1);
 QTVRUpdate(myInstance,kQTVRStatic);
end;


end.

