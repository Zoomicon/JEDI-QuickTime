{************************************************************************}
{                                                       	         }
{       Borland Delphi Runtime Library                  		 }
{       QuickTime interface unit                                         }
{ 									 }
{ Portions created by Apple Computer, Inc. are 				 }
{ Copyright:  (c) 1997-2001 by Apple Computer, Inc.                      }
{ All Rights Reserved. 							 }
{                                                                        }
{ The original file is: QTML.h, released 20 Apr 2001. 		         }
{ The original Pascal code is: qt_QTML.pas, released 15 May 2002. 	 }
{ The initial developer of the Pascal code is George Birbilis            }
{ (birbilis@cti.gr).                     				 }
{ 									 }
{ Portions created by George Birbilis are    				 }
{ Copyright (C) 1998-2002 George Birbilis 				 }
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

(*
     File:       QTML.h

     Contains:   QuickTime Cross-platform specific interfaces

     Version:    Technology: QuickTime 4.1
                 Release:    QuickTime 5.0.1

     Copyright:  (c) 1997-2001 by Apple Computer, Inc., all rights reserved.

     Bugs?:      For bug reports, consult the following page on
                 the World Wide Web:

                     http://developer.apple.com/bugreporter/

*)

(* HISTORY:
14May2000 - birbilis: donated to Delphi-JEDI
15Feb2002 - birbilis: moved all "external" directives from "implementation"
            section to "interface" section
          - fixed CreatePortAssociation to return a GrafPtr, not a CGrafPtr (maybe qtml.h has a "bug" here, asked about it on the QT-API mailing list...)
          - translated the full "qtml.h" of QuickTime 5.0.1 (the latest public version of the QT SDK for Windows)
*)

unit qt_QTML;

