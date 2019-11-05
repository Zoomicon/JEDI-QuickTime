(*************************************************************************
*
*       Borland Delphi Runtime Library
*       QuickTime interface unit
*
* Portions created by Apple Computer, Inc. are
* Copyright (C) 1997-1998 Apple Computer, Inc..
* All Rights Reserved.
*
* The original file is: QuickTimeVRFormat.h, released dd Mmm yyyy.
* The original Pascal code is: qt_QuickTimeVRFormat.pas, released 14 May 2000.
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
*************************************************************************)

//07Mar1999 - birbilis: COMPLETED
//14May2000 - birbilis: donated to Delphi-JEDI
//19May2005 - birbilis: changed license header text to conserve disk space

unit qt_QuickTimeVRFormat;

interface
 uses C_Types, qt_MacTypes,qt_Movies,qt_QuickTimeVR;

(*
 	File:		QuickTimeVRFormat.h

 	Contains:	QuickTime VR interfaces

 	Version:	Technology:	QuickTime VR 2.1
 				Release:	QuickTime 3.0

 	Copyright:	© 1997-1998 by Apple Computer, Inc., all rights reserved.

 	Bugs?:		Please include the the file and version information (from above) with
 				the problem description.  Developers belonging to one of the Apple
 				developer programs can submit bug reports to:

 					devsupport@apple.com

*)

(* File Format Version numbers *)
 const kQTVRMajorVersion =(2);
 const kQTVRMinorVersion =(0);

(* User data type for the Movie Controller type specifier*)

 const kQTControllerType	= kQTVRControllerSubType;		(* Atom & ID of where our*)
       kQTControllerID		= 1;					(* ...controller name is stored*)

(* VRWorld atom types*)

 const	kQTVRWorldHeaderAtomType	= (((ord('v') shl 8 +ord('r'))shl 8 +ord('s'))shl 8 +ord('c')) {'vrsc'};
	kQTVRImagingParentAtomType	= (((ord('i') shl 8 +ord('m'))shl 8 +ord('g'))shl 8 +ord('p')) {'imgp'};
	kQTVRPanoImagingAtomType	= (((ord('i') shl 8 +ord('m'))shl 8 +ord('p'))shl 8 +ord('n')) {'impn'};
	kQTVRObjectImagingAtomType	= (((ord('i') shl 8 +ord('m'))shl 8 +ord('o'))shl 8 +ord('b')) {'imob'};
	kQTVRNodeParentAtomType		= (((ord('v') shl 8 +ord('r'))shl 8 +ord('n'))shl 8 +ord('p')) {'vrnp'};
	kQTVRNodeIDAtomType		= (((ord('v') shl 8 +ord('r'))shl 8 +ord('n'))shl 8 +ord('i')) {'vrni'};
	kQTVRNodeLocationAtomType	= (((ord('n') shl 8 +ord('l'))shl 8 +ord('o'))shl 8 +ord('c')) {'nloc'};
	kQTVRCursorParentAtomType	= (((ord('v') shl 8 +ord('r'))shl 8 +ord('c'))shl 8 +ord('p')) {'vrcp'};		(* New with 2.1*)
	kQTVRCursorAtomType		= (((ord('C') shl 8 +ord('U'))shl 8 +ord('R'))shl 8 +ord('S')) {'CURS'};		(* New with 2.1*)
	kQTVRColorCursorAtomType	= (((ord('c') shl 8 +ord('r'))shl 8 +ord('s'))shl 8 +ord('r')) {'crsr'};		(* New with 2.1*)


(* NodeInfo atom types*)

 const	kQTVRNodeHeaderAtomType		= (((ord('n') shl 8 +ord('d'))shl 8 +ord('h'))shl 8 +ord('d')) {'ndhd'};
	kQTVRHotSpotParentAtomType	= (((ord('h') shl 8 +ord('s'))shl 8 +ord('p'))shl 8 +ord('a')) {'hspa'};
	kQTVRHotSpotAtomType		= (((ord('h') shl 8 +ord('o'))shl 8 +ord('t'))shl 8 +ord('s')) {'hots'};
	kQTVRHotSpotInfoAtomType	= (((ord('h') shl 8 +ord('s'))shl 8 +ord('i'))shl 8 +ord('n')) {'hsin'};
	kQTVRLinkInfoAtomType		= (((ord('l') shl 8 +ord('i'))shl 8 +ord('n'))shl 8 +ord('k')) {'link'};


