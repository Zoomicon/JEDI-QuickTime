{************************************************************************}
{                                                       	         }
{       Borland Delphi Runtime Library                  		 }
{       QuickTime interface unit                                         }
{ 									 }
{ Portions created by Apple Computer, Inc. are 				 }
{ Copyright (C) 1985-1998 Apple Computer, Inc.. 			 }
{ All Rights Reserved. 							 }
{ 								         }
{ The original file is: QDOffscreen.h, released dd Mmm yyyy. 		 }
{ The original Pascal code is: qt_QDOffscreen.pas, released 14 May 2000. }
{ The initial developer of the Pascal code is George Birbilis            }
{ (birbilis@cti.gr).                     				 }
{ 									 }
{ Portions created by George Birbilis are    				 }
{ Copyright (C) 1998-2000 George Birbilis 				 }
{ 									 }
{       Obtained through:                               		 }
{ 									 }
{       Joint Endeavour of Delphi Innovators (Project JEDI)              }
{									 }
{ You may retrieve the latest version of this file at the Project        }
{ JEDI home page, located at http://delphi-jedi.org                      }
{									 }
{ The contents of this file are used with permission, subject to         }
{ the Mozilla Public License Version 1.1 (the "License"); you may        }
{ not use this file except in compliance with the License. You may       }
{ obtain a copy of the License at                                        }
{ http://www.mozilla.org/MPL/MPL-1.1.html 	                         }
{ 									 }
{ Software distributed under the License is distributed on an 	         }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or         }
{ implied. See the License for the specific language governing           }
{ rights and limitations under the License. 				 }
{ 									 }
{************************************************************************}

(* HISTORY:
03Mar1999 - birbilis: COMPLETED
14May2000 - birbilis: donated to Delphi-JEDI
21Jan2002 - birbilis: renamed from "qt_ODOffscreen" to "qt_QDOffscreen"
          - birbilis: stripped off implementation part, moved all "external" directives to the "interface" section
*)

unit qt_QDOffscreen;

interface
 uses qt_QuickDraw,qt_MacTypes,C_Types;

(*
 	File:		QDOffscreen.h

 	Contains:	Quickdraw Offscreen GWorld Interfaces.

 	Version:	Technology:	Mac OS 8
 				Release:	QuickTime 3.0

 	Copyright:	© 1985-1998 by Apple Computer, Inc., all rights reserved

 	Bugs?:		Please include the the file and version information (from above) with
 				the problem description.  Developers belonging to one of the Apple
 				developer programs can submit bug reports to:

 					devsupport@apple.com

*)

 const //Delphi: C unnamed enum, made constants
	pixPurgeBit				= 0;
	noNewDeviceBit				= 1;
	useTempMemBit				= 2;
	keepLocalBit				= 3;
	pixelsPurgeableBit			= 6;
	pixelsLockedBit				= 7;
	mapPixBit					= 16;
	newDepthBit					= 17;
	alignPixBit					= 18;
	newRowBytesBit				= 19;
	reallocPixBit				= 20;
	clipPixBit					= 28;
	stretchPixBit				= 29;
	ditherPixBit				= 30;
	gwFlagErrBit				= 31;



 const //Delphi: C unnamed enum, made constants
	pixPurge					= long(1) shl pixPurgeBit;
	noNewDevice					= long(1) shl noNewDeviceBit;
	useTempMem					= long(1) shl useTempMemBit;
	keepLocal					= long(1) shl keepLocalBit;
	pixelsPurgeable				= long(1) shl pixelsPurgeableBit;
	pixelsLocked				= long(1) shl pixelsLockedBit;
	kAllocDirectDrawSurface		= long(1) shl 14;
	mapPix						= long(1) shl mapPixBit;
	newDepth					= long(1) shl newDepthBit;
	alignPix					= long(1) shl alignPixBit;
	newRowBytes					= long(1) shl newRowBytesBit;
	reallocPix					= long(1) shl reallocPixBit;
	clipPix						= long(1) shl clipPixBit;
	stretchPix					= long(1) shl stretchPixBit;
	ditherPix					= long(1) shl ditherPixBit;
	gwFlagErr					= long(1) shl gwFlagErrBit;

 type GWorldFlags=unsigned_long;

 (* Type definition of a GWorldPtr *)
 type GWorldPtr=CGrafPtr;

function NewGWorld(offscreenGWorld:GWorldPtr;PixelDepth:short;const boundsRect:Rect;cTable:CTabHandle;aGDevice:GDHandle;flags:GWorldFlags):QDErr; cdecl; external 'qtmlClient.dll';

{$ifndef TARGET_OS_MAC}
(* Quicktime 3.0 *)
{$ifdef TARGET_OS_WIN32}
(* gdevice attribute bits*)

 const //Delphi: C unnamed enum, made constants
 	deviceIsIndirect			= (long(1) shl 0);
	deviceNeedsLock				= (long(1) shl 1);
	deviceIsStatic				= (long(1) shl 2);
	deviceIsExternalBuffer		= (long(1) shl 3);
	deviceIsDDSurface			= (long(1) shl 4);
	deviceIsDCISurface			= (long(1) shl 5);
	deviceIsGDISurface			= (long(1) shl 6);
	deviceIsAScreen				= (long(1) shl 7);
	deviceIsOverlaySurface		= (long(1) shl 8);

 function GetGDeviceSurface(gdh:GDHandle):void ; cdecl; external 'qtmlClient.dll';
 function GetGDeviceAttributes(gdh:GDHandle):unsigned long; cdecl; external 'qtmlClient.dll';

(* to allocate non-mac-rgb GWorlds use QTNewGWorld (ImageCompression.h) *)

 function NewGWorldFromHBITMAP(offscreenGWorld:GWorldPtr;cTable:CTabHandle;aGDevice:GDHandle;flags:GWorldFlags;newHBITMAP:void;newHDC:void):QDErr; cdecl; external 'qtmlClient.dll';

{$endif} (* TARGET_OS_WIN32 *)

function NewGWorldFromPtr(offscreenGWorld:GWorldPtr;PixelFormat:unsigned_long;const boundsRect:Rect;cTable:CTabHandle;aGDevice:GDHandle;flags:GWorldFlags;newBuffer:Ptr;rowBytes:long):QDErr; cdecl; external 'qtmlClient.dll';
{$endif}  (* not TARGET_OS_MAC *)

 function LockPixels(pm:PixMapHandle):Boolean; cdecl; external 'qtmlClient.dll';
 procedure UnlockPixels(pm:PixMapHandle); cdecl; external 'qtmlClient.dll';
 function UpdateGWorld(var offscreenGWorld:GWorldPtr;pixelDepth:short;const boundsRect:Rect;cTable:CTabHandle;aGDevice:GDHandle;flags:GWorldFlags):GWorldFlags; cdecl; external 'qtmlClient.dll';
 procedure DisposeGWorld(offscreenGWorld:GWorldPtr); cdecl; external 'qtmlClient.dll';
 procedure GetGWorld(var port:CGrafPtr;var gdh:GDHandle); cdecl; external 'qtmlClient.dll';
 procedure SetGWorld(port:CGrafPtr;gdh:GDHandle); cdecl; external 'qtmlClient.dll';
 procedure CTabChanged(ctab:CTabHandle); cdecl; external 'qtmlClient.dll';
 procedure PixPatChanged(ppat:PixPatHandle); cdecl; external 'qtmlClient.dll';
 procedure PortChanged(port:GrafPtr); cdecl; external 'qtmlClient.dll';
 procedure GDeviceChanged(gdh:GDHandle); cdecl; external 'qtmlClient.dll';
 procedure AllowPurgePixels(pm:PixMapHandle); cdecl; external 'qtmlClient.dll';
 procedure NoPurgePixels(pm:PixMapHandle); cdecl; external 'qtmlClient.dll';
 function GetPixelsState(pm:PixMapHandle):GWorldFlags; cdecl; external 'qtmlClient.dll';
 procedure SetPixelsState(pm:PixMapHandle;state:GWorldFlags); cdecl; external 'qtmlClient.dll';
 function GetPixBaseAddr(pm:PixMapHandle):Ptr; cdecl; external 'qtmlClient.dll';
 function NewScreenBuffer(const globalRect:Rect;purgeable:Boolean;gdh:GDHandle;var offscreenPixMap:PixMapHandle):QDErr; cdecl; external 'qtmlClient.dll';
 procedure DisposeScreenBuffer(offscreenPixMap:PixMapHandle); cdecl; external 'qtmlClient.dll';
 function GetGWorldDevice(offscreenGWorld:GWorldPtr):GDHandle; cdecl; external 'qtmlClient.dll';
 function QDDone(port:GrafPtr):Boolean; cdecl; external 'qtmlClient.dll';
 function OffscreenVersion:long; cdecl; external 'qtmlClient.dll';
 function NewTempScreenBuffer(const globalRect:Rect;purgeable:Boolean;gdh:GDHandle;offscreenPixMap:PixMapHandle):QDErr; cdecl; external 'qtmlClient.dll';
 function PixMap32Bit(pmHandle:PixMapHandle):Boolean; cdecl; external 'qtmlClient.dll';
 function GetGWorldPixMap(offscreenGWorld:GWorldPtr):PixMapHandle; cdecl; external 'qtmlClient.dll';

implementation

end.
