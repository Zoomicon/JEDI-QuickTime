(******************************************************************************
                                                       	               
       Borland Delphi Runtime Library                  		       
       QuickTime interface unit                                               
 									       
 Portions created by Apple Computer, Inc. are 				       
 Copyright (C) 1990-1999 Apple Computer, Inc.. 			       
 All Rights Reserved. 							       
 								               
 The original file is: QuickTimeComponents.h, released dd Mmm yyyy. 	       
 The original Pascal code is: qt_QuickTimeComponents.pas, released 13 Jan 2002
 The initial developer of the Pascal code is George Birbilis                  
 (birbilis@cti.gr).                     				       
 									       
 Portions created by George Birbilis are    				       
 Copyright (C) 2002 George Birbilis 					       
 									       
       Obtained through:                               		       
 									       
       Joint Endeavour of Delphi Innovators (Project JEDI)                    
									       
 You may retrieve the latest version of this file at the Project              
 JEDI home page, located at http://delphi-jedi.org                            
									       
 The contents of this file are used with permission, subject to               
 the Mozilla Public License Version 1.1 (the "License"); you may              
 not use this file except in compliance with the License. You may             
 obtain a copy of the License at                                              
 http://www.mozilla.org/MPL/MPL-1.1.html 	                               
 									       
 Software distributed under the License is distributed on an 	               
 "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or               
 implied. See the License for the specific language governing                 
 rights and limitations under the License. 				       

******************************************************************************)

//13Jan2002 - birbilis: first version
//21Jan2002 - birbilis: added SGSettingsDialog
//02Feb2002 - birbilis: fixed FCC constants
//17Aug2002 - birbilis: changed year from 2001 to 2002 in this history
//23Dec2009 - birbilis: added TimeCode support and using "external" in implementation section

unit qt_QuickTimeComponents;

(*
 	File:		QuickTimeComponents.h

 	Contains:	QuickTime interfaces

 	Version:	Technology:
 				Release:	QuickTime 4.1

 	Copyright:	(c) 1990-1999 by Apple Computer, Inc., all rights reserved

 	Bugs?:		For bug reports, consult the following page on
 				the World Wide Web:

 					http://developer.apple.com/bugreporter/

*)

interface
 uses
  qt_MacTypes,
  qt_Components,
  qt_QuickDraw,
  C_Types,
  qt_Events,
  qt_Files,
  qt_Movies;

 const
  clockComponentType=(((ord('c') shl 8 +ord('l'))shl 8 +ord('o'))shl 8 +ord('k')); {'clok'}
  systemTickClock=(((ord('t') shl 8 +ord('i'))shl 8 +ord('c'))shl 8 +ord('k')); {'tick'} //subtype: 60ths since boot
  systemSecondClock=(((ord('s') shl 8 +ord('e'))shl 8 +ord('c'))shl 8 +ord('o')); {'seco'} //subtype: seconds since 1904
  systemMillisecondClock=(((ord('m') shl 8 +ord('i'))shl 8 +ord('l'))shl 8 +ord('l')); {'mill'} //subtype: 1000ths since boot
  systemMicrosecondClock=(((ord('m') shl 8 +ord('i'))shl 8 +ord('c'))shl 8 +ord('r')); {'micr'} //subtype: 1000000ths since boot

 const
  kClockRateIsLinear               = 1;
  kClockImplementsCallBacks	       = 2;
  kClockCanHandleIntermittentSound = 4; //sound clocks only

