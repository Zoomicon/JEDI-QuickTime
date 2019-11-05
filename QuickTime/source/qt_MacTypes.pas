//TO DO: check if StandardFileReply works OK now that changed Boolean type again

(************************************************************************
                                                       	         
       Borland Delphi Runtime Library
       QuickTime interface unit

 Portions created by Apple Computer, Inc. are
 Copyright (C) ????-1998 Apple Computer, Inc..
 All Rights Reserved.

 The original file is: MacTypes.h, released dd Mmm yyyy.
 The original Pascal code is: qt_MacTypes.pas, released 14 May 2000.
 The initial developer of the Pascal code is George Birbilis
 (birbilis@cti.gr).

 Portions created by George Birbilis are
 Copyright (C) 1998-2009 George Birbilis

       Obtained through:

       Joint Endeavour of Delphi Innovators (Project JEDI)

 You may retrieve the latest version of this file at the Project
 JEDI home page, located at http://delphi-jedi.org

 The contents of this file are used with permission, subject to
 the Mozilla Public License Version 1.1 (the "License"); you may
 not use this file except in compliance with the License. You may
 obtain a copy of the License at
 http://www.mozilla.org/MPL/MPL-1.1.html

 Software distributed under the License is distributed on an 	         
 "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or         
 implied. See the License for the specific language governing           
 rights and limitations under the License. 				 

************************************************************************)

(******
 History:
  07Mar1999 - birbilis: last known change before donation to Delphi-JEDI
  14May2000 - birbilis: donated to Delphi-JEDI
  21Jan2002 - birbilis: added FOUR_CHAR_CODE type
  02Feb2002 - birbilis: removed again FOUR_CHAR_CODE type and added
                        FOUR_CHAR_CODE function instead
  21May2002 - birbilis: added widePtr and OSTypePtr types
  23May2002 - birbilis: added all String types from QT5.0.1 SDK
  18Jun2002 - birbilis: almost finished, based on QT5.0.1 SDK
  30Jun2002 - birbilis: added "Str255Ptr" type
   6Jul2002 - birbilis: changed all "char" to "AnsiChar"
            -           changed all "ConstStrXXParam"
            -           added "SInt64Ptr"
  02Oct2009 - birbilis: added "UInt8Ptr", "SInt8Ptr", "SInt16Ptr", "UInt16Ptr",
                        "SInt32Ptr", "UInt32Ptr" and "UInt64Ptr"
******)

(*
     File:       MacTypes.h

     Contains:   Basic Macintosh data types.

     Version:    Technology: Mac OS 9
                 Release:    QuickTime 5.0.1

     Copyright:  (c) 1985-2001 by Apple Computer, Inc., all rights reserved.

     Bugs?:      For bug reports, consult the following page on
                 the World Wide Web:

                     http://developer.apple.com/bugreporter/

*)

unit qt_MacTypes;

interface
 uses C_Types;

{$define TARGET_RT_LITTLE_ENDIAN} //in C it's defined in ConditionalMacros.h (maybe create a ConditionalMacros.inc for Pascal and include wherever it's needed)

(********************************************************************************

    Base integer types for all target OS's and CPU's

        UInt8            8-bit unsigned integer
        SInt8            8-bit signed integer
        UInt16          16-bit unsigned integer
        SInt16          16-bit signed integer
        UInt32          32-bit unsigned integer
        SInt32          32-bit signed integer
        UInt64          64-bit unsigned integer
        SInt64          64-bit signed integer

*********************************************************************************)
 type
  UInt8=byte;      //unsigned 8-bit integer
  UInt8Ptr=^UInt8;

  SInt8=shortInt;  //signed 8-bit integer
  SInt8Ptr=^SInt8;

  SInt16=short; //signed 16-bit integer
  SInt16Ptr=^SInt16;

  UInt16=word;  //unsigned 16-bit integer
  UInt16Ptr=^UInt16;

  SInt32=long;  //signed 32-bit integer
  SInt32Ptr=^SInt32;

  UInt32=cardinal; //unsigned 32-bit integer
  UInt32Ptr=^UInt32;

{$ifdef TARGET_RT_BIG_ENDIAN}

 wide=packed record
  hi:SInt32;
  lo:UInt32;
  end;

 UnsignedWide=packed record
  hi:UInt32;
  lo:UInt32;
  end;

{$else}

 wide=packed record
  lo:UInt32;
  hi:SInt32;
  end;

 UnsignedWide=packed record
  lo:UInt32;
  hi:UInt32;
  end;

{$endif}  (* TARGET_RT_BIG_ENDIAN *)

(*
  Note:   wide and UnsignedWide must always be structs for source code
           compatibility. On the other hand UInt64 and SInt64 can be
          either a struct or a long long, depending on the compiler.

           If you use UInt64 and SInt64 you should do all operations on
          those data types through the functions/macros in Math64.h.
           This will assure that your code compiles with compilers that
           support long long and those that don't.

           The MS Visual C/C++ compiler uses __int64 instead of long long.
*)

 type
  //SInt64=Int64;
  //UInt64=Int64; //this would be problematic: Delphi has no unsigned Int64 type!!!

  SInt64=wide;
  SInt64Ptr=^SInt64;

  UInt64=UnsignedWide;
  UInt64Ptr=^UInt64;

(********************************************************************************

    Base fixed point types

        Fixed           16-bit signed integer plus 16-bit fraction
        UnsignedFixed   16-bit unsigned integer plus 16-bit fraction
        Fract           2-bit signed integer plus 30-bit fraction
        ShortFixed      8-bit signed integer plus 8-bit fraction

*********************************************************************************)

 type
  Fixed=long;
  FixedPtr=^Fixed;

  Fract=long;
  FractPtr=^Fract;

  UnsignedFixed=unsigned_long;
  UnsignedFixedPtr=^UnsignedFixed;

  ShortFixed=short;
  ShortFixedPtr=^ShortFixed;

(********************************************************************************

	Base floating point types

		Float32			32 bit IEEE float:  1 sign bit, 8 exponent bits, 23 fraction bits
		Float64			64 bit IEEE float:  1 sign bit, 11 exponent bits, 52 fraction bits
		Float80			80 bit MacOS float: 1 sign bit, 15 exponent bits, 1 integer bit, 63 fraction bits
		Float96			96 bit 68881 float: 1 sign bit, 15 exponent bits, 16 pad bits, 1 integer bit, 63 fraction bits

	Note: These are fixed size floating point types, useful when writing a floating
		  point value to disk.  If your compiler does not support a particular size
		  float, a struct is used instead.
		  Use of of the NCEG types (e.g. double_t) or an ANSI C type (e.g. double) if
		  you want a floating point representation that is natural for any given
		  compiler, but might be a different size on different compilers.

*********************************************************************************)

 type
  Float32=float;
  Float64=double; //a short double in MetroWorks & ThinkC C compilers, a double in all others

{$ifdef TARGET_CPU_68K}
 {$ifdef TARGET_RT_MAC_68881}
 type
  Float96=long_double;
  Float80=record
   exp:SInt16;
   man:array[0..3] of UInt16;
   end;
 {$else}
  Float80=long_double;
  Float96=record
   exp:array[0..1]of SInt16; (* the second 16-bits is always zero *)
   man:array[0..3]of UInt16;
   end;
 {$endif}
{$else}
 type
  Float80=packed record
   exp:SInt16;
   man:array[0..3]of UInt16;
   end;

  Float96=packed record
   exp:array[0..1]of SInt16; (* the second 16-bits is always zero *)
   man:array[0..3]of UInt16;
   end;
{$endif}

(********************************************************************************

    MacOS Memory Manager types

        Ptr             Pointer to a non-relocatable block
        Handle          Pointer to a master pointer to a relocatable block
        Size            The number of bytes in a block (signed for historical reasons)

*********************************************************************************)

 type
  Ptr=^char;
  Handle=^Ptr;
  Size=long;

(********************************************************************************

    Higher level basic types
    
        OSErr                   16-bit result error code
        OSStatus                32-bit result error code
        LogicalAddress          Address in the clients virtual address space
        ConstLogicalAddress     Address in the clients virtual address space that will only be read
        PhysicalAddress         Real address as used on the hardware bus
        BytePtr                 Pointer to an array of bytes
        ByteCount               The size of an array of bytes
        ByteOffset              An offset into an array of bytes
        ItemCount               32-bit iteration count
        OptionBits              Standard 32-bit set of bit flags
        PBVersion               ?
        Duration                32-bit millisecond timer for drivers
        AbsoluteTime            64-bit clock
        ScriptCode              A particular set of written characters (e.g. Roman vs Cyrillic) and their encoding
        LangCode                A particular language (e.g. English), as represented using a particular ScriptCode
        RegionCode              Designates a language as used in a particular region (e.g. British vs American
                                English) together with other region-dependent characteristics (e.g. date format)
        FourCharCode            A 32-bit value made by packing four 1 byte characters together
        OSType                  A FourCharCode used in the OS and file system (e.g. creator)
        ResType                 A FourCharCode used to tag resources (e.g. 'DLOG')

*********************************************************************************)

 type
  OSErr=SInt16;
  OSStatus=SInt32;
  LogicalAddress=pointer;
  ConstLogicalAddress={const}pointer;
  PhysicalAddress=pointer;
  BytePtr=^UInt8;
  ByteCount=UInt32;
  ByteOffset=UInt32;
  Duration=SInt32;
  AbsoluteTime=UnsignedWide;
  OptionBits=UInt32;
  ItemCount=UInt32;
  PBVersion=UInt32;
  ScriptCode=SInt16;
  LangCode=SInt16;
  RegionCode=SInt16;
  FourCharCode=unsigned_long;
  OSType=FourCharCode;
  ResType=FourCharCode;
  OSTypePtr=^OSType;
  ResTypePtr=^ResType;

(********************************************************************************

    Boolean types and values

        Boolean         A one byte value, holds "false" (0) or "true" (1)
        false           The Boolean value of zero (0)
        true            The Boolean value of one (1)

*********************************************************************************)
 (*
    The identifiers "true" and "false" are becoming keywords in C++
    and work with the new built-in type "bool"
    "Boolean" will remain an unsigned char for compatibility with source
    code written before "bool" existed.
 *)
 //const
  //false = 0; //that's the false value in Delphi as well
  //true  = 1; //that's the true value in Delphi as well
 type
  Boolean=ByteBool; {unsigned_char} //1 byte (10Feb99: must be a WordBool, since that one fixes the packed record problem with StandardFileReply)
  BooleanPtr=^Boolean; //delphi3

(********************************************************************************

    Function Pointer Types

        ProcPtr                 Generic pointer to a function
        Register68kProcPtr      Pointer to a 68K function that expects parameters in registers
        UniversalProcPtr        Pointer to classic 68K code or a RoutineDescriptor

        ProcHandle              Pointer to a ProcPtr
        UniversalProcHandle     Pointer to a UniversalProcPtr

*********************************************************************************)

 type
  ProcPtr=function:long; stdcall; //CALLBACK_API_C=stdcall on Win32
  Register68kProcPtr=procedure; stdcall; //CALLBACK_API=stdcall on Win32
  UniversalProcPtr=ProcPtr;
  ProcHandle=^ProcPtr;
  UniversalProcHandle=^UniversalProcPtr;

(********************************************************************************

    Common Constants

        noErr                   OSErr: function performed properly - no error
        kNilOptions             OptionBits: all flags false
        kInvalidID              KernelID: NULL is for pointers as kInvalidID is for ID's
        kVariableLengthArray    array bounds: variable length array

    Note: kVariableLengthArray is used in array bounds to specify a variable length array.
          It is ususally used in variable length structs when the last field is an array
          of any size.  Before ANSI C, we used zero as the bounds of variable length
          array, but zero length array are illegal in ANSI C.  Example usage:

        struct FooList
        {
            short   listLength;
            Foo     elements[kVariableLengthArray];
        };

*********************************************************************************)

 const
  noErr = 0;
  kNilOptions = 0;
  kInvalidID = 0;
  kVariableLengthArray = 1;
  kUnknownType = $3F3F3F3F; (* '????' QuickTime 3.0: default unknown ResType or OSType *)

(********************************************************************************

    String Types

        UniChar                 A single 16-bit Unicode character
        UniCharCount            A count of Unicode characters in an array or buffer

        StrNNN                  Pascal string holding up to NNN bytes
        StringPtr               Pointer to a pascal string
        StringHandle            Pointer to a StringPtr
        ConstStringPtr          Pointer to a read-only pascal string
        ConstStrNNNParam        For function parameters only - means string is const
        
        CStringPtr              Pointer to a C string           ( in C:  char* )
        ConstCStringPtr         Pointer to a read-only C string ( in C:  const char* )

    Note: The length of a pascal string is stored as the first byte.
          A pascal string does not have a termination byte.
          A pascal string can hold at most 255 bytes of data.
          The first character in a pascal string is offset one byte from the start of the string.

          A C string is terminated with a byte of value zero.
          A C string has no length limitation.
          The first character in a C string is the zeroth byte of the string.


*********************************************************************************)
 type
  UniChar=UInt16;
  UniCharPtr=^UniChar;
  UniCharCount=UInt32;
  UniCharCountPtr=^UniCharCount;

  Str255={array[0..255] of AnsiChar}shortString;
  Str255Ptr=^Str255; //for Delphi
  Str63=array[0..63]of AnsiChar;
  Str63Ptr=^Str63; //for Delphi
  Str32=array[0..32]of AnsiChar;
  Str32Ptr=^Str32; //for Delphi
  Str31=array[0..31]of AnsiChar;
  Str31Ptr=^Str31; //for Delphi
  Str27=array[0..27]of AnsiChar;
  Str27Ptr=^Str27; //for Delphi
  Str15=array[0..15]of AnsiChar;
  Str15Ptr=^Str15; //for Delphi
