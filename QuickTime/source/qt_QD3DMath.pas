{************************************************************************}
{                                                       	             }
{       Borland Delphi Runtime Library                  		       }
{       QuickTime interface unit                                         }
{ 									                   }
{ Portions created by Apple Computer, Inc. are 					 }
{ Copyright (C) 1995-1998 Apple Computer, Inc.. 			       }
{ All Rights Reserved. 							             }
{ 								                   	 }
{ The original file is: QD3DMath.h, released dd Mmm yyyy. 		       }
{ The original Pascal code is: qt_QD3DMath.pas, released 14 May 2000. 	 }
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

unit qt_QD3DMath;

interface
 uses C_Types,qt_QD3D;

(*
 	File:		QD3DMath.h

 	Contains:	Math & matrix routines and definitions.

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
 **							Constant Definitions							 **
 **																			 **
 *****************************************************************************)
(*
 *  Real zero definition
 *)

{$ifdef FLT_EPSILON}
	const kQ3RealZero=(FLT_EPSILON);
{$else}
	const kQ3RealZero={float}(1.19209290e-07);
{$endif}

{$ifdef FLT_MAX}
	const kQ3MaxFloat=(FLT_MAX);
{$else}
	const kQ3MaxFloat={float}(3.40282347e+38);
{$endif}

(*
 *  Values of PI
 *)
 const kQ3Pi 		=			{float}(3.1415926535898);
       kQ32Pi 		=			{float}(2.0 * 3.1415926535898);
       kQ3PiOver2	=			{float}(3.1415926535898 / 2.0);
       kQ33PiOver2	=			{float}(3.0 * 3.1415926535898 / 2.0);

(******************************************************************************
 **																			 **
 **							Miscellaneous Functions							 **
 **																			 **
 *****************************************************************************)

 function Q3Math_DegreesToRadians(x:float):float;
 function Q3Math_RadiansToDegrees(x:float):float;
 function Q3Math_Min(x,y:float):float;
 function Q3Math_Max(x,y:float):float;

(******************************************************************************
 **																			 **
 **							Point and Vector Creation						 **
 **																			 **
 *****************************************************************************)

 function Q3Point2D_Set(point2D:TQ3Point2D;x:float;y:float):TQ3Point2D ; cdecl;
 function Q3Param2D_Set(param2D:TQ3Param2D;u:float;v:float):TQ3Param2D ; cdecl;
 function Q3Point3D_Set(point3D:TQ3Point3D;x:float;y:float;z:float):TQ3Point3D ; cdecl;
 function Q3RationalPoint3D_Set(point3D:TQ3RationalPoint3D;x:float;y:float;w:float):TQ3RationalPoint3D ; cdecl;
 function Q3RationalPoint4D_Set(point4D:TQ3RationalPoint4D;x:float;y:float;z:float;w:float):TQ3RationalPoint4D ; cdecl;
 function Q3Vector2D_Set(vector2D:TQ3Vector2D;x:float;y:float):TQ3Vector2D ; cdecl;
 function Q3Vector3D_Set(vector3D:TQ3Vector3D;x:float;y:float;z:float):TQ3Vector3D ; cdecl;
 function Q3PolarPoint_Set(polarPoint:TQ3PolarPoint;r:float;theta:float):TQ3PolarPoint ; cdecl;
 function Q3SphericalPoint_Set(sphericalPoint:TQ3SphericalPoint;rho:float;theta:float;phi:float):TQ3SphericalPoint ; cdecl;

(******************************************************************************
 **																			 **
 **					Point and Vector Dimension Conversion					 **
 **																			 **
 *****************************************************************************)

 function Q3Point2D_To3D(const point2D:TQ3Point2D;result:TQ3Point3D):TQ3Point3D ; cdecl;
 function Q3RationalPoint3D_To2D(const point3D:TQ3RationalPoint3D;result:TQ3Point2D):TQ3Point2D ; cdecl;
 function Q3Point3D_To4D(const point3D:TQ3Point3D;result:TQ3RationalPoint4D):TQ3RationalPoint4D ; cdecl;
 function Q3RationalPoint4D_To3D(const point4D:TQ3RationalPoint4D;result:TQ3Point3D):TQ3Point3D ; cdecl;
 function Q3Vector2D_To3D(const vector2D:TQ3Vector2D;result:TQ3Vector3D):TQ3Vector3D ; cdecl;
 function Q3Vector3D_To2D(const vector3D:TQ3Vector3D;result:TQ3Vector2D):TQ3Vector2D ; cdecl;

(******************************************************************************
 **																			 **
 **							Point Subtraction								 **
 **																			 **
 *****************************************************************************)

 function Q3Point2D_Subtract(const p1:TQ3Point2D;const p2:TQ3Point2D;result:TQ3Vector2D):TQ3Vector2D ; cdecl;
 function Q3Param2D_Subtract(const p1:TQ3Param2D;const p2:TQ3Param2D;result:TQ3Vector2D):TQ3Vector2D ; cdecl;
 function Q3Point3D_Subtract(const p1:TQ3Point3D;const p2:TQ3Point3D;result:TQ3Vector3D):TQ3Vector3D ; cdecl;

