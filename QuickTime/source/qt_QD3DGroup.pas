{************************************************************************}
{                                                       	             }
{       Borland Delphi Runtime Library                  		       }
{       QuickTime interface unit                                         }
{ 									                   }
{ Portions created by Apple Computer, Inc. are 					 }
{ Copyright (C) ????-1998 Apple Computer, Inc.. 			       }
{ All Rights Reserved. 							             }
{ 								                   	 }
{ The original file is: QD3DGroup.h, released dd Mmm yyyy. 		       }
{ The original Pascal code is: qt_QD3DGroup.pas, released 14 May 2000. 	 }
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

unit qt_QD3DGroup;

interface
 uses C_Types,qt_QD3D;

(******************************************************************************
 **																			 **
 **	Group Typedefs							     **
 **																			 **
 *****************************************************************************)
(*
 * These flags affect how a group is traversed
 * They apply to when a group is "drawn", "picked", "bounded", "written"
 *)

 type TQ3DisplayGroupStateMasks=int; //Delphi: can't have it an enum, cause values aren't 0,1,2,3...
 const kQ3DisplayGroupStateNone	= 0;
       kQ3DisplayGroupStateMaskIsDrawn = 1 shl 0;
       kQ3DisplayGroupStateMaskIsInline = 1 shl 1;
       kQ3DisplayGroupStateMaskUseBoundingBox = 1 shl 2;
       kQ3DisplayGroupStateMaskUseBoundingSphere = 1 shl 3;
       kQ3DisplayGroupStateMaskIsPicked = 1 shl 4;
       kQ3DisplayGroupStateMaskIsWritten = 1 shl 5;

 type TQ3DisplayGroupState=unsigned_long;

 (* Group Routines (apply to all groups) *)

 type PQ3GroupPosition=^TQ3GroupPosition;

 function Q3Group_New:TQ3GroupObject; cdecl;
 function Q3Group_GetType(group:TQ3GroupObject):TQ3ObjectType; cdecl;
 function Q3Group_AddObject(group:TQ3GroupObject;_object:TQ3Object):TQ3GroupPosition; cdecl;
 function Q3Group_AddObjectBefore(group:TQ3GroupObject;position:TQ3GroupPosition;_object:TQ3Object):TQ3GroupPosition; cdecl;
 function Q3Group_AddObjectAfter(group:TQ3GroupObject;position:TQ3GroupPosition;_object:TQ3Object):TQ3GroupPosition; cdecl;
 function Q3Group_GetPositionObject(group:TQ3GroupObject;position:TQ3GroupPosition;_object:PQ3Object):TQ3Status; cdecl;
 function Q3Group_SetPositionObject(group:TQ3GroupObject;position:TQ3GroupPosition;_object:TQ3Object):TQ3Status; cdecl;
 function Q3Group_RemovePosition(group:TQ3GroupObject;position:TQ3GroupPosition):TQ3Object; cdecl;
 function Q3Group_GetFirstPosition(group:TQ3GroupObject;position:PQ3GroupPosition):TQ3Status; cdecl;
 function Q3Group_GetLastPosition(group:TQ3GroupObject;position:PQ3GroupPosition):TQ3Status; cdecl;
 function Q3Group_GetNextPosition(group:TQ3GroupObject;position:PQ3GroupPosition):TQ3Status; cdecl;
 function Q3Group_GetPreviousPosition(group:TQ3GroupObject;position:PQ3GroupPosition):TQ3Status; cdecl;
 function Q3Group_CountObjects(group:TQ3GroupObject;nObjects:unsigned_longPtr):TQ3Status; cdecl;
 function Q3Group_EmptyObjects(group:TQ3GroupObject):TQ3Status; cdecl;

 (* Group Subclasses *)

 function Q3LightGroup_New:TQ3GroupObject; cdecl;
 function Q3InfoGroup_New:TQ3GroupObject; cdecl;

(******************************************************************************
 **																			 **
 **	Display Group Routines						     **
 **																			 **
 *****************************************************************************)

 function Q3DisplayGroup_New:TQ3GroupObject; cdecl;
 function Q3DisplayGroup_GetType(group:TQ3GroupObject):TQ3ObjectType; cdecl;
 function Q3DisplayGroup_GetState(group:TQ3GroupObject;state:TQ3DisplayGroupState):TQ3Status; cdecl;
 function Q3DisplayGroup_SetState(group:TQ3GroupObject;state:TQ3DisplayGroupState):TQ3Status; cdecl;
 function Q3DisplayGroup_Submit(group:TQ3GroupObject;view:TQ3ViewObject):TQ3Status; cdecl;

implementation

(* Group Routines (apply to all groups) *)

function Q3Group_New; cdecl; external 'qd3d.dll';
function Q3Group_GetType; cdecl; external 'qd3d.dll';
function Q3Group_AddObject; cdecl; external 'qd3d.dll';
function Q3Group_AddObjectBefore; cdecl; external 'qd3d.dll';
function Q3Group_AddObjectAfter; cdecl; external 'qd3d.dll';
function Q3Group_GetPositionObject; cdecl; external 'qd3d.dll';
function Q3Group_SetPositionObject; cdecl; external 'qd3d.dll';
function Q3Group_RemovePosition; cdecl; external 'qd3d.dll';
function Q3Group_GetFirstPosition; cdecl; external 'qd3d.dll';
function Q3Group_GetLastPosition; cdecl; external 'qd3d.dll';
function Q3Group_GetNextPosition; cdecl; external 'qd3d.dll';
function Q3Group_GetPreviousPosition; cdecl; external 'qd3d.dll';
function Q3Group_CountObjects; cdecl; external 'qd3d.dll';
function Q3Group_EmptyObjects; cdecl; external 'qd3d.dll';

(* Group Subclasses *)

function Q3LightGroup_New; cdecl; external 'qd3d.dll';
function Q3InfoGroup_New; cdecl; external 'qd3d.dll';

(******************************************************************************
 **																			 **
 **	Display Group Routines						     **
 **																			 **
 *****************************************************************************)

function Q3DisplayGroup_New; cdecl; external 'qd3d.dll';
function Q3DisplayGroup_GetType; cdecl; external 'qd3d.dll';
function Q3DisplayGroup_GetState; cdecl; external 'qd3d.dll';
function Q3DisplayGroup_SetState; cdecl; external 'qd3d.dll';
function Q3DisplayGroup_Submit; cdecl; external 'qd3d.dll';

end.

