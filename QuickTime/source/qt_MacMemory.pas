(************************************************************************

       Borland Delphi Runtime Library                  		       
       QuickTime interface unit                                         
 									                   
 Portions created by Apple Computer, Inc. are 					 
 Copyright (C) ????-1998 Apple Computer, Inc.. 			       
 All Rights Reserved. 							             
 								                   	 
 The original file is: MacMemory.h, released dd Mmm yyyy. 		       
 The original Pascal code is: qt_MacMemory.pas, released 14 May 2000. 	 
 The initial developer of the Pascal code is George Birbilis            
 (birbilis@cti.gr).                     				             
 									                   
 Portions created by George Birbilis are    				       
 Copyright (C) 1998-2009 George Birbilis 					 
 									                   
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

************************************************************************)

//10Feb1999 - birbilis: Last known change before donation to Delphi-JEDI
//14May2000 - birbilis: Donated to Delphi-JEDI
//18Jun2002 - birbilis: Ported more declarations
//16Jun2003 - birbilis: Ported "PtrToHand"
//          - birbilis: Fixed "BlockMove" and "BlockMoveData" to not use "var destPtr" but "destPtr:pointer" instead
//24Dec2009 - birbilis: Ported "HLock", "HUnlock", "HPurge", "HNoPurge", "HLockHi",
//                      "SetHandleSize", "MoveHHi", "GetPtrSize", "SetPtrSize", "HGetState" and "HSetState"
//          - birbilis: Moved external definition to implementation section

unit qt_MacMemory;

interface
 uses C_Types, qt_MacTypes;

 //note: EXTERN_API=cdecl on Win32

 function NewPtrClear(byteCount:Size):Ptr; cdecl;

 function NewHandle(byteCount:Size):Handle; cdecl;
 function NewHandleSys(byteCount:Size):Handle; cdecl;
 function NewHandleClear(byteCount:Size):Handle; cdecl;
 function NewHandleSysClear(byteCount:Size):Handle; cdecl;

 procedure HLock(h:Handle); cdecl;
 procedure HUnlock(h:Handle); cdecl;
 procedure HPurge(h:Handle); cdecl;
 procedure HNoPurge(h:Handle); cdecl;
 procedure HLockHi(h:Handle); cdecl;

 procedure MoveHHi(h:Handle); cdecl;
 procedure DisposePtr(p:Ptr); cdecl;
 function GetPtrSize(p:Ptr):Size; cdecl;
 procedure SetPtrSize(p:Ptr; newSize:Size); cdecl;
 procedure DisposeHandle(h:Handle); cdecl;

 procedure SetHandleSize(h:Handle; newSize:Size); cdecl;
 (*
    NOTE

    GetHandleSize and GetPtrSize are documented in Inside Mac as returning 0
    in case of an error, but the traps actually return an error code in D0.
    The glue sets D0 to 0 if an error occurred.
 *)
 function GetHandleSize(h:Handle):Size; cdecl;

 function HGetState(h:Handle):SInt8; cdecl;
 procedure HSetState(h:Handle; flags: SInt8); cdecl;

 procedure BlockMove(const srcPtr:pointer;destPtr:pointer;byteCount:Size); cdecl;
 procedure BlockMoveData(const srcPtr:pointer;destPtr:pointer;byteCount:Size); cdecl;

 function MemError:OSErr; cdecl;

 function PtrToHand(const srcPtr:pointer;var dstHndl:Handle; size:long):OSErr; cdecl;

implementation

 function NewPtrClear(byteCount:Size):Ptr; cdecl; external 'qtmlClient.dll';

 function NewHandle(byteCount:Size):Handle; cdecl; external 'qtmlClient.dll';
 function NewHandleSys(byteCount:Size):Handle; cdecl; external 'qtmlClient.dll';
 function NewHandleClear(byteCount:Size):Handle; cdecl; external 'qtmlClient.dll';
 function NewHandleSysClear(byteCount:Size):Handle; cdecl; external 'qtmlClient.dll';

 procedure HLock(h:Handle); cdecl; external 'qtmlClient.dll';
 procedure HUnlock(h:Handle); cdecl; external 'qtmlClient.dll';
 procedure HPurge(h:Handle); cdecl; external 'qtmlClient.dll';
 procedure HNoPurge(h:Handle); cdecl; external 'qtmlClient.dll';
 procedure HLockHi(h:Handle); cdecl; external 'qtmlClient.dll';

 procedure MoveHHi(h:Handle); cdecl; external 'qtmlClient.dll';
 procedure DisposePtr(p:Ptr); cdecl; external 'qtmlClient.dll';
 function GetPtrSize(p:Ptr):Size; cdecl; external 'qtmlClient.dll';
 procedure SetPtrSize(p:Ptr; newSize:Size); cdecl; external 'qtmlClient.dll';
 procedure DisposeHandle(h:Handle); cdecl; external 'qtmlClient.dll';

 procedure SetHandleSize(h:Handle; newSize:Size); cdecl; external 'qtmlClient.dll';
 function GetHandleSize(h:Handle):Size; cdecl; external 'qtmlClient.dll';

 function HGetState(h:Handle):SInt8; cdecl; external 'qtmlClient.dll';
 procedure HSetState(h:Handle; flags: SInt8); cdecl; external 'qtmlClient.dll';

 procedure BlockMove(const srcPtr:pointer;destPtr:pointer;byteCount:Size); cdecl; external 'qtmlClient.dll';
 procedure BlockMoveData(const srcPtr:pointer;destPtr:pointer;byteCount:Size); cdecl; external 'qtmlClient.dll';

 function MemError:OSErr; cdecl; external 'qtmlClient.dll';

 function PtrToHand(const srcPtr:pointer;var dstHndl:Handle; size:long):OSErr; cdecl; external 'qtmlClient.dll';

end.