(******************************************************************************
 **																			 **
 **							Point Distance									 **
 **																			 **
 *****************************************************************************)

 function Q3Point2D_Distance(const p1:TQ3Point2D;const p2:TQ3Point2D):float; cdecl;
 function Q3Point2D_DistanceSquared(const p1:TQ3Point2D;const p2:TQ3Point2D):float; cdecl;
 function Q3Param2D_Distance(const p1:TQ3Param2D;const p2:TQ3Param2D):float; cdecl;
 function Q3Param2D_DistanceSquared(const p1:TQ3Param2D;const p2:TQ3Param2D):float; cdecl;
 function Q3RationalPoint3D_Distance(const p1:TQ3RationalPoint3D;const p2:TQ3RationalPoint3D):float; cdecl;
 function Q3RationalPoint3D_DistanceSquared(const p1:TQ3RationalPoint3D;const p2:TQ3RationalPoint3D):float; cdecl;
 function Q3Point3D_Distance(const p1:TQ3Point3D;const p2:TQ3Point3D):float; cdecl;
 function Q3Point3D_DistanceSquared(const p1:TQ3Point3D;const p2:TQ3Point3D):float; cdecl;
 function Q3RationalPoint4D_Distance(const p1:TQ3RationalPoint4D;const p2:TQ3RationalPoint4D):float; cdecl;
 function Q3RationalPoint4D_DistanceSquared(const p1:TQ3RationalPoint4D;const p2:TQ3RationalPoint4D):float; cdecl;

(******************************************************************************
 **																			 **
 **							Point Relative Ratio							 **
 **																			 **
 *****************************************************************************)

 function Q3Point2D_RRatio(const p1:TQ3Point2D;const p2:TQ3Point2D;r1:float;r2:float;result:TQ3Point2D):TQ3Point2D ; cdecl;
 function Q3Param2D_RRatio(const p1:TQ3Param2D;const p2:TQ3Param2D;r1:float;r2:float;result:TQ3Param2D):TQ3Param2D ; cdecl;
 function Q3Point3D_RRatio(const p1:TQ3Point3D;const p2:TQ3Point3D;r1:float;r2:float;result:TQ3Point3D):TQ3Point3D ; cdecl;
 function Q3RationalPoint4D_RRatio(const p1:TQ3RationalPoint4D;const p2:TQ3RationalPoint4D;r1:float;r2:float;result:TQ3RationalPoint4D):TQ3RationalPoint4D ; cdecl;

(******************************************************************************
 **																			 **
 **	Point / Vector Addition	& Subtraction				     **
 **																			 **
 *****************************************************************************)

 function Q3Point2D_Vector2D_Add(const point2D:TQ3Point2D;const vector2D:TQ3Vector2D;result:TQ3Point2D):TQ3Point2D ; cdecl;
 function Q3Param2D_Vector2D_Add(const param2D:TQ3Param2D;const vector2D:TQ3Vector2D;result:TQ3Param2D):TQ3Param2D ; cdecl;
 function Q3Point3D_Vector3D_Add(const point3D:TQ3Point3D;const vector3D:TQ3Vector3D;result:TQ3Point3D):TQ3Point3D ; cdecl;
 function Q3Point2D_Vector2D_Subtract(const point2D:TQ3Point2D;const vector2D:TQ3Vector2D;result:TQ3Point2D):TQ3Point2D ; cdecl;
 function Q3Param2D_Vector2D_Subtract(const param2D:TQ3Param2D;const vector2D:TQ3Vector2D;result:TQ3Param2D):TQ3Param2D ; cdecl;
 function Q3Point3D_Vector3D_Subtract(const point3D:TQ3Point3D;const vector3D:TQ3Vector3D;result:TQ3Point3D):TQ3Point3D ; cdecl;

(******************************************************************************
 **																			 **
 **								Vector Scale								 **
 **																			 **
 *****************************************************************************)

 function Q3Vector2D_Scale(const vector2D:TQ3Vector2D;scalar:float;result:TQ3Vector2D):TQ3Vector2D ; cdecl;
 function Q3Vector3D_Scale(const vector3D:TQ3Vector3D;scalar:float;result:TQ3Vector3D):TQ3Vector3D ; cdecl;

(******************************************************************************
 **																			 **
 **								Vector Length								 **
 **																			 **
 *****************************************************************************)

 function Q3Vector2D_Length(const vector2D:TQ3Vector2D):float; cdecl;
 function Q3Vector3D_Length(const vector3D:TQ3Vector3D):float; cdecl;

(******************************************************************************
 **																			 **
 **								Vector Normalize							 **
 **																			 **
 *****************************************************************************)

 function Q3Vector2D_Normalize(const vector2D:TQ3Vector2D;result:TQ3Vector2D):TQ3Vector2D ; cdecl;
 function Q3Vector3D_Normalize(const vector3D:TQ3Vector3D;result:TQ3Vector3D):TQ3Vector3D ; cdecl;

