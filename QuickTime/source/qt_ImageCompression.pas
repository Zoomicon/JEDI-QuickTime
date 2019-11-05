{************************************************************************}
{                                                       	         }
{       Borland Delphi Runtime Library                  		 }
{       QuickTime interface unit                                         }
{ 									 }
{ Portions created by Apple Computer, Inc. are 				 }
{ Copyright (C) ????-1998 Apple Computer, Inc.. 			 }
{ All Rights Reserved. 							 }
{ 								         }
{ The original file is: ImageCompression.h, released dd Mmm yyyy. 	 }
{ The original Pascal code is: qt_ImageCompression.pas, released 14 May 2000. }
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

//10Feb1999 - birbilis: last known change before donation to Delphi-JEDI
//14May2000 - birbilis: donated to Delphi-JEDI
//21Jan2002 - birbilis: added more stuff
//26Jun2002 - birbilis: now "StandardGetFilePreview" uses "ConstSFTypeListPtr"
//                      instead of "SFTypeList" (changed in QuickTime headers)

unit qt_ImageCompression;

interface
 uses C_Types,qt_MacTypes,qt_StandardFile,qt_QDOffScreen,qt_Quickdraw;

 type
  MatrixRecord=packed record
   matrix:array[0..2,0..2] of Fixed;
  end;
 MatrixRecordPtr=^MatrixRecord;


 type CodecType=OSType;
      CodecQ=cardinal; //unsigned long

 const codecLosslessQuality		= $00000400;
       codecMaxQuality			= $000003FF;
       codecMinQuality			= $00000000;
       codecLowQuality			= $00000100;
       codecNormalQuality		= $00000200;
       codecHighQuality			= $00000300;

 type ImageDescription=packed record
       idSize:long; (* total size of ImageDescription including extra data ( CLUTs and other per sequence data ) *)
       cType:CodecType; (* what kind of codec compressed this data *)
       resvd1:long; (* reserved for Apple use *)
       resvd2:short; (* reserved for Apple use *)
       dataRefIndex:short; (* set to zero  *)
       version:short; (* which version is this data *)
       revisionLevel:short; (* what version of that codec did this *)
       vendor:long; (* whose  codec compressed this data *)
       temporalQuality:CodecQ; (* what was the temporal quality factor  *)
       spatialQuality:CodecQ; (* what was the spatial quality factor *)
       width:short; (* how many pixels wide is this data *)
       height:short; (* how many pixels high is this data *)
       hRes:Fixed; (* horizontal resolution *)
       vRes:Fixed; (* vertical resolution *)
       dataSize:long; (* if known, the size of data for this image descriptor *)
       frameCount:short; (* number of frames this description applies to *)
       name:Str31; (* name of codec ( in case not installed )  *)
       depth:short; (* what depth is this data (1-32) or ( 33-40 grayscale ) *)
       clutID:short; (* clut id or if 0 clut follows  or -1 if no clut *)
       end;
      ImageDescriptionPtr=^ImageDescription;
      ImageDescriptionHandle=^ImageDescriptionPtr;

 procedure StandardGetFilePreview(fileFilter:FileFilterUPP;numTypes:short;
                                  typeList:ConstSFTypeListPtr;var reply:StandardFileReply); cdecl; external 'QTMLClient.dll';

 function QTNewGWorld(var offscreenGWorld:GWorldPtr;PixelFormat:OSType;const boundsRect:Rect;cTable:CTabHandle;aGDevice:GDHandle;flags:GWorldFlags):OSErr; cdecl; external 'QTMLClient.dll';
 function QTNewGWorldFromPtr(var gw:GWorldPtr;pixelFormat:OSType;const boundsRect:Rect;cTable:CTabHandle;aGDevice:GDHandle;flags:GWorldFlags;var baseAddr;rowBytes:long):OSErr; cdecl; external 'QTMLClient.dll';
 function QTUpdateGWorld(var offscreenGWorld:GWorldPtr;PixelFormat:OSType;const boundsRect:Rect;cTable:CTabHandle;aGDevice:GDHandle;flags:GWorldFlags):GWorldFlags; cdecl; external 'QTMLClient.dll';
 function MakeImageDescriptionForPixMap(pixmap:PixMapHandle;var idh:ImageDescriptionHandle):OSErr; cdecl; external 'QTMLClient.dll';
 function MakeImageDescriptionForEffect(effectType:OSType;var idh:ImageDescriptionHandle):OSErr; cdecl; external 'QTMLClient.dll';
 function QTGetPixelSize(PixelFormat:OSType):short; cdecl; external 'QTMLClient.dll';
 function QTGetPixMapPtrRowBytes(pm:PixMapPtr):long; cdecl; external 'QTMLClient.dll';
 function QTGetPixMapHandleRowBytes(pm:PixMapHandle):long; cdecl; external 'QTMLClient.dll';
 function QTSetPixMapPtrRowBytes(pm:PixMapPtr;rowBytes:long):OSErr; cdecl; external 'QTMLClient.dll';
 function QTSetPixMapHandleRowBytes(pm:PixMapHandle;rowBytes:long):OSErr; cdecl; external 'QTMLClient.dll';
 function QuadToQuadMatrix(const source:Fixed;const dest:Fixed;var map:MatrixRecord):OSErr; cdecl; external 'QTMLClient.dll';

implementation

end.
 