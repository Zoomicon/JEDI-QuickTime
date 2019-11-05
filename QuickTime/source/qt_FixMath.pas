{************************************************************************}
{                                                       	         }
{       Borland Delphi Runtime Library                  		 }
{       QuickTime interface unit                                         }
{ 									 }
{ Portions created by Apple Computer, Inc. are 				 }
{ Copyright (C) 1985-2001 Apple Computer, Inc.. 			 }
{ All Rights Reserved. 							 }
{ 								         }
{ The original file is: FixMath.h, released dd Mmm yyyy. 		 }
{ The original Pascal code is: qt_FixMath.pas, released 21 May 2002. 	 }
{ The initial developer of the Pascal code is George Birbilis            }
{ (birbilis@kagi.com).                     				 }
{ 									 }
{ Portions created by George Birbilis are    				 }
{ Copyright (C) 1998-2004 George Birbilis 				 }
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

//21May2002 - birbilis: full porting of FixMath.h from QT5.01 SDK
//17Jun2004 - birbilis: renamed "positiveInfinit" to "positiveInfinity"
//          - birbilis: added "Fix2X","X2Fix","Frac2X","X2Frac"

(*
     File:       FixMath.h

     Contains:   Fixed Math Interfaces.

     Version:    Technology: Mac OS 8
                 Release:    QuickTime 5.0.1

     Copyright:  (c) 1985-2001 by Apple Computer, Inc., all rights reserved

     Bugs?:      For bug reports, consult the following page on
                 the World Wide Web:

                     http://developer.apple.com/bugreporter/

*)

unit qt_FixMath;

interface
 uses qt_MacTypes,C_Types;

 const
  fixed1=Fixed(long($00010000));
  fract1=Fract(long($40000000));
  positiveInfinity=long($7FFFFFFF);
  negativeInfinity=long($80000000);

(*
    FixRatio, FixMul, and FixRound were previously in ToolUtils.h
*)

 function FixRatio(numer:short;denom:short):Fixed; cdecl; external 'qtmlClient.dll';
 function FixMul(a:Fixed;b:Fixed):Fixed; cdecl; external 'qtmlClient.dll';
 function FixRound(x:Fixed):short; cdecl; external 'qtmlClient.dll';
 function Fix2Frac(x:Fixed):Fract; cdecl; external 'qtmlClient.dll';
 function Fix2Long(x:Fixed):long; cdecl; external 'qtmlClient.dll';
 function Long2Fix(x:long):Fixed; cdecl; external 'qtmlClient.dll';
 function Frac2Fix(x:Fract):Fixed; cdecl; external 'qtmlClient.dll';
 function FracMul(x:Fract;y:Fract):Fract; cdecl; external 'qtmlClient.dll';
 function FixDiv(x:Fixed;y:Fixed):Fixed; cdecl; external 'qtmlClient.dll';
 function FracDiv(x:Fract;y:Fract):Fract; cdecl; external 'qtmlClient.dll';
 function FracSqrt(x:Fract):Fract; cdecl; external 'qtmlClient.dll';
 function FracSin(x:Fixed):Fract; cdecl; external 'qtmlClient.dll';
 function FracCos(x:Fixed):Fract; cdecl; external 'qtmlClient.dll';
 function FixATan2(x:long;y:long):Fixed; cdecl; external 'qtmlClient.dll';

 function Fix2X(x:Fixed):float; cdecl; external 'qtmlClient.dll';
 function X2Fix(x:float):Fixed; cdecl; external 'qtmlClient.dll';
 function Frac2X(x:Fract):float; cdecl; external 'qtmlClient.dll';
 function X2Frac(x:float):Fract; cdecl; external 'qtmlClient.dll';

(* QuickTime 3.0 makes these Wide routines available on other platforms*)

 function WideCompare({const} var target:wide;{const} var source:wide):short; cdecl; external 'qtmlClient.dll';
 function WideAdd(var target:wide;{const} var source:wide):widePtr; cdecl; external 'qtmlClient.dll';
 function WideSubtract(var target:wide;{const} var source:wide):widePtr; cdecl; external 'qtmlClient.dll';
 function WideNegate(var target:wide):widePtr; cdecl; external 'qtmlClient.dll';
 function WideShift(var target:wide;shift:long):widePtr; cdecl; external 'qtmlClient.dll';
 function WideSquareRoot({const} var source:wide):unsigned_long; cdecl; external 'qtmlClient.dll';
 function WideMultiply(multiplicand:long;multiplier:long;var target:wide):widePtr; cdecl; external 'qtmlClient.dll';

 (* returns the quotient *)
 function WideDivide({const} var dividend:wide;divisor:long;var remainder:long):long; cdecl; external 'qtmlClient.dll';

 (* quotient replaces dividend *)
 function WideWideDivide(var dividend:wide;divisor:long;var remainder:long):widePtr; cdecl; external 'qtmlClient.dll';

 function WideBitShift(var src:wide;shift:long):widePtr; cdecl; external 'qtmlClient.dll';

implementation

end.

