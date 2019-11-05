{************************************************************************}
{                                                       	             }
{       Borland Delphi Runtime Library                  		       }
{       QuickTime interface unit                                         }
{ 									                   }
{ Portions created by Apple Computer, Inc. are 					 }
{ Copyright (C) 1997-1998 Apple Computer, Inc.. 			       }
{ All Rights Reserved. 							             }
{ 								                   	 }
{ The original file is: QD3DSet.h, released dd Mmm yyyy. 		       }
{ The original Pascal code is: qt_QD3DSet.pas, released 14 May 2000. 	 }
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

//01Mar1999 - birbilis: using {$MINENUMSIZE 4} define
//14May2000 - birbilis: donated to Delphi-JEDI

unit qt_QD3DSet;

{$MINENUMSIZE 4} //must use this and make C enums into Delphi enums and not subrange types

interface
 uses qt_QD3D;

(******************************************************************************
 **
 ** Attribute Types								 **
 **
 *****************************************************************************)
(*
 *	For the data types listed below, pass in a pointer to it in the _Add
 *	and _Get calls.
 *
 *	For surface shader attributes, reference counts are incremented on
 *	the _Add and _Get
 *)

 type TQ3AttributeTypes=(		(* Data Type			    *)
       kQ3AttributeTypeNone		{= 0},	  (* ---------		    *)
       kQ3AttributeTypeSurfaceUV	{= 1},	  (* TQ3Param2D		    *)
       kQ3AttributeTypeShadingUV	{= 2},	  (* TQ3Param2D 	    *)
       kQ3AttributeTypeNormal		{= 3},	  (* TQ3Vector3D 	    *)
       kQ3AttributeTypeAmbientCoefficient {= 4}, (* float 		    *)
       kQ3AttributeTypeDiffuseColor {= 5},	  (* TQ3ColorRGB	    *)
       kQ3AttributeTypeSpecularColor {= 6},	  (* TQ3ColorRGB	    *)
       kQ3AttributeTypeSpecularControl {= 7},	  (* float		    *)
       kQ3AttributeTypeTransparencyColor {= 8},  (* TQ3ColorRGB	    *)
       kQ3AttributeTypeSurfaceTangent {= 9},	  (* TQ3Tangent2D  	    *)
       kQ3AttributeTypeHighlightState {= 10},	  (* TQ3Switch 		    *)
       kQ3AttributeTypeSurfaceShader {= 11},	  (* TQ3SurfaceShaderObject *)
       kQ3AttributeTypeNumTypes	{= 12});

 type TQ3AttributeType=TQ3ElementType;       

 (* AttributeSet Routines *)

 function Q3AttributeSet_New:TQ3AttributeSet; cdecl;
 function Q3AttributeSet_Add(attributeSet:TQ3AttributeSet;theType:TQ3AttributeType;const data:pointer):TQ3Status; cdecl;
 function Q3AttributeSet_Contains(attributeSet:TQ3AttributeSet;attributeType:TQ3AttributeType):TQ3Boolean; cdecl;
 function Q3AttributeSet_Get(attributeSet:TQ3AttributeSet;theType:TQ3AttributeType;data:pointer):TQ3Status; cdecl;
 function Q3AttributeSet_Clear(attributeSet:TQ3AttributeSet;theType:TQ3AttributeType):TQ3Status; cdecl;
 function Q3AttributeSet_Empty(target:TQ3AttributeSet):TQ3Status; cdecl;

implementation

(* AttributeSet Routines *)

function Q3AttributeSet_New; cdecl; external 'qd3d.dll';
function Q3AttributeSet_Add; cdecl; external 'qd3d.dll';
function Q3AttributeSet_Contains; cdecl; external 'qd3d.dll';
function Q3AttributeSet_Get; cdecl; external 'qd3d.dll';
function Q3AttributeSet_Clear; cdecl; external 'qd3d.dll';
function Q3AttributeSet_Empty; cdecl; external 'qd3d.dll';

end.

