{************************************************************************}
{                                                       	             }
{       Borland Delphi Runtime Library                  		       }
{       QuickTime interface unit                                         }
{ 									                   }
{ Portions created by Apple Computer, Inc. are 					 }
{ Copyright (C) 1997-1998 Apple Computer, Inc.. 			       }
{ All Rights Reserved. 							             }
{ 								                   	 }
{ The original file is: QD3DShader.h, released dd Mmm yyyy. 		       }
{ The original Pascal code is: qt_QD3DShader.pas, released 14 May 2000. 	 }
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

//01Mar1999 - birbilis: COMPLETED
//14May2000 - birbilis: donated to Delphi-JEDI

unit qt_QD3DShader;

{$MINENUMSIZE 4} //must use this and make C enums into Delphi enums and not subrange types

interface
 uses C_Types,qt_QD3D;

(*
 	File:		QD3DShader.h

 	Contains:	QuickDraw 3D Shader / Color Routines

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
 **								RGB Color routines							 **
 **																			 **
 *****************************************************************************)

 function Q3ColorRGB_Set(color:TQ3ColorRGB;r:float;g:float;b:float):TQ3ColorRGB ; cdecl;
 function Q3ColorARGB_Set(color:TQ3ColorARGB;a:float;r:float;g:float;b:float):TQ3ColorARGB ; cdecl;
 function Q3ColorRGB_Add(const c1:TQ3ColorRGB;const c2:TQ3ColorRGB;result:TQ3ColorRGB):TQ3ColorRGB ; cdecl;
 function Q3ColorRGB_Subtract(const c1:TQ3ColorRGB;const c2:TQ3ColorRGB;result:TQ3ColorRGB):TQ3ColorRGB ; cdecl;
 function Q3ColorRGB_Scale(const color:TQ3ColorRGB;scale:float;result:TQ3ColorRGB):TQ3ColorRGB ; cdecl;
 function Q3ColorRGB_Clamp(const color:TQ3ColorRGB;result:TQ3ColorRGB):TQ3ColorRGB ; cdecl;
 function Q3ColorRGB_Lerp(const first:TQ3ColorRGB;const last:TQ3ColorRGB;alpha:float;result:TQ3ColorRGB):TQ3ColorRGB ; cdecl;
 function Q3ColorRGB_Accumulate(const src:TQ3ColorRGB;result:TQ3ColorRGB):TQ3ColorRGB ; cdecl;
 function Q3ColorRGB_Luminance(const color:TQ3ColorRGB;luminance:float):float ; cdecl;

(******************************************************************************
 **																			 **
 **								Shader Types								 **
 **																			 **
 *****************************************************************************)

 type TQ3ShaderUVBoundary=(
	kQ3ShaderUVBoundaryWrap		{= 0},
	kQ3ShaderUVBoundaryClamp	{= 1});

(******************************************************************************
 **																			 **
 **								Shader Routines								 **
 **																			 **
 *****************************************************************************)

 function Q3Shader_GetType(shader:TQ3ShaderObject):TQ3ObjectType; cdecl;
 function Q3Shader_Submit(shader:TQ3ShaderObject;view:TQ3ViewObject):TQ3Status; cdecl;
 function Q3Shader_SetUVTransform(shader:TQ3ShaderObject;const uvTransform:TQ3Matrix3x3):TQ3Status; cdecl;
 function Q3Shader_GetUVTransform(shader:TQ3ShaderObject;uvTransform:TQ3Matrix3x3):TQ3Status; cdecl;
 function Q3Shader_SetUBoundary(shader:TQ3ShaderObject;uBoundary:TQ3ShaderUVBoundary):TQ3Status; cdecl;
 function Q3Shader_SetVBoundary(shader:TQ3ShaderObject;vBoundary:TQ3ShaderUVBoundary):TQ3Status; cdecl;
 function Q3Shader_GetUBoundary(shader:TQ3ShaderObject;uBoundary:TQ3ShaderUVBoundary):TQ3Status; cdecl;
 function Q3Shader_GetVBoundary(shader:TQ3ShaderObject;vBoundary:TQ3ShaderUVBoundary):TQ3Status; cdecl;

(******************************************************************************
 **																			 **
 **							Illumination Shader	Classes						 **
 **																			 **
 *****************************************************************************)

 function Q3IlluminationShader_GetType(shader:TQ3ShaderObject):TQ3ObjectType; cdecl;
 function Q3PhongIllumination_New:TQ3ShaderObject; cdecl;
 function Q3LambertIllumination_New:TQ3ShaderObject; cdecl;
 function Q3NULLIllumination_New:TQ3ShaderObject; cdecl;

(******************************************************************************
 **																			 **
 **								 Surface Shader								 **
 **																			 **
 *****************************************************************************)

 function Q3SurfaceShader_GetType(shader:TQ3SurfaceShaderObject):TQ3ObjectType; cdecl;

