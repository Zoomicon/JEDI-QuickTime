{************************************************************************}
{                                                       	             }
{       Borland Delphi Runtime Library                  		       }
{       QuickTime interface unit                                         }
{ 									                   }
{ Portions created by Apple Computer, Inc. are 					 }
{ Copyright (C) 1997-1998 Apple Computer, Inc.. 			       }
{ All Rights Reserved. 							             }
{ 								                   	 }
{ The original file is: QD3DTransform.h, released dd Mmm yyyy. 		       }
{ The original Pascal code is: qt_QD3DTransform.pas, released 14 May 2000. 	 }
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

unit qt_QD3DTransform;

interface
 uses C_Types,qt_QD3D;

(*
 	File:		QD3DTransform.h

 	Contains:	Q3Transform routines

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
 **							Transform Routines							     **
 **																			 **
 *****************************************************************************)

 function Q3Transform_GetType(transform:TQ3TransformObject):TQ3ObjectType; cdecl;
 function Q3Transform_GetMatrix(transform:TQ3TransformObject;matrix:PQ3Matrix4x4):PQ3Matrix4x4; cdecl;
 function Q3Transform_Submit(transform:TQ3TransformObject;view:TQ3ViewObject):TQ3Status; cdecl;

(******************************************************************************
 **																			 **
 **							MatrixTransform Routines					     **
 **																			 **
 *****************************************************************************)

 function Q3MatrixTransform_New(const matrix:PQ3Matrix4x4):TQ3TransformObject; cdecl;
 function Q3MatrixTransform_Submit(const matrix:PQ3Matrix4x4;view:TQ3ViewObject):TQ3Status; cdecl;
 function Q3MatrixTransform_Set(transform:TQ3TransformObject;const matrix:PQ3Matrix4x4):TQ3Status; cdecl;
 function Q3MatrixTransform_Get(transform:TQ3TransformObject;matrix:PQ3Matrix4x4):TQ3Status; cdecl;

(******************************************************************************
 **																			 **
 **							RotateTransform Data						     **
 **																			 **
 *****************************************************************************)

 type TQ3RotateTransformData=packed record
       axis:TQ3Axis;
       radians:float;
       end;

(******************************************************************************
 **																			 **
 **							RotateTransform Routines					     **
 **																			 **
 *****************************************************************************)

 type PQ3RotateTransformData=^TQ3RotateTransformData; //Delphi

 function Q3RotateTransform_New(const data:PQ3RotateTransformData):TQ3TransformObject; cdecl;
 function Q3RotateTransform_Submit(const data:PQ3RotateTransformData;view:TQ3ViewObject):TQ3Status; cdecl;
 function Q3RotateTransform_SetData(transform:TQ3TransformObject;const data:PQ3RotateTransformData):TQ3Status; cdecl;
 function Q3RotateTransform_GetData(transform:TQ3TransformObject;data:PQ3RotateTransformData):TQ3Status; cdecl;
 function Q3RotateTransform_SetAxis(transform:TQ3TransformObject;axis:TQ3Axis):TQ3Status; cdecl;
 function Q3RotateTransform_SetAngle(transform:TQ3TransformObject;radians:float):TQ3Status; cdecl;
 function Q3RotateTransform_GetAxis(renderable:TQ3TransformObject;axis:PQ3Axis):TQ3Status; cdecl;
 function Q3RotateTransform_GetAngle(transform:TQ3TransformObject;radians:floatPtr):TQ3Status; cdecl;

(******************************************************************************
 **																			 **
 **					RotateAboutPointTransform Data							 **
 **																			 **
 *****************************************************************************)

 type TQ3RotateAboutPointTransformData=packed record
       axis:TQ3Axis;
       radians:float;
       about:TQ3Point3D;
       end;

(******************************************************************************
 **																			 **
 **					RotateAboutPointTransform Routines						 **
 **																			 **
 *****************************************************************************)

 type PQ3RotateAboutPointTransformData=^TQ3RotateAboutPointTransformData;

 function Q3RotateAboutPointTransform_New(const data:PQ3RotateAboutPointTransformData):TQ3TransformObject; cdecl;
 function Q3RotateAboutPointTransform_Submit(const data:PQ3RotateAboutPointTransformData;view:TQ3ViewObject):TQ3Status; cdecl;
 function Q3RotateAboutPointTransform_SetData(transform:TQ3TransformObject;const data:PQ3RotateAboutPointTransformData):TQ3Status; cdecl;
 function Q3RotateAboutPointTransform_GetData(transform:TQ3TransformObject;data:PQ3RotateAboutPointTransformData):TQ3Status; cdecl;
 function Q3RotateAboutPointTransform_SetAxis(transform:TQ3TransformObject;axis:TQ3Axis):TQ3Status; cdecl;
 function Q3RotateAboutPointTransform_GetAxis(transform:TQ3TransformObject;axis:PQ3Axis):TQ3Status; cdecl;
 function Q3RotateAboutPointTransform_SetAngle(transform:TQ3TransformObject;radians:float):TQ3Status; cdecl;
 function Q3RotateAboutPointTransform_GetAngle(transform:TQ3TransformObject;radians:floatPtr):TQ3Status; cdecl;
 function Q3RotateAboutPointTransform_SetAboutPoint(transform:TQ3TransformObject;const about:PQ3Point3D):TQ3Status; cdecl;
 function Q3RotateAboutPointTransform_GetAboutPoint(transform:TQ3TransformObject;about:PQ3Point3D):TQ3Status; cdecl;

