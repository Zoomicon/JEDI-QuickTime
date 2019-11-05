{************************************************************************}
{                                                       	         }
{       Borland Delphi Runtime Library                  		 }
{       QuickTime interface unit                                         }
{ 									 }
{ Portions created by Apple Computer, Inc. are 				 }
{ Copyright:  (c) 1997-2001 by Apple Computer, Inc.                      }
{ All Rights Reserved. 							 }
{                                                                        }
{ The original file is: OSUtils.h, released 20 Apr 2001. 		         }
{ The original Pascal code is: qt_OSUtils.pas, released 15 May 2002. 	 }
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
     File:       OSUtils.h

     Contains:   OS Utilities Interfaces.

     Version:    Technology: Mac OS 8
                 Release:    QuickTime 5.0.1

     Copyright:  (c) 1985-2001 by Apple Computer, Inc., all rights reserved

     Bugs?:      For bug reports, consult the following page on
                 the World Wide Web:

                     http://developer.apple.com/bugreporter/

*)

(* HISTORY:
15Feb2002 - birbilis: first creation based on the QuickTime 5.0.1 SDK for Windows
*)

unit qt_OSUtils;

interface
 uses C_Types;

type
 QElemPtr=^QElem;
 QElem=record
  qLink:QElemPtr;
  qType:short;
  qData:array[0..0] of short;
 end;

{$ifdef TARGET_OS_MAC}

 type
  QHdr=record
   qFlags:{volatile} short;
   qHead:{volatile} QElemPtr;
   qTail:{volatile} QElemPtr;
   end;
  QHdrPtr=^QHdr;

{$else}

(*
   QuickTime 3.0
   this version of QHdr contains the Mutex necessary for
   non-mac non-interrupt code
*)

 type
  QHdr=record
   qFlags:{volatile} short;
   pad:short;
   MutexID:long;
   qHead:{volatile} QElemPtr;
   qTail:{volatile} QElemPtr;
   end;
  QHdrPtr=^QHdr;
{$endif} (* TARGET_OS_MAC *)

implementation

end.