(******************************************************************************
 **																			 **
 **					Vector/Vector Addition and Subtraction					 **
 **																			 **
 *****************************************************************************)

 function Q3Vector2D_Add(const v1:TQ3Vector2D;const v2:TQ3Vector2D;result:TQ3Vector2D):TQ3Vector2D ; cdecl;
 function Q3Vector3D_Add(const v1:TQ3Vector3D;const v2:TQ3Vector3D;result:TQ3Vector3D):TQ3Vector3D ; cdecl;
 function Q3Vector2D_Subtract(const v1:TQ3Vector2D;const v2:TQ3Vector2D;result:TQ3Vector2D):TQ3Vector2D ; cdecl;
 function Q3Vector3D_Subtract(const v1:TQ3Vector3D;const v2:TQ3Vector3D;result:TQ3Vector3D):TQ3Vector3D ; cdecl;

(******************************************************************************
 **																			 **
 **								Cross Product								 **
 **																			 **
 *****************************************************************************)

 function Q3Vector2D_Cross(const v1:TQ3Vector2D;const v2:TQ3Vector2D):float; cdecl;
 function Q3Vector3D_Cross(const v1:TQ3Vector3D;const v2:TQ3Vector3D;result:TQ3Vector3D):TQ3Vector3D ; cdecl;
 function Q3Point3D_CrossProductTri(const point1:TQ3Point3D;const point2:TQ3Point3D;const point3:TQ3Point3D;crossVector:TQ3Vector3D):TQ3Vector3D ; cdecl;

(******************************************************************************
 **																			 **
 **								Dot Product									 **
 **																			 **
 *****************************************************************************)

 function Q3Vector2D_Dot(const v1:TQ3Vector2D;const v2:TQ3Vector2D):float; cdecl;
 function Q3Vector3D_Dot(const v1:TQ3Vector3D;const v2:TQ3Vector3D):float; cdecl;

(******************************************************************************
 **																			 **
 **						Point and Vector Transformation						 **
 **																			 **
 *****************************************************************************)

 function Q3Vector2D_Transform(const vector2D:TQ3Vector2D;const matrix3x3:TQ3Matrix3x3;result:TQ3Vector2D):TQ3Vector2D ; cdecl;
 function Q3Vector3D_Transform(const vector3D:TQ3Vector3D;const matrix4x4:TQ3Matrix4x4;result:TQ3Vector3D):TQ3Vector3D ; cdecl;
 function Q3Point2D_Transform(const point2D:TQ3Point2D;const matrix3x3:TQ3Matrix3x3;result:TQ3Point2D):TQ3Point2D ; cdecl;
 function Q3Param2D_Transform(const param2D:TQ3Param2D;const matrix3x3:TQ3Matrix3x3;result:TQ3Param2D):TQ3Param2D ; cdecl;
 function Q3Point3D_Transform(const point3D:TQ3Point3D;const matrix4x4:TQ3Matrix4x4;result:TQ3Point3D):TQ3Point3D ; cdecl;
 function Q3RationalPoint4D_Transform(const point4D:TQ3RationalPoint4D;const matrix4x4:TQ3Matrix4x4;result:TQ3RationalPoint4D):TQ3RationalPoint4D ; cdecl;
 function Q3Point3D_To3DTransformArray(const inPoint3D:TQ3Point3D;const matrix:TQ3Matrix4x4;outPoint3D:TQ3Point3D;numPoints:long;inStructSize:unsigned_long;outStructSize:unsigned_long):TQ3Status; cdecl;
 function Q3Point3D_To4DTransformArray(const inPoint3D:TQ3Point3D;const matrix:TQ3Matrix4x4;outPoint4D:TQ3RationalPoint4D;numPoints:long;inStructSize:unsigned_long;outStructSize:unsigned_long):TQ3Status; cdecl;
 function Q3RationalPoint4D_To4DTransformArray(const inPoint4D:TQ3RationalPoint4D;const matrix:TQ3Matrix4x4;outPoint4D:TQ3RationalPoint4D;numPoints:long;inStructSize:unsigned_long;outStructSize:unsigned_long):TQ3Status; cdecl;

(******************************************************************************
 **																			 **
 **								Vector Negation								 **
 **																			 **
 *****************************************************************************)

 function Q3Vector2D_Negate(const vector2D:TQ3Vector2D;result:TQ3Vector2D):TQ3Vector2D ; cdecl;
 function Q3Vector3D_Negate(const vector3D:TQ3Vector3D;result:TQ3Vector3D):TQ3Vector3D ; cdecl;

(******************************************************************************
 **																			 **
 **					Point conversion from cartesian to polar				 **
 **																			 **
 *****************************************************************************)

 function Q3Point2D_ToPolar(const point2D:TQ3Point2D;result:TQ3PolarPoint):TQ3PolarPoint ; cdecl;
 function Q3PolarPoint_ToPoint2D(const polarPoint:TQ3PolarPoint;result:TQ3Point2D):TQ3Point2D ; cdecl;
 function Q3Point3D_ToSpherical(const point3D:TQ3Point3D;result:TQ3SphericalPoint):TQ3SphericalPoint ; cdecl;
 function Q3SphericalPoint_ToPoint3D(const sphericalPoint:TQ3SphericalPoint;result:TQ3Point3D):TQ3Point3D ; cdecl;

