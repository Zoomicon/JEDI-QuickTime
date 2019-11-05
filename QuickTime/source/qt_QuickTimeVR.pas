(************************************************************************
*
*       Borland Delphi Runtime Library
*       QuickTime interface unit
*
* Portions created by Apple Computer, Inc. are
* Copyright (C) 1997-1998 Apple Computer, Inc..
* All Rights Reserved.
*
* The original file is: QuickTimeVR.h, released dd Mmm yyyy.
* The original Pascal code is: qt_QuickTimeVR.pas, released 14 May 2000.
* The initial developer of the Pascal code is George Birbilis
* (birbilis@cti.gr).
*
* Portions created by George Birbilis are
* Copyright (C) 1998-2005 George Birbilis
*
*       Obtained through:
*
*       Joint Endeavour of Delphi Innovators (Project JEDI)
*
* You may retrieve the latest version of this file at the Project
* JEDI home page, located at http://delphi-jedi.org
*
* The contents of this file are used with permission, subject to
* the Mozilla Public License Version 1.1 (the "License"); you may
* not use this file except in compliance with the License. You may
* obtain a copy of the License at
* http://www.mozilla.org/MPL/MPL-1.1.html
*
* Software distributed under the License is distributed on an
* "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
* implied. See the License for the specific language governing
* rights and limitations under the License.
*
************************************************************************)

