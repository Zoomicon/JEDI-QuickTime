{************************************************************************}
{                                                       	             }
{       Borland Delphi Runtime Library                  		       }
{       QuickTime interface unit                                         }
{ 									                   }
{ Portions created by Apple Computer, Inc. are 					 }
{ Copyright (C) 1997-1998 Apple Computer, Inc.. 			       }
{ All Rights Reserved. 							             }
{ 								                   	 }
{ The original file is: QD3DStyle.h, released dd Mmm yyyy. 		       }
{ The original Pascal code is: qt_QD3DStyle.pas, released 14 May 2000. 	 }
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

unit qt_QD3DStyle;

{$MINENUMSIZE 4} //must use this and make C enums into Delphi enums and not subrange types

interface
 uses C_Types,qt_QD3D;

(* Subdivision *)

 type TQ3SubdivisionMethod=(kQ3SubdivisionMethodConstant{=0},
                            kQ3SubdivisionMethodWorldSpace{=1},
                            kQ3SubdivisionMethodScreenSpace{=2});

      TQ3SubdivisionStyleData=packed record
       method:TQ3SubdivisionMethod;
       c1:float;
       c2:float;
       end;

 type PQ3SubdivisionStyleData=^TQ3SubdivisionStyleData;

 function Q3SubdivisionStyle_New(const data:PQ3SubdivisionStyleData):TQ3StyleObject; cdecl;
 function Q3SubdivisionStyle_Submit(const data:PQ3Status;view:TQ3ViewObject):TQ3Status; cdecl;
 function Q3SubdivisionStyle_SetData(subdiv:TQ3Status;const data:PQ3SubdivisionStyleData):TQ3Status; cdecl;
 function Q3SubdivisionStyle_GetData(subdiv:TQ3StyleObject;data:PQ3SubdivisionStyleData):TQ3Status; cdecl;

implementation

(* Subdivision *)

 function Q3SubdivisionStyle_New; cdecl; external 'qd3d.dll';
 function Q3SubdivisionStyle_Submit; cdecl; external 'qd3d.dll';
 function Q3SubdivisionStyle_SetData; cdecl; external 'qd3d.dll';
 function Q3SubdivisionStyle_GetData; cdecl; external 'qd3d.dll';


end.