(******************************************************************************
 **																			 **
 **							Point Affine Combinations						 **
 **																			 **
 *****************************************************************************)

 function Q3Point2D_AffineComb(const points2D:TQ3Point2D;const weights:float;nPoints:unsigned_long;result:TQ3Point2D):TQ3Point2D ; cdecl;
 function Q3Param2D_AffineComb(const params2D:TQ3Param2D;const weights:float;nPoints:unsigned_long;result:TQ3Param2D):TQ3Param2D ; cdecl;
 function Q3RationalPoint3D_AffineComb(const points3D:TQ3RationalPoint3D;const weights:float;numPoints:unsigned_long;result:TQ3RationalPoint3D):TQ3RationalPoint3D ; cdecl;
 function Q3Point3D_AffineComb(const points3D:TQ3Point3D;const weights:float;numPoints:unsigned_long;result:TQ3Point3D):TQ3Point3D ; cdecl;
 function Q3RationalPoint4D_AffineComb(const points4D:TQ3RationalPoint4D;const weights:float;numPoints:unsigned_long;result:TQ3RationalPoint4D):TQ3RationalPoint4D ; cdecl;

(******************************************************************************
 **																			 **
 **								Matrix Functions							 **
 **																			 **
 *****************************************************************************)

 function Q3Matrix3x3_Copy(const matrix3x3:TQ3Matrix3x3;result:TQ3Matrix3x3):TQ3Matrix3x3 ; cdecl;
 function Q3Matrix4x4_Copy(const matrix4x4:TQ3Matrix4x4;result:TQ3Matrix4x4):TQ3Matrix4x4 ; cdecl;
 function Q3Matrix3x3_SetIdentity(matrix3x3:TQ3Matrix3x3):TQ3Matrix3x3 ; cdecl;
 function Q3Matrix4x4_SetIdentity(matrix4x4:TQ3Matrix4x4):TQ3Matrix4x4 ; cdecl;
 function Q3Matrix3x3_Transpose(const matrix3x3:TQ3Matrix3x3;result:TQ3Matrix3x3):TQ3Matrix3x3 ; cdecl;
 function Q3Matrix4x4_Transpose(const matrix4x4:TQ3Matrix4x4;result:TQ3Matrix4x4):TQ3Matrix4x4 ; cdecl;
 function Q3Matrix3x3_Invert(const matrix3x3:TQ3Matrix3x3;result:TQ3Matrix3x3):TQ3Matrix3x3 ; cdecl;
 function Q3Matrix4x4_Invert(const matrix4x4:TQ3Matrix4x4;result:TQ3Matrix4x4):TQ3Matrix4x4 ; cdecl;
 function Q3Matrix3x3_Adjoint(const matrix3x3:TQ3Matrix3x3;result:TQ3Matrix3x3):TQ3Matrix3x3 ; cdecl;
 function Q3Matrix3x3_Multiply(const matrixA:TQ3Matrix3x3;const matrixB:TQ3Matrix3x3;result:TQ3Matrix3x3):TQ3Matrix3x3 ; cdecl;
 function Q3Matrix4x4_Multiply(const matrixA:TQ3Matrix4x4;const matrixB:TQ3Matrix4x4;result:TQ3Matrix4x4):TQ3Matrix4x4 ; cdecl;
 function Q3Matrix3x3_SetTranslate(matrix3x3:TQ3Matrix3x3;xTrans:float;yTrans:float):TQ3Matrix3x3 ; cdecl;
 function Q3Matrix3x3_SetScale(matrix3x3:TQ3Matrix3x3;xScale:float;yScale:float):TQ3Matrix3x3 ; cdecl;
 function Q3Matrix3x3_SetRotateAboutPoint(matrix3x3:TQ3Matrix3x3;const origin:TQ3Point2D;angle:float):TQ3Matrix3x3 ; cdecl;
 function Q3Matrix4x4_SetTranslate(matrix4x4:TQ3Matrix4x4;xTrans:float;yTrans:float;zTrans:float):TQ3Matrix4x4 ; cdecl;
 function Q3Matrix4x4_SetScale(matrix4x4:TQ3Matrix4x4;xScale:float;yScale:float;zScale:float):TQ3Matrix4x4 ; cdecl;
 function Q3Matrix4x4_SetRotateAboutPoint(matrix4x4:TQ3Matrix4x4;const origin:TQ3Point3D;xAngle:float;yAngle:float;zAngle:float):TQ3Matrix4x4 ; cdecl;
 function Q3Matrix4x4_SetRotateAboutAxis(matrix4x4:TQ3Matrix4x4;const origin:TQ3Point3D;const orientation:TQ3Vector3D;angle:float):TQ3Matrix4x4 ; cdecl;
 function Q3Matrix4x4_SetRotate_X(matrix4x4:TQ3Matrix4x4;angle:float):TQ3Matrix4x4 ; cdecl;
 function Q3Matrix4x4_SetRotate_Y(matrix4x4:TQ3Matrix4x4;angle:float):TQ3Matrix4x4 ; cdecl;
 function Q3Matrix4x4_SetRotate_Z(matrix4x4:TQ3Matrix4x4;angle:float):TQ3Matrix4x4 ; cdecl;
 function Q3Matrix4x4_SetRotate_XYZ(matrix4x4:TQ3Matrix4x4;xAngle:float;yAngle:float;zAngle:float):TQ3Matrix4x4 ; cdecl;
 function Q3Matrix4x4_SetRotateVectorToVector(matrix4x4:TQ3Matrix4x4;const v1:TQ3Vector3D;const v2:TQ3Vector3D):TQ3Matrix4x4 ; cdecl;
 function Q3Matrix4x4_SetQuaternion(matrix:TQ3Matrix4x4;const quaternion:TQ3Quaternion):TQ3Matrix4x4 ; cdecl;
 function Q3Matrix3x3_Determinant(const matrix3x3:TQ3Matrix3x3):float; cdecl;
 function Q3Matrix4x4_Determinant(const matrix4x4:TQ3Matrix4x4):float; cdecl;

