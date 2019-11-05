{************************************************************************}
{                                                       	         }
{       Borland Delphi Runtime Library                  		 }
{       QuickTime interface unit                                         }
{ 									 }
{ Portions created by Apple Computer, Inc. are 				 }
{ Copyright (C) 1990-2001 Apple Computer, Inc.. 			 }
{ All Rights Reserved. 							 }
{ 								         }
{ The original file is: Finder.h, released dd Mmm yyyy. 		 }
{ The original Pascal code is: qt_Finder.pas, released 23 May 2002. 	 }
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

//23May2002 - birbilis: first version based on QT5.0.1 SDK

(*
     File:       Finder.h

     Contains:   Finder flags and container types.

     Version:    Technology: Mac OS 8.5
                 Release:    QuickTime 5.0.1

     Copyright:  (c) 1990-2001 by Apple Computer, Inc., all rights reserved

     Bugs?:      For bug reports, consult the following page on
                 the World Wide Web:

                     http://developer.apple.com/bugreporter/

*)

unit qt_Finder;

interface
 uses qt_MacTypes;

(*------------------------------------------------------------------------*)
(*
   The following data structures are here for compatibility.
   Use the new data structures replacing them if possible (i.e. FileInfo
   instead of FInfo, etc...)
*)
(*------------------------------------------------------------------------*)
(* File info *)
(*
     IMPORTANT:
     In MacOS 8, the fdFldr field has become reserved for the Finder.
*)

 type
  FInfo=record
   fdType:OSType; (* The type of the file *)
   fdCreator:OSType; (* The file's creator *)
   fdFlags:UInt16; (* Flags ex. kHasBundle, kIsInvisible, etc. *)
   fdLocation:Point; (* File's location in folder. *)
                     (* If set to {0, 0}, the Finder will place the item automatically *)
   fdFldr:SInt16; (* Reserved (set to 0) *)
   end;

(* Extended file info *)
(*
     IMPORTANT:
     In MacOS 8, the fdIconID and fdComment fields were changed
     to become reserved fields for the Finder.
     The fdScript has become an extended flag.
*)

 type
  FXInfo=record
   fdIconID:SInt16; (* Reserved (set to 0) *)
   fdReserved:array[0..2] of SInt16; (* Reserved (set to 0) *)
   fdScript:SInt8; (* Extended flags. Script code if high-bit is set *)
   fdXFlags:SInt8; (* Extended flags *)
   fdComment:SInt16; (* Reserved (set to 0). Comment ID if high-bit is clear *)
   fdPutAway:SInt32; (* Put away folder ID *)
   end;

(* Folder info *)
(*
     IMPORTANT:
     In MacOS 8, the frView field was changed to become reserved
     field for the Finder.
*)

 type
  DInfo=record
   frRect:Rect; (* Folder's window bounds *)
   frFlags:UInt16; (* Flags ex. kIsInvisible, kNameLocked, etc.*)
   frLocation:Point; (* Folder's location in parent folder *)
                     (* If set to {0, 0}, the Finder will place the item automatically *)
   frView:SInt16; (* Reserved (set to 0) *)
   end;

(* Extended folder info *)
(*
     IMPORTANT:
     In MacOS 8, the frOpenChain and frComment fields were changed
     to become reserved fields for the Finder.
     The frScript has become an extended flag.
*)

 type
  DXInfo=record
   frScroll:Point; (* Scroll position *)
   frOpenChain:SInt32; (* Reserved (set to 0) *)
   frScript:SInt8; (* Extended flags. Script code if high-bit is set *)
   frXFlags:SInt8; (* Extended flags *)
   frComment:SInt16; (* Reserved (set to 0). Comment ID if high-bit is clear *)
   frPutAway:SInt32; (* Put away folder ID *)
   end;

implementation

end.

