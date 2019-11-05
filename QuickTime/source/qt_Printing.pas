{************************************************************************}
{                                                       	             }
{       Borland Delphi Runtime Library                  		       }
{       QuickTime interface unit                                         }
{ 									                   }
{ Portions created by Apple Computer, Inc. are 					 }
{ Copyright (C) ????-1998 Apple Computer, Inc.. 			       }
{ All Rights Reserved. 							             }
{ 								                   	 }
{ The original file is: Printing.h, released dd Mmm yyyy. 		       }
{ The original Pascal code is: qt_Printing.pas, released 14 May 2000. 	 }
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

//14May2000 - birbilis: donated to Delphi-JEDI

unit qt_Printing;

interface
 uses C_Types,qt_MacTypes,qt_QuickDraw;

 const pPrGlobals					= $00000944;					(*The PrVars lo mem area:*)
       bDraftLoop					= 0;
       bSpoolLoop					= 1;
       bUser1Loop					= 2;
       bUser2Loop					= 3;
       fNewRunBit					= 2;
       fHiResOK					= 3;
       fWeOpenedRF					= 4;							(*Driver constants *)
       iPrBitsCtl					= 4;
       lScreenBits					= 0;
       lPaintBits					= 1;
       lHiScreenBits				= $00000002;					(*The Bitmap Print Proc's Screen Bitmap param*)
       lHiPaintBits				= $00000003;					(*The Bitmap Print Proc's Paint [sq pix] param*)
       iPrIOCtl					= 5;
       iPrEvtCtl					= 6;							(*The PrEvent Proc's ctl number*)
       lPrEvtAll					= $0002FFFD;					(*The PrEvent Proc's CParam for the entire screen*)
       lPrEvtTop					= $0001FFFD;					(*The PrEvent Proc's CParam for the top folder*)
       iPrDrvrRef					= -3;

 type TPrPort=packed record
       gPort:GrafPort;   (*The Printer's graf port.*)
       gProcs:QDProcs;   (*..and its procs*)
       lGParam1:long;    (*16 bytes for private parameter storage.*)
       lGParam2:long;
       lGParam3:long;
       lGParam4:long;
       fOurPtr:Boolean;  (*Whether the PrPort allocation was done by us.*)
       fOurBits:Boolean; (*Whether the BitMap allocation was done by us.*)
       end;
      TPPrPort=^TPrPort;
      TPPrPortRef=TPPrPort; //^TPrPort; //Delphi: compiler needs this to say TPPrPort=TPPrPortRef=^TPrPort
(* Printing Graf Port. All printer imaging, whether spooling, banding, etc, happens "thru" a GrafPort.
  This is the "PrPeek" record. *)

 type TPrInfo=packed record
       iDev:short;						(*Font mgr/QuickDraw device code*)
       iVRes:short;						(*Resolution of device, in device coordinates*)
       iHRes:short;						(*..note: V before H => compatable with Point.*)
       rPage:Rect;						(*The page (printable) rectangle in device coordinates.*)
       end;
      TPPrInfo=^TPrInfo;
(* Print Info Record: The parameters needed for page composition. *)

 const feedCut						= 0;
       feedFanfold					= 1;
       feedMechCut					= 2;
       feedOther					= 3;
 type TFeed=SInt8;

 const scanTB						= 0;
       scanBT						= 1;
       scanLR						= 2;
       scanRL						= 3;
 type TScan=SInt8;

 type TPrStl=packed record
       wDev:short;
       iPageV:short;
       iPageH:short;
       bPort:SInt8;
       feed:TFeed;
       end;
      TPPrStl=^TPrStl;

      TPrXInfo=packed record
       iRowBytes,
       iBandV,
       iBandH,
       iDevBytes,
       iBands:short;
       bPatScale,
       bUlThick,
       bUlOffset,
       bUlShadow:SInt8;
       scan:TScan;
       bXInfoX:SInt8;
       end;
      TPPrXInfo=^TPrXInfo;

      PrIdleUPP=pointer; //???

      TPrJob=packed record
       iFstPage,					(*Page Range.*)
       iLstPage,
       iCopies:short;					(*No. copies.*)
       bJDocLoop:SInt8;					(*The Doc style: Draft, Spool, .., and ..*)
       fFromUsr:Boolean;					(*Printing from an User's App (not PrApp) flag*)
       pIdleProc:PrIdleUPP;					(*The Proc called while waiting on IO etc.*)
       pFileName:StringPtr;					(*Spool File Name: NIL for default.*)
       iFileVol:short;					(*Spool File vol, set to 0 initially*)
       bFileVers,					(*Spool File version, set to 0 initially*)
       bJobX:SInt8;						(*An eXtra byte.*)
       end;
      TPPrJob=^TPrJob;
(* Print Job: Print "form" for a single print request. *)

 type TPrint=packed record
       iPrVersion:short;	     (*(2) Printing software version*)
       prInfo:TPrInfo;		     (*(14) the PrInfo data associated with the current style.*)
       rPaper:Rect;		     (*(8) The paper rectangle [offset from rPage]*)
       prStl:TPrStl;		     (*(8)  This print request's style.*)
       prInfoPT:TPrInfo;	     (*(14)  Print Time Imaging metrics*)
       prXInfo:TPrXInfo;	     (*(16)  Print-time (expanded) Print info record.*)
       prJob:TPrJob;		     (*(20) The Print Job request (82)  Total of the above; 120-82 = 38 bytes needed to fill 120*)
       printX:array[0..18]of short; (*Spare to fill to 120 bytes!*)
       end;
      TPPrint=^TPrint;
      THPrint=^TPPrint;

      TPRect=^Rect; (* A Rect Ptr *)

      TPrStatus=packed record
       iTotPages:short;	(*Total pages in Print File.*)
       iCurPage:short;	(*Current page number*)
       iTotCopies:short; (*Total copies requested*)
       iCurCopy:short;	(*Current copy number*)
       iTotBands:short;	(*Total bands per page.*)
       iCurBand:short;	(*Current band number*)
       fPgDirty:Boolean; (*True if current page has been written to.*)
       fImaging:Boolean; (*Set while in band's DrawPic call.*)
       hPrint:THPrint; (*Handle to the active Printer record*)
       pPrPort:TPPrPortRef; (*Ptr to the active PrPort*)
       hPic:PicHandle; (*Handle to the active Picture*)
       end;

      TPPrStatus=^TPrStatus;
      TPPrStatusRef=TPPrStatus; //^TPrStatus; //Delphi: compiler needs this to say TPPrStatus=TPPrStatusRef=^TPrStatus

 procedure PrOpen; cdecl;
 procedure PrClose; cdecl;
 procedure PrintDefault(hPrint:THPrint); cdecl;

 function PrError:short; cdecl;

 function PrStlDialog(hPrint:THPrint):Boolean; cdecl;
 function PrJobDialog(hPrint:THPrint):Boolean; cdecl;
 function PrOpenDoc(hPrint:THPrint;pPrPort:TPPrPortRef;pIOBuf:Ptr):TPPrPortRef; cdecl;
 procedure PrCloseDoc(pPrPort:TPPrPortRef); cdecl;
 procedure PrOpenPage(pPrPort:TPPrPortRef;pPageFrame:TPRect); cdecl;
 procedure PrClosePage(pPrPort:TPPrPortRef); cdecl;
 procedure PrPicFile(hPrint:THPrint;pPrPort:TPPrPortRef;pIOBuf:Ptr;pDevBuf:Ptr;prStatus:TPPrStatusRef); cdecl;

implementation

 procedure PrOpen; cdecl; external 'qtmlClient.dll';
 procedure PrClose; cdecl; external 'qtmlClient.dll';
 procedure PrintDefault; cdecl; external 'qtmlClient.dll';

 function PrError; cdecl; external 'qtmlClient.dll';

 function PrStlDialog; cdecl; external 'qtmlClient.dll';
 function PrJobDialog; cdecl; external 'qtmlClient.dll';

 function PrOpenDoc; cdecl; external 'qtmlClient.dll';
 procedure PrCloseDoc; cdecl; external 'qtmlClient.dll';
 procedure PrOpenPage; cdecl; external 'qtmlClient.dll';
 procedure PrClosePage; cdecl; external 'qtmlClient.dll';
 procedure PrPicFile; cdecl; external 'qtmlClient.dll';

end.
