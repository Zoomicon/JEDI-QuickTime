{************************************************************************}
{                                                       	         }
{       Borland Delphi Runtime Library                  		 }
{       QuickTime interface unit                                         }
{ 									 }
{ Portions created by Apple Computer, Inc. are 				 }
{ Copyright (C) ????-1998 Apple Computer, Inc.. 			 }
{ All Rights Reserved. 							 }
{ 								         }
{ The original file is: Files.h, released dd Mmm yyyy. 		         }
{ The original Pascal code is: qt_Files.pas, released 14 May 2000. 	 }
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

//14May2000 - birbilis: donated to Delphi-JEDI
//23May2002 - birbilis: added more declarations
//26Jun2002 - birbilis: fixed FSSpec (parID field is long, not word)

unit qt_Files;

interface
 uses C_Types,qt_MacTypes,qt_OSUtils,qt_Finder;

 //Files.h//

(* HFSUniStr255 is the Unicode equivalent of Str255 *)

 type
  HFSUniStr255=record
   length:UInt16; (* number of unicode characters *)
   unicode:array[0..254] of UniChar; (* unicode characters *)
  end;

 ConstHFSUniStr255Param={const} ^HFSUniStr255;

 const
  fsCurPerm                   = $00; (* open access permissions in ioPermssn *)
  fsRdPerm                    = $01;
  fsWrPerm                    = $02;
  fsRdWrPerm                  = $03;
  fsRdWrShPerm                = $04;
  fsRdDenyPerm                = $10; (* for use with OpenDeny and OpenRFDeny *)
  fsWrDenyPerm                = $20; (* for use with OpenDeny and OpenRFDeny *)

 const
  fsRtParID                   = 1;
  fsRtDirID                   = 2;

 const
  fsAtMark                    = 0; (* positioning modes in ioPosMode *)
  fsFromStart                 = 1;
  fsFromLEOF                  = 2;
  fsFromMark                  = 3;

 const (* ioPosMode flags *)
  pleaseCacheBit              = 4;     (* please cache this request *)
  pleaseCacheMask             = $0010;
  noCacheBit                  = 5;     (* please don't cache this request *)
  noCacheMask                 = $0020;
  rdVerifyBit                 = 6;     (* read verify mode *)
  rdVerifyMask                = $0040;
  rdVerify                    = 64;    (* old name of rdVerifyMask *)
  forceReadBit                = 6;
  forceReadMask               = $0040;
  newLineBit                  = 7;     (* newline mode *)
  newLineMask                 = $0080;
  newLineCharMask             = $FF00; (* newline character *)

 const (* CatSearch Search bitmask Constants *)
  fsSBPartialName             = 1;
  fsSBFullName                = 2;
  fsSBFlAttrib                = 4;
  fsSBFlFndrInfo              = 8;
  fsSBFlLgLen                 = 32;
  fsSBFlPyLen                 = 64;
  fsSBFlRLgLen                = 128;
  fsSBFlRPyLen                = 256;
  fsSBFlCrDat                 = 512;
  fsSBFlMdDat                 = 1024;
  fsSBFlBkDat                 = 2048;
  fsSBFlXFndrInfo             = 4096;
  fsSBFlParID                 = 8192;
  fsSBNegate                  = 16384;
  fsSBDrUsrWds                = 8;
  fsSBDrNmFls                 = 16;
  fsSBDrCrDat                 = 512;
  fsSBDrMdDat                 = 1024;
  fsSBDrBkDat                 = 2048;
  fsSBDrFndrInfo              = 4096;
  fsSBDrParID                 = 8192;

 const (* CatSearch Search bit value Constants *)
  fsSBPartialNameBit          = 0;    (*ioFileName points to a substring*)
  fsSBFullNameBit             = 1;    (*ioFileName points to a match string*)
  fsSBFlAttribBit             = 2;    (*search includes file attributes*)
  fsSBFlFndrInfoBit           = 3;    (*search includes finder info*)
  fsSBFlLgLenBit              = 5;    (*search includes data logical length*)
  fsSBFlPyLenBit              = 6;    (*search includes data physical length*)
  fsSBFlRLgLenBit             = 7;    (*search includes resource logical length*)
  fsSBFlRPyLenBit             = 8;    (*search includes resource physical length*)
  fsSBFlCrDatBit              = 9;    (*search includes create date*)
  fsSBFlMdDatBit              = 10;   (*search includes modification date*)
  fsSBFlBkDatBit              = 11;   (*search includes backup date*)
  fsSBFlXFndrInfoBit          = 12;   (*search includes extended finder info*)
  fsSBFlParIDBit              = 13;   (*search includes file's parent ID*)
  fsSBNegateBit               = 14;   (*return all non-matches*)
  fsSBDrUsrWdsBit             = 3;    (*search includes directory finder info*)
  fsSBDrNmFlsBit              = 4;    (*search includes directory valence*)
  fsSBDrCrDatBit              = 9;    (*directory-named version of fsSBFlCrDatBit*)
  fsSBDrMdDatBit              = 10;   (*directory-named version of fsSBFlMdDatBit*)
  fsSBDrBkDatBit              = 11;   (*directory-named version of fsSBFlBkDatBit*)
  fsSBDrFndrInfoBit           = 12;   (*directory-named version of fsSBFlXFndrInfoBit*)
  fsSBDrParIDBit              = 13;   (*directory-named version of fsSBFlParIDBit*)

 const (* vMAttrib (GetVolParms) bit position constants *)
  bLimitFCBs                  = 31;
  bLocalWList                 = 30;
  bNoMiniFndr                 = 29;
  bNoVNEdit                   = 28;
  bNoLclSync                  = 27;
  bTrshOffLine                = 26;
  bNoSwitchTo                 = 25;
  bNoDeskItems                = 20;
  bNoBootBlks                 = 19;
  bAccessCntl                 = 18;
  bNoSysDir                   = 17;
  bHasExtFSVol                = 16;
  bHasOpenDeny                = 15;
  bHasCopyFile                = 14;
  bHasMoveRename              = 13;
  bHasDesktopMgr              = 12;
  bHasShortName               = 11;
  bHasFolderLock              = 10;
  bHasPersonalAccessPrivileges = 9;
  bHasUserGroupList           = 8;
  bHasCatSearch               = 7;
  bHasFileIDs                 = 6;
  bHasBTreeMgr                = 5;
  bHasBlankAccessPrivileges   = 4;
  bSupportsAsyncRequests      = 3;  (* asynchronous requests to this volume are handled correctly at any time*)
  bSupportsTrashVolumeCache   = 2;

 const (* vMExtendedAttributes (GetVolParms) bit position constants *)
  bIsEjectable                = 0;  (* volume is in an ejectable disk drive *)
  bSupportsHFSPlusAPIs        = 1;  (* volume supports HFS Plus APIs directly (not through compatibility layer) *)
  bSupportsFSCatalogSearch    = 2;  (* volume supports FSCatalogSearch *)
  bSupportsFSExchangeObjects  = 3;  (* volume supports FSExchangeObjects *)
  bSupports2TBFiles           = 4;  (* volume supports supports 2 terabyte files *)
  bSupportsLongNames          = 5;  (* volume supports file/directory/volume names longer than 31 characters *)
  bSupportsMultiScriptNames   = 6;  (* volume supports file/directory/volume names with characters from multiple script systems *)
  bSupportsNamedForks         = 7;  (* volume supports forks beyond the data and resource forks *)
  bSupportsSubtreeIterators   = 8;  (* volume supports recursive iterators not at the volume root *)
  bL2PCanMapFileBlocks        = 9;  (* volume supports Lg2Phys SPI correctly *)
  bAllowCDiDataHandler        = 17; (* allow QuickTime's CDi data handler to examine this volume *)

 const (* Desktop Database icon Constants *)
  kLargeIcon                  = 1;
  kLarge4BitIcon              = 2;
  kLarge8BitIcon              = 3;
  kSmallIcon                  = 4;
  kSmall4BitIcon              = 5;
  kSmall8BitIcon              = 6;

 const
  kLargeIconSize              = 256;
  kLarge4BitIconSize          = 512;
  kLarge8BitIconSize          = 1024;
  kSmallIconSize              = 64;
  kSmall4BitIconSize          = 128;
  kSmall8BitIconSize          = 256;

 const (* Large Volume Constants *)
  kWidePosOffsetBit           = 8;
  kUseWidePositioning         = (1 shl kWidePosOffsetBit);
  kMaximumBlocksIn4GB         = $007FFFFF;

 const (* Foreign Privilege Model Identifiers *)
  fsUnixPriv                  = 1;

 const (* Authentication Constants *)
  kNoUserAuthentication       = 1;
  kPassword                   = 2;
  kEncryptPassword            = 3;
  kTwoWayEncryptPassword      = 6;


(* mapping codes (ioObjType) for MapName & MapID *)
 const
  kOwnerID2Name               = 1;
  kGroupID2Name               = 2;
  kOwnerName2ID               = 3;
  kGroupName2ID               = 4; (* types of oj object to be returned (ioObjType) for _GetUGEntry *)
  kReturnNextUser             = 1;
  kReturnNextGroup            = 2;
  kReturnNextUG               = 3;

(* vcbFlags bits *)
 const
  kVCBFlagsIdleFlushBit       = 3;     (* Set if volume should be flushed at idle time *)
  kVCBFlagsIdleFlushMask      = $0008;
  kVCBFlagsHFSPlusAPIsBit     = 4;     (* Set if volume implements HFS Plus APIs itself (not via emulation) *)
  kVCBFlagsHFSPlusAPIsMask    = $0010;
  kVCBFlagsHardwareGoneBit    = 5;     (* Set if disk driver returned a hardwareGoneErr to Read or Write *)
  kVCBFlagsHardwareGoneMask   = $0020;
  kVCBFlagsVolumeDirtyBit     = 15;    (* Set if volume information has changed since the last FlushVol *)
  kVCBFlagsVolumeDirtyMask    = $8000;

(* ioFlAttrib bits returned by PBGetCatInfo *)
 const (* file and directory attributes in ioFlAttrib *)
  kioFlAttribLockedBit        = 0;     (* Set if file or directory is locked *)
  kioFlAttribLockedMask       = $01;
  kioFlAttribResOpenBit       = 2;     (* Set if resource fork is open *)
  kioFlAttribResOpenMask      = $04;
  kioFlAttribDataOpenBit      = 3;     (* Set if data fork is open *)
  kioFlAttribDataOpenMask     = $08;
  kioFlAttribDirBit           = 4;     (* Set if this is a directory *)
  kioFlAttribDirMask          = $10;
  ioDirFlg                    = 4;     (* Set if this is a directory (old name) *)
  ioDirMask                   = $10;
  kioFlAttribCopyProtBit      = 6;     (* Set if AppleShare server "copy-protects" the file *)
  kioFlAttribCopyProtMask     = $40;
  kioFlAttribFileOpenBit      = 7;     (* Set if file (either fork) is open *)
  kioFlAttribFileOpenMask     = $80;  (* ioFlAttrib for directories only *)
  kioFlAttribInSharedBit      = 2;     (* Set if the directory is within a shared area of the directory hierarchy *)
  kioFlAttribInSharedMask     = $04;
  kioFlAttribMountedBit       = 3;     (* Set if the directory is a share point that is mounted by some user *)
  kioFlAttribMountedMask      = $08;
  kioFlAttribSharePointBit    = 5;     (* Set if the directory is a share point *)
  kioFlAttribSharePointMask   = $20;


(* ioFCBFlags bits returned by PBGetFCBInfo *)
 const
  kioFCBWriteBit              = 8;      (* Data can be written to this file *)
  kioFCBWriteMask             = $0100;
  kioFCBResourceBit           = 9;      (* This file is a resource fork *)
  kioFCBResourceMask          = $0200;
  kioFCBWriteLockedBit        = 10;     (* File has a locked byte range *)
  kioFCBWriteLockedMask       = $0400;
  kioFCBLargeFileBit          = 11;     (* File may grow beyond 2GB; cache uses file blocks; not bytes *)
  kioFCBLargeFileMask         = $0800;
  kioFCBSharedWriteBit        = 12;     (* File is open for shared write access *)
  kioFCBSharedWriteMask       = $1000;
  kioFCBFileLockedBit         = 13;     (* File is locked (write-protected) *)
  kioFCBFileLockedMask        = $2000;
  kioFCBOwnClumpBit           = 14;     (* File has clump size specified in FCB *)
  kioFCBOwnClumpMask          = $4000;
  kioFCBModifiedBit           = 15;     (* File has changed since it was last flushed *)
  kioFCBModifiedMask          = $8000;

(* ioACUser bits returned by PBGetCatInfo *)
(* Note: you must clear ioACUser before calling PBGetCatInfo because some file systems do not use this field *)
 const
  kioACUserNoSeeFolderBit     = 0;   (* Set if user does not have See Folder privileges *)
  kioACUserNoSeeFolderMask    = $01;
  kioACUserNoSeeFilesBit      = 1;   (* Set if user does not have See Files privileges *)
  kioACUserNoSeeFilesMask     = $02;
  kioACUserNoMakeChangesBit   = 2;   (* Set if user does not have Make Changes privileges *)
  kioACUserNoMakeChangesMask  = $04;
  kioACUserNotOwnerBit        = 7;   (* Set if user is not owner of the directory *)
  kioACUserNotOwnerMask       = $80;

(* Folder and File values of access privileges in ioACAccess *)
 const
  kioACAccessOwnerBit         = 31;            (* User is owner of directory *)
  kioACAccessOwnerMask        = long($80000000);
  kioACAccessBlankAccessBit   = 28;            (* Directory has blank access privileges *)
  kioACAccessBlankAccessMask  = $10000000;
  kioACAccessUserWriteBit     = 26;            (* User has write privileges *)
  kioACAccessUserWriteMask    = $04000000;
  kioACAccessUserReadBit      = 25;            (* User has read privileges *)
  kioACAccessUserReadMask     = $02000000;
  kioACAccessUserSearchBit    = 24;            (* User has search privileges *)
  kioACAccessUserSearchMask   = $01000000;
  kioACAccessEveryoneWriteBit = 18;            (* Everyone has write privileges *)
  kioACAccessEveryoneWriteMask = $00040000;
  kioACAccessEveryoneReadBit  = 17;            (* Everyone has read privileges *)
  kioACAccessEveryoneReadMask = $00020000;
  kioACAccessEveryoneSearchBit = 16;           (* Everyone has search privileges *)
  kioACAccessEveryoneSearchMask = $00010000;
  kioACAccessGroupWriteBit    = 10;            (* Group has write privileges *)
  kioACAccessGroupWriteMask   = $00000400;
  kioACAccessGroupReadBit     = 9;             (* Group has read privileges *)
  kioACAccessGroupReadMask    = $00000200;
  kioACAccessGroupSearchBit   = 8;             (* Group has search privileges *)
  kioACAccessGroupSearchMask  = $00000100;
  kioACAccessOwnerWriteBit    = 2;             (* Owner has write privileges *)
  kioACAccessOwnerWriteMask   = $00000004;
  kioACAccessOwnerReadBit     = 1;             (* Owner has read privileges *)
  kioACAccessOwnerReadMask    = $00000002;
  kioACAccessOwnerSearchBit   = 0;             (* Owner has search privileges *)
  kioACAccessOwnerSearchMask  = $00000001;
  kfullPrivileges             = $00070007;    (* all privileges for everybody and owner*)
  kownerPrivileges            = $00000007;    (* all privileges for owner only*)

(* values of user IDs and group IDs *)
 const
  knoUser                     = 0;
  kadministratorUser          = 1;

 const
  knoGroup                    = 0;

 type
  GetVolParmsInfoBuffer=record
   vMVersion:short; (*version number*)
   vMAttrib:long; (*bit vector of attributes (see vMAttrib constants)*)
   vMLocalHand:Handle; (*handle to private data*)
   vMServerAdr:long; (*AppleTalk server address or zero*)
                     (*       vMVersion 1 GetVolParmsInfoBuffer ends here *)
   vMVolumeGrade:long; (*approx. speed rating or zero if unrated*)
   vMForeignPrivID:short; (*foreign privilege model supported or zero if none*)
                          (*       vMVersion 2 GetVolParmsInfoBuffer ends here *)
   vMExtendedAttributes:long; (*extended attribute bits (see vMExtendedAttributes constants)*)
                              (*       vMVersion 3 GetVolParmsInfoBuffer ends here *)
  end;

 type
  ParmBlkPtr=^ParamBlockRec;
  IOCompletionProcPtr=procedure(paramBlock:ParmBlkPtr); stdcall; //CALLBACK_API=stdcall on Win32

(*
    WARNING: IOCompletionProcPtr uses register based parameters under classic 68k
             and cannot be written in a high-level language without
             the help of mixed mode or assembly glue.
*)
  IOCompletionUPP={REGISTER_UPP_TYPE(}IOCompletionProcPtr{)};

  IOParam=record
   qLink:QElemPtr; (*queue link in header*)
   qType:short; (*type byte for safety check*)
   ioTrap:short; (*FS: the Trap*)
   ioCmdAddr:Ptr; (*FS: address to dispatch to*)
   ioCompletion:IOCompletionUPP; (*completion routine addr (0 for synch calls)*)
   ioResult:{volatile}OSErr; (*result code*)
   ioNamePtr:StringPtr; (*ptr to Vol:FileName string*)
   ioVRefNum:short; (*volume refnum (DrvNum for Eject and MountVol)*)
   ioRefNum:short; (*refNum for I/O operation*)
   ioVersNum:SInt8; (*version number*)
   ioPermssn:SInt8; (*Open: permissions (byte)*)
   ioMisc:Ptr; (*Rename: new name (GetEOF,SetEOF: logical end of file) (Open: optional ptr to buffer) (SetFileType: new type)*)
   ioBuffer:Ptr; (*data buffer Ptr*)
   ioReqCount:long; (*requested byte count; also = ioNewDirID*)
   ioActCount:long; (*actual byte count completed*)
   ioPosMode:short; (*initial file positioning*)
   ioPosOffset:long; (*file position offset*)
   end;
  IOParamPtr=^IOParam;

  FileParam=record
   qLink:QElemPtr; (*queue link in header*)
   qType:short; (*type byte for safety check*)
   ioTrap:short; (*FS: the Trap*)
   ioCmdAddr:Ptr; (*FS: address to dispatch to*)
   ioCompletion:IOCompletionUPP; (*completion routine addr (0 for synch calls)*)
   {volatile}ioResult:OSErr; (*result code*)
   ioNamePtr:StringPtr; (*ptr to Vol:FileName string*)
   ioVRefNum:short; (*volume refnum (DrvNum for Eject and MountVol)*)
   ioFRefNum:short; (*reference number*)
   ioFVersNum:SInt8; (*version number*)
   filler1:SInt8;
   ioFDirIndex:short; (*GetFInfo directory index*)
   ioFlAttrib:SInt8; (*GetFInfo: in-use bit=7, lock bit=0*)
   ioFlVersNum:SInt8; (*file version number*)
   ioFlFndrInfo:FInfo; (*user info*)
   ioFlNum:unsigned_long; (*GetFInfo: file number; TF- ioDirID*)
   ioFlStBlk:unsigned_short; (*start file block (0 if none)*)
   ioFlLgLen:long; (*logical length (EOF)*)
   ioFlPyLen:long; (*physical length*)
   ioFlRStBlk:unsigned_short; (*start block rsrc fork*)
   ioFlRLgLen:long; (*file logical length rsrc fork*)
   ioFlRPyLen:long; (*file physical length rsrc fork*)
   ioFlCrDat:unsigned_long; (*file creation date& time (32 bits in secs)*)
   ioFlMdDat:unsigned_long; (*last modified date and time*)
   end;
  FileParamPtr=^FileParam;

  VolumeParam=record
   qLink:QElemPtr; (*queue link in header*)
   qType:short; (*type byte for safety check*)
   ioTrap:short; (*FS: the Trap*)
   ioCmdAddr:Ptr; (*FS: address to dispatch to*)
   ioCompletion:IOCompletionUPP; (*completion routine addr (0 for synch calls)*)
   ioResult:{volatile}OSErr; (*result code*)
   ioNamePtr:StringPtr; (*ptr to Vol:FileName string*)
   ioVRefNum:short; (*volume refnum (DrvNum for Eject and MountVol)*)
   filler2:long;
   ioVolIndex:short; (*volume index number*)
   ioVCrDate:unsigned_long; (*creation date and time*)
   ioVLsBkUp:unsigned_long; (*last backup date and time*)
   ioVAtrb:unsigned_short; (*volume attrib*)
   ioVNmFls:unsigned_short; (*number of files in directory*)
   ioVDirSt:unsigned_short; (*start block of file directory*)
   ioVBlLn:short; (*GetVolInfo: length of dir in blocks*)
   ioVNmAlBlks:unsigned_short; (*for compatibilty ioVNmAlBlks * ioVAlBlkSiz <= 2 GB*)
   ioVAlBlkSiz:unsigned_long; (*for compatibilty ioVAlBlkSiz is <= $0000FE00 (65,024)*)
   ioVClpSiz:unsigned_long; (*GetVolInfo: bytes to allocate at a time*)
   ioAlBlSt:unsigned_short; (*starting disk(512-byte) block in block map*)
   ioVNxtFNum:unsigned_long; (*GetVolInfo: next free file number*)
   ioVFrBlk:unsigned_short; (*GetVolInfo: # free alloc blks for this vol*)
   end;
  VolumeParamPtr=^VolumeParam;

  CntrlParam=record
   qLink:QElemPtr; (*queue link in header*)
   qType:short; (*type byte for safety check*)
   ioTrap:short; (*FS: the Trap*)
   ioCmdAddr:Ptr; (*FS: address to dispatch to*)
   ioCompletion:IOCompletionUPP; (*completion routine addr (0 for synch calls)*)
   ioResult:{volatile}OSErr; (*result code*)
   ioNamePtr:StringPtr; (*ptr to Vol:FileName string*)
   ioVRefNum:short; (*volume refnum (DrvNum for Eject and MountVol)*)
   ioCRefNum:short; (*refNum for I/O operation*)
   csCode:short; (*word for control status code*)
   csParam:array[0..10] of short; (*operation-defined parameters*)
   end;
  CntrlParamPtr=^CntrlParam;

  SlotDevParam=record
   qLink:QElemPtr; (*queue link in header*)
   qType:short; (*type byte for safety check*)
   ioTrap:short; (*FS: the Trap*)
   ioCmdAddr:Ptr; (*FS: address to dispatch to*)
   ioCompletion:IOCompletionUPP; (*completion routine addr (0 for synch calls)*)
   ioResult:{volatile}OSErr; (*result code*)
   ioNamePtr:StringPtr; (*ptr to Vol:FileName string*)
   ioVRefNum:short; (*volume refnum (DrvNum for Eject and MountVol)*)
   ioSRefNum:short;
   ioSVersNum:SInt8;
   ioSPermssn:SInt8;
   ioSMix:Ptr;
   ioSFlags:short;
   ioSlot:SInt8;
   ioID:SInt8;
   end;
  SlotDevParamPtr=^SlotDevParam;

  MultiDevParam=record
   qLink:QElemPtr; (*queue link in header*)
   qType:short; (*type byte for safety check*)
   ioTrap:short; (*FS: the Trap*)
   ioCmdAddr:Ptr; (*FS: address to dispatch to*)
   ioCompletion:IOCompletionUPP; (*completion routine addr (0 for synch calls)*)
   ioResult:{volatile}OSErr; (*result code*)
   ioNamePtr:StringPtr; (*ptr to Vol:FileName string*)
   ioVRefNum:short; (*volume refnum (DrvNum for Eject and MountVol)*)
   ioMRefNum:short;
   ioMVersNum:SInt8;
   ioMPermssn:SInt8;
   ioMMix:Ptr;
   ioMFlags:short;
   ioSEBlkPtr:Ptr;
   end;
  MultiDevParamPtr=^MultiDevParam;

  ParamBlockRec=record
   case integer of //C's union
    0: (ioParam:IOParam);
    1: (fileParam:FileParam);
    2: (volumeParam:VolumeParam);
    3: (cntrlParam:CntrlParam);
    4: (slotDevParam:SlotDevParam);
    5: (multiDevParam:MultiDevParam);
  end;

  HFileInfo=record
   qLink:QElemPtr; (*queue link in header*)
   qType:short; (*type byte for safety check*)
   ioTrap:short; (*FS: the Trap*)
   ioCmdAddr:Ptr; (*FS: address to dispatch to*)
   ioCompletion:IOCompletionUPP; (*completion routine addr (0 for synch calls)*)
   ioResult:{volatile}OSErr; (*result code*)
   ioNamePtr:StringPtr; (*ptr to Vol:FileName string*)
   ioVRefNum:short; (*volume refnum (DrvNum for Eject and MountVol)*)
   ioFRefNum:short;
   ioFVersNum:SInt8;
   filler1:SInt8;
   ioFDirIndex:short;
   ioFlAttrib:SInt8;
   ioACUser:SInt8;
   ioFlFndrInfo:FInfo;
   ioDirID:long;
   ioFlStBlk:unsigned_short;
   ioFlLgLen:long;
   ioFlPyLen:long;
   ioFlRStBlk:unsigned_short;
   ioFlRLgLen:long;
   ioFlRPyLen:long;
   ioFlCrDat:unsigned_long;
   ioFlMdDat:unsigned_long;
   ioFlBkDat:unsigned_long;
   ioFlXFndrInfo:FXInfo;
   ioFlParID:long;
   ioFlClpSiz:long;
   end;

  DirInfo=record
   qLink:QElemPtr; (*queue link in header*)
   qType:short; (*type byte for safety check*)
   ioTrap:short; (*FS: the Trap*)
   ioCmdAddr:Ptr; (*FS: address to dispatch to*)
   ioCompletion:IOCompletionUPP; (*completion routine addr (0 for synch calls)*)
   ioResult:{volatile}OSErr; (*result code*)
   ioNamePtr:StringPtr; (*ptr to Vol:FileName string*)
   ioVRefNum:short; (*volume refnum (DrvNum for Eject and MountVol)*)
   ioFRefNum:short;
   ioFVersNum:SInt8;
   filler1:SInt8;
   ioFDirIndex:short;
   ioFlAttrib:SInt8;
   ioACUser:SInt8;
   ioDrUsrWds:DInfo;
   ioDrDirID:long;
   ioDrNmFls:unsigned_short;
   filler3:array[0..8] of short;
   ioDrCrDat:unsigned_long;
   ioDrMdDat:unsigned_long;
   ioDrBkDat:unsigned_long;
   ioDrFndrInfo:DXInfo;
   ioDrParID:long;
   end;

  CInfoPBRec=record
   case System.boolean of //C's union
    false: (hFileInfo:HFileInfo);
    true: (dirInfo:DirInfo);
  end;
  CInfoPBPtr=^CInfoPBRec;

 //...

 type FSSpec=packed record
       vRefNum:short;
       parID:long;
       name:StrFileName; (* a Str63 on MacOS*)
       end;
      FSSpecPtr=^FSSpec;
      FSSpecHandle=^FSSpecPtr;

 function FSMakeFSSpec(vRefNum:short;dirID:long;fileName:ConstStr255Param;spec:FSSpecPtr):OSErr; cdecl; external 'qtmlClient.dll';

implementation

end.