(******************************************************************************
 **																			 **
 **								Quaternion Routines						     **
 **																			 **
 *****************************************************************************)

 function Q3Quaternion_Set(quaternion:TQ3Quaternion;w:float;x:float;y:float;z:float):TQ3Quaternion ; cdecl;
 function Q3Quaternion_SetIdentity(quaternion:TQ3Quaternion):TQ3Quaternion ; cdecl;
 function Q3Quaternion_Copy(const quaternion:TQ3Quaternion;result:TQ3Quaternion):TQ3Quaternion ; cdecl;
 function Q3Quaternion_IsIdentity(const quaternion:TQ3Quaternion):TQ3Boolean; cdecl;
 function Q3Quaternion_Invert(const quaternion:TQ3Quaternion;result:TQ3Quaternion):TQ3Quaternion ; cdecl;
 function Q3Quaternion_Normalize(const quaternion:TQ3Quaternion;result:TQ3Quaternion):TQ3Quaternion ; cdecl;
 function Q3Quaternion_Dot(const q1:TQ3Quaternion;const q2:TQ3Quaternion):float; cdecl;
 function Q3Quaternion_Multiply(const q1:TQ3Quaternion;const q2:TQ3Quaternion;result:TQ3Quaternion):TQ3Quaternion ; cdecl;
 function Q3Quaternion_SetRotateAboutAxis(quaternion:TQ3Quaternion;const axis:TQ3Vector3D;angle:float):TQ3Quaternion ; cdecl;
 function Q3Quaternion_SetRotate_XYZ(quaternion:TQ3Quaternion;xAngle:float;yAngle:float;zAngle:float):TQ3Quaternion ; cdecl;
 function Q3Quaternion_SetRotate_X(quaternion:TQ3Quaternion;angle:float):TQ3Quaternion ; cdecl;
 function Q3Quaternion_SetRotate_Y(quaternion:TQ3Quaternion;angle:float):TQ3Quaternion ; cdecl;
 function Q3Quaternion_SetRotate_Z(quaternion:TQ3Quaternion;angle:float):TQ3Quaternion ; cdecl;
 function Q3Quaternion_SetMatrix(quaternion:TQ3Quaternion;const matrix:TQ3Matrix4x4):TQ3Quaternion ; cdecl;
 function Q3Quaternion_SetRotateVectorToVector(quaternion:TQ3Quaternion;const v1:TQ3Vector3D;const v2:TQ3Vector3D):TQ3Quaternion ; cdecl;
 function Q3Quaternion_MatchReflection(const q1:TQ3Quaternion;const q2:TQ3Quaternion;result:TQ3Quaternion):TQ3Quaternion ; cdecl;
 function Q3Quaternion_InterpolateFast(const q1:TQ3Quaternion;const q2:TQ3Quaternion;t:float;result:TQ3Quaternion):TQ3Quaternion ; cdecl;
 function Q3Quaternion_InterpolateLinear(const q1:TQ3Quaternion;const q2:TQ3Quaternion;t:float;result:TQ3Quaternion):TQ3Quaternion ; cdecl;
 function Q3Vector3D_TransformQuaternion(const vector3D:TQ3Vector3D;const quaternion:TQ3Quaternion;result:TQ3Vector3D):TQ3Vector3D ; cdecl;
 function Q3Point3D_TransformQuaternion(const point3D:TQ3Point3D;const quaternion:TQ3Quaternion;result:TQ3Point3D):TQ3Point3D ; cdecl;

