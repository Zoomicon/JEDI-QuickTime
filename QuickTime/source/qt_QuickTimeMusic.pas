{************************************************************************}
{                                                       	             }
{       Borland Delphi Runtime Library                  		       }
{       QuickTime interface unit                                         }
{ 									                   }
{ Portions created by Apple Computer, Inc. are 					 }
{ Copyright (C) 1997-1998 Apple Computer, Inc.. 			       }
{ All Rights Reserved. 							             }
{ 								                   	 }
{ The original file is: QuickTimeMusic.p, released dd Mmm yyyy. 		       }
{ The original Pascal code is: qt_QuickTimeMusic.pas, released 14 May 2000. 	 }
{ The initial developer of the Pascal code is Apple Computer, Inc.
{                       Ported to Delphi by Phil Taylor (aar09@pop.dial.pipex.com).  }
{ 									                   }
{ Portions created by Phil Taylor are    				       }
{ Copyright (C) 2000 Phil Taylor 					 }
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


{
 	File:		QuickTimeMusic.p

 	Contains:	QuickTime Interfaces.

 	Version:	Technology:	QuickTime 2.5
 				Release:	Universal Interfaces 3.0.1

 	Copyright:	© 1990-1997 by Apple Computer, Inc., all rights reserved

 	Bugs?:		Please include the the file and version information (from above) with
 				the problem description.  Developers belonging to one of the Apple
 				developer programs can submit bug reports to:

 					devsupport@apple.com
}

//original version: Translated to QT4Delphi from the Mac Pascal Universal interfaces by Phil Taylor
//13Apr2002: birbilis - new version


Unit qt_QuickTimeMusic;

interface
 Uses C_Types,
      qt_MacTypes,
      qt_Components,
      qt_ImageCompression,
      qt_Movies,
      qt_Quickdraw;
      {qt_Video, qt_Sound}

CONST
	kaiToneDescType				= 'tone';
	kaiNoteRequestInfoType		        = 'ntrq';
	kaiKnobListType				= 'knbl';
	kaiKeyRangeInfoType			= 'sinf';
	kaiSampleDescType			= 'sdsc';
	kaiSampleInfoType			= 'smin';
	kaiSampleDataType			= 'sdat';
	kaiInstInfoType				= 'iinf';
	kaiPictType				= 'pict';
	kaiWriterType				= '©wrt';
	kaiCopyrightType			= '©cpy';
	kaiOtherStrType				= 'str ';
	kaiInstrumentRefType		        = 'iref';
	kaiLibraryInfoType			= 'linf';
	kaiLibraryDescType			= 'ldsc';


TYPE
        {Some definitions which belong in headers which are not yet translated}
        ModalFilterUPP = UniversalProcPtr;              {Dialogs}
        LongintPtr = ^Longint;                          {Types}



	InstLibDescRecPtr = ^InstLibDescRec;
	InstLibDescRec = RECORD
		libIDName:				Str31;
	END;

	InstKnobRecPtr = ^InstKnobRec;
	InstKnobRec = RECORD
		number:					LONGINT;
		value:					LONGINT;
	END;


CONST
	kInstKnobMissingUnknown		= 0;
	kInstKnobMissingDefault		= $01;


TYPE
	InstKnobListPtr = ^InstKnobList;
	InstKnobList = RECORD
		knobCount:				LONGINT;
		knobFlags:				LONGINT;
		knob:					ARRAY [0..0] OF InstKnobRec;
	END;


CONST
	kMusicLoopTypeNormal		= 0;
	kMusicLoopTypePalindrome	= 1;							{  back & forth }

	instSamplePreProcessFlag	= $01;



TYPE
	InstSampleDescRecPtr = ^InstSampleDescRec;
	InstSampleDescRec = RECORD
		dataFormat:				OSType;
		numChannels:			short;
		sampleSize:				short;
		sampleRate:				UnsignedFixed;
		sampleDataID:			short;
		offset:					LONGINT;								{  offset within SampleData - this could be
just for internal use }
		numSamples:				LONGINT;								{  this could also just be for internal
use, we'll see }
		loopType:				LONGINT;
		loopStart:				LONGINT;
		loopEnd:				LONGINT;
		pitchNormal:			LONGINT;
		pitchLow:				LONGINT;
		pitchHigh:				LONGINT;
	END;

	AtomicInstrument					= Handle;
	AtomicInstrumentPtr					= Ptr;


CONST
	kMusicComponentType		= 'musi';

	kSoftSynthComponentSubType	= 'ss  ';
	kGMSynthComponentSubType	= 'gm  ';



TYPE
	MusicComponent						= ComponentInstance;
{  MusicSynthesizerFlags }

CONST
	kSynthesizerDynamicVoice	= $01;							{  can assign voices on the fly
(else, polyphony is very important  }
	kSynthesizerUsesMIDIPort	= $02;							{  must be patched through MIDI
Manager  }
	kSynthesizerMicrotone		= $04;							{  can play microtonal scales  }
	kSynthesizerHasSamples		= $08;							{  synthesizer has some use for
sampled data  }
	kSynthesizerMixedDrums		= $10;							{  any part can play drum parts,
total = instrument parts  }
	kSynthesizerSoftware		= $20;							{  implemented in main CPU software ==
uses cpu cycles  }
	kSynthesizerHardware		= $40;							{  is a hardware device (such as
nubus, or maybe DSP?)  }
	kSynthesizerDynamicChannel	= $80;							{  can move any part to any
channel or disable each part. (else we assume it lives on all channels in
masks)  }
	kSynthesizerHogsSystemChannel = $0100;						{  can be channelwise
dynamic, but always responds on its system channel  }
	kSynthesizerSlowSetPart		= $0400;						{  SetPart() and
SetPartInstrumentNumber() calls do not have rapid response, may glitch
notes  }
	kSynthesizerOffline		= $1000;						{  can enter an offline synthesis mode  }
	kSynthesizerGM			= $4000;						{  synth is a GM device  }
	kSynthesizerSoundLocalization = $00010000;					{  synth is a GM device  }

{
 * Note that these controller numbers
 * are _not_ identical to the MIDI controller numbers.
 * These are _signed_ 8.8 values, and the LSB's are
 * always sent to a MIDI device. Controllers 32-63 are
 * reserved (for MIDI, they are LSB's for 0-31, but we
 * always send both).
 *
 * The full range, therefore, is -128.00 to 127.7f.
 *
 * _Excepting_ _volume_, all controls default to zero.
 *
 * Pitch bend is specified in fractional semitones! No
 * more "pitch bend range" nonsense. You can bend as far
 * as you want, any time you want.
 }

TYPE
	MusicController						= SInt32;

CONST
	kControllerModulationWheel	= 1;
	kControllerBreath			= 2;
	kControllerFoot				= 4;
	kControllerPortamentoTime	= 5;							{  portamento on/off is omitted, 0
time = 'off'  }
	kControllerVolume			= 7;
	kControllerBalance			= 8;
	kControllerPan				= 10;							{  0 - "default", 1 - n: positioned in
output 1-n (incl fractions)  }
	kControllerExpression		= 11;
	kControllerLever1			= 16;							{  general purpose controllers  }
	kControllerLever2			= 17;							{  general purpose controllers  }
	kControllerLever3			= 18;							{  general purpose controllers  }
	kControllerLever4			= 19;							{  general purpose controllers  }
	kControllerLever5			= 80;							{  general purpose controllers  }
	kControllerLever6			= 81;							{  general purpose controllers  }
	kControllerLever7			= 82;							{  general purpose controllers  }
	kControllerLever8			= 83;							{  general purpose controllers  }
	kControllerPitchBend		= 32;							{  positive & negative semitones, with
7 bits fraction  }
	kControllerAfterTouch		= 33;							{  aka channel pressure  }
	kControllerSustain			= 64;							{  boolean - positive for on, 0 or
negative off  }
	kControllerSostenuto		= 66;							{  boolean  }
	kControllerSoftPedal		= 67;							{  boolean  }
	kControllerReverb			= 91;
	kControllerTremolo			= 92;
	kControllerChorus			= 93;
	kControllerCeleste			= 94;
	kControllerPhaser			= 95;
	kControllerEditPart			= 113;							{  last 16 controllers 113-128 and
above are global controllers which respond on part zero  }
	kControllerMasterTune		= 114;

	kControllerMaximum			= $7FFF;						{  +01111111.11111111  }
	kControllerMinimum			= $8000;						{  -10000000.00000000  }


TYPE
	SynthesizerDescriptionPtr = ^SynthesizerDescription;
	SynthesizerDescription = RECORD
		synthesizerType:		OSType;									{  synthesizer type (must be same as
component subtype)  }
		name:				Str31;									{  text name of synthesizer type  }
		flags:				LONGINT;								{  from the above enum  }
		voiceCount:			LONGINT;								{  maximum polyphony  }
		partCount:			LONGINT;								{  maximum multi-timbrality (and midi
channels)  }
		instrumentCount:		LONGINT;								{  non gm, built in (rom) instruments
only  }
		modifiableInstrumentCount:      LONGINT;								{  plus n-more are user
modifiable  }
		channelMask:			LONGINT;								{  (midi device only) which channels
device always uses  }
		drumPartCount:			LONGINT;								{  maximum multi-timbrality of drum parts  }
		drumCount:			LONGINT;								{  non gm, built in (rom) drumkits only  }
		modifiableDrumCount:	        LONGINT;								{  plus n-more are user
modifiable  }
		drumChannelMask:		LONGINT;								{  (midi device only) which channels
device always uses  }
		outputCount:			LONGINT;								{  number of audio outputs (usually two)  }
		latency:			LONGINT;								{  response time in µSec  }
		controllers:			ARRAY [0..3] OF LONGINT;				{  array of 128 bits  }
		gmInstruments:			ARRAY [0..3] OF LONGINT;				{  array of 128 bits  }
		gmDrums:			ARRAY [0..3] OF LONGINT;				{  array of 128 bits  }
	END;


CONST
	kVoiceCountDynamic			= -1;							{  constant to use to specify dynamic
voicing  }



TYPE
	ToneDescriptionPtr = ^ToneDescription;
	ToneDescription = RECORD
		synthesizerType:		OSType;									{  synthesizer type  }
		synthesizerName:		Str31;									{  name of instantiation of synth  }
		instrumentName:			Str31;									{  preferred name for human use  }
		instrumentNumber:		LONGINT;								{  inst-number used if synth-name
matches  }
		gmNumber:			LONGINT;								{  Best matching general MIDI number  }
	END;


CONST
	kFirstDrumkit				= 16384;						{  (first value is "no drum". instrument
numbers from 16384->16384+128 are drumkits, and for GM they are _defined_
drumkits!  }
	kLastDrumkit				= 16512;

{  InstrumentMatch }
	kInstrumentMatchSynthesizerType = 1;
	kInstrumentMatchSynthesizerName = 2;
	kInstrumentMatchName		= 4;
	kInstrumentMatchNumber		= 8;
	kInstrumentMatchGMNumber	= 16;

{  KnobFlags }
	kKnobReadOnly			= 16;							{  knob value cannot be changed by user or
with a SetKnob call  }
	kKnobInterruptUnsafe		= 32;							{  only alter this knob from foreground
task time (may access toolbox)  }
	kKnobKeyrangeOverride		= 64;							{  knob can be overridden within a
single keyrange (software synth only)  }
	kKnobGroupStart			= 128;							{  knob is first in some logical group of
knobs  }
	kKnobFixedPoint8		= 1024;
	kKnobFixedPoint16		= 2048;							{  One of these may be used at a time.  }
	kKnobTypeNumber			= $00;
	kKnobTypeGroupName		= $1000;						{  "knob" is really a group name for
display purposes  }
	kKnobTypeBoolean		= $2000;						{  if range is greater than 1, its a
multi-checkbox field  }
	kKnobTypeNote			= $3000;						{  knob range is equivalent to MIDI keys  }
	kKnobTypePan			= $4000;						{  range goes left/right (lose this? )  }
	kKnobTypeInstrument		= $5000;						{  knob value = reference to another
instrument number  }
	kKnobTypeSetting	        = $6000;						{  knob value is 1 of n different
things (eg, fm algorithms) popup menu  }
	kKnobTypeMilliseconds		= $7000;						{  knob is a millisecond time range  }
	kKnobTypePercentage		= $8000;						{  knob range is displayed as a
Percentage  }
	kKnobTypeHertz			= $9000;						{  knob represents frequency  }
	kKnobTypeButton			= $A000;						{  momentary trigger push button  }


	kUnknownKnobValue			= $7FFFFFFF;					{  a knob with this value means, we
don't know it.  }
	kDefaultKnobValue			= $7FFFFFFE;					{  used to SET a knob to its default
value.  }


TYPE
	KnobDescriptionPtr = ^KnobDescription;
	KnobDescription = RECORD
		name:					Str63;
		lowValue:				LONGINT;
		highValue:				LONGINT;
		defaultValue:			        LONGINT;								{  a default instrument is made
of all default values  }
		flags:					LONGINT;
		knobID:					LONGINT;
	END;

	GCInstrumentDataPtr = ^GCInstrumentData;
	GCInstrumentData = RECORD
		tone:					ToneDescription;
		knobCount:				LONGINT;
		knob:					ARRAY [0..0] OF LONGINT;
	END;

	GCInstrumentDataHandle				= ^GCInstrumentDataPtr;
	InstrumentAboutInfoPtr = ^InstrumentAboutInfo;
	InstrumentAboutInfo = RECORD
		p:					PicHandle;
		author:					Str255;
		copyright:				Str255;
		other:					Str255;
	END;


CONST
	kMusicPacketPortLost		= 1;							{  received when application loses the
default input port  }
	kMusicPacketPortFound		= 2;							{  received when application gets it
back out from under someone else's claim  }
	kMusicPacketTimeGap		= 3;							{  data[0] = number of milliseconds to
keep the MIDI line silent  }


TYPE
	MusicMIDIPacketPtr = ^MusicMIDIPacket;
	MusicMIDIPacket = RECORD
		length:					short;
		reserved:				LONGINT;								{  if length zero, then reserved = above enum  }
		data:					PACKED ARRAY [0..248] OF UInt8;
	END;

	MusicMIDISendProcPtr = ProcPtr;  { FUNCTION MusicMIDISend(self:
MusicComponent; refCon: LONGINT; VAR mmp: MusicMIDIPacket):
ComponentResult; }

	MusicMIDISendUPP = UniversalProcPtr;
	MusicMIDIReadHookProcPtr = ProcPtr;  { FUNCTION MusicMIDIReadHook(VAR mp:
MusicMIDIPacket; myRefCon: LONGINT): ComponentResult; }

	MusicMIDIReadHookUPP = UniversalProcPtr;



CONST
	notImplementedMusicErr		= $8000F7E9;
	cantSendToSynthesizerErr	= $8000F7E8;
	cantReceiveFromSynthesizerErr   = $8000F7E7;
	illegalVoiceAllocationErr	= $8000F7E6;
	illegalPartErr			= $8000F7E5;
	illegalChannelErr		= $8000F7E4;
	illegalKnobErr			= $8000F7E3;
	illegalKnobValueErr		= $8000F7E2;
	illegalInstrumentErr		= $8000F7E1;
	illegalControllerErr		= $8000F7E0;
	midiManagerAbsentErr		= $8000F7DF;
	synthesizerNotRespondingErr	= $8000F7DE;
	synthesizerErr			= $8000F7DD;
	illegalNoteChannelErr		= $8000F7DC;
	noteChannelNotAllocatedErr	= $8000F7DB;
	tunePlayerFullErr		= $8000F7DA;
	tuneParseErr			= $8000F7D9;

	kGetAtomicInstNoExpandedSamples = $01;
	kGetAtomicInstNoOriginalSamples = $02;
	kGetAtomicInstNoSamples		= $03;
	kGetAtomicInstNoKnobList	= $04;
	kGetAtomicInstNoInstrumentInfo = $08;
	kGetAtomicInstOriginalKnobList = $10;
	kGetAtomicInstAllKnobs		= $20;							{  return even those that are set to
default }

{
   For non-gm instruments, instrument number of tone description == 0
   If you want to speed up while running, slam the inst num with what Get
instrument number returns
   All missing knobs are slammed to the default value
}
	kSetAtomicInstKeepOriginalInstrument = $01;
	kSetAtomicInstShareAcrossParts = $02;						{  inst disappears when app
goes away }
	kSetAtomicInstCallerTosses	= $04;							{  the caller isn't keeping a
copy around (for NASetAtomicInstrument) }
	kSetAtomicInstCallerGuarantees = $08;						{  the caller guarantees a
copy is around }
	kSetAtomicInstInterruptSafe	= $10;							{  dont move memory at this time
(but process at next task time) }
	kSetAtomicInstDontPreprocess = $80;							{  perform no further
preprocessing because either 1)you know the instrument is digitally clean,
or 2) you got it from a GetPartAtomic }

	kInstrumentNamesModifiable	= 1;
	kInstrumentNamesBoth		= 2;

{
 * Structures specific to the GenericMusicComponent
 }

	kGenericMusicComponentSubtype = 'gene';


TYPE
	GenericKnobDescriptionPtr = ^GenericKnobDescription;
	GenericKnobDescription = RECORD
		kd:						KnobDescription;
		hw1:					LONGINT;								{  driver defined  }
		hw2:					LONGINT;								{  driver defined  }
		hw3:					LONGINT;								{  driver defined  }
		settingsID:				LONGINT;								{  resource ID list for boolean and popup
names  }
	END;

	GenericKnobDescriptionListPtr = ^GenericKnobDescriptionList;
	GenericKnobDescriptionList = RECORD
		knobCount:				LONGINT;
		knob:					ARRAY [0..0] OF GenericKnobDescription;
	END;

	GenericKnobDescriptionListHandle	= ^GenericKnobDescriptionListPtr;
{ knobTypes for MusicDerivedSetKnob }

CONST
	kGenericMusicKnob			= 1;
	kGenericMusicInstrumentKnob	= 2;
	kGenericMusicDrumKnob		= 3;
	kGenericMusicGlobalController = 4;



	kGenericMusicResFirst		= 0;
	kGenericMusicResMiscStringList = 1;							{  STR# 1: synth name, 2:about
author,3:aboutcopyright,4:aboutother  }
	kGenericMusicResMiscLongList = 2;							{  Long various params, see list
below  }
	kGenericMusicResInstrumentList = 3;							{  NmLs of names and shorts,
categories prefixed by '**'  }
	kGenericMusicResDrumList	= 4;							{  NmLs of names and shorts  }
	kGenericMusicResInstrumentKnobDescriptionList = 5;			{  Knob  }
	kGenericMusicResDrumKnobDescriptionList = 6;				{  Knob  }
	kGenericMusicResKnobDescriptionList = 7;					{  Knob  }
	kGenericMusicResBitsLongList = 8;							{  Long back to back bitmaps of
controllers, gminstruments, and drums  }
	kGenericMusicResModifiableInstrumentHW = 9;					{  Shrt same as the hw
shorts trailing the instrument names, a shortlist  }
	kGenericMusicResGMTranslation = 10;							{  Long 128 long entries, 1 for
each gm inst, of local instrument numbers 1-n (not hw numbers)  }
	kGenericMusicResROMInstrumentData = 11;						{  knob lists for ROM
instruments, so the knob values may be known  }
	kGenericMusicResAboutPICT	= 12;							{  picture for aboutlist. must be
present for GetAbout call to work  }
	kGenericMusicResLast		= 13;

{ elements of the misc long list }
	kGenericMusicMiscLongFirst	= 0;
	kGenericMusicMiscLongVoiceCount = 1;
	kGenericMusicMiscLongPartCount = 2;
	kGenericMusicMiscLongModifiableInstrumentCount = 3;
	kGenericMusicMiscLongChannelMask = 4;
	kGenericMusicMiscLongDrumPartCount = 5;
	kGenericMusicMiscLongModifiableDrumCount = 6;
	kGenericMusicMiscLongDrumChannelMask = 7;
	kGenericMusicMiscLongOutputCount = 8;
	kGenericMusicMiscLongLatency = 9;
	kGenericMusicMiscLongFlags	= 10;
	kGenericMusicMiscLongFirstGMHW = 11;						{  number to add to locate GM
main instruments  }
	kGenericMusicMiscLongFirstGMDrumHW = 12;					{  number to add to locate
GM drumkits  }
	kGenericMusicMiscLongFirstUserHW = 13;						{  First hw number of user
instruments (presumed sequential)  }
	kGenericMusicMiscLongLast	= 14;


TYPE
	GCPartPtr = ^GCPart;
	GCPart = RECORD
		hwInstrumentNumber:		LONGINT;								{  internal number of recalled
instrument  }
		controller:				ARRAY [0..127] OF short;				{  current values for all
controllers  }
		volume:					LONGINT;								{  ctrl 7 is special case  }
		polyphony:				LONGINT;
		midiChannel:			LONGINT;								{  1-16 if in use  }
		id:						GCInstrumentData;						{  ToneDescription & knoblist, uncertain
length  }
	END;

{
 * Calls specific to the GenericMusicComponent
 }

CONST
	kMusicGenericRange			= $0100;
	kMusicDerivedRange			= $0200;

{
 * Flags in GenericMusicConfigure call
 }
	kGenericMusicDoMIDI			= $01;							{  implement normal MIDI messages for
note, controllers, and program changes 0-127  }
	kGenericMusicBank0			= $02;							{  implement instrument bank changes on
controller 0  }
	kGenericMusicBank32			= $04;							{  implement instrument bank changes
on controller 32  }
	kGenericMusicErsatzMIDI		= $08;							{  construct MIDI packets, but send
them to the derived component  }
	kGenericMusicCallKnobs		= $10;							{  call the derived component with
special knob format call  }
	kGenericMusicCallParts		= $20;							{  call the derived component with
special part format call  }
	kGenericMusicCallInstrument	= $40;							{  call
MusicDerivedSetInstrument for MusicSetInstrument calls  }
	kGenericMusicCallNumber		= $80;							{  call
MusicDerivedSetPartInstrumentNumber for MusicSetPartInstrumentNumber calls,
& don't send any C0 or bank stuff  }
	kGenericMusicCallROMInstrument = $0100;						{  call MusicSetInstrument
for MusicSetPartInstrumentNumber for "ROM" instruments, passing params from
the ROMi resource  }
	kGenericMusicAllDefaults	= $0200;						{  indicates that when a new
instrument is recalled, all knobs are reset to DEFAULT settings. True for
GS modules  }






TYPE
	MusicOfflineDataProcPtr = ProcPtr;  { FUNCTION
MusicOfflineData(SoundData: Ptr; numBytes: LONGINT; myRefCon: LONGINT):
ComponentResult; }

	MusicOfflineDataUPP = UniversalProcPtr;
	OfflineSampleTypePtr = ^OfflineSampleType;
	OfflineSampleType = RECORD
		numChannels:			LONGINT;								{ number of channels,  ie mono = 1 }
		sampleRate:				UnsignedFixed;							{ sample rate in Apples Fixed point
representation }
		sampleSize:				short;								{ number of bits in sample }
	END;

	InstrumentInfoRecordPtr = ^InstrumentInfoRecord;
	InstrumentInfoRecord = RECORD
		instrumentNumber:		LONGINT;								{  instrument number (if 0, name is a
catagory) }
		flags:					LONGINT;								{  show in picker, etc. }
		toneNameIndex:			LONGINT;								{  index in toneNames (1 based) }
		itxtNameAtomID:			LONGINT;								{  index in itxtNames (itxt/name by
index) }
	END;

	InstrumentInfoListPtr = ^InstrumentInfoList;
	InstrumentInfoList = RECORD
		recordCount:			LONGINT;
		toneNames:				Handle;									{  name from tone description }
		itxtNames:				QTAtomContainer;						{  itxt/name atoms for instruments }
		info:					ARRAY [0..0] OF InstrumentInfoRecord;
	END;

	InstrumentInfoListHandle			= ^InstrumentInfoListPtr;

FUNCTION MusicGetDescription(mc: MusicComponent; VAR sd:
SynthesizerDescription): ComponentResult; cdecl;

FUNCTION MusicGetPart(mc: MusicComponent; part: LONGINT; VAR midiChannel:
LONGINT; VAR polyphony: LONGINT): ComponentResult; cdecl;

FUNCTION MusicSetPart(mc: MusicComponent; part: LONGINT; midiChannel:
LONGINT; polyphony: LONGINT): ComponentResult; cdecl;

FUNCTION MusicSetPartInstrumentNumber(mc: MusicComponent; part: LONGINT; instrumentNumber: LONGINT): ComponentResult; cdecl;

FUNCTION MusicGetPartInstrumentNumber(mc: MusicComponent; part: LONGINT):
ComponentResult; cdecl;

FUNCTION MusicStorePartInstrument(mc: MusicComponent; part: LONGINT;
instrumentNumber: LONGINT): ComponentResult; cdecl;

FUNCTION MusicGetPartAtomicInstrument(mc: MusicComponent; part: LONGINT;
VAR ai: AtomicInstrument; flags: LONGINT): ComponentResult; cdecl;

FUNCTION MusicSetPartAtomicInstrument(mc: MusicComponent; part: LONGINT;
aiP: AtomicInstrumentPtr; flags: LONGINT): ComponentResult; cdecl;

{  Obsolete calls }
FUNCTION MusicGetInstrumentKnobDescriptionObsolete(mc: MusicComponent;
knobIndex: LONGINT; mkd:  Ptr): ComponentResult; cdecl;

FUNCTION MusicGetDrumKnobDescriptionObsolete(mc: MusicComponent;
knobIndex: LONGINT; mkd:  Ptr): ComponentResult; cdecl;

FUNCTION MusicGetKnobDescriptionObsolete(mc: MusicComponent; knobIndex:
LONGINT; mkd:  Ptr): ComponentResult; cdecl;

FUNCTION MusicGetPartKnob(mc: MusicComponent; part: LONGINT; knobID:
LONGINT): ComponentResult; cdecl;

FUNCTION MusicSetPartKnob(mc: MusicComponent; part: LONGINT; knobID:
LONGINT; knobValue: LONGINT): ComponentResult; cdecl;

FUNCTION MusicGetKnob(mc: MusicComponent; knobID: LONGINT):
ComponentResult; cdecl;

FUNCTION MusicSetKnob(mc: MusicComponent; knobID: LONGINT; knobValue:
LONGINT): ComponentResult; cdecl;

FUNCTION MusicGetPartName(mc: MusicComponent; part: LONGINT; name:
StringPtr): ComponentResult; cdecl;

FUNCTION MusicSetPartName(mc: MusicComponent; part: LONGINT; name:
StringPtr): ComponentResult; cdecl;

FUNCTION MusicFindTone(mc: MusicComponent; VAR td: ToneDescription; VAR
instrumentNumber: LONGINT; VAR fit: LONGINT): ComponentResult; cdecl;

FUNCTION MusicPlayNote(mc: MusicComponent; part: LONGINT; pitch: LONGINT;
velocity: LONGINT): ComponentResult; cdecl;

FUNCTION MusicResetPart(mc: MusicComponent; part: LONGINT):
ComponentResult; cdecl;

FUNCTION MusicSetPartController(mc: MusicComponent; part: LONGINT;
controllerNumber: MusicController; controllerValue: LONGINT):
ComponentResult; cdecl;

FUNCTION MusicGetPartController(mc: MusicComponent; part: LONGINT;
controllerNumber: MusicController): ComponentResult; cdecl;

FUNCTION MusicGetMIDIProc(mc: MusicComponent; VAR midiSendProc:
MusicMIDISendUPP; VAR refCon: LONGINT): ComponentResult; cdecl;

FUNCTION MusicSetMIDIProc(mc: MusicComponent; midiSendProc:
MusicMIDISendUPP; refCon: LONGINT): ComponentResult; cdecl;

FUNCTION MusicGetInstrumentNames(mc: MusicComponent;
modifiableInstruments: LONGINT; VAR instrumentNames: Handle; VAR
instrumentCategoryLasts: Handle; VAR instrumentCategoryNames: Handle):
ComponentResult; cdecl;

FUNCTION MusicGetDrumNames(mc: MusicComponent; modifiableInstruments:
LONGINT; VAR instrumentNumbers: Handle; VAR instrumentNames: Handle):
ComponentResult; cdecl;

FUNCTION MusicGetMasterTune(mc: MusicComponent): ComponentResult; cdecl;

FUNCTION MusicSetMasterTune(mc: MusicComponent; masterTune: LONGINT):
ComponentResult; cdecl;

FUNCTION MusicGetInstrumentAboutInfo(mc: MusicComponent; part: LONGINT;
VAR iai: InstrumentAboutInfo): ComponentResult; cdecl;

FUNCTION MusicGetDeviceConnection(mc: MusicComponent; index: LONGINT; VAR
id1: LONGINT; VAR id2: LONGINT): ComponentResult; cdecl;

FUNCTION MusicUseDeviceConnection(mc: MusicComponent; id1: LONGINT; id2:
LONGINT): ComponentResult; cdecl;

FUNCTION MusicGetKnobSettingStrings(mc: MusicComponent; knobIndex:
LONGINT; isGlobal: LONGINT; VAR settingsNames: Handle; VAR
settingsCategoryLasts: Handle; VAR settingsCategoryNames: Handle):
ComponentResult; cdecl;

FUNCTION MusicGetMIDIPorts(mc: MusicComponent; VAR inputPortCount:
LONGINT; VAR outputPortCount: LONGINT): ComponentResult; cdecl;

FUNCTION MusicSendMIDI(mc: MusicComponent; portIndex: LONGINT; VAR mp:
MusicMIDIPacket): ComponentResult; cdecl;

FUNCTION MusicReceiveMIDI(mc: MusicComponent; readHook:
MusicMIDIReadHookUPP; refCon: LONGINT): ComponentResult; cdecl;

FUNCTION MusicStartOffline(mc: MusicComponent; VAR numChannels: LONGINT;
VAR sampleRate: UnsignedFixed; VAR sampleSize: short; dataProc:
MusicOfflineDataUPP; dataProcRefCon: LONGINT): ComponentResult; cdecl;

FUNCTION MusicSetOfflineTimeTo(mc: MusicComponent; newTimeStamp: LONGINT):
ComponentResult; cdecl;

FUNCTION MusicGetInstrumentKnobDescription(mc: MusicComponent; knobIndex:
LONGINT; VAR mkd: KnobDescription): ComponentResult; cdecl;

FUNCTION MusicGetDrumKnobDescription(mc: MusicComponent; knobIndex:
LONGINT; VAR mkd: KnobDescription): ComponentResult; cdecl;

FUNCTION MusicGetKnobDescription(mc: MusicComponent; knobIndex: LONGINT;
VAR mkd: KnobDescription): ComponentResult; cdecl;

FUNCTION MusicGetInfoText(mc: MusicComponent; selector: LONGINT; VAR
textH: Handle; VAR styleH: Handle): ComponentResult; cdecl;


CONST
	kGetInstrumentInfoNoBuiltIn	= $01;
	kGetInstrumentInfoMidiUserInst = $02;
	kGetInstrumentInfoNoIText	= $04;

FUNCTION MusicGetInstrumentInfo(mc: MusicComponent;
getInstrumentInfoFlags: LONGINT; VAR infoListH: InstrumentInfoListHandle):
ComponentResult; cdecl;



FUNCTION MusicTask(mc: MusicComponent): ComponentResult; cdecl;

FUNCTION MusicSetPartInstrumentNumberInterruptSafe(mc: MusicComponent;
part: LONGINT; instrumentNumber: LONGINT): ComponentResult; cdecl;

FUNCTION MusicSetPartSoundLocalization(mc: MusicComponent; part: LONGINT;
data: Handle): ComponentResult; cdecl;



FUNCTION MusicGenericConfigure(mc: MusicComponent; mode: LONGINT; flags:
LONGINT; baseResID: LONGINT): ComponentResult; cdecl;

FUNCTION MusicGenericGetPart(mc: MusicComponent; partNumber: LONGINT; VAR
part: GCPartPtr): ComponentResult; cdecl;

FUNCTION MusicGenericGetKnobList(mc: MusicComponent; knobType: LONGINT;
VAR gkdlH: GenericKnobDescriptionListHandle): ComponentResult; cdecl;

FUNCTION MusicDerivedMIDISend(mc: MusicComponent; VAR packet:
MusicMIDIPacket): ComponentResult; cdecl;

FUNCTION MusicDerivedSetKnob(mc: MusicComponent; knobType: LONGINT;
knobNumber: LONGINT; knobValue: LONGINT; partNumber: LONGINT; VAR p:
GCPart; VAR gkd: GenericKnobDescription): ComponentResult; cdecl;

FUNCTION MusicDerivedSetPart(mc: MusicComponent; partNumber: LONGINT; VAR
p: GCPart): ComponentResult; cdecl;

FUNCTION MusicDerivedSetInstrument(mc: MusicComponent; partNumber:
LONGINT; VAR p: GCPart): ComponentResult; cdecl;

FUNCTION MusicDerivedSetPartInstrumentNumber(mc: MusicComponent;
partNumber: LONGINT; VAR p: GCPart): ComponentResult; cdecl;

FUNCTION MusicDerivedSetMIDI(mc: MusicComponent; midiProc:
MusicMIDISendProcPtr; refcon: LONGINT; midiChannel: LONGINT):
ComponentResult; cdecl;

FUNCTION MusicDerivedStorePartInstrument(mc: MusicComponent; partNumber:
LONGINT; VAR p: GCPart; instrumentNumber: LONGINT): ComponentResult; cdecl;




{  Mask bit for returned value by InstrumentFind. }

CONST
	kInstrumentExactMatch		= $00020000;
	kInstrumentRecommendedSubstitute = $00010000;
	kInstrumentQualityField		= $FF000000;
	kInstrumentRoland8BitQuality = $05000000;


TYPE
	InstrumentAboutInfoHandle			= ^InstrumentAboutInfoPtr;
	GMInstrumentInfoPtr = ^GMInstrumentInfo;
	GMInstrumentInfo = RECORD
		cmpInstID:				LONGINT;
		gmInstNum:				LONGINT;
		instMatch:				LONGINT;
	END;

	GMInstrumentInfoHandle				= ^GMInstrumentInfoPtr;
	nonGMInstrumentInfoRecordPtr = ^nonGMInstrumentInfoRecord;
	nonGMInstrumentInfoRecord = RECORD
		cmpInstID:				LONGINT;								{  if 0, category name }
		flags:					LONGINT;								{  match, show in picker }
		toneNameIndex:			LONGINT;								{  index in toneNames (1 based) }
		itxtNameAtomID:			LONGINT;								{  index in itxtNames (itxt/name by
index) }
	END;

	nonGMInstrumentInfoPtr = ^nonGMInstrumentInfo;
	nonGMInstrumentInfo = RECORD
		recordCount:			LONGINT;
		toneNames:				Handle;									{  name from tone description }
		itxtNames:				QTAtomContainer;						{  itext/name atoms for instruments }
		instInfo:				ARRAY [0..0] OF nonGMInstrumentInfoRecord;
	END;

	nonGMInstrumentInfoHandle			= ^nonGMInstrumentInfoPtr;
	InstCompInfoPtr = ^InstCompInfo;
	InstCompInfo = RECORD
		infoSize:				LONGINT;								{  size of this record }
		InstrumentLibraryName:	Str31;
		InstrumentLibraryITxt:	QTAtomContainer;						{  itext/name atoms for
instruments }
		GMinstrumentCount:		LONGINT;
		GMinstrumentInfo:		GMInstrumentInfoHandle;
		GMdrumCount:			LONGINT;
		GMdrumInfo:				GMInstrumentInfoHandle;
		nonGMinstrumentCount:	LONGINT;
		nonGMinstrumentInfo:	nonGMInstrumentInfoHandle;
	END;

	InstCompInfoHandle					= ^InstCompInfoPtr;
FUNCTION InstrumentGetInst(ci: ComponentInstance; instID: LONGINT; VAR
atomicInst: AtomicInstrument; flags: LONGINT): ComponentResult; cdecl;

FUNCTION InstrumentGetInfo(ci: ComponentInstance; getInstrumentInfoFlags:
LONGINT; VAR instInfo: InstCompInfoHandle): ComponentResult; cdecl;

FUNCTION InstrumentInitialize(ci: ComponentInstance; initFormat: LONGINT;
initParams:  Ptr): ComponentResult; cdecl;

FUNCTION InstrumentOpenComponentResFile(ci: ComponentInstance; VAR
resFile: short): ComponentResult; cdecl;

FUNCTION InstrumentCloseComponentResFile(ci: ComponentInstance; resFile:
short): ComponentResult; cdecl;

FUNCTION InstrumentGetComponentRefCon(ci: ComponentInstance; VAR refCon:
Ptr): ComponentResult; cdecl;

FUNCTION InstrumentSetComponentRefCon(ci: ComponentInstance; refCon:
Ptr): ComponentResult; cdecl;



{--------------------------
	Types
--------------------------}


CONST
	kSynthesizerConnectionMono	= 1;							{  if set, and synth can be
mono/poly, then the partCount channels from the system channel are hogged
}
	kSynthesizerConnectionMMgr	= 2;							{  this connection imported from
the MIDI Mgr  }
	kSynthesizerConnectionOMS	= 4;							{  this connection imported from OMS  }
	kSynthesizerConnectionQT	= 8;							{  this connection is a
QuickTime-only port  }
	kSynthesizerConnectionFMS	= 16;							{  this connection imported from FMS  }

{ used for MIDI device only }

TYPE
	SynthesizerConnectionsPtr = ^SynthesizerConnections;
	SynthesizerConnections = RECORD
		clientID:				OSType;
		inputPortID:			OSType;									{  terminology death: this port is used
to SEND to the midi synth  }
		outputPortID:			OSType;									{  terminology death: this port receives
from a keyboard or other control device  }
		midiChannel:			LONGINT;								{  The system channel; others are
configurable (or the nubus slot number)  }
		flags:					LONGINT;
		unique:					LONGINT;								{  unique id may be used instead of index,
to getinfo and unregister calls  }
		reserved1:				LONGINT;								{  should be zero  }
		reserved2:				LONGINT;								{  should be zero  }
	END;

	QTMIDIPortPtr = ^QTMIDIPort;
	QTMIDIPort = RECORD
		portConnections:		SynthesizerConnections;
		portName:				Str63;
	END;


CONST
	kNoteRequestNoGM			= 1;							{  dont degrade to a GM synth  }
	kNoteRequestNoSynthType		= 2;							{  dont degrade to another synth of
same type but different name  }
	kNoteRequestSynthMustMatch	= 4;							{  synthType must be a match,
including kGMSynthComponentSubType  }


TYPE
	NoteAllocator						= ComponentInstance;
	NoteRequestInfoPtr = ^NoteRequestInfo;
	NoteRequestInfo = RECORD
		flags:					SInt8;									{  1: dont accept GM match, 2: dont accept
same-synth-type match  }
		reserved:				SInt8;									{  must be zero  }
		polyphony:				short;								{  Maximum number of voices  }
		typicalPolyphony:		Fixed;									{  Hint for level mixing  }
	END;

	NoteRequestPtr = ^NoteRequest;
	NoteRequest = RECORD
		info:					NoteRequestInfo;
		tone:					ToneDescription;
	END;

	NoteChannel = ^LONGINT;



CONST
	kPickDontMix				= 1;							{  dont mix instruments with drum sounds  }
	kPickSameSynth				= 2;							{  only allow the same device that went in,
to come out  }
	kPickUserInsts				= 4;							{  show user insts in addition to ROM voices  }
	kPickEditAllowEdit			= 8;							{  lets user switch over to edit mode  }
	kPickEditAllowPick			= 16;							{  lets the user switch over to pick mode  }
	kPickEditSynthGlobal		= 32;							{  edit the global knobs of the synth  }
	kPickEditControllers		= 64;							{  edit the controllers of the notechannel  }


	{kNoteAllocatorComponentType = $6E6F7461; 'nota'}
        kNoteAllocatorComponentType=(((ord('n') shl 8 + ord('o')) shl 8 +
ord('t')) shl 8 + ord('a'));


{--------------------------------
	Note Allocator Prototypes
--------------------------------}
FUNCTION NARegisterMusicDevice(ci: NoteAllocator; synthType: OSType; VAR
name: Str31; VAR connections: SynthesizerConnections): ComponentResult;
cdecl;

FUNCTION NAUnregisterMusicDevice(ci: NoteAllocator; index: LONGINT):
ComponentResult; cdecl;

FUNCTION NAGetRegisteredMusicDevice(ci: NoteAllocator; index: LONGINT; VAR
synthType: OSType; VAR name: Str31; VAR connections:
SynthesizerConnections; VAR mc: MusicComponent): ComponentResult; cdecl;

FUNCTION NASaveMusicConfiguration(ci: NoteAllocator): ComponentResult; cdecl;

FUNCTION NANewNoteChannel(ci: NoteAllocator; VAR noteRequest: NoteRequest;
VAR outChannel: NoteChannel): ComponentResult; cdecl;

FUNCTION NADisposeNoteChannel(ci: NoteAllocator; noteChannel:
NoteChannel): ComponentResult; cdecl;

FUNCTION NAGetNoteChannelInfo(ci: NoteAllocator; noteChannel: NoteChannel;
VAR index: LONGINT; VAR part: LONGINT): ComponentResult; cdecl;

FUNCTION NAPrerollNoteChannel(ci: NoteAllocator; noteChannel:
NoteChannel): ComponentResult; cdecl;

FUNCTION NAUnrollNoteChannel(ci: NoteAllocator; noteChannel: NoteChannel):
ComponentResult; cdecl;

FUNCTION NASetNoteChannelVolume(ci: NoteAllocator; noteChannel:
NoteChannel; volume: Fixed): ComponentResult; cdecl;

FUNCTION NAResetNoteChannel(ci: NoteAllocator; noteChannel: NoteChannel):
ComponentResult; cdecl;

FUNCTION NAPlayNote(ci: NoteAllocator; noteChannel: NoteChannel; pitch:
LONGINT; velocity: LONGINT): ComponentResult; cdecl;

FUNCTION NASetController(ci: NoteAllocator; noteChannel: NoteChannel;
controllerNumber: LONGINT; controllerValue: LONGINT): ComponentResult;
cdecl;

FUNCTION NASetKnob(ci: NoteAllocator; noteChannel: NoteChannel;
knobNumber: LONGINT; knobValue: LONGINT): ComponentResult; cdecl;

FUNCTION NAFindNoteChannelTone(ci: NoteAllocator; noteChannel:
NoteChannel; VAR td: ToneDescription; VAR instrumentNumber: LONGINT):
ComponentResult; cdecl;

FUNCTION NASetInstrumentNumber(ci: NoteAllocator; noteChannel:
NoteChannel; instrumentNumber: LONGINT): ComponentResult; cdecl;

FUNCTION NAPickInstrument(ci: NoteAllocator; filterProc: ModalFilterUPP;
prompt: StringPtr; VAR sd: ToneDescription; flags: LONGINT; refCon:
LONGINT; reserved1: LONGINT; reserved2: LONGINT): ComponentResult; cdecl;

FUNCTION NAPickArrangement(ci: NoteAllocator; filterProc: ModalFilterUPP;
prompt: StringPtr; zero1: LONGINT; zero2: LONGINT; t: Track; songName:
StringPtr): ComponentResult; cdecl;

FUNCTION NASetDefaultMIDIInput(ci: NoteAllocator; VAR sc:
SynthesizerConnections): ComponentResult; cdecl;

FUNCTION NAGetDefaultMIDIInput(ci: NoteAllocator; VAR sc:
SynthesizerConnections): ComponentResult; cdecl;

FUNCTION NAUseDefaultMIDIInput(ci: NoteAllocator; readHook:
MusicMIDIReadHookUPP; refCon: LONGINT; flags: LONGINT): ComponentResult;
cdecl;

FUNCTION NALoseDefaultMIDIInput(ci: NoteAllocator): ComponentResult; cdecl;

FUNCTION NAStuffToneDescription(ci: NoteAllocator; gmNumber: LONGINT; VAR
td: ToneDescription): ComponentResult; cdecl;

FUNCTION NACopyrightDialog(ci: NoteAllocator; p: PicHandle; author:
StringPtr; copyright: StringPtr; other: StringPtr; title: StringPtr;
filterProc: ModalFilterUPP; refCon: LONGINT): ComponentResult; cdecl;

{
  	kNADummyOneSelect = 29
  	kNADummyTwoSelect = 30
}

FUNCTION NAGetIndNoteChannel(ci: NoteAllocator; index: LONGINT; VAR nc:
NoteChannel; VAR seed: LONGINT): ComponentResult; cdecl;

FUNCTION NAGetMIDIPorts(ci: NoteAllocator; VAR inputPorts: Handle; VAR
outputPorts: Handle): ComponentResult; cdecl;

FUNCTION NAGetNoteRequest(ci: NoteAllocator; noteChannel: NoteChannel; VAR
nrOut: NoteRequest): ComponentResult; cdecl;

FUNCTION NASendMIDI(ci: NoteAllocator; noteChannel: NoteChannel; VAR mp:
MusicMIDIPacket): ComponentResult; cdecl;

FUNCTION NAPickEditInstrument(ci: NoteAllocator; filterProc:
ModalFilterUPP; prompt: StringPtr; refCon: LONGINT; nc: NoteChannel; ai:
AtomicInstrument; flags: LONGINT): ComponentResult; cdecl;

FUNCTION NANewNoteChannelFromAtomicInstrument(ci: NoteAllocator;
instrument: AtomicInstrumentPtr; flags: LONGINT; VAR outChannel:
NoteChannel): ComponentResult; cdecl;

FUNCTION NASetAtomicInstrument(ci: NoteAllocator; noteChannel:
NoteChannel; instrument: AtomicInstrumentPtr; flags: LONGINT):
ComponentResult; cdecl;

FUNCTION NAGetKnob(ci: NoteAllocator; noteChannel: NoteChannel;
knobNumber: LONGINT; VAR knobValue: LONGINT): ComponentResult; cdecl;

FUNCTION NATask(ci: NoteAllocator): ComponentResult; cdecl;

FUNCTION NASetNoteChannelBalance(ci: NoteAllocator; noteChannel:
NoteChannel; balance: LONGINT): ComponentResult; cdecl;

FUNCTION NASetInstrumentNumberInterruptSafe(ci: NoteAllocator;
noteChannel: NoteChannel; instrumentNumber: LONGINT): ComponentResult;
cdecl;

FUNCTION NASetNoteChannelSoundLocalization(ci: NoteAllocator; noteChannel:
NoteChannel; data: Handle): ComponentResult; cdecl;





CONST
	kTuneQueueDepth				= 8;							{  Deepest you can queue tune segments  }



TYPE
	TuneStatusPtr = ^TuneStatus;
	TuneStatus = RECORD
		tune:					LongIntPtr;								{  currently playing tune  }
		tunePtr:				LongIntPtr;								{  position within currently playing piece  }
		time:					TimeValue;								{  current tune time  }
		queueCount:				short;								{  how many pieces queued up?  }
		queueSpots:				short;								{  How many more tunepieces can be queued  }
		queueTime:				TimeValue;								{  How much time is queued up? (can be
very inaccurate)  }
		reserved:				ARRAY [0..2] OF LONGINT;
	END;

	TuneCallBackProcPtr = ProcPtr;  { PROCEDURE TuneCallBack((CONST)VAR
status: TuneStatus; refCon: LONGINT); }

	TunePlayCallBackProcPtr = ProcPtr;  { PROCEDURE TunePlayCallBack(VAR
event: LONGINT; seed: LONGINT; refCon: LONGINT); }

	TuneCallBackUPP = UniversalProcPtr;
	TunePlayCallBackUPP = UniversalProcPtr;
	TunePlayer							= ComponentInstance;

CONST
	kTunePlayerType				= 'tune';


FUNCTION TuneSetHeader(tp: TunePlayer; VAR header: LONGINT):
ComponentResult; cdecl;

FUNCTION TuneGetTimeBase(tp: TunePlayer; VAR tb: TimeBase):
ComponentResult; cdecl;

FUNCTION TuneSetTimeScale(tp: TunePlayer; scale: TimeScale):
ComponentResult; cdecl;

FUNCTION TuneGetTimeScale(tp: TunePlayer; VAR scale: TimeScale):
ComponentResult; cdecl;

FUNCTION TuneGetIndexedNoteChannel(tp: TunePlayer; i: LONGINT; VAR nc:
NoteChannel): ComponentResult; cdecl;


{ Values for when to start. }

CONST
	kTuneStartNow				= 1;							{  start after buffer is implied  }
	kTuneDontClipNotes			= 2;							{  allow notes to finish their durations
outside sample  }
	kTuneExcludeEdgeNotes		= 4;							{  dont play notes that start at end of
tune  }
	kTuneQuickStart				= 8;							{  Leave all the controllers where they
are, ignore start time  }
	kTuneLoopUntil				= 16;							{  loop a queued tune if there's nothing
else in the queue  }
	kTuneStartNewMaster			= 16384;

FUNCTION TuneQueue(tp: TunePlayer; VAR tune: LONGINT; tuneRate: Fixed;
tuneStartPosition: LONGINT; tuneStopPosition: LONGINT; queueFlags: LONGINT;
callBackProc: TuneCallBackUPP; refCon: LONGINT): ComponentResult; cdecl;

FUNCTION TuneInstant(tp: TunePlayer; tune:  Ptr; tunePosition: LONGINT):
ComponentResult; cdecl;

FUNCTION TuneGetStatus(tp: TunePlayer; VAR status: TuneStatus):
ComponentResult; cdecl;

{ Values for stopping. }

CONST
	kTuneStopFade				= 1;							{  do a quick, synchronous fadeout  }
	kTuneStopSustain			= 2;							{  don't silece notes  }
	kTuneStopInstant			= 4;							{  silence notes fast (else, decay them)  }
	kTuneStopReleaseChannels	= 8;							{  afterwards, let the channels go  }

FUNCTION TuneStop(tp: TunePlayer; stopFlags: LONGINT): ComponentResult; cdecl;

FUNCTION TuneSetVolume(tp: TunePlayer; volume: Fixed): ComponentResult; cdecl;

FUNCTION TuneGetVolume(tp: TunePlayer): ComponentResult; cdecl;

FUNCTION TunePreroll(tp: TunePlayer): ComponentResult; cdecl;

FUNCTION TuneUnroll(tp: TunePlayer): ComponentResult; cdecl;

FUNCTION TuneSetNoteChannels(tp: TunePlayer; count: LONGINT; VAR
noteChannelList: NoteChannel; playCallBackProc: TunePlayCallBackUPP;
refCon: LONGINT): ComponentResult; cdecl;

FUNCTION TuneSetPartTranspose(tp: TunePlayer; part: LONGINT; transpose:
LONGINT; velocityShift: LONGINT): ComponentResult; cdecl;

FUNCTION TuneGetNoteAllocator(tp: TunePlayer): NoteAllocator; cdecl;

FUNCTION TuneSetSofter(tp: TunePlayer; softer: LONGINT): ComponentResult;
cdecl;

FUNCTION TuneTask(tp: TunePlayer): ComponentResult; cdecl;

FUNCTION TuneSetBalance(tp: TunePlayer; balance: LONGINT):
ComponentResult; cdecl;

FUNCTION TuneSetSoundLocalization(tp: TunePlayer; data: Handle):
ComponentResult; cdecl;

FUNCTION TuneSetHeaderWithSize(tp: TunePlayer; VAR header: LONGINT; size:
LONGINT): ComponentResult; cdecl;



TYPE
	MusicOpWord							= LONGINT;
	MusicOpWordPtr						= ^LONGINT;
{ 	QuickTime Music Track Event Formats:

	At this time, QuickTime music tracks support 5 different event types --
REST events,
	short NOTE events, short CONTROL events, short GENERAL events, Long NOTE
events,
	long CONTROL events, and variable GENERAL events.

		* REST Event (4 bytes/event):
	
			(0 0 0) (5-bit UNUSED) (24-bit Rest Duration)
		
		* Short NOTE Events (4 bytes/event):
	
			(0 0 1) (5-bit Part) (6-bit Pitch) (7-bit Volume) (11-bit Duration)
		
			where:	Pitch is offset by 32 (Actual pitch = pitch field + 32)

		* Short CONTROL Events (4 bytes/event):
	
			(0 1 0) (5-bit Part) (8-bit Controller) (1-bit UNUSED) (1-bit Sign)
(7-bit MSB) (7-bit LSB)
																		 ( or 15-bit Signed Value)
		* Short GENERAL Event (4 bytes/event):
	
			(0 1 1) (1-bit UNUSED) (12-bit Sub-Type) (16-bit Value)
	
		* Long NOTE Events (8 bytes/event):
	
			(1 0 0 1) (12-bit Part) (1-bit UNUSED) (7-bit Pitch) (1-bit UNUSED)
(7-bit Volume)
			(1 0) (8-bit UNUSED) (22-bit Duration)
		
		* Long CONTROL Event (8 bytes/event):
		
			(1 0 1 0) (12-bit Part) (16-bit Value MSB)
			(1 0) (14-bit Controller) (16-bit Value LSB)
	
		* Long KNOB Event (8 bytes/event):
	
			(1 0 1 1) (12-bit Sub-Type) (16-bit Value MSB)
			(1 0) (14-bit KNOB) (16-bit Value LSB)
	
		* Variable GENERAL Length Events (N bytes/event):
	
			(1 1 1 1) (12-bit Sub-Type) (16-bit Length)
				:
			(32-bit Data values)
				:
			(1 1) (14-bit UNUSED) (16-bit Length)
	
			where:	Length field is the number of LONG words in the record.
					Lengths include the first and last long words (Minimum length = 2)
				
	The following event type values have not been used yet and are reserved for
	future expansion:
		
		* (1 0 0 0)		(8 bytes/event)
		* (1 1 0 0)		(N bytes/event)
		* (1 1 0 1)		(N bytes/event)
		* (1 1 1 0)		(N bytes/event)
		
	For all events, the following generalizations apply:
	
		-	All duration values are specified in Millisecond units.
		- 	Pitch values are intended to map directly to the MIDI key numbers.
		-	Controllers from 0 to 127 correspond to the standard MIDI controllers.
			Controllers greater than 127 correspond to other controls (i.e., Pitch
Bend,
			Key Pressure, and Channel Pressure).	
}

{  Defines for the implemented music event data fields }

CONST
	kRestEventType				= $00000000;					{  lower 3-bits  }
	kNoteEventType				= $00000001;					{  lower 3-bits  }
	kControlEventType			= $00000002;					{  lower 3-bits  }
	kMarkerEventType			= $00000003;					{  lower 3-bits  }
	kUndefined1EventType		= $00000008;					{  4-bits  }
	kXNoteEventType				= $00000009;					{  4-bits  }
	kXControlEventType			= $0000000A;					{  4-bits  }
	kKnobEventType				= $0000000B;					{  4-bits  }
	kUndefined2EventType		= $0000000C;					{  4-bits  }
	kUndefined3EventType		= $0000000D;					{  4-bits  }
	kUndefined4EventType		= $0000000E;					{  4-bits  }
	kGeneralEventType			= $0000000F;					{  4-bits  }
	kXEventLengthBits			= $00000002;					{  2 bits: indicates 8-byte event
record  }
	kGeneralEventLengthBits		= $00000003;					{  2 bits: indicates variable length event record  }
	kEventLen					= 1;							{  length of events in long words  }
	kXEventLen					= 2;
	kRestEventLen				= 1;							{  length of events in long words  }
	kNoteEventLen				= 1;
	kControlEventLen			= 1;
	kMarkerEventLen				= 1;
	kXNoteEventLen				= 2;
	kXControlEventLen			= 2;
	kGeneralEventLen			= 2;							{  2 or more, however  }
																{  ersal Event Defines }
	kEventLengthFieldPos		= 30;							{  by looking at these two bits of the
1st or last word 			  }
	kEventLengthFieldWidth		= 2;							{  of an event you can determine the
event length 					  }
																{  length field: 0 & 1 => 1 long; 2 => 2 longs; 3 =>
variable length  }
	kEventTypeFieldPos			= 29;							{  event type field for short events  }
	kEventTypeFieldWidth		= 3;							{  short type is 3 bits  }
	kXEventTypeFieldPos			= 28;							{  event type field for extended events  }
	kXEventTypeFieldWidth		= 4;							{  extended type is 4 bits  }
	kEventPartFieldPos			= 24;
	kEventPartFieldWidth		= 5;
	kXEventPartFieldPos			= 16;							{  in the 1st long word  }
	kXEventPartFieldWidth		= 12;							{  Rest Events }
	kRestEventDurationFieldPos	= 0;
	kRestEventDurationFieldWidth = 24;
	kRestEventDurationMax		= $00FFFFFF;					{  Note Events }
	kNoteEventPitchFieldPos		= 18;
	kNoteEventPitchFieldWidth	= 6;
	kNoteEventPitchOffset		= 32;							{  add to value in pitch field to get
actual pitch  }
	kNoteEventVolumeFieldPos	= 11;
	kNoteEventVolumeFieldWidth	= 7;
	kNoteEventVolumeOffset		= 0;							{  add to value in volume field to get
actual volume  }
	kNoteEventDurationFieldPos	= 0;
	kNoteEventDurationFieldWidth = 11;
	kNoteEventDurationMax		= $000007FF;
	kXNoteEventPitchFieldPos	= 0;							{  in the 1st long word  }
	kXNoteEventPitchFieldWidth	= 16;
	kXNoteEventDurationFieldPos	= 0;							{  in the 2nd long word  }
	kXNoteEventDurationFieldWidth = 22;
	kXNoteEventDurationMax		= $003FFFFF;
	kXNoteEventVolumeFieldPos	= 22;							{  in the 2nd long word  }
	kXNoteEventVolumeFieldWidth	= 7;							{  Control Events }
	kControlEventControllerFieldPos = 16;
	kControlEventControllerFieldWidth = 8;
	kControlEventValueFieldPos	= 0;
	kControlEventValueFieldWidth = 16;
	kXControlEventControllerFieldPos = 0;						{  in the 2nd long word  }
	kXControlEventControllerFieldWidth = 16;
	kXControlEventValueFieldPos	= 0;							{  in the 1st long word  }
	kXControlEventValueFieldWidth = 16;							{  Knob Events }
	kKnobEventValueHighFieldPos	= 0;							{  1st long word  }
	kKnobEventValueHighFieldWidth = 16;
	kKnobEventKnobFieldPos		= 16;							{  2nd long word  }
	kKnobEventKnobFieldWidth	= 14;
	kKnobEventValueLowFieldPos	= 0;							{  2nd long word  }
	kKnobEventValueLowFieldWidth = 16;							{  Marker Events }
	kMarkerEventSubtypeFieldPos	= 16;
	kMarkerEventSubtypeFieldWidth = 8;
	kMarkerEventValueFieldPos	= 0;
	kMarkerEventValueFieldWidth	= 16;							{  General Events }
	kGeneralEventSubtypeFieldPos = 16;							{  in the last long word  }
	kGeneralEventSubtypeFieldWidth = 14;
	kGeneralEventLengthFieldPos	= 0;							{  in the 1st & last long words  }
	kGeneralEventLengthFieldWidth = 16;



{  General Event Defined Types }
	kGeneralEventNoteRequest	= 1;							{  Encapsulates NoteRequest data
structure  }
	kGeneralEventPartKey		= 4;
	kGeneralEventTuneDifference	= 5;							{  Contains a standard sequence,
with end marker, for the tune difference of a sequence piece (halts
QuickTime 2.0 Music)  }
	kGeneralEventAtomicInstrument = 6;							{  Encapsulates AtomicInstrument
record  }
	kGeneralEventKnob			= 7;							{  knobID/knobValue pairs; smallest event
is 4 longs  }
	kGeneralEventMIDIChannel	= 8;							{  used in tune header, one longword
identifies the midi channel it originally came from  }
	kGeneralEventPartChange		= 9;							{  used in tune sequence, one
longword identifies the tune part which can now take over this part's note
channel (similar to program change) (halts QuickTime 2.0 Music) }
	kGeneralEventNoOp			= 10;							{  guaranteed to do nothing and be ignored. (halts QuickTime 2.0 Music)  }
	kGeneralEventUsedNotes		= 11;							{  four longwords specifying which
midi notes are actually used, 0..127 msb to lsb  }

{  Marker Event Defined Types		// marker is 60 ee vv vv in hex, where e =
event type, and v = value }
	kMarkerEventEnd				= 0;							{  marker type 0 means: value 0 - stop,
value != 0 - ignore }
	kMarkerEventBeat			= 1;							{  value 0 = single beat; anything else is
65536ths-of-a-beat (quarter note) }
	kMarkerEventTempo			= 2;							{  value same as beat marker, but
indicates that a tempo event should be computed (based on where the next
beat or tempo marker is) and emitted upon export }



{ UPP call backs }
	uppMusicMIDISendProcInfo = $00000FF0;
	uppMusicMIDIReadHookProcInfo = $000003F0;
	uppMusicOfflineDataProcInfo = $00000FF0;
	uppTuneCallBackProcInfo = $000003C0;
	uppTunePlayCallBackProcInfo = $00000FC0;

FUNCTION NewMusicMIDISendProc(userRoutine: MusicMIDISendProcPtr):
MusicMIDISendUPP; cdecl;


FUNCTION NewMusicMIDIReadHookProc(userRoutine: MusicMIDIReadHookProcPtr):
MusicMIDIReadHookUPP; cdecl;


FUNCTION NewMusicOfflineDataProc(userRoutine: MusicOfflineDataProcPtr):
MusicOfflineDataUPP; cdecl;


FUNCTION NewTuneCallBackProc(userRoutine: TuneCallBackProcPtr):
TuneCallBackUPP; cdecl;


FUNCTION NewTunePlayCallBackProc(userRoutine: TunePlayCallBackProcPtr):
TunePlayCallBackUPP; cdecl;


FUNCTION CallMusicMIDISendProc(self: MusicComponent; refCon: LONGINT; VAR
mmp: MusicMIDIPacket; userRoutine: MusicMIDISendUPP): ComponentResult;
cdecl;


FUNCTION CallMusicMIDIReadHookProc(VAR mp: MusicMIDIPacket; myRefCon:
LONGINT; userRoutine: MusicMIDIReadHookUPP): ComponentResult; cdecl;


FUNCTION CallMusicOfflineDataProc(SoundData: Ptr; numBytes: LONGINT;
myRefCon: LONGINT; userRoutine: MusicOfflineDataUPP): ComponentResult;
cdecl;


PROCEDURE CallTuneCallBackProc({CONST}VAR status: TuneStatus; refCon:
LONGINT; userRoutine: TuneCallBackUPP); cdecl;


PROCEDURE CallTunePlayCallBackProc(VAR event: LONGINT; seed: LONGINT;
refCon: LONGINT; userRoutine: TunePlayCallBackUPP); cdecl;


IMPLEMENTATION

FUNCTION MusicGetDescription(mc: MusicComponent; VAR sd:
SynthesizerDescription): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicGetPart(mc: MusicComponent; part: LONGINT; VAR midiChannel:
LONGINT; VAR polyphony: LONGINT): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicSetPart(mc: MusicComponent; part: LONGINT; midiChannel:
LONGINT; polyphony: LONGINT): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicSetPartInstrumentNumber(mc: MusicComponent; part: LONGINT;
instrumentNumber: LONGINT): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicGetPartInstrumentNumber(mc: MusicComponent; part: LONGINT):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicStorePartInstrument(mc: MusicComponent; part: LONGINT;
instrumentNumber: LONGINT): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicGetPartAtomicInstrument(mc: MusicComponent; part: LONGINT;
VAR ai: AtomicInstrument; flags: LONGINT): ComponentResult; cdecl;
external 'qtmlClient.dll';

FUNCTION MusicSetPartAtomicInstrument(mc: MusicComponent; part: LONGINT;
aiP: AtomicInstrumentPtr; flags: LONGINT): ComponentResult; cdecl;
external 'qtmlClient.dll';

FUNCTION MusicGetInstrumentKnobDescriptionObsolete(mc: MusicComponent;
knobIndex: LONGINT; mkd:  Ptr): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicGetDrumKnobDescriptionObsolete(mc: MusicComponent;
knobIndex: LONGINT; mkd:  Ptr): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicGetKnobDescriptionObsolete(mc: MusicComponent; knobIndex:
LONGINT; mkd:  Ptr): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicGetPartKnob(mc: MusicComponent; part: LONGINT; knobID:
LONGINT): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicSetPartKnob(mc: MusicComponent; part: LONGINT; knobID:
LONGINT; knobValue: LONGINT): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicGetKnob(mc: MusicComponent; knobID: LONGINT):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicSetKnob(mc: MusicComponent; knobID: LONGINT; knobValue:
LONGINT): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicGetPartName(mc: MusicComponent; part: LONGINT; name:
StringPtr): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicSetPartName(mc: MusicComponent; part: LONGINT; name:
StringPtr): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicFindTone(mc: MusicComponent; VAR td: ToneDescription; VAR
instrumentNumber: LONGINT; VAR fit: LONGINT): ComponentResult; cdecl;
external 'qtmlClient.dll';

FUNCTION MusicPlayNote(mc: MusicComponent; part: LONGINT; pitch: LONGINT;
velocity: LONGINT): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicResetPart(mc: MusicComponent; part: LONGINT):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicSetPartController(mc: MusicComponent; part: LONGINT;
controllerNumber: MusicController; controllerValue: LONGINT):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicGetPartController(mc: MusicComponent; part: LONGINT;
controllerNumber: MusicController): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicGetMIDIProc(mc: MusicComponent; VAR midiSendProc:
MusicMIDISendUPP; VAR refCon: LONGINT): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicSetMIDIProc(mc: MusicComponent; midiSendProc:
MusicMIDISendUPP; refCon: LONGINT): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicGetInstrumentNames(mc: MusicComponent;
modifiableInstruments: LONGINT; VAR instrumentNames: Handle; VAR
instrumentCategoryLasts: Handle; VAR instrumentCategoryNames: Handle):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicGetDrumNames(mc: MusicComponent; modifiableInstruments:
LONGINT; VAR instrumentNumbers: Handle; VAR instrumentNames: Handle):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicGetMasterTune(mc: MusicComponent): ComponentResult; cdecl;
external 'qtmlClient.dll';

FUNCTION MusicSetMasterTune(mc: MusicComponent; masterTune: LONGINT):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicGetInstrumentAboutInfo(mc: MusicComponent; part: LONGINT;
VAR iai: InstrumentAboutInfo): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicGetDeviceConnection(mc: MusicComponent; index: LONGINT; VAR
id1: LONGINT; VAR id2: LONGINT): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicUseDeviceConnection(mc: MusicComponent; id1: LONGINT; id2:
LONGINT): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicGetKnobSettingStrings(mc: MusicComponent; knobIndex:
LONGINT; isGlobal: LONGINT; VAR settingsNames: Handle; VAR
settingsCategoryLasts: Handle; VAR settingsCategoryNames: Handle):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicGetMIDIPorts(mc: MusicComponent; VAR inputPortCount:
LONGINT; VAR outputPortCount: LONGINT): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicSendMIDI(mc: MusicComponent; portIndex: LONGINT; VAR mp:
MusicMIDIPacket): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicReceiveMIDI(mc: MusicComponent; readHook:
MusicMIDIReadHookUPP; refCon: LONGINT): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicStartOffline(mc: MusicComponent; VAR numChannels: LONGINT;
VAR sampleRate: UnsignedFixed; VAR sampleSize: short; dataProc:
MusicOfflineDataUPP; dataProcRefCon: LONGINT): ComponentResult; cdecl;
external 'qtmlClient.dll';

FUNCTION MusicSetOfflineTimeTo(mc: MusicComponent; newTimeStamp: LONGINT):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicGetInstrumentKnobDescription(mc: MusicComponent; knobIndex:
LONGINT; VAR mkd: KnobDescription): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicGetDrumKnobDescription(mc: MusicComponent; knobIndex:
LONGINT; VAR mkd: KnobDescription): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicGetKnobDescription(mc: MusicComponent; knobIndex: LONGINT;
VAR mkd: KnobDescription): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicGetInfoText(mc: MusicComponent; selector: LONGINT; VAR
textH: Handle; VAR styleH: Handle): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicGetInstrumentInfo(mc: MusicComponent;
getInstrumentInfoFlags: LONGINT; VAR infoListH: InstrumentInfoListHandle):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicTask(mc: MusicComponent): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicSetPartInstrumentNumberInterruptSafe(mc: MusicComponent;
part: LONGINT; instrumentNumber: LONGINT): ComponentResult; cdecl;
external 'qtmlClient.dll';

FUNCTION MusicSetPartSoundLocalization(mc: MusicComponent; part: LONGINT;
data: Handle): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicGenericConfigure(mc: MusicComponent; mode: LONGINT; flags:
LONGINT; baseResID: LONGINT): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicGenericGetPart(mc: MusicComponent; partNumber: LONGINT; VAR
part: GCPartPtr): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicGenericGetKnobList(mc: MusicComponent; knobType: LONGINT;
VAR gkdlH: GenericKnobDescriptionListHandle): ComponentResult; cdecl;
external 'qtmlClient.dll';

FUNCTION MusicDerivedMIDISend(mc: MusicComponent; VAR packet:
MusicMIDIPacket): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicDerivedSetKnob(mc: MusicComponent; knobType: LONGINT;
knobNumber: LONGINT; knobValue: LONGINT; partNumber: LONGINT; VAR p:
GCPart; VAR gkd: GenericKnobDescription): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicDerivedSetPart(mc: MusicComponent; partNumber: LONGINT; VAR
p: GCPart): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicDerivedSetInstrument(mc: MusicComponent; partNumber:
LONGINT; VAR p: GCPart): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicDerivedSetPartInstrumentNumber(mc: MusicComponent;
partNumber: LONGINT; VAR p: GCPart): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION MusicDerivedSetMIDI(mc: MusicComponent; midiProc:
MusicMIDISendProcPtr; refcon: LONGINT; midiChannel: LONGINT):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION MusicDerivedStorePartInstrument(mc: MusicComponent; partNumber:
LONGINT; VAR p: GCPart; instrumentNumber: LONGINT): ComponentResult; cdecl;
external 'qtmlClient.dll';

FUNCTION InstrumentGetInst(ci: ComponentInstance; instID: LONGINT; VAR
atomicInst: AtomicInstrument; flags: LONGINT): ComponentResult; cdecl;
external 'qtmlClient.dll';

FUNCTION InstrumentGetInfo(ci: ComponentInstance; getInstrumentInfoFlags:
LONGINT; VAR instInfo: InstCompInfoHandle): ComponentResult; cdecl;
external 'qtmlClient.dll';

FUNCTION InstrumentInitialize(ci: ComponentInstance; initFormat: LONGINT;
initParams:  Ptr): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION InstrumentOpenComponentResFile(ci: ComponentInstance; VAR
resFile: short): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION InstrumentCloseComponentResFile(ci: ComponentInstance; resFile:
short): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION InstrumentGetComponentRefCon(ci: ComponentInstance; VAR refCon:
Ptr): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION InstrumentSetComponentRefCon(ci: ComponentInstance; refCon:
Ptr): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION NARegisterMusicDevice(ci: NoteAllocator; synthType: OSType; VAR
name: Str31; VAR connections: SynthesizerConnections): ComponentResult;
cdecl;  external 'qtmlClient.dll';

FUNCTION NAUnregisterMusicDevice(ci: NoteAllocator; index: LONGINT):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION NAGetRegisteredMusicDevice(ci: NoteAllocator; index: LONGINT; VAR
synthType: OSType; VAR name: Str31; VAR connections: SynthesizerConnections;
VAR mc: MusicComponent): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION NASaveMusicConfiguration(ci: NoteAllocator): ComponentResult;
cdecl;  external 'qtmlClient.dll';

FUNCTION NANewNoteChannel(ci: NoteAllocator; VAR noteRequest: NoteRequest;
VAR outChannel: NoteChannel): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION NADisposeNoteChannel(ci: NoteAllocator; noteChannel:
NoteChannel): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION NAGetNoteChannelInfo(ci: NoteAllocator; noteChannel: NoteChannel;
VAR index: LONGINT; VAR part: LONGINT): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION NAPrerollNoteChannel(ci: NoteAllocator; noteChannel:
NoteChannel): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION NAUnrollNoteChannel(ci: NoteAllocator; noteChannel: NoteChannel):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION NASetNoteChannelVolume(ci: NoteAllocator; noteChannel:
NoteChannel; volume: Fixed): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION NAResetNoteChannel(ci: NoteAllocator; noteChannel: NoteChannel):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION NAPlayNote(ci: NoteAllocator; noteChannel: NoteChannel; pitch:
LONGINT; velocity: LONGINT): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION NASetController(ci: NoteAllocator; noteChannel: NoteChannel;
controllerNumber: LONGINT; controllerValue: LONGINT): ComponentResult;
cdecl;  external 'qtmlClient.dll';

FUNCTION NASetKnob(ci: NoteAllocator; noteChannel: NoteChannel;
knobNumber: LONGINT; knobValue: LONGINT): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION NAFindNoteChannelTone(ci: NoteAllocator; noteChannel:
NoteChannel; VAR td: ToneDescription; VAR instrumentNumber: LONGINT):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION NASetInstrumentNumber(ci: NoteAllocator; noteChannel:
NoteChannel; instrumentNumber: LONGINT): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION NAPickInstrument(ci: NoteAllocator; filterProc: ModalFilterUPP;
prompt: StringPtr; VAR sd: ToneDescription; flags: LONGINT; refCon:
LONGINT; reserved1: LONGINT; reserved2: LONGINT): ComponentResult; cdecl;
external 'qtmlClient.dll';

FUNCTION NAPickArrangement(ci: NoteAllocator; filterProc: ModalFilterUPP;
prompt: StringPtr; zero1: LONGINT; zero2: LONGINT; t: Track; songName:
StringPtr): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION NASetDefaultMIDIInput(ci: NoteAllocator; VAR sc:
SynthesizerConnections): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION NAGetDefaultMIDIInput(ci: NoteAllocator; VAR sc:
SynthesizerConnections): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION NAUseDefaultMIDIInput(ci: NoteAllocator; readHook:
MusicMIDIReadHookUPP; refCon: LONGINT; flags: LONGINT): ComponentResult;
cdecl;  external 'qtmlClient.dll';

FUNCTION NALoseDefaultMIDIInput(ci: NoteAllocator): ComponentResult;
cdecl;  external 'qtmlClient.dll';

FUNCTION NAStuffToneDescription(ci: NoteAllocator; gmNumber: LONGINT; VAR
td: ToneDescription): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION NACopyrightDialog(ci: NoteAllocator; p: PicHandle; author:
StringPtr; copyright: StringPtr; other: StringPtr; title: StringPtr;
filterProc: ModalFilterUPP; refCon: LONGINT): ComponentResult; cdecl;
external 'qtmlClient.dll';

FUNCTION NAGetIndNoteChannel(ci: NoteAllocator; index: LONGINT; VAR nc:
NoteChannel; VAR seed: LONGINT): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION NAGetMIDIPorts(ci: NoteAllocator; VAR inputPorts: Handle; VAR
outputPorts: Handle): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION NAGetNoteRequest(ci: NoteAllocator; noteChannel: NoteChannel; VAR
nrOut: NoteRequest): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION NASendMIDI(ci: NoteAllocator; noteChannel: NoteChannel; VAR mp:
MusicMIDIPacket): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION NAPickEditInstrument(ci: NoteAllocator; filterProc:
ModalFilterUPP; prompt: StringPtr; refCon: LONGINT; nc: NoteChannel; ai:
AtomicInstrument; flags: LONGINT): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION NANewNoteChannelFromAtomicInstrument(ci: NoteAllocator;
instrument: AtomicInstrumentPtr; flags: LONGINT; VAR outChannel:
NoteChannel): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION NASetAtomicInstrument(ci: NoteAllocator; noteChannel:
NoteChannel; instrument: AtomicInstrumentPtr; flags: LONGINT):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION NAGetKnob(ci: NoteAllocator; noteChannel: NoteChannel;
knobNumber: LONGINT; VAR knobValue: LONGINT): ComponentResult; cdecl;
external 'qtmlClient.dll';

FUNCTION NATask(ci: NoteAllocator): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION NASetNoteChannelBalance(ci: NoteAllocator; noteChannel:
NoteChannel; balance: LONGINT): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION NASetInstrumentNumberInterruptSafe(ci: NoteAllocator;
noteChannel: NoteChannel; instrumentNumber: LONGINT): ComponentResult;
cdecl;  external 'qtmlClient.dll';

FUNCTION NASetNoteChannelSoundLocalization(ci: NoteAllocator; noteChannel:
NoteChannel; data: Handle): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION TuneSetHeader(tp: TunePlayer; VAR header: LONGINT):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION TuneGetTimeBase(tp: TunePlayer; VAR tb: TimeBase):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION TuneSetTimeScale(tp: TunePlayer; scale: TimeScale):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION TuneGetTimeScale(tp: TunePlayer; VAR scale: TimeScale):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION TuneGetIndexedNoteChannel(tp: TunePlayer; i: LONGINT; VAR nc:
NoteChannel): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION TuneQueue(tp: TunePlayer; VAR tune: LONGINT; tuneRate: Fixed;
tuneStartPosition: LONGINT; tuneStopPosition: LONGINT; queueFlags: LONGINT;
callBackProc: TuneCallBackUPP; refCon: LONGINT): ComponentResult; cdecl;
external 'qtmlClient.dll';

FUNCTION TuneInstant(tp: TunePlayer; tune:  Ptr; tunePosition: LONGINT):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION TuneGetStatus(tp: TunePlayer; VAR status: TuneStatus):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION TuneStop(tp: TunePlayer; stopFlags: LONGINT): ComponentResult;
cdecl;  external 'qtmlClient.dll';

FUNCTION TuneSetVolume(tp: TunePlayer; volume: Fixed): ComponentResult;
cdecl;  external 'qtmlClient.dll';

FUNCTION TuneGetVolume(tp: TunePlayer): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION TunePreroll(tp: TunePlayer): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION TuneUnroll(tp: TunePlayer): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION TuneSetNoteChannels(tp: TunePlayer; count: LONGINT; VAR
noteChannelList: NoteChannel; playCallBackProc: TunePlayCallBackUPP;
refCon: LONGINT): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION TuneSetPartTranspose(tp: TunePlayer; part: LONGINT; transpose:
LONGINT; velocityShift: LONGINT): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION TuneGetNoteAllocator(tp: TunePlayer): NoteAllocator; cdecl;
external 'qtmlClient.dll';

FUNCTION TuneSetSofter(tp: TunePlayer; softer: LONGINT): ComponentResult;
cdecl;  external 'qtmlClient.dll';

FUNCTION TuneTask(tp: TunePlayer): ComponentResult; cdecl;  external
'qtmlClient.dll';

FUNCTION TuneSetBalance(tp: TunePlayer; balance: LONGINT):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION TuneSetSoundLocalization(tp: TunePlayer; data: Handle):
ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION TuneSetHeaderWithSize(tp: TunePlayer; VAR header: LONGINT; size:
LONGINT): ComponentResult; cdecl;  external 'qtmlClient.dll';

FUNCTION NewMusicMIDISendProc(userRoutine: MusicMIDISendProcPtr):
MusicMIDISendUPP; cdecl;  external 'qtmlClient.dll';

FUNCTION NewMusicMIDIReadHookProc(userRoutine: MusicMIDIReadHookProcPtr):
MusicMIDIReadHookUPP; cdecl;  external 'qtmlClient.dll';

FUNCTION NewMusicOfflineDataProc(userRoutine: MusicOfflineDataProcPtr):
MusicOfflineDataUPP; cdecl;  external 'qtmlClient.dll';

FUNCTION NewTuneCallBackProc(userRoutine: TuneCallBackProcPtr):
TuneCallBackUPP; cdecl;  external 'qtmlClient.dll';

FUNCTION NewTunePlayCallBackProc(userRoutine: TunePlayCallBackProcPtr):
TunePlayCallBackUPP; cdecl;  external 'qtmlClient.dll';

FUNCTION CallMusicMIDISendProc(self: MusicComponent; refCon: LONGINT; VAR
mmp: MusicMIDIPacket; userRoutine: MusicMIDISendUPP): ComponentResult;
cdecl;  external 'qtmlClient.dll';

FUNCTION CallMusicMIDIReadHookProc(VAR mp: MusicMIDIPacket; myRefCon:
LONGINT; userRoutine: MusicMIDIReadHookUPP): ComponentResult; cdecl;
external 'qtmlClient.dll';

FUNCTION CallMusicOfflineDataProc(SoundData: Ptr; numBytes: LONGINT;
myRefCon: LONGINT; userRoutine: MusicOfflineDataUPP): ComponentResult;
cdecl;  external 'qtmlClient.dll';

PROCEDURE CallTuneCallBackProc({CONST}VAR status: TuneStatus; refCon:
LONGINT; userRoutine: TuneCallBackUPP); cdecl;  external 'qtmlClient.dll';

PROCEDURE CallTunePlayCallBackProc(VAR event: LONGINT; seed: LONGINT;
refCon: LONGINT; userRoutine: TunePlayCallBackUPP); cdecl;  external
'qtmlClient.dll';

END.


