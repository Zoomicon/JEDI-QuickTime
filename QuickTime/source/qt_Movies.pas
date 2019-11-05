{************************************************************************}
{                                                       	         }
{       Borland Delphi Runtime Library                  		 }
{       QuickTime interface unit                                         }
{ 									 }
{ Portions created by Apple Computer, Inc. are 				 }
{ Copyright (C) 1990-1998 Apple Computer, Inc.. 			 }
{ All Rights Reserved. 							 }
{ 								         }
{ The original file is: Movies.h, released dd Mmm yyyy. 		 }
{ The original Pascal code is: qt_Movies.pas, released 14 May 2000. 	 }
{ The initial developer of the Pascal code is George Birbilis            }
{ (birbilis@cti.gr).                     				 }
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

(* HISTORY:
14May2000 - birbilis: Donated to Delphi-JEDI
21Jan2002 - birbilis: Stripped out almost all the implementation section by
                      moving "external" directives to the interface section
03Feb2002 - birbilis: Fixed bug with FCC constants that had been introduced
                      at the 21Jan2002 version
21May2002 - birbilis: Added NewMovieFromHandle, NewMovieFromDataFork,
                      NewMovieFromUserProc, NewMovieFromDataRef,
                      AddMovieResource, UpdateMovieResource,
                      RemoveMovieResource, HasMovieChanged, ClearMovieChanged,
                      GetMediaNextInterestingTime, GetTrackNextInterestingTime,
                      GetMovieNextInterestingTime, CreateMovieFile,
                      DeleteMovieFile,SetMovieTimeValue
18Jun2002 - birbilis: Completed "Movie State Routines" section based on QT5.0.1
          -           Ported the following sections from Movies.h:
                      "Track creation", "Track State", "Media State",
                      "Media's Data", "Media Sample Table", "Editing",
                      "Hi-level Editing", "Middle-level Editing",
                      "movie & track edit state", "track reference",
                      "high level file conversion", "Movie Timebase Conversion",
                      "Miscellaneous", "Group Selection", "User Data",
                      "Movie Controller support", "Scrap", "DataRef",
                      "Playback hint", "Load time track hints", "Big screen TV",
                      "Wired Actions", "Interactive Sprites Support",
                      "QT Atom Data Support"
26Jun2002 - birbilis: Changed "NewMovieFromDataRef" to use "shortPtr" for its
                      "id" parameter cause it's an optional one (can pass nil)
          -           Changed "GetMovieNextInterestingTime",
                      "GetTrackNextInterestingTime" and
                      "GetMediaNextInterestingTime" to use "TimeValuePtr" for
                      their "interestingDuration" parameter cause it's an
                      optional parameter (can pass nil)
30Jun2002 - birbilis: At "GetMediaHandlerDescription" using "Str255Ptr",
                      not "Str255"
16Oct2002 - birbilis: At "GetMovieNaturalBoundsRect" and "GetMovieGWorld",
                      fixed some parameters to be passed by reference
          -           At "SetMovieMasterClock" fixed a "const" parameter to "var"
05Jul2003 - birbilis: Added declaration of "TimeValue64" and "TimeValue64Ptr"
07Aug2004 - birbilis: Added "QTAtomIDPtr" type
          -           Changed last parameter of "QTFindChildByIndex" to be of
                      type "QTAtomIDPtr" instead of a "var" parameter of type
                      "QTAtomID", so that one can pass "nil" for that parameter
          -           Changed last parameter of "QTCopyAtomDataToPtr" to be of
                      type "longPtr" instead of a "var" parameter of type "long"
                      so that one can pass "nil" for that parameter
          -           Changed last parameter of "QTFindChildByID" to be of type
                      "longPtr" instead of a "var" parameter of type "long" so
                      that one can pass "nil" for that parameter
*)

unit qt_Movies;

interface
 uses C_Types,
      qt_QuickDraw,
      qt_Components,
      qt_Files,
      qt_Aliases,
      qt_MacTypes,
      qt_Events,
      qt_ImageCompression;