//...


 const
  TCSourceRefNameType=(((ord('n') shl 8 +ord('a'))shl 8 +ord('m'))shl 8 +ord('e')); {'name'}

 const
  tcDropFrame   = 1 {shl 0};
  tc24HourMax   = 1 shl 1;
  tcNegTimesOK  = 1 shl 2;
  tcCounter     = 1 shl 3;

 type
  TimeCodeDef = packed record
   flags:long;               (* Flags that provide timecode format information, such as drop-frame, etc.*)
   fTimeScale:TimeScale;     (* Contains the time scale for interpreting the frameDuration field *)
                             (* This field indicates the number of time units per second (eg. 2997) *)
   frameDuration:TimeValue;  (* Specifies how long each frame lasts, in the units defined by the *)
                             (* fTimeScale field (eg. 100) *)
   numFrames:UInt8;          (* Indicates the number of frames stored per second (eg. 30) OR In the case *)
                             (* of timecodes that are interpreted as counters, this field indicates the *)
                             (* number of frames stored per timer "tick" *)
   padding:UInt8;            (* unused padding *)
   end;

 const
  tctNegFlag = $80; (* negative bit is in minutes *)

 type

  TimeCodeTime = packed record
   hours:UInt8;
   minutes:UInt8;
   seconds:UInt8;
   frames:UInt8;
   end;

  TimeCodeCounter = packed record
   counter:long;
  end;

  TimeCodeRecord = packed record
   case integer of //C's union
    0: (t:TimeCodeTime);
    1: (c:TimeCodeCounter);
  end;

  (* 64-bit counter *) //see "http://developer.apple.com/mac/library/technotes/tn2007/tn2198.html"
  TimeCode64Counter = SInt64;

  TimeCodeDescription = packed record
    descSize:long;               (* standard sample description header *)
    dataFormat:long;             (* Indicates the sample description type *)
    resvd1:long;                 (* Set to 0 *)
    resvd2:short;                (* Set to 0 *)
    dataRefIndex:short;          (* Contains an index value indicating which of the media's data references *)
                                 (* contains the sample data for this sample description *)
    flags:long;                  (* timecode specific stuff *)  (* Reserved, set to 0 *)
    timeCodeDef:TimeCodeDef;     (* Contains a timecode definition structure that defines timecode *)
                                 (* format information *)
    srcRef:array[0..0] of long;  (* Contains the timecode's source information. This is formatted as a user data *)
                                 (* item that is stored in the sample description. The media handler provides *)
                                 (* functions that allow you to get and set this data *)
  end;
  TimeCodeDescriptionPtr = ^TimeCodeDescription;
  TimeCodeDescriptionHandle = ^TimeCodeDescriptionPtr;

 const
  tcdfShowTimeCode = 1 {shl 0};

 type
  TCTextOptions = packed record
    txFont:short;
    txFace:short;
    txSize:short;
    pad:short;                        (* let's make it longword aligned - thanks.. *)
    foreColor:RGBColor;
    backColor:RGBColor;
  end;
  TCTextOptionsPtr = ^TCTextOptions;

 function TCGetCurrentTimeCode(mh:MediaHandler; var frameNum:long; var tcdef:TimeCodeDef; var tcrec:TimeCodeRecord; var srcRefH:UserData):HandlerError; cdecl;
 function TCGetTimeCodeAtTime(mh:MediaHandler; mediaTime:TimeValue; var frameNum:long; var tcdef:TimeCodeDef; var tcdata:TimeCodeRecord; var srcRefH:UserData):HandlerError; cdecl;
 function TCTimeCodeToString(mh:MediaHandler; var tcdef:TimeCodeDef; var tcrec:TimeCodeRecord; tcStr:StringPtr):HandlerError; cdecl;
 function TCTimeCodeToFrameNumber(mh:MediaHandler; var tcdef:TimeCodeDef; var tcrec:TimeCodeRecord; var frameNumber:long):HandlerError; cdecl;
 function TCFrameNumberToTimeCode(mh:MediaHandler; frameNumber:long; var tcdef:TimeCodeDef; var tcrec:TimeCodeRecord):HandlerError; cdecl;
 function TCGetSourceRef(mh:MediaHandler; tcdH:TimeCodeDescriptionHandle; var srefH:UserData):HandlerError; cdecl;
 function TCSetSourceRef(mh:MediaHandler; tcdH:TimeCodeDescriptionHandle; srefH:UserData):HandlerError; cdecl;
 function TCSetTimeCodeFlags(mh:MediaHandler; flags:long; flagsMask:long):HandlerError; cdecl;
 function TCGetTimeCodeFlags(mh:MediaHandler; var flags:long):HandlerError; cdecl;
 function TCSetDisplayOptions(mh:MediaHandler; textOptions:TCTextOptionsPtr):HandlerError; cdecl;
 function TCGetDisplayOptions(mh:MediaHandler; var textOptions:TCTextOptions):HandlerError; cdecl;

//...

(*
	General Sequence Grab stuff
*)

 type
  SeqGrabComponent=ComponentInstance;
  SGChannel=ComponentInstance;

 const
  SeqGrabComponentType=(((ord('b') shl 8 +ord('a'))shl 8 +ord('r'))shl 8 +ord('g')); {'barg'}
  SeqGrabChannelType=(((ord('s') shl 8 +ord('g'))shl 8 +ord('c'))shl 8 +ord('h')); {'sgch'}
  SeqGrabPanelType=(((ord('s') shl 8 +ord('g'))shl 8 +ord('p'))shl 8 +ord('n')); {'sgpn'}
  SeqGrabCompressionPanelType=(((ord('c') shl 8 +ord('m'))shl 8 +ord('p'))shl 8 +ord('r')); {'cmpr'}
  SeqGrabSourcePanelType=(((ord('s') shl 8 +ord('o'))shl 8 +ord('u'))shl 8 +ord('r')); {'sour'}

 type
  SGModalFilterProcPtr=function(theDialog:DialogPtr;theEvent:EventRecordPtr;
                                itemHit:ShortPtr;refCon:long):boolean;cdecl;
  SGModalFilterUPP={STACK_UPP_TYPE}SGModalFilterProcPtr;

 type
  NewSGModalFilterUPP=function(userRoutine:SGModalFilterProcPtr):SGModalFilterUPP;cdecl;
  NewSGModalFilterProc=NewSGModalFilterUPP;

const
 sgPanelFlagForPanel = 1;

const
 seqGrabSettingsPreviewOnly = 1;

const
 channelPlayNormal = 0;
 channelPlayFast = 1;
 channelPlayHighQuality = 2;
 channelPlayAllData = 4;

 function SGInitialize(s:SeqGrabComponent):ComponentResult; cdecl;
 function SGSetDataOutput(s:SeqGrabComponent; const movieFile:FSSpec; whereFlags:long):ComponentResult; cdecl;
 function SGGetDataOutput(s:SeqGrabComponent; var movieFile:FSSpec; var whereFlags:long):ComponentResult; cdecl;
 function SGSetGWorld(s:SeqGrabComponent; gp:CGrafPtr; gd:GDHandle):ComponentResult; cdecl;
 function SGGetGWorld(s:SeqGrabComponent; var gp:CGrafPtr; var gd:GDHandle):ComponentResult; cdecl;
 function SGNewChannel(s:SeqGrabComponent; channelType:OSType; var ref:SGChannel):ComponentResult; cdecl;
 function SGDisposeChannel(s:SeqGrabComponent; c:SGChannel):ComponentResult; cdecl;
 function SGStartPreview(s:SeqGrabComponent):ComponentResult; cdecl;
 function SGStartRecord(s:SeqGrabComponent):ComponentResult; cdecl;
 function SGIdle(s:SeqGrabComponent):ComponentResult; cdecl;
 function SGStop(s:SeqGrabComponent):ComponentResult; cdecl;
 function SGPause(s:SeqGrabComponent; pause:Byte):ComponentResult; cdecl;
 function SGPrepare(s:SeqGrabComponent; prepareForPreview:Boolean; prepareForRecord:Boolean):ComponentResult; cdecl;
 function SGRelease(s:SeqGrabComponent):ComponentResult; cdecl;
 function SGGetMovie(s:SeqGrabComponent):Movie; cdecl;
 function SGSetMaximumRecordTime(s:SeqGrabComponent; ticks:unsigned_longPtr):ComponentResult; cdecl;
 function SGGetMaximumRecordTime(s:SeqGrabComponent; ticks:unsigned_longPtr):ComponentResult; cdecl;
 function SGGetStorageSpaceRemaining(s:SeqGrabComponent; bytes:unsigned_longPtr):ComponentResult; cdecl;
 function SGGetTimeRemaining(s:SeqGrabComponent; var ticksLeft:long):ComponentResult; cdecl;
 function SGGrabPict(s:SeqGrabComponent; var p:PicHandle; const bounds:Rect; offscreenDepth:short; grabPictFlags:long):ComponentResult; cdecl;
 function SGGetLastMovieResID(s:SeqGrabComponent; var resID:short):ComponentResult; cdecl;
 function SGSetFlags(s:SeqGrabComponent; sgFlags:long):ComponentResult; cdecl;
 function SGGetFlags(s:SeqGrabComponent; var sgFlags:long):ComponentResult; cdecl;
 //function SGSetDataProc(s:SeqGrabComponent; proc:SGDataUPP; refCon:long):ComponentResult; cdecl;
 function SGNewChannelFromComponent(s:SeqGrabComponent; var newChannel:SGChannel; sgChannelComponent:Component):ComponentResult; cdecl;
 //function SGDisposeDeviceList(s:SeqGrabComponent; list:SGDeviceList):ComponentResult; cdecl;
 //function SGAppendDeviceListToMenu(s:SeqGrabComponent; list:SGDeviceList; mh:MenuHandle):ComponentResult; cdecl;
 function SGSetSettings(s:SeqGrabComponent; ud:UserData; flags:long):ComponentResult; cdecl;
 function SGGetSettings(s:SeqGrabComponent; var ud:UserData; flags:long):ComponentResult; cdecl;
 function SGGetIndChannel(s:SeqGrabComponent; index:short; var ref:SGChannel; var chanType:OSType):ComponentResult; cdecl;
 function SGUpdate(s:SeqGrabComponent; updateRgn:RgnHandle):ComponentResult; cdecl;
 function SGGetPause(s:SeqGrabComponent; var paused:Byte):ComponentResult; cdecl;

 type
  ConstComponentListPtr={const}^Component;

 function SGSettingsDialog(s:SeqGrabComponent; c:SGChannel; numPanels:short; panelList:ConstComponentListPtr; flags:long; proc:SGModalFilterUPP; procRefNum:long):ComponentResult; cdecl;

implementation

 function TCGetCurrentTimeCode(mh:MediaHandler; var frameNum:long; var tcdef:TimeCodeDef; var tcrec:TimeCodeRecord; var srcRefH:UserData):HandlerError; cdecl; external 'qtmlClient.dll';
 function TCGetTimeCodeAtTime(mh:MediaHandler; mediaTime:TimeValue; var frameNum:long; var tcdef:TimeCodeDef; var tcdata:TimeCodeRecord; var srcRefH:UserData):HandlerError; cdecl; external 'qtmlClient.dll';
 function TCTimeCodeToString(mh:MediaHandler; var tcdef:TimeCodeDef; var tcrec:TimeCodeRecord; tcStr:StringPtr):HandlerError; cdecl; external 'qtmlClient.dll';
 function TCTimeCodeToFrameNumber(mh:MediaHandler; var tcdef:TimeCodeDef; var tcrec:TimeCodeRecord; var frameNumber:long):HandlerError; cdecl; external 'qtmlClient.dll';
 function TCFrameNumberToTimeCode(mh:MediaHandler; frameNumber:long; var tcdef:TimeCodeDef; var tcrec:TimeCodeRecord):HandlerError; cdecl; external 'qtmlClient.dll';
 function TCGetSourceRef(mh:MediaHandler; tcdH:TimeCodeDescriptionHandle; var srefH:UserData):HandlerError; cdecl; external 'qtmlClient.dll';
 function TCSetSourceRef(mh:MediaHandler; tcdH:TimeCodeDescriptionHandle; srefH:UserData):HandlerError; cdecl; external 'qtmlClient.dll';
 function TCSetTimeCodeFlags(mh:MediaHandler; flags:long; flagsMask:long):HandlerError; cdecl; external 'qtmlClient.dll';
 function TCGetTimeCodeFlags(mh:MediaHandler; var flags:long):HandlerError; cdecl; external 'qtmlClient.dll';
 function TCSetDisplayOptions(mh:MediaHandler; textOptions:TCTextOptionsPtr):HandlerError; cdecl; external 'qtmlClient.dll';
 function TCGetDisplayOptions(mh:MediaHandler; var textOptions:TCTextOptions):HandlerError; cdecl; external 'qtmlClient.dll';

 function SGInitialize(s:SeqGrabComponent):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGSetDataOutput(s:SeqGrabComponent; const movieFile:FSSpec; whereFlags:long):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGGetDataOutput(s:SeqGrabComponent; var movieFile:FSSpec; var whereFlags:long):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGSetGWorld(s:SeqGrabComponent; gp:CGrafPtr; gd:GDHandle):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGGetGWorld(s:SeqGrabComponent; var gp:CGrafPtr; var gd:GDHandle):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGNewChannel(s:SeqGrabComponent; channelType:OSType; var ref:SGChannel):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGDisposeChannel(s:SeqGrabComponent; c:SGChannel):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGStartPreview(s:SeqGrabComponent):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGStartRecord(s:SeqGrabComponent):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGIdle(s:SeqGrabComponent):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGStop(s:SeqGrabComponent):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGPause(s:SeqGrabComponent; pause:Byte):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGPrepare(s:SeqGrabComponent; prepareForPreview:Boolean; prepareForRecord:Boolean):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGRelease(s:SeqGrabComponent):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGGetMovie(s:SeqGrabComponent):Movie; cdecl; external 'qtmlClient.dll';
 function SGSetMaximumRecordTime(s:SeqGrabComponent; ticks:unsigned_longPtr):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGGetMaximumRecordTime(s:SeqGrabComponent; ticks:unsigned_longPtr):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGGetStorageSpaceRemaining(s:SeqGrabComponent; bytes:unsigned_longPtr):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGGetTimeRemaining(s:SeqGrabComponent; var ticksLeft:long):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGGrabPict(s:SeqGrabComponent; var p:PicHandle; const bounds:Rect; offscreenDepth:short; grabPictFlags:long):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGGetLastMovieResID(s:SeqGrabComponent; var resID:short):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGSetFlags(s:SeqGrabComponent; sgFlags:long):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGGetFlags(s:SeqGrabComponent; var sgFlags:long):ComponentResult; cdecl; external 'qtmlClient.dll';
 //function SGSetDataProc(s:SeqGrabComponent; proc:SGDataUPP; refCon:long):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGNewChannelFromComponent(s:SeqGrabComponent; var newChannel:SGChannel; sgChannelComponent:Component):ComponentResult; cdecl; external 'qtmlClient.dll';
 //function SGDisposeDeviceList(s:SeqGrabComponent; list:SGDeviceList):ComponentResult; cdecl; external 'qtmlClient.dll';
 //function SGAppendDeviceListToMenu(s:SeqGrabComponent; list:SGDeviceList; mh:MenuHandle):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGSetSettings(s:SeqGrabComponent; ud:UserData; flags:long):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGGetSettings(s:SeqGrabComponent; var ud:UserData; flags:long):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGGetIndChannel(s:SeqGrabComponent; index:short; var ref:SGChannel; var chanType:OSType):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGUpdate(s:SeqGrabComponent; updateRgn:RgnHandle):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGGetPause(s:SeqGrabComponent; var paused:Byte):ComponentResult; cdecl; external 'qtmlClient.dll';
 function SGSettingsDialog(s:SeqGrabComponent; c:SGChannel; numPanels:short; panelList:ConstComponentListPtr; flags:long; proc:SGModalFilterUPP; procRefNum:long):ComponentResult; cdecl; external 'qtmlClient.dll';

end.
