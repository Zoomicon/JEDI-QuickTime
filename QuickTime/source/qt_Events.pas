{************************************************************************}
{                                                       	         }
{       Borland Delphi Runtime Library                  		 }
{       QuickTime interface unit                                         }
{ 									 }
{ Portions created by Apple Computer, Inc. are 				 }
{ Copyright (C) ????-1998 Apple Computer, Inc.. 			 }
{ All Rights Reserved. 							 }
{ 								         }
{ The original file is: Events.h, released dd Mmm yyyy. 		 }
{ The original Pascal code is: qt_Events.pas, released 13 May 2002. 	 }
{ The initial developer of the Pascal code is George Birbilis            }
{ (birbilis@cti.gr).                     				 }
{ 									 }
{ Portions created by George Birbilis are    				 }
{ Copyright (C) 1998-2002 George Birbilis 				 }
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

//07Mar1999 - birbilis: last known change before donation to Delphi-JEDI
//14May2000 - birbilis: donated to Delphi-JEDI
//13Jan2002 - birbilis: added some more stuff

unit qt_Events;

interface
 uses qt_MacTypes;

 //Events.h//

 type EventKind=UInt16;
      EventMask=UInt16;

 const
  nullEvent	  = 0;
  mouseDown	  = 1;
  mouseUp	  = 2;
  keyDown	  = 3;
  keyUp		  = 4;
  autoKey	  = 5;
  updateEvt	  = 6;
  diskEvt	  = 7;
  activateEvt	  = 8;
  osEvt		  = 15;
  kHighLevelEvent = 23;

 const
  mDownMask          = 1 shl mouseDown; (* mouse button pressed *)
  mUpMask            = 1 shl mouseUp; (* mouse button released *)
  keyDownMask        = 1 shl keyDown; (* key pressed *)
  keyUpMask          = 1 shl keyUp; (* key released *)
  autoKeyMask        = 1 shl autoKey; (* key repeatedly held down *)
  updateMask         = 1 shl updateEvt;	(* window needs updating *)
  diskMask           = 1 shl diskEvt; (* disk inserted *)
  activMask          = 1 shl activateEvt; (* activate/deactivate window *)
  highLevelEventMask = $0400; (* high-level events (includes AppleEvents) *)
  osMask	     = 1 shl osEvt; (* operating system events (suspend, resume) *)
  everyEvent	     = $FFFF; (* all of the above *)

 const
  charCodeMask	   = $000000FF;
  keyCodeMask	   = $0000FF00;
  adbAddrMask	   = $00FF0000;
  osEvtMessageMask = $FF000000;

 const (* OS event messages.  Event (sub)code is in the high byte of the message field.*)
  mouseMovedMessage    = $00FA;
  suspendResumeMessage = $0001;


 const
  resumeFlag	       = 1; (* Bit 0 of message indicates resume vs suspend *)
  convertClipboardFlag = 2; (* Bit 1 in resume message indicates clipboard change *)

 type EventModifiers=UInt16;
 const (* modifiers *)
  activeFlagBit	     = 0;  (* activate? (activateEvt and mouseDown) *)
  btnStateBit	     = 7;  (* state of button? *)
  cmdKeyBit	     = 8;  (* command key down? *)
  shiftKeyBit	     = 9;  (* shift key down? *)
  alphaLockBit	     = 10; (* alpha lock down? *)
  optionKeyBit	     = 11; (* option key down? *)
  controlKeyBit	     = 12; (* control key down? *)
  rightShiftKeyBit   = 13; (* right shift key down? *)
  rightOptionKeyBit  = 14; (* right Option key down? *)
  rightControlKeyBit = 15; (* right Control key down? *)

 const
  activeFlag	  = 1 shl activeFlagBit;
  btnState	  = 1 shl btnStateBit;
  cmdKey	  = 1 shl cmdKeyBit;
  shiftKey	  = 1 shl shiftKeyBit;
  alphaLock	  = 1 shl alphaLockBit;
  optionKey	  = 1 shl optionKeyBit;
  controlKey	  = 1 shl controlKeyBit;
  rightShiftKey	  = 1 shl rightShiftKeyBit;
  rightOptionKey  = 1 shl rightOptionKeyBit;
  rightControlKey = 1 shl rightControlKeyBit;

 const
  kNullCharCode		    = 0;
  kHomeCharCode		    = 1;
  kEnterCharCode	    = 3;
  kEndCharCode		    = 4;
  kHelpCharCode		    = 5;
  kBellCharCode		    = 7;
  kBackspaceCharCode	    = 8;
  kTabCharCode		    = 9;
  kLineFeedCharCode	    = 10;
  kVerticalTabCharCode	    = 11;
  kPageUpCharCode	    = 11;
  kFormFeedCharCode	    = 12;
  kPageDownCharCode	    = 12;
  kReturnCharCode	    = 13;
  kFunctionKeyCharCode	    = 16;
  kEscapeCharCode	    = 27;
  kClearCharCode	    = 27;
  kLeftArrowCharCode	    = 28;
  kRightArrowCharCode	    = 29;
  kUpArrowCharCode	    = 30;
  kDownArrowCharCode	    = 31;
  kDeleteCharCode	    = 127;
  kNonBreakingSpaceCharCode = 202;

 type
  EventRecord=packed record
   what:EventKind;
   message:UInt32;
   when:UInt32;
   where:Point;
   modifiers:EventModifiers;
   end;
  EventRecordPtr=^EventRecord;

implementation

end.

