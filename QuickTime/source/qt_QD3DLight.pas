{************************************************************************}
{                                                       	             }
{       Borland Delphi Runtime Library                  		       }
{       QuickTime interface unit                                         }
{ 									                   }
{ Portions created by Apple Computer, Inc. are 					 }
{ Copyright (C) ????-1998 Apple Computer, Inc.. 			       }
{ All Rights Reserved. 							             }
{ 								                   	 }
{ The original file is: QD3DLight.h, released dd Mmm yyyy. 		       }
{ The original Pascal code is: qt_QD3DLight.pas, released 14 May 2000. 	 }
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

unit qt_QD3DLight;

{$MINENUMSIZE 4} //must use this and make C enums into Delphi enums and not subrange types

interface
 uses C_Types,qt_QD3D;

 (* Enum Definitions *)

 type TQ3AttenuationType=(
       kQ3AttenuationTypeNone		        {= 0},
       kQ3AttenuationTypeInverseDistance        {= 1},
       kQ3AttenuationTypeInverseDistanceSquared {= 2});

 type TQ3FallOffType=(
       kQ3FallOffTypeNone		{= 0},
       kQ3FallOffTypeLinear		{= 1},
       kQ3FallOffTypeExponential	{= 2},
       kQ3FallOffTypeCosine		{= 3});

 (* Data Structure Definitions *)

 type TQ3LightData=packed record
       isOn:TQ3Boolean;
       brightness:float;
       color:TQ3ColorRGB;
       end;

      TQ3DirectionalLightData=packed record
       lightData:TQ3LightData;
       castsShadows:TQ3Boolean;
       direction:TQ3Vector3D;
       end;

      TQ3PointLightData=packed record
       lightData:TQ3LightData;
       castsShadows:TQ3Boolean;
       attenuation:TQ3AttenuationType;
       location:TQ3Point3D;
       end;

      TQ3SpotLightData=packed record
       lightData:TQ3LightData;
       castsShadows:TQ3Boolean;
       attenuation:TQ3AttenuationType;
       location:TQ3Point3D;
       direction:TQ3Vector3D;
       hotAngle:float;
       outerAngle:float;
       fallOff:TQ3FallOffType;
       end;

(******************************************************************************
 **
 **	Specific Light Routines
 **
 *****************************************************************************)

 (* Ambient Light *)

 type PQ3LightData=^TQ3LightData;

 function Q3AmbientLight_New(const lightData:PQ3LightData):TQ3LightObject; cdecl;
 function Q3AmbientLight_GetData(light:TQ3LightObject;lightData:PQ3LightData):TQ3Status; cdecl;
 function Q3AmbientLight_SetData(light:TQ3LightObject;const lightData:PQ3LightData):TQ3Status; cdecl;

 (* Directional Light *)

 type PQ3DirectionalLightData=^TQ3DirectionalLightData;

 function Q3DirectionalLight_New(const directionalLightData:PQ3DirectionalLightData):TQ3LightObject; cdecl;
 function Q3DirectionalLight_GetCastShadowsState(light:TQ3LightObject;castsShadows:PQ3Boolean):TQ3Status; cdecl;
 function Q3DirectionalLight_GetDirection(light:TQ3LightObject;direction:PQ3Vector3D):TQ3Status; cdecl;
 function Q3DirectionalLight_SetCastShadowsState(light:TQ3LightObject;castsShadows:TQ3Boolean):TQ3Status; cdecl;
 function Q3DirectionalLight_SetDirection(light:TQ3LightObject;const direction:PQ3Vector3D):TQ3Status; cdecl;
 function Q3DirectionalLight_GetData(light:TQ3LightObject;directionalLightData:PQ3DirectionalLightData):TQ3Status; cdecl;
 function Q3DirectionalLight_SetData(light:TQ3LightObject;const directionalLightData:PQ3DirectionalLightData):TQ3Status; cdecl;

 (* Point Light	*)

 type PQ3PointLightData=^TQ3PointLightData;
      PQ3AttenuationType=^TQ3AttenuationType;

 function Q3PointLight_New(const pointLightData:PQ3PointLightData):TQ3LightObject; cdecl;
 function Q3PointLight_GetCastShadowsState(light:TQ3LightObject;castsShadows:PQ3Boolean):TQ3Status; cdecl;
 function Q3PointLight_GetAttenuation(light:TQ3LightObject;attenuation:PQ3AttenuationType):TQ3Status; cdecl;
 function Q3PointLight_GetLocation(light:TQ3LightObject;location:PQ3Point3D):TQ3Status; cdecl;
 function Q3PointLight_GetData(light:TQ3LightObject;pointLightData:PQ3PointLightData):TQ3Status; cdecl;
 function Q3PointLight_SetCastShadowsState(light:TQ3LightObject;castsShadows:TQ3Boolean):TQ3Status; cdecl;
 function Q3PointLight_SetAttenuation(light:TQ3LightObject;attenuation:TQ3AttenuationType):TQ3Status; cdecl;
 function Q3PointLight_SetLocation(light:TQ3LightObject;const location:PQ3Point3D):TQ3Status; cdecl;
 function Q3PointLight_SetData(light:TQ3LightObject;const pointLightData:PQ3PointLightData):TQ3Status; cdecl;

 (* Spot Light *)

 type PQ3SpotLightData=^TQ3SpotLightData; //Delphi
      PQ3FallOffType=^TQ3FallOffType; //Delphi

 function Q3SpotLight_New(const spotLightData:PQ3SpotLightData):TQ3LightObject; cdecl;
 function Q3SpotLight_GetCastShadowsState(light:TQ3LightObject;castsShadows:PQ3Boolean):TQ3Status; cdecl;
 function Q3SpotLight_GetAttenuation(light:TQ3LightObject;attenuation:PQ3AttenuationType):TQ3Status; cdecl;
 function Q3SpotLight_GetLocation(light:TQ3LightObject;location:PQ3Point3D):TQ3Status; cdecl;
 function Q3SpotLight_GetDirection(light:TQ3LightObject;direction:PQ3Vector3D):TQ3Status; cdecl;
 function Q3SpotLight_GetHotAngle(light:TQ3LightObject;hotAngle:floatPtr):TQ3Status; cdecl;
 function Q3SpotLight_GetOuterAngle(light:TQ3LightObject;outerAngle:floatPtr):TQ3Status; cdecl;
 function Q3SpotLight_GetFallOff(light:TQ3LightObject;fallOff:PQ3FallOffType):TQ3Status; cdecl;
 function Q3SpotLight_GetData(light:TQ3LightObject;spotLightData:PQ3SpotLightData):TQ3Status; cdecl;
 function Q3SpotLight_SetCastShadowsState(light:TQ3LightObject;castsShadows:TQ3Boolean):TQ3Status; cdecl;
 function Q3SpotLight_SetAttenuation(light:TQ3LightObject;attenuation:TQ3AttenuationType):TQ3Status; cdecl;
 function Q3SpotLight_SetLocation(light:TQ3LightObject;const location:PQ3Point3D):TQ3Status; cdecl;
 function Q3SpotLight_SetDirection(light:TQ3LightObject;const direction:PQ3Vector3D):TQ3Status; cdecl;
 function Q3SpotLight_SetHotAngle(light:TQ3LightObject;hotAngle:float):TQ3Status; cdecl;
 function Q3SpotLight_SetOuterAngle(light:TQ3LightObject;outerAngle:float):TQ3Status; cdecl;
 function Q3SpotLight_SetFallOff(light:TQ3LightObject;fallOff:TQ3FallOffType):TQ3Status; cdecl;
 function Q3SpotLight_SetData(light:TQ3LightObject;const spotLightData:PQ3SpotLightData):TQ3Status; cdecl;