(*
 	File:		Movies.h

 	Contains:	QuickTime Interfaces.

 	Version:	Technology:	QuickTime 3.0
 				Release:	QuickTime 3.0

 	Copyright:	© 1990-1998 by Apple Computer, Inc., all rights reserved

 	Bugs?:		Please include the the file and version information (from above) with
 				the problem description.  Developers belonging to one of the Apple
 				developer programs can submit bug reports to:

 					devsupport@apple.com

*)

 const
  MovieFileType=(((ord('M') shl 8 +ord('o'))shl 8 +ord('o'))shl 8 +ord('V')); {'MooV'}
  MovieScrapType =(((ord('m') shl 8 +ord('o'))shl 8 +ord('o'))shl 8 +ord('v')); {'moov'}

 const
  MovieResourceType                =(((ord('m') shl 8 +ord('o'))shl 8 +ord('o'))shl 8 +ord('v')); {'moov'}
  MovieForwardPointerResourceType  =(((ord('f') shl 8 +ord('o'))shl 8 +ord('r'))shl 8 +ord('e')); {'fore'}
  MovieBackwardPointerResourceType =(((ord('b') shl 8 +ord('a'))shl 8 +ord('c'))shl 8 +ord('k')); {'back'}

 const
  MovieResourceAtomType   =(((ord('m') shl 8 +ord('o'))shl 8 +ord('o'))shl 8 +ord('v')); {'moov'}
  MovieDataAtomType       =(((ord('m') shl 8 +ord('d'))shl 8 +ord('a'))shl 8 +ord('t')); {'mdat'}
  FreeAtomType            = (((ord('f') shl 8 +ord('r'))shl 8 +ord('e'))shl 8 +ord('e')); {'free'}
  SkipAtomType            =(((ord('s') shl 8 +ord('k'))shl 8 +ord('i'))shl 8 +ord('p')); {'skip'}
  WideAtomPlaceholderType =(((ord('w') shl 8 +ord('i'))shl 8 +ord('d'))shl 8 +ord('e')); {'wide'}

 const
  MediaHandlerType =(((ord('m') shl 8 +ord('h'))shl 8 +ord('l'))shl 8 +ord('r')); {'mhlr'}
  DataHandlerType  =(((ord('d') shl 8 +ord('h'))shl 8 +ord('l'))shl 8 +ord('r')); {'dhlr'}

 const
  VideoMediaType             =(((ord('v') shl 8 +ord('i'))shl 8 +ord('d'))shl 8 +ord('e')); {'vide'}
  SoundMediaType             =(((ord('s') shl 8 +ord('o'))shl 8 +ord('u'))shl 8 +ord('n')); {'soun'}
  TextMediaType              =(((ord('t') shl 8 +ord('e'))shl 8 +ord('x'))shl 8 +ord('t')); {'text'}
  BaseMediaType              =(((ord('g') shl 8 +ord('n'))shl 8 +ord('r'))shl 8 +ord('c')); {'gnrc'}
  MPEGMediaType              =(((ord('M') shl 8 +ord('P'))shl 8 +ord('E'))shl 8 +ord('G')); {'MPEG'}
  MusicMediaType             =(((ord('m') shl 8 +ord('u'))shl 8 +ord('s'))shl 8 +ord('i')); {'musi'}
  TimeCodeMediaType          =(((ord('t') shl 8 +ord('m'))shl 8 +ord('c'))shl 8 +ord('d')); {'tmcd'}
  SpriteMediaType            =(((ord('s') shl 8 +ord('p'))shl 8 +ord('r'))shl 8 +ord('t')); {'sprt'}
  FlashMediaType             =(((ord('f') shl 8 +ord('l'))shl 8 +ord('s'))shl 8 +ord('h')); {'flsh'}
  MovieMediaType             =(((ord('m') shl 8 +ord('o'))shl 8 +ord('o'))shl 8 +ord('v')); {'moov'}
  TweenMediaType             =(((ord('t') shl 8 +ord('w'))shl 8 +ord('e'))shl 8 +ord('n')); {'twen'}
  ThreeDeeMediaType          =(((ord('q') shl 8 +ord('d'))shl 8 +ord('3'))shl 8 +ord('d')); {'qd3d'}
  HandleDataHandlerSubType   =(((ord('h') shl 8 +ord('n'))shl 8 +ord('d'))shl 8 +ord('l')); {'hndl'}
  ResourceDataHandlerSubType =(((ord('r') shl 8 +ord('s'))shl 8 +ord('r'))shl 8 +ord('c')); {'rsrc'}
  URLDataHandlerSubType      =(((ord('u') shl 8 +ord('r'))shl 8 +ord('l'))shl 8 +ord(' ')); {'url '}
  WiredActionHandlerType     =(((ord('w') shl 8 +ord('i'))shl 8 +ord('r'))shl 8 +ord('e')); {'wire'}

 const
  VisualMediaCharacteristic      = (((ord('e')shl 8 +ord('y'))shl 8 +ord('e'))shl 8 +ord('s')); {'eyes'}
  AudioMediaCharacteristic	 = (((ord('e')shl 8 +ord('a'))shl 8 +ord('r'))shl 8 +ord('s')); {'ears'}
  kCharacteristicCanSendVideo    = (((ord('v')shl 8 +ord('s'))shl 8 +ord('n'))shl 8 +ord('d')); {'vsnd'}
  kCharacteristicProvidesActions = (((ord('a')shl 8 +ord('c'))shl 8 +ord('t'))shl 8 +ord('n')); {'actn'}
  kCharacteristicNonLinear	 = (((ord('n')shl 8 +ord('o'))shl 8 +ord('n'))shl 8 +ord('l')); {'nonl'}
  kCharacteristicCanStep         = (((ord('s')shl 8 +ord('t'))shl 8 +ord('e'))shl 8 +ord('p')); {'step'}
  kCharacteristicHasNoDuration   = (((ord('n')shl 8 +ord('o'))shl 8 +ord('t'))shl 8 +ord('i')); {'noti'}

 const
  kUserDataMovieControllerType  =(((ord('c') shl 8 +ord('t'))shl 8 +ord('y'))shl 8 +ord('p')); {'ctyp'}
  kUserDataName                 =(((ord('n') shl 8 +ord('a'))shl 8 +ord('m'))shl 8 +ord('e')); {'name'}
  kUserDataTextAuthor           =OSType(((ord('©') shl 8 +ord('a'))shl 8 +ord('u'))shl 8 +ord('t')); {'©aut'}
  kUserDataTextComment          =OSType(((ord('©') shl 8 +ord('c'))shl 8 +ord('m'))shl 8 +ord('t')); {'©cmt'}
  kUserDataTextCopyright        =OSType(((ord('©') shl 8 +ord('c'))shl 8 +ord('p'))shl 8 +ord('y')); {'©cpy'}
  kUserDataTextCreationDate     =OSType(((ord('©') shl 8 +ord('d'))shl 8 +ord('a'))shl 8 +ord('y')); {'©day'}
  kUserDataTextDescription      =OSType(((ord('©') shl 8 +ord('d'))shl 8 +ord('e'))shl 8 +ord('s')); {'©des'}
  kUserDataTextDirector         =OSType(((ord('©') shl 8 +ord('d'))shl 8 +ord('i'))shl 8 +ord('r')); {'©dir'}
  kUserDataTextDisclaimer       =OSType(((ord('©') shl 8 +ord('d'))shl 8 +ord('i'))shl 8 +ord('s')); {'©dis'}
  kUserDataTextFullName	        =OSType(((ord('©') shl 8 +ord('n'))shl 8 +ord('a'))shl 8 +ord('m')); {'©nam'}
  kUserDataTextHostComputer     =OSType(((ord('©') shl 8 +ord('h'))shl 8 +ord('s'))shl 8 +ord('t')); {'©hst'}
  kUserDataTextInformation      =OSType(((ord('©') shl 8 +ord('i'))shl 8 +ord('n'))shl 8 +ord('f')); {'©inf'}
  kUserDataTextKeywords         =OSType(((ord('©') shl 8 +ord('k'))shl 8 +ord('e'))shl 8 +ord('y')); {'©key'}
  kUserDataTextMake             =OSType(((ord('©') shl 8 +ord('m'))shl 8 +ord('a'))shl 8 +ord('k')); {'©mak'}
  kUserDataTextModel            =OSType(((ord('©') shl 8 +ord('m'))shl 8 +ord('o'))shl 8 +ord('d')); {'©mod'}
  kUserDataTextOriginalFormat   =OSType(((ord('©') shl 8 +ord('f'))shl 8 +ord('m'))shl 8 +ord('t')); {'©fmt'}
  kUserDataTextOriginalSource   =OSType(((ord('©') shl 8 +ord('s'))shl 8 +ord('r'))shl 8 +ord('c')); {'©src'}
  kUserDataTextPerformers       =OSType(((ord('©') shl 8 +ord('p'))shl 8 +ord('r'))shl 8 +ord('f')); {'©prf'}
  kUserDataTextProducer         =OSType(((ord('©') shl 8 +ord('p'))shl 8 +ord('r'))shl 8 +ord('d')); {'©prd'}
  kUserDataTextProduct          =OSType(((ord('©') shl 8 +ord('P'))shl 8 +ord('R'))shl 8 +ord('D')); {'©PRD'}
  kUserDataTextSoftware         =OSType(((ord('©') shl 8 +ord('s'))shl 8 +ord('w'))shl 8 +ord('r')); {'©swr'}
  kUserDataTextSpecialPlaybackRequirements =OSType(((ord('©') shl 8 +ord('r'))shl 8 +ord('e'))shl 8 +ord('q')); {'©req'}
  kUserDataTextWarning          =OSType(((ord('©') shl 8 +ord('w'))shl 8 +ord('r'))shl 8 +ord('n')); {'©wrn'}
  kUserDataTextWriter           =OSType(((ord('©') shl 8 +ord('w'))shl 8 +ord('r'))shl 8 +ord('t')); {'©wrt'}
  kUserDataTextEditDate1        =OSType(((ord('©') shl 8 +ord('e'))shl 8 +ord('d'))shl 8 +ord('1')); {'©ed1'}
  kUserDataTextChapter          =OSType(((ord('©') shl 8 +ord('c'))shl 8 +ord('h'))shl 8 +ord('p')); {'©chp'}

 const
  kUserDataUnicodeBit = long(1) shl 7;

 const
  DoTheRightThing = 0;

 type
  MovieRecord=packed record
   data:array[0..0]of long;
   end;
  Movie=^MovieRecord;
  MoviePtr=^Movie;

  TrackRecord=packed record
   data:array[0..0]of long;
   end;
  Track=^TrackRecord;

  MediaRecord=packed record
   data:array[0..0]of long;
   end;
  Media=^MediaRecord;

  UserDataRecord=packed record
   data:array[0..0] of long; //6Feb1999:changed from 1..1 to 0..0
   end;
  UserData=^UserDataRecord;

  TrackEditStateRecord=packed record
   data:array[0..0] of long;
   end;
  TrackEditState=^TrackEditStateRecord;

  MovieEditStateRecord=packed record
   data:array[0..0] of long;
   end;
  MovieEditState=^MovieEditStateRecord;

  SpriteWorldRecord=packed record
   data:array[0..0] of long;
   end;
  SpriteWorld=^SpriteWorldRecord;

  SpriteRecord=packed record
   data:array[0..0] of long;
   end;
  Sprite=^SpriteRecord;

  QTTweenerRecord=packed record
   data:array[0..0] of long;
   end;
  QTTweener=^QTTweenerRecord;

 type
  SampleDescription=packed record
   descSize:long;
   dataFormat:long;
   resvd1:long;
   resvd2:short;
   dataRefIndex:short;
   end;
  SampleDescriptionPtr=^SampleDescription;
  SampleDescriptionHandle=^SampleDescriptionPtr;

 //...

 (* menu item codes*)
 const mcMenuUndo					= 1;
       mcMenuCut					= 3;
       mcMenuCopy					= 4;
       mcMenuPaste					= 5;
       mcMenuClear					= 6;

 const movieTrackMediaType	= 1 shl 0;
       movieTrackCharacteristic	= 1 shl 1;
       movieTrackEnabledOnly	= 1 shl 2;

 const keepInRam			= 1 shl 0; (* load and make non-purgable*)
       unkeepInRam			= 1 shl 1; (* mark as purgable*)
       flushFromRam			= 1 shl 2; (* empty those handles*)
       loadForwardTrackEdits		= 1 shl 3; (*	load track edits into ram for playing forward*)
       loadBackwardTrackEdits		= 1 shl 4; (*	load track edits into ram for playing in reverse*)

 const newMovieActive=1 shl 0;
       newMovieDontResolveDataRefs	  = 1 shl 1;
       newMovieDontAskUnresolvedDataRefs  = 1 shl 2;
       newMovieDontAutoAlternates	  = 1 shl 3;
       newMovieDontUpdateForeBackPointers = 1 shl 4;

 (* track usage bits *)

 const trackUsageInMovie		= 1 shl 1;
       trackUsageInPreview		= 1 shl 2;
       trackUsageInPoster		= 1 shl 3;

 (* Add/GetMediaSample flags *)

 const mediaSampleNotSync		= 1 shl 0; (* sample is not a sync sample (eg. is frame differenced *)
       mediaSampleShadowSync		= 1 shl 1; (* sample is a shadow sync *)

 const pasteInParallel			= 1 shl 0;
       showUserSettingsDialog		= 1 shl 1;
       movieToFileOnlyExport		= 1 shl 2;
       movieFileSpecValid		= 1 shl 3;

 const nextTimeMediaSample		= 1 shl 0;
       nextTimeMediaEdit		= 1 shl 1;
       nextTimeTrackEdit		= 1 shl 2;
       nextTimeSyncSample		= 1 shl 3;
       nextTimeStep			= 1 shl 4;
       nextTimeEdgeOK			= 1 shl 14;
       nextTimeIgnoreActiveSegment	= 1 shl 15;

 type nextTimeFlagsEnum=word;

 const createMovieFileDeleteCurFile     = long(1) shl 31;
       createMovieFileDontCreateMovie   = long(1) shl 30;
       createMovieFileDontOpenFile	= long(1) shl 29;
       createMovieFileDontCreateResFile = long(1) shl 28;

 type createMovieFileFlagsEnum=cardinal;

 const flattenAddMovieToDataFork	        = long(1) shl 0;
       flattenActiveTracksOnly		        = long(1) shl 2;
       flattenDontInterleaveFlatten             = long(1) shl 3;
       flattenFSSpecPtrIsDataRefRecordPtr       = long(1) shl 4;
       flattenCompressMovieResource             = long(1) shl 5;
       flattenForceMovieResourceBeforeMovieData = long(1) shl 6;

 type movieFlattenFlagsEnum=cardinal;

 const movieInDataForkResID = -1; (* magic res ID *)

 const mcTopLeftMovie	 = 1 shl 0; (* usually centered *)
       mcScaleMovieToFit = 1 shl 1; (* usually only scales down *)
       mcWithBadge	 = 1 shl 2; (* give me a badge *)
       mcNotVisible	 = 1 shl 3; (* don't show controller *)
       mcWithFrame	 = 1 shl 4; (* gimme a frame *)

 const movieScrapDontZeroScrap		= 1 shl 0;
       movieScrapOnlyPutMovie		= 1 shl 1;

 const dataRefSelfReference		= 1 shl 0;
       dataRefWasNotResolved		= 1 shl 1;

 type MovieController=ComponentInstance;
      mcAction=short;
 const	mcActionIdle 	= 1;  	(* no param*)
	mcActionDraw 	= 2;  	(* param is WindowPtr*)
	mcActionActivate = 3;  	(* no param*)
	mcActionDeactivate = 4;  	(* no param*)
	mcActionMouseDown = 5;  	(* param is pointer to EventRecord*)
	mcActionKey 		= 6;  	(* param is pointer to EventRecord*)
	mcActionPlay 	= 8;  	(* param is Fixed; play rate*)
	mcActionGoToTime = 12;  	(* param is TimeRecord*)
	mcActionSetVolume = 14;  	(* param is a short*)
	mcActionGetVolume = 15;  	(* param is pointer to a short*)
	mcActionStep 	= 18;  	(* param is number of steps (short)*)
	mcActionSetLooping = 21;  	(* param is Boolean*)
	mcActionGetLooping = 22;  	(* param is pointer to a Boolean*)
	mcActionSetLoopIsPalindrome	= 23;  	(* param is Boolean*)
	mcActionGetLoopIsPalindrome	= 24;  	(* param is pointer to a Boolean*)
	mcActionSetGrowBoxBounds	= 25;  	(* param is a Rect*)
	mcActionControllerSizeChanged = 26;  	(* no param*)
	mcActionSetSelectionBegin	= 29;  	(* param is TimeRecord*)
	mcActionSetSelectionDuration = 30;  	(* param is TimeRecord; action only taken on set-duration*)
	mcActionSetKeysEnabled		= 32;  	(* param is Boolean*)
	mcActionGetKeysEnabled		= 33;  	(* param is pointer to Boolean*)
	mcActionSetPlaySelection	= 34;  	(* param is Boolean*)
	mcActionGetPlaySelection	= 35;  	(* param is pointer to Boolean*)
	mcActionSetUseBadge = 36;  	(* param is Boolean*)
	mcActionGetUseBadge = 37;  	(* param is pointer to Boolean*)
	mcActionSetFlags = 38;  	(* param is long of flags*)
	mcActionGetFlags = 39;  	(* param is pointer to a long of flags*)
	mcActionSetPlayEveryFrame	= 40;  	(* param is Boolean*)
	mcActionGetPlayEveryFrame	= 41;  	(* param is pointer to Boolean*)
	mcActionGetPlayRate = 42;  	(* param is pointer to Fixed*)
	mcActionShowBalloon = 43;  	(* param is a pointer to a boolean. set to false to stop balloon*)
	mcActionBadgeClick = 44;  	(* param is pointer to Boolean. set to false to ignore click*)
	mcActionMovieClick = 45;  	(* param is pointer to event record. change "what" to nullEvt to kill click*)
	mcActionSuspend 	= 46;  	(* no param*)
	mcActionResume 	= 47;  	(* no param*)
	mcActionSetControllerKeysEnabled = 48;  (* param is Boolean*)
	mcActionGetTimeSliderRect	= 49;  	(* param is pointer to rect*)
	mcActionMovieEdited = 50;  	(* no param*)
	mcActionGetDragEnabled		= 51;  	(* param is pointer to Boolean*)
	mcActionSetDragEnabled		= 52;  	(* param is Boolean*)
	mcActionGetSelectionBegin	= 53;  	(* param is TimeRecord*)
	mcActionGetSelectionDuration = 54;	(* param is TimeRecord*)
	mcActionPrerollAndPlay		= 55;		(* param is Fixed; play rate*)
	mcActionGetCursorSettingEnabled = 56;		(* param is pointer to Boolean*)
	mcActionSetCursorSettingEnabled = 57;		(* param is Boolean*)
	mcActionSetColorTable		= 58;		(* param is CTabHandle*)
	mcActionLinkToURL			= 59;	(* param is Handle to URL*)
	mcActionCustomButtonClick	= 60;		(* param is pointer to EventRecord*)
	mcActionForceTimeTableUpdate = 61;		(* no param*)
	mcActionSetControllerTimeLimits = 62;		(* param is pointer to 2 time values min/max. do no send this message to controller. used internally only.*)
	mcActionExecuteAllActionsForQTEvent = 63;	(* param is ResolvedQTEventSpecPtr*)
	mcActionExecuteOneActionForQTEvent = 64;	(* param is ResolvedQTEventSpecPtr*)
	mcActionAdjustCursor		= 65;		(* param is pointer to EventRecord (WindowPtr is in message parameter)*)
	mcActionUseTrackForTimeTable = 66;		(* param is pointer to {long trackID; Boolean useIt}. do not send this message to controller. *)
	mcActionClickAndHoldPoint	= 67;		(* param is point (local coordinates). return true if point has click & hold action (e.g.; VR object movie autorotate spot)*)
	mcActionShowMessageString	= 68;		(* param is a StringPtr*)

 const 	mcFlagSuppressMovieFrame	= 1 shl 0;
	mcFlagSuppressStepButtons	= 1 shl 1;
	mcFlagSuppressSpeakerButton	= 1 shl 2;
	mcFlagsUseWindowPalette		= 1 shl 3;
	mcFlagsDontInvalidate		= 1 shl 4;
	mcFlagsUseCustomButton		= 1 shl 5;

 type QTAtomContainer=Handle;
      QTAtom=long;
      QTAtomPtr=^QTAtom; //needed for Delphi
      QTAtomType=long;
      QTAtomTypePtr=^QTAtomType; //needed for Delphi
      QTAtomID=long;
      QTAtomIDPtr=^QTAtomID; //needed for Delphi
      (* QTFloatDouble is the 64-bit IEEE-754 standard*)
      QTFloatDouble=Float64;
      (* QTFloatSingle is the 32-bit IEEE-754 standard*)
      QTFloatSingle=Float32;

(*****
*   Interactive Sprites Support
*****)
(* QTEventRecord flags*)
 const
  kQTEventPayloadIsQTList     = long(1) shl 0;

 type
  QTEventRecord=packed record
   version:long;
   eventType:OSType;
   where:Point;
   flags:long;
   payloadRefcon:long; (* from here down only present if version >= 2 *)
   param1:long;
   param2:long;
   param3:long;
   end;
  QTEventRecordPtr=^QTEventRecord;

 QTAtomSpec=packed record
  container:QTAtomContainer;
  atom:QTAtom;
  end;
 QTAtomSpecPtr=^QTAtomSpec;

 ResolvedQTEventSpec=packed record
  actionAtom:QTAtomSpec;
  targetTrack:Track;
  targetRefCon:long;
  end;
 ResolvedQTEventSpecPtr=^ResolvedQTEventSpec;

(* action constants *)
 const
  kActionMovieSetVolume       = 1024;                         (* (short movieVolume) *)
  kActionMovieSetRate         = 1025;                         (* (Fixed rate) *)
  kActionMovieSetLoopingFlags = 1026;                         (* (long loopingFlags) *)
  kActionMovieGoToTime        = 1027;                         (* (TimeValue time) *)
  kActionMovieGoToTimeByName  = 1028;                         (* (Str255 timeName) *)
  kActionMovieGoToBeginning   = 1029;                         (* no params *)
  kActionMovieGoToEnd         = 1030;                         (* no params *)
  kActionMovieStepForward     = 1031;                         (* no params *)
  kActionMovieStepBackward    = 1032;                         (* no params *)
  kActionMovieSetSelection    = 1033;                         (* (TimeValue startTime, TimeValue endTime) *)
  kActionMovieSetSelectionByName = 1034;                      (* (Str255 startTimeName, Str255 endTimeName) *)
  kActionMoviePlaySelection   = 1035;                         (* (Boolean selectionOnly) *)
  kActionMovieSetLanguage     = 1036;                         (* (long language) *)
  kActionMovieChanged         = 1037;                         (* no params *)
  kActionMovieRestartAtTime   = 1038;                         (* (TimeValue startTime, Fixed rate) *)
  kActionTrackSetVolume       = 2048;                         (* (short volume) *)
  kActionTrackSetBalance      = 2049;                         (* (short balance) *)
  kActionTrackSetEnabled      = 2050;                         (* (Boolean enabled) *)
  kActionTrackSetMatrix       = 2051;                         (* (MatrixRecord matrix) *)
  kActionTrackSetLayer        = 2052;                         (* (short layer) *)
  kActionTrackSetClip         = 2053;                         (* (RgnHandle clip) *)
  kActionTrackSetCursor       = 2054;                         (* (QTATomID cursorID) *)
  kActionTrackSetGraphicsMode = 2055;                         (* (ModifierTrackGraphicsModeRecord graphicsMode) *)
  kActionTrackSetIdleFrequency = 2056;                        (* (long frequency) *)
  kActionTrackSetBassTreble   = 2057;                         (* (short base, short treble) *)
  kActionSpriteSetMatrix      = 3072;                         (* (MatrixRecord matrix) *)
  kActionSpriteSetImageIndex  = 3073;                         (* (short imageIndex) *)
  kActionSpriteSetVisible     = 3074;                         (* (short visible) *)
  kActionSpriteSetLayer       = 3075;                         (* (short layer) *)
  kActionSpriteSetGraphicsMode = 3076;                        (* (ModifierTrackGraphicsModeRecord graphicsMode) *)
  kActionSpritePassMouseToCodec = 3078;                       (* no params *)
  kActionSpriteClickOnCodec   = 3079;                         (* Point localLoc *)
  kActionSpriteTranslate      = 3080;                         (* (Fixed x, Fixed y, Boolean isAbsolute) *)
  kActionSpriteScale          = 3081;                         (* (Fixed xScale, Fixed yScale) *)
  kActionSpriteRotate         = 3082;                         (* (Fixed degrees) *)
  kActionSpriteStretch        = 3083;                         (* (Fixed p1x, Fixed p1y, Fixed p2x, Fixed p2y, Fixed p3x, Fixed p3y, Fixed p4x, Fixed p4y) *)
  kActionQTVRSetPanAngle      = 4096;                         (* (float panAngle) *)
  kActionQTVRSetTiltAngle     = 4097;                         (* (float tiltAngle) *)
  kActionQTVRSetFieldOfView   = 4098;                         (* (float fieldOfView) *)
  kActionQTVRShowDefaultView  = 4099;                         (* no params *)
  kActionQTVRGoToNodeID       = 4100;                         (* (UInt32 nodeID) *)
  kActionQTVREnableHotSpot    = 4101;                         (* long ID, Boolean enable *)
  kActionQTVRShowHotSpots     = 4102;                         (* Boolean show *)
  kActionQTVRTranslateObject  = 4103;                         (* float xMove, float yMove *)
  kActionMusicPlayNote        = 5120;                         (* (long sampleDescIndex, long partNumber, long delay, long pitch, long velocity, long duration) *)
  kActionMusicSetController   = 5121;                         (* (long sampleDescIndex, long partNumber, long delay, long controller, long value) *)
  kActionCase                 = 6144;                         (* [(CaseStatementActionAtoms)] *)
  kActionWhile                = 6145;                         (* [(WhileStatementActionAtoms)] *)
  kActionGoToURL              = 6146;                         (* (C string urlLink) *)
  kActionSendQTEventToSprite  = 6147;                         (* ([(SpriteTargetAtoms)], QTEventRecord theEvent) *)
  kActionDebugStr             = 6148;                         (* (Str255 theString) *)
  kActionPushCurrentTime      = 6149;                         (* no params *)
  kActionPushCurrentTimeWithLabel = 6150;                     (* (Str255 theLabel) *)
  kActionPopAndGotoTopTime    = 6151;                         (* no params *)
  kActionPopAndGotoLabeledTime = 6152;                        (* (Str255 theLabel) *)
  kActionStatusString         = 6153;                         (* (C string theString, long stringTypeFlags) *)
  kActionSendQTEventToTrackObject = 6154;                     (* ([(TrackObjectTargetAtoms)], QTEventRecord theEvent) *)
  kActionAddChannelSubscription = 6155;                       (* (Str255 channelName, C string channelsURL, C string channelsPictureURL) *)
  kActionRemoveChannelSubscription = 6156;                    (* (C string channelsURL) *)
  kActionOpenCustomActionHandler = 6157;                      (* (long handlerID, ComponentDescription handlerDesc) *)
  kActionDoScript             = 6158;                         (* (long scriptTypeFlags, CString command, CString arguments) *)
  kActionDoCompressedActions  = 6159;                         (* (compressed QTAtomContainer prefixed with eight bytes: long compressorType, long decompressedSize) *)
  kActionSendAppMessage       = 6160;                         (* (long appMessageID) *)
  kActionLoadComponent        = 6161;                         (* (ComponentDescription handlerDesc) *)
  kActionSetFocus             = 6162;                         (* [(TargetAtoms theObject)] *)
  kActionDontPassKeyEvent     = 6163;                         (* no params *)
  kActionSpriteTrackSetVariable = 7168;                       (* (QTAtomID variableID, float value) *)
  kActionSpriteTrackNewSprite = 7169;                         (* (QTAtomID spriteID, short imageIndex, MatrixRecord *matrix, short visible, short layer, ModifierTrackGraphicsModeRecord *graphicsMode, QTAtomID actionHandlingSpriteID) *)
  kActionSpriteTrackDisposeSprite = 7170;                     (* (QTAtomID spriteID) *)
  kActionSpriteTrackSetVariableToString = 7171;               (* (QTAtomID variableID, C string value) *)
  kActionSpriteTrackConcatVariables = 7172;                   (* (QTAtomID firstVariableID, QTAtomID secondVariableID, QTAtomID resultVariableID ) *)
  kActionSpriteTrackSetVariableToMovieURL = 7173;             (* (QTAtomID variableID, < optional: [(MovieTargetAtoms)] > ) *)
  kActionSpriteTrackSetVariableToMovieBaseURL = 7174;         (* (QTAtomID variableID, < optional: [(MovieTargetAtoms)] > ) *)
  kActionApplicationNumberAndString = 8192;                   (* (long aNumber, Str255 aString ) *)
  kActionQD3DNamedObjectTranslateTo = 9216;                   (* (Fixed x, Fixed y, Fixed z ) *)
  kActionQD3DNamedObjectScaleTo = 9217;                       (* (Fixed xScale, Fixed yScale, Fixed zScale ) *)
  kActionQD3DNamedObjectRotateTo = 9218;                      (* (Fixed xDegrees, Fixed yDegrees, Fixed zDegrees ) *)
  kActionFlashTrackSetPan     = 10240;                        (* (short xPercent, short yPercent ) *)
  kActionFlashTrackSetZoom    = 10241;                        (* (short zoomFactor ) *)
  kActionFlashTrackSetZoomRect = 10242;                       (* (long left, long top, long right, long bottom ) *)
  kActionFlashTrackGotoFrameNumber = 10243;                   (* (long frameNumber ) *)
  kActionFlashTrackGotoFrameLabel = 10244;                    (* (C string frameLabel ) *)
  kActionFlashTrackSetFlashVariable = 10245;                  (* (C string path, C string name, C string value, Boolean updateFocus) *)
  kActionFlashTrackDoButtonActions = 10246;                   (* (C string path, long buttonID, long transition) *)
  kActionMovieTrackAddChildMovie = 11264;                     (* (QTAtomID childMovieID, C string childMovieURL) *)
  kActionMovieTrackLoadChildMovie = 11265;                    (* (QTAtomID childMovieID) *)
  kActionMovieTrackLoadChildMovieWithQTListParams = 11266;    (* (QTAtomID childMovieID, C string qtlistXML) *)
  kActionTextTrackPasteText   = 12288;                        (* (C string theText, long startSelection, long endSelection ) *)
  kActionTextTrackSetTextBox  = 12291;                        (* (short left, short top, short right, short bottom) *)
  kActionTextTrackSetTextStyle = 12292;                       (* (Handle textStyle) *)
  kActionTextTrackSetSelection = 12293;                       (* (long startSelection, long endSelection ) *)
  kActionTextTrackSetBackgroundColor = 12294;                 (* (ModifierTrackGraphicsModeRecord backgroundColor ) *)
  kActionTextTrackSetForegroundColor = 12295;                 (* (ModifierTrackGraphicsModeRecord foregroundColor ) *)
  kActionTextTrackSetFace     = 12296;                        (* (long fontFace ) *)
  kActionTextTrackSetFont     = 12297;                        (* (long fontID ) *)
  kActionTextTrackSetSize     = 12298;                        (* (long fontSize ) *)
  kActionTextTrackSetAlignment = 12299;                       (* (short alignment ) *)
  kActionTextTrackSetHilite   = 12300;                        (* (long startHighlight, long endHighlight, ModifierTrackGraphicsModeRecord highlightColor ) *)
  kActionTextTrackSetDropShadow = 12301;                      (* (Point dropShadow, short transparency ) *)
  kActionTextTrackSetDisplayFlags = 12302;                    (* (long flags ) *)
  kActionTextTrackSetScroll   = 12303;                        (* (long delay ) *)
  kActionTextTrackRelativeScroll = 12304;                     (* (short deltaX, short deltaY ) *)
  kActionTextTrackFindText    = 12305;                        (* (long flags, Str255 theText, ModifierTrackGraphicsModeRecord highlightColor ) *)
  kActionTextTrackSetHyperTextFace = 12306;                   (* (short index, long fontFace ) *)
  kActionTextTrackSetHyperTextColor = 12307;                  (* (short index, ModifierTrackGraphicsModeRecord highlightColor ) *)
  kActionTextTrackKeyEntry    = 12308;                        (* (short character ) *)
  kActionTextTrackMouseDown   = 12309;                        (* no params *)
  kActionTextTrackSetEditable = 12310;                        (* (short editState) *)
  kActionListAddElement       = 13312;                        (* (C string parentPath, long atIndex, C string newElementName) *)
  kActionListRemoveElements   = 13313;                        (* (C string parentPath, long startIndex, long endIndex) *)
  kActionListSetElementValue  = 13314;                        (* (C string elementPath, C string valueString) *)
  kActionListPasteFromXML     = 13315;                        (* (C string xml, C string targetParentPath, long startIndex) *)
  kActionListSetMatchingFromXML = 13316;                      (* (C string xml, C string targetParentPath) *)
  kActionListSetFromURL       = 13317;                        (* (C string url, C string targetParentPath ) *)
  kActionListExchangeLists    = 13318;                        (* (C string url, C string parentPath) *)
  kActionListServerQuery      = 13319;                        (* (C string url, C string keyValuePairs, long flags, C string parentPath) *)

 type //note: CALLBACK_API=stdcall on win32
  MovieRgnCoverProcPtr=function(theMovie:Movie; changedRgn:RgnHandle; refcon:long):OSErr; stdcall;
  MovieProgressProcPtr=function(theMovie:Movie; _message:short; whatOperation:short; percentDone:Fixed; refcon:long):OSErr; stdcall;
  MovieDrawingCompleteProcPtr=function(theMovie:Movie; refCon:long):OSErr; stdcall;
  TrackTransferProcPtr=function(t:Track; refCon:long):OSErr; stdcall;
  GetMovieProcPtr=function(offset:long; size:long; dataPtr:pointer; refCon:pointer):OSErr; stdcall;
  MoviePreviewCallOutProcPtr=function(refcon:long):Boolean; stdcall;
  TextMediaProcPtr=function(theText:Handle; theMovie:Movie; displayFlag:shortPtr; refcon:long):OSErr; stdcall;
  ActionsProcPtr=function(refcon:pointer; targetTrack:Track; targetRefCon:long; theEvent:QTEventRecordPtr):OSErr; stdcall;
  DoMCActionProcPtr=function(refcon:pointer; action:short; params:pointer; handled:BooleanPtr):OSErr; stdcall;
  MovieExecuteWiredActionsProcPtr=function(theMovie:Movie; refcon:pointer; flags:long; wiredActions:QTAtomContainer):OSErr; stdcall;
  MoviePrePrerollCompleteProcPtr=procedure(theMovie:Movie; prerollErr:OSErr; refcon:pointer); stdcall;
  MoviesErrorProcPtr=procedure(theErr:OSErr; refcon:long); stdcall;

 type //for win32 only
  MovieRgnCoverUPP=MovieRgnCoverProcPtr; 
  MovieProgressUPP=MovieProgressProcPtr;
  MovieDrawingCompleteUPP=MovieDrawingCompleteProcPtr;
  TrackTransferUPP=TrackTransferProcPtr;
  GetMovieUPP=GetMovieProcPtr;
  MoviePreviewCallOutUPP=MoviePreviewCallOutProcPtr;
  TextMediaUPP=TextMediaProcPtr;
  ActionsUPP=ActionsProcPtr;
  DoMCActionUPP=DoMCActionProcPtr;
  MovieExecuteWiredActionsUPP=MovieExecuteWiredActionsProcPtr;
  MoviePrePrerollCompleteUPP=MoviePrePrerollCompleteProcPtr;
  MoviesErrorUPP=MoviesErrorProcPtr;

 type
  MediaHandler=ComponentInstance;
  DataHandler=ComponentInstance;
  MediaHandlerComponent=Component;
  DataHandlerComponent=Component;
  HandlerErrorComponentResult=ComponentResult;

 (* TimeBase equates *)
 type
  TimeValue=long;
  TimeValuePtr=^TimeValue;
  TimeScale=long;
  CompTimeValue=wide;
  TimeValue64=SInt64;
  TimeValue64Ptr=^TimeValue64;

 const
  loopTimeBase		 = 1;
  palindromeLoopTimeBase = 2;
  maintainTimeBaseZero	 = 4;

 type
  TimeBaseFlags=cardinal;
  TimeBaseRecord=packed record
   data:array[0..0]of long;
   end;
  TimeBase=^TimeBaseRecord;

  TimeRecord=packed record
   value:CompTimeValue; (* units *)
   scale:TimeScale; (* units per second *)
   base:TimeBase;
   end;
  TimeRecordPtr=^TimeRecord; //Delphi

(* CallBack equates *)
 const
  triggerTimeFwd              = $0001;                      (* when curTime exceeds triggerTime going forward *)
  triggerTimeBwd              = $0002;                      (* when curTime exceeds triggerTime going backwards *)
  triggerTimeEither           = $0003;                      (* when curTime exceeds triggerTime going either direction *)
  triggerRateLT               = $0004;                      (* when rate changes to less than trigger value *)
  triggerRateGT               = $0008;                      (* when rate changes to greater than trigger value *)
  triggerRateEqual            = $0010;                      (* when rate changes to equal trigger value *)
  triggerRateLTE              = triggerRateLT or triggerRateEqual;
  triggerRateGTE              = triggerRateGT or triggerRateEqual;
  triggerRateNotEqual         = triggerRateGT or triggerRateEqual or triggerRateLT;
  triggerRateChange           = 0;
  triggerAtStart              = $0001;
  triggerAtStop               = $0002;

 //...

 const
  hintsScrubMode              = 1 shl 0;       (* mask == && (if flags == scrub on, flags != scrub off) *)
  hintsLoop                   = 1 shl 1;
  hintsDontPurge              = 1 shl 2;
  hintsUseScreenBuffer        = 1 shl 5;
  hintsAllowInterlace         = 1 shl 6;
  hintsUseSoundInterp         = 1 shl 7;
  hintsHighQuality            = 1 shl 8;       (* slooooow *)
  hintsPalindrome             = 1 shl 9;
  hintsInactive               = 1 shl 11;
  hintsOffscreen              = 1 shl 12;
  hintsDontDraw               = 1 shl 13;
  hintsAllowBlacklining       = 1 shl 14;
  hintsDontUseVideoOverlaySurface = 1 shl 16;
  hintsIgnoreBandwidthRestrictions = 1 shl 17;
  hintsPlayingEveryFrame      = 1 shl 18;
  hintsAllowDynamicResize     = 1 shl 19;
  hintsSingleField            = 1 shl 20;
  hintsNoRenderingTimeOut     = 1 shl 21;

 type
  playHintsEnum=unsigned_long;

 //...

(*****
     QT Atom Data Support
*****)
 const
  kParentAtomIsContainer      = 0;

(* create and dispose QTAtomContainer objects*)
 function QTNewAtomContainer(var atomData:QTAtomContainer):OSErr; cdecl; external 'qtmlClient.dll';
 function QTDisposeAtomContainer(atomData:QTAtomContainer):OSErr; cdecl; external 'qtmlClient.dll';

(* locating nested atoms within QTAtomContainer container *)
 function QTGetNextChildType(container:QTAtomContainer;parentAtom:QTAtom;currentChildType:QTAtomType):QTAtomType; cdecl; external 'qtmlClient.dll';
 function QTCountChildrenOfType(container:QTAtomContainer;parentAtom:QTAtom;childType:QTAtomType):short; cdecl; external 'qtmlClient.dll';
 function QTFindChildByIndex(container:QTAtomContainer;parentAtom:QTAtom;atomType:QTAtomType;index:short;id:QTAtomIDPtr):QTAtom; cdecl; external 'qtmlClient.dll';
 function QTFindChildByID(container:QTAtomContainer;parentAtom:QTAtom;atomType:QTAtomType;id:QTAtomID;index:shortPtr):QTAtom; cdecl; external 'qtmlClient.dll';
 function QTNextChildAnyType(container:QTAtomContainer;parentAtom:QTAtom;currentChild:QTAtom;var nextChild:QTAtom):OSErr; cdecl; external 'qtmlClient.dll';

(* set a leaf atom's data *)
 function QTSetAtomData(container:QTAtomContainer;atom:QTAtom;dataSize:long;var atomData):OSErr; cdecl; external 'qtmlClient.dll';

(* extracting data *)
 function QTCopyAtomDataToHandle(container:QTAtomContainer;atom:QTAtom;targetHandle:Handle):OSErr; cdecl; external 'qtmlClient.dll';
 function QTCopyAtomDataToPtr(container:QTAtomContainer;atom:QTAtom;sizeOrLessOK:Boolean;size:long;var targetPtr;actualSize:longPtr):OSErr; cdecl; external 'qtmlClient.dll';
 function QTGetAtomTypeAndID(container:QTAtomContainer;atom:QTAtom;atomType:QTAtomTypePtr;var id:QTAtomID):OSErr; cdecl; external 'qtmlClient.dll';

(* extract a copy of an atom and all of it's children, caller disposes *)
 function QTCopyAtom(container:QTAtomContainer;atom:QTAtom;var targetContainer:QTAtomContainer):OSErr; cdecl; external 'qtmlClient.dll';

(* obtaining direct reference to atom data *)
 function QTLockContainer(container:QTAtomContainer):OSErr; cdecl; external 'qtmlClient.dll';
 function QTGetAtomDataPtr(container:QTAtomContainer;atom:QTAtom;var dataSize:long;var atomData:Ptr):OSErr; cdecl; external 'qtmlClient.dll';
 function QTUnlockContainer(container:QTAtomContainer):OSErr; cdecl; external 'qtmlClient.dll';

(*
   building QTAtomContainer trees
   creates and inserts new atom at specified index, existing atoms at or after index are moved toward end of list
   used for Top-Down tree creation
*)
 function QTInsertChild(container:QTAtomContainer;parentAtom:QTAtom;atomType:QTAtomType;id:QTAtomID;index:short;dataSize:long;data:pointer;newAtom:QTAtomPtr):OSErr; cdecl; external 'qtmlClient.dll';

(* inserts children from childrenContainer as children of parentAtom *)
 function QTInsertChildren(container:QTAtomContainer;parentAtom:QTAtom;childrenContainer:QTAtomContainer):OSErr; cdecl; external 'qtmlClient.dll';

(* destruction*)
 function QTRemoveAtom(container:QTAtomContainer;atom:QTAtom):OSErr; cdecl; external 'qtmlClient.dll';
 function QTRemoveChildren(container:QTAtomContainer;atom:QTAtom):OSErr; cdecl; external 'qtmlClient.dll';

(* replacement must be same type as target *)
 function QTReplaceAtom(targetContainer:QTAtomContainer;targetAtom:QTAtom;replacementContainer:QTAtomContainer;replacementAtom:QTAtom):OSErr; cdecl; external 'qtmlClient.dll';
 function QTSwapAtoms(container:QTAtomContainer;atom1:QTAtom;atom2:QTAtom):OSErr; cdecl; external 'qtmlClient.dll';
 function QTSetAtomID(container:QTAtomContainer;atom:QTAtom;newID:QTAtomID):OSErr; cdecl; external 'qtmlClient.dll';
 function QTGetAtomParent(container:QTAtomContainer;childAtom:QTAtom):QTAtom; cdecl; external 'qtmlClient.dll';
 function SetMediaPropertyAtom(theMedia:Media;propertyAtom:QTAtomContainer):OSErr; cdecl; external 'qtmlClient.dll';
 function GetMediaPropertyAtom(theMedia:Media;var propertyAtom:QTAtomContainer):OSErr; cdecl; external 'qtmlClient.dll';

(*****
    Tween Support
*****)

  //...

(*****
    Sound Description Manipulations
*****)

  //...


 type
  SampleReferenceRecord=packed record
   dataOffset:long;
   dataSize:long;
   durationPerSample:TimeValue;
   numberOfSamples:long;
   sampleFlags:short;
   end;
  SampleReferencePtr=^SampleReferenceRecord;

  SampleReference64Record=packed record
   dataOffset:wide;
   dataSize:unsigned_long;
   durationPerSample:TimeValue;
   numberOfSamples:unsigned_long;
   sampleFlags:short;
   end;
  SampleReference64Ptr=^SampleReference64Record;

 //...

 function EnterMovies:OSErr; cdecl; external 'qtmlClient.dll';
 procedure ExitMovies; cdecl; external 'qtmlClient.dll';

 procedure DisposeMovie(theMovie:Movie);cdecl; external 'qtmlClient.dll';
 function MCIsPlayerEvent(mc:MovieController;const e:EventRecordPtr):ComponentResult; cdecl; external 'qtmlClient.dll';
 procedure MoviesTask(theMovie:Movie;maxMilliSecToUse:long); cdecl; external 'qtmlClient.dll';
 procedure SetMovieActive(theMovie:Movie;active:Boolean); cdecl; external 'qtmlClient.dll';

 (* calls for editing *)
 function MCEnableEditing(mc:MovieController;enabled:Boolean):ComponentResult; cdecl; external 'qtmlClient.dll';
 function MCIsEditingEnabled(mc:MovieController):long; cdecl; external 'qtmlClient.dll';
 function MCCopy(mc:MovieController):Movie; cdecl; external 'qtmlClient.dll';
 function MCCut(mc:MovieController):Movie; cdecl; external 'qtmlClient.dll';
 function MCPaste(mc:MovieController;srcMovie:Movie):ComponentResult; cdecl; external 'qtmlClient.dll';
 function MCClear(mc:MovieController):ComponentResult; cdecl; external 'qtmlClient.dll';
 function MCUndo(mc:MovieController):ComponentResult; cdecl; external 'qtmlClient.dll';

 (* Movie State Routines *)
 function GetMovieCreationTime(theMovie:Movie):cardinal; cdecl; external 'qtmlClient.dll';
 function GetMovieModificationTime(theMovie:Movie):cardinal; cdecl; external 'qtmlClient.dll';
 function GetMovieTimeScale(theMovie:Movie):TimeScale; cdecl; external 'qtmlClient.dll';
 procedure SetMovieTimeScale(theMovie:Movie;timeScale:TimeScale); cdecl; external 'qtmlClient.dll';
 function GetMovieDuration(theMovie:Movie):TimeValue; cdecl; external 'qtmlClient.dll';
 function GetMovieRate(theMovie:Movie):Fixed; cdecl; external 'qtmlClient.dll';
 procedure SetMovieRate(theMovie:Movie;rate:Fixed); cdecl; external 'qtmlClient.dll';
 function GetMoviePreferredRate(theMovie:Movie):Fixed; cdecl; external 'qtmlClient.dll';
 procedure SetMoviePreferredRate(theMovie:Movie;rate:Fixed); cdecl; external 'qtmlClient.dll';
 function GetMoviePreferredVolume(theMovie:Movie):short; cdecl; external 'qtmlClient.dll';
 procedure SetMoviePreferredVolume(theMovie:Movie;volume:short); cdecl; external 'qtmlClient.dll';
 function GetMovieVolume(theMovie:Movie):short; cdecl; external 'qtmlClient.dll';
 procedure SetMovieVolume(theMovie:Movie;volume:short); cdecl; external 'qtmlClient.dll';
 //...
 procedure GetMovieMatrix(theMovie:Movie;var matrix:MatrixRecord); cdecl; external 'qtmlClient.dll';
 procedure SetMovieMatrix(theMovie:Movie;{const} var matrix:MatrixRecord); cdecl; external 'qtmlClient.dll';
 procedure GetMoviePreviewTime(theMovie:Movie;var previewTime:TimeValue;var previewDuration:TimeValue); cdecl; external 'qtmlClient.dll';
 procedure SetMoviePreviewTime(theMovie:Movie;previewTime:TimeValue;previewDuration:TimeValue); cdecl; external 'qtmlClient.dll';
 function GetMoviePosterTime(theMovie:Movie):TimeValue; cdecl; external 'qtmlClient.dll';
 procedure SetMoviePosterTime(theMovie:Movie;posterTime:TimeValue); cdecl; external 'qtmlClient.dll';
 procedure GetMovieSelection(theMovie:Movie;var selectionTime:TimeValue;var selectionDuration:TimeValue); cdecl; external 'qtmlClient.dll';
 procedure SetMovieSelection(theMovie:Movie;selectionTime:TimeValue;selectionDuration:TimeValue); cdecl; external 'qtmlClient.dll';
 procedure SetMovieActiveSegment(theMovie:Movie;startTime:TimeValue;duration:TimeValue); cdecl; external 'qtmlClient.dll';
 procedure GetMovieActiveSegment(theMovie:Movie;var startTime:TimeValue;var duration:TimeValue); cdecl; external 'qtmlClient.dll';
 function GetMovieTime(theMovie:Movie;currentTime:TimeRecordPtr):TimeValue; cdecl; external 'qtmlClient.dll';
 procedure SetMovieTime(theMovie:Movie;const newtime:TimeRecordPtr); cdecl; external 'qtmlClient.dll';
 procedure SetMovieTimeValue(theMovie:Movie;newtime:TimeValue); cdecl; external 'qtmlClient.dll';
 function GetMovieUserData(theMovie:Movie):UserData; cdecl; external 'qtmlClient.dll';


 function MCDoAction(mc:MovieController;action:short;params:pointer):ComponentResult; cdecl; external 'qtmlClient.dll';

 (* calls for playing movies, previews, posters *)

 procedure StartMovie(theMovie:Movie); cdecl; external 'qtmlClient.dll';
 procedure StopMovie(theMovie:Movie); cdecl; external 'qtmlClient.dll';
 procedure GoToBeginningOfMovie(theMovie:Movie); cdecl; external 'qtmlClient.dll';
 procedure GoToEndOfMovie(theMovie:Movie); cdecl; external 'qtmlClient.dll';
 function IsMovieDone(theMovie:Movie):Boolean; cdecl; external 'qtmlClient.dll';
 function GetMoviePreviewMode(theMovie:Movie):Boolean; cdecl; external 'qtmlClient.dll';
 procedure SetMoviePreviewMode(theMovie:Movie;usePreview:Boolean); cdecl; external 'qtmlClient.dll';
 procedure ShowMoviePoster(theMovie:Movie); cdecl; external 'qtmlClient.dll';
// procedure PlayMoviePreview(theMovie:Movie;callOutProc:MoviePreviewCallOutUPP;refcon:long); cdecl; external 'qtmlClient.dll';

 (* calls for controlling movies & tracks which are playing *)

 function GetMovieTimeBase(theMovie:Movie):TimeBase; cdecl; external 'qtmlClient.dll';
 procedure SetMovieMasterTimeBase(theMovie:Movie;tb:TimeBase;const slaveZero:TimeRecord); cdecl; external 'qtmlClient.dll';
 procedure SetMovieMasterClock(theMovie:Movie;clockMeister:Component;var slaveZero:TimeRecord); cdecl; external 'qtmlClient.dll';
 procedure GetMovieGWorld(theMovie:Movie;var port:CGrafPtr;var gdh:GDHandle); cdecl; external 'qtmlClient.dll';
 procedure SetMovieGWorld(theMovie:Movie;port:CGrafPtr;gdh:GDHandle); cdecl; external 'qtmlClient.dll';

 const movieDrawingCallWhenChanged	= 0; //Delphi: was C untyped enum, made constants
       movieDrawingCallAlways		= 1;

// procedure SetMovieDrawingCompleteProc(theMovie:Movie;flags:long;proc:MovieDrawingCompleteUPP;refCon:long); cdecl; external 'qtmlClient.dll';
 procedure GetMovieNaturalBoundsRect(theMovie:Movie;var naturalBounds:Rect); cdecl; external 'qtmlClient.dll';
 function GetNextTrackForCompositing(theMovie:Movie;theTrack:Track):Track; cdecl; external 'qtmlClient.dll';
 function GetPrevTrackForCompositing(theMovie:Movie;theTrack:Track):Track; cdecl; external 'qtmlClient.dll';
// procedure SetTrackGWorld(theTrack:Track;port:CGrafPtr;gdh:GDHandle;proc:TrackTransferUPP;refCon:long); cdecl; external 'qtmlClient.dll';
 function GetMoviePict(theMovie:Movie;time:TimeValue):PicHandle; cdecl; external 'qtmlClient.dll';
 function GetTrackPict(theTrack:Track;time:TimeValue):PicHandle; cdecl; external 'qtmlClient.dll';
 function GetMoviePosterPict(theMovie:Movie):PicHandle; cdecl; external 'qtmlClient.dll';

 (* called between Begin & EndUpdate *)

 function UpdateMovie(theMovie:Movie):OSErr; cdecl; external 'qtmlClient.dll';
 function InvalidateMovieRegion(theMovie:Movie;invalidRgn:RgnHandle):OSErr; cdecl; external 'qtmlClient.dll';

 (* spatial movie routines *)
 procedure GetMovieBox(theMovie:Movie;var boxRect:Rect); cdecl; external 'qtmlClient.dll';
 procedure SetMovieBox(theMovie:Movie;const boxRect:Rect); cdecl; external 'qtmlClient.dll';

 (* movie display clip *)

 function GetMovieDisplayClipRgn(theMovie:Movie):RgnHandle; cdecl; external 'qtmlClient.dll';
 procedure SetMovieDisplayClipRgn(theMovie:Movie;theClip:RgnHandle); cdecl; external 'qtmlClient.dll';

 (* movie src clip *)

 function GetMovieClipRgn(theMovie:Movie):RgnHandle; cdecl; external 'qtmlClient.dll';
 procedure SetMovieClipRgn(theMovie:Movie;theClip:RgnHandle); cdecl; external 'qtmlClient.dll';

 (* track src clip *)

 function GetTrackClipRgn(theTrack:Track):RgnHandle; cdecl; external 'qtmlClient.dll';
 procedure SetTrackClipRgn(theTrack:Track;theClip:RgnHandle); cdecl; external 'qtmlClient.dll';

 (* state type things *)
 function MCGetControllerBoundsRect(mc:MovieController;var bounds:Rect):ComponentResult; cdecl; external 'qtmlClient.dll';
 function MCSetControllerBoundsRect(mc:MovieController;const bounds:Rect):ComponentResult; cdecl; external 'qtmlClient.dll';

 (* Error Routines *)
 function GetMoviesError:OSErr; cdecl; external 'qtmlClient.dll';
 function ClearMoviesStickyError:OSErr; cdecl; external 'qtmlClient.dll';
 function GetMoviesStickyError:OSErr; cdecl; external 'qtmlClient.dll';

 (* Track/Media finding routines *)
 function GetMovieTrackCount(theMovie:Movie):long; cdecl; external 'qtmlClient.dll';
 function GetMovieTrack(theMovie:Movie;trackID:long):Track; cdecl; external 'qtmlClient.dll';
 function GetMovieIndTrack(theMovie:Movie;index:long):Track; cdecl; external 'qtmlClient.dll';
 function GetMovieIndTrackType(theMovie:Movie;index:long;trackType:OSType;flags:long):Track; cdecl; external 'qtmlClient.dll';
 function GetTrackID(theTrack:Track):long; cdecl; external 'qtmlClient.dll';
 function GetTrackMovie(theTrack:Track):Movie; cdecl; external 'qtmlClient.dll';

(*************************
* Track creation routines
**************************)

 function NewMovieTrack(theMovie:Movie;width:Fixed;height:Fixed;trackVolume:short):Track; cdecl; external 'qtmlClient.dll';
 procedure DisposeMovieTrack(theTrack:Track); cdecl; external 'qtmlClient.dll';

(*************************
* Track State routines
**************************)

 function GetTrackCreationTime(theTrack:Track):unsigned_long; cdecl; external 'qtmlClient.dll';
 function GetTrackModificationTime(theTrack:Track):unsigned_long; cdecl; external 'qtmlClient.dll';
 function GetTrackEnabled(theTrack:Track):Boolean; cdecl; external 'qtmlClient.dll';
 procedure SetTrackEnabled(theTrack:Track;isEnabled:Boolean); cdecl; external 'qtmlClient.dll';
 function GetTrackUsage(theTrack:Track):long; cdecl; external 'qtmlClient.dll';
 procedure SetTrackUsage(theTrack:Track;usage:long); cdecl; external 'qtmlClient.dll';
 function GetTrackDuration(theTrack:Track):TimeValue; cdecl; external 'qtmlClient.dll';
 function GetTrackOffset(theTrack:Track):TimeValue; cdecl; external 'qtmlClient.dll';
 procedure SetTrackOffset(theTrack:Track;movieOffsetTime:TimeValue); cdecl; external 'qtmlClient.dll';
 function GetTrackLayer(theTrack:Track):short; cdecl; external 'qtmlClient.dll';
 procedure SetTrackLayer(theTrack:Track;layer:short); cdecl; external 'qtmlClient.dll';
 function GetTrackAlternate(theTrack:Track):Track; cdecl; external 'qtmlClient.dll';
 procedure SetTrackAlternate(theTrack:Track;alternateT:Track); cdecl; external 'qtmlClient.dll';
 procedure SetAutoTrackAlternatesEnabled(theMovie:Movie;enable:Boolean); cdecl; external 'qtmlClient.dll';
 procedure SelectMovieAlternates(theMovie:Movie); cdecl; external 'qtmlClient.dll';
 function GetTrackVolume(theTrack:Track):short; cdecl; external 'qtmlClient.dll';
 procedure SetTrackVolume(theTrack:Track;volume:short); cdecl; external 'qtmlClient.dll';
 procedure GetTrackMatrix(theTrack:Track;var matrix:MatrixRecord); cdecl; external 'qtmlClient.dll';
 procedure SetTrackMatrix(theTrack:Track;{const} var matrix:MatrixRecord); cdecl; external 'qtmlClient.dll';
 procedure GetTrackDimensions(theTrack:Track;var width:Fixed;var height:Fixed); cdecl; external 'qtmlClient.dll';
 procedure SetTrackDimensions(theTrack:Track;width:Fixed;height:Fixed); cdecl; external 'qtmlClient.dll';
 function GetTrackUserData(theTrack:Track):UserData; cdecl; external 'qtmlClient.dll';
 function GetTrackDisplayMatrix(theTrack:Track;var matrix:MatrixRecord):OSErr; cdecl; external 'qtmlClient.dll';
 function GetTrackSoundLocalizationSettings(theTrack:Track;var settings:Handle):OSErr; cdecl; external 'qtmlClient.dll';

(*************************
* get Media routines
**************************)

 function NewTrackMedia(theTrack:Track;mediaType:OSType;timeScale:TimeScale;dataRef:Handle;dataRefType:OSType):Media; cdecl; external 'qtmlClient.dll';
 procedure DisposeTrackMedia(theMedia:Media); cdecl; external 'qtmlClient.dll';
 function GetTrackMedia(theTrack:Track):Media; cdecl; external 'qtmlClient.dll';
 function GetMediaTrack(theMedia:Media):Track; cdecl; external 'qtmlClient.dll';

(*************************
* Media State routines
**************************)

 function GetMediaCreationTime(theMedia:Media):unsigned_long; cdecl; external 'qtmlClient.dll';
 function GetMediaModificationTime(theMedia:Media):unsigned_long; cdecl; external 'qtmlClient.dll';
 function GetMediaTimeScale(theMedia:Media):TimeScale; cdecl; external 'qtmlClient.dll';
 procedure SetMediaTimeScale(theMedia:Media;timeScale:TimeScale); cdecl; external 'qtmlClient.dll';
 function GetMediaDuration(theMedia:Media):TimeValue; cdecl; external 'qtmlClient.dll';
 function GetMediaLanguage(theMedia:Media):short; cdecl; external 'qtmlClient.dll';
 procedure SetMediaLanguage(theMedia:Media;language:short); cdecl; external 'qtmlClient.dll';
 function GetMediaQuality(theMedia:Media):short; cdecl; external 'qtmlClient.dll';
 procedure SetMediaQuality(theMedia:Media;quality:short); cdecl; external 'qtmlClient.dll';
 procedure GetMediaHandlerDescription(theMedia:Media;var mediaType:OSType;creatorName:Str255Ptr;creatorManufacturer:OSTypePtr); cdecl; external 'qtmlClient.dll';
 function GetMediaUserData(theMedia:Media):UserData; cdecl; external 'qtmlClient.dll';
 function GetMediaInputMap(theMedia:Media;var inputMap:QTAtomContainer):OSErr; cdecl; external 'qtmlClient.dll';
 function SetMediaInputMap(theMedia:Media;inputMap:QTAtomContainer):OSErr; cdecl; external 'qtmlClient.dll';

(*************************
* Media Handler routines
**************************)

 function GetMediaHandler(theMedia:Media):MediaHandler; cdecl; external 'qtmlClient.dll';
 function SetMediaHandler(theMedia:Media;mH:MediaHandlerComponent):OSErr; cdecl; external 'qtmlClient.dll';

(*************************
* Media's Data routines
**************************)

 function BeginMediaEdits(theMedia:Media):OSErr; cdecl; external 'qtmlClient.dll';
 function EndMediaEdits(theMedia:Media):OSErr; cdecl; external 'qtmlClient.dll';
 function SetMediaDefaultDataRefIndex(theMedia:Media;index:short):OSErr; cdecl; external 'qtmlClient.dll';
 procedure GetMediaDataHandlerDescription(theMedia:Media;index:short;var dhType:OSType;creatorName:Str255;var creatorManufacturer:OSType); cdecl; external 'qtmlClient.dll';
 function GetMediaDataHandler(theMedia:Media;index:short):DataHandler; cdecl; external 'qtmlClient.dll';
 function SetMediaDataHandler(theMedia:Media;index:short;dataHandler:DataHandlerComponent):OSErr; cdecl; external 'qtmlClient.dll';
 function GetDataHandler(dataRef:Handle;dataHandlerSubType:OSType;flags:long):Component; cdecl; external 'qtmlClient.dll';
 function OpenADataHandler(dataRef:Handle;dataHandlerSubType:OSType;anchorDataRef:Handle;anchorDataRefType:OSType;tb:TimeBase;flags:long;var dh:ComponentInstance):OSErr; cdecl; external 'qtmlClient.dll';

(*************************
* Media Sample Table Routines
**************************)

 function GetMediaSampleDescriptionCount(theMedia:Media):long; cdecl; external 'qtmlClient.dll';
 procedure GetMediaSampleDescription(theMedia:Media;index:long;descH:SampleDescriptionHandle); cdecl; external 'qtmlClient.dll';
 function SetMediaSampleDescription(theMedia:Media;index:long;descH:SampleDescriptionHandle):OSErr; cdecl; external 'qtmlClient.dll';
 function GetMediaSampleCount(theMedia:Media):long; cdecl; external 'qtmlClient.dll';
 function GetMediaSyncSampleCount(theMedia:Media):long; cdecl; external 'qtmlClient.dll';
 procedure SampleNumToMediaTime(theMedia:Media;logicalSampleNum:long;var sampleTime:TimeValue;var sampleDuration:TimeValue); cdecl; external 'qtmlClient.dll';
 procedure MediaTimeToSampleNum(theMedia:Media;time:TimeValue;var sampleNum:long;var sampleTime:TimeValue;var sampleDuration:TimeValue); cdecl; external 'qtmlClient.dll';
 function AddMediaSample(theMedia:Media;dataIn:Handle;inOffset:long;size:unsigned_long;durationPerSample:TimeValue;sampleDescriptionH:SampleDescriptionHandle;numberOfSamples:long;sampleFlags:short;sampleTime:TimeValuePtr):OSErr; cdecl; external 'qtmlClient.dll';
 function AddMediaSampleReference(theMedia:Media;dataOffset:long;size:unsigned_long;durationPerSample:TimeValue;sampleDescriptionH:SampleDescriptionHandle;numberOfSamples:long;sampleFlags:short;var sampleTime:TimeValue):OSErr; cdecl; external 'qtmlClient.dll';
 function AddMediaSampleReferences(theMedia:Media;sampleDescriptionH:SampleDescriptionHandle;numberOfSamples:long;sampleRefs:SampleReferencePtr;var sampleTime:TimeValue):OSErr; cdecl; external 'qtmlClient.dll';
 function AddMediaSampleReferences64(theMedia:Media;sampleDescriptionH:SampleDescriptionHandle;numberOfSamples:long;sampleRefs:SampleReference64Ptr;var sampleTime:TimeValue):OSErr; cdecl; external 'qtmlClient.dll';
 function GetMediaSample(theMedia:Media;dataOut:Handle;maxSizeToGrow:long;var size:long;time:TimeValue;var sampleTime:TimeValue;var durationPerSample:TimeValue;sampleDescriptionH:SampleDescriptionHandle;var sampleDescriptionIndex:long;maxNumberOfSamples:long;var numberOfSamples:long;var sampleFlags:short):OSErr; cdecl; external 'qtmlClient.dll';
 function GetMediaSampleReference(theMedia:Media;var dataOffset:long;var size:long;time:TimeValue;var sampleTime:TimeValue;var durationPerSample:TimeValue;sampleDescriptionH:SampleDescriptionHandle;var sampleDescriptionIndex:long;maxNumberOfSamples:long;var numberOfSamples:long;var sampleFlags:short):OSErr; cdecl; external 'qtmlClient.dll';
 function GetMediaSampleReferences(theMedia:Media;time:TimeValue;var sampleTime:TimeValue;sampleDescriptionH:SampleDescriptionHandle;var sampleDescriptionIndex:long;maxNumberOfEntries:long;var actualNumberofEntries:long;sampleRefs:SampleReferencePtr):OSErr; cdecl; external 'qtmlClient.dll';
 function GetMediaSampleReferences64(theMedia:Media;time:TimeValue;var sampleTime:TimeValue;sampleDescriptionH:SampleDescriptionHandle;var sampleDescriptionIndex:long;maxNumberOfEntries:long;var actualNumberofEntries:long;sampleRefs:SampleReference64Ptr):OSErr; cdecl; external 'qtmlClient.dll';
 function SetMediaPreferredChunkSize(theMedia:Media;maxChunkSize:long):OSErr; cdecl; external 'qtmlClient.dll';
 function GetMediaPreferredChunkSize(theMedia:Media;var maxChunkSize:long):OSErr; cdecl; external 'qtmlClient.dll';
 function SetMediaShadowSync(theMedia:Media;frameDiffSampleNum:long;syncSampleNum:long):OSErr; cdecl; external 'qtmlClient.dll';
 function GetMediaShadowSync(theMedia:Media;frameDiffSampleNum:long;var syncSampleNum:long):OSErr; cdecl; external 'qtmlClient.dll';

(*************************
* Editing Routines
**************************)

 function InsertMediaIntoTrack(theTrack:Track;trackStart:TimeValue;mediaTime:TimeValue;mediaDuration:TimeValue;mediaRate:Fixed):OSErr; cdecl; external 'qtmlClient.dll';
 function InsertTrackSegment(srcTrack:Track;dstTrack:Track;srcIn:TimeValue;srcDuration:TimeValue;dstIn:TimeValue):OSErr; cdecl; external 'qtmlClient.dll';
 function InsertMovieSegment(srcMovie:Movie;dstMovie:Movie;srcIn:TimeValue;srcDuration:TimeValue;dstIn:TimeValue):OSErr; cdecl; external 'qtmlClient.dll';
 function InsertEmptyTrackSegment(dstTrack:Track;dstIn:TimeValue;dstDuration:TimeValue):OSErr; cdecl; external 'qtmlClient.dll';
 function InsertEmptyMovieSegment(dstMovie:Movie;dstIn:TimeValue;dstDuration:TimeValue):OSErr; cdecl; external 'qtmlClient.dll';
 function DeleteTrackSegment(theTrack:Track;startTime:TimeValue;duration:TimeValue):OSErr; cdecl; external 'qtmlClient.dll';
 function DeleteMovieSegment(theMovie:Movie;startTime:TimeValue;duration:TimeValue):OSErr; cdecl; external 'qtmlClient.dll';
 function ScaleTrackSegment(theTrack:Track;startTime:TimeValue;oldDuration:TimeValue;newDuration:TimeValue):OSErr; cdecl; external 'qtmlClient.dll';
 function ScaleMovieSegment(theMovie:Movie;startTime:TimeValue;oldDuration:TimeValue;newDuration:TimeValue):OSErr; cdecl; external 'qtmlClient.dll';

(*************************
* Hi-level Editing Routines
**************************)

 function CutMovieSelection(theMovie:Movie):Movie; cdecl; external 'qtmlClient.dll';
 function CopyMovieSelection(theMovie:Movie):Movie; cdecl; external 'qtmlClient.dll';
 procedure PasteMovieSelection(theMovie:Movie;src:Movie); cdecl; external 'qtmlClient.dll';
 procedure AddMovieSelection(theMovie:Movie;src:Movie); cdecl; external 'qtmlClient.dll';
 procedure ClearMovieSelection(theMovie:Movie); cdecl; external 'qtmlClient.dll';
 function PasteHandleIntoMovie(h:Handle;handleType:OSType;theMovie:Movie;flags:long;userComp:ComponentInstance):OSErr; cdecl; external 'qtmlClient.dll';
 function PutMovieIntoTypedHandle(theMovie:Movie;targetTrack:Track;handleType:OSType;publicMovie:Handle;start:TimeValue;dur:TimeValue;flags:long;userComp:ComponentInstance):OSErr; cdecl; external 'qtmlClient.dll';
 function IsScrapMovie(targetTrack:Track):Component; cdecl; external 'qtmlClient.dll';

(*************************
* Middle-level Editing Routines
**************************)

 function CopyTrackSettings(srcTrack:Track;dstTrack:Track):OSErr; cdecl; external 'qtmlClient.dll';
 function CopyMovieSettings(srcMovie:Movie;dstMovie:Movie):OSErr; cdecl; external 'qtmlClient.dll';
 function AddEmptyTrackToMovie(srcTrack:Track;dstMovie:Movie;dataRef:Handle;dataRefType:OSType;var dstTrack:Track):OSErr; cdecl; external 'qtmlClient.dll';

 const
  kQTCloneShareSamples  = 1 shl 0;
  kQTCloneDontCopyEdits = 1 shl 1;

 function AddClonedTrackToMovie(srcTrack:Track;dstMovie:Movie;flags:long;var dstTrack:Track):OSErr; cdecl; external 'qtmlClient.dll';

(*************************
* movie & track edit state routines
**************************)

 function NewMovieEditState(theMovie:Movie):MovieEditState; cdecl; external 'qtmlClient.dll';
 function UseMovieEditState(theMovie:Movie;toState:MovieEditState):OSErr; cdecl; external 'qtmlClient.dll';
 function DisposeMovieEditState(state:MovieEditState):OSErr; cdecl; external 'qtmlClient.dll';
 function NewTrackEditState(theTrack:Track):TrackEditState; cdecl; external 'qtmlClient.dll';
 function UseTrackEditState(theTrack:Track;state:TrackEditState):OSErr; cdecl; external 'qtmlClient.dll';
 function DisposeTrackEditState(state:TrackEditState):OSErr; cdecl; external 'qtmlClient.dll';

(*************************
* track reference routines
**************************)

 function AddTrackReference(theTrack:Track;refTrack:Track;refType:OSType;addedIndex:longPtr):OSErr; cdecl; external 'qtmlClient.dll';
 function DeleteTrackReference(theTrack:Track;refType:OSType;index:long):OSErr; cdecl; external 'qtmlClient.dll';
 function SetTrackReference(theTrack:Track;refTrack:Track;refType:OSType;index:long):OSErr; cdecl; external 'qtmlClient.dll';
 function GetTrackReference(theTrack:Track;refType:OSType;index:long):Track; cdecl; external 'qtmlClient.dll';
 function GetNextTrackReferenceType(theTrack:Track;refType:OSType):OSType; cdecl; external 'qtmlClient.dll';
 function GetTrackReferenceCount(theTrack:Track;refType:OSType):long; cdecl; external 'qtmlClient.dll';

(************************
* high level file conversion routines
**************************)

 function ConvertFileToMovieFile({const}var inputFile:FSSpec;{const}var outputFile:FSSpec;creator:OSType;scriptTag:ScriptCode;var resID:short;flags:long;userComp:ComponentInstance;proc:MovieProgressUPP;refCon:long):OSErr; cdecl; external 'qtmlClient.dll';
 function ConvertMovieToFile(theMovie:Movie;onlyTrack:Track;var outputFile:FSSpec;fileType:OSType;creator:OSType;scriptTag:ScriptCode;var resID:short;flags:long;userComp:ComponentInstance):OSErr; cdecl; external 'qtmlClient.dll';

 const
  kGetMovieImporterValidateToFind = long(1) shl 0;
  kGetMovieImporterAllowNewFile = long(1) shl 1;
  kGetMovieImporterDontConsiderGraphicsImporters = long(1) shl 2;
  kGetMovieImporterDontConsiderFileOnlyImporters = long(1) shl 6;
  kGetMovieImporterAutoImportOnly = long(1) shl 10; (* reject aggressive movie importers which have dontAutoFileMovieImport set*)

 function GetMovieImporterForDataRef(dataRefType:OSType;dataRef:Handle;flags:long;var importer:Component):OSErr; cdecl; external 'qtmlClient.dll';

 const
  kQTGetMIMETypeInfoIsQuickTimeMovieType = (((ord('m') shl 8 +ord('o'))shl 8 +ord('o'))shl 8 +ord('v')); {'moov'} (* info is a pointer to a Boolean *)
  kQTGetMIMETypeInfoIsUnhelpfulType = (((ord('d') shl 8 +ord('u'))shl 8 +ord('m'))shl 8 +ord('b')); {'dumb'} (* info is a pointer to a Boolean *)

 function QTGetMIMETypeInfo({const} var mimeStringStart:char;mimeStringLength:short;infoSelector:OSType;var infoDataPtr;var infoDataSize:long):OSErr; cdecl; external 'qtmlClient.dll';

(*************************
* Movie Timebase Conversion Routines
**************************)

 function TrackTimeToMediaTime(value:TimeValue;theTrack:Track):TimeValue; cdecl; external 'qtmlClient.dll';
 function GetTrackEditRate(theTrack:Track;atTime:TimeValue):Fixed; cdecl; external 'qtmlClient.dll';

(*************************
* Miscellaneous Routines
**************************)

 function GetMovieDataSize(theMovie:Movie;startTime:TimeValue;duration:TimeValue):long; cdecl; external 'qtmlClient.dll';
 function GetMovieDataSize64(theMovie:Movie;startTime:TimeValue;duration:TimeValue;var dataSize:wide):OSErr; cdecl; external 'qtmlClient.dll';
 function GetTrackDataSize(theTrack:Track;startTime:TimeValue;duration:TimeValue):long; cdecl; external 'qtmlClient.dll';
 function GetTrackDataSize64(theTrack:Track;startTime:TimeValue;duration:TimeValue;var dataSize:wide):OSErr; cdecl; external 'qtmlClient.dll';
 function GetMediaDataSize(theMedia:Media;startTime:TimeValue;duration:TimeValue):long; cdecl; external 'qtmlClient.dll';
 function GetMediaDataSize64(theMedia:Media;startTime:TimeValue;duration:TimeValue;var dataSize:wide):OSErr; cdecl; external 'qtmlClient.dll';
 function PtInMovie(theMovie:Movie;pt:Point):Boolean; cdecl; external 'qtmlClient.dll';
 function PtInTrack(theTrack:Track;pt:Point):Boolean; cdecl; external 'qtmlClient.dll';

(*************************
* Group Selection Routines
**************************)

 procedure SetMovieLanguage(theMovie:Movie;language:long); cdecl; external 'qtmlClient.dll';

(*************************
* User Data
**************************)

 function GetUserData(theUserData:UserData;data:Handle;udType:OSType;index:long):OSErr; cdecl; external 'qtmlClient.dll';
 function AddUserData(theUserData:UserData;data:Handle;udType:OSType):OSErr; cdecl; external 'qtmlClient.dll';
 function RemoveUserData(theUserData:UserData;udType:OSType;index:long):OSErr; cdecl; external 'qtmlClient.dll';
 function CountUserDataType(theUserData:UserData;udType:OSType):short; cdecl; external 'qtmlClient.dll';
 function GetNextUserDataType(theUserData:UserData;udType:OSType):long; cdecl; external 'qtmlClient.dll';
 function GetUserDataItem(theUserData:UserData;var data;size:long;udType:OSType;index:long):OSErr; cdecl; external 'qtmlClient.dll';
 function SetUserDataItem(theUserData:UserData;var data;size:long;udType:OSType;index:long):OSErr; cdecl; external 'qtmlClient.dll';
 function AddUserDataText(theUserData:UserData;data:Handle;udType:OSType;index:long;itlRegionTag:short):OSErr; cdecl; external 'qtmlClient.dll';
 function GetUserDataText(theUserData:UserData;data:Handle;udType:OSType;index:long;itlRegionTag:short):OSErr; cdecl; external 'qtmlClient.dll';
 function RemoveUserDataText(theUserData:UserData;udType:OSType;index:long;itlRegionTag:short):OSErr; cdecl; external 'qtmlClient.dll';
 function NewUserData(var theUserData:UserData):OSErr; cdecl; external 'qtmlClient.dll';
 function DisposeUserData(theUserData:UserData):OSErr; cdecl; external 'qtmlClient.dll';
 function NewUserDataFromHandle(h:Handle;var theUserData:UserData):OSErr; cdecl; external 'qtmlClient.dll';
 function PutUserDataIntoHandle(theUserData:UserData;h:Handle):OSErr; cdecl; external 'qtmlClient.dll';
 function SetMoviePropertyAtom(theMovie:Movie;propertyAtom:QTAtomContainer):OSErr; cdecl; external 'qtmlClient.dll';
 function GetMoviePropertyAtom(theMovie:Movie;var propertyAtom:QTAtomContainer):OSErr; cdecl; external 'qtmlClient.dll';
 procedure GetMediaNextInterestingTime(theMedia:Media;interestingTimeFlags:short;time:TimeValue;rate:Fixed;var interestingTime:TimeValue;interestingDuration:TimeValuePtr); cdecl; external 'qtmlClient.dll';
 procedure GetTrackNextInterestingTime(theTrack:Track;interestingTimeFlags:short;time:TimeValue;rate:Fixed;var interestingTime:TimeValue;interestingDuration:TimeValuePtr); cdecl; external 'qtmlClient.dll';
 procedure GetMovieNextInterestingTime(theMovie:Movie;interestingTimeFlags:short;numMediaTypes:short;{const} whichMediaTypes:OSTypePtr;time:TimeValue;rate:Fixed;interestingTime:TimeValuePtr;interestingDuration:TimeValuePtr); cdecl; external 'qtmlClient.dll';
 function CreateMovieFile({const} var fileSpec:FSSpec;creator:OSType;scriptTag:ScriptCode;createMovieFileFlags:long;var resRefNum:short;var newmovie:Movie):OSErr; cdecl; external 'qtmlClient.dll';
 function OpenMovieFile({const} var fileSpec:FSSpec;var resRefNum:short;permission:SInt8):OSErr; cdecl; external 'qtmlClient.dll';
 function CloseMovieFile(resRefNum:short):OSErr; cdecl; external 'qtmlClient.dll';
 function DeleteMovieFile({const} var fileSpec:FSSpec):OSErr; cdecl; external 'qtmlClient.dll';
 function NewMovieFromFile(var theMovie:Movie;resRefNum:short;resId:shortPtr;resName:StringPtr;newMovieFlags:short;dataRefWasChanged:BooleanPtr):OSErr; cdecl; external 'qtmlClient.dll';
 function NewMovieFromHandle(var theMovie:Movie;h:Handle;newMovieFlags:short;var dataRefWasChanged:Boolean):OSErr; cdecl; external 'qtmlClient.dll';
 function NewMovieFromDataFork(var theMovie:Movie;fRefNum:short;fileOffset:long;newMovieFlags:short;var dataRefWasChanged:Boolean):OSErr; cdecl; external 'qtmlClient.dll';
 function NewMovieFromDataFork64(var theMovie:Movie;fRefNum:long;{const} var fileOffset:wide;newMovieFlags:short;var dataRefWasChanged:Boolean):OSErr; cdecl; external 'qtmlClient.dll';
 function NewMovieFromUserProc(var m:Movie;flags:short;var dataRefWasChanged:Boolean;getProc:GetMovieUPP;var refCon;defaultDataRef:Handle;dataRefType:OSType):OSErr; cdecl; external 'qtmlClient.dll';
 function NewMovieFromDataRef(var m:Movie;flags:short;id:shortPtr;dataRef:Handle;dataRefType:OSType):OSErr; cdecl; external 'qtmlClient.dll';
 function AddMovieResource(theMovie:Movie;resRefNum:short;var resId:short;resName:ConstStr255Param):OSErr; cdecl; external 'qtmlClient.dll';
 function UpdateMovieResource(theMovie:Movie;resRefNum:short;resId:short;resName:ConstStr255Param):OSErr; cdecl; external 'qtmlClient.dll';
 function RemoveMovieResource(resRefNum:short;resId:short):OSErr; cdecl; external 'qtmlClient.dll';
 function HasMovieChanged(theMovie:Movie):Boolean; cdecl; external 'qtmlClient.dll';
 procedure ClearMovieChanged(theMovie:Movie); cdecl; external 'qtmlClient.dll';
 function SetMovieDefaultDataRef(theMovie:Movie;dataRef:Handle;dataRefType:OSType):OSErr; cdecl; external 'qtmlClient.dll';
 function GetMovieDefaultDataRef(theMovie:Movie;var dataRef:Handle;var dataRefType:OSType):OSErr; cdecl; external 'qtmlClient.dll';
 function SetMovieAnchorDataRef(theMovie:Movie;dataRef:Handle;dataRefType:OSType):OSErr; cdecl; external 'qtmlClient.dll';
 function GetMovieAnchorDataRef(theMovie:Movie;var dataRef:Handle;var dataRefType:OSType;var outFlags:long):OSErr; cdecl; external 'qtmlClient.dll';
 function SetMovieColorTable(theMovie:Movie;ctab:CTabHandle):OSErr; cdecl; external 'qtmlClient.dll';
 function GetMovieColorTable(theMovie:Movie;var ctab:CTabHandle):OSErr; cdecl; external 'qtmlClient.dll';
 procedure FlattenMovie(theMovie:Movie;movieFlattenFlags:long;{const} var theFile:FSSpec;creator:OSType;scriptTag:ScriptCode;createMovieFileFlags:long;var resId:short;resName:ConstStr255Param); cdecl; external 'qtmlClient.dll';
 function FlattenMovieData(theMovie:Movie;movieFlattenFlags:long;{const} var theFile:FSSpec;creator:OSType;scriptTag:ScriptCode;createMovieFileFlags:long):Movie; cdecl; external 'qtmlClient.dll';
 procedure SetMovieProgressProc(theMovie:Movie;p:MovieProgressUPP;refcon:long); cdecl; external 'qtmlClient.dll';
 procedure GetMovieProgressProc(theMovie:Movie;var p:MovieProgressUPP;var refcon:long); cdecl; external 'qtmlClient.dll';
 function CreateShortcutMovieFile({const} var fileSpec:FSSpec;creator:OSType;scriptTag:ScriptCode;createMovieFileFlags:long;targetDataRef:Handle;targetDataRefType:OSType):OSErr; cdecl; external 'qtmlClient.dll';
 function MovieSearchText(theMovie:Movie;text:Ptr;size:long;searchFlags:long;var searchTrack:Track;var searchTime:TimeValue;var searchOffset:long):OSErr; cdecl; external 'qtmlClient.dll';
 procedure GetPosterBox(theMovie:Movie;var boxRect:Rect); cdecl; external 'qtmlClient.dll';
 procedure SetPosterBox(theMovie:Movie;{const} var boxRect:Rect); cdecl; external 'qtmlClient.dll';
 function GetMovieSegmentDisplayBoundsRgn(theMovie:Movie;time:TimeValue;duration:TimeValue):RgnHandle; cdecl; external 'qtmlClient.dll';
 function GetTrackSegmentDisplayBoundsRgn(theTrack:Track;time:TimeValue;duration:TimeValue):RgnHandle; cdecl; external 'qtmlClient.dll';
 procedure SetMovieCoverProcs(theMovie:Movie;uncoverProc:MovieRgnCoverUPP;coverProc:MovieRgnCoverUPP;refcon:long); cdecl; external 'qtmlClient.dll';
 function GetMovieCoverProcs(theMovie:Movie;var uncoverProc:MovieRgnCoverUPP;var coverProc:MovieRgnCoverUPP;var refcon:long):OSErr; cdecl; external 'qtmlClient.dll';
 function GetTrackStatus(theTrack:Track):ComponentResult; cdecl; external 'qtmlClient.dll';

 const
  kMovieLoadStateError         = long(-1);
  kMovieLoadStateLoading       = 1000;
  kMovieLoadStateLoaded        = 2000;
  kMovieLoadStatePlayable      = 10000;
  kMovieLoadStatePlaythroughOK = 20000;
  kMovieLoadStateComplete      = long(100000);

 function GetMovieLoadState(theMovie:Movie):long; cdecl; external 'qtmlClient.dll';

 (* Input flags for CanQuickTimeOpenFile/DataRef *)
 const
  kQTDontUseDataToFindImporter = long(1) shl 0;
  kQTDontLookForMovieImporterIfGraphicsImporterFound = long(1) shl 1;
  kQTAllowOpeningStillImagesAsMovies = long(1) shl 2;
  kQTAllowImportersThatWouldCreateNewFile = long(1) shl 3;
  kQTAllowAggressiveImporters = long(1) shl 4;         (* eg, TEXT and PICT movie importers *)

 (* Determines whether the file could be opened using a graphics importer or opened in place as a movie. *)
 function CanQuickTimeOpenFile(fileSpec:FSSpecPtr;fileType:OSType;fileNameExtension:OSType;var outCanOpenWithGraphicsImporter:Boolean;var outCanOpenAsMovie:Boolean;var outPreferGraphicsImporter:Boolean;inFlags:UInt32):OSErr; cdecl; external 'qtmlClient.dll';

 (* Determines whether the file could be opened using a graphics importer or opened in place as a movie. *)
 function CanQuickTimeOpenDataRef(dataRef:Handle;dataRefType:OSType;var outCanOpenWithGraphicsImporter:Boolean;var outCanOpenAsMovie:Boolean;var outPreferGraphicsImporter:Boolean;inFlags:UInt32):OSErr; cdecl; external 'qtmlClient.dll';

(***************
*  Movie Controller support routines
****************)

 function NewMovieController(theMovie:Movie;const movieRect:RectPtr;someFlags:long):ComponentInstance;cdecl; external 'qtmlClient.dll';
 procedure DisposeMovieController(mc:ComponentInstance);cdecl; external 'qtmlClient.dll';
 //procedure ShowMovieInformation(theMovie:Movie;filterProc:ModalFilterUPP;refCon:long); cdecl; external 'qtmlClient.dll';

(***********
*  Scrap routines
************)

 function PutMovieOnScrap(theMovie:Movie;movieScrapFlags:long):OSErr; cdecl; external 'qtmlClient.dll';
 function NewMovieFromScrap(newMovieFlags:long):Movie; cdecl; external 'qtmlClient.dll';

(*****
*   DataRef routines
*****)

 function GetMediaDataRef(theMedia:Media;index:short;var dataRef:Handle;var dataRefType:OSType;var dataRefAttributes:long):OSErr; cdecl; external 'qtmlClient.dll';
 function SetMediaDataRef(theMedia:Media;index:short;dataRef:Handle;dataRefType:OSType):OSErr; cdecl; external 'qtmlClient.dll';
 function SetMediaDataRefAttributes(theMedia:Media;index:short;dataRefAttributes:long):OSErr; cdecl; external 'qtmlClient.dll';
 function AddMediaDataRef(theMedia:Media;var index:short;dataRef:Handle;dataRefType:OSType):OSErr; cdecl; external 'qtmlClient.dll';
 function GetMediaDataRefCount(theMedia:Media;var count:short):OSErr; cdecl; external 'qtmlClient.dll';
 function QTNewAlias({const} var fss:FSSpec;var alias:AliasHandle;minimal:Boolean):OSErr; cdecl; external 'qtmlClient.dll';

(*****
*   Playback hint routines
*****)

 procedure SetMoviePlayHints(theMovie:Movie;flags:long;flagsMask:long); cdecl; external 'qtmlClient.dll';
 procedure SetMediaPlayHints(theMedia:Media;flags:long;flagsMask:long); cdecl; external 'qtmlClient.dll';
 procedure GetMediaPlayHints(theMedia:Media;var flags:long); cdecl; external 'qtmlClient.dll';

(*****
*   Load time track hints
*****)

 const
  preloadAlways        = long(1) shl 0;
  preloadOnlyIfEnabled = long(1) shl 1;

 procedure SetTrackLoadSettings(theTrack:Track;preloadTime:TimeValue;preloadDuration:TimeValue;preloadFlags:long;defaultHints:long); cdecl; external 'qtmlClient.dll';
 procedure GetTrackLoadSettings(theTrack:Track;var preloadTime:TimeValue;var preloadDuration:TimeValue;var preloadFlags:long;var defaultHints:long); cdecl; external 'qtmlClient.dll';

(*****
*   Big screen TV
*****)

 const
  fullScreenHideCursor        = long(1) shl 0;
  fullScreenAllowEvents       = long(1) shl 1;
  fullScreenDontChangeMenuBar = long(1) shl 2;
  fullScreenPreflightSize     = long(1) shl 3;

 function BeginFullScreen(var restoreState:Ptr;whichGD:GDHandle;var desiredWidth:short;var desiredHeight:short;var newWindow:WindowRef;var eraseColor:RGBColor;flags:long):OSErr; cdecl; external 'qtmlClient.dll';
 function EndFullScreen(fullState:Ptr;flags:long):OSErr; cdecl; external 'qtmlClient.dll';

(*****
*   Wired Actions
*****)
(* flags for MovieExecuteWiredActions*)
 const
  movieExecuteWiredActionDontExecute = long(1) shl 0;

 function AddMovieExecuteWiredActionsProc(theMovie:Movie;proc:MovieExecuteWiredActionsUPP;var refCon):OSErr; cdecl; external 'qtmlClient.dll';
 function RemoveMovieExecuteWiredActionsProc(theMovie:Movie;proc:MovieExecuteWiredActionsUPP;var refCon):OSErr; cdecl; external 'qtmlClient.dll';
 function MovieExecuteWiredActions(theMovie:Movie;flags:long;actions:QTAtomContainer):OSErr; cdecl; external 'qtmlClient.dll';

 //...sprites etc.

////////////////

 function MCIdle(mc:MovieController):ComponentResult; cdecl; external 'qtmlClient.dll';
 function MCSetVisible(mc:MovieController;visible:Boolean):ComponentResult; cdecl; external 'qtmlClient.dll';
 function MCGetVisible(mc:MovieController):ComponentResult; cdecl; external 'qtmlClient.dll';

 (* target management *)
 function MCSetMovie(mc:MovieController;theMovie:Movie;movieWindow:WindowPtr;where:Point):ComponentResult; cdecl; external 'qtmlClient.dll';
 function MCGetIndMovie(mc:MovieController;index:short):Movie; cdecl; external 'qtmlClient.dll';
 function MCGetMovie(mc:MovieController):Movie; //Delphi: C macro implemented as a function
 function MCRemoveAllMovies(mc:MovieController):ComponentResult; cdecl; external 'qtmlClient.dll';
 function MCRemoveAMovie(mc:MovieController;m:Movie):ComponentResult; cdecl; external 'qtmlClient.dll';
 function MCRemoveMovie(mc:MovieController):ComponentResult; cdecl; external 'qtmlClient.dll';

 type MCActionFilterWithRefConUPP=pointer; //?

 (* somewhat special stuff *)
 function MCSetActionFilterWithRefCon(mc:MovieController;blob:MCActionFilterWithRefConUPP;refCon:long):ComponentResult; cdecl; external 'qtmlClient.dll';

implementation

function MCGetMovie;
begin
 result:=MCGetIndMovie(mc, 0);
end; //Delphi: C macro implemented as a function

end.