(* Miscellaneous atom types*)

 const	kQTVRStringAtomType		= (((ord('v') shl 8 +ord('r'))shl 8 +ord('s'))shl 8 +ord('g')) {'vrsg'};
	kQTVRStringEncodingAtomType	= (((ord('v') shl 8 +ord('r'))shl 8 +ord('s'))shl 8 +ord('e')) {'vrse'};		(* New with 2.1*)
	kQTVRPanoSampleDataAtomType	= (((ord('p') shl 8 +ord('d'))shl 8 +ord('a'))shl 8 +ord('t')) {'pdat'};
	kQTVRObjectInfoAtomType		= (((ord('o') shl 8 +ord('b'))shl 8 +ord('j'))shl 8 +ord('i')) {'obji'};
	kQTVRImageTrackRefAtomType	= (((ord('i') shl 8 +ord('m'))shl 8 +ord('t'))shl 8 +ord('r')) {'imtr'};		(* Parent is kQTVRObjectInfoAtomType. Required if track ref is not 1 as required by 2.0 format.*)
	kQTVRHotSpotTrackRefAtomType    = (((ord('h') shl 8 +ord('s'))shl 8 +ord('t'))shl 8 +ord('r')) {'hstr'};		(* Parent is kQTVRObjectInfoAtomType. Required if track ref is not 1 as required by 2.0 format.*)
	kQTVRAngleRangeAtomType		= (((ord('a') shl 8 +ord('r'))shl 8 +ord('n'))shl 8 +ord('g')) {'arng'};
	kQTVRTrackRefArrayAtomType	= (((ord('t') shl 8 +ord('r'))shl 8 +ord('e'))shl 8 +ord('f')) {'tref'};
	kQTVRPanConstraintAtomType	= (((ord('p') shl 8 +ord('c'))shl 8 +ord('o'))shl 8 +ord('n')) {'pcon'};
	kQTVRTiltConstraintAtomType	= (((ord('t') shl 8 +ord('c'))shl 8 +ord('o'))shl 8 +ord('n')) {'tcon'};
	kQTVRFOVConstraintAtomType	= (((ord('f') shl 8 +ord('c'))shl 8 +ord('o'))shl 8 +ord('n')) {'fcon'};



 const	kQTVRObjectInfoAtomID		= 1;
	kQTVRObjectImageTrackRefAtomID = 1;							(* New with 2.1, it adds a track reference to select between multiple image tracks*)
	kQTVRObjectHotSpotTrackRefAtomID = 1;						(* New with 2.1, it adds a track reference to select between multiple hotspot tracks*)


(* Track reference types*)

 const	kQTVRImageTrackRefType		= (((ord('i') shl 8 +ord('m'))shl 8 +ord('g'))shl 8 +ord('t')) {'imgt'};
	kQTVRHotSpotTrackRefType	= (((ord('h') shl 8 +ord('o'))shl 8 +ord('t'))shl 8 +ord('t')) {'hott'};


(* Old hot spot types*)

 const	kQTVRHotSpotNavigableType	= (((ord('n') shl 8 +ord('a'))shl 8 +ord('v'))shl 8 +ord('g')) {'navg'};


(* Valid bits used in QTVRLinkHotSpotAtom*)

 const	kQTVRValidPan			= long(1) shl 0;
	kQTVRValidTilt			= long(1) shl 1;
	kQTVRValidFOV			= long(1) shl 2;
	kQTVRValidViewCenter		= long(1) shl 3;



(* Values for flags field in QTVRPanoSampleAtom*)

 const  kQTVRPanoFlagHorizontal		= long(1) shl 0;
	kQTVRPanoFlagLast		= long(1) shl 31;



