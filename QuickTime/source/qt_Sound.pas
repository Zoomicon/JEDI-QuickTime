{************************************************************************}
{                                                       	             }
{       Borland Delphi Runtime Library                  		       }
{       QuickTime interface unit                                         }
{ 									                   }
{ Portions created by Apple Computers Inc. are 					 }
{ Copyright (C) ????-???? Apple Computers Inc.. 			       }
{ All Rights Reserved. 							             }
{ 								                   	 }
{ The original file is: Sound.h, released dd Mmm yyyy. 		       }
{ The original Pascal code is: qt_Sound.pas, released 14 May 2000. 	 }
{ The initial developer of the Pascal code is George Birbilis            }
{ (birbilis@cti.gr).                     				             }
{ 									                   }
{ Portions created by George Birbilis are    				       }
{ Copyright (C) 1998-2000 George Birbilis 					 }
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

//19Mar2000 - birbilis: first test version with just SysBeep routine
//20Mar2000 - birbilis: ported lots of the constants from "Sound.h"
//04Apr2000 - birbilis: converted some C hex (0x) constants to Object Pascal ($)
//14May2000 - birbilis: donated to Delphi-JEDI

unit qt_Sound;

(*
 	File:		Sound.h

 	Contains:	Sound Manager Interfaces.

 	Version:	Technology:	Sound Manager 3.3
 				Release:	QuickTime 4.0

 	Copyright:	(c) 1986-1998 by Apple Computer, Inc., all rights reserved

 	Bugs?:		For bug reports, consult the following page on
 				the World Wide Web:

 					http://developer.apple.com/bugreporter/

*)

interface
 uses C_Types,qt_MacTypes;