interface
 uses C_Types,
      qt_MacTypes,
      qt_QuickDraw,
      qt_Events,
      qt_OSUtils, //for "QHdr"
      qt_Files, //for "FSSpec"
      qt_Aliases; //for "AliasHandle"

 procedure QTMLYieldCPU; cdecl; external 'qtmlClient.dll';
 procedure QTMLYieldCPUTime(milliSeconds:long;flags:unsigned_long); cdecl; external 'qtmlClient.dll';

 type
  OpaqueQTMLMutex=record end;
  QTMLMutex=^OpaqueQTMLMutex;
  OpaqueQTMLSyncVar=record end;
  QTMLSyncVar=^OpaqueQTMLSyncVar;
  QTMLSyncVarPtr=^QTMLSyncVar;

 const
  kInitializeQTMLNoSoundFlag	                = (1 shl 0); (* flag for requesting no sound when calling InitializeQTML *)
  kInitializeQTMLUseGDIFlag	                = (1 shl 1); (* flag for requesting GDI when calling InitializeQTML *)
  kInitializeQTMLDisableDirectSound             = (1 shl 2); (* disables QTML's use of DirectSound *)
  kInitializeQTMLUseExclusiveFullScreenModeFlag = (1 shl 3); (* later than QTML 3.0: qtml starts up in exclusive full screen mode *)
  kInitializeQTMLDisableDDClippers              = (1 shl 4); (* flag for requesting QTML not to use DirectDraw clipper objects; QTML 5.0 and later *)

 const
  kQTMLHandlePortEvents	= (1 shl 0); (* flag for requesting QTML to handle events *)
  kQTMLNoIdleEvents	= (1 shl 1); (* flag for requesting QTML not to send Idle Events *)

 function InitializeQTML(flag:long):OSErr; far; cdecl; external 'qtmlClient.dll';
 procedure TerminateQTML; cdecl; far; external 'qtmlClient.dll';

 //??? how come CreatePortAssociation be returning a GrafPtr and DestoyPortAssociation needing as input a CGrafPtr?
 function CreatePortAssociation(theWnd:pointer;storage:Ptr;flags:long):GrafPtr; cdecl; external 'qtmlClient.dll';
 procedure DestroyPortAssociation(cgp:CGrafPtr); cdecl; external 'qtmlClient.dll';

 procedure QTMLGrabMutex(mu:QTMLMutex); cdecl; external 'qtmlClient.dll';
 function QTMLTryGrabMutex(mu:QTMLMutex):Boolean; cdecl; external 'qtmlClient.dll';
 procedure QTMLReturnMutex(mu:QTMLMutex); cdecl; external 'qtmlClient.dll';
 function QTMLCreateMutex:QTMLMutex; cdecl; external 'qtmlClient.dll';
 procedure QTMLDestroyMutex(mu:QTMLMutex); cdecl; external 'qtmlClient.dll';

 function QTMLCreateSyncVar:QTMLSyncVarPtr; cdecl; external 'qtmlClient.dll';
 procedure QTMLDestroySyncVar(p:QTMLSyncVarPtr); cdecl; external 'qtmlClient.dll';
 function QTMLTestAndSetSyncVar(sync:QTMLSyncVarPtr):long; cdecl; external 'qtmlClient.dll';
 procedure QTMLWaitAndSetSyncVar(sync:QTMLSyncVarPtr); cdecl; external 'qtmlClient.dll';
 procedure QTMLResetSyncVar(sync:QTMLSyncVarPtr); cdecl; external 'qtmlClient.dll';
 procedure InitializeQHdr(var qhdr:QHdr); cdecl; external 'qtmlClient.dll';
 procedure TerminateQHdr(var qhdr:QHdr); cdecl; external 'qtmlClient.dll';
 procedure QTMLAcquireWindowList; cdecl; external 'qtmlClient.dll';
 procedure QTMLReleaseWindowList; cdecl; external 'qtmlClient.dll';

(*
   These routines are here to support "interrupt level" code
      These are dangerous routines, only use if you know what you are doing.
*)

 function QTMLRegisterInterruptSafeThread(threadID:unsigned_long;var threadInfo):long; cdecl; external 'qtmlClient.dll';
 function QTMLUnregisterInterruptSafeThread(threadID:unsigned_long):long; cdecl; external 'qtmlClient.dll';
 function NativeEventToMacEvent(var nativeEvent;var macEvent:EventRecord):long; cdecl; external 'qtmlClient.dll';
 const WinEventToMacEvent:function(var nativeEvent;var winMsg:EventRecord):long; cdecl = NativeEventToMacEvent;

 function IsTaskBarVisible:Boolean; cdecl; external 'qtmlClient.dll';
 procedure ShowHideTaskBar(showIt:Boolean); cdecl; external 'qtmlClient.dll';

 const
  kDDSurfaceLocked = (1 shl 0);
  kDDSurfaceStatic = (1 shl 1);

 function QTGetDDObject(var lpDDObject:pointer):OSErr; cdecl; external 'qtmlClient.dll';
 function QTSetDDObject(var lpNewDDObject):OSErr; cdecl; external 'qtmlClient.dll';
 function QTSetDDPrimarySurface(var lpNewDDSurface;flags:unsigned_long):OSErr; cdecl; external 'qtmlClient.dll';
 function QTMLGetVolumeRootPath(var fullPath:char;var volumeRootPath:char;volumeRootLen:unsigned_long):OSErr; cdecl; external 'qtmlClient.dll';
 procedure QTMLSetWindowWndProc(theWindow:WindowRef;windowProc:pointer); cdecl; external 'qtmlClient.dll';
 function QTMLGetWindowWndProc(theWindow:WindowRef):pointer; cdecl; external 'qtmlClient.dll';

 function QTMLGetCanonicalPathName(var inName:char;var outName:char;outLen:unsigned_long):OSErr; cdecl; external 'qtmlClient.dll';

 const
  kFullNativePath        = 0;
  kFileNameOnly          = (1 shl 0);
  kDirectoryPathOnly     = (1 shl 1);
  kUFSFullPathName       = (1 shl 2);
  kTryVDIMask            = (1 shl 3); (* Used in NativePathNameToFSSpec to specify to search VDI mountpoints *)
  kFullPathSpecifiedMask = (1 shl 4); (* the passed in name is a fully qualified full path *)

 function FSSpecToNativePathName(const inFile:FSSpec;var outName:char;outLen:unsigned_long;flags:long):OSErr; cdecl; external 'qtmlClient.dll';

 const
  kErrorIfFileNotFound = 1 shl 31;

 function NativePathNameToFSSpec(var inName:char;var outFile:FSSpec;flags:long):OSErr; cdecl; external 'qtmlClient.dll';
 function QTGetAliasInfo(alias:AliasHandle;index:AliasInfoType;var outBuf:char;bufLen:long;var outLen:long;flags:unsigned_long):OSErr; cdecl; external 'qtmlClient.dll';

implementation

end.
