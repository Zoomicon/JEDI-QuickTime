{************************************************************************}
{                                                       	             }
{       Borland Delphi Runtime Library                  		       }
{       QuickTime interface unit                                         }
{ 									                   }
{ Portions created by Apple Computer, Inc. are 					 }
{ Copyright (C) ????-1998 Apple Computer, Inc.. 			       }
{ All Rights Reserved. 							             }
{ 								                   	 }
{ The original file is: QD3DGeometry.h, released dd Mmm yyyy. 		       }
{ The original Pascal code is: qt_QD3DGeometry.pas, released 14 May 2000. 	 }
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

//01Mar1999: birbilis: added the missing "origin" field to TQ3BoxData
//14May2000 - birbilis: donated to Delphi-JEDI

unit qt_QD3DGeometry;

interface
 uses C_Types,qt_QD3D;

 (* Box	Data Structure Definitions *)

 type TQ3AttributeSetArray=array[0..5] of TQ3AttributeSet; //Delphi
      PQ3AttributeSetArray=^TQ3AttributeSetArray; //Delphi

 type TQ3BoxData=packed record
       origin:TQ3Point3D;
       orientation:TQ3Vector3D;
       majorAxis:TQ3Vector3D;
       minorAxis:TQ3Vector3D;
       faceAttributeSet:PQ3AttributeSetArray; (* Ordering : Left, right, *) //Delphi: was TQ3AttributeSet* in C
                                              (*	    front, back, *)
                                              (*	    top, bottom  *)
       boxAttributeSet:TQ3AttributeSet;
       end;

(******************************************************************************
 **																			 **
 **	Box Routines							     **
 **																			 **
 *****************************************************************************)

 function Q3Box_New(const boxData:TQ3BoxData):TQ3GeometryObject; cdecl;
 function Q3Box_Submit(const boxData:TQ3BoxData;view:TQ3ViewObject):TQ3Status; cdecl;
 function Q3Box_SetData(box:TQ3GeometryObject;const boxData:TQ3BoxData):TQ3Status; cdecl;
 function Q3Box_GetData(box:TQ3GeometryObject;boxData:TQ3BoxData):TQ3Status; cdecl;
 function Q3Box_EmptyData(boxData:TQ3BoxData):TQ3Status; cdecl;
 function Q3Box_SetOrigin(box:TQ3GeometryObject;const origin:TQ3Point3D):TQ3Status; cdecl;
 function Q3Box_SetOrientation(box:TQ3GeometryObject;const orientation:TQ3Vector3D):TQ3Status; cdecl;
 function Q3Box_SetMajorAxis(box:TQ3GeometryObject;const majorAxis:TQ3Vector3D):TQ3Status; cdecl;
 function Q3Box_SetMinorAxis(box:TQ3GeometryObject;const minorAxis:TQ3Vector3D):TQ3Status; cdecl;
 function Q3Box_GetOrigin(box:TQ3GeometryObject;origin:TQ3Point3D):TQ3Status; cdecl;
 function Q3Box_GetOrientation(box:TQ3GeometryObject;orientation:TQ3Vector3D):TQ3Status; cdecl;
 function Q3Box_GetMajorAxis(box:TQ3GeometryObject;majorAxis:TQ3Vector3D):TQ3Status; cdecl;
 function Q3Box_GetMinorAxis(box:TQ3GeometryObject;minorAxis:TQ3Vector3D):TQ3Status; cdecl;
 function Q3Box_GetFaceAttributeSet(box:TQ3GeometryObject;faceIndex:unsigned_long;faceAttributeSet:TQ3AttributeSet):TQ3Status; cdecl;
 function Q3Box_SetFaceAttributeSet(box:TQ3GeometryObject;faceIndex:unsigned_long;faceAttributeSet:TQ3AttributeSet):TQ3Status; cdecl;

implementation

(******************************************************************************
 **																			 **
 **	Box Routines							     **
 **																			 **
 *****************************************************************************)

function Q3Box_New; cdecl; external 'qd3d.dll';
function Q3Box_Submit; cdecl; external 'qd3d.dll';
function Q3Box_SetData; cdecl; external 'qd3d.dll';
function Q3Box_GetData; cdecl; external 'qd3d.dll';
function Q3Box_EmptyData; cdecl; external 'qd3d.dll';
function Q3Box_SetOrigin; cdecl; external 'qd3d.dll';
function Q3Box_SetOrientation; cdecl; external 'qd3d.dll';
function Q3Box_SetMajorAxis; cdecl; external 'qd3d.dll';
function Q3Box_SetMinorAxis; cdecl; external 'qd3d.dll';
function Q3Box_GetOrigin; cdecl; external 'qd3d.dll';
function Q3Box_GetOrientation; cdecl; external 'qd3d.dll';
function Q3Box_GetMajorAxis; cdecl; external 'qd3d.dll';
function Q3Box_GetMinorAxis; cdecl; external 'qd3d.dll';
function Q3Box_GetFaceAttributeSet; cdecl; external 'qd3d.dll';
function Q3Box_SetFaceAttributeSet; cdecl; external 'qd3d.dll';

end.