(******************************************************************************
 **																			 **
 **					RotateAboutAxisTransform Data							 **
 **																			 **
 *****************************************************************************)

 type TQ3RotateAboutAxisTransformData=record
       origin:TQ3Point3D;
       orientation:TQ3Vector3D;
       radians:float;
       end;

(******************************************************************************
 **																			 **
 **					RotateAboutAxisTransform Routines						 **
 **																			 **
 *****************************************************************************)

 type PQ3RotateAboutAxisTransformData=^TQ3RotateAboutAxisTransformData;

 function Q3RotateAboutAxisTransform_New(const data:PQ3RotateAboutAxisTransformData):TQ3TransformObject; cdecl;
 function Q3RotateAboutAxisTransform_Submit(const data:PQ3RotateAboutAxisTransformData;view:TQ3ViewObject):TQ3Status; cdecl;
 function Q3RotateAboutAxisTransform_SetData(transform:TQ3TransformObject;const data:PQ3RotateAboutAxisTransformData):TQ3Status; cdecl;
 function Q3RotateAboutAxisTransform_GetData(transform:TQ3TransformObject;data:PQ3RotateAboutAxisTransformData):TQ3Status; cdecl;
 function Q3RotateAboutAxisTransform_SetOrientation(transform:TQ3TransformObject;const axis:PQ3Vector3D):TQ3Status; cdecl;
 function Q3RotateAboutAxisTransform_GetOrientation(transform:TQ3TransformObject;axis:PQ3Vector3D):TQ3Status; cdecl;
 function Q3RotateAboutAxisTransform_SetAngle(transform:TQ3TransformObject;radians:float):TQ3Status; cdecl;
 function Q3RotateAboutAxisTransform_GetAngle(transform:TQ3TransformObject;radians:floatPtr):TQ3Status; cdecl;
 function Q3RotateAboutAxisTransform_SetOrigin(transform:TQ3TransformObject;const origin:PQ3Point3D):TQ3Status; cdecl;
 function Q3RotateAboutAxisTransform_GetOrigin(transform:TQ3TransformObject;origin:PQ3Point3D):TQ3Status; cdecl;

(******************************************************************************
 **																			 **
 **							ScaleTransform Routines						     **
 **																			 **
 *****************************************************************************)

 function Q3ScaleTransform_New(const scale:PQ3Vector3D):TQ3TransformObject; cdecl;
 function Q3ScaleTransform_Submit(const scale:PQ3Vector3D;view:TQ3ViewObject):TQ3Status; cdecl;
 function Q3ScaleTransform_Set(transform:TQ3TransformObject;const scale:PQ3Vector3D):TQ3Status; cdecl;
 function Q3ScaleTransform_Get(transform:TQ3TransformObject;scale:PQ3Vector3D):TQ3Status; cdecl;

(******************************************************************************
 **																			 **
 **							TranslateTransform Routines					     **
 **																			 **
 *****************************************************************************)

 function Q3TranslateTransform_New(const translate:PQ3Vector3D):TQ3TransformObject; cdecl;
 function Q3TranslateTransform_Submit(const translate:PQ3Vector3D;view:TQ3ViewObject):TQ3Status; cdecl;
 function Q3TranslateTransform_Set(transform:TQ3TransformObject;const translate:PQ3Vector3D):TQ3Status; cdecl;
 function Q3TranslateTransform_Get(transform:TQ3TransformObject;translate:PQ3Vector3D):TQ3Status; cdecl;

(******************************************************************************
 **																			 **
 **							QuaternionTransform Routines				     **
 **																			 **
 *****************************************************************************)

 function Q3QuaternionTransform_New(const quaternion:PQ3Quaternion):TQ3TransformObject; cdecl;
 function Q3QuaternionTransform_Submit(const quaternion:PQ3Quaternion;view:TQ3ViewObject):TQ3Status; cdecl;
 function Q3QuaternionTransform_Set(transform:TQ3TransformObject;const quaternion:PQ3Quaternion):TQ3Status; cdecl;
 function Q3QuaternionTransform_Get(transform:TQ3TransformObject;quaternion:PQ3Quaternion):TQ3Status; cdecl;

(******************************************************************************
 **																			 **
 **							ResetTransform Routines						     **
 **																			 **
 *****************************************************************************)

 function Q3ResetTransform_New:TQ3TransformObject; cdecl;
 function Q3ResetTransform_Submit(view:TQ3ViewObject):TQ3Status; cdecl;

