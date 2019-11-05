{************************************************************************}
{                                                       	             }
{       Borland Delphi Runtime Library                  		       }
{       QuickTime interface unit                                         }
{ 									                   }
{ Portions created by Apple Computer, Inc. are 					 }
{ Copyright (C) 1997-1998 Apple Computer, Inc.. 			       }
{ All Rights Reserved. 							             }
{ 								                   	 }
{ The original file is: QuickDraw.h, released dd Mmm yyyy. 		       }
{ The original Pascal code is: qt_QuickDraw.pas, released 14 May 2000. 	 }
{ The initial developer of the Pascal code is George Birbilis            }
{ (birbilis@cti.gr).                     				             }
{ 									                   }
{ Portions created by George Birbilis are    				       }
{ Copyright (C) 1998-2003 George Birbilis 					 }
{ 									                   }
{       Obtained through:                               		       }
{ 									                   }
{       Joint Endeavour of Delphi Innovators (Project JEDI)              }
{									                   }
{ You may retrieve the latest version of this file at the Project        }
{ JEDI home page, located at http://delphi-jedi.org                      }
{									                   }
{ The contents of this file are used with permission, subject to         }
{ the Mozilla Public License Version 1.1 (the "License"); you may        }
{ not use this file except in compliance with the License. You may       }
{ obtain a copy of the License at                                        }
{ http://www.mozilla.org/MPL/MPL-1.1.html 	                         }
{ 									                   }
{ Software distributed under the License is distributed on an 	       }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or         }
{ implied. See the License for the specific language governing           }
{ rights and limitations under the License. 				       }
{ 									                   }
{************************************************************************}

//30Jan1999 - birbilis: fixed getNativeWindowPort proc to accept a HWND instead of a pointer
//03Mar1999 - birbilis: added GetHWNDPort
//14May2000 - birbilis: donated to Delphi-JEDI
//05Jul2003 - birbilis: added "RGBColorPtr" and "RGBColorHdl" types

unit qt_QuickDraw;

interface
 uses C_Types,qt_MacTypes,Windows;

 //QuickDraw.h//
 type
  QDErr=short;

  RGBColor=packed record
   red:unsigned_short; (*magnitude of red component*)
   green:unsigned_short; (*magnitude of green component*)
   blue:unsigned_short; (*magnitude of blue component*)
   end;
  RGBColorPtr=^RGBColor;
  RGBColorHdl=^RGBColorPtr; //??? how come this isn't named RGBColorHandle in the QuickTime API?

  ColorSpec=packed record
   value:short; (*index or other value*)
   rgb:RGBColor; (*true color*)
   end;

  CSpecArray=array[0..0]of ColorSpec;

  ColorTable=packed record
   ctSeed:long; (*unique identifier for table*)
   ctFlags:short; (*high bit: 0 = PixMap; 1 = device*)
   ctSize:short; (*number of entries in CTTable*)
   ctTable:CSpecArray; (*array [0..0] of ColorSpec*)
   end;
  CTabPtr=^ColorTable;
  CTabHandle=^CTabPtr;

  PixMapExtension=packed record
   extSize:long;	(*size of struct, duh!*)
   pmBits:cardinal; (*pixmap attributes bitfield*)
   pmGD:pointer; (*this is a GDHandle*)
   pmSeed:long;
   reserved0:cardinal; (*reserved for future use*)
   reserved1:cardinal; (*reserved for future use*)
   reserved2:cardinal; (*reserved for future use*)
   end;
  PixMapExtPtr=^PixMapExtension;
  PixMapExtHandle=^PixMapExtPtr;

  PixMap=packed record
   baseAddr:Ptr; (*pointer to pixels*)
   rowBytes:short; (*offset to next line*)
   bounds:Rect; (*encloses bitmap*)
   pmVersion:short; (*pixMap version number*)
   packType:short; (*defines packing format*)
   packSize:long; (*length of pixel data*)
   hRes:Fixed; (*horiz. resolution (ppi)*)
   vRes:Fixed; (*vert. resolution (ppi)*)
   pixelType:short; (*defines pixel type*)
   pixelSize:short; (*# bits in pixel*)
   cmpCount:short; (*# components in pixel*)
   cmpSize:short; (*# bits per component*)
   {$ifdef OLDPIXMAPSTRUCT}
   planeBytes:long; (*offset to next plane*)
   pmTable:CTabHandle; (*color map for this pixMap*)
   pmReserved:long;
   {$else}
   pixelFormat:OSType; (*fourCharCode representation*)
   pmTable:	CTabHandle; (*color map for this pixMap*)
   pmExt:PixMapExtHandle; (*Handle to pixMap extension*)
   {$ENDIF}
   end;
  PixMapPtr=^PixMap;
  PixMapHandle=^PixMapPtr;

  MacRegion=packed record
   rgnSize:word; (*size in bytes*)
   rgnBBox:Rect; (*enclosing rectangle*)
   end;
  RgnPtr=^MacRegion;
  RgnHandle=^RgnPtr;

  Pattern=packed record
   pat:array[0..7] of UInt8;
   end;
  PixPat=packed record
   patType:short; (*type of pattern*)
   patMap:PixMapHandle; (*the pattern's pixMap*)
   patData:Handle; (*pixmap's data*)
   patXData:Handle; (*expanded Pattern data*)
   patXValid:short; (*flags whether expanded Pattern valid*)
   patXMap:Handle; (*Handle to expanded Pattern data*)
   pat1Data:Pattern; (*old-Style pattern/RGB color*)
   end;
  PixPatPtr=^PixPat;
  PixPatHandle=^PixPatPtr;

  //??????????????//
  QDTextUPP=pointer;
  QDLineUPP=pointer;
  QDRectUPP=pointer;
  QDRRectUPP=pointer;
  QDOvalUPP=pointer;
  QDArcUPP=pointer;
  QDPolyUPP=pointer;
  QDRgnUPP=pointer;
  QDBitsUPP=pointer;
  QDCommentUPP=pointer;
  QDTxMeasUPP=pointer;
  QDGetPicUPP=pointer;
  QDPutPicUPP=pointer;
  QDOpcodeUPP=pointer;
  QDStdGlyphsUPP=pointer;
  //////////////////

  QDProcs=packed record
   textProc:QDTextUPP;
   lineProc:QDLineUPP;
   rectProc:QDRectUPP;
   rRectProc:QDRRectUPP;
   ovalProc:QDOvalUPP;
   arcProc:QDArcUPP;
   polyProc:QDPolyUPP;
   rgnProc:QDRgnUPP;
   bitsProc:QDBitsUPP;
   commentProc:QDCommentUPP;
   txMeasProc:QDTxMeasUPP;
   getPicProc:QDGetPicUPP;
   putPicProc:QDPutPicUPP;
   end;
  QDProcsPtr=^QDProcs;

  CQDProcs=packed record
   textProc:QDTextUPP;
   lineProc:QDLineUPP;
   rectProc:QDRectUPP;
   rRectProc:QDRRectUPP;
   ovalProc:QDOvalUPP;
   arcProc:QDArcUPP;
   polyProc:QDPolyUPP;
   rgnProc:QDRgnUPP;
   bitsProc:QDBitsUPP;
   commentProc:QDCommentUPP;
   txMeasProc:QDTxMeasUPP;
   getPicProc:QDGetPicUPP;
   putPicProc:QDPutPicUPP;
   opcodeProc:QDOpcodeUPP;
   newProc1:UniversalProcPtr; (* this is the StdPix bottleneck -- see ImageCompression.h *)
   glyphsProc:QDStdGlyphsUPP; (* was newProc2; now used in Unicode text drawing *)
   newProc3:UniversalProcPtr;
   newProc4:UniversalProcPtr;
   newProc5:UniversalProcPtr;
   newProc6:UniversalProcPtr;
   end;
  CQDProcsPtr=pointer{^CQDProcs};

  CGrafPort=packed record
   device:short;
   portPixMap:PixMapHandle; (*port's pixel map*)
   portVersion:short; (*high 2 bits always set*)
   grafVars:Handle; (*Handle to more fields*)
   chExtra:short; (*character extra*)
   pnLocHFrac:short; (*pen fraction*)
   portRect:Rect;
   visRgn:RgnHandle;
   clipRgn:RgnHandle;
   bkPixPat:PixPatHandle; (*background pattern*)
   rgbFgColor:RGBColor; (*RGB components of fg*)
   rgbBkColor:RGBColor; (*RGB components of bk*)
   pnLoc:Point;
   pnSize:Point;
   pnMode:short;
   pnPixPat:PixPatHandle; (*pen's pattern*)
   fillPixPat:PixPatHandle; (*fill pattern*)
   pnVis:short;
   txFont:short;
   txFace:StyleField; (*StyleField occupies 16-bits, but only first 8-bits are used*)
   txMode:short;
   txSize:short;
   spExtra:Fixed;
   fgColor:long;
   bkColor:long;
   colrBit:short;
   patStretch:short;
   picSave:Handle;
   rgnSave:Handle;
   polySave:Handle;
   grafProcs:CQDProcsPtr;
   end;
  CGrafPtr=^CGrafPort;
  CWindowPtr=CGrafPtr;

  BitMap=packed record
  baseAddr:Ptr;
  rowBytes:short;
  bounds:Rect;
  end;
  BitMapPtr=^BitMap;
  BitMapHandle=^BitMapPtr;

  GrafPort=packed record
   device:short;
   portBits:BitMap;
   portRect:Rect;
   visRgn:RgnHandle;
   clipRgn:RgnHandle;
   bkPat:Pattern;
   fillPat:Pattern;
   pnLoc:Point;
   pnSize:Point;
   pnMode:short;
   pnPat:Pattern;
   pnVis:short;
   txFont:short;
   txFace:StyleField; (*StyleField occupies 16-bits, but only first 8-bits are used*)
   txMode:short;
   txSize:short;
   spExtra:Fixed;
   fgColor:long;
   bkColor:long;
   colrBit:short;
   patStretch:short;
   picSave:Handle;
   rgnSave:Handle;
   polySave:Handle;
   grafProcs:QDProcsPtr;
   end;
  GrafPtr=^GrafPort;
  WindowPtr=GrafPtr;
  DialogPtr=WindowPtr;
  WindowRef=WindowPtr;

  GDevice=packed record
   //...//
   end;
  GDPtr=pointer{^GDevice};
  GDHandle=^GDPtr;

  Picture=packed record
   picSize:short;
   picFrame:Rect;
   end;
  PicPtr=^Picture;
  PicHandle=^PicPtr;

 function GetNativeWindowPort(nativeWindow:HWND):GrafPtr; cdecl;
 function GetHWNDPort(theHWND:HWND):GrafPtr; //Delphi: C macro implemented as function

 procedure MacOffsetRect(var r:Rect;dh:short;dv:short); cdecl;
 procedure GetPort(var port:GrafPtr); cdecl;

 procedure ClosePicture; cdecl;
 procedure DrawPicture(myPicture:PicHandle;const dstRect:RectPtr); cdecl;
 procedure KillPicture(myPicture:PicHandle); cdecl;

{$IFDEF TARGET_OS_MAC}
 procedure SetPort(port:GrafPtr); cdecl;
{$ENDIF}
 procedure MacSetPort(port:GrafPtr); cdecl;

implementation

//#define GetPortHWND(port)  GetPortNativeWindow(port)

 function GetHWNDPort(theHWND:HWND):GrafPtr;
 begin
  result:=GetNativeWindowPort(theHWND);
 end;

 function GetNativeWindowPort; cdecl; external 'qtmlClient.dll';
 procedure MacOffsetRect; cdecl; external 'qtmlClient.dll';
 procedure GetPort; cdecl; external 'qtmlClient.dll';

 procedure ClosePicture; cdecl; external 'qtmlClient.dll';
 procedure DrawPicture; cdecl; external 'qtmlClient.dll';
 procedure KillPicture; cdecl; external 'qtmlClient.dll';

 procedure MacSetPort; cdecl; external 'qtmlClient.dll';

end.