(*
						* * *  N O T E  * * *

	This file has been updated to include Sound Manager 3.3 interfaces.

	Some of the Sound Manager 3.0 interfaces were not put into the InterfaceLib
	that originally shipped with the PowerMacs. These missing functions and the
	new 3.3 interfaces have been released in the SoundLib library for PowerPC
	developers to link with. The runtime library for these functions are
	installed by the Sound Manager. The following functions are found in SoundLib.

		GetCompressionInfo(), GetSoundPreference(), SetSoundPreference(),
		UnsignedFixedMulDiv(), SndGetInfo(), SndSetInfo(), GetSoundOutputInfo(),
		SetSoundOutputInfo(), GetCompressionName(), SoundConverterOpen(),
		SoundConverterClose(), SoundConverterGetBufferSizes(), SoundConverterBeginConversion(),
		SoundConverterConvertBuffer(), SoundConverterEndConversion(),
		AudioGetBass(), AudioGetInfo(), AudioGetMute(), AudioGetOutputDevice(),
		AudioGetTreble(), AudioGetVolume(), AudioMuteOnEvent(), AudioSetBass(),
		AudioSetMute(), AudioSetToDefaults(), AudioSetTreble(), AudioSetVolume(),
		OpenMixerSoundComponent(), CloseMixerSoundComponent(), SoundComponentAddSource(),
		SoundComponentGetInfo(), SoundComponentGetSource(), SoundComponentGetSourceData(),
		SoundComponentInitOutputDevice(), SoundComponentPauseSource(),
		SoundComponentPlaySourceBuffer(), SoundComponentRemoveSource(),
		SoundComponentSetInfo(), SoundComponentSetOutput(), SoundComponentSetSource(),
		SoundComponentStartSource(), SoundComponentStopSource(),
		ParseAIFFHeader(), ParseSndHeader(), SoundConverterGetInfo(), SoundConverterSetInfo()
*)
(*
	Interfaces for Sound Driver, !!! OBSOLETE and NOT SUPPORTED !!!

	These items are no longer defined, but appear here so that someone
	searching the interfaces might find them. If you are using one of these
	items, you must change your code to support the Sound Manager.

		swMode, ftMode, ffMode
		FreeWave, FFSynthRec, Tone, SWSynthRec, Wave, FTSoundRec
		SndCompletionProcPtr
		StartSound, StopSound, SoundDone
*)
(*
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   constants
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*)
 const twelfthRootTwo = 1.05946309435;

 const soundListRsrc = (((ord('s') shl 8 +ord('n'))shl 8 +ord('d'))shl 8 +ord(' ')); (*Resource type used by Sound Manager*)

 const kSimpleBeepID = 1; (*reserved resource ID for Simple Beep*)

 const rate48khz      = long($BB800000); (*48000.00000 in fixed-point*)
       rate44khz      = long($AC440000); (*44100.00000 in fixed-point*)
       rate22050hz    = $56220000;       (*22050.00000 in fixed-point*)
       rate22khz      = $56EE8BA3;       (*22254.54545 in fixed-point*)
       rate11khz      = $2B7745D1;       (*11127.27273 in fixed-point*)
       rate11025hz    = $2B110000;       (*11025.00000 in fixed-point*)

 const	(*synthesizer numbers for SndNewChannel*)
	squareWaveSynth	    = 1; (*square wave synthesizer*)
	waveTableSynth	    = 3; (*wave table synthesizer*)
	sampledSynth	    = 5; (*sampled sound synthesizer*)
        (*old Sound Manager MACE synthesizer numbers*)
	MACE3snthID	    = 11;
	MACE6snthID	    = 13;

 const kMiddleC	= 60; (*MIDI note value for middle C*)


 const kNoVolume    = 0;     (*setting for no sound volume*)
       kFullVolume  = $0100; (*1.0, setting for full hardware output volume*)

 const stdQLength   = 128;

 const dataOffsetFlag = $8000;

 const kUseOptionalOutputDevice	= -1; (*only for Sound Manager 3.0 or later*)

 const notCompressed	    = 0;  (*compression ID's*)
       fixedCompression	    = -1; (*compression ID for fixed-sized compression*)
       variableCompression  = -2; (*compression ID for variable-sized compression*)

 const twoToOne			       = 1;
       eightToThree		       = 2;
       threeToOne		       = 3;
       sixToOne			       = 4;
       sixToOnePacketSize	       = 8;
       threeToOnePacketSize	       = 16;

 const stateBlockSize	   = 64;
       leftOverBlockSize   = 32;

 const firstSoundFormat	 = $0001; (*general sound format*)
       secondSoundFormat = $0002; (*special sampled sound format (HyperCard)*)

 const dbBufferReady = $00000001; (*double buffer is filled*)
       dbLastBuffer  = $00000004; (*last double buffer to play*)

 const sysBeepDisable	   = $0000;     (*SysBeep() enable flags*)
       sysBeepEnable	   = (1 shl 0);
       sysBeepSynchronous  = (1 shl 1); (*if bit set, make alert sounds synchronous*)

 const unitTypeNoSelection = $FFFF; (*unitTypes for AudioSelection.unitType*)
       unitTypeSeconds	   = $0000;

 const stdSH	= $00;	(*Standard sound header encode value*)
       extSH	= $FF; (*Extended sound header encode value*)
       cmpSH	= $FE;	(*Compressed sound header encode value*)

 (*command numbers for SndDoCommand and SndDoImmediate*)

 const nullCmd		      = 0;
       initCmd		      = 1;
       freeCmd		      = 2;
       quietCmd		      = 3;
       flushCmd		      = 4;
       reInitCmd	      = 5;
       waitCmd		      = 10;
       pauseCmd		      = 11;
       resumeCmd	      = 12;
       callBackCmd	      = 13;
       syncCmd		      = 14;
       availableCmd	      = 24;
       versionCmd	      = 25;
       totalLoadCmd	      = 26;
       loadCmd		      = 27;
       freqDurationCmd	      = 40;
       restCmd		      = 41;
       freqCmd		      = 42;
       ampCmd		      = 43;
       timbreCmd	      = 44;
       getAmpCmd	      = 45;
       volumeCmd	      = 46;	(*sound manager 3.0 or later only*)
       getVolumeCmd	      = 47; (*sound manager 3.0 or later only*)
       clockComponentCmd      = 50; (*sound manager 3.2.1 or later only*)
       getClockComponentCmd   = 51; (*sound manager 3.2.1 or later only*)
       scheduledSoundCmd      = 52; (*sound manager 3.3 or later only*)
       linkSoundComponentsCmd = 53; (*sound manager 3.3 or later only*)
       waveTableCmd	      = 60;
       phaseCmd		      = 61;
       soundCmd		      = 80;
       bufferCmd	      = 81;
       rateCmd		      = 82;
       continueCmd	      = 83;
       doubleBufferCmd	      = 84;
       getRateCmd	      = 85;
       rateMultiplierCmd      = 86;
       getRateMultiplierCmd   = 87;
       sizeCmd		      = 90; (*obsolete command*)
       convertCmd	      = 91; (*obsolete MACE command*)


{$IFDEF OLDROUTINENAMES}

 (*channel initialization parameters*)

 const  waveInitChannelMask = $07;
	waveInitChannel0    = $04;		(*wave table only; Sound Manager 2.0 and earlier*)
	waveInitChannel1    = $05;		(*wave table only; Sound Manager 2.0 and earlier*)
	waveInitChannel2    = $06;		(*wave table only; Sound Manager 2.0 and earlier*)
	waveInitChannel3    = $07;		(*wave table only; Sound Manager 2.0 and earlier*)
	initChan0	    = waveInitChannel0;	(*obsolete spelling*)
	initChan1	    = waveInitChannel1;	(*obsolete spelling*)
	initChan2	    = waveInitChannel2;	(*obsolete spelling*)
	initChan3	    = waveInitChannel3; (*obsolete spelling*)

 const outsideCmpSH = 0; (*obsolete MACE constant*)
       insideCmpSH  = 1; (*obsolete MACE constant*)
       aceSuccess   = 0; (*obsolete MACE constant*)
       aceMemFull   = 1; (*obsolete MACE constant*)
       aceNilBlock  = 2; (*obsolete MACE constant*)
       aceBadComp   = 3; (*obsolete MACE constant*)
       aceBadEncode = 4; (*obsolete MACE constant*)
       aceBadDest   = 5; (*obsolete MACE constant*)
       aceBadCmd    = 6; (*obsolete MACE constant*)

{$ENDIF} (* OLDROUTINENAMES *)

 const initChanLeft    = $0002; (*left stereo channel*)
       initChanRight   = $0003; (*right stereo channel*)
       initNoInterp    = $0004; (*no linear interpolation*)
       initNoDrop      = $0008; (*no drop-sample conversion*)
       initMono	       = $0080; (*monophonic channel*)
       initStereo      = $00C0; (*stereo channel*)
       initMACE3       = $0300; (*MACE 3:1*)
       initMACE6       = $0400; (*MACE 6:1*)
       initPanMask     = $0003; (*mask for right/left pan values*)
       initSRateMask   = $0030; (*mask for sample rate values*)
       initStereoMask  = $00C0; (*mask for mono/stereo values*)
       initCompMask    = $FF00; (*mask for compression IDs*)

(*Get&Set Sound Information Selectors*)

 const siActiveChannels		  = 'chac'; (*active channels*)
       siActiveLevels		  = 'lmac'; (*active meter levels*)
       siAGCOnOff		  = 'agc '; (*automatic gain control state*)
       siAsync			  = 'asyn'; (*asynchronous capability*)
       siAVDisplayBehavior	  = 'avdb';
       siChannelAvailable	  = 'chav'; (*number of channels available*)
       siCompressionAvailable	  = 'cmav'; (*compression types available*)
       siCompressionChannels	  = 'cpct'; (*compressor's number of channels*)
       siCompressionFactor	  = 'cmfa'; (*current compression factor*)
       siCompressionHeader	  = 'cmhd'; (*return compression header*)
       siCompressionNames	  = 'cnam'; (*compression type names available*)
       siCompressionParams	  = 'evaw'; (*compression parameters*)
       siCompressionSampleRate	  = 'cprt'; (*compressor's sample rate*)
       siCompressionType	  = 'comp'; (*current compression type*)
       siContinuous		  = 'cont'; (*continous recording*)
       siDecompressionParams	  = 'wave'; (*decompression parameters*)
       siDeviceBufferInfo	  = 'dbin'; (*size of interrupt buffer*)
       siDeviceConnected	  = 'dcon'; (*input device connection status*)
       siDeviceIcon		  = 'icon'; (*input device icon*)
       siDeviceName		  = 'name'; (*input device name*)
       siHardwareBalance	  = 'hbal';
       siHardwareBalanceSteps	  = 'hbls';
       siHardwareBass		  = 'hbas';
       siHardwareBassSteps	  = 'hbst';
       siHardwareBusy		  = 'hwbs'; (*sound hardware is in use*)
       siHardwareFormat		  = 'hwfm'; (*get hardware format*)
       siHardwareMute		  = 'hmut'; (*mute state of all hardware*)
       siHardwareTreble		  = 'htrb';
       siHardwareTrebleSteps	  = 'hwts';
       siHardwareVolume		  = 'hvol'; (*volume level of all hardware*)
       siHardwareVolumeSteps	  = 'hstp'; (*number of volume steps for hardware*)
       siHeadphoneMute		  = 'pmut'; (*mute state of headphones*)
       siHeadphoneVolume	  = 'pvol'; (*volume level of headphones*)
       siHeadphoneVolumeSteps	  = 'hdst'; (*number of volume steps for headphones*)
       siInputAvailable		  = 'inav'; (*input sources available*)
       siInputGain		  = 'gain'; (*input gain*)
       siInputSource		  = 'sour'; (*input source selector*)
       siInputSourceNames	  = 'snam'; (*input source names*)
       siLevelMeterOnOff	  = 'lmet'; (*level meter state*)
       siModemGain		  = 'mgai'; (*modem input gain*)
       siMonitorAvailable	  = 'mnav';
       siMonitorSource		  = 'mons';
       siNumberChannels		  = 'chan'; (*current number of channels*)
       siOptionsDialog		  = 'optd'; (*display options dialog*)
       siOSTypeInputSource	  = 'inpt'; (*input source by OSType*)
       siOSTypeInputAvailable	  = 'inav'; (*list of available input source OSTypes*)
       siPlayThruOnOff		  = 'plth'; (*playthrough state*)
       siPostMixerSoundComponent  = 'psmx'; (*install post-mixer effect*)
       siPreMixerSoundComponent	  = 'prmx'; (*install pre-mixer effect*)
       siQuality		  = 'qual'; (*quality setting*)
       siRateMultiplier		  = 'rmul'; (*throttle rate setting*)
       siRecordingQuality	  = 'qual'; (*recording quality*)
       siSampleRate		  = 'srat'; (*current sample rate*)
       siSampleRateAvailable	  = 'srav'; (*sample rates available*)
       siSampleSize		  = 'ssiz'; (*current sample size*)
       siSampleSizeAvailable	  = 'ssav'; (*sample sizes available*)
       siSetupCDAudio		  = 'sucd'; (*setup sound hardware for CD audio*)
       siSetupModemAudio	  = 'sumd'; (*setup sound hardware for modem audio*)
       siSlopeAndIntercept	  = 'flap'; (*floating point variables for conversion*)
       siSoundClock		  = 'sclk';
       siUseThisSoundClock	  = 'sclc'; (*sdev uses this to tell the mixer to use his sound clock*)
       siSpeakerMute		  = 'smut'; (*mute state of all built-in speaker*)
       siSpeakerVolume		  = 'svol'; (*volume level of built-in speaker*)
       siSSpCPULoadLimit	  = '3dll';
       siSSpLocalization	  = '3dif';
       siSSpSpeakerSetup	  = '3dst';
       siStereoInputGain	  = 'sgai'; (*stereo input gain*)
       siSubwooferMute		  = 'bmut'; (*mute state of sub-woofer*)
       siTwosComplementOnOff	  = 'twos'; (*two's complement state*)
       siVolume			  = 'volu'; (*volume level of source*)
       siVoxRecordInfo		  = 'voxr'; (*VOX record parameters*)
       siVoxStopInfo		  = 'voxs'; (*VOX stop parameters*)
       siWideStereo		  = 'wide'; (*wide stereo setting*)

 const siCloseDriver        = 'clos';  (*reserved for internal use only*)
       siInitializeDriver   = 'init';  (*reserved for internal use only*)
       siPauseRecording     = 'paus';  (*reserved for internal use only*)
       siUserInterruptProc  = 'user';  (*reserved for internal use only*)



(* Sound Manager routines *)

 type SndCommandPtr=pointer; //temp
      SndChannelPtr=pointer; //temp

 procedure SysBeep(duration:short); cdecl;
 function SndDoCommand(chan:SndChannelPtr;const cmd:SndCommandPtr;noWait:Boolean):OSErr; cdecl; //should re-check what the Boolean size in Delphi4 is
 function SndDoImmediate(chan:SndChannelPtr;const cmd:SndCommandPtr):OSErr; cdecl;

implementation

 procedure SysBeep; cdecl; external 'qtmlClient.dll';
 function SndDoCommand; cdecl; external 'qtmlClient.dll';
 function SndDoImmediate; cdecl; external 'qtmlClient.dll';

end.