implementation

(******************************************************************************
 **																			 **
 **							Transform Routines							     **
 **																			 **
 *****************************************************************************)

function Q3Transform_GetType; cdecl; external 'qd3d.dll';
function Q3Transform_GetMatrix; cdecl; external 'qd3d.dll';
function Q3Transform_Submit; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **							MatrixTransform Routines					     **
 **																			 **
 *****************************************************************************)

function Q3MatrixTransform_New; cdecl; external 'qd3d.dll';
function Q3MatrixTransform_Submit; cdecl; external 'qd3d.dll';
function Q3MatrixTransform_Set; cdecl; external 'qd3d.dll';
function Q3MatrixTransform_Get; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **							RotateTransform Routines					     **
 **																			 **
 *****************************************************************************)

function Q3RotateTransform_New; cdecl; external 'qd3d.dll';
function Q3RotateTransform_Submit; cdecl; external 'qd3d.dll';
function Q3RotateTransform_SetData; cdecl; external 'qd3d.dll';
function Q3RotateTransform_GetData; cdecl; external 'qd3d.dll';
function Q3RotateTransform_SetAxis; cdecl; external 'qd3d.dll';
function Q3RotateTransform_SetAngle; cdecl; external 'qd3d.dll';
function Q3RotateTransform_GetAxis; cdecl; external 'qd3d.dll';
function Q3RotateTransform_GetAngle; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **					RotateAboutPointTransform Routines						 **
 **																			 **
 *****************************************************************************)

function Q3RotateAboutPointTransform_New; cdecl; external 'qd3d.dll';
function Q3RotateAboutPointTransform_Submit; cdecl; external 'qd3d.dll';
function Q3RotateAboutPointTransform_SetData; cdecl; external 'qd3d.dll';
function Q3RotateAboutPointTransform_GetData; cdecl; external 'qd3d.dll';
function Q3RotateAboutPointTransform_SetAxis; cdecl; external 'qd3d.dll';
function Q3RotateAboutPointTransform_GetAxis; cdecl; external 'qd3d.dll';
function Q3RotateAboutPointTransform_SetAngle; cdecl; external 'qd3d.dll';
function Q3RotateAboutPointTransform_GetAngle; cdecl; external 'qd3d.dll';
function Q3RotateAboutPointTransform_SetAboutPoint; cdecl; external 'qd3d.dll';
function Q3RotateAboutPointTransform_GetAboutPoint; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **					RotateAboutAxisTransform Routines						 **
 **																			 **
 *****************************************************************************)

function Q3RotateAboutAxisTransform_New; cdecl; external 'qd3d.dll';
function Q3RotateAboutAxisTransform_Submit; cdecl; external 'qd3d.dll';
function Q3RotateAboutAxisTransform_SetData; cdecl; external 'qd3d.dll';
function Q3RotateAboutAxisTransform_GetData; cdecl; external 'qd3d.dll';
function Q3RotateAboutAxisTransform_SetOrientation; cdecl; external 'qd3d.dll';
function Q3RotateAboutAxisTransform_GetOrientation; cdecl; external 'qd3d.dll';
function Q3RotateAboutAxisTransform_SetAngle; cdecl; external 'qd3d.dll';
function Q3RotateAboutAxisTransform_GetAngle; cdecl; external 'qd3d.dll';
function Q3RotateAboutAxisTransform_SetOrigin; cdecl; external 'qd3d.dll';
function Q3RotateAboutAxisTransform_GetOrigin; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **							ScaleTransform Routines						     **
 **																			 **
 *****************************************************************************)

function Q3ScaleTransform_New; cdecl; external 'qd3d.dll';
function Q3ScaleTransform_Submit; cdecl; external 'qd3d.dll';
function Q3ScaleTransform_Set; cdecl; external 'qd3d.dll';
function Q3ScaleTransform_Get; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **							TranslateTransform Routines					     **
 **																			 **
 *****************************************************************************)

function Q3TranslateTransform_New; cdecl; external 'qd3d.dll';
function Q3TranslateTransform_Submit; cdecl; external 'qd3d.dll';
function Q3TranslateTransform_Set; cdecl; external 'qd3d.dll';
function Q3TranslateTransform_Get; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **							QuaternionTransform Routines				     **
 **																			 **
 *****************************************************************************)

function Q3QuaternionTransform_New; cdecl; external 'qd3d.dll';
function Q3QuaternionTransform_Submit; cdecl; external 'qd3d.dll';
function Q3QuaternionTransform_Set; cdecl; external 'qd3d.dll';
function Q3QuaternionTransform_Get; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **							ResetTransform Routines						     **
 **																			 **
 *****************************************************************************)

function Q3ResetTransform_New; cdecl; external 'qd3d.dll';
function Q3ResetTransform_Submit; cdecl; external 'qd3d.dll';

end.

