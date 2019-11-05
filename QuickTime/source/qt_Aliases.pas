(************************************************************************
*
*       Borland Delphi Runtime Library
*       QuickTime interface unit
*
* Portions created by Apple Computer, Inc. are
* Copyright:  (c) 1997-2001 by Apple Computer, Inc.
* All Rights Reserved.
*
* The original file is: Aliases.h, released 20 Apr 2001.
* The original Pascal code is: qt_Aliases.pas, released 15 May 2002.
* The initial developer of the Pascal code is George Birbilis
* (birbilis@cti.gr).
*
* Portions created by George Birbilis are
* Copyright (C) 1998-2005 George Birbilis
*
*       Obtained through:
*
*       Joint Endeavour of Delphi Innovators (Project JEDI)
*
* You may retrieve the latest version of this file at the Project
* JEDI home page, located at http://delphi-jedi.org
*
* The contents of this file are used with permission, subject to
* the Mozilla Public License Version 1.1 (the "License"); you may
* not use this file except in compliance with the License. You may
* obtain a copy of the License at
* http://www.mozilla.org/MPL/MPL-1.1.html
*
* Software distributed under the License is distributed on an
* "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
* implied. See the License for the specific language governing
* rights and limitations under the License.
*
************************************************************************)

(*
     File:       Aliases.h

     Contains:   Alias Manager Interfaces.

     Version:    Technology: Mac OS 8.1
                 Release:    QuickTime 5.0.1

     Copyright:  (c) 1989-2001 by Apple Computer, Inc., all rights reserved

     Bugs?:      For bug reports, consult the following page on
                 the World Wide Web:

                     http://developer.apple.com/bugreporter/

*)

(* HISTORY:
15Feb2002 - birbilis: first creation based on the QuickTime 5.0.1 SDK for Windows
27May2005 - birbilis: fixed "NewAlias" to be found at "qtmlClient.dll" instead of "qtmlCliend.dll"
*)

unit qt_Aliases;

interface
 uses
  qt_MacTypes,
  C_Types,
  qt_Files;

const
 rAliasType = (((ord('a') shl 8 +ord('l'))shl 8 +ord('i'))shl 8 +ord('s')) {alis}; { Aliases are stored as resources of this type }

 {  define alias resolution action rules mask  }
 kARMMountVol	    = $00000001; { mount the volume automatically }
 kARMNoUI	    = $00000002; { no user interface allowed during resolution }
 kARMMultVols	    = $00000008; { search on multiple volumes }
 kARMSearch	    = $00000100; { search quickly }
 kARMSearchMore	    = $00000200; { search further }
 kARMSearchRelFirst = $00000400; { search target on a relative path first }

																{  define alias record information types  }
 asiZoneName					= -3;							{  get zone name  }
 asiServerName				= -2;							{  get server name  }
 asiVolumeName				= -1;							{  get volume name  }
 asiAliasName				= 0;							{  get aliased file/folder/volume name  }
 asiParentName				= 1;							{  get parent folder name  }

 { ResolveAliasFileWithMountFlags options }
 kResolveAliasFileNoUI = $00000001; {  no user interaction during resolution }

 { define the alias record that will be the blackbox for the caller }

 type
  AliasRecordPtr = ^AliasRecord;
  AliasRecord=record
   userType:  OSType;									{  appl stored type like creator type  }
   aliasSize: UInt16;									{  alias record size in bytes, for appl usage  }
   end;

 AliasPtr = ^AliasRecord;
 AliasHandle = ^AliasPtr;
 {alias record information type}
 AliasInfoType = short;

 (* create a new alias between fromFile-target and return alias record handle *)
 function NewAlias(const fromFile:FSSpecPtr; const target:FSSpec; VAR alias: AliasHandle): OSErr; cdecl; external 'qtmlClient.dll';

 //...

implementation

end.