implementation

(* Ambient Light *)

function Q3AmbientLight_New; cdecl; external 'qd3d.dll';
function Q3AmbientLight_GetData; cdecl; external 'qd3d.dll';
function Q3AmbientLight_SetData; cdecl; external 'qd3d.dll';

(* Directional Light *)

function Q3DirectionalLight_New; cdecl; external 'qd3d.dll';
function Q3DirectionalLight_GetCastShadowsState; cdecl; external 'qd3d.dll';
function Q3DirectionalLight_GetDirection; cdecl; external 'qd3d.dll';
function Q3DirectionalLight_SetCastShadowsState; cdecl; external 'qd3d.dll';
function Q3DirectionalLight_SetDirection; cdecl; external 'qd3d.dll';
function Q3DirectionalLight_GetData; cdecl; external 'qd3d.dll';
function Q3DirectionalLight_SetData; cdecl; external 'qd3d.dll';

(* Point Light	*)

function Q3PointLight_New; cdecl; external 'qd3d.dll';
function Q3PointLight_GetCastShadowsState; cdecl; external 'qd3d.dll';
function Q3PointLight_GetAttenuation; cdecl; external 'qd3d.dll';
function Q3PointLight_GetLocation; cdecl; external 'qd3d.dll';
function Q3PointLight_GetData; cdecl; external 'qd3d.dll';
function Q3PointLight_SetCastShadowsState; cdecl; external 'qd3d.dll';
function Q3PointLight_SetAttenuation; cdecl; external 'qd3d.dll';
function Q3PointLight_SetLocation; cdecl; external 'qd3d.dll';
function Q3PointLight_SetData; cdecl; external 'qd3d.dll';

(* Spot Light *)

function Q3SpotLight_New; cdecl; external 'qd3d.dll';
function Q3SpotLight_GetCastShadowsState; cdecl; external 'qd3d.dll';
function Q3SpotLight_GetAttenuation; cdecl; external 'qd3d.dll';
function Q3SpotLight_GetLocation; cdecl; external 'qd3d.dll';
function Q3SpotLight_GetDirection; cdecl; external 'qd3d.dll';
function Q3SpotLight_GetHotAngle; cdecl; external 'qd3d.dll';
function Q3SpotLight_GetOuterAngle; cdecl; external 'qd3d.dll';
function Q3SpotLight_GetFallOff; cdecl; external 'qd3d.dll';
function Q3SpotLight_GetData; cdecl; external 'qd3d.dll';
function Q3SpotLight_SetCastShadowsState; cdecl; external 'qd3d.dll';
function Q3SpotLight_SetAttenuation; cdecl; external 'qd3d.dll';
function Q3SpotLight_SetLocation; cdecl; external 'qd3d.dll';
function Q3SpotLight_SetDirection; cdecl; external 'qd3d.dll';
function Q3SpotLight_SetHotAngle; cdecl; external 'qd3d.dll';
function Q3SpotLight_SetOuterAngle; cdecl; external 'qd3d.dll';
function Q3SpotLight_SetFallOff; cdecl; external 'qd3d.dll';
function Q3SpotLight_SetData; cdecl; external 'qd3d.dll';

end.

