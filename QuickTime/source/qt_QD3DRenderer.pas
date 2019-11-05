{************************************************************************}
{                                                       	             }
{       Borland Delphi Runtime Library                  		       }
{       QuickTime interface unit                                         }
{ 									                   }
{ Portions created by Apple Computer, Inc. are 					 }
{ Copyright (C) 1995-1998 Apple Computer, Inc.. 			       }
{ All Rights Reserved. 							             }
{ 								                   	 }
{ The original file is: QD3DRenderer.h, released dd Mmm yyyy. 		       }
{ The original Pascal code is: qt_QD3DRenderer.pas, released 14 May 2000. 	 }
{ The initial developer of the Pascal code is George Birbilis            }
{ (birbilis@cti.gr).                     				             }
{ 									                   }
{ Portions created by George Birbilis are    				       }
{ Copyright (C) 1998-2000 George Birbilis 					 }
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

//14May2000 - birbilis: donated to Delphi-JEDI

unit qt_QD3DRenderer;

interface
 uses C_Types,qt_QD3D;

(*
 	File:		QD3DRenderer.h

 	Contains:	Q3Renderer types and routines

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
 **	Renderer Functions						     **
 **																			 **
 *****************************************************************************)

 function Q3Renderer_NewFromType(rendererObjectType:TQ3ObjectType):TQ3RendererObject; cdecl;
 function Q3Renderer_GetType(renderer:TQ3RendererObject):TQ3ObjectType; cdecl;

(* Q3Renderer_Flush has been replaced by Q3View_Flush *)
(* Q3Renderer_Sync has been replaced by Q3View_Sync *)

(******************************************************************************
 **																			 **
 **						Interactive Renderer Specific Functions				 **
 **																			 **
 *****************************************************************************)
(* CSG IDs attribute *)
//??? const kQ3AttributeTypeConstructiveSolidGeometryID=Q3_OBJECT_TYPE('c','s','g','i');

(* Object IDs, to be applied as attributes on geometries *)
const kQ3SolidGeometryObjNone =(-1);
      kQ3SolidGeometryObjA    =	0;
      kQ3SolidGeometryObjB    =	1;
      kQ3SolidGeometryObjC    =	2;
      kQ3SolidGeometryObjD    =	3;
      kQ3SolidGeometryObjE    =	4;

(* Possible CSG equations *)

 type TQ3CSGEquation=int; //Delphi: can't make an enum, cause members aren't 0,1,2,...
 const kQ3CSGEquationAandB	= long($88888888);
       kQ3CSGEquationAandnotB	= $22222222;
       kQ3CSGEquationAanBonCad	= $2F222F22;
       kQ3CSGEquationnotAandB	= $44444444;
       kQ3CSGEquationnAaBorCanB	= $74747474;

 function Q3InteractiveRenderer_SetCSGEquation(renderer:TQ3RendererObject;equation:TQ3CSGEquation):TQ3Status; cdecl;
 function Q3InteractiveRenderer_GetCSGEquation(renderer:TQ3RendererObject;equation:TQ3CSGEquation):TQ3Status; cdecl;
 function Q3InteractiveRenderer_SetPreferences(renderer:TQ3RendererObject;vendorID:long;engineID:long):TQ3Status; cdecl;
 function Q3InteractiveRenderer_GetPreferences(renderer:TQ3RendererObject;vendorID:long;engineID:long):TQ3Status; cdecl;
 function Q3InteractiveRenderer_SetDoubleBufferBypass(renderer:TQ3RendererObject;bypass:TQ3Boolean):TQ3Status; cdecl;
 function Q3InteractiveRenderer_GetDoubleBufferBypass(renderer:TQ3RendererObject;bypass:TQ3Boolean):TQ3Status; cdecl;
 function Q3InteractiveRenderer_SetRAVEContextHints(renderer:TQ3RendererObject;RAVEContextHints:unsigned_long):TQ3Status; cdecl;
 function Q3InteractiveRenderer_GetRAVEContextHints(renderer:TQ3RendererObject;RAVEContextHints:unsigned_longPtr):TQ3Status; cdecl;
 function Q3InteractiveRenderer_SetRAVETextureFilter(renderer:TQ3RendererObject;RAVEtextureFilterValue:unsigned_long):TQ3Status; cdecl;
 function Q3InteractiveRenderer_GetRAVETextureFilter(renderer:TQ3RendererObject;RAVEtextureFilterValue:unsigned_longPtr):TQ3Status; cdecl;

implementation

(******************************************************************************
 **																			 **
 **	Renderer Functions						     **
 **																			 **
 *****************************************************************************)

function Q3Renderer_NewFromType; cdecl; external 'qd3d.dll';
function Q3Renderer_GetType; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **						Interactive Renderer Specific Functions				 **
 **																			 **
 *****************************************************************************)

function Q3InteractiveRenderer_SetCSGEquation; cdecl; external 'qd3d.dll';
function Q3InteractiveRenderer_GetCSGEquation; cdecl; external 'qd3d.dll';
function Q3InteractiveRenderer_SetPreferences; cdecl; external 'qd3d.dll';
function Q3InteractiveRenderer_GetPreferences; cdecl; external 'qd3d.dll';
function Q3InteractiveRenderer_SetDoubleBufferBypass; cdecl; external 'qd3d.dll';
function Q3InteractiveRenderer_GetDoubleBufferBypass; cdecl; external 'qd3d.dll';
function Q3InteractiveRenderer_SetRAVEContextHints; cdecl; external 'qd3d.dll';
function Q3InteractiveRenderer_GetRAVEContextHints; cdecl; external 'qd3d.dll';
function Q3InteractiveRenderer_SetRAVETextureFilter; cdecl; external 'qd3d.dll';
function Q3InteractiveRenderer_GetRAVETextureFilter; cdecl; external 'qd3d.dll';

end.