(******************************************************************************
 **																			 **
 **								Volume Routines							     **
 **																			 **
 *****************************************************************************)

 function Q3BoundingBox_Copy(const src:TQ3BoundingBox;dest:TQ3BoundingBox):TQ3BoundingBox ; cdecl;
 function Q3BoundingBox_Union(const v1:TQ3BoundingBox;const v2:TQ3BoundingBox;result:TQ3BoundingBox):TQ3BoundingBox ; cdecl;
 function Q3BoundingBox_Set(bBox:TQ3BoundingBox;const min:TQ3Point3D;const max:TQ3Point3D;isEmpty:TQ3Boolean):TQ3BoundingBox ; cdecl;
 function Q3BoundingBox_UnionPoint3D(const bBox:TQ3BoundingBox;const point3D:TQ3Point3D;result:TQ3BoundingBox):TQ3BoundingBox ; cdecl;
 function Q3BoundingBox_UnionRationalPoint4D(const bBox:TQ3BoundingBox;const point4D:TQ3RationalPoint4D;result:TQ3BoundingBox):TQ3BoundingBox ; cdecl;
 function Q3BoundingBox_SetFromPoints3D(bBox:TQ3BoundingBox;const points3D:TQ3Point3D;numPoints:unsigned_long;structSize:unsigned_long):TQ3BoundingBox ; cdecl;
 function Q3BoundingBox_SetFromRationalPoints4D(bBox:TQ3BoundingBox;const points4D:TQ3RationalPoint4D;numPoints:unsigned_long;structSize:unsigned_long):TQ3BoundingBox ; cdecl;

(******************************************************************************
 **																			 **
 **								Sphere Routines							     **
 **																			 **
 *****************************************************************************)

 function Q3BoundingSphere_Copy(const src:TQ3BoundingSphere;dest:TQ3BoundingSphere):TQ3BoundingSphere ; cdecl;
 function Q3BoundingSphere_Union(const s1:TQ3BoundingSphere;const s2:TQ3BoundingSphere;result:TQ3BoundingSphere):TQ3BoundingSphere ; cdecl;
 function Q3BoundingSphere_Set(bSphere:TQ3BoundingSphere;const origin:TQ3Point3D;radius:float;isEmpty:TQ3Boolean):TQ3BoundingSphere ; cdecl;
 function Q3BoundingSphere_UnionPoint3D(const bSphere:TQ3BoundingSphere;const point3D:TQ3Point3D;result:TQ3BoundingSphere):TQ3BoundingSphere ; cdecl;
 function Q3BoundingSphere_UnionRationalPoint4D(const bSphere:TQ3BoundingSphere;const point4D:TQ3RationalPoint4D;result:TQ3BoundingSphere):TQ3BoundingSphere ; cdecl;
 function Q3BoundingSphere_SetFromPoints3D(bSphere:TQ3BoundingSphere;const points3D:TQ3Point3D;numPoints:unsigned_long;structSize:unsigned_long):TQ3BoundingSphere ; cdecl;
 function Q3BoundingSphere_SetFromRationalPoints4D(bSphere:TQ3BoundingSphere;const points4D:TQ3RationalPoint4D;numPoints:unsigned_long;structSize:unsigned_long):TQ3BoundingSphere ; cdecl;

implementation

(******************************************************************************
 **																			 **
 **							Miscellaneous Functions							 **
 **																			 **
 *****************************************************************************)

function Q3Math_DegreesToRadians(x:float):float;
begin
 result:={float}(((x) *  kQ3Pi / 180.0));
end;

function Q3Math_RadiansToDegrees(x:float):float;
begin
 result:={float}((x) * 180.0 / kQ3Pi);
end;

function Q3Math_Min(x,y:float):float;
begin
 if x<=y then result:=x else result:=y;
end;

function Q3Math_Max(x,y:float):float;
begin
 if x>=y then result:=x else result:=y;
end;

(******************************************************************************
 **																			 **
 **							Point and Vector Creation						 **
 **																			 **
 *****************************************************************************)

function Q3Point2D_Set; cdecl; external 'qd3d.dll';
function Q3Param2D_Set; cdecl; external 'qd3d.dll';
function Q3Point3D_Set; cdecl; external 'qd3d.dll';
function Q3RationalPoint3D_Set; cdecl; external 'qd3d.dll';
function Q3RationalPoint4D_Set; cdecl; external 'qd3d.dll';
function Q3Vector2D_Set; cdecl; external 'qd3d.dll';
function Q3Vector3D_Set; cdecl; external 'qd3d.dll';
function Q3PolarPoint_Set; cdecl; external 'qd3d.dll';
function Q3SphericalPoint_Set; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **					Point and Vector Dimension Conversion					 **
 **																			 **
 *****************************************************************************)

function Q3Point2D_To3D; cdecl; external 'qd3d.dll';
function Q3RationalPoint3D_To2D; cdecl; external 'qd3d.dll';
function Q3Point3D_To4D; cdecl; external 'qd3d.dll';
function Q3RationalPoint4D_To3D; cdecl; external 'qd3d.dll';
function Q3Vector2D_To3D; cdecl; external 'qd3d.dll';
function Q3Vector3D_To2D; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **							Point Subtraction								 **
 **																			 **
 *****************************************************************************)

function Q3Point2D_Subtract; cdecl; external 'qd3d.dll';
function Q3Param2D_Subtract; cdecl; external 'qd3d.dll';
function Q3Point3D_Subtract; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **							Point Distance									 **
 **																			 **
 *****************************************************************************)