(* HISTORY:
 14May2000 - birbilis: donated to Delphi-JEDI
 08Oct2001 - birbilis: added hotspot related calls and "events & cursor" related calls
 07Nov2001 - birbilis: added "View State Calls" section
 08Nov2001 - birbilis: added "Scene and Node Location Information" section
                       added the missing "object specific" calls to the "Viewing Angles and Zooming" section
                       added "Basic Conversion and Math Routines" section
                       added "Object Movie Specific Calls" section
                       added "Imaging Characteristics" section
                       added "Viewing Limits and Constraints" section
                       added "Back Buffer Memory Management" section
                       added "Interaction Routines" section
                       added missing constants
 25Feb2002 - birbilis: fixed "kQTVRDefaultNode" and "kQTVRPreviousNode" to be of
                       "UInt32" type, not "long" type (QT API for C was wrong
                       here, since "QTVRGoToNodeID" needs a "UInt32" nodeID
                       parameter and can accept those two special nodeID values
                       as well
 13Apr2002 - birbilis: fixed-bug: changed all "out" parameters to "var"
 19May2005 - birbilis: changed license header text to conserve disk space
                       added dynamic linking (default) to QuickTimeVR.qtx via a compiler define
*)

//This translation from C to Object Pascal should now be complete, or almost complete!

{$DEFINE DYNAMIC_LINKING}

unit qt_QuickTimeVR;

interface
 uses C_Types,
      qt_MacTypes,qt_Movies,qt_Errors,qt_QuickDraw;

 //QuickTimeVR.h//

 type OpaqueQTVRInstance=packed record end;//Pascal's empty record = C's empty struct
      QTVRInstance=^OpaqueQTVRInstance;
      QTVRInstancePtr=^QTVRInstance;

 (* Released API Version numbers *)
 const kQTVRAPIMajorVersion02=($02);
 const kQTVRAPIMinorVersion00=($00);
 const kQTVRAPIMinorVersion01=($01);
 const kQTVRAPIMinorVersion10=($10);

 (* Version numbers for the API described in this header *)
 const kQTVRAPIMajorVersion=kQTVRAPIMajorVersion02;
 const kQTVRAPIMinorVersion=kQTVRAPIMinorVersion10;

 const kQTVRControllerSubType = (((ord('c')shl 8 +ord('t'))shl 8 +ord('y'))shl 8 +ord('p')); {'ctyp'}
       kQTVRQTVRType	      = (((ord('q')shl 8 +ord('t'))shl 8 +ord('v'))shl 8 +ord('r')); {'qtvr'}
       kQTVRPanoramaType      = (((ord('p')shl 8 +ord('a'))shl 8 +ord('n'))shl 8 +ord('o')); {'pano'}
       kQTVRObjectType	      = (((ord('o')shl 8 +ord('b'))shl 8 +ord('j'))shl 8 +ord('e')); {'obje'}
       kQTVROldPanoType	      = (((ord('S')shl 8 +ord('T'))shl 8 +ord('p'))shl 8 +ord('n')); {'STpn'} //Used in QTVR 1.0 release
       kQTVROldObjectType     = (((ord('s')shl 8 +ord('t'))shl 8 +ord('n'))shl 8 +ord('a')); {'stna'} //Used in QTVR 1.0 release

 const kQTVRUnknownType=(((ord('?') shl 8 +ord('?'))shl 8 +ord('?'))shl 8 +ord('?')); {'????'}	// Unknown node type
(* //Delphi: this must be wrong in the QuickTimeVR.h
#if TARGET_OS_MAC
#define kQTVRUnknownType '????'		// Unknown node type
#else
#define kQTVRUnknownType '\?\?\?\?'	// Unknown node type
#endif  /* TARGET_OS_MAC */
*)

 (* QTVR hot spot types*)

 const kQTVRHotSpotLinkType		= (((ord('l') shl 8 +ord('i'))shl 8 +ord('n'))shl 8 +ord('k')); {'link'}
       kQTVRHotSpotURLType		= (((ord('u') shl 8 +ord('r'))shl 8 +ord('l'))shl 8 +ord(' ')); {'url '}
       kQTVRHotSpotUndefinedType	= (((ord('u') shl 8 +ord('n'))shl 8 +ord('d'))shl 8 +ord('f')); {'undf'}

 (* Special Values for nodeID in QTVRGoToNodeID *)

 const kQTVRCurrentNode			= 0;
       kQTVRPreviousNode		= UInt32($80000000); //Birb: had "long" here, fixed cause "QTVRGoToNodeID" needs unsigned value
       kQTVRDefaultNode			= UInt32($80000001); //Birb: had "long" here, fixed cause "QTVRGoToNodeID" needs unsigned value

 (* Panorama correction modes used for the kQTVRImagingCorrection imaging property *)

 const kQTVRNoCorrection		= 0;
       kQTVRPartialCorrection		= 1;
       kQTVRFullCorrection		= 2;

 (* Imaging Modes used by QTVRSetImagingProperty, QTVRGetImagingProperty, QTVRUpdate, QTVRBeginUpdate *)

 const kQTVRStatic	= 1;
       kQTVRMotion	= 2;
       kQTVRCurrentMode	= 0;   //Special Value for QTVRUpdate
       kQTVRAllModes	= 100; //Special value for QTVRSetProperty
 type QTVRImagingMode=UInt32;

 (* Imaging Properties used by QTVRSetImagingProperty, QTVRGetImagingProperty *)
 const kQTVRImagingCorrection  = 1;
       kQTVRImagingQuality     = 2;
       kQTVRImagingDirectDraw  = 3;
       kQTVRImagingCurrentMode = 100; //Get Only

 (* OR the above with kImagingDefaultValue to get/set the default value *)
 const kImagingDefaultValue = long($80000000);

 (* Transition Types used by QTVRSetTransitionProperty, QTVREnableTransition *)
 const kQTVRTransitionSwing = 1;

 (* Transition Properties QTVRSetTransitionProperty *)
 const kQTVRTransitionSpeed	= 1;
       kQTVRTransitionDirection	= 2;

 (* Constraint values used to construct value returned by GetConstraintStatus *)
 const kQTVRUnconstrained      = 0;
       kQTVRCantPanLeft	       = 1 shl 0;
       kQTVRCantPanRight       = 1 shl 1;
       kQTVRCantPanUp	       = 1 shl 2;
       kQTVRCantPanDown	       = 1 shl 3;
       kQTVRCantZoomIn	       = 1 shl 4;
       kQTVRCantZoomOut	       = 1 shl 5;
       kQTVRCantTranslateLeft  = 1 shl 6;
       kQTVRCantTranslateRight = 1 shl 7;
       kQTVRCantTranslateUp    = 1 shl 8;
       kQTVRCantTranslateDown  = 1 shl 9;

 (* Object-only mouse mode values used to construct value returned by QTVRGetCurrentMouseMode *)
 const kQTVRPanning	= 1 shl 0; //standard objects, "object only" controllers
       kQTVRTranslating	= 1 shl 1; //all objects
       kQTVRZooming	= 1 shl 2; //all objects
       kQTVRScrolling	= 1 shl 3; //standard object arrow scrollers and joystick object
       kQTVRSelecting	= 1 shl 4; //object absolute controller

 (* Properties for use with QTVRSetInteractionProperty/GetInteractionProperty *)
 const kQTVRInteractionMouseClickHysteresis = 1;   //pixels within which the mouse is considered not to have moved (UInt16)
       kQTVRInteractionMouseClickTimeout    = 2;   //ticks after which a mouse click times out and turns into panning (UInt32)
       kQTVRInteractionPanTiltSpeed         = 3;   //control the relative pan/tilt speed from 1 (slowest) to 10 (fastest). (UInt32) Default is 5
       kQTVRInteractionZoomSpeed	    = 4;   //control the relative zooming speed from 1 (slowest) to 10 (fastest). (UInt32) Default is 5
       kQTVRInteractionTranslateOnMouseDown = 101; //Holding MouseDown with this setting translates zoomed object movies (Boolean)
       kQTVRInteractionMouseMotionScale     = 102; //The maximum angle of rotation caused by dragging across the display window (float pointer)
       kQTVRInteractionNudgeMode	    = 103; //A QTVRNudgeMode: rotate, translate, or the same as the current mouse mode. Requires QTVR 2.1

 (* OR the above with kQTVRInteractionDefaultValue to get/set the default value *)
 const kQTVRInteractionDefaultValue = long($80000000);

 (* Geometry constants used in QTVRSetBackBufferPrefs, QTVRGetBackBufferSettings, QTVRGetBackBufferMemInfo *)
 const kQTVRUseMovieGeometry   = 0;
       kQTVRVerticalCylinder   = (((ord('v') shl 8 +ord('c'))shl 8 +ord('y'))shl 8 +ord('l'));
       kQTVRHorizontalCylinder = (((ord('h') shl 8 +ord('c'))shl 8 +ord('y'))shl 8 +ord('l'));

 (* Resolution constants used in QTVRSetBackBufferPrefs, QTVRGetBackBufferSettings, QTVRGetBackBufferMemInfo *)
 const kQTVRDefaultRes = 0;
       kQTVRFullRes    = 1 shl 0;
       kQTVRHalfRes    = 1 shl 1;
       kQTVRQuarterRes = 1 shl 2;

 (* QTVR-specific pixelFormat constants used in QTVRSetBackBufferPrefs, QTVRGetBackBufferSettings, QTVRGetBackBufferMemInfo *)
 const kQTVRUseMovieDepth = 0;

 (* Cache Size Pref constants used in QTVRSetBackBufferPrefs, QTVRGetBackBufferSettings *)
 const kQTVRMinimumCache   = -1;
       kQTVRSuggestedCache = 0;
       kQTVRFullCache	   = 1;

 const (* Angular units used by QTVRSetAngularUnits *)
       kQTVRDegrees = 0;
       kQTVRRadians = 1;
 type QTVRAngularUnits=UInt32;
       
 (* Values for enableFlag parameter in QTVREnableHotSpot *)
 const kQTVRHotSpotID	= 0;
       kQTVRHotSpotType	= 1;
       kQTVRAllHotSpots	= 2;

 (* Values for kind parameter in QTVRGet/SetConstraints, QTVRGetViewingLimits *)
 const kQTVRPan		= 0;
       kQTVRTilt	= 1;
       kQTVRFieldOfView	= 2;
       kQTVRViewCenterH	= 4; //WrapAndConstrain only
       kQTVRViewCenterV	= 5; //WrapAndConstrain only

 (* Values for setting parameter in QTVRSetAnimationSetting, QTVRGetAnimationSetting *)
 const //View Frame Animation Settings
       kQTVRPalindromeViewFrames = 1;
       kQTVRStartFirstViewFrame  = 2;
       kQTVRDontLoopViewFrames	 = 3;
       kQTVRPlayEveryViewFrame	 = 4; //Requires QTVR 2.1 (kQTVRAPIMajorVersion02 + kQTVRAPIMinorVersion10)
       //View Animation Settings
       kQTVRSyncViewToFrameRate	= 16;
       kQTVRPalindromeViews	= 17;
       kQTVRPlayStreamingViews	= 18; //Requires QTVR 2.1 (kQTVRAPIMajorVersion02 + kQTVRAPIMinorVersion10)
 type QTVRObjectAnimationSetting=UInt32;

 const kQTVRWrapPan	    = 1;
       kQTVRWrapTilt	    = 2;
       kQTVRCanZoom	    = 3;
       kQTVRReverseHControl = 4;
       kQTVRReverseVControl = 5;
       kQTVRSwapHVControl   = 6;
       kQTVRTranslation	    = 7;
 type QTVRControlSetting=UInt32;

 const kQTVRDefault   = 0;
       kQTVRCurrent   = 2;
       kQTVRMouseDown = 3;
 type QTVRViewStateType=UInt32;

 const kQTVRRight     = 0;
       kQTVRUpRight   = 45;
       kQTVRUp	      = 90;
       kQTVRUpLeft    = 135;
       kQTVRLeft      = 180;
       kQTVRDownLeft  = 225;
       kQTVRDown      = 270;
       kQTVRDownRight = 315;
 type QTVRNudgeControl=UInt32;

 const kQTVRNudgeRotate	     = 0;
       kQTVRNudgeTranslate   = 1;
       kQTVRNudgeSameAsMouse = 2;
 type QTVRNudgeMode=UInt32;

 (* Flags to control elements of the QTVR control bar (set via mcActionSetFlags) *)
 const mcFlagQTVRSuppressBackBtn      = long(1) shl 16;
       mcFlagQTVRSuppressZoomBtns     = long(1) shl 17;
       mcFlagQTVRSuppressHotSpotBtn   = long(1) shl 18;
       mcFlagQTVRSuppressTranslateBtn = long(1) shl 19;
       mcFlagQTVRSuppressHelpText     = long(1) shl 20;
       mcFlagQTVRSuppressHotSpotNames = long(1) shl 21;
       mcFlagQTVRExplicitFlagSet      = long(1) shl 31; //bits 0->30 should be interpreted as "explicit on" for the corresponding suppression bits

 (* Cursor types used in type field of QTVRCursorRecord*)
 const kQTVRUseDefaultCursor = 0;
       kQTVRStdCursorType    = 1;
       kQTVRColorCursorType  = 2;

(* Values for flags parameter in QTVRMouseOverHotSpot callback*)
 const	kQTVRHotSpotEnter		= 0;
	kQTVRHotSpotWithin		= 1;
	kQTVRHotSpotLeave		= 2;

 (* Values for flags parameter in QTVRSetPrescreenImagingCompleteProc *)
 const kQTVRPreScreenEveryIdle = 1 shl 0; //Requires QTVR 2.1 (kQTVRAPIMajorVersion02 + kQTVRAPIMinorVersion10)

 (* Values for flags field of areasOfInterest in QTVRSetBackBufferImagingProc *)
 const kQTVRBackBufferEveryUpdate   = 1 shl 0;
       kQTVRBackBufferEveryIdle	    = 1 shl 1;
       kQTVRBackBufferAlwaysRefresh = 1 shl 2;
       kQTVRBackBufferHorizontal    = 1 shl 3; //Requires that backbuffer proc be long-rowBytes aware (gestaltQDHasLongRowBytes)

 (* Values for flagsIn parameter in QTVRBackBufferImaging callback *)
 const kQTVRBackBufferRectVisible  = 1 shl 0;
       kQTVRBackBufferWasRefreshed = 1 shl 1;

 (* Values for flagsOut parameter in QTVRBackBufferImaging callback *)
 const kQTVRBackBufferFlagDidDraw  = 1 shl 0;
       kQTVRBackBufferFlagLastFlag = long(1) shl 31;

 (* QTVRCursorRecord used in QTVRReplaceCursor*)

 type QTVRCursorRecord=packed record
       theType:UInt16; //field was previously named "type"
       rsrcID:SInt16;
       handle:Handle;
       end;

 type QTVRFloatPoint=packed record
       x:float;
       y:float;
       end;

 (* Struct used for areasOfInterest parameter in QTVRSetBackBufferImagingProc *)
 type QTVRAreaOfInterest=packed record
       panAngle:float;
       tiltAngle:float;
       width:float;
       height:float;
       flags:UInt32;
       end;
      QTVRAreaOfInterestPtr=^QTVRAreaOfInterest;

(*
  =================================================================================================
   Callback routines
  -------------------------------------------------------------------------------------------------
*)
type QTVRLeavingNodeProcPtr=function(qtvr:QTVRInstance;fromNodeID:UInt32;toNodeID:UInt32;var cancel:boolean;refCon:SInt32):OSErr; cdecl;
     QTVREnteringNodeProcPtr=function(qtvr:QTVRInstance;nodeID:UInt32;refCon:SInt32):OSErr; cdecl;
     QTVRMouseOverHotSpotProcPtr=function(qtvr:QTVRInstance;hotSpotID:UInt32;flags:UInt32;refCon:SInt32):OSErr; cdecl;
     QTVRImagingCompleteProcPtr=function(qtvr:QTVRInstance;refCon:SInt32):OSErr; cdecl;
     QTVRBackBufferImagingProcPtr=function(qtvr:QTVRInstance;var drawRect:Rect;areaIndex:UInt16;flagsIn:UInt32;var flagsOut:UInt32;refCon:SInt32):OSErr; cdecl;
     QTVRLeavingNodeUPP=QTVRLeavingNodeProcPtr;
     QTVREnteringNodeUPP=QTVREnteringNodeProcPtr;
     QTVRMouseOverHotSpotUPP=QTVRMouseOverHotSpotProcPtr;
     QTVRImagingCompleteUPP=QTVRImagingCompleteProcPtr;
     QTVRBackBufferImagingUPP=QTVRBackBufferImagingProcPtr;

{$ifdef OPAQUE_UPP_TYPES}
function NewQTVRLeavingNodeUPP(userRoutine:QTVRLeavingNodeProcPtr):QTVRLeavingNodeUPP; //EXTERN_API=cdecl in QT-Windows
function NewQTVREnteringNodeUPP(userRoutine:QTVREnteringNodeProcPtr):QTVREnteringNodeUPP;
function NewQTVRMouseOverHotSpotUPP(userRoutine:QTVRMouseOverHotSpotProcPtr):QTVRMouseOverHotSpotUPP; cdecl;
function NewQTVRImagingCompleteUPP(userRoutine:QTVRImagingCompleteProcPtr):QTVRImagingCompleteUPP; cdecl;
function NewQTVRBackBufferImagingUPP(userRoutine:QTVRBackBufferImagingProcPtr):QTVRBackBufferImagingUPP; cdecl;
procedure DisposeQTVRLeavingNodeUPP(userUPP:QTVRLeavingNodeUPP); cdecl;
procedure DisposeQTVREnteringNodeUPP(userUPP:QTVREnteringNodeUPP); cdecl;
procedure DisposeQTVRMouseOverHotSpotUPP(userUPP:QTVRMouseOverHotSpotUPP); cdecl;
procedure DisposeQTVRImagingCompleteUPP(userUPP:QTVRImagingCompleteUPP); cdecl;
function InvokeQTVRLeavingNodeUPP(qtvr:QTVRInstance;fromNodeID:UInt32;toNodeID:UInt32;var cancel:Boolean;refCon:SInt32;userUPP:QTVRLeavingNodeUPP):OSErr; cdecl;
function InvokeQTVREnteringNodeUPP(qtvr:QTVRInstance;nodeID:UInt32;refCon:SInt32;userUPP:QTVREnteringNodeUPP):OSErr; cdecl;
function InvokeQTVRMouseOverHotSpotUPP(qtvr:QTVRInstance;hotSpotID:UInt32;flags:UInt32;refCon:SInt32;userUPP:QTVRMouseOverHotSpotUPP):OSErr; cdecl;
function InvokeQTVRImagingCompleteUPP(qtvr:QTVRInstance;refCon:SInt32;userUPP:QTVRImagingCompleteUPP):OSErr; cdecl;
function InvokeQTVRBackBufferImagingUPP(qtvr:QTVRInstance;var drawRect:Rect;areaIndex:UInt16;flagsIn:UInt32;var flagsOut:UInt32;refCon:SInt32;userUPP:QTVRBackBufferImagingUPP):OSErr; cdecl;
{$else}
const uppQTVRLeavingNodeProcInfo = $0000FFE0; //pascal 2_bytes Func(4_bytes, 4_bytes, 4_bytes, 4_bytes, 4_bytes)
      uppQTVREnteringNodeProcInfo = $00000FE0; //pascal 2_bytes Func(4_bytes, 4_bytes, 4_bytes)
      uppQTVRMouseOverHotSpotProcInfo = $00003FE0; //pascal 2_bytes Func(4_bytes, 4_bytes, 4_bytes, 4_bytes)
      uppQTVRImagingCompleteProcInfo = $000003E0; //pascal 2_bytes Func(4_bytes, 4_bytes)
      uppQTVRBackBufferImagingProcInfo = $0003FBE0; //pascal 2_bytes Func(4_bytes, 4_bytes, 2_bytes, 4_bytes, 4_bytes, 4_bytes)
      //...
{$endif}


(*
  =================================================================================================
    QTVR Intercept Struct, Callback, Routine Descriptors
  -------------------------------------------------------------------------------------------------
*)

const
  kQTVRSetPanAngleSelector	= $2000;
	kQTVRSetTiltAngleSelector	= $2001;
	kQTVRSetFieldOfViewSelector	= $2002;
	kQTVRSetViewCenterSelector	= $2003;
	kQTVRMouseEnterSelector		= $2004;
	kQTVRMouseWithinSelector	= $2005;
	kQTVRMouseLeaveSelector		= $2006;
	kQTVRMouseDownSelector		= $2007;
	kQTVRMouseStillDownSelector	= $2008;
	kQTVRMouseUpSelector		= $2009;
	kQTVRTriggerHotSpotSelector	= $200A;
	kQTVRGetHotSpotTypeSelector	= $200B; (* Requires QTVR 2.1 (kQTVRAPIMajorVersion02 + kQTVRAPIMinorVersion10)*)

type
 QTVRProcSelector=UInt32;

 QTVRInterceptRecord=packed record
  reserved1:SInt32;
  selector:SInt32;

  reserved2:SInt32;
  reserved3:SInt32;

  paramCount:SInt32;
  parameter:array[0..5] of pointer;
  end;

 QTVRInterceptPtr=^QTVRInterceptRecord;

(* Prototype for Intercept Proc callback*)
type
 QTVRInterceptProcPtr=procedure(qtvr:QTVRInstance;qtvrMsg:QTVRInterceptPtr;refCon:SInt32;cancel:BooleanPtr); cdecl; //CALLBACK_API=cdecl in QT-Windows
 QTVRInterceptUPP={STACK_UPP_TYPE(}QTVRInterceptProcPtr{)}; //STACK_UPP_TYPE(name)=name in QT-Windows

{$ifndef OPAQUE_UPP_TYPES}
//...
{$else}
const uppQTVRInterceptProcInfo = $00003FC0; //pascal no_return_value Func(4_bytes, 4_bytes, 4_bytes, 4_bytes)
{$endif}
function NewQTVRInterceptProc(userRoutine:QTVRInterceptProcPtr):QTVRInterceptUPP;
procedure CallQTVRInterceptProc(userRoutine:QTVRInterceptProcPtr; qtvr:QTVRInstance; qtvrMsg:QTVRInterceptPtr; refCon:SInt32; cancel:BooleanPtr);

(*
  =================================================================================================
    Initialization QTVR calls
  -------------------------------------------------------------------------------------------------
   Requires QTVR 2.1 (kQTVRAPIMajorVersion02 + kQTVRAPIMinorVersion10) and only work on Non-Macintosh platforms
*)

{$IFNDEF TARGET_OS_MAC}
 function InitializeQTVR:OSErr;
 function TerminateQTVR:OSErr;
{$ENDIF}

{$IFNDEF DYNAMIC_LINKING}

(*
  =================================================================================================
    General QTVR calls
  -------------------------------------------------------------------------------------------------
*)

 function QTVRGetQTVRTrack(theMovie:Movie;index:SInt32):Track; cdecl;
 function QTVRGetQTVRInstance(var qtvr:QTVRInstance;qtvrTrack:Track;mc:MovieController):OSErr; cdecl;

(*
  =================================================================================================
    Viewing Angles and Zooming
  -------------------------------------------------------------------------------------------------
*)

 function QTVRSetPanAngle(qtvr:QTVRInstance;panAngle:float):OSErr; cdecl;
 function QTVRGetPanAngle(qtvr:QTVRInstance):float; cdecl;
 function QTVRSetTiltAngle(qtvr:QTVRInstance;tiltAngle:float):OSErr; cdecl;
 function QTVRGetTiltAngle(qtvr:QTVRInstance):float; cdecl;
 function QTVRSetFieldOfView(qtvr:QTVRInstance;fieldOfView:float):OSErr; cdecl;
 function QTVRGetFieldOfView(qtvr:QTVRInstance):float; cdecl;
 function QTVRShowDefaultView(qtvr:QTVRInstance):OSErr; cdecl;

 //Object Specific//
 function QTVRSetViewCenter(qtvr:QTVRInstance;{const}var viewCenter:QTVRFloatPoint):OSErr; cdecl;
 function QTVRGetViewCenter(qtvr:QTVRInstance;var viewCenter:QTVRFloatPoint):OSErr; cdecl;
 function QTVRNudge(qtvr:QTVRInstance;direction:QTVRNudgeControl):OSErr; cdecl;
 //QTVRInteractionNudge requires QTVR 2.1 (kQTVRAPIMajorVersion02 + kQTVRAPIMinorVersion10)
 function QTVRInteractionNudge(qtvr:QTVRInstance;direction:QTVRNudgeControl):OSErr; cdecl;

(*
  =================================================================================================
    Scene and Node Location Information
  -------------------------------------------------------------------------------------------------
*)

 function QTVRGetVRWorld(qtvr:QTVRInstance;var VRWorld:QTAtomContainer):OSErr; cdecl;
 function QTVRGetNodeInfo(qtvr:QTVRInstance;nodeID:UInt32;var nodeInfo:QTAtomContainer):OSErr; cdecl;
 function QTVRGoToNodeID(qtvr:QTVRInstance;nodeID:UInt32):OSErr; cdecl;
 function QTVRGetCurrentNodeID(qtvr:QTVRInstance):UInt32; cdecl;
 function QTVRGetNodeType(qtvr:QTVRInstance;nodeID:UInt32):OSType; cdecl;

(*
  =================================================================================================
    Hot Spot related calls
  -------------------------------------------------------------------------------------------------
*)

 function QTVRPtToHotSpotID(qtvr:QTVRInstance;pt:Point;var hotSpotID):OSErr; cdecl;
 //QTVRGetHotSpotType requires QTVR 2.1 (kQTVRAPIMajorVersion02 + kQTVRAPIMinorVersion10)
 function QTVRGetHotSpotType(qtvr:QTVRInstance;hotSpotID:UInt32;var hotSpotType:OSType):OSErr; cdecl;
 function QTVRTriggerHotSpot(qtvr:QTVRInstance;hotSpotID:UInt32;nodeInfo:QTAtomContainer;selectedAtom:QTAtom):OSErr; cdecl;
 function QTVRSetMouseOverHotSpotProc(qtvr:QTVRInstance;mouseOverHotSpotProc:QTVRMouseOverHotSpotUPP;refCon:SInt32;flags:UInt32):OSErr; cdecl;
 function QTVREnableHotSpot(qtvr:QTVRInstance;enableFlag:UInt32;hotSpotValue:UInt32;enable:Boolean):OSErr; cdecl;
 function QTVRGetVisibleHotSpots(qtvr:QTVRInstance;hotSpots:Handle):UInt32; cdecl;
 function QTVRGetHotSpotRegion(qtvr:QTVRInstance;hotSpotID:UInt32;hotSpotRegion:RgnHandle):OSErr; cdecl;

(*
  =================================================================================================
    Event & Cursor Handling Calls
  -------------------------------------------------------------------------------------------------
*)

 function QTVRSetMouseOverTracking(qtvr:QTVRInstance;enable:Boolean):OSErr; cdecl;
 function QTVRGetMouseOverTracking(qtvr:QTVRInstance):Boolean; cdecl;
 function QTVRSetMouseDownTracking(qtvr:QTVRInstance;enable:Boolean):OSErr; cdecl;
 function QTVRGetMouseDownTracking(qtvr:QTVRInstance):Boolean; cdecl;
 function QTVRMouseEnter(qtvr:QTVRInstance;pt:Point;var hotSpotID:UInt32;w:WindowPtr):OSErr; cdecl;
 function QTVRMouseWithin(qtvr:QTVRInstance;pt:Point;var hotSpotID:UInt32;w:WindowPtr):OSErr; cdecl;
 function QTVRMouseLeave(qtvr:QTVRInstance;pt:Point;w:WindowPtr):OSErr; cdecl;
 function QTVRMouseDown(qtvr:QTVRInstance;pt:Point;when:UInt32;modifiers:UInt16;var hotSpotID:UInt32;w:WindowPtr):OSErr; cdecl;
 function QTVRMouseStillDown(qtvr:QTVRInstance;pt:Point;var hotSpotID:UInt32;w:WindowPtr):OSErr; cdecl;
 function QTVRMouseUp(qtvr:QTVRInstance;pt:Point;var hotSpotID:UInt32;w:WindowPtr):OSErr; cdecl;
 //These require QTVR 2.01 (kQTVRAPIMajorVersion02 + kQTVRAPIMinorVersion01)
 function QTVRMouseStillDownExtended(qtvr:QTVRInstance;pt:Point;var hotSpotID:UInt32;w:WindowPtr;when:UInt32;modifiers:UInt16):OSErr; cdecl;
 function QTVRMouseUpExtended(qtvr:QTVRInstance;pt:Point;var hotSpotID:UInt32;w:WindowPtr;when:UInt32;modifiers:UInt16):OSErr; cdecl;

(*
  =================================================================================================
    Intercept Routines
  -------------------------------------------------------------------------------------------------
*)

 function QTVRInstallInterceptProc(
  qtvr:QTVRInstance;
  selector:QTVRProcSelector;
  interceptProc:QTVRInterceptUPP;
  refCon:SInt32;
  flags:UInt32):OSErr;cdecl;

 function QTVRCallInterceptedProc(qtvr:QTVRInstance;qtvrMsg:QTVRInterceptPtr):OSErr;cdecl; //QTVRInterceptPtr=^QTVRInterceptRecord

(*
  =================================================================================================
    Object Movie Specific Calls
  -------------------------------------------------------------------------------------------------
   QTVRGetCurrentMouseMode requires QTRVR 2.1 (kQTVRAPIMajorVersion02 + kQTVRAPIMinorVersion10)
*)

 function QTVRGetCurrentMouseMode(qtvr:QTVRInstance):UInt32; cdecl;
 function QTVRSetFrameRate(qtvr:QTVRInstance;rate:float):OSErr; cdecl;
 function QTVRGetFrameRate(qtvr:QTVRInstance):float; cdecl;
 function QTVRSetViewRate(qtvr:QTVRInstance;rate:float):OSErr; cdecl;
 function QTVRGetViewRate(qtvr:QTVRInstance):float; cdecl;
 function QTVRSetViewCurrentTime(qtvr:QTVRInstance;time:TimeValue):OSErr; cdecl;
 function QTVRGetViewCurrentTime(qtvr:QTVRInstance):TimeValue; cdecl;
 function QTVRGetCurrentViewDuration(qtvr:QTVRInstance):TimeValue; cdecl;

(*
  =================================================================================================
   View State Calls - QTVR Object Only
  -------------------------------------------------------------------------------------------------
*)

 function QTVRSetViewState(qtvr:QTVRInstance;viewStateType:QTVRViewStateType;state:UInt16):OSErr; cdecl;
 function QTVRGetViewState(qtvr:QTVRInstance;viewStateType:QTVRViewStateType;var state:UInt16):OSErr; cdecl;
 function QTVRGetViewStateCount(qtvr:QTVRInstance):UInt16; cdecl;
 function QTVRSetAnimationSetting(qtvr:QTVRInstance;setting:QTVRObjectAnimationSetting;enable:Boolean):OSErr; cdecl;
 function QTVRGetAnimationSetting(qtvr:QTVRInstance;setting:QTVRObjectAnimationSetting;var enable:Boolean):OSErr; cdecl;
 function QTVRSetControlSetting(qtvr:QTVRInstance;setting:QTVRControlSetting;enable:Boolean):OSErr; cdecl;
 function QTVRGetControlSetting(qtvr:QTVRInstance;setting:QTVRControlSetting;var enable:Boolean):OSErr; cdecl;
 function QTVREnableFrameAnimation(qtvr:QTVRInstance;enable:Boolean):OSErr; cdecl;
 function QTVRGetFrameAnimation(qtvr:QTVRInstance):Boolean; cdecl;
 function QTVREnableViewAnimation(qtvr:QTVRInstance;enable:Boolean):OSErr; cdecl;
 function QTVRGetViewAnimation(qtvr:QTVRInstance):Boolean; cdecl;

(*
  =================================================================================================
    Imaging Characteristics
  -------------------------------------------------------------------------------------------------
*)

 function QTVRSetVisible(qtvr:QTVRInstance;visible:Boolean):OSErr; cdecl;
 function QTVRGetVisible(qtvr:QTVRInstance):Boolean; cdecl;
 function QTVRSetImagingProperty(qtvr:QTVRInstance;imagingMode:QTVRImagingMode;imagingProperty:UInt32;propertyValue:SInt32):OSErr; cdecl;
 function QTVRGetImagingProperty(qtvr:QTVRInstance;imagingMode:QTVRImagingMode;imagingProperty:UInt32;var propertyValue:SInt32):OSErr; cdecl;
 function QTVRUpdate(qtvr:QTVRInstance;imagingMode:QTVRImagingMode):OSErr; cdecl;
 function QTVRBeginUpdateStream(qtvr:QTVRInstance;imagingMode:QTVRImagingMode):OSErr; cdecl;
 function QTVREndUpdateStream(qtvr:QTVRInstance):OSErr; cdecl;
 function QTVRSetTransitionProperty(qtvr:QTVRInstance;transitionType:UInt32;transitionProperty:UInt32;transitionValue:SInt32):OSErr; cdecl;
 function QTVREnableTransition(qtvr:QTVRInstance;transitionType:UInt32;enable:Boolean):OSErr; cdecl;

(*
  =================================================================================================
    Basic Conversion and Math Routines
  -------------------------------------------------------------------------------------------------
*)

 function QTVRSetAngularUnits(qtvr:QTVRInstance;units:QTVRAngularUnits):OSErr; cdecl;
 function QTVRGetAngularUnits(qtvr:QTVRInstance):QTVRAngularUnits; cdecl;

 //Pano specific routines//
 function QTVRPtToAngles(qtvr:QTVRInstance;pt:Point;var panAngle:float;var tiltAngle:float):OSErr; cdecl;
 function QTVRCoordToAngles(qtvr:QTVRInstance;var coord:QTVRFloatPoint;var panAngle:float;var tiltAngle:float):OSErr; cdecl;
 function QTVRAnglesToCoord(qtvr:QTVRInstance;panAngle:float;tiltAngle:float;var coord:QTVRFloatPoint):OSErr; cdecl;

 //Object specific routines//
 function QTVRPanToColumn(qtvr:QTVRInstance;panAngle:float):short; cdecl; //zero based
 function QTVRColumnToPan(qtvr:QTVRInstance;column:short):float; cdecl; //zero based
 function QTVRTiltToRow(qtvr:QTVRInstance;tiltAngle:float):short; cdecl; //zero based
 function QTVRRowToTilt(qtvr:QTVRInstance;row:short):float; cdecl; //zero based
 function QTVRWrapAndConstrain(qtvr:QTVRInstance;kind:short;value:float;var result:float):OSErr; cdecl;

(*
  =================================================================================================
    Interaction Routines
  -------------------------------------------------------------------------------------------------
*)

 function QTVRSetEnteringNodeProc(qtvr:QTVRInstance;enteringNodeProc:QTVREnteringNodeUPP;refCon:SInt32;flags:UInt32):OSErr; cdecl;
 function QTVRSetLeavingNodeProc(qtvr:QTVRInstance;leavingNodeProc:QTVRLeavingNodeUPP;refCon:SInt32;flags:UInt32):OSErr; cdecl;
 function QTVRSetInteractionProperty(qtvr:QTVRInstance;theProperty:UInt32;var value):OSErr; cdecl; //birbilis: changed "property" to "theProperty" (property is a reserved word in Delphi)
 function QTVRGetInteractionProperty(qtvr:QTVRInstance;theProperty:UInt32;var value):OSErr; cdecl; //birbilis: changed "property" to "theProperty" (property is a reserved word in Delphi)
 function QTVRReplaceCursor(qtvr:QTVRInstance;var cursRecord:QTVRCursorRecord):OSErr; cdecl;

(*
  =================================================================================================
    Viewing Limits and Constraints
  -------------------------------------------------------------------------------------------------
*)
 function QTVRGetViewingLimits(qtvr:QTVRInstance;kind:UInt16;var minValue:float;var maxValue:float):OSErr; cdecl;
 function QTVRGetConstraintStatus(qtvr:QTVRInstance):UInt32; cdecl;
 function QTVRGetConstraints(qtvr:QTVRInstance;kind:UInt16;var minValue:float;var maxValue:float):OSErr; cdecl;
 function QTVRSetConstraints(qtvr:QTVRInstance;kind:UInt16;minValue:float;maxValue:float):OSErr; cdecl;

(*
  =================================================================================================
    Back Buffer Memory Management
  -------------------------------------------------------------------------------------------------
*)

 function QTVRGetAvailableResolutions(qtvr:QTVRInstance;var resolutionsMask:UInt16):OSErr; cdecl;
 //These require QTVR 2.1 (kQTVRAPIMajorVersion02 + kQTVRAPIMinorVersion10)//
 function QTVRGetBackBufferMemInfo(qtvr:QTVRInstance;geometry:UInt32;resolution:UInt16;cachePixelFormat:UInt32;var minCacheBytes:SInt32;var suggestedCacheBytes:SInt32;var fullCacheBytes:SInt32):OSErr; cdecl;
 function QTVRGetBackBufferSettings(qtvr:QTVRInstance;var geometry:UInt32;var resolution:UInt16;var cachePixelFormat:UInt32;var cacheSize:SInt16):OSErr; cdecl;

(*
  =================================================================================================
    Buffer Access
  -------------------------------------------------------------------------------------------------
*)

 function QTVRSetPrescreenImagingCompleteProc(qtvr:QTVRInstance;imagingCompleteProc:QTVRImagingCompleteUPP;refCon:SInt32;flags:UInt32):OSErr; cdecl;
 function QTVRSetBackBufferImagingProc(qtvr:QTVRInstance;backBufferImagingProc:QTVRBackBufferImagingUPP;numAreas:UInt16;areasOfInterest:QTVRAreaOfInterestPtr;refCon:SInt32):OSErr; cdecl; //areasOfInterest is a pointer to an array
 function QTVRRefreshBackBuffer(qtvr:QTVRInstance;flags:UInt32):OSErr; cdecl;

{$ELSE}

type

(*
  =================================================================================================
    General QTVR calls
  -------------------------------------------------------------------------------------------------
*)

 TQTVRGetQTVRTrack=function(theMovie:Movie;index:SInt32):Track; cdecl;
 TQTVRGetQTVRInstance=function(var qtvr:QTVRInstance;qtvrTrack:Track;mc:MovieController):OSErr; cdecl;

(*
  =================================================================================================
    Viewing Angles and Zooming
  -------------------------------------------------------------------------------------------------
*)

 TQTVRSetPanAngle=function(qtvr:QTVRInstance;panAngle:float):OSErr; cdecl;
 TQTVRGetPanAngle=function(qtvr:QTVRInstance):float; cdecl;
 TQTVRSetTiltAngle=function(qtvr:QTVRInstance;tiltAngle:float):OSErr; cdecl;
 TQTVRGetTiltAngle=function(qtvr:QTVRInstance):float; cdecl;
 TQTVRSetFieldOfView=function(qtvr:QTVRInstance;fieldOfView:float):OSErr; cdecl;
 TQTVRGetFieldOfView=function(qtvr:QTVRInstance):float; cdecl;
 TQTVRShowDefaultView=function(qtvr:QTVRInstance):OSErr; cdecl;

 //Object Specific//
 TQTVRSetViewCenter=function(qtvr:QTVRInstance;{const}var viewCenter:QTVRFloatPoint):OSErr; cdecl;
 TQTVRGetViewCenter=function(qtvr:QTVRInstance;var viewCenter:QTVRFloatPoint):OSErr; cdecl;
 TQTVRNudge=function(qtvr:QTVRInstance;direction:QTVRNudgeControl):OSErr; cdecl;
 //QTVRInteractionNudge requires QTVR 2.1 =function(kQTVRAPIMajorVersion02 + kQTVRAPIMinorVersion10)
 TQTVRInteractionNudge=function(qtvr:QTVRInstance;direction:QTVRNudgeControl):OSErr; cdecl;

(*
  =================================================================================================
    Scene and Node Location Information
  -------------------------------------------------------------------------------------------------
*)

 TQTVRGetVRWorld=function(qtvr:QTVRInstance;var VRWorld:QTAtomContainer):OSErr; cdecl;
 TQTVRGetNodeInfo=function(qtvr:QTVRInstance;nodeID:UInt32;var nodeInfo:QTAtomContainer):OSErr; cdecl;
 TQTVRGoToNodeID=function(qtvr:QTVRInstance;nodeID:UInt32):OSErr; cdecl;
 TQTVRGetCurrentNodeID=function(qtvr:QTVRInstance):UInt32; cdecl;
 TQTVRGetNodeType=function(qtvr:QTVRInstance;nodeID:UInt32):OSType; cdecl;

(*
  =================================================================================================
    Hot Spot related calls
  -------------------------------------------------------------------------------------------------
*)

 TQTVRPtToHotSpotID=function(qtvr:QTVRInstance;pt:Point;var hotSpotID):OSErr; cdecl;
 //QTVRGetHotSpotType requires QTVR 2.1 =function(kQTVRAPIMajorVersion02 + kQTVRAPIMinorVersion10)
 TQTVRGetHotSpotType=function(qtvr:QTVRInstance;hotSpotID:UInt32;var hotSpotType:OSType):OSErr; cdecl;
 TQTVRTriggerHotSpot=function(qtvr:QTVRInstance;hotSpotID:UInt32;nodeInfo:QTAtomContainer;selectedAtom:QTAtom):OSErr; cdecl;
 TQTVRSetMouseOverHotSpotProc=function(qtvr:QTVRInstance;mouseOverHotSpotProc:QTVRMouseOverHotSpotUPP;refCon:SInt32;flags:UInt32):OSErr; cdecl;
 TQTVREnableHotSpot=function(qtvr:QTVRInstance;enableFlag:UInt32;hotSpotValue:UInt32;enable:Boolean):OSErr; cdecl;
 TQTVRGetVisibleHotSpots=function(qtvr:QTVRInstance;hotSpots:Handle):UInt32; cdecl;
 TQTVRGetHotSpotRegion=function(qtvr:QTVRInstance;hotSpotID:UInt32;hotSpotRegion:RgnHandle):OSErr; cdecl;

(*
  =================================================================================================
    Event & Cursor Handling Calls
  -------------------------------------------------------------------------------------------------
*)

 TQTVRSetMouseOverTracking=function(qtvr:QTVRInstance;enable:Boolean):OSErr; cdecl;
 TQTVRGetMouseOverTracking=function(qtvr:QTVRInstance):Boolean; cdecl;
 TQTVRSetMouseDownTracking=function(qtvr:QTVRInstance;enable:Boolean):OSErr; cdecl;
 TQTVRGetMouseDownTracking=function(qtvr:QTVRInstance):Boolean; cdecl;
 TQTVRMouseEnter=function(qtvr:QTVRInstance;pt:Point;var hotSpotID:UInt32;w:WindowPtr):OSErr; cdecl;
 TQTVRMouseWithin=function(qtvr:QTVRInstance;pt:Point;var hotSpotID:UInt32;w:WindowPtr):OSErr; cdecl;
 TQTVRMouseLeave=function(qtvr:QTVRInstance;pt:Point;w:WindowPtr):OSErr; cdecl;
 TQTVRMouseDown=function(qtvr:QTVRInstance;pt:Point;when:UInt32;modifiers:UInt16;var hotSpotID:UInt32;w:WindowPtr):OSErr; cdecl;
 TQTVRMouseStillDown=function(qtvr:QTVRInstance;pt:Point;var hotSpotID:UInt32;w:WindowPtr):OSErr; cdecl;
 TQTVRMouseUp=function(qtvr:QTVRInstance;pt:Point;var hotSpotID:UInt32;w:WindowPtr):OSErr; cdecl;
 //These require QTVR 2.01 =function(kQTVRAPIMajorVersion02 + kQTVRAPIMinorVersion01)
 TQTVRMouseStillDownExtended=function(qtvr:QTVRInstance;pt:Point;var hotSpotID:UInt32;w:WindowPtr;when:UInt32;modifiers:UInt16):OSErr; cdecl;
 TQTVRMouseUpExtended=function(qtvr:QTVRInstance;pt:Point;var hotSpotID:UInt32;w:WindowPtr;when:UInt32;modifiers:UInt16):OSErr; cdecl;

(*
  =================================================================================================
    Intercept Routines
  -------------------------------------------------------------------------------------------------
*)

 TQTVRInstallInterceptProc=function(
  qtvr:QTVRInstance;
  selector:QTVRProcSelector;
  interceptProc:QTVRInterceptUPP;
  refCon:SInt32;
  flags:UInt32):OSErr;cdecl;

 TQTVRCallInterceptedProc=function(qtvr:QTVRInstance;qtvrMsg:QTVRInterceptPtr):OSErr;cdecl; //QTVRInterceptPtr=^QTVRInterceptRecord

(*
  =================================================================================================
    Object Movie Specific Calls
  -------------------------------------------------------------------------------------------------
   QTVRGetCurrentMouseMode requires QTRVR 2.1 =function(kQTVRAPIMajorVersion02 + kQTVRAPIMinorVersion10)
*)

 TQTVRGetCurrentMouseMode=function(qtvr:QTVRInstance):UInt32; cdecl;
 TQTVRSetFrameRate=function(qtvr:QTVRInstance;rate:float):OSErr; cdecl;
 TQTVRGetFrameRate=function(qtvr:QTVRInstance):float; cdecl;
 TQTVRSetViewRate=function(qtvr:QTVRInstance;rate:float):OSErr; cdecl;
 TQTVRGetViewRate=function(qtvr:QTVRInstance):float; cdecl;
 TQTVRSetViewCurrentTime=function(qtvr:QTVRInstance;time:TimeValue):OSErr; cdecl;
 TQTVRGetViewCurrentTime=function(qtvr:QTVRInstance):TimeValue; cdecl;
 TQTVRGetCurrentViewDuration=function(qtvr:QTVRInstance):TimeValue; cdecl;

(*
  =================================================================================================
   View State Calls - QTVR Object Only
  -------------------------------------------------------------------------------------------------
*)

 TQTVRSetViewState=function(qtvr:QTVRInstance;viewStateType:QTVRViewStateType;state:UInt16):OSErr; cdecl;
 TQTVRGetViewState=function(qtvr:QTVRInstance;viewStateType:QTVRViewStateType;var state:UInt16):OSErr; cdecl;
 TQTVRGetViewStateCount=function(qtvr:QTVRInstance):UInt16; cdecl;
 TQTVRSetAnimationSetting=function(qtvr:QTVRInstance;setting:QTVRObjectAnimationSetting;enable:Boolean):OSErr; cdecl;
 TQTVRGetAnimationSetting=function(qtvr:QTVRInstance;setting:QTVRObjectAnimationSetting;var enable:Boolean):OSErr; cdecl;
 TQTVRSetControlSetting=function(qtvr:QTVRInstance;setting:QTVRControlSetting;enable:Boolean):OSErr; cdecl;
 TQTVRGetControlSetting=function(qtvr:QTVRInstance;setting:QTVRControlSetting;var enable:Boolean):OSErr; cdecl;
 TQTVREnableFrameAnimation=function(qtvr:QTVRInstance;enable:Boolean):OSErr; cdecl;
 TQTVRGetFrameAnimation=function(qtvr:QTVRInstance):Boolean; cdecl;
 TQTVREnableViewAnimation=function(qtvr:QTVRInstance;enable:Boolean):OSErr; cdecl;
 TQTVRGetViewAnimation=function(qtvr:QTVRInstance):Boolean; cdecl;

(*
  =================================================================================================
    Imaging Characteristics
  -------------------------------------------------------------------------------------------------
*)

 TQTVRSetVisible=function(qtvr:QTVRInstance;visible:Boolean):OSErr; cdecl;
 TQTVRGetVisible=function(qtvr:QTVRInstance):Boolean; cdecl;
 TQTVRSetImagingProperty=function(qtvr:QTVRInstance;imagingMode:QTVRImagingMode;imagingProperty:UInt32;propertyValue:SInt32):OSErr; cdecl;
 TQTVRGetImagingProperty=function(qtvr:QTVRInstance;imagingMode:QTVRImagingMode;imagingProperty:UInt32;var propertyValue:SInt32):OSErr; cdecl;
 TQTVRUpdate=function(qtvr:QTVRInstance;imagingMode:QTVRImagingMode):OSErr; cdecl;
 TQTVRBeginUpdateStream=function(qtvr:QTVRInstance;imagingMode:QTVRImagingMode):OSErr; cdecl;
 TQTVREndUpdateStream=function(qtvr:QTVRInstance):OSErr; cdecl;
 TQTVRSetTransitionProperty=function(qtvr:QTVRInstance;transitionType:UInt32;transitionProperty:UInt32;transitionValue:SInt32):OSErr; cdecl;
 TQTVREnableTransition=function(qtvr:QTVRInstance;transitionType:UInt32;enable:Boolean):OSErr; cdecl;

(*
  =================================================================================================
    Basic Conversion and Math Routines
  -------------------------------------------------------------------------------------------------
*)

 TQTVRSetAngularUnits=function(qtvr:QTVRInstance;units:QTVRAngularUnits):OSErr; cdecl;
 TQTVRGetAngularUnits=function(qtvr:QTVRInstance):QTVRAngularUnits; cdecl;

 //Pano specific routines//
 TQTVRPtToAngles=function(qtvr:QTVRInstance;pt:Point;var panAngle:float;var tiltAngle:float):OSErr; cdecl;
 TQTVRCoordToAngles=function(qtvr:QTVRInstance;var coord:QTVRFloatPoint;var panAngle:float;var tiltAngle:float):OSErr; cdecl;
 TQTVRAnglesToCoord=function(qtvr:QTVRInstance;panAngle:float;tiltAngle:float;var coord:QTVRFloatPoint):OSErr; cdecl;

 //Object specific routines//
 TQTVRPanToColumn=function(qtvr:QTVRInstance;panAngle:float):short; cdecl; //zero based
 TQTVRColumnToPan=function(qtvr:QTVRInstance;column:short):float; cdecl; //zero based
 TQTVRTiltToRow=function(qtvr:QTVRInstance;tiltAngle:float):short; cdecl; //zero based
 TQTVRRowToTilt=function(qtvr:QTVRInstance;row:short):float; cdecl; //zero based
 TQTVRWrapAndConstrain=function(qtvr:QTVRInstance;kind:short;value:float;var result:float):OSErr; cdecl;

(*
  =================================================================================================
    Interaction Routines
  -------------------------------------------------------------------------------------------------
*)

 TQTVRSetEnteringNodeProc=function(qtvr:QTVRInstance;enteringNodeProc:QTVREnteringNodeUPP;refCon:SInt32;flags:UInt32):OSErr; cdecl;
 TQTVRSetLeavingNodeProc=function(qtvr:QTVRInstance;leavingNodeProc:QTVRLeavingNodeUPP;refCon:SInt32;flags:UInt32):OSErr; cdecl;
 TQTVRSetInteractionProperty=function(qtvr:QTVRInstance;theProperty:UInt32;var value):OSErr; cdecl; //birbilis: changed "property" to "theProperty" =function(property is a reserved word in Delphi)
 TQTVRGetInteractionProperty=function(qtvr:QTVRInstance;theProperty:UInt32;var value):OSErr; cdecl; //birbilis: changed "property" to "theProperty" =function(property is a reserved word in Delphi)
 TQTVRReplaceCursor=function(qtvr:QTVRInstance;var cursRecord:QTVRCursorRecord):OSErr; cdecl;

(*
  =================================================================================================
    Viewing Limits and Constraints
  -------------------------------------------------------------------------------------------------
*)
 TQTVRGetViewingLimits=function(qtvr:QTVRInstance;kind:UInt16;var minValue:float;var maxValue:float):OSErr; cdecl;
 TQTVRGetConstraintStatus=function(qtvr:QTVRInstance):UInt32; cdecl;
 TQTVRGetConstraints=function(qtvr:QTVRInstance;kind:UInt16;var minValue:float;var maxValue:float):OSErr; cdecl;
 TQTVRSetConstraints=function(qtvr:QTVRInstance;kind:UInt16;minValue:float;maxValue:float):OSErr; cdecl;

(*
  =================================================================================================
    Back Buffer Memory Management
  -------------------------------------------------------------------------------------------------
*)

 TQTVRGetAvailableResolutions=function(qtvr:QTVRInstance;var resolutionsMask:UInt16):OSErr; cdecl;
 //These require QTVR 2.1 =function(kQTVRAPIMajorVersion02 + kQTVRAPIMinorVersion10)//
 TQTVRGetBackBufferMemInfo=function(qtvr:QTVRInstance;geometry:UInt32;resolution:UInt16;cachePixelFormat:UInt32;var minCacheBytes:SInt32;var suggestedCacheBytes:SInt32;var fullCacheBytes:SInt32):OSErr; cdecl;
 TQTVRGetBackBufferSettings=function(qtvr:QTVRInstance;var geometry:UInt32;var resolution:UInt16;var cachePixelFormat:UInt32;var cacheSize:SInt16):OSErr; cdecl;

(*
  =================================================================================================
    Buffer Access
  -------------------------------------------------------------------------------------------------
*)

 TQTVRSetPrescreenImagingCompleteProc=function(qtvr:QTVRInstance;imagingCompleteProc:QTVRImagingCompleteUPP;refCon:SInt32;flags:UInt32):OSErr; cdecl;
 TQTVRSetBackBufferImagingProc=function(qtvr:QTVRInstance;backBufferImagingProc:QTVRBackBufferImagingUPP;numAreas:UInt16;areasOfInterest:QTVRAreaOfInterestPtr;refCon:SInt32):OSErr; cdecl; //areasOfInterest is a pointer to an array
 TQTVRRefreshBackBuffer=function(qtvr:QTVRInstance;flags:UInt32):OSErr; cdecl;

var
 QTVRGetQTVRTrack:TQTVRGetQTVRTrack;
 QTVRGetQTVRInstance:TQTVRGetQTVRInstance;
 QTVRSetPanAngle:TQTVRSetPanAngle;
 QTVRGetPanAngle:TQTVRGetPanAngle;
 QTVRSetTiltAngle:TQTVRSetTiltAngle;
 QTVRGetTiltAngle:TQTVRGetTiltAngle;
 QTVRSetFieldOfView:TQTVRSetFieldOfView;
 QTVRGetFieldOfView:TQTVRGetFieldOfView;
 QTVRShowDefaultView:TQTVRShowDefaultView;
 QTVRSetViewCenter:TQTVRSetViewCenter;
 QTVRGetViewCenter:TQTVRGetViewCenter;
 QTVRNudge:TQTVRNudge;
 QTVRInteractionNudge:TQTVRInteractionNudge;
 QTVRGetVRWorld:TQTVRGetVRWorld;
 QTVRGetNodeInfo:TQTVRGetNodeInfo;
 QTVRGoToNodeID:TQTVRGoToNodeID;
 QTVRGetCurrentNodeID:TQTVRGetCurrentNodeID;
 QTVRGetNodeType:TQTVRGetNodeType;
 QTVRPtToHotSpotID:TQTVRPtToHotSpotID;
 QTVRGetHotSpotType:TQTVRGetHotSpotType;
 QTVRTriggerHotSpot:TQTVRTriggerHotSpot;
 QTVRSetMouseOverHotSpotProc:TQTVRSetMouseOverHotSpotProc;
 QTVREnableHotSpot:TQTVREnableHotSpot;
 QTVRGetVisibleHotSpots:TQTVRGetVisibleHotSpots;
 QTVRGetHotSpotRegion:TQTVRGetHotSpotRegion;
 QTVRSetMouseOverTracking:TQTVRSetMouseOverTracking;
 QTVRGetMouseOverTracking:TQTVRGetMouseOverTracking;
 QTVRSetMouseDownTracking:TQTVRSetMouseDownTracking;
 QTVRGetMouseDownTracking:TQTVRGetMouseDownTracking;
 QTVRMouseEnter:TQTVRMouseEnter;
 QTVRMouseWithin:TQTVRMouseWithin;
 QTVRMouseLeave:TQTVRMouseLeave;
 QTVRMouseDown:TQTVRMouseDown;
 QTVRMouseStillDown:TQTVRMouseStillDown;
 QTVRMouseUp:TQTVRMouseUp;
 QTVRMouseStillDownExtended:TQTVRMouseStillDownExtended;
 QTVRMouseUpExtended:TQTVRMouseUpExtended;
 QTVRInstallInterceptProc:TQTVRInstallInterceptProc;
 QTVRCallInterceptedProc:TQTVRCallInterceptedProc;
 QTVRGetCurrentMouseMode:TQTVRGetCurrentMouseMode;
 QTVRSetFrameRate:TQTVRSetFrameRate;
 QTVRGetFrameRate:TQTVRGetFrameRate;
 QTVRSetViewRate:TQTVRSetViewRate;
 QTVRGetViewRate:TQTVRGetViewRate;
 QTVRSetViewCurrentTime:TQTVRSetViewCurrentTime;
 QTVRGetViewCurrentTime:TQTVRGetViewCurrentTime;
 QTVRGetCurrentViewDuration:TQTVRGetCurrentViewDuration;
 QTVRSetViewState:TQTVRSetViewState;
 QTVRGetViewState:TQTVRGetViewState;
 QTVRGetViewStateCount:TQTVRGetViewStateCount;
 QTVRSetAnimationSetting:TQTVRSetAnimationSetting;
 QTVRGetAnimationSetting:TQTVRGetAnimationSetting;
 QTVRSetControlSetting:TQTVRSetControlSetting;
 QTVRGetControlSetting:TQTVRGetControlSetting;
 QTVREnableFrameAnimation:TQTVREnableFrameAnimation;
 QTVRGetFrameAnimation:TQTVRGetFrameAnimation;
 QTVREnableViewAnimation:TQTVREnableViewAnimation;
 QTVRGetViewAnimation:TQTVRGetViewAnimation;
 QTVRSetVisible:TQTVRSetVisible;
 QTVRGetVisible:TQTVRGetVisible;
 QTVRSetImagingProperty:TQTVRSetImagingProperty;
 QTVRGetImagingProperty:TQTVRGetImagingProperty;
 QTVRUpdate:TQTVRUpdate;
 QTVRBeginUpdateStream:TQTVRBeginUpdateStream;
 QTVREndUpdateStream:TQTVREndUpdateStream;
 QTVRSetTransitionProperty:TQTVRSetTransitionProperty;
 QTVREnableTransition:TQTVREnableTransition;
 QTVRSetAngularUnits:TQTVRSetAngularUnits;
 QTVRGetAngularUnits:TQTVRGetAngularUnits;
 QTVRPtToAngles:TQTVRPtToAngles;
 QTVRCoordToAngles:TQTVRCoordToAngles;
 QTVRAnglesToCoord:TQTVRAnglesToCoord;
 QTVRPanToColumn:TQTVRPanToColumn;
 QTVRColumnToPan:TQTVRColumnToPan;
 QTVRTiltToRow:TQTVRTiltToRow;
 QTVRRowToTilt:TQTVRRowToTilt;
 QTVRWrapAndConstrain:TQTVRWrapAndConstrain;
 QTVRSetEnteringNodeProc:TQTVRSetEnteringNodeProc;
 QTVRSetLeavingNodeProc:TQTVRSetLeavingNodeProc;
 QTVRSetInteractionProperty:TQTVRSetInteractionProperty;
 QTVRGetInteractionProperty:TQTVRGetInteractionProperty;
 QTVRReplaceCursor:TQTVRReplaceCursor;
 QTVRGetViewingLimits:TQTVRGetViewingLimits;
 QTVRGetConstraintStatus:TQTVRGetConstraintStatus;
 QTVRGetConstraints:TQTVRGetConstraints;
 QTVRSetConstraints:TQTVRSetConstraints;
 QTVRGetAvailableResolutions:TQTVRGetAvailableResolutions;
 QTVRGetBackBufferMemInfo:TQTVRGetBackBufferMemInfo;
 QTVRGetBackBufferSettings:TQTVRGetBackBufferSettings;
 QTVRSetPrescreenImagingCompleteProc:TQTVRSetPrescreenImagingCompleteProc;
 QTVRSetBackBufferImagingProc:TQTVRSetBackBufferImagingProc;
 QTVRRefreshBackBuffer:TQTVRRefreshBackBuffer;

{$ENDIF}

implementation
uses
{$IFDEF DYNAMIC_LINKING}
 Windows,
{$ENDIF}
 qt_Components;

var
 qtvrComponent:ComponentInstance;

{$IFNDEF TARGET_OS_MAC}
function InitializeQTVR;
begin
 qtvrComponent:=OpenDefaultComponent(kQTVRQTVRType,0);
 if (qtvrComponent=nil)
  then result:=unresolvedComponentDLLErr
  else result:=noErr;
end;

function TerminateQTVR;
begin
 result:=CloseComponent(qtvrComponent);
end;
{$ENDIF}

function NewQTVRInterceptProc;
begin
 result:=userRoutine; //newRoutineDescriptor(userRoutine,uppQTVRInterceptProcInfo,GetCurrentArchitecture())=UniversalProcPtr(userRoutine)=userRoutine in QT-Windows
end;

procedure CallQTVRInterceptProc;
begin
 userRoutine(qtvr, qtvrMsg, refCon, cancel); //CALL_FOUR_PARAMETER_UPP(proc,procinfo,p1,p2,p3,p4)=proc(p1,p2,p3,p4) in QTW
end;

{$IFNDEF DYNAMIC_LINKING}

//General QTVR calls//
function QTVRGetQTVRTrack; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetQTVRInstance; cdecl; external 'QuickTimeVR.qtx';

//Viewing Angles and Zooming//
function QTVRSetPanAngle; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetPanAngle; cdecl; external 'QuickTimeVR.qtx';
function QTVRSetTiltAngle; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetTiltAngle; cdecl; external 'QuickTimeVR.qtx';
function QTVRSetFieldOfView; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetFieldOfView; cdecl; external 'QuickTimeVR.qtx';
function QTVRShowDefaultView; cdecl; external 'QuickTimeVR.qtx';
//...object specific:
function QTVRSetViewCenter; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetViewCenter; cdecl; external 'QuickTimeVR.qtx';
function QTVRNudge; cdecl; external 'QuickTimeVR.qtx';
function QTVRInteractionNudge; cdecl; external 'QuickTimeVR.qtx';

//Scene and Node Location Information//
function QTVRGetVRWorld; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetNodeInfo; cdecl; external 'QuickTimeVR.qtx';
function QTVRGoToNodeID; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetCurrentNodeID; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetNodeType; cdecl; external 'QuickTimeVR.qtx';

//Event & Cursor Handling Calls//
function QTVRSetMouseOverTracking; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetMouseOverTracking; cdecl; external 'QuickTimeVR.qtx';
function QTVRSetMouseDownTracking; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetMouseDownTracking; cdecl; external 'QuickTimeVR.qtx';
function QTVRMouseEnter; cdecl; external 'QuickTimeVR.qtx';
function QTVRMouseWithin; cdecl; external 'QuickTimeVR.qtx';
function QTVRMouseLeave; cdecl; external 'QuickTimeVR.qtx';
function QTVRMouseDown; cdecl; external 'QuickTimeVR.qtx';
function QTVRMouseStillDown; cdecl; external 'QuickTimeVR.qtx';
function QTVRMouseUp; cdecl; external 'QuickTimeVR.qtx';
function QTVRMouseStillDownExtended; cdecl; external 'QuickTimeVR.qtx';
function QTVRMouseUpExtended; cdecl; external 'QuickTimeVR.qtx';

//Hot Spot related calls//
function QTVRPtToHotSpotID; cdecl; external 'QuickTimeVR.qtx';
        //QTVRGetHotSpotType requires QTVR 2.1 (kQTVRAPIMajorVersion02 + kQTVRAPIMinorVersion10)
function QTVRGetHotSpotType; cdecl; external 'QuickTimeVR.qtx';
function QTVRTriggerHotSpot; cdecl; external 'QuickTimeVR.qtx';
function QTVRSetMouseOverHotSpotProc; cdecl; external 'QuickTimeVR.qtx';
function QTVREnableHotSpot; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetVisibleHotSpots; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetHotSpotRegion; cdecl; external 'QuickTimeVR.qtx';

//Intercept Routines//
function QTVRInstallInterceptProc; cdecl; external 'QuickTimeVR.qtx';
function QTVRCallInterceptedProc; cdecl; external 'QuickTimeVR.qtx';

//Object Movie Specific Calls//
function QTVRGetCurrentMouseMode; cdecl; external 'QuickTimeVR.qtx';
function QTVRSetFrameRate; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetFrameRate; cdecl; external 'QuickTimeVR.qtx';
function QTVRSetViewRate; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetViewRate; cdecl; external 'QuickTimeVR.qtx';
function QTVRSetViewCurrentTime; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetViewCurrentTime; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetCurrentViewDuration; cdecl; external 'QuickTimeVR.qtx';

//View State Calls - QTVR object only//
function QTVRSetViewState; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetViewState; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetViewStateCount; cdecl; external 'QuickTimeVR.qtx';
function QTVRSetAnimationSetting; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetAnimationSetting; cdecl; external 'QuickTimeVR.qtx';
function QTVRSetControlSetting; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetControlSetting; cdecl; external 'QuickTimeVR.qtx';
function QTVREnableFrameAnimation; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetFrameAnimation; cdecl; external 'QuickTimeVR.qtx';
function QTVREnableViewAnimation; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetViewAnimation; cdecl; external 'QuickTimeVR.qtx';

//Imaging Characteristics//
function QTVRSetVisible; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetVisible; cdecl; external 'QuickTimeVR.qtx';
function QTVRSetImagingProperty; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetImagingProperty; cdecl; external 'QuickTimeVR.qtx';
function QTVRUpdate; cdecl; external 'QuickTimeVR.qtx';
function QTVRBeginUpdateStream; cdecl; external 'QuickTimeVR.qtx';
function QTVREndUpdateStream; cdecl; external 'QuickTimeVR.qtx';
function QTVRSetTransitionProperty; cdecl; external 'QuickTimeVR.qtx';
function QTVREnableTransition; cdecl; external 'QuickTimeVR.qtx';

//Basic Conversion and Math Routines//
function QTVRSetAngularUnits; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetAngularUnits; cdecl; external 'QuickTimeVR.qtx';
//...Pano specific routines:
function QTVRPtToAngles; cdecl; external 'QuickTimeVR.qtx';
function QTVRCoordToAngles; cdecl; external 'QuickTimeVR.qtx';
function QTVRAnglesToCoord; cdecl; external 'QuickTimeVR.qtx';
//...Object specific routines:
function QTVRPanToColumn; cdecl; external 'QuickTimeVR.qtx';
function QTVRColumnToPan; cdecl; external 'QuickTimeVR.qtx';
function QTVRTiltToRow; cdecl; external 'QuickTimeVR.qtx';
function QTVRRowToTilt; cdecl; external 'QuickTimeVR.qtx';
function QTVRWrapAndConstrain; cdecl; external 'QuickTimeVR.qtx';

//Interaction Routines
function QTVRSetEnteringNodeProc; cdecl; external 'QuickTimeVR.qtx';
function QTVRSetLeavingNodeProc; cdecl; external 'QuickTimeVR.qtx';
function QTVRSetInteractionProperty; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetInteractionProperty; cdecl; external 'QuickTimeVR.qtx';
function QTVRReplaceCursor; cdecl; external 'QuickTimeVR.qtx';

//Viewing Limits and Constraints
function QTVRGetViewingLimits; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetConstraintStatus; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetConstraints; cdecl; external 'QuickTimeVR.qtx';
function QTVRSetConstraints; cdecl; external 'QuickTimeVR.qtx';

//Back Buffer Memory Management
function QTVRGetAvailableResolutions; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetBackBufferMemInfo; cdecl; external 'QuickTimeVR.qtx';
function QTVRGetBackBufferSettings; cdecl; external 'QuickTimeVR.qtx';

//Buffer Access
function QTVRSetPrescreenImagingCompleteProc; cdecl; external 'QuickTimeVR.qtx';
function QTVRSetBackBufferImagingProc; cdecl; external 'QuickTimeVR.qtx';
function QTVRRefreshBackBuffer; cdecl; external 'QuickTimeVR.qtx';

{$ELSE}

var
 handle:THandle;

{$ENDIF}

initialization

{$IFDEF DYNAMIC_LINKING}
handle:=LoadLibrary('QuickTimeVR.qtx');
if handle<>0 then
 begin
 @QTVRGetQTVRTrack:=GetProcAddress(handle,'QTVRGetQTVRTrack');
 @QTVRGetQTVRInstance:=GetProcAddress(handle,'QTVRGetQTVRInstance');
 @QTVRSetPanAngle:=GetProcAddress(handle,'QTVRSetPanAngle');
 @QTVRGetPanAngle:=GetProcAddress(handle,'QTVRGetPanAngle');
 @QTVRSetTiltAngle:=GetProcAddress(handle,'QTVRSetTiltAngle');
 @QTVRGetTiltAngle:=GetProcAddress(handle,'QTVRGetTiltAngle');
 @QTVRSetFieldOfView:=GetProcAddress(handle,'QTVRSetFieldOfView');
 @QTVRGetFieldOfView:=GetProcAddress(handle,'QTVRGetFieldOfView');
 @QTVRShowDefaultView:=GetProcAddress(handle,'QTVRShowDefaultView');
 @QTVRSetViewCenter:=GetProcAddress(handle,'QTVRSetViewCenter');
 @QTVRGetViewCenter:=GetProcAddress(handle,'QTVRGetViewCenter');
 @QTVRNudge:=GetProcAddress(handle,'QTVRNudge');
 @QTVRInteractionNudge:=GetProcAddress(handle,'QTVRInteractionNudge');
 @QTVRGetVRWorld:=GetProcAddress(handle,'QTVRGetVRWorld');
 @QTVRGetNodeInfo:=GetProcAddress(handle,'QTVRGetNodeInfo');
 @QTVRGoToNodeID:=GetProcAddress(handle,'QTVRGoToNodeID');
 @QTVRGetCurrentNodeID:=GetProcAddress(handle,'QTVRGetCurrentNodeID');
 @QTVRGetNodeType:=GetProcAddress(handle,'QTVRGetNodeType');
 @QTVRPtToHotSpotID:=GetProcAddress(handle,'QTVRPtToHotSpotID');
 @QTVRGetHotSpotType:=GetProcAddress(handle,'QTVRGetHotSpotType');
 @QTVRTriggerHotSpot:=GetProcAddress(handle,'QTVRTriggerHotSpot');
 @QTVRSetMouseOverHotSpotProc:=GetProcAddress(handle,'QTVRSetMouseOverHotSpotProc');
 @QTVREnableHotSpot:=GetProcAddress(handle,'QTVREnableHotSpot');
 @QTVRGetVisibleHotSpots:=GetProcAddress(handle,'QTVRGetVisibleHotSpots');
 @QTVRGetHotSpotRegion:=GetProcAddress(handle,'QTVRGetHotSpotRegion');
 @QTVRSetMouseOverTracking:=GetProcAddress(handle,'QTVRSetMouseOverTracking');
 @QTVRGetMouseOverTracking:=GetProcAddress(handle,'QTVRGetMouseOverTracking');
 @QTVRSetMouseDownTracking:=GetProcAddress(handle,'QTVRSetMouseDownTracking');
 @QTVRGetMouseDownTracking:=GetProcAddress(handle,'QTVRGetMouseDownTracking');
 @QTVRMouseEnter:=GetProcAddress(handle,'QTVRMouseEnter');
 @QTVRMouseWithin:=GetProcAddress(handle,'QTVRMouseWithin');
 @QTVRMouseLeave:=GetProcAddress(handle,'QTVRMouseLeave');
 @QTVRMouseDown:=GetProcAddress(handle,'QTVRMouseDown');
 @QTVRMouseStillDown:=GetProcAddress(handle,'QTVRMouseStillDown');
 @QTVRMouseUp:=GetProcAddress(handle,'QTVRMouseUp');
 @QTVRMouseStillDownExtended:=GetProcAddress(handle,'QTVRMouseStillDownExtended');
 @QTVRMouseUpExtended:=GetProcAddress(handle,'QTVRMouseUpExtended');
 @QTVRInstallInterceptProc:=GetProcAddress(handle,'QTVRInstallInterceptProc');
 @QTVRCallInterceptedProc:=GetProcAddress(handle,'QTVRCallInterceptedProc');
 @QTVRGetCurrentMouseMode:=GetProcAddress(handle,'QTVRGetCurrentMouseMode');
 @QTVRSetFrameRate:=GetProcAddress(handle,'QTVRSetFrameRate');
 @QTVRGetFrameRate:=GetProcAddress(handle,'QTVRGetFrameRate');
 @QTVRSetViewRate:=GetProcAddress(handle,'QTVRSetViewRate');
 @QTVRGetViewRate:=GetProcAddress(handle,'QTVRGetViewRate');
 @QTVRSetViewCurrentTime:=GetProcAddress(handle,'QTVRSetViewCurrentTime');
 @QTVRGetViewCurrentTime:=GetProcAddress(handle,'QTVRGetViewCurrentTime');
 @QTVRGetCurrentViewDuration:=GetProcAddress(handle,'QTVRGetCurrentViewDuration');
 @QTVRSetViewState:=GetProcAddress(handle,'QTVRSetViewState');
 @QTVRGetViewState:=GetProcAddress(handle,'QTVRGetViewState');
 @QTVRGetViewStateCount:=GetProcAddress(handle,'QTVRGetViewStateCount');
 @QTVRSetAnimationSetting:=GetProcAddress(handle,'QTVRSetAnimationSetting');
 @QTVRGetAnimationSetting:=GetProcAddress(handle,'QTVRGetAnimationSetting');
 @QTVRSetControlSetting:=GetProcAddress(handle,'QTVRSetControlSetting');
 @QTVRGetControlSetting:=GetProcAddress(handle,'QTVRGetControlSetting');
 @QTVREnableFrameAnimation:=GetProcAddress(handle,'QTVREnableFrameAnimation');
 @QTVRGetFrameAnimation:=GetProcAddress(handle,'QTVRGetFrameAnimation');
 @QTVREnableViewAnimation:=GetProcAddress(handle,'QTVREnableViewAnimation');
 @QTVRGetViewAnimation:=GetProcAddress(handle,'QTVRGetViewAnimation');
 @QTVRSetVisible:=GetProcAddress(handle,'QTVRSetVisible');
 @QTVRGetVisible:=GetProcAddress(handle,'QTVRGetVisible');
 @QTVRSetImagingProperty:=GetProcAddress(handle,'QTVRSetImagingProperty');
 @QTVRGetImagingProperty:=GetProcAddress(handle,'QTVRGetImagingProperty');
 @QTVRUpdate:=GetProcAddress(handle,'QTVRUpdate');
 @QTVRBeginUpdateStream:=GetProcAddress(handle,'QTVRBeginUpdateStream');
 @QTVREndUpdateStream:=GetProcAddress(handle,'QTVREndUpdateStream');
 @QTVRSetTransitionProperty:=GetProcAddress(handle,'QTVRSetTransitionProperty');
 @QTVREnableTransition:=GetProcAddress(handle,'QTVREnableTransition');
 @QTVRSetAngularUnits:=GetProcAddress(handle,'QTVRSetAngularUnits');
 @QTVRGetAngularUnits:=GetProcAddress(handle,'QTVRGetAngularUnits');
 @QTVRPtToAngles:=GetProcAddress(handle,'QTVRPtToAngles');
 @QTVRCoordToAngles:=GetProcAddress(handle,'QTVRCoordToAngles');
 @QTVRAnglesToCoord:=GetProcAddress(handle,'QTVRAnglesToCoord');
 @QTVRPanToColumn:=GetProcAddress(handle,'QTVRPanToColumn');
 @QTVRColumnToPan:=GetProcAddress(handle,'QTVRColumnToPan');
 @QTVRTiltToRow:=GetProcAddress(handle,'QTVRTiltToRow');
 @QTVRRowToTilt:=GetProcAddress(handle,'QTVRRowToTilt');
 @QTVRWrapAndConstrain:=GetProcAddress(handle,'QTVRWrapAndConstrain');
 @QTVRSetEnteringNodeProc:=GetProcAddress(handle,'QTVRSetEnteringNodeProc');
 @QTVRSetLeavingNodeProc:=GetProcAddress(handle,'QTVRSetLeavingNodeProc');
 @QTVRSetInteractionProperty:=GetProcAddress(handle,'QTVRSetInteractionProperty');
 @QTVRGetInteractionProperty:=GetProcAddress(handle,'QTVRGetInteractionProperty');
 @QTVRReplaceCursor:=GetProcAddress(handle,'QTVRReplaceCursor');
 @QTVRGetViewingLimits:=GetProcAddress(handle,'QTVRGetViewingLimits');
 @QTVRGetConstraintStatus:=GetProcAddress(handle,'QTVRGetConstraintStatus');
 @QTVRGetConstraints:=GetProcAddress(handle,'QTVRGetConstraints');
 @QTVRSetConstraints:=GetProcAddress(handle,'QTVRSetConstraints');
 @QTVRGetAvailableResolutions:=GetProcAddress(handle,'QTVRGetAvailableResolutions');
 @QTVRGetBackBufferMemInfo:=GetProcAddress(handle,'QTVRGetBackBufferMemInfo');
 @QTVRGetBackBufferSettings:=GetProcAddress(handle,'QTVRGetBackBufferSettings');
 @QTVRSetPrescreenImagingCompleteProc:=GetProcAddress(handle,'QTVRSetPrescreenImagingCompleteProc');
 @QTVRSetBackBufferImagingProc:=GetProcAddress(handle,'QTVRSetBackBufferImagingProc');
 @QTVRRefreshBackBuffer:=GetProcAddress(handle,'QTVRRefreshBackBuffer');
 end;
{$ENDIF}

finalization

{$IFDEF DYNAMIC_LINKING}
 if handle<>0 then
  FreeLibrary(handle);
{$ENDIF}

(* NOTE: procs exported by "QuickTimeVR.qtx" module of QT5 (found using DEPENDS.EXE of Visual Studio)
QTVRGetQTVRTrack
QTVRGetQTVRInstance
QTVRSetPanAngle
QTVRGetPanAngle
QTVRSetTiltAngle
QTVRGetTiltAngle
QTVRSetFieldOfView
QTVRGetFieldOfView
QTVRShowDefaultView
QTVRSetViewCenter
QTVRGetViewCenter
QTVRNudge
QTVRGetVRWorld
QTVRGoToNodeID
QTVRGetCurrentNodeID
QTVRGetNodeType
QTVRPtToHotSpotID
QTVRGetNodeInfo
QTVRTriggerHotSpot
QTVRSetMouseOverHotSpotProc
QTVREnableHotSpot
QTVRGetVisibleHotSpots
QTVRGetHotSpotRegion
QTVRSetMouseOverTracking
QTVRGetMouseOverTracking
QTVRSetMouseDownTracking
QTVRGetMouseDownTracking
QTVRMouseEnter
QTVRMouseWithin
QTVRMouseLeave
QTVRMouseDown
QTVRMouseStillDown
QTVRMouseUp
QTVRInstallInterceptProc
QTVRCallInterceptedProc
QTVRSetFrameRate
QTVRGetFrameRate
QTVRSetViewRate
QTVRGetViewRate
QTVRSetViewCurrentTime
QTVRGetViewCurrentTime
QTVRGetCurrentViewDuration
QTVRSetViewState
QTVRGetViewState
QTVRGetViewStateCount
QTVRSetAnimationSetting
QTVRGetAnimationSetting
QTVRSetControlSetting
QTVRGetControlSetting
QTVREnableFrameAnimation
QTVRGetFrameAnimation
QTVREnableViewAnimation
QTVRGetViewAnimation
QTVRSetVisible
QTVRGetVisible
QTVRSetImagingProperty
QTVRGetImagingProperty
QTVRUpdate
QTVRBeginUpdateStream
QTVREndUpdateStream
QTVRSetTransitionProperty
QTVREnableTransition
QTVRSetAngularUnits
QTVRGetAngularUnits
QTVRPtToAngles
QTVRCoordToAngles
QTVRAnglesToCoord
QTVRPanToColumn
QTVRColumnToPan
QTVRTiltToRow
QTVRRowToTilt
QTVRWrapAndConstrain
QTVRSetEnteringNodeProc
QTVRSetLeavingNodeProc
QTVRSetInteractionProperty
QTVRGetInteractionProperty
QTVRReplaceCursor
QTVRGetViewingLimits
QTVRGetConstraintStatus
QTVRGetConstraints
QTVRSetConstraints
QTVRGetAvailableResolutions
QTVRGetBackBufferMemInfo
QTVRGetBackBufferSettings
QTVRSetBackBufferPrefs
QTVRSetPrescreenImagingCompleteProc
QTVRSetBackBufferImagingProc
QTVRRefreshBackBuffer
QTVRMouseStillDownExtended
QTVRMouseUpExtended
QTVRGetHotSpotType
QTVRGetCurrentMouseMode
QTVRInteractionNudge
QTVRSetViewParameter
QTVRGetViewParameter
CubicCodec_ComponentDispatch
CylinderCodec_ComponentDispatch
ObjectNodeMedia_ComponentDispatch
ObjectNode_ComponentDispatch
PanControllerComponentDispatch
PanoMediaComponentDispatch
QTVRControllerComponentDispatch
QTVRMediaComponentDispatch
*)

end.