(* Values for locationFlags field in QTVRNodeLocationAtom*)

 const	kQTVRSameFile	= 0;



(* Header for QTVR track's Sample Description packed record (vrWorld atom container is appended)*)

 type QTVRSampleDescription=packed record
       descSize:UInt32; (* total size of the QTVRSampleDescription*)
       descType:UInt32;	(* must be 'qtvr'*)

       reserved1:UInt32; (* must be zero*)
       reserved2:UInt16; (* must be zero*)
       dataRefIndex:UInt16; (* must be zero*)

       data:UInt32; (* Will be extended to hold vrWorld QTAtomContainer*)
       end;

      QTVRSampleDescriptionPtr=^QTVRSampleDescription;
      QTVRSampleDescriptionHandle=^QTVRSampleDescriptionPtr;

(*
  =================================================================================================
   Definitions and  typeures used in the VRWorld QTAtomContainer
  -------------------------------------------------------------------------------------------------
*)

 type QTVRStringAtom=packed record
       stringUsage:UInt16;
       stringLength:UInt16;
       theString:array[0..3]of unsigned_char; (* field previously named "string"*)
       end;

      QTVRStringAtomPtr=^QTVRStringAtom;

 type QTVRWorldHeaderAtom=packed record
       majorVersion:UInt16;
       minorVersion:UInt16;

       nameAtomID:QTAtomID;
       defaultNodeID:UInt32;
       vrWorldFlags:UInt32;

       reserved1:UInt32;
       reserved2:UInt32;
       end;

      QTVRWorldHeaderAtomPtr=^QTVRWorldHeaderAtom;

(* Valid bits used in QTVRPanoImagingAtom*)

 const  kQTVRValidCorrection	     = long(1) shl 0;
	kQTVRValidQuality	     = long(1) shl 1;
	kQTVRValidDirectDraw	     = long(1) shl 2;
	kQTVRValidFirstExtraProperty = long(1) shl 3;



 type QTVRPanoImagingAtom=packed record
       majorVersion:UInt16;
       minorVersion:UInt16;

       imagingMode:UInt32;
       imagingValidFlags:UInt32;

       correction:UInt32;
       quality:UInt32;
       directDraw:UInt32;
       imagingProperties:array[0..5]of UInt32;		(* for future properties*)

       reserved1:UInt32;
       reserved2:UInt32;
       end;

      QTVRPanoImagingAtomPtr=^QTVRPanoImagingAtom;

 type QTVRNodeLocationAtom=record
       majorVersion:UInt16;
       minorVersion:UInt16;

       nodeType:OSType;
       locationFlags:UInt32;
       locationData:UInt32;

       reserved1:UInt32;
       reserved2:UInt32;
       end;

      QTVRNodeLocationAtomPtr=^QTVRNodeLocationAtom;
(*
  =================================================================================================
   Definitions and  typeures used in the Nodeinfo QTAtomContainer
  -------------------------------------------------------------------------------------------------
*)


 type QTVRNodeHeaderAtom=record
       majorVersion:UInt16;
       minorVersion:UInt16;

       nodeType:OSType;
       nodeID:QTAtomID;
       nameAtomID:QTAtomID;
       commentAtomID:QTAtomID;

       reserved1:UInt32;
       reserved2:UInt32;
       end;
      QTVRNodeHeaderAtomPtr=^QTVRNodeHeaderAtom;

 type QTVRAngleRangeAtom=packed record
       minimumAngle:Float32;
       maximumAngle:Float32;
       end;
      QTVRAngleRangeAtomPtr=^QTVRAngleRangeAtom;

 type QTVRHotSpotInfoAtom=packed record
       majorVersion:UInt16;
       minorVersion:UInt16;

       hotSpotType:OSType;
       nameAtomID:QTAtomID;
       commentAtomID:QTAtomID;

       cursorID:array[0..2]of SInt32;

       (*canonical view for this hot spot*)
       bestPan:Float32;
       bestTilt:Float32;
       bestFOV:Float32;
       bestViewCenter:QTVRFloatPoint;

       (*Bounding box for this hot spot*)
       hotSpotRect:Rect;

       flags:UInt32;
       reserved1:UInt32;
       reserved2:UInt32;
       end;
      QTVRHotSpotInfoAtomPtr=^QTVRHotSpotInfoAtom;

 type QTVRLinkHotSpotAtom=packed record
       majorVersion:UInt16;
       minorVersion:UInt16;

       toNodeID:UInt32;

       fromValidFlags:UInt32;
       fromPan:Float32;
       fromTilt:Float32;
       fromFOV:Float32;
       fromViewCenter:QTVRFloatPoint;

       toValidFlags:UInt32;
       toPan:Float32;
       toTilt:Float32;
       toFOV:Float32;
       toViewCenter:QTVRFloatPoint;

       distance:Float32;

       flags:UInt32;
       reserved1:UInt32;
       reserved2:UInt32;
       end;
      QTVRLinkHotSpotAtomPtr=^QTVRLinkHotSpotAtom;

(*
  =================================================================================================
   Definitions and  typeures used in Panorama and Object tracks
  -------------------------------------------------------------------------------------------------
*)


 type QTVRPanoSampleAtom=packed record
       majorVersion:UInt16;
       minorVersion:UInt16;

       imageRefTrackIndex:UInt32;   (* track reference index of the full res image track*)
       hotSpotRefTrackIndex:UInt32; (* track reference index of the full res hot spot track*)

       minPan:Float32;
       maxPan:Float32;
       minTilt:Float32;
       maxTilt:Float32;
       minFieldOfView:Float32;
       maxFieldOfView:Float32;

       defaultPan:Float32;
       defaultTilt:Float32;
       defaultFieldOfView:Float32;

       (*Info for highest res version of image track*)
       imageSizeX:UInt32;					(* pixel width of the panorama (e.g. 768)*)
       imageSizeY:UInt32;					(* pixel height of the panorama (e.g. 2496)*)
       imageNumFramesX:UInt16;			(* diced frames wide (e.g. 1)*)
       imageNumFramesY:UInt16;			(* diced frames high (e.g. 24)*)

       (*Info for highest res version of hotSpot track*)
       hotSpotSizeX:UInt32;				(* pixel width of the hot spot panorama (e.g. 768)*)
       hotSpotSizeY:UInt32;				(* pixel height of the hot spot panorama (e.g. 2496)*)
       hotSpotNumFramesX:UInt16;			(* diced frames wide (e.g. 1)*)
       hotSpotNumFramesY:UInt16;			(* diced frames high (e.g. 24)*)

       flags:UInt32;
       reserved1:UInt32;
       reserved2:UInt32;
       end;
      QTVRPanoSampleAtomPtr=^QTVRPanoSampleAtom;

(* Special resolution values for the Image Track Reference Atoms. Use only one value per track reference.*)

 const	kQTVRFullTrackRes		= kQTVRFullRes;
	kQTVRHalfTrackRes		= kQTVRHalfRes;
	kQTVRQuarterTrackRes		= kQTVRQuarterRes;
	kQTVRPreviewTrackRes		= $8000;



 type QTVRTrackRefEntry=packed record
       trackRefType:UInt32;
       trackResolution:UInt16;
       trackRefIndex:UInt32;
       end;

(*
  =================================================================================================
   Object File format 2.0
  -------------------------------------------------------------------------------------------------
*)

 const	kQTVRObjectAnimateViewFramesOn    = (long(1) shl 0);
	kQTVRObjectPalindromeViewFramesOn = (long(1) shl 1);
	kQTVRObjectStartFirstViewFrameOn  = (long(1) shl 2);
	kQTVRObjectAnimateViewsOn	  = (long(1) shl 3);
	kQTVRObjectPalindromeViewsOn      = (long(1) shl 4);
	kQTVRObjectSyncViewToFrameRate    = (long(1) shl 5);
	kQTVRObjectDontLoopViewFramesOn   = (long(1) shl 6);
	kQTVRObjectPlayEveryViewFrameOn   = (long(1) shl 7);
	kQTVRObjectStreamingViewsOn	  = (long(1) shl 8);



 const	kQTVRObjectWrapPanOn		= (long(1) shl 0);
	kQTVRObjectWrapTiltOn		= (long(1) shl 1);
	kQTVRObjectCanZoomOn		= (long(1) shl 2);
	kQTVRObjectReverseHControlOn    = (long(1) shl 3);
	kQTVRObjectReverseVControlOn    = (long(1) shl 4);
	kQTVRObjectSwapHVControlOn	= (long(1) shl 5);
	kQTVRObjectTranslationOn	= (long(1) shl 6);



 const	kGrabberScrollerUI	= 1;							(* "Object" *)
	kOldJoyStickUI		= 2;							(*  "1.0 Object as Scene"     *)
	kJoystickUI		= 3;							(* "Object In Scene"*)
	kGrabberUI		= 4;							(* "Grabber only"*)
	kAbsoluteUI		= 5;								(* "Absolute pointer"*)




 type QTVRObjectSampleAtom=packed record
       majorVersion:UInt16; (* kQTVRMajorVersion*)
       minorVersion:UInt16; (* kQTVRMinorVersion*)
       movieType:UInt16; (* ObjectUITypes*)
       viewStateCount:UInt16; (* The number of view states 1 based*)
       defaultViewState:UInt16; (* The default view state number. The number must be 1 to viewStateCount*)
       mouseDownViewState:UInt16; (* The mouse down view state.   The number must be 1 to viewStateCount*)
       viewDuration:UInt32; (* The duration of each view including all animation frames in a view*)
       columns:UInt32; (* Number of columns in movie*)
       rows:UInt32; (* Number rows in movie*)
       mouseMotionScale:Float32; (* 180.0 for kStandardObject or kQTVRObjectInScene, actual degrees for kOldNavigableMovieScene.*)
       minPan:Float32; (* Start   horizontal pan angle in degrees*)
       maxPan:Float32; (* End     horizontal pan angle in degrees*)
       defaultPan:Float32; (* Initial horizontal pan angle in degrees (poster view)*)
       minTilt:Float32; (* Start   vertical   pan angle in degrees*)
       maxTilt:Float32; (* End     vertical   pan angle in degrees*)
       defaultTilt:Float32; (* Initial vertical   pan angle in degrees (poster view)	*)
       minFieldOfView:Float32; (* minimum field of view setting (appears as the maximum zoom effect) must be >= 1*)
       fieldOfView:Float32; (* the field of view range must be >= 1*)
       defaultFieldOfView:Float32; (* must be in minFieldOfView and maxFieldOfView range inclusive*)
       defaultViewCenterH:Float32;
       defaultViewCenterV:Float32;

       viewRate:Float32;
       frameRate:Float32;
       animationSettings:UInt32; (* 32 reserved bit fields*)
       controlSettings:UInt32; (* 32 reserved bit fields*)
       end;
      QTVRObjectSampleAtomPtr=^QTVRObjectSampleAtom;

{$ifdef OLDROUTINENAMES}
 type VRStringAtom=QTVRStringAtom;
      VRWorldHeaderAtom=QTVRWorldHeaderAtom;
      VRPanoImagingAtom=QTVRPanoImagingAtom;
      VRNodeLocationAtom=QTVRNodeLocationAtom;
      VRNodeHeaderAtom=QTVRNodeHeaderAtom;
      VRAngleRangeAtom=QTVRAngleRangeAtom;
      VRHotSpotInfoAtom=QTVRHotSpotInfoAtom;
      VRLinkHotSpotAtom=QTVRLinkHotSpotAtom;
      VRPanoSampleAtom=QTVRPanoSampleAtom;
      VRTrackRefEntry=QTVRTrackRefEntry;
      VRObjectSampleAtom=QTVRObjectSampleAtom;
{$endif}  (* OLDROUTINENAMES *)

implementation

end.