(*
    The type Str32 is used in many AppleTalk based data structures.
    It holds up to 32 one byte chars.  The problem is that with the
    length byte it is 33 bytes long.  This can cause weird alignment
    problems in structures.  To fix this the type "Str32Field" has
    been created.  It should only be used to hold 32 chars, but
    it is 34 bytes long so that there are no alignment problems.
*)
 type Str32Field=array[0..33]of AnsiChar;
(*
    QuickTime 3.0:
    The type StrFileName is used to make MacOS structs work
    cross-platform.  For example FSSpec or SFReply previously
    contained a Str63 field.  They now contain a StrFileName
    field which is the same when targeting the MacOS but is
    a 256 char buffer for Win32 and unix, allowing them to
    contain long file names.
*)
{$IFDEF TARGET_OS_MAC}
 type StrFileName=Str63;
{$ELSE}
 type StrFileName=shortstring; //Str255; //birbilis: needed for Delphi to allow TypeInfo(StrFilename), needed to set up special property editor for this type of property
{$ENDIF}

 type
  StringPtr=^ShortString;
  StringHandle=^StringPtr; //birbilis: made ^StringPtr

  ConstStringPtr={const}StringPtr; //birbilis: made StringPtr
  ConstStr255Param={const}Str255Ptr;
  ConstStr63Param={const}Str63Ptr;
  ConstStr32Param={const}Str32Ptr;
  ConstStr31Param={const}Str31Ptr;
  ConstStr27Param={const}Str27Ptr;
  ConstStr15Param={const}Str15Ptr;

{$ifdef TARGET_OS_MAC}
 type ConstStrFileNameParam=ConstStr63Param;
{$else}
 type ConstStrFileNameParam=ConstStr255Param;
{$endif}  (* TARGET_OS_MAC *)

 function StrLength(str:ConstStr255Param):byte;

{$ifdef OLDROUTINENAMES}
 const Length:(function(str:ConstStr255Param):byte)=StrLength;
{$endif}

(********************************************************************************

    Quickdraw Types

        Point               2D Quickdraw coordinate, range: -32K to +32K
        Rect                Rectangluar Quickdraw area
        Style               Quickdraw font rendering styles
        StyleParameter      Style when used as a parameter (historical 68K convention)
        StyleField          Style when used as a field (historical 68K convention)
        CharParameter       Char when used as a parameter (historical 68K convention)

    Note:   The original Macintosh toolbox in 68K Pascal defined Style as a SET.
            Both Style and CHAR occupy 8-bits in packed records or 16-bits when
            used as fields in non-packed records or as parameters.

*********************************************************************************)

 type

  Point=packed record
   v:short;
   h:short;
   end;
  PointPtr=^Point;

  Rect=packed record
   top:short;
   left:short;
   bottom:short;
   right:short;
   end;
  RectPtr=^Rect;

 FixedPoint=packed record
  x:Fixed;
  y:Fixed;
  end;

 FixedRect=packed record
  left:Fixed;
  top:Fixed;
  right:Fixed;
  bottom:Fixed;
  end;

 CharParameter=short;

 const
  normal                      = $0;
  bold                        = $1;
  italic                      = $2;
  underline                   = $4;
  outline                     = $8;
  shadow                      = $10;
  condense                    = $20;
  extend                      = $40;

 type
  Style=unsigned_char;
  StyleParameter=short;
  StyleField=Style;

//...

(*********************************************************************************

    Old names for types

*********************************************************************************)

 type
  //Byte=UInt8;
  SignedByte=SInt8;
  WidePtr=^wide;
  UnsignedWidePtr=^UnsignedWide;
  extended80=Float80;
  extended96=Float96;
  VHSelect=SInt8;

/////////////////////

 //Special values in C//
 (**)//const NULL=nil; //shouldn't use NULL but use nil, since it'a a special const in the System unit

////////////////////////////////////////////////

 type Str4=packed array[0..3] of AnsiChar;
 function FOUR_CHAR_CODE(s:str4):unsigned_long;

implementation

 function StrLength(str:ConstStr255Param):byte;
 begin
  result:=byte(str^[0]);
 end;

 function FOUR_CHAR_CODE;
 begin
  result:=(((ord(s[0]) shl 8 +ord(s[1]))shl 8 +ord(s[2]))shl 8 +ord(s[3]));
 end;

end.

