{************************************************************************}
{                                                       	             }
{       Borland Delphi Runtime Library                  		       }
{       QuickTime interface unit                                         }
{ 									                   }
{ Portions created by Apple Computer, Inc. are 					 }
{ Copyright (C) ????-1998 Apple Computer, Inc.. 			       }
{ All Rights Reserved. 							             }
{ 								                   	 }
{ The original file is: QD3DDrawContext.h, released dd Mmm yyyy. 		       }
{ The original Pascal code is: qt_QD3DDrawContext.pas, released 14 May 2000. 	 }
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

unit qt_QD3DDrawContext;

{$MINENUMSIZE 4} //must use this and make C enums into Delphi enums and not subrange types

interface
 uses qt_QD3D;

 (* DrawContext Data Structures *)

 type TQ3DrawContextClearImageMethod=(
       kQ3ClearMethodNone	{= 0},
       kQ3ClearMethodWithColor	{= 1});

       TQ3DrawContextData=packed record
	clearImageMethod:TQ3DrawContextClearImageMethod;
	clearImageColor:TQ3ColorARGB;
	pane:TQ3Area;
	paneState:TQ3Boolean;
	mask:TQ3Bitmap;
	maskState:TQ3Boolean;
	doubleBufferState:TQ3Boolean;
        end;

 (* Pixmap Data Structure *)

 type TQ3PixmapDrawContextData=packed record
       drawContextData:TQ3DrawContextData;
       pixmap:TQ3Pixmap;
       end;

 (* Pixmap DrawContext Routines *)

 type PQ3Pixmap=^TQ3Pixmap;
      PQ3PixmapDrawContextData=^TQ3PixmapDrawContextData;

 function Q3PixmapDrawContext_New(const contextData:PQ3PixmapDrawContextData):TQ3DrawContextObject; cdecl;
 function Q3PixmapDrawContext_SetPixmap(drawContext:TQ3DrawContextObject;const pixmap:PQ3Pixmap):TQ3Status; cdecl;
 function Q3PixmapDrawContext_GetPixmap(drawContext:TQ3DrawContextObject;pixmap:PQ3Pixmap):TQ3Status; cdecl;

implementation

 (* Pixmap DrawContext Routines *)

 function Q3PixmapDrawContext_New; cdecl; external 'qd3d.dll';
 function Q3PixmapDrawContext_SetPixmap; cdecl; external 'qd3d.dll';
 function Q3PixmapDrawContext_GetPixmap; cdecl; external 'qd3d.dll';

end.