function Q3Point2D_Distance; cdecl; external 'qd3d.dll';
function Q3Point2D_DistanceSquared; cdecl; external 'qd3d.dll';
function Q3Param2D_Distance; cdecl; external 'qd3d.dll';
function Q3Param2D_DistanceSquared; cdecl; external 'qd3d.dll';
function Q3RationalPoint3D_Distance; cdecl; external 'qd3d.dll';
function Q3RationalPoint3D_DistanceSquared; cdecl; external 'qd3d.dll';
function Q3Point3D_Distance; cdecl; external 'qd3d.dll';
function Q3Point3D_DistanceSquared; cdecl; external 'qd3d.dll';
function Q3RationalPoint4D_Distance; cdecl; external 'qd3d.dll';
function Q3RationalPoint4D_DistanceSquared; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **							Point Relative Ratio							 **
 **																			 **
 *****************************************************************************)

function Q3Point2D_RRatio; cdecl; external 'qd3d.dll';
function Q3Param2D_RRatio; cdecl; external 'qd3d.dll';
function Q3Point3D_RRatio; cdecl; external 'qd3d.dll';
function Q3RationalPoint4D_RRatio; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **	Point / Vector Addition	& Subtraction				     **
 **																			 **
 *****************************************************************************)

function Q3Point2D_Vector2D_Add; cdecl; external 'qd3d.dll';
function Q3Param2D_Vector2D_Add; cdecl; external 'qd3d.dll';
function Q3Point3D_Vector3D_Add; cdecl; external 'qd3d.dll';
function Q3Point2D_Vector2D_Subtract; cdecl; external 'qd3d.dll';
function Q3Param2D_Vector2D_Subtract; cdecl; external 'qd3d.dll';
function Q3Point3D_Vector3D_Subtract; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **								Vector Scale								 **
 **																			 **
 *****************************************************************************)

function Q3Vector2D_Scale; cdecl; external 'qd3d.dll';
function Q3Vector3D_Scale; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **								Vector Length								 **
 **																			 **
 *****************************************************************************)

function Q3Vector2D_Length; cdecl; external 'qd3d.dll';
function Q3Vector3D_Length; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **								Vector Normalize							 **
 **																			 **
 *****************************************************************************)

function Q3Vector2D_Normalize; cdecl; external 'qd3d.dll';
function Q3Vector3D_Normalize; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **					Vector/Vector Addition and Subtraction					 **
 **																			 **
 *****************************************************************************)

function Q3Vector2D_Add; cdecl; external 'qd3d.dll';
function Q3Vector3D_Add; cdecl; external 'qd3d.dll';
function Q3Vector2D_Subtract; cdecl; external 'qd3d.dll';
function Q3Vector3D_Subtract; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **								Cross Product								 **
 **																			 **
 *****************************************************************************)

function Q3Vector2D_Cross; cdecl; external 'qd3d.dll';
function Q3Vector3D_Cross; cdecl; external 'qd3d.dll';
function Q3Point3D_CrossProductTri; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **								Dot Product									 **
 **																			 **
 *****************************************************************************)

function Q3Vector2D_Dot; cdecl; external 'qd3d.dll';
function Q3Vector3D_Dot; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **						Point and Vector Transformation						 **
 **																			 **
 *****************************************************************************)

function Q3Vector2D_Transform; cdecl; external 'qd3d.dll';
function Q3Vector3D_Transform; cdecl; external 'qd3d.dll';
function Q3Point2D_Transform; cdecl; external 'qd3d.dll';
function Q3Param2D_Transform; cdecl; external 'qd3d.dll';
function Q3Point3D_Transform; cdecl; external 'qd3d.dll';
function Q3RationalPoint4D_Transform; cdecl; external 'qd3d.dll';
function Q3Point3D_To3DTransformArray; cdecl; external 'qd3d.dll';
function Q3Point3D_To4DTransformArray; cdecl; external 'qd3d.dll';
function Q3RationalPoint4D_To4DTransformArray; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **								Vector Negation								 **
 **																			 **
 *****************************************************************************)

function Q3Vector2D_Negate; cdecl; external 'qd3d.dll';
function Q3Vector3D_Negate; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **					Point conversion from cartesian to polar				 **
 **																			 **
 *****************************************************************************)

function Q3Point2D_ToPolar; cdecl; external 'qd3d.dll';
function Q3PolarPoint_ToPoint2D; cdecl; external 'qd3d.dll';
function Q3Point3D_ToSpherical; cdecl; external 'qd3d.dll';
function Q3SphericalPoint_ToPoint3D; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **							Point Affine Combinations						 **
 **																			 **
 *****************************************************************************)

function Q3Point2D_AffineComb; cdecl; external 'qd3d.dll';
function Q3Param2D_AffineComb; cdecl; external 'qd3d.dll';
function Q3RationalPoint3D_AffineComb; cdecl; external 'qd3d.dll';
function Q3Point3D_AffineComb; cdecl; external 'qd3d.dll';
function Q3RationalPoint4D_AffineComb; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **								Matrix Functions							 **
 **																			 **
 *****************************************************************************)

