{************************************************************************}
{                                                       	             }
{       Borland Delphi Runtime Library                  		       }
{       QuickTime interface unit                                         }
{ 									                   }
{ Portions created by Apple Computer, Inc. are 					 }
{ Copyright (C) 1997-1998 Apple Computer, Inc.. 			       }
{ All Rights Reserved. 							             }
{ 								                   	 }
{ The original file is: QD3DView.h, released dd Mmm yyyy. 		       }
{ The original Pascal code is: qt_QD3DView.pas, released 14 May 2000. 	 }
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

//28Feb1999 - birbilis: using {$MINENUMSIZE 4} define
//14May2000 - birbilis: donated to Delphi-JEDI

unit qt_QD3DView;

{$MINENUMSIZE 4} //must use this and make C enums into Delphi enums and not subrange types

interface
 uses qt_QD3D,qt_QD3DStyle;

 (* View Type Definitions *)

 type TQ3ViewStatus=(
       kQ3ViewStatusDone	{= 0},
       kQ3ViewStatusRetraverse	{= 1},
       kQ3ViewStatusError	{= 2},
       kQ3ViewStatusCancelled	{= 3});

(* Default Attribute Set *)

 const kQ3ViewDefaultAmbientCoefficient=1.0;
       kQ3ViewDefaultDiffuseColor:TQ3ColorRGB=(r:0.5;g:0.5;b:0.5);
       kQ3ViewDefaultSpecularColor:TQ3ColorRGB=(r:0.5;g:0.5;b:0.5);
       kQ3ViewDefaultSpecularControl=4.0;
       kQ3ViewDefaultTransparency:TQ3ColorRGB=(r:1.0;g:1.0;b:1.0); //color???
       kQ3ViewDefaultHighlightState=kQ3Off;
       kQ3ViewDefaultHighlightColor:TQ3ColorRGB=(r:1.0;g:0.0;b:0.0); //color???
       kQ3ViewDefaultSubdivisionMethod=kQ3SubdivisionMethodConstant;
       kQ3ViewDefaultSubdivisionC1=10.0;
       kQ3ViewDefaultSubdivisionC2=10.0;

 type PQ3RendererObject=^TQ3RendererObject;
      PQ3BoundingBox=^TQ3BoundingBox;
      PQ3BoundingSphere=^TQ3BoundingSphere;
      PQ3CameraObject=^TQ3CameraObject;
      PQ3DrawContextObject=^TQ3DrawContextObject;
      PQ3GroupObject=^TQ3GroupObject;

 (* View Routines *)

 function Q3View_New:TQ3ViewObject; cdecl;
 function Q3View_Cancel(view:TQ3ViewObject):TQ3Status; cdecl;

 (* View Rendering routines *)

 function Q3View_SetRendererByType(view:TQ3ViewObject;theType:TQ3ObjectType):TQ3Status; cdecl;
 function Q3View_SetRenderer(view:TQ3ViewObject;renderer:TQ3RendererObject):TQ3Status; cdecl;
 function Q3View_GetRenderer(view:TQ3ViewObject;renderer:PQ3RendererObject):TQ3Status; cdecl;

 function Q3View_StartRendering(view:TQ3ViewObject):TQ3Status; cdecl;
 function Q3View_EndRendering(view:TQ3ViewObject):TQ3ViewStatus; cdecl;

 function Q3View_Flush(view:TQ3ViewObject):TQ3Status; cdecl;
 function Q3View_Sync(view:TQ3ViewObject):TQ3Status; cdecl;

 (* View/Bounds/Pick routines *)

 function Q3View_StartBoundingBox(view:TQ3ViewObject;computeBounds:TQ3ComputeBounds):TQ3Status; cdecl;
 function Q3View_EndBoundingBox(view:TQ3ViewObject;result:PQ3BoundingBox):TQ3ViewStatus; cdecl;

 function Q3View_StartBoundingSphere(view:TQ3ComputeBounds;computeBounds:TQ3ComputeBounds):TQ3Status; cdecl;
 function Q3View_EndBoundingSphere(view:TQ3ViewObject;result:PQ3BoundingSphere):TQ3ViewStatus; cdecl;

 function Q3View_StartPicking(view:TQ3ViewObject;pick:TQ3PickObject):TQ3Status; cdecl;
 function Q3View_EndPicking(view:TQ3ViewObject):TQ3ViewStatus; cdecl;

 (* View/Camera routines *)

 function Q3View_GetCamera(view:TQ3ViewObject;camera:PQ3CameraObject):TQ3Status; cdecl;
 function Q3View_SetCamera(view:TQ3ViewObject;camera:TQ3CameraObject):TQ3Status; cdecl;

 (* View/Lights routines *)

 function Q3View_SetLightGroup(view:TQ3ViewObject;lightGroup:TQ3GroupObject):TQ3Status; cdecl;
 function Q3View_GetLightGroup(view:TQ3ViewObject;lightGroup:PQ3GroupObject):TQ3Status; cdecl;

 (* DrawContext routines *)

 function Q3View_SetDrawContext(view:TQ3ViewObject;drawContext:TQ3DrawContextObject):TQ3Status; cdecl;
 function Q3View_GetDrawContext(view:TQ3ViewObject;drawContext:PQ3DrawContextObject):TQ3Status; cdecl;

implementation

 (* View Routines *)

 function Q3View_New; cdecl; external 'qd3d.dll';
 function Q3View_Cancel; cdecl; external 'qd3d.dll';

 (* View Rendering routines *)

 function Q3View_SetRendererByType; cdecl; external 'qd3d.dll';
 function Q3View_SetRenderer; cdecl; external 'qd3d.dll';
 function Q3View_GetRenderer; cdecl; external 'qd3d.dll';

 function Q3View_StartRendering; cdecl; external 'qd3d.dll';
 function Q3View_EndRendering; cdecl; external 'qd3d.dll';

 function Q3View_Flush; cdecl; external 'qd3d.dll';
 function Q3View_Sync; cdecl; external 'qd3d.dll';

 (* View/Bounds/Pick routines *)

 function Q3View_StartBoundingBox; cdecl; external 'qd3d.dll';
 function Q3View_EndBoundingBox; cdecl; external 'qd3d.dll';

 function Q3View_StartBoundingSphere; cdecl; external 'qd3d.dll';
 function Q3View_EndBoundingSphere; cdecl; external 'qd3d.dll';

 function Q3View_StartPicking; cdecl; external 'qd3d.dll';
 function Q3View_EndPicking; cdecl; external 'qd3d.dll';

 (* View/Camera routines *)

 function Q3View_GetCamera; cdecl; external 'qd3d.dll';
 function Q3View_SetCamera; cdecl; external 'qd3d.dll';

 (* View/Lights routines *)

 function Q3View_SetLightGroup; cdecl; external 'qd3d.dll';
 function Q3View_GetLightGroup; cdecl; external 'qd3d.dll';

 (* DrawContext routines *)

 function Q3View_SetDrawContext; cdecl; external 'qd3d.dll';
 function Q3View_GetDrawContext; cdecl; external 'qd3d.dll';

end.

