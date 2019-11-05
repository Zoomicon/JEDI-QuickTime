{************************************************************************}
{                                                       	             }
{       Borland Delphi Runtime Library                  		       }
{       QuickTime interface unit                                         }
{ 									                   }
{ Portions created by Apple Computer, Inc. are 					 }
{ Copyright (C) ????-1998 Apple Computer, Inc.. 			       }
{ All Rights Reserved. 							             }
{ 								                   	 }
{ The original file is: QD3DCamera.h, released dd Mmm yyyy. 		       }
{ The original Pascal code is: qt_QD3DCamera.pas, released 14 May 2000. 	 }
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

//28Feb1999 - birbilis: last known change before donation to Delphi-JEDI
//14May2000 - birbilis: donated to Delphi-JEDI

unit qt_QD3DCamera;

interface
 uses C_Types,qt_QD3D;

 (* Data packed recordure Definitions *)

(*
 *  The placement of the camera.
 *)

 type TQ3CameraPlacement=packed record
	cameraLocation:TQ3Point3D;  (*  Location point of the camera *)
	pointOfInterest:TQ3Point3D; (*  Point of interest *)
	upVector:TQ3Vector3D;       (*  "up" vector *)
        end;

(*
 *  The range of the camera.
 *)

 type TQ3CameraRange=packed record
	hither:float; (*  Hither plane, measured from "from" towards "to" *)
	yon:float;    (*  Yon  plane, measured from "from" towards "to" *)
        end;

(*
 *  Viewport specification.  Origin is (-1, 1), and corresponds to the
 *  upper left-hand corner; width and height maximum is (2.0, 2.0),
 *  corresponding to the lower left-hand corner of the window.  The
 *  TQ3Viewport specifies a part of the viewPlane that gets displayed
 *	on the window that is to be drawn.
 *  Normally, it is set with an origin of (-1.0, 1.0), and a width and
 *  height of both 2.0, specifying that the entire window is to be
 *  drawn.  If, for example, an exposure event of the window exposed
 *  the right half of the window, you would set the origin to (0, 1),
 *  and the width and height to (1.0) and (2.0), respectively.
 *
 *)

 type TQ3CameraViewPort=packed record
	origin:TQ3Point2D;
	width:float;
	height:float;
        end;

      TQ3CameraData=packed record
	placement:TQ3CameraPlacement;
	range:TQ3CameraRange;
	viewPort:TQ3CameraViewPort;
        end;

(*
 *  An orthographic camera.
 *
 *  The lens characteristics are set with the dimensions of a
 *  rectangular viewPort in the frame of the camera.
 *)

 type TQ3OrthographicCameraData=packed record
       cameraData:TQ3CameraData;
       left,
       top,
       right,
       bottom:float;
       end;

(*
 *  A perspective camera specified in terms of an arbitrary view plane.
 *
 *  This is most useful when setting the camera to look at a particular
 *  object.  The viewPlane is set to distance from the camera to the object.
 *  The halfWidth is set to half the width of the cross section of the object,
 *  and the halfHeight equal to the halfWidth divided by the aspect ratio
 *  of the viewPort.
 *
 *  This is the only perspective camera with specifications for off-axis
 *  viewing, which is desirable for scrolling.
 *)

 type TQ3ViewPlaneCameraData=packed record
	cameraData:TQ3CameraData;
        viewPlane,
        halfWidthAtViewPlane,
        halfHeightAtViewPlane,
        centerXOnViewPlane,
        centerYOnViewPlane:float;
        end;

(*
 *	A view angle aspect camera is a perspective camera specified in
 *	terms of the minimum view angle and the aspect ratio of X to Y.
 *
 *)

 type TQ3ViewAngleAspectCameraData=packed record
       cameraData:TQ3CameraData;
       fov:float;
       aspectRatioXToY:float;
       end;

 (* View Angle Aspect Camera *)

 type PQ3ViewAngleAspectCameraData=^TQ3ViewAngleAspectCameraData;

 function Q3ViewAngleAspectCamera_New(const cameraData:PQ3ViewAngleAspectCameraData):TQ3CameraObject; cdecl;
 function Q3ViewAngleAspectCamera_SetData(camera:TQ3CameraObject;const cameraData:PQ3ViewAngleAspectCameraData):TQ3Status; cdecl;
 function Q3ViewAngleAspectCamera_GetData(camera:TQ3CameraObject;cameraData:PQ3ViewAngleAspectCameraData):TQ3Status; cdecl;
 function Q3ViewAngleAspectCamera_SetFOV(camera:TQ3CameraObject;fov:float):TQ3Status; cdecl;
 function Q3ViewAngleAspectCamera_GetFOV(camera:TQ3CameraObject;fov:floatPtr):TQ3Status; cdecl;
 function Q3ViewAngleAspectCamera_SetAspectRatio(camera:TQ3CameraObject;aspectRatioXToY:float):TQ3Status; cdecl;
 function Q3ViewAngleAspectCamera_GetAspectRatio(camera:TQ3CameraObject;aspectRatioXToY:floatPtr):TQ3Status; cdecl;

implementation

 (* View Angle Aspect Camera *)

 function Q3ViewAngleAspectCamera_New; cdecl; external 'qd3d.dll';
 function Q3ViewAngleAspectCamera_SetData; cdecl; external 'qd3d.dll';
 function Q3ViewAngleAspectCamera_GetData; cdecl; external 'qd3d.dll';
 function Q3ViewAngleAspectCamera_SetFOV; cdecl; external 'qd3d.dll';
 function Q3ViewAngleAspectCamera_GetFOV; cdecl; external 'qd3d.dll';
 function Q3ViewAngleAspectCamera_SetAspectRatio; cdecl; external 'qd3d.dll';
 function Q3ViewAngleAspectCamera_GetAspectRatio; cdecl; external 'qd3d.dll';

end.

