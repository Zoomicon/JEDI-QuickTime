{************************************************************************}
{                                                       	         }
{       Borland Delphi Runtime Library                  		 }
{       QuickTime interface unit                                         }
{ 									 }
{ Portions created by Apple Computer, Inc. are 				 }
{ Copyright (C) 1995-1998 Apple Computer, Inc.. 			 }
{ All Rights Reserved. 							 }
{ 								         }
{ The original file is: QD3DAcceleration.h, released dd Mmm yyyy. 	 }
{ The original Pascal code is: qt_QD3DAcceleration.pas, released 14 May 2000.}
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

//01Mar1999 - birbilis: COMPLETED
//14May2000 - birbilis: donated to Delphi-JEDI
//07Aug2004 - birbilis: renamed to "qt_QD3DAcceleration" from "qt_QD3DAccelaration"

unit qt_QD3DAcceleration;

interface
 uses qt_QD3D;

(*
 	File:		QD3DAcceleration.h

 	Contains:	Header file for low-level 3D driver API							
 
 	Version:	Technology:	Quickdraw 3D 1.5.4
 				Release:	QuickTime 3.0

 	Copyright:	© 1995-1998 by Apple Computer, Inc., all rights reserved.
 
 	Bugs?:		Please include the the file and version information (from above) with
 				the problem description.  Developers belonging to one of the Apple
 				developer programs can submit bug reports to:

 					devsupport@apple.com

*)

(******************************************************************************
 **																			 **
 ** 						Vendor ID definitions							 **
 **																			 **
 *****************************************************************************)
(*
 * If kQAVendor_BestChoice is used, the system chooses the "best" drawing engine
 * available for the target device. This should be used for the default.
 *)
const kQAVendor_BestChoice	=(-1);
(*
 * The other definitions (kQAVendor_Apple, etc.) identify specific vendors
 * of drawing engines. When a vendor ID is used in conjunction with a
 * vendor-defined engine ID, a specific drawing engine can be selected.
 *)
const kQAVendor_Apple		=0;
const kQAVendor_ATI		=1;
const kQAVendor_Radius		=2;
const kQAVendor_Mentor		=3;		(* Mentor Software, Inc. *)
const kQAVendor_Matrox		=4;
const kQAVendor_Yarc		=5;
const kQAVendor_DiamondMM	=6;
const kQAVendor_3DLabs		=7;
const kQAVendor_D3DAdaptor	=8;
const kQAVendor_IXMicro		=9;
(******************************************************************************
 **																			 **
 **						 Apple's engine ID definitions						 **
 **																			 **
 *****************************************************************************)
const kQAEngine_AppleSW		=0;		(* Default software rasterizer *)
const kQAEngine_AppleHW		=(-1);	(* Apple accelerator *)
const kQAEngine_AppleHW2	=1;		(* Another Apple accelerator *)
const kQAEngine_AppleHW3	=2;		(* Another Apple accelerator *)

implementation

end.