function Q3Matrix3x3_Copy; cdecl; external 'qd3d.dll';
function Q3Matrix4x4_Copy; cdecl; external 'qd3d.dll';
function Q3Matrix3x3_SetIdentity; cdecl; external 'qd3d.dll';
function Q3Matrix4x4_SetIdentity; cdecl; external 'qd3d.dll';
function Q3Matrix3x3_Transpose; cdecl; external 'qd3d.dll';
function Q3Matrix4x4_Transpose; cdecl; external 'qd3d.dll';
function Q3Matrix3x3_Invert; cdecl; external 'qd3d.dll';
function Q3Matrix4x4_Invert; cdecl; external 'qd3d.dll';
function Q3Matrix3x3_Adjoint; cdecl; external 'qd3d.dll';
function Q3Matrix3x3_Multiply; cdecl; external 'qd3d.dll';
function Q3Matrix4x4_Multiply; cdecl; external 'qd3d.dll';
function Q3Matrix3x3_SetTranslate; cdecl; external 'qd3d.dll';
function Q3Matrix3x3_SetScale; cdecl; external 'qd3d.dll';
function Q3Matrix3x3_SetRotateAboutPoint; cdecl; external 'qd3d.dll';
function Q3Matrix4x4_SetTranslate; cdecl; external 'qd3d.dll';
function Q3Matrix4x4_SetScale; cdecl; external 'qd3d.dll';
function Q3Matrix4x4_SetRotateAboutPoint; cdecl; external 'qd3d.dll';
function Q3Matrix4x4_SetRotateAboutAxis; cdecl; external 'qd3d.dll';
function Q3Matrix4x4_SetRotate_X; cdecl; external 'qd3d.dll';
function Q3Matrix4x4_SetRotate_Y; cdecl; external 'qd3d.dll';
function Q3Matrix4x4_SetRotate_Z; cdecl; external 'qd3d.dll';
function Q3Matrix4x4_SetRotate_XYZ; cdecl; external 'qd3d.dll';
function Q3Matrix4x4_SetRotateVectorToVector; cdecl; external 'qd3d.dll';
function Q3Matrix4x4_SetQuaternion; cdecl; external 'qd3d.dll';
function Q3Matrix3x3_Determinant; cdecl; external 'qd3d.dll';
function Q3Matrix4x4_Determinant; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **								Quaternion Routines						     **
 **																			 **
 *****************************************************************************)

function Q3Quaternion_Set; cdecl; external 'qd3d.dll';
function Q3Quaternion_SetIdentity; cdecl; external 'qd3d.dll';
function Q3Quaternion_Copy; cdecl; external 'qd3d.dll';
function Q3Quaternion_IsIdentity; cdecl; external 'qd3d.dll';
function Q3Quaternion_Invert; cdecl; external 'qd3d.dll';
function Q3Quaternion_Normalize; cdecl; external 'qd3d.dll';
function Q3Quaternion_Dot; cdecl; external 'qd3d.dll';
function Q3Quaternion_Multiply; cdecl; external 'qd3d.dll';
function Q3Quaternion_SetRotateAboutAxis; cdecl; external 'qd3d.dll';
function Q3Quaternion_SetRotate_XYZ; cdecl; external 'qd3d.dll';
function Q3Quaternion_SetRotate_X; cdecl; external 'qd3d.dll';
function Q3Quaternion_SetRotate_Y; cdecl; external 'qd3d.dll';
function Q3Quaternion_SetRotate_Z; cdecl; external 'qd3d.dll';
function Q3Quaternion_SetMatrix; cdecl; external 'qd3d.dll';
function Q3Quaternion_SetRotateVectorToVector; cdecl; external 'qd3d.dll';
function Q3Quaternion_MatchReflection; cdecl; external 'qd3d.dll';
function Q3Quaternion_InterpolateFast; cdecl; external 'qd3d.dll';
function Q3Quaternion_InterpolateLinear; cdecl; external 'qd3d.dll';
function Q3Vector3D_TransformQuaternion; cdecl; external 'qd3d.dll';
function Q3Point3D_TransformQuaternion; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **								Volume Routines							     **
 **																			 **
 *****************************************************************************)

function Q3BoundingBox_Copy; cdecl; external 'qd3d.dll';
function Q3BoundingBox_Union; cdecl; external 'qd3d.dll';
function Q3BoundingBox_Set; cdecl; external 'qd3d.dll';
function Q3BoundingBox_UnionPoint3D; cdecl; external 'qd3d.dll';
function Q3BoundingBox_UnionRationalPoint4D; cdecl; external 'qd3d.dll';
function Q3BoundingBox_SetFromPoints3D; cdecl; external 'qd3d.dll';
function Q3BoundingBox_SetFromRationalPoints4D; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **								Sphere Routines							     **
 **																			 **
 *****************************************************************************)

function Q3BoundingSphere_Copy; cdecl; external 'qd3d.dll';
function Q3BoundingSphere_Union; cdecl; external 'qd3d.dll';
function Q3BoundingSphere_Set; cdecl; external 'qd3d.dll';
function Q3BoundingSphere_UnionPoint3D; cdecl; external 'qd3d.dll';
function Q3BoundingSphere_UnionRationalPoint4D; cdecl; external 'qd3d.dll';
function Q3BoundingSphere_SetFromPoints3D; cdecl; external 'qd3d.dll';
function Q3BoundingSphere_SetFromRationalPoints4D; cdecl; external 'qd3d.dll';

end.

