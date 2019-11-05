(************************************************************************

       Borland Delphi Runtime Library
       QuickTime interface unit

 Portions created by Apple Computers Inc. are
 Copyright (C) 1990-2001 Apple Computers Inc.
 All Rights Reserved.

 The original file is: QuickTimeStreaming.h, released dd Mmm yyyy.
 The original Pascal code is: qt_QuickTimeStreaming.pas, released 30 Jun 2003.
 The initial developer of the Pascal code is George Birbilis (birbilis@kagi.com).

 Portions created by George Birbilis are
 Copyright (C) 2003 George Birbilis

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

unit qt_QuickTimeStreaming;

interface

(*
     File:       QuickTimeStreaming.h

     Contains:   QuickTime Interfaces.

     Version:    Technology: QuickTime 5.0
                 Release:    QuickTime 5.0.1

     Copyright:  (c) 1990-2001 by Apple Computer, Inc., all rights reserved

     Bugs?:      For bug reports, consult the following page on
                 the World Wide Web:

                     http://developer.apple.com/bugreporter/

*)

 uses
  C_Types,
  qt_MacTypes,
  qt_Movies,
  qt_Files,
  qt_QuickDraw,
  qt_Components,
  qt_QuickTimeComponents,
  qt_ImageCompression;

 const
  kQTSInfiniteDuration        = $7FFFFFFF;
  kQTSUnknownDuration         = $00000000;
  kQTSNormalForwardRate       = $00010000;
  kQTSStoppedRate             = $00000000;

 type
  QTSPresentationRecord=packed record
   data:packed array[0..0] of long;
   end;
  QTSPresentation=^QTSPresentationRecord;

  QTSStreamRecord=packed record
   data:packed array[0..0] of long;
   end;
  QTSStream=^QTSStreamRecord;

  QTSEditEntry=packed record
   presentationDuration:TimeValue64;
   streamStartTime:TimeValue64;
   streamRate:Fixed;
   end;

  QTSEditList=packed record
   numEdits:SInt32;
   edits:packed array[0..0] of QTSEditEntry;
   end;
  QTSEditListPtr=^QTSEditList;
  QTSEditListHandle=^QTSEditListPtr;

 const
  kQTSInvalidPresentation = QTSPresentation(long(0));
  kQTSAllPresentations    = QTSPresentation(long(0));
  kQTSInvalidStream       = QTSStream(long(0));
  kQTSAllStreams          = QTSStream(long(0));

 //typedef CALLBACK_API( ComponentResult , QTSNotificationProcPtr )(inErr:ComponentResult; inNotificationType:OSType; inNotificationParams:pointer; inRefCon:pointer);
 //typedef STACK_UPP_TYPE(QTSNotificationProcPtr)                  QTSNotificationUPP;
 type QTSNotificationUPP=pointer;

 (*-----------------------------------------
     Get / Set Info
 -----------------------------------------*)

 const
  kQTSGetURLLink = (((ord('g') shl 8 +ord('u'))shl 8 +ord('l'))shl 8 +ord('l')); {'gull'} (* ^QTSGetURLLinkRecord *)

 (* get and set *)

 const
  kQTSTargetBufferDurationInfo = (((ord('b') shl 8 +ord('u'))shl 8 +ord('f'))shl 8 +ord('r')); {'bufr'} (* ^Fixed in seconds, expected, not actual *)
  kQTSDurationInfo            = (((ord('d') shl 8 +ord('u'))shl 8 +ord('r'))shl 8 +ord('a')); {'dura'} (* ^QTSDurationAtom *)
  kQTSSoundLevelMeteringEnabledInfo = (((ord('m') shl 8 +ord('t'))shl 8 +ord('r'))shl 8 +ord('n')); {'mtrn'} (* ^Boolean *)
  kQTSSoundLevelMeterInfo     = (((ord('l') shl 8 +ord('e'))shl 8 +ord('v'))shl 8 +ord('m')); {'levm'} (* LevelMeterInfoPtr *)
  kQTSSourceTrackIDInfo       = (((ord('o') shl 8 +ord('t'))shl 8 +ord('i'))shl 8 +ord('d')); {'otid'} (* ^UInt32 *)
  kQTSSourceLayerInfo         = (((ord('o') shl 8 +ord('l'))shl 8 +ord('y'))shl 8 +ord('r')); {'olyr'} (* ^UInt16 *)
  kQTSSourceLanguageInfo      = (((ord('o') shl 8 +ord('l'))shl 8 +ord('n'))shl 8 +ord('g')); {'olng'} (* ^UInt16 *)
  kQTSSourceTrackFlagsInfo    = (((ord('o') shl 8 +ord('t'))shl 8 +ord('f'))shl 8 +ord('l')); {'otfl'} (* ^SInt32 *)
  kQTSSourceDimensionsInfo    = (((ord('o') shl 8 +ord('d'))shl 8 +ord('i'))shl 8 +ord('m')); {'odim'} (* ^QTSDimensionParams *)
  kQTSSourceVolumesInfo       = (((ord('o') shl 8 +ord('v'))shl 8 +ord('o'))shl 8 +ord('l')); {'ovol'} (* ^QTSVolumesParams *)
  kQTSSourceMatrixInfo        = (((ord('o') shl 8 +ord('m'))shl 8 +ord('a'))shl 8 +ord('t')); {'omat'} (* ^MatrixRecord *)
  kQTSSourceClipRectInfo      = (((ord('o') shl 8 +ord('c'))shl 8 +ord('l'))shl 8 +ord('p')); {'oclp'} (* ^Rect *)
  kQTSSourceGraphicsModeInfo  = (((ord('o') shl 8 +ord('g'))shl 8 +ord('r'))shl 8 +ord('m')); {'ogrm'} (* ^QTSGraphicsModeParams *)
  kQTSSourceScaleInfo         = (((ord('o') shl 8 +ord('s'))shl 8 +ord('c'))shl 8 +ord('l')); {'oscl'} (* ^Point *)
  kQTSSourceBoundingRectInfo  = (((ord('o') shl 8 +ord('r'))shl 8 +ord('c'))shl 8 +ord('t')); {'orct'} (* ^Rect *)
  kQTSSourceUserDataInfo      = (((ord('o') shl 8 +ord('u'))shl 8 +ord('d'))shl 8 +ord('t')); {'oudt'} (* UserData *)
  kQTSSourceInputMapInfo      = (((ord('o') shl 8 +ord('i'))shl 8 +ord('m'))shl 8 +ord('p')); {'oimp'} (* QTAtomContainer *)
  kQTSInfo_DataProc           = (((ord('d') shl 8 +ord('a'))shl 8 +ord('t'))shl 8 +ord('p')); {'datp'} (* ^QTSDataProcParams *)
  kQTSInfo_SendDataExtras     = (((ord('d') shl 8 +ord('e'))shl 8 +ord('x'))shl 8 +ord('t')); {'dext'} (* ^QTSSendDataExtrasParams *)
  kQTSInfo_HintTrackID        = (((ord('h') shl 8 +ord('t'))shl 8 +ord('i'))shl 8 +ord('d')); {'htid'} (* ^long *)

 (* get only *)

 const
  kQTSStatisticsInfo          = (((ord('s') shl 8 +ord('t'))shl 8 +ord('a'))shl 8 +ord('t')); {'stat'}       (* ^QTSStatisticsParams *)
  kQTSMinStatusDimensionsInfo = (((ord('m') shl 8 +ord('s'))shl 8 +ord('t'))shl 8 +ord('d')); {'mstd'}       (* ^QTSDimensionParams *)
  kQTSNormalStatusDimensionsInfo = (((ord('n') shl 8 +ord('s'))shl 8 +ord('t'))shl 8 +ord('d')); {'nstd'}    (* ^QTSDimensionParams *)
  kQTSTotalDataRateInfo       = (((ord('d') shl 8 +ord('r'))shl 8 +ord('t'))shl 8 +ord('t')); {'drtt'}       (* ^UInt32, add to what's there *)
  kQTSTotalDataRateInInfo     = (((ord('d') shl 8 +ord('r'))shl 8 +ord('t'))shl 8 +ord('i')); {'drti'}       (* ^UInt32, add to what's there *)
  kQTSTotalDataRateOutInfo    = (((ord('d') shl 8 +ord('r'))shl 8 +ord('t'))shl 8 +ord('o')); {'drto'}       (* ^UInt32, add to what's there *)
  kQTSLostPercentInfo         = (((ord('l') shl 8 +ord('p'))shl 8 +ord('c'))shl 8 +ord('t')); {'lpct'}       (* ^QTSLostPercentParams, add to what's there *)
  kQTSNumViewersInfo          = (((ord('n') shl 8 +ord('v'))shl 8 +ord('i'))shl 8 +ord('w')); {'nviw'}       (* ^UInt32 *)
  kQTSMediaTypeInfo           = (((ord('m') shl 8 +ord('t'))shl 8 +ord('y'))shl 8 +ord('p')); {'mtyp'}       (* ^OSType *)
  kQTSNameInfo                = (((ord('n') shl 8 +ord('a'))shl 8 +ord('m'))shl 8 +ord('e')); {'name'}       (* ^QTSNameParams *)
  kQTSCanHandleSendDataType   = (((ord('c') shl 8 +ord('h'))shl 8 +ord('s'))shl 8 +ord('d')); {'chsd'}       (* ^QTSCanHandleSendDataTypeParams *)
  kQTSAnnotationsInfo         = (((ord('m') shl 8 +ord('e'))shl 8 +ord('t'))shl 8 +ord('a')); {'meta'}       (* QTAtomContainer *)
  kQTSRemainingBufferTimeInfo = (((ord('b') shl 8 +ord('t'))shl 8 +ord('m'))shl 8 +ord('s')); {'btms'}       (* ^UInt32 remaining buffer time before playback, in microseconds *)
  kQTSInfo_SettingsText       = (((ord('s') shl 8 +ord('t'))shl 8 +ord('t'))shl 8 +ord('x')); {'sttx'}       (* ^QTSSettingsTextParams *)


 const
  kQTSTargetBufferDurationTimeScale = 1000;

 type
  QTSPanelFilterParams=packed record
   version:SInt32;
   inStream:QTSStream;
   inPanelType:OSType;
   inPanelSubType:OSType;
   details:QTAtomSpec;
   end;

 (* return true to keep this panel*)
 //typedef CALLBACK_API( Boolean , QTSPanelFilterProcPtr )(inParams:QTSPanelFilterParamsPtr; inRefCon:pointer);
 //typedef STACK_UPP_TYPE(QTSPanelFilterProcPtr)                   QTSPanelFilterUPP;
 type QTSPanelFilterUPP=pointer;

 const
  kQTSSettingsTextSummary = (((ord('s') shl 8 +ord('e'))shl 8 +ord('t'))shl 8 +ord('1')); {'set1'}
  kQTSSettingsTextDetails = (((ord('s') shl 8 +ord('e'))shl 8 +ord('t'))shl 8 +ord('d')); {'setd'}


 type
  QTSSettingsTextParams=packed record
   flags:SInt32;   (* None yet defined *)
   inSettingsSelector:OSType; (* which kind of setting you want from enum above *)
   outSettingsAsText:Handle; (* QTS allocates; Caller disposes *)
   inPanelFilterProc:QTSPanelFilterUPP; (* To get a subset filter with this *)
   inPanelFilterProcRefCon:pointer;
   end;

  QTSCanHandleSendDataTypeParams=packed record
   modifierTypeOrInputID:SInt32;
   isModifierType:Boolean;
   returnedCanHandleSendDataType:Boolean; (* callee sets to true if it can handle it *)
   end;

  QTSNameParams=packed record
   maxNameLength:SInt32;
   requestedLanguage:SInt32;
   returnedActualLanguage:SInt32;
   returnedName:unsigned_charPtr;               (* pascal string; caller supplies*)
   end;

  QTSLostPercentParams=packed record
   receivedPkts:UInt32;
   lostPkts:UInt32;
   percent:Fixed;
   end;

  QTSDimensionParams=packed record
   width:Fixed;
   height:Fixed;
   end;

  QTSVolumesParams=packed record
   leftVolume:SInt16;
   rightVolume:SInt16;
   end;

  QTSGraphicsModeParams=packed record
   graphicsMode:SInt16;
   opColor:RGBColor;
   end;

  QTSGetURLLinkRecord=packed record
   displayWhere:Point;
   returnedURLLink:Handle;
   end;

 const
  kQTSDataProcParamsVersion1  = 1;

 const
  kQTSDataProcType_MediaSample = (((ord('m') shl 8 +ord('d'))shl 8 +ord('i'))shl 8 +ord('a')); {'mdia'}
  kQTSDataProcType_HintSample = (((ord('h') shl 8 +ord('i'))shl 8 +ord('n'))shl 8 +ord('t')); {'hint'}

 type
  QTSDataProcParams=packed record
   version:SInt32;
   flags:SInt32;
   stream:QTSStream;
   procType:OSType;
   proc:QTSNotificationUPP;
   procRefCon:pointer;
   end;

 const
  kQTSDataProcSelector_SampleData = (((ord('s') shl 8 +ord('a'))shl 8 +ord('m'))shl 8 +ord('p')); {'samp'}
  kQTSDataProcSelector_UserData = (((ord('u') shl 8 +ord('s'))shl 8 +ord('e'))shl 8 +ord('r')); {'user'}

 const
  kQTSSampleDataCallbackParamsVersion1 = 1;


 type
  QTSSampleDataCallbackParams=packed record
   version:SInt32;
   flags:SInt32;
   stream:QTSStream;
   procType:OSType;
   mediaType:OSType;
   mediaTimeScale:TimeScale;
   sampleDesc:SampleDescriptionHandle;
   sampleDescSeed:UInt32;
   sampleTime:TimeValue64;
   duration:TimeValue64; (* could be 0 *)
   sampleFlags:SInt32;
   dataLength:UInt32;
   data:{const} pointer;
   end;

 const
  kQTSUserDataCallbackParamsVersion1 = 1;


 type
  QTSUserDataCallbackParams=packed record
   version:SInt32;
   flags:SInt32;
   stream:QTSStream;
   procType:OSType;
   userDataType:OSType;
   userDataHandle:Handle;    (* caller must make copy if it wants to keep the data around *)
   end;

 const
  kQTSSendDataExtrasParamsVersion1 = 1;

 type
  QTSSendDataExtrasParams=packed record
   version:SInt32;
   flags:SInt32;   procType:OSType;   end;

 //typedef CALLBACK_API( Boolean , QTSModalFilterProcPtr )(inDialog:DialogPtr; inEvent:ConstEventRecordPtr; ioItemHit:SInt16Ptr; inRefCon:pointer);
 //typedef STACK_UPP_TYPE(QTSModalFilterProcPtr) QTSModalFilterUPP;
 type QTSModalFilterUPP=pointer;

 (*-----------------------------------------
     Characteristics
 -----------------------------------------*)

 (* characteristics in Movies.h work here too *)
 const
  kQTSSupportsPerStreamControlCharacteristic = (((ord('p') shl 8 +ord('s'))shl 8 +ord('c'))shl 8 +ord('t')); {'psct'}


 type
  QTSVideoParams=packed record
   width:Fixed;
   height:Fixed;   matrix:MatrixRecord;   gWorld:CGrafPtr;   gdHandle:GDHandle;   clip:RgnHandle;   graphicsMode:short;   opColor:RGBColor;   end;

  QTSAudioParams=packed record
   leftVolume:SInt16;
   rightVolume:SInt16;
   bassLevel:SInt16;
   trebleLevel:SInt16;
   frequencyBandsCount:short;
   frequencyBands:pointer;
   levelMeteringEnabled:Boolean;
   end;

  QTSMediaParams=packed record
   v:QTSVideoParams;
   a:QTSAudioParams;
   end;
  QTSMediaParamsPtr=^QTSMediaParams;

 const
  kQTSMustDraw                = 1 shl 3;
  kQTSAtEnd                   = 1 shl 4;
  kQTSPreflightDraw           = 1 shl 5;
  kQTSSyncDrawing             = 1 shl 6;


 (* media task result flags *)
 const
  kQTSDidDraw                 = 1 shl 0;
  kQTSNeedsToDraw             = 1 shl 2;
  kQTSDrawAgain               = 1 shl 3;
  kQTSPartialDraw             = 1 shl 4;


 (*============================================================================
         Notifications
 ============================================================================*)

 (* ------ notification types ------ *)
 const
  kQTSNullNotification        = (((ord('n') shl 8 +ord('u'))shl 8 +ord('l'))shl 8 +ord('l')); {'null'}         (* NULL *)
  kQTSErrorNotification       = (((ord('e') shl 8 +ord('r'))shl 8 +ord('r'))shl 8 +ord(' ')); {'err '}         (* ^QTSErrorParams, optional *)
  kQTSNewPresDetectedNotification = (((ord('n') shl 8 +ord('e'))shl 8 +ord('w'))shl 8 +ord('p')); {'newp'}     (* ^QTSNewPresDetectedParams *)
  kQTSPresBeginChangingNotification = (((ord('p') shl 8 +ord('r'))shl 8 +ord('c'))shl 8 +ord('b')); {'prcb'}   (* NULL *)
  kQTSPresDoneChangingNotification = (((ord('p') shl 8 +ord('r'))shl 8 +ord('c'))shl 8 +ord('d')); {'prcd'}    (* NULL *)
  kQTSPresentationChangedNotification = (((ord('p') shl 8 +ord('r'))shl 8 +ord('c'))shl 8 +ord('h')); {'prch'} (* NULL *)
  kQTSNewStreamNotification   = (((ord('s') shl 8 +ord('t'))shl 8 +ord('n'))shl 8 +ord('w')); {'stnw'}         (* ^QTSNewStreamParams *)
  kQTSStreamBeginChangingNotification = (((ord('s') shl 8 +ord('t'))shl 8 +ord('c'))shl 8 +ord('b')); {'stcb'} (* QTSStream *)
  kQTSStreamDoneChangingNotification = (((ord('s') shl 8 +ord('t'))shl 8 +ord('c'))shl 8 +ord('d')); {'stcd'}  (* QTSStream *)
  kQTSStreamChangedNotification = (((ord('s') shl 8 +ord('t'))shl 8 +ord('c'))shl 8 +ord('h')); {'stch'}       (* ^QTSStreamChangedParams *)
  kQTSStreamGoneNotification  = (((ord('s') shl 8 +ord('t'))shl 8 +ord('g'))shl 8 +ord('n')); {'stgn'}         (* ^QTSStreamGoneParams *)
  kQTSPreviewAckNotification  = (((ord('p') shl 8 +ord('v'))shl 8 +ord('a'))shl 8 +ord('k')); {'pvak'}         (* QTSStream *)
  kQTSPrerollAckNotification  = (((ord('p') shl 8 +ord('a'))shl 8 +ord('c'))shl 8 +ord('k')); {'pack'}         (* QTSStream *)
  kQTSStartAckNotification    = (((ord('s') shl 8 +ord('a'))shl 8 +ord('c'))shl 8 +ord('k')); {'sack'}         (* QTSStream *)
  kQTSStopAckNotification     = (((ord('x') shl 8 +ord('a'))shl 8 +ord('c'))shl 8 +ord('k')); {'xack'}         (* QTSStream *)
  kQTSStatusNotification      = (((ord('s') shl 8 +ord('t'))shl 8 +ord('a'))shl 8 +ord('t')); {'stat'}         (* ^QTSStatusParams *)
  kQTSURLNotification         = (((ord('u') shl 8 +ord('r'))shl 8 +ord('l'))shl 8 +ord(' ')); {'url '}         (* ^QTSURLParams *)
  kQTSDurationNotification    = (((ord('d') shl 8 +ord('u'))shl 8 +ord('r'))shl 8 +ord('a')); {'dura'}         (* ^QTSDurationAtom *)
  kQTSNewPresentationNotification = (((ord('n') shl 8 +ord('p'))shl 8 +ord('r'))shl 8 +ord('s')); {'nprs'}     (* QTSPresentation *)
  kQTSPresentationGoneNotification = (((ord('x') shl 8 +ord('p'))shl 8 +ord('r'))shl 8 +ord('s')); {'xprs'}    (* QTSPresentation *)
  kQTSPresentationDoneNotification = (((ord('p') shl 8 +ord('d'))shl 8 +ord('o'))shl 8 +ord('n')); {'pdon'}    (* NULL *)
  kQTSBandwidthAlertNotification = (((ord('b') shl 8 +ord('w'))shl 8 +ord('a'))shl 8 +ord('l')); {'bwal'}      (* ^QTSBandwidthAlertParams *)
  kQTSAnnotationsChangedNotification = (((ord('m') shl 8 +ord('e'))shl 8 +ord('t'))shl 8 +ord('a')); {'meta'}  (* NULL *)


 (* flags for QTSErrorParams *)
 const
  kQTSFatalErrorFlag = $00000001;


 type
  QTSErrorParams=packed record
   {const} errorString:pchar;
   flags:SInt32;
   end;

  QTSNewPresDetectedParams=packed record
   data:pointer;
   end;

  QTSNewStreamParams=packed record
   stream:QTSStream;
   end;

  QTSStreamChangedParams=packed record
   stream:QTSStream;
   mediaComponent:ComponentInstance; (* could be NULL *)
   end;

  QTSStreamGoneParams=packed record
   stream:QTSStream;
   end;

  QTSStatusParams=packed record
   status:UInt32;
   {const} statusString:pchar;
   detailedStatus:UInt32;
   {const} detailedStatusString:pchar;
   end;

  QTSInfoParams=packed record
   infoType:OSType;
   infoParams:pointer;
   end;

  QTSURLParams=packed record
   urlLength:UInt32;
   {const} url:pchar;
   end;

 const
  kQTSBandwidthAlertNeedToStop = 1 shl 0;
  kQTSBandwidthAlertRestartAt = 1 shl 1;


 type
  QTSBandwidthAlertParams=packed record
   flags:SInt32;
   restartAt:TimeValue;   (* new field in QT 4.1*)
   reserved:pointer;
   end;


 (*============================================================================
         Presentation
 ============================================================================*)

 (*-----------------------------------------
      Flags
 -----------------------------------------*)

 (* flags for NewPresentationFromData *)
 const
  kQTSAutoModeFlag            = $00000001;
  kQTSDontShowStatusFlag      = $00000008;
  kQTSSendMediaFlag           = $00010000;
  kQTSReceiveMediaFlag        = $00020000;


 type
  QTSNewPresentationParams=packed record
   dataType:OSType;
   {const} data:pointer;
   dataLength:UInt32;
   editList:QTSEditListHandle;
   flags:SInt32;
   timeScale:TimeScale;  (* set to 0 for default timescale *)
   mediaParams:QTSMediaParamsPtr;
   notificationProc:QTSNotificationUPP;
   notificationRefCon:pointer;
   end;
  QTSNewPresentationParamsPtr=^QTSNewPresentationParams; 

  QTSPresParams=packed record
   version:UInt32;
   editList:QTSEditListHandle;
   flags:SInt32;
   timeScale:TimeScale;  (* set to 0 for default timescale *)
   mediaParams:QTSMediaParamsPtr;
   notificationProc:QTSNotificationUPP;
   notificationRefCon:pointer;
   end;
  QTSPresParamsPtr=^QTSPresParams;

 const
  kQTSPresParamsVersion1 = 1;


  type
  QTSPresIdleParams=packed record
   stream:QTSStream;
   movieTimeToDisplay:TimeValue64;
   flagsIn:SInt32;
   flagsOut:SInt32;
   end;

 const
  kQTSExportFlag_ShowDialog   = $00000001;

 const
  kQTSExportParamsVersion1    = 1;

 type
  QTSExportParams=packed record
   version:SInt32;
   exportType:OSType;
   exportExtraData:pointer;
   destinationContainerType:OSType;
   destinationContainerData:pointer;
   destinationContainerExtras:pointer;
   flagsIn:SInt32;
   flagsOut:SInt32;
   filterProc:QTSModalFilterUPP;
   filterProcRefCon:pointer;
   exportComponent:Component; (* NULL unless you want to override *)
   end;

 (*-----------------------------------------
     Toolbox Init/Close
 -----------------------------------------*)

 (* all "apps" must call this *)
  function InitializeQTS():OSErr; cdecl; external 'qtmlClient.dll';
  function TerminateQTS():OSErr; cdecl; external 'qtmlClient.dll';

 (*-----------------------------------------
     Presentation Functions
 -----------------------------------------*)

 function QTSNewPresentation({const} inParams:QTSNewPresentationParamsPtr;var outPresentation:QTSPresentation):OSErr; cdecl;
 function QTSNewPresentationFromData(inDataType:OSType;{const} inData:pointer;{const} inDataLength:SInt64Ptr;{const} inPresParams:QTSPresParamsPtr;var outPresentation:QTSPresentation):OSErr; cdecl;
 function QTSNewPresentationFromFile({const} inFileSpec:FSSpecPtr;{const} inPresParams:QTSPresParamsPtr;var outPresentation:QTSPresentation):OSErr; cdecl;
 function QTSNewPresentationFromDataRef(inDataRef:Handle;inDataRefType:OSType;{const} inPresParams:QTSPresParamsPtr;var outPresentation:QTSPresentation):OSErr; cdecl;
 function QTSDisposePresentation(inPresentation:QTSPresentation;inFlags:SInt32):OSErr; cdecl;
 function QTSPresExport(inPresentation:QTSPresentation;inStream:QTSStream;var inExportParams:QTSExportParams):OSErr; cdecl;
 procedure QTSPresIdle(inPresentation:QTSPresentation;var ioParams:QTSPresIdleParams); cdecl;
 function QTSPresInvalidateRegion(inPresentation:QTSPresentation;inRegion:RgnHandle):OSErr; cdecl;

 (*-----------------------------------------
     Presentation Configuration
 -----------------------------------------*)

 function QTSPresSetFlags(inPresentation:QTSPresentation;inFlags:SInt32;inFlagsMask:SInt32):OSErr; cdecl;
 function QTSPresGetFlags(inPresentation:QTSPresentation;var outFlags:SInt32):OSErr; cdecl;
 function QTSPresGetTimeBase(inPresentation:QTSPresentation;var outTimeBase:TimeBase):OSErr; cdecl;
 function QTSPresGetTimeScale(inPresentation:QTSPresentation;var outTimeScale:TimeScale):OSErr; cdecl;
 function QTSPresSetInfo(inPresentation:QTSPresentation;inStream:QTSStream;inSelector:OSType;ioParam:pointer):OSErr; cdecl;
 function QTSPresGetInfo(inPresentation:QTSPresentation;inStream:QTSStream;inSelector:OSType;ioParam:pointer):OSErr; cdecl;
 function QTSPresHasCharacteristic(inPresentation:QTSPresentation;inStream:QTSStream;inCharacteristic:OSType;var outHasIt:Boolean):OSErr; cdecl;
 function QTSPresSetNotificationProc(inPresentation:QTSPresentation;inNotificationProc:QTSNotificationUPP;inRefCon:pointer):OSErr; cdecl;
 function QTSPresGetNotificationProc(inPresentation:QTSPresentation;var outNotificationProc:QTSNotificationUPP;outRefCon:Handle):OSErr; cdecl;

 (*-----------------------------------------
     Presentation Control
 -----------------------------------------*)

 function QTSPresPreview(inPresentation:QTSPresentation;inStream:QTSStream;{const} inTimeValue:TimeValue64Ptr;inRate:Fixed;inFlags:SInt32):OSErr; cdecl;
 function QTSPresPreroll(inPresentation:QTSPresentation;inStream:QTSStream;inTimeValue:UInt32;inRate:Fixed;inFlags:SInt32):OSErr; cdecl;
 function QTSPresPreroll64(inPresentation:QTSPresentation;inStream:QTSStream;{const} inPrerollTime:TimeValue64Ptr;inRate:Fixed;inFlags:SInt32):OSErr; cdecl;
 function QTSPresStart(inPresentation:QTSPresentation;inStream:QTSStream;inFlags:SInt32):OSErr; cdecl;
 function QTSPresSkipTo(inPresentation:QTSPresentation;inTimeValue:UInt32):OSErr; cdecl;
 function QTSPresSkipTo64(inPresentation:QTSPresentation;{const} inTimeValue:TimeValue64Ptr):OSErr; cdecl;
 function QTSPresStop(inPresentation:QTSPresentation;inStream:QTSStream;inFlags:SInt32):OSErr; cdecl;


 (*============================================================================
         Streams
 ============================================================================*)

 (*-----------------------------------------
     Stream Functions
 -----------------------------------------*)

 function QTSPresNewStream(inPresentation:QTSPresentation;inDataType:OSType;{const} inData:pointer;inDataLength:UInt32;inFlags:SInt32;var outStream:QTSStream):OSErr; cdecl;
 function QTSDisposeStream(inStream:QTSStream;inFlags:SInt32):OSErr; cdecl;
 function QTSPresGetNumStreams(inPresentation:QTSPresentation):UInt32; cdecl;
 function QTSPresGetIndStream(inPresentation:QTSPresentation;inIndex:UInt32):QTSStream; cdecl;
 function QTSGetStreamPresentation(inStream:QTSStream):QTSPresentation; cdecl;
 function QTSPresSetPreferredRate(inPresentation:QTSPresentation;inRate:Fixed;inFlags:SInt32):OSErr; cdecl;
 function QTSPresGetPreferredRate(inPresentation:QTSPresentation;var outRate:Fixed):OSErr; cdecl;
 function QTSPresSetEnable(inPresentation:QTSPresentation;inStream:QTSStream;inEnableMode:Boolean):OSErr; cdecl;
 function QTSPresGetEnable(inPresentation:QTSPresentation;inStream:QTSStream;var outEnableMode:Boolean):OSErr; cdecl;
 function QTSPresSetPresenting(inPresentation:QTSPresentation;inStream:QTSStream;inPresentingMode:Boolean):OSErr; cdecl;
 function QTSPresGetPresenting(inPresentation:QTSPresentation;inStream:QTSStream;var outPresentingMode:Boolean):OSErr; cdecl;
 function QTSPresSetActiveSegment(inPresentation:QTSPresentation;inStream:QTSStream;{const} inStartTime:TimeValue64Ptr;{const} inDuration:TimeValue64Ptr):OSErr; cdecl;
 function QTSPresGetActiveSegment(inPresentation:QTSPresentation;inStream:QTSStream;var outStartTime:TimeValue64;var outDuration:TimeValue64):OSErr; cdecl;
 function QTSPresSetPlayHints(inPresentation:QTSPresentation;inStream:QTSStream;inFlags:SInt32;inFlagsMask:SInt32):OSErr; cdecl;
 function QTSPresGetPlayHints(inPresentation:QTSPresentation;inStream:QTSStream;var outFlags:SInt32):OSErr; cdecl;

 (*-----------------------------------------
     Stream Spatial Functions
 -----------------------------------------*)

 function QTSPresSetGWorld(inPresentation:QTSPresentation;inStream:QTSStream;inGWorld:CGrafPtr;inGDHandle:GDHandle):OSErr; cdecl;
 function QTSPresGetGWorld(inPresentation:QTSPresentation;inStream:QTSStream;var outGWorld:CGrafPtr;var outGDHandle:GDHandle):OSErr; cdecl;
 function QTSPresSetClip(inPresentation:QTSPresentation;inStream:QTSStream;inClip:RgnHandle):OSErr; cdecl;
 function QTSPresGetClip(inPresentation:QTSPresentation;inStream:QTSStream;var outClip:RgnHandle):OSErr; cdecl;
 function QTSPresSetMatrix(inPresentation:QTSPresentation;inStream:QTSStream;{const} inMatrix:MatrixRecordPtr):OSErr; cdecl;
 function QTSPresGetMatrix(inPresentation:QTSPresentation;inStream:QTSStream;var outMatrix:MatrixRecord):OSErr; cdecl;
 function QTSPresSetDimensions(inPresentation:QTSPresentation;inStream:QTSStream;inWidth:Fixed;inHeight:Fixed):OSErr; cdecl;
 function QTSPresGetDimensions(inPresentation:QTSPresentation;inStream:QTSStream;var outWidth:Fixed;var outHeight:Fixed):OSErr; cdecl;
 function QTSPresSetGraphicsMode(inPresentation:QTSPresentation;inStream:QTSStream;inMode:short;{const} inOpColor:RGBColorPtr):OSErr; cdecl;
 function QTSPresGetGraphicsMode(inPresentation:QTSPresentation;inStream:QTSStream;var outMode:short;var outOpColor:RGBColor):OSErr; cdecl;
 function QTSPresGetPicture(inPresentation:QTSPresentation;inStream:QTSStream;var outPicture:PicHandle):OSErr; cdecl;

 (*-----------------------------------------
     Stream Sound Functions
 -----------------------------------------*)

 function QTSPresSetVolumes(inPresentation:QTSPresentation;inStream:QTSStream;inLeftVolume:short;inRightVolume:short):OSErr; cdecl;
 function QTSPresGetVolumes(inPresentation:QTSPresentation;inStream:QTSStream;var outLeftVolume:short;var outRightVolume:short):OSErr; cdecl;

 (*-----------------------------------------
     Sourcing
 -----------------------------------------*)

 function QTSPresGetSettingsAsText(inPresentation:QTSPresentation;inStream:QTSStream;inFlags:SInt32;inSettingsType:OSType;var outText:Handle;inPanelFilterProc:QTSPanelFilterUPP;inPanelFilterProcRefCon:pointer):OSErr; cdecl;
 function QTSPresSettingsDialog(inPresentation:QTSPresentation;inStream:QTSStream;inFlags:SInt32;inFilterProc:QTSModalFilterUPP;inFilterProcRefCon:pointer):OSErr; cdecl;
 function QTSPresSettingsDialogWithFilters(inPresentation:QTSPresentation;inStream:QTSStream;inFlags:SInt32;inFilterProc:QTSModalFilterUPP;inFilterProcRefCon:pointer;inPanelFilterProc:QTSPanelFilterUPP;inPanelFilterProcRefCon:pointer):OSErr; cdecl;
 function QTSPresSetSettings(inPresentation:QTSPresentation;inStream:QTSStream;inSettings:QTAtomSpecPtr;inFlags:SInt32):OSErr; cdecl;
 function QTSPresGetSettings(inPresentation:QTSPresentation;inStream:QTSStream;var outSettings:QTAtomContainer;inFlags:SInt32):OSErr; cdecl;
 function QTSPresAddSourcer(inPresentation:QTSPresentation;inStream:QTSStream;inSourcer:ComponentInstance;inFlags:SInt32):OSErr; cdecl;
 function QTSPresRemoveSourcer(inPresentation:QTSPresentation;inStream:QTSStream;inSourcer:ComponentInstance;inFlags:SInt32):OSErr; cdecl;
 function QTSPresGetNumSourcers(inPresentation:QTSPresentation;inStream:QTSStream):UInt32; cdecl;
 function QTSPresGetIndSourcer(inPresentation:QTSPresentation;inStream:QTSStream;inIndex:UInt32;var outSourcer:ComponentInstance):OSErr; cdecl;

 (*============================================================================
         Misc
 ============================================================================*)

 (* flags for Get/SetNetworkAppName *)
 const
  kQTSNetworkAppNameIsFullNameFlag = $00000001;

 function QTSSetNetworkAppName({const} inAppName:pchar;inFlags:SInt32):OSErr; cdecl;
 function QTSGetNetworkAppName(inFlags:SInt32;outCStringPtr:charHandle):OSErr; cdecl;

 (*-----------------------------------------
     Statistics Utilities
 -----------------------------------------*)

 type
  QTSStatHelperRecord=packed record
   data:array[0..0] of long;
   end;

  QTSStatHelper=^QTSStatHelperRecord;

 const
  kQTSInvalidStatHelper = long(0);

 (* flags for QTSStatHelperNextParams *)
 const
  kQTSStatHelperReturnPascalStringsFlag = $00000001;


 type
  QTSStatHelperNextParams=packed record
   flags:SInt32;
   returnedStatisticsType:OSType;
   returnedStream:QTSStream;
   maxStatNameLength:UInt32;
   returnedStatName:pchar;           (* NULL if you don't want it *)
   maxStatStringLength:UInt32;
   returnedStatString:pchar;         (* NULL if you don't want it *)
   maxStatUnitLength:UInt32;
   returnedStatUnit:pchar;           (* NULL if you don't want it *)
   end;

  QTSStatisticsParams=packed record
   statisticsType:OSType;
   container:QTAtomContainer;
   parentAtom:QTAtom;
   flags:SInt32;
   end;

 (* general statistics types *)
 const
  kQTSAllStatisticsType       = (((ord('a') shl 8 +ord('l'))shl 8 +ord('l'))shl 8 +ord(' ')); {'all '}
  kQTSShortStatisticsType     = (((ord('s') shl 8 +ord('h'))shl 8 +ord('r'))shl 8 +ord('t')); {'shrt'}
  kQTSSummaryStatisticsType   = (((ord('s') shl 8 +ord('u'))shl 8 +ord('m'))shl 8 +ord('m')); {'summ'}

 (* statistics flags *)
 const
  kQTSGetNameStatisticsFlag              = $00000001;
  kQTSDontGetDataStatisticsFlag          = $00000002;
  kQTSUpdateAtomsStatisticsFlag          = $00000004;
  kQTSGetUnitsStatisticsFlag             = $00000008;
  kQTSUpdateAllIfNecessaryStatisticsFlag = $00010000;

 (* statistics atom types *)
 const
  kQTSStatisticsStreamAtomType = (((ord('s') shl 8 +ord('t'))shl 8 +ord('r'))shl 8 +ord('m')); {'strm'}
  kQTSStatisticsNameAtomType  = (((ord('n') shl 8 +ord('a'))shl 8 +ord('m'))shl 8 +ord('e')); {'name'}  (* chars only, no length or terminator *)
  kQTSStatisticsDataFormatAtomType = (((ord('f') shl 8 +ord('r'))shl 8 +ord('m'))shl 8 +ord('t')); {'frmt'} (* OSType *)
  kQTSStatisticsDataAtomType  = (((ord('d') shl 8 +ord('a'))shl 8 +ord('t'))shl 8 +ord('a')); {'data'}
  kQTSStatisticsUnitsAtomType = (((ord('u') shl 8 +ord('n'))shl 8 +ord('i'))shl 8 +ord('t')); {'unit'} (* OSType *)
  kQTSStatisticsUnitsNameAtomType = (((ord('u') shl 8 +ord('n'))shl 8 +ord('i'))shl 8 +ord('n')); {'unin'} (* chars only, no length or terminator *)

 (* statistics data formats *)
 const
  kQTSStatisticsSInt32DataFormat = (((ord('s') shl 8 +ord('i'))shl 8 +ord('3'))shl 8 +ord('2')); {'si32'}
  kQTSStatisticsUInt32DataFormat = (((ord('u') shl 8 +ord('i'))shl 8 +ord('3'))shl 8 +ord('2')); {'ui32'}
  kQTSStatisticsSInt16DataFormat = (((ord('s') shl 8 +ord('i'))shl 8 +ord('1'))shl 8 +ord('6')); {'si16'}
  kQTSStatisticsUInt16DataFormat = (((ord('u') shl 8 +ord('i'))shl 8 +ord('1'))shl 8 +ord('6')); {'ui16'}
  kQTSStatisticsFixedDataFormat = (((ord('f') shl 8 +ord('i'))shl 8 +ord('x'))shl 8 +ord('d')); {'fixd'}
  kQTSStatisticsUnsignedFixedDataFormat = (((ord('u') shl 8 +ord('f'))shl 8 +ord('i'))shl 8 +ord('x')); {'ufix'}
  kQTSStatisticsStringDataFormat = (((ord('s') shl 8 +ord('t'))shl 8 +ord('r'))shl 8 +ord('g')); {'strg'}
  kQTSStatisticsOSTypeDataFormat = (((ord('o') shl 8 +ord('s'))shl 8 +ord('t'))shl 8 +ord('p')); {'ostp'}
  kQTSStatisticsRectDataFormat = (((ord('r') shl 8 +ord('e'))shl 8 +ord('c'))shl 8 +ord('t')); {'rect'}
  kQTSStatisticsPointDataFormat = (((ord('p') shl 8 +ord('o'))shl 8 +ord('n'))shl 8 +ord('t')); {'pont'}

 (* statistics units types *)
 const
  kQTSStatisticsNoUnitsType   = 0;
  kQTSStatisticsPercentUnitsType = (((ord('p') shl 8 +ord('c'))shl 8 +ord('n'))shl 8 +ord('t')); {'pcnt'}
  kQTSStatisticsBitsPerSecUnitsType = (((ord('b') shl 8 +ord('p'))shl 8 +ord('s'))shl 8 +ord(' ')); {'bps '}
  kQTSStatisticsFramesPerSecUnitsType = (((ord('f') shl 8 +ord('p'))shl 8 +ord('s'))shl 8 +ord(' ')); {'fps '}

 (* specific statistics types *)
 const
  kQTSTotalDataRateStat       = (((ord('d') shl 8 +ord('r'))shl 8 +ord('t'))shl 8 +ord('t')); {'drtt'}
  kQTSTotalDataRateInStat     = (((ord('d') shl 8 +ord('r'))shl 8 +ord('t'))shl 8 +ord('i')); {'drti'}
  kQTSTotalDataRateOutStat    = (((ord('d') shl 8 +ord('r'))shl 8 +ord('t'))shl 8 +ord('o')); {'drto'}
  kQTSNetworkIDStringStat     = (((ord('n') shl 8 +ord('i'))shl 8 +ord('d'))shl 8 +ord('s')); {'nids'}

 function QTSNewStatHelper(inPresentation:QTSPresentation;inStream:QTSStream;inStatType:OSType;inFlags:SInt32;var outStatHelper:QTSStatHelper):OSErr; cdecl;
 function QTSDisposeStatHelper(inStatHelper:QTSStatHelper):OSErr; cdecl;
 function QTSStatHelperGetStats(inStatHelper:QTSStatHelper):OSErr; cdecl;
 function QTSStatHelperResetIter(inStatHelper:QTSStatHelper):OSErr; cdecl;
 function QTSStatHelperNext(inStatHelper:QTSStatHelper;var ioParams:QTSStatHelperNextParams):Boolean; cdecl;
 function QTSStatHelperGetNumStats(inStatHelper:QTSStatHelper):UInt32; cdecl;

 (* used by components to put statistics into the atom container *)

 function QTSGetOrMakeStatAtomForStream(inContainer:QTAtomContainer;inStream:QTSStream;var outParentAtom:QTAtom):OSErr; cdecl;
 function QTSInsertStatistic(inContainer:QTAtomContainer;inParentAtom:QTAtom;inStatType:OSType;inStatData:pointer;inStatDataLength:UInt32;inStatDataFormat:OSType;inFlags:SInt32):OSErr; cdecl;
 function QTSInsertStatisticName(inContainer:QTAtomContainer;inParentAtom:QTAtom;inStatType:OSType;{const} inStatName:pchar;inStatNameLength:UInt32):OSErr; cdecl;
 function QTSInsertStatisticUnits(inContainer:QTAtomContainer;inParentAtom:QTAtom;inStatType:OSType;inUnitsType:OSType;{const} inUnitsName:pchar;inUnitsNameLength:UInt32):OSErr; cdecl;

 (*============================================================================
         Data Formats
 ============================================================================*)

 (*-----------------------------------------
     Data Types
 -----------------------------------------*)

 (* universal data types *)
 const
  kQTSNullDataType            = (((ord('N') shl 8 +ord('U'))shl 8 +ord('L'))shl 8 +ord('L')); {'NULL'}
  kQTSUnknownDataType         = (((ord('h') shl 8 +ord('u'))shl 8 +ord('h'))shl 8 +ord('?')); {'huh?'}
  kQTSAtomContainerDataType   = (((ord('q') shl 8 +ord('t'))shl 8 +ord('a'))shl 8 +ord('c')); {'qtac'}       (* QTAtomContainer *)
  kQTSAtomDataType            = (((ord('q') shl 8 +ord('t'))shl 8 +ord('a'))shl 8 +ord('t')); {'qtat'}       (* ^QTSAtomContainerDataStruct *)
  kQTSAliasDataType           = (((ord('a') shl 8 +ord('l'))shl 8 +ord('i'))shl 8 +ord('s')); {'alis'}
  kQTSFileDataType            = (((ord('f') shl 8 +ord('s'))shl 8 +ord('p'))shl 8 +ord('c')); {'fspc'}       (* ^FSSpec *)
  kQTSFileSpecDataType        = (((ord('f') shl 8 +ord('s'))shl 8 +ord('p'))shl 8 +ord('c')); {'fspc'}       (* ^FSSpec *)
  kQTSHandleDataType          = (((ord('h') shl 8 +ord('n'))shl 8 +ord('d'))shl 8 +ord('l')); {'hndl'}       (* ^Handle *)
  kQTSDataRefDataType         = (((ord('d') shl 8 +ord('r'))shl 8 +ord('e'))shl 8 +ord('f')); {'dref'}       (* DataReferencePtr *)

 (* these data types are specific to presentations *)
 const
  kQTSRTSPDataType            = (((ord('r') shl 8 +ord('t'))shl 8 +ord('s'))shl 8 +ord('p')); {'rtsp'}
  kQTSSDPDataType             = (((ord('s') shl 8 +ord('d'))shl 8 +ord('p'))shl 8 +ord(' ')); {'sdp '}

 (*-----------------------------------------
     Atom IDs
 -----------------------------------------*)

 const
  kQTSAtomType_Presentation   = (((ord('p') shl 8 +ord('r'))shl 8 +ord('e'))shl 8 +ord('s')); {'pres'}
  kQTSAtomType_PresentationHeader = (((ord('p') shl 8 +ord('h'))shl 8 +ord('d'))shl 8 +ord('r')); {'phdr'}   (* QTSPresentationHeaderAtom *)
  kQTSAtomType_MediaStream    = (((ord('m') shl 8 +ord('s'))shl 8 +ord('t'))shl 8 +ord('r')); {'mstr'}
  kQTSAtomType_MediaStreamHeader = (((ord('m') shl 8 +ord('s'))shl 8 +ord('h'))shl 8 +ord('d')); {'mshd'}    (* QTSMediaStreamHeaderAtom *)
  kQTSAtomType_MediaDescriptionText = (((ord('m') shl 8 +ord('d'))shl 8 +ord('e'))shl 8 +ord('s')); {'mdes'} (* chars, no length *)
  kQTSAtomType_ClipRect       = (((ord('c') shl 8 +ord('l'))shl 8 +ord('i'))shl 8 +ord('p')); {'clip'}       (* QTSClipRectAtom *)
  kQTSAtomType_Duration       = (((ord('d') shl 8 +ord('u'))shl 8 +ord('r'))shl 8 +ord('a')); {'dura'}       (* QTSDurationAtom *)
  kQTSAtomType_BufferTime     = (((ord('b') shl 8 +ord('u'))shl 8 +ord('f'))shl 8 +ord('r')); {'bufr'}        (* QTSBufferTimeAtom *)


 type
  QTSAtomContainerDataStruct=packed record
   container:QTAtomContainer;
   parentAtom:QTAtom;
   end;

 (* flags for QTSPresentationHeaderAtom *)
 const
  kQTSPresHeaderTypeIsData    = $00000100;
  kQTSPresHeaderDataIsHandle  = $00000200;


 type
  QTSPresentationHeaderAtom=packed record
   versionAndFlags:SInt32;
   conductorOrDataType:OSType;
   dataAtomType:OSType;               (* where the data really is *)
   end;

  QTSMediaStreamHeaderAtom=packed record
   versionAndFlags:SInt32;
   mediaTransportType:OSType;
   mediaTransportDataAID:OSType;  (* where the data really is *)
   end;

  QTSBufferTimeAtom=packed record
   versionAndFlags:SInt32;
   bufferTime:Fixed;
   end;

  QTSDurationAtom=packed record
   versionAndFlags:SInt32;
   timeScale:TimeScale;
   duration:TimeValue64;
   end;

  QTSClipRectAtom=packed record
   versionAndFlags:SInt32;
   clipRect:Rect;
   end;

 const
  kQTSEmptyEditStreamStartTime = -1;


 type
  QTSStatus=UInt32;

 const
  kQTSNullStatus              = 0;
  kQTSUninitializedStatus     = 1;
  kQTSConnectingStatus        = 2;
  kQTSOpeningConnectionDetailedStatus = 3;
  kQTSMadeConnectionDetailedStatus = 4;
  kQTSNegotiatingStatus       = 5;
  kQTSGettingDescriptionDetailedStatus = 6;
  kQTSGotDescriptionDetailedStatus = 7;
  kQTSSentSetupCmdDetailedStatus = 8;
  kQTSReceivedSetupResponseDetailedStatus = 9;
  kQTSSentPlayCmdDetailedStatus = 10;
  kQTSReceivedPlayResponseDetailedStatus = 11;
  kQTSBufferingStatus         = 12;
  kQTSPlayingStatus           = 13;
  kQTSPausedStatus            = 14;
  kQTSAutoConfiguringStatus   = 15;
  kQTSDownloadingStatus       = 16;
  kQTSBufferingWithTimeStatus = 17;
  kQTSWaitingDisconnectStatus = 100;

 (*-----------------------------------------
     QuickTime Preferences Types
 -----------------------------------------*)

 const
  kQTSConnectionPrefsType     = (((ord('s') shl 8 +ord('t'))shl 8 +ord('c'))shl 8 +ord('m')); {'stcm'}       (* root atom that all other atoms are contained in*)
                                                                 (*    kQTSNotUsedForProxyPrefsType = 'nopr',     /        comma-delimited list of URLs that are never used for proxies*)
  kQTSConnectionMethodPrefsType = (((ord('m') shl 8 +ord('t'))shl 8 +ord('h'))shl 8 +ord('d')); {'mthd'}     (*      connection method (OSType that matches one of the following three)*)
  kQTSDirectConnectPrefsType  = (((ord('d') shl 8 +ord('r'))shl 8 +ord('c'))shl 8 +ord('t')); {'drct'}       (*       used if direct connect (QTSDirectConnectPrefsRecord)*)
                                                                 (*    kQTSRTSPProxyPrefsType =     'rtsp',   /  used if RTSP Proxy (QTSProxyPrefsRecord)*)
  kQTSSOCKSPrefsType          = (((ord('s') shl 8 +ord('o'))shl 8 +ord('c'))shl 8 +ord('k')); {'sock'}        (*       used if SOCKS Proxy (QTSProxyPrefsRecord)*)

 const
  kQTSDirectConnectHTTPProtocol = (((ord('h') shl 8 +ord('t'))shl 8 +ord('t'))shl 8 +ord('p')); {'http'}
  kQTSDirectConnectRTSPProtocol = (((ord('r') shl 8 +ord('t'))shl 8 +ord('s'))shl 8 +ord('p')); {'rtsp'}


 type
  QTSDirectConnectPrefsRecord=packed record
   tcpPortID:UInt32;
   protocol:OSType;
   end;

  QTSProxyPrefsRecord=packed record
   serverNameStr:Str255;
   portID:UInt32;
   end;

 const
  kQTSTransAndProxyPrefsVersNum = 2;       (* prefs atom format version *)

 const
  kConnectionActive           = (long(1) shl 0);
  kConnectionUseSystemPref    = (long(1) shl 1);


 type
  QTSTransportPref=packed record
   protocol:OSType; (* udp, http, tcp, etc *)
   portID:SInt32;   (* port to use for this connection type *)
   flags:UInt32;    (* connection flags *)
   seed:UInt32;     (* seed value last time this setting was read from system prefs *)
   end;
  QTSTransportPrefPtr=^QTSTransportPref;

 const
  kProxyActive                = (long(1) shl 0);
  kProxyUseSystemPref         = (long(1) shl 1);


 type
  QTSProxyPref=packed record
   flags:UInt32;         (* proxy flags*)
   portID:SInt32;        (* port to use for this connection type *)
   seed:UInt32;          (* seed value last time this setting was read from system prefs *)
   serverNameStr:Str255; (* proxy server url *)
   end;
  QTSProxyPrefPtr=^QTSProxyPref;

 const
  kNoProxyUseSystemPref = (long(1) shl 0);


 type
  QTSNoProxyPref=packed record
   flags:UInt32; (* no-proxy flags *)
   seed:UInt32; (* seed value last time this setting was read from system prefs *)
   urlList:packed array[0..0] of AnsiChar; (* NULL terminated, comma delimited list of urls *)
   end;
  QTSNoProxyPrefPtr=^QTSNoProxyPref;

 const
  kQTSTransAndProxyAtomType   = (((ord('s') shl 8 +ord('t'))shl 8 +ord('r'))shl 8 +ord('p')); {'strp'}       (* transport/proxy prefs root atom*)
  kQTSConnectionPrefsVersion  = (((ord('v') shl 8 +ord('e'))shl 8 +ord('r'))shl 8 +ord('s')); {'vers'}       (*   prefs format version*)
  kQTSTransportPrefsAtomType  = (((ord('t') shl 8 +ord('r'))shl 8 +ord('n'))shl 8 +ord('s')); {'trns'}       (*   tranport prefs root atom*)
  kQTSConnectionAtomType      = (((ord('c') shl 8 +ord('o'))shl 8 +ord('n'))shl 8 +ord('n')); {'conn'}       (*     connection prefs atom type, one for each transport type*)
  kQTSUDPTransportType        = (((ord('u') shl 8 +ord('d'))shl 8 +ord('p'))shl 8 +ord(' ')); {'udp '}       (*     udp transport prefs*)
  kQTSHTTPTransportType       = (((ord('h') shl 8 +ord('t'))shl 8 +ord('t'))shl 8 +ord('p')); {'http'}       (*     http transport prefs*)
  kQTSTCPTransportType        = (((ord('t') shl 8 +ord('c'))shl 8 +ord('p'))shl 8 +ord(' ')); {'tcp '}       (*     tcp transport prefs    *)
  kQTSProxyPrefsAtomType      = (((ord('p') shl 8 +ord('r'))shl 8 +ord('x'))shl 8 +ord('y')); {'prxy'}       (*   proxy prefs root atom*)
  kQTSHTTPProxyPrefsType      = (((ord('h') shl 8 +ord('t'))shl 8 +ord('t'))shl 8 +ord('p')); {'http'}       (*     http proxy settings*)
  kQTSRTSPProxyPrefsType      = (((ord('r') shl 8 +ord('t'))shl 8 +ord('s'))shl 8 +ord('p')); {'rtsp'}       (*     rtsp proxy settings*)
  kQTSSOCKSProxyPrefsType     = (((ord('s') shl 8 +ord('c'))shl 8 +ord('k'))shl 8 +ord('s')); {'scks'}       (*     socks proxy settings*)
  kQTSProxyUserInfoPrefsType  = (((ord('u') shl 8 +ord('s'))shl 8 +ord('e'))shl 8 +ord('r')); {'user'}       (*   proxy username/password root atom*)
  kQTSDontProxyPrefsAtomType  = (((ord('n') shl 8 +ord('o'))shl 8 +ord('p'))shl 8 +ord('r')); {'nopr'}       (*   no-proxy prefs root atom*)
  kQTSDontProxyDataType       = (((ord('d') shl 8 +ord('a'))shl 8 +ord('t'))shl 8 +ord('a')); {'data'}        (*     no proxy settings*)

 function QTSPrefsAddProxySetting(proxyType:OSType;portID:SInt32;flags:UInt32;seed:UInt32;srvrURL:Str255):OSErr; cdecl;
 function QTSPrefsFindProxyByType(proxyType:OSType;flags:UInt32;flagsMask:UInt32;var proxyHndl:QTSProxyPrefPtr;var count:SInt16):OSErr; cdecl;
 function QTSPrefsAddConnectionSetting(protocol:OSType;portID:SInt32;flags:UInt32;seed:UInt32):OSErr; cdecl;
 function QTSPrefsFindConnectionByType(protocol:OSType;flags:UInt32;flagsMask:UInt32;var connectionHndl:QTSTransportPrefPtr;var count:SInt16):OSErr; cdecl;
 function QTSPrefsGetActiveConnection(protocol:OSType;var connectInfo:QTSTransportPref):OSErr; cdecl;
 function QTSPrefsGetNoProxyURLs(var noProxyHndl:QTSNoProxyPrefPtr):OSErr; cdecl;
 function QTSPrefsSetNoProxyURLs(urls:pchar;flags:UInt32;seed:UInt32):OSErr; cdecl;
 function QTSPrefsAddProxyUserInfo(proxyType:OSType;flags:SInt32;flagsMask:SInt32;username:StringPtr;password:StringPtr):OSErr; cdecl;
 function QTSPrefsFindProxyUserInfoByType(proxyType:OSType;flags:SInt32;flagsMask:SInt32;username:StringPtr;password:StringPtr):OSErr; cdecl;


 (*============================================================================
         Memory Management Services
 ============================================================================*)
 (*
    These routines allocate normal pointers and handles,
    but do the correct checking, etc.
    Dispose using the normal DisposePtr and DisposeHandle
    Call these routines for one time memory allocations.
    You do not need to set any hints to use these calls.
 *)

 function QTSNewPtr(inByteCount:UInt32;inFlags:SInt32;var outFlags:SInt32):Ptr; cdecl;
 function QTSNewHandle(inByteCount:UInt32;inFlags:SInt32;var outFlags:SInt32):Handle; cdecl;

 //#define QTSNewPtrClear(_s)      QTSNewPtr((_s), kQTSMemAllocClearMem, NULL)
 //#define QTSNewHandleClear(_s)   QTSNewHandle((_s), kQTSMemAllocClearMem, NULL)

 (* flags in *)
 const
  kQTSMemAllocClearMem        = $00000001;
  kQTSMemAllocDontUseTempMem  = $00000002;
  kQTSMemAllocTryTempMemFirst = $00000004;
  kQTSMemAllocDontUseSystemMem = $00000008;
  kQTSMemAllocTrySystemMemFirst = $00000010;
  kQTSMemAllocHoldMemory      = $00001000;
  kQTSMemAllocIsInterruptTime = $01010000;  (* currently not supported for alloc *)

 (* flags out *)
 const
  kQTSMemAllocAllocatedInTempMem = $00000001;
  kQTSMemAllocAllocatedInSystemMem = $00000002;

 type
  OpaqueQTSMemPtr=record
   end;
  QTSMemPtr = ^OpaqueQTSMemPtr;

 (*
    These routines are for buffers that will be recirculated
    you must use QTReleaseMemPtr instead of DisposePtr
    QTSReleaseMemPtr can be used at interrupt time
    but QTSAllocMemPtr currently cannot
 *)
 function QTSAllocMemPtr(inByteCount:UInt32;inFlags:SInt32):QTSMemPtr; cdecl;
 procedure QTSReleaseMemPtr(inMemPtr:QTSMemPtr;inFlags:SInt32); cdecl;


 (*============================================================================
         Buffer Management Services
 ============================================================================*)

 const
  kQTSStreamBufferVersion1 = 1;


 type
  QTSStreamBufferPtr=^QTSStreamBuffer; //forward declaration
  QTSStreamBuffer=packed record
   reserved1:QTSStreamBufferPtr;
   reserved2:QTSStreamBufferPtr;
   next:QTSStreamBufferPtr;        (* next message block in a message *)
   rptr:unsigned_charPtr;          (* first byte with real data in the DataBuffer *)
   wptr:unsigned_charPtr;          (* last+1 byte with real data in the DataBuffer *)
   version:SInt32;
   metadata:array[0..3] of UInt32; (* usage defined by message sender *)
   flags:SInt32;                   (* reserved *)
   reserved3:long;
   reserved4:long;
   reserved5:long;

   moreMeta:array[0..7] of UInt32;
   end;

 (* flags for QTSDuplicateMessage *)
 const
  kQTSDuplicateBufferFlag_CopyData = $00000001;
  kQTSDuplicateBufferFlag_FlattenMessage = $00000002;


 function QTSNewStreamBuffer(inDataSize:UInt32;inFlags:SInt32;var outStreamBuffer:QTSStreamBufferPtr):OSErr; cdecl;
 procedure QTSFreeMessage(var inMessage:QTSStreamBuffer); cdecl;

 (*
     kQTSDuplicateBufferFlag_CopyData - forces a copy of the data itself
     kQTSCopyBufferFlag_FlattenMessage - copies the data if it needs to be flattened
     QTSDuplicateMessage never frees the old message
 *)
 function QTSDuplicateMessage(var inMessage:QTSStreamBuffer;inFlags:SInt32;var outDuplicatedMessage:QTSStreamBufferPtr):OSErr; cdecl;
 function QTSMessageLength(var inMessage:QTSStreamBuffer):UInt32; cdecl;
 procedure QTSStreamBufferDataInfo(var inStreamBuffer:QTSStreamBuffer;var outDataStart:unsigned_charPtr;var outDataMaxLength:UInt32); cdecl;

 (* ---- old calls (don't use these) *)

 function QTSAllocBuffer(inSize:SInt32):QTSStreamBufferPtr; cdecl;
 function QTSDupMessage(inMessage:QTSStreamBufferPtr):QTSStreamBufferPtr; cdecl;
 function QTSCopyMessage(inMessage:QTSStreamBufferPtr):QTSStreamBufferPtr; cdecl;
 function QTSFlattenMessage(inMessage:QTSStreamBufferPtr):QTSStreamBufferPtr; cdecl;


 (*============================================================================
         Misc
 ============================================================================*)
 function QTSGetErrorString(inErrorCode:SInt32;inMaxErrorStringLength:UInt32;outErrorString:pchar;inFlags:SInt32):Boolean; cdecl;
 function QTSInitializeMediaParams(var inMediaParams:QTSMediaParams):OSErr; cdecl;

 (* UPP call backs *)

(*

 {$ifdef OPAQUE_UPP_TYPES}
     EXTERN_API(QTSNotificationUPP)
     NewQTSNotificationUPP          (QTSNotificationProcPtr  userRoutine);

     EXTERN_API(QTSPanelFilterUPP)
     NewQTSPanelFilterUPP           (QTSPanelFilterProcPtr   userRoutine);

     EXTERN_API(QTSModalFilterUPP)
     NewQTSModalFilterUPP           (QTSModalFilterProcPtr   userRoutine);

     EXTERN_API(void)
     DisposeQTSNotificationUPP      (QTSNotificationUPP      userUPP);

     EXTERN_API(void)
     DisposeQTSPanelFilterUPP       (QTSPanelFilterUPP       userUPP);

     EXTERN_API(void)
     DisposeQTSModalFilterUPP       (QTSModalFilterUPP       userUPP);

     EXTERN_API(ComponentResult)
     InvokeQTSNotificationUPP       (ComponentResult         inErr,
                                     OSType                  inNotificationType,
                                     void *                  inNotificationParams,
                                     void *                  inRefCon,
                                     QTSNotificationUPP      userUPP);

     EXTERN_API(Boolean)
     InvokeQTSPanelFilterUPP        (QTSPanelFilterParams *  inParams,
                                     void *                  inRefCon,
                                     QTSPanelFilterUPP       userUPP);

     EXTERN_API(Boolean)
     InvokeQTSModalFilterUPP        (DialogPtr               inDialog,
                                     const EventRecord *     inEvent,
                                     SInt16 *                ioItemHit,
                                     void *                  inRefCon,
                                     QTSModalFilterUPP       userUPP);

 {$else}
     enum { uppQTSNotificationProcInfo = 0x00003FF0 };               /* pascal 4_bytes Func(4_bytes, 4_bytes, 4_bytes, 4_bytes) */
     enum { uppQTSPanelFilterProcInfo = 0x000003D0 };                /* pascal 1_byte Func(4_bytes, 4_bytes) */
     enum { uppQTSModalFilterProcInfo = 0x00003FD0 };                /* pascal 1_byte Func(4_bytes, 4_bytes, 4_bytes, 4_bytes) */
     #define NewQTSNotificationUPP(userRoutine)                      (QTSNotificationUPP)NewRoutineDescriptor((ProcPtr)(userRoutine), uppQTSNotificationProcInfo, GetCurrentArchitecture())
     #define NewQTSPanelFilterUPP(userRoutine)                       (QTSPanelFilterUPP)NewRoutineDescriptor((ProcPtr)(userRoutine), uppQTSPanelFilterProcInfo, GetCurrentArchitecture())
     #define NewQTSModalFilterUPP(userRoutine)                       (QTSModalFilterUPP)NewRoutineDescriptor((ProcPtr)(userRoutine), uppQTSModalFilterProcInfo, GetCurrentArchitecture())
     #define DisposeQTSNotificationUPP(userUPP)                      DisposeRoutineDescriptor(userUPP)
     #define DisposeQTSPanelFilterUPP(userUPP)                       DisposeRoutineDescriptor(userUPP)
     #define DisposeQTSModalFilterUPP(userUPP)                       DisposeRoutineDescriptor(userUPP)
     #define InvokeQTSNotificationUPP(inErr, inNotificationType, inNotificationParams, inRefCon, userUPP)  (ComponentResult)CALL_FOUR_PARAMETER_UPP((userUPP), uppQTSNotificationProcInfo, (inErr), (inNotificationType), (inNotificationParams), (inRefCon))
     #define InvokeQTSPanelFilterUPP(inParams, inRefCon, userUPP)    (Boolean)CALL_TWO_PARAMETER_UPP((userUPP), uppQTSPanelFilterProcInfo, (inParams), (inRefCon))
     #define InvokeQTSModalFilterUPP(inDialog, inEvent, ioItemHit, inRefCon, userUPP)  (Boolean)CALL_FOUR_PARAMETER_UPP((userUPP), uppQTSModalFilterProcInfo, (inDialog), (inEvent), (ioItemHit), (inRefCon))
 {$endif}

 *)

 (* support for pre-Carbon UPP routines: NewXXXProc and CallXXXProc *)

 (*

 #define NewQTSNotificationProc(userRoutine)                     NewQTSNotificationUPP(userRoutine)
 #define NewQTSPanelFilterProc(userRoutine)                      NewQTSPanelFilterUPP(userRoutine)
 #define NewQTSModalFilterProc(userRoutine)                      NewQTSModalFilterUPP(userRoutine)
 #define CallQTSNotificationProc(userRoutine, inErr, inNotificationType, inNotificationParams, inRefCon) InvokeQTSNotificationUPP(inErr, inNotificationType, inNotificationParams, inRefCon, userRoutine)
 #define CallQTSPanelFilterProc(userRoutine, inParams, inRefCon) InvokeQTSPanelFilterUPP(inParams, inRefCon, userRoutine)
 #define CallQTSModalFilterProc(userRoutine, inDialog, inEvent, ioItemHit, inRefCon) InvokeQTSModalFilterUPP(inDialog, inEvent, ioItemHit, inRefCon, userRoutine)

 *)

implementation

end.
