{************************************************************************}
{                                                       	             }
{       Borland Delphi Runtime Library                  		       }
{       QuickTime interface unit                                         }
{ 									                   }
{ Portions created by Apple Computer, Inc. are 					 }
{ Copyright (C) ????-1998 Apple Computer, Inc.. 			       }
{ All Rights Reserved. 							             }
{ 								                   	 }
{ The original file is: Gestalt.h, released dd Mmm yyyy. 		       }
{ The original Pascal code is: qt_Gestalt.pas, released 14 May 2000. 	 }
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

unit qt_Gestalt;

interface
 uses C_Types,qt_MacTypes;

 const gestaltQuickTimeVersion	= (((ord('q') shl 8+ ord('t'))shl 8 +ord('i'))shl 8 +ord('m')); {'qtim'} (* returns version of QuickTime *)
       gestaltQuickTime		= gestaltQuickTimeVersion; (* gestaltQuickTime is old name for gestaltQuickTimeVersion *)

 const gestaltQuickTimeFeatures	= (((ord('q') shl 8 +ord('t'))shl 8 +ord('r'))shl 8 +ord('s')); {'qtrs'}
       gestaltPPCQuickTimeLibPresent = 0; (* PowerPC QuickTime glue library is present *)

 const gestaltQTVRMgrAttr	       = (((ord('q') shl 8 +ord('t'))shl 8 +ord('v'))shl 8 +ord('r'));	{'qtvr'}	(* QuickTime VR attributes                               *)
       gestaltQTVRMgrPresent	       = 0;							                (* QTVR API is present                                   *)
       gestaltQTVRObjMoviesPresent     = 1;							                (* QTVR runtime knows about object movies                *)
       gestaltQTVRCylinderPanosPresent = 2;							                (* QTVR runtime knows about cylindrical panoramic movies *)

 const gestaltQTVRMgrVers = (((ord('q') shl 8 +ord('t'))shl 8 +ord('v'))shl 8 +ord('v')); {'qtvv'} (* QuickTime VR version                                  *)

 const gestaltPhysicalRAMSize = (((ord('r') shl 8 +ord('a'))shl 8 +ord('m'))shl 8 +ord(' ')); {'ram '}		(* physical RAM size *)

 function Gestalt(selector:OSType;var response:long):OSErr; cdecl;

implementation

 function Gestalt; cdecl; external 'QTMLClient.dll';

end.