(******************************************************************************
 **																			 **
 **								Texture Shader								 **
 **																			 **
 *****************************************************************************)

 function Q3TextureShader_New(texture:TQ3TextureObject):TQ3ShaderObject; cdecl;
 function Q3TextureShader_GetTexture(shader:TQ3ShaderObject;texture:TQ3TextureObject):TQ3Status; cdecl;
 function Q3TextureShader_SetTexture(shader:TQ3ShaderObject;texture:TQ3TextureObject):TQ3Status; cdecl;

(******************************************************************************
 **																			 **
 **								Texture Objects								 **
 **																			 **
 *****************************************************************************)

 function Q3Texture_GetType(texture:TQ3TextureObject):TQ3ObjectType; cdecl;
 function Q3Texture_GetWidth(texture:TQ3TextureObject;width:unsigned_longPtr):TQ3Status; cdecl;
 function Q3Texture_GetHeight(texture:TQ3TextureObject;height:unsigned_longPtr):TQ3Status; cdecl;

(******************************************************************************
 **																			 **
 **								Pixmap Texture							     **
 **																			 **
 *****************************************************************************)

 function Q3PixmapTexture_New(const pixmap:TQ3StoragePixmap):TQ3TextureObject; cdecl;
 function Q3PixmapTexture_GetPixmap(texture:TQ3TextureObject;pixmap:TQ3StoragePixmap):TQ3Status; cdecl;
 function Q3PixmapTexture_SetPixmap(texture:TQ3TextureObject;const pixmap:TQ3StoragePixmap):TQ3Status; cdecl;

(******************************************************************************
 **																			 **
 **								Mipmap Texture							     **
 **																			 **
 *****************************************************************************)

 function Q3MipmapTexture_New(const mipmap:TQ3Mipmap):TQ3TextureObject; cdecl;
 function Q3MipmapTexture_GetMipmap(texture:TQ3TextureObject;mipmap:TQ3Mipmap):TQ3Status; cdecl;
 function Q3MipmapTexture_SetMipmap(texture:TQ3TextureObject;const mipmap:TQ3Mipmap):TQ3Status; cdecl;

implementation

(******************************************************************************
 **																			 **
 **								RGB Color routines							 **
 **																			 **
 *****************************************************************************)

function Q3ColorRGB_Set; cdecl; external 'qd3d.dll';
function Q3ColorARGB_Set; cdecl; external 'qd3d.dll';
function Q3ColorRGB_Add; cdecl; external 'qd3d.dll';
function Q3ColorRGB_Subtract; cdecl; external 'qd3d.dll';
function Q3ColorRGB_Scale; cdecl; external 'qd3d.dll';
function Q3ColorRGB_Clamp; cdecl; external 'qd3d.dll';
function Q3ColorRGB_Lerp; cdecl; external 'qd3d.dll';
function Q3ColorRGB_Accumulate; cdecl; external 'qd3d.dll';
function Q3ColorRGB_Luminance; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **								Shader Routines								 **
 **																			 **
 *****************************************************************************)

function Q3Shader_GetType; cdecl; external 'qd3d.dll';
function Q3Shader_Submit; cdecl; external 'qd3d.dll';
function Q3Shader_SetUVTransform; cdecl; external 'qd3d.dll';
function Q3Shader_GetUVTransform; cdecl; external 'qd3d.dll';
function Q3Shader_SetUBoundary; cdecl; external 'qd3d.dll';
function Q3Shader_SetVBoundary; cdecl; external 'qd3d.dll';
function Q3Shader_GetUBoundary; cdecl; external 'qd3d.dll';
function Q3Shader_GetVBoundary; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **							Illumination Shader	Classes						 **
 **																			 **
 *****************************************************************************)

function Q3IlluminationShader_GetType; cdecl; external 'qd3d.dll';
function Q3PhongIllumination_New; cdecl; external 'qd3d.dll';
function Q3LambertIllumination_New; cdecl; external 'qd3d.dll';
function Q3NULLIllumination_New; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **								 Surface Shader								 **
 **																			 **
 *****************************************************************************)

function Q3SurfaceShader_GetType; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **								Texture Shader								 **
 **																			 **
 *****************************************************************************)

function Q3TextureShader_New; cdecl; external 'qd3d.dll';
function Q3TextureShader_GetTexture; cdecl; external 'qd3d.dll';
function Q3TextureShader_SetTexture; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **								Texture Objects								 **
 **																			 **
 *****************************************************************************)

function Q3Texture_GetType; cdecl; external 'qd3d.dll';
function Q3Texture_GetWidth; cdecl; external 'qd3d.dll';
function Q3Texture_GetHeight; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **								Pixmap Texture							     **
 **																			 **
 *****************************************************************************)

function Q3PixmapTexture_New; cdecl; external 'qd3d.dll';
function Q3PixmapTexture_GetPixmap; cdecl; external 'qd3d.dll';
function Q3PixmapTexture_SetPixmap; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **								Mipmap Texture							     **
 **																			 **
 *****************************************************************************)

function Q3MipmapTexture_New; cdecl; external 'qd3d.dll';
function Q3MipmapTexture_GetMipmap; cdecl; external 'qd3d.dll';
function Q3MipmapTexture_SetMipmap; cdecl; external 'qd3d.dll';

end.

