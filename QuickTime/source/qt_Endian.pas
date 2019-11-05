{************************************************************************}
{                                                       	         }
{       Borland Delphi Runtime Library                  		 }
{       QuickTime interface unit                                         }
{ 									 }
{ Portions created by Apple Computer, Inc. are 				 }
{ Copyright (C) ????-1998 Apple Computer, Inc.. 			 }
{ All Rights Reserved. 							 }
{ 								         }
{ The original file is: Endian.h, released dd Mmm yyyy. 		 }
{ The original Pascal code is: qt_Endian.pas, released 14 May 2000. 	 }
{ The initial developer of the Pascal code is George Birbilis            }
{ (birbilis@cti.gr).                     				 }
{ 									 }
{ Portions created by George Birbilis are    				 }
{ Copyright (C) 1998-2000 George Birbilis 				 }
{ 									 }
{       Obtained through:                               		 }
{ 									 }
{       Joint Endeavour of Delphi Innovators (Project JEDI)              }
{									 }
{ You may retrieve the latest version of this file at the Project        }
{ JEDI home page, located at http://delphi-jedi.org                      }
{									 }
{ The contents of this file are used with permission, subject to         }
{ the Mozilla Public License Version 1.1 (the "License"); you may        }
{ not use this file except in compliance with the License. You may       }
{ obtain a copy of the License at                                        }
{ http://www.mozilla.org/MPL/MPL-1.1.html 	                         }
{ 									 }
{ Software distributed under the License is distributed on an 	         }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or         }
{ implied. See the License for the specific language governing           }
{ rights and limitations under the License. 				 }
{ 									 }
{************************************************************************}

//30Mar1999 - birbilis: last known change before donation to Delphi-JEDI
//14May2000 - birbilis: donated to Delphi-JEDI
//18Jun2002 - birbilis: newer version based on QT 5.0.1 SDK
//07Aug2004 - birbilis: removed "uses Dialogs" clause

(*
     File:       Endian.h

     Contains:   QuickTime Interfaces

     Version:    Technology: QuickTime 3.0
                 Release:    QuickTime 5.0.1

     Copyright:  (c) 1997-2001 by Apple Computer, Inc., all rights reserved

     Bugs?:      For bug reports, consult the following page on
                 the World Wide Web:

                     http://developer.apple.com/bugreporter/

*)

unit qt_Endian;

// Delphi showed the message 'A device attatched to the system is not functioning'
// This is usually shown when a wrong entry point is used in a DLL (use TDUMP to see the correct name of the proc) and couldn't load the QT4Delphi package... so not importing Endian procs for now

interface
 uses C_Types,
      qt_MacTypes,qt_FixMath;

{$define TARGET_RT_LITTLE_ENDIAN} //in C it's defined in ConditionalMacros.h (maybe create a ConditionalMacros.inc for Pascal and include wherever it's needed)

(*
    This file provides Endian Flipping routines for dealing with converting data
    between Big-Endian and Little-Endian machines.  These routines are useful
    when writing code to compile for both Big and Little Endian machines and
    which must handle other endian number formats, such as reading or writing
    to a file or network packet.

    These routines are named as follows:

        Endian<U><W>_<S>to<D>

    where
        <U> is whether the integer is signed ('S') or unsigned ('U')
        <W> is integer bit width: 16, 32, or 64
        <S> is the source endian format: 'B' for big, 'L' for little, or 'N' for native
        <D> is the destination endian format: 'B' for big, 'L' for little, or 'N' for native

    For example, to convert a Big Endian 32-bit unsigned integer to the current native format use:
        
        long i = EndianU32_BtoN(data);

    This file is set up so that the function macro to nothing when the target runtime already
    is the desired format (e.g. on Big Endian machines, EndianU32_BtoN() macros away).

    If long long's are not supported, you cannot get 64-bit quantities as a single value.
    The macros are not defined in that case.
    
    
    
                                <<< W A R N I N G >>>
    
    It is very important not to put any autoincrements inside the macros.  This 
    will produce erroneous results because each time the address is accessed in the macro, 
    the increment occurs.

 *)
(*
   Note: These functions are currently not implemented in any library
         and are only listed here as function prototypes to document the macros
*)

//...

(*
   These types are used for structures that contain data that is
   always in BigEndian format.  This extra typing prevents little
   endian code from directly changing the data, thus saving much
   time in the debugger.
*)

{$ifdef TARGET_RT_LITTLE_ENDIAN}

 type

  BigEndianLong=packed record
   bigEndianValue:long;
   end;

  BigEndianUnsignedLong=packed record
   bigEndianValue:unsigned_long;
   end;

  BigEndianShort=packed record
   bigEndianValue:short;
   end;

  BigEndianUnsignedShort=packed record
   bigEndianValue:unsigned_short;
   end;

  BigEndianFixed=packed record
   bigEndianValue:Fixed;
   end;

  BigEndianUnsignedFixed=packed record
   bigEndianValue:UnsignedFixed;
   end;

  BigEndianOSType=packed record
   bigEndianValue:OSType;
   end;

{$else}

 type
  BigEndianLong=long;
  BigEndianUnsignedLong=unsigned_long;
  BigEndianShort=short;
  BigEndianUnsignedShort=unsigned_short;
  BigEndianFixed=Fixed;
  BigEndianUnsignedFixed=UnsignedFixed;
  BigEndianOSType=OSType;

{$endif}  (* TARGET_RT_LITTLE_ENDIAN *)

 function EndianS16_BtoN(value:SInt16):SInt16;
 function EndianS16_NtoB(value:SInt16):SInt16;
 function EndianU16_BtoN(value:UInt16):UInt16;
 function EndianU16_NtoB(value:UInt16):UInt16;
 function EndianS32_BtoN(value:SInt32):SInt32;
 function EndianS32_NtoB(value:SInt32):SInt32;
 function EndianU32_BtoN(value:UInt32):UInt32;
 function EndianU32_NtoB(value:UInt32):UInt32;
 function EndianS64_BtoN(value:SInt64):SInt64;
 function EndianS64_NtoB(value:SInt64):SInt64;
 function EndianU64_BtoN(value:UInt64):UInt64;
 function EndianU64_NtoB(value:UInt64):UInt64;

 function EndianS16_LtoN(value:SInt16):SInt16;
 function EndianS16_NtoL(value:SInt16):SInt16;
 function EndianU16_LtoN(value:UInt16):UInt16;
 function EndianU16_NtoL(value:UInt16):UInt16;
 function EndianS32_LtoN(value:SInt32):SInt32;
 function EndianS32_NtoL(value:SInt32):SInt32;
 function EndianU32_LtoN(value:UInt32):UInt32;
 function EndianU32_NtoL(value:UInt32):UInt32;
 function EndianS64_LtoN(value:SInt64):SInt64;
 function EndianS64_NtoL(value:SInt64):SInt64;
 function EndianU64_LtoN(value:UInt64):UInt64;
 function EndianU64_NtoL(value:UInt64):UInt64;

 function EndianS16_LtoB(value:SInt16):SInt16;
 function EndianS16_BtoL(value:SInt16):SInt16;
 function EndianU16_LtoB(value:UInt16):UInt16;
 function EndianU16_BtoL(value:UInt16):UInt16;
 function EndianS32_LtoB(value:SInt32):SInt32;
 function EndianS32_BtoL(value:SInt32):SInt32;
 function EndianU32_LtoB(value:UInt32):UInt32;
 function EndianU32_BtoL(value:UInt32):UInt32;
 function EndianS64_LtoB(value:SInt64):SInt64;
 function EndianS64_BtoL(value:SInt64):SInt64;
 function EndianU64_LtoB(value:UInt64):UInt64;
 function EndianU64_BtoL(value:UInt64):UInt64;

 function Endian16_Swap(value:UInt16):UInt16;
 function Endian32_Swap(value:UInt32):UInt32;
 function Endian64_Swap(value:UInt64):UInt64;

implementation

(*
    Macro away no-op functions
*)

{$ifdef TARGET_RT_BIG_ENDIAN}

 function EndianS16_BtoN; begin result:=value; end;
 function EndianS16_NtoB; begin result:=value; end;
 function EndianU16_BtoN; begin result:=value; end;
 function EndianU16_NtoB; begin result:=value; end;
 function EndianS32_BtoN; begin result:=value; end;
 function EndianS32_NtoB; begin result:=value; end;
 function EndianU32_BtoN; begin result:=value; end;
 function EndianU32_NtoB; begin result:=value; end;
 function EndianS64_BtoN; begin result:=value; end;
 function EndianS64_NtoB; begin result:=value; end;
 function EndianU64_BtoN; begin result:=value; end;
 function EndianU64_NtoB; begin result:=value; end;

{$else}

 function EndianS16_LtoN; begin result:=value; end;
 function EndianS16_NtoL; begin result:=value; end;
 function EndianU16_LtoN; begin result:=value; end;
 function EndianU16_NtoL; begin result:=value; end;
 function EndianS32_LtoN; begin result:=value; end;
 function EndianS32_NtoL; begin result:=value; end;
 function EndianU32_LtoN; begin result:=value; end;
 function EndianU32_NtoL; begin result:=value; end;
 function EndianS64_LtoN; begin result:=value; end;
 function EndianS64_NtoL; begin result:=value; end;
 function EndianU64_LtoN; begin result:=value; end;
 function EndianU64_NtoL; begin result:=value; end;

{$endif}

(*
    Map native to actual
*)

{$ifdef TARGET_RT_BIG_ENDIAN}

 function EndianS16_LtoN; begin result:=EndianS16_LtoB(value); end;
 function EndianS16_NtoL; begin result:=EndianS16_BtoL(value); end;
 function EndianU16_LtoN; begin result:=EndianU16_LtoB(value); end;
 function EndianU16_NtoL; begin result:=EndianU16_BtoL(value); end;
 function EndianS32_LtoN; begin result:=EndianS32_LtoB(value); end;
 function EndianS32_NtoL; begin result:=EndianS32_BtoL(value); end;
 function EndianU32_LtoN; begin result:=EndianU32_LtoB(value); end;
 function EndianU32_NtoL; begin result:=EndianU32_BtoL(value); end;
 function EndianS64_LtoN; begin result:=EndianS64_LtoB(value); end;
 function EndianS64_NtoL; begin result:=EndianS64_BtoL(value); end;
 function EndianU64_LtoN; begin result:=EndianU64_LtoB(value); end;
 function EndianU64_NtoL; begin result:=EndianU64_BtoL(value); end;

{$else}

 function EndianS16_BtoN; begin result:=EndianS16_BtoL(value); end;
 function EndianS16_NtoB; begin result:=EndianS16_LtoB(value); end;
 function EndianU16_BtoN; begin result:=EndianU16_BtoL(value); end;
 function EndianU16_NtoB; begin result:=EndianU16_LtoB(value); end;
 function EndianS32_BtoN; begin result:=EndianS32_BtoL(value); end;
 function EndianS32_NtoB; begin result:=EndianS32_LtoB(value); end;
 function EndianU32_BtoN; begin result:=EndianU32_BtoL(value); end;
 function EndianU32_NtoB; begin result:=EndianU32_LtoB(value); end;
 function EndianS64_BtoN; begin result:=EndianS64_BtoL(value); end;
 function EndianS64_NtoB; begin result:=EndianS64_LtoB(value); end;
 function EndianU64_BtoN; begin result:=EndianU64_BtoL(value); end;
 function EndianU64_NtoB; begin result:=EndianU64_LtoB(value); end;

{$endif}

(*
    Implement ÅLtoB and ÅBtoL
*)
 function EndianS16_LtoB; begin result:=(SInt16(Endian16_Swap(value))); end;
 function EndianS16_BtoL; begin result:=(SInt16(Endian16_Swap(value))); end;
 function EndianU16_LtoB; begin result:=(UInt16(Endian16_Swap(value))); end;
 function EndianU16_BtoL; begin result:=(UInt16(Endian16_Swap(value))); end;
 function EndianS32_LtoB; begin result:=(SInt32(Endian32_Swap(value))); end;
 function EndianS32_BtoL; begin result:=(SInt32(Endian32_Swap(value))); end;
 function EndianU32_LtoB; begin result:=(UInt32(Endian32_Swap(value))); end;
 function EndianU32_BtoL; begin result:=(UInt32(Endian32_Swap(value))); end;
 function EndianS64_LtoB; begin result:=(SInt64(Endian64_Swap(UInt64(value)))); end;
 function EndianS64_BtoL; begin result:=(SInt64(Endian64_Swap(UInt64(value)))); end;
 function EndianU64_LtoB; begin result:=(UInt64(Endian64_Swap(value))); end;
 function EndianU64_BtoL; begin result:=(UInt64(Endian64_Swap(value))); end;

(*
    Implement low level Å_Swap functions.

       extern UInt16 Endian16_Swap(UInt16 value);
     extern UInt32 Endian32_Swap(UInt32 value);
     extern UInt64 Endian64_Swap(UInt64 value);

   Note: Depending on the processor, you might want to implement
        these as function calls instead of macros.

*)

 function Endian16_Swap(value:UInt16):UInt16;
 begin
  result:=((UInt16(value) shl 8) and $FF00) or
          ((UInt16(value) shr 8) and $00FF);
 end;

 function Endian32_Swap(value:UInt32):UInt32;
 begin
  result:=((UInt32(value) shl 24) and $FF000000) or
          ((UInt32(value) shl 8) and $00FF0000) or
          ((UInt32(value) shr 8) and $0000FF00) or
          ((UInt32(value) shr 24) and $000000FF);
 end;

 function Endian64_Swap(value:UInt64):UInt64;
 begin
  UnsignedWidePtr(@result)^.lo := Endian32_Swap(UnsignedWidePtr(@value)^.hi);
  UnsignedWidePtr(@result)^.hi := Endian32_Swap(UnsignedWidePtr(@value)^.lo);
 end;

end.


