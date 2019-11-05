{************************************************************************}
{                                                       	             }
{       Borland Delphi Runtime Library                  		       }
{       QuickTime interface unit                                         }
{ 									                   }
{ Portions created by Apple Computer, Inc. are 					 }
{ Copyright (C) 1992-1999 Apple Computer, Inc.. 			       }
{ All Rights Reserved. 							             }
{ 								                   	 }
{ The original file is: MixedMode.h, released dd Mmm yyyy. 		       }
{ The original Pascal code is: qt_MixedMode.pas, released 21 Jan 2002. 	 }
{ The initial developer of the Pascal code is George Birbilis            }
{ (birbilis@cti.gr).                     				             }
{ 									                   }
{ Portions created by George Birbilis are    				       }
{ Copyright (C) 2002 George Birbilis 					 }
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

//21Jan2002 - birbilis: first version
//02Feb2002 - birbilis: added some defines from the removed QuickTime.pas unit

unit qt_MixedMode;

interface
 uses qt_MacTypes;

 type
      ProcInfoType=cardinal;
      RoutineFlagsType=word;
      ISAType=Sint8;

      RoutineRecord=packed record
       procInfo:ProcInfoType; (* calling conventions *)
       reserved1:SInt8; (* Must be 0 *)
       ISA:ISAType; (* Instruction Set Architecture *)
       routineFlags:RoutineFlagsType; (* Flags for each routine *)
       procDescriptor:ProcPtr; (* Where is the thing we’re calling? *)
       reserved2:UInt32; (* Must be 0 *)
       selector:UInt32; (* For dispatched routines, the selector *)
       end;

      {RoutineDescriptor=packed record
       goMixedModeTrap:UInt16; (* Our A-Trap *)
       version:SInt8; (* Current Routine Descriptor version *)
       routineDescriptorFlags:RDFlagsType; (* Routine Descriptor Flags *)
       reserved1:UInt32; (* Unused, must be zero *)
       reserved2:UInt8; (* Unused, must be zero *)
       selectorInfo:UInt8; (* If a dispatched routine, calling convention, else 0 *)
       routineCount:UInt16; (* Number of routines in this RD *)
       routineRecords:array[0..0]of RoutineRecord; (* The individual routines *)
       end;}

 procedure DisposeRoutineDescriptor(proc:UniversalProcPtr);

implementation

 procedure DisposeRoutineDescriptor;
 begin
 //NOP
 end;

end.
