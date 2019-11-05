{************************************************************************}
{                                                       	             }
{       Borland Delphi Runtime Library                  		       }
{       QuickTime interface unit                                         }
{ 									                   }
{ Portions created by Apple Computer, Inc. are 					 }
{ Copyright (C) ????-1998 Apple Computer, Inc.. 			       }
{ All Rights Reserved. 							             }
{ 								                   	 }
{ The original file is: Components.h, released dd Mmm yyyy. 		       }
{ The original Pascal code is: qt_Components.pas, released 14 May 2000. 	 }
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
//21Jan2001 - birbilis: added more stuff

unit qt_Components;

interface
 uses C_Types,qt_MacTypes;

 //Components.h//

 const kAppleManufacturer		= (((ord('a') shl 8 +ord('p'))shl 8 +ord('p'))shl 8 +ord('l')); {'appl'} (* Apple supplied components *)
       kComponentResourceType		= (((ord('t') shl 8 +ord('h'))shl 8 +ord('n'))shl 8 +ord('g')); {'thng'} (* a components resource type *)
       kComponentAliasResourceType	= (((ord('t') shl 8 +ord('h'))shl 8 +ord('g'))shl 8 +ord('a')); {'thga'} (* component alias resource type *)

 const kAnyComponentType		= 0;
       kAnyComponentSubType		= 0;
       kAnyComponentManufacturer	= 0;
       kAnyComponentFlagsMask		= 0;

 type ComponentRecord=packed record
       data:array[0..0]of long;
       end;
      Component=^ComponentRecord;
      ComponentInstanceRecord=packed record
       data:array[0..0]of long;
       end;
      ComponentInstance=^ComponentInstanceRecord;
      ComponentResult=long;

 type
  ComponentDescription=packed record
   componentType:OSType; (* A unique 4-byte code indentifying the command set *)
   componentSubType:OSType; (* Particular flavor of this instance *)
   componentManufacturer:OSType; (* Vendor indentification *)
   componentFlags:unsigned_long; (* 8 each for Component,Type,SubType,Manuf/revision *)
   componentFlagsMask:unsigned_long; (* Mask for specifying which flags to consider in search, zero during registration *)
   end;


(********************************************************
*							*
*  	       APPLICATION LEVEL CALLS	                *
*							*
********************************************************)

(********************************************************
* Component Database Add, Delete, and Query Routines
********************************************************)

 //function RegisterComponent(var cd:ComponentDescription;componentEntryPoint:ComponentRoutineUPP;global:short;componentName:Handle;componentInfo:Handle;componentIcon:Handle):Component; cdecl; external 'qtmlClient.dll';
 //function RegisterComponentResource(cr:ComponentResourceHandle;global:short):Component; cdecl; external 'qtmlClient.dll';
 function UnregisterComponent(aComponent:Component):OSErr; cdecl; external 'qtmlClient.dll';
 function FindNextComponent(aComponent:Component;var looking:ComponentDescription):Component; cdecl; external 'qtmlClient.dll';
 function CountComponents(var looking:ComponentDescription):long; cdecl; external 'qtmlClient.dll';
 function GetComponentInfo(aComponent:Component;var cd:ComponentDescription;componentName:Handle;componentInfo:Handle;componentIcon:Handle):OSErr; cdecl; external 'qtmlClient.dll';
 function GetComponentListModSeed:long; cdecl; external 'qtmlClient.dll';
 function GetComponentTypeModSeed(componentType:OSType):long; cdecl; external 'qtmlClient.dll';

(********************************************************
* Component Instance Allocation and dispatch routines
********************************************************)

 function OpenAComponent(aComponent:Component;var ci:ComponentInstance):OSErr; cdecl; external 'qtmlClient.dll';
 function OpenComponent(aComponent:Component):ComponentInstance; cdecl; external 'qtmlClient.dll';
 function CloseComponent(aComponentInstance:ComponentInstance):OSErr; cdecl; external 'qtmlClient.dll';
 function GetComponentInstanceError(aComponentInstance:ComponentInstance):OSErr; cdecl; external 'qtmlClient.dll';


(********************************************************
*							*
*               CALLS MADE BY COMPONENTS                *
*							*
********************************************************)

(********************************************************
* Component Management routines
********************************************************)

 procedure SetComponentInstanceError(aComponentInstance:ComponentInstance;theError:OSErr); cdecl; external 'qtmlClient.dll';
 function GetComponentRefcon(aComponent:Component):long; cdecl; external 'qtmlClient.dll';
 procedure SetComponentRefcon(aComponent:Component;theRefcon:long); cdecl; external 'qtmlClient.dll';
 function OpenComponentResFile(aComponent:Component):short; cdecl; external 'qtmlClient.dll';
 function OpenAComponentResFile(aComponent:Component;var resRef:short):OSErr; cdecl; external 'qtmlClient.dll';
 function CloseComponentResFile(refnum:short):OSErr; cdecl; external 'qtmlClient.dll';
 function GetComponentResource(aComponent:Component;resType:OSType;resID:short;var theResource:Handle):OSErr; cdecl; external 'qtmlClient.dll';
 function GetComponentIndString(aComponent:Component;theString:Str255;strListID:short;index:short):OSErr; cdecl; external 'qtmlClient.dll';
 function GetComponentPublicResource(aComponent:Component;resourceType:OSType;resourceID:short;var theResource:Handle):OSErr; cdecl; external 'qtmlClient.dll';
 //function GetComponentPublicResourceList(resourceType:OSType;resourceID:short;flags:long;var cd:ComponentDescription;missingProc:GetMissingComponentResourceUPP;var refCon;var atomContainerPtr):OSErr; cdecl; external 'qtmlClient.dll';
 function ResolveComponentAlias(aComponent:Component):Component; cdecl; external 'qtmlClient.dll';
 function GetComponentPublicIndString(aComponent:Component;theString:Str255;strListID:short;index:short):OSErr; cdecl; external 'qtmlClient.dll';

(********************************************************
* Component Instance Management routines
********************************************************)

 function GetComponentInstanceStorage(aComponentInstance:ComponentInstance):Handle; cdecl; external 'qtmlClient.dll';
 procedure SetComponentInstanceStorage(aComponentInstance:ComponentInstance;theStorage:Handle); cdecl; external 'qtmlClient.dll';
 function GetComponentInstanceA5(aComponentInstance:ComponentInstance):long; cdecl; external 'qtmlClient.dll';
 procedure SetComponentInstanceA5(aComponentInstance:ComponentInstance;theA5:long); cdecl; external 'qtmlClient.dll';
 function CountComponentInstances(aComponent:Component):long; cdecl; external 'qtmlClient.dll';

 //...

 function OpenDefaultComponent(componentType:OSType;componentSubType:OSType):ComponentInstance; cdecl; external 'qtmlClient.dll';

implementation

end.
