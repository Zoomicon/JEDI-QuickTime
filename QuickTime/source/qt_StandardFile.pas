(************************************************************************

       Borland Delphi Runtime Library
       QuickTime interface unit

 Portions created by Apple Computers Inc. are
 Copyright (C) ????-???? Apple Computers Inc.
 All Rights Reserved.

 The original file is: StandardFile.h, released dd Mmm yyyy.
 The original Pascal code is: qt_StandardFile.pas, released 14 May 2000.
 The initial developer of the Pascal code is George Birbilis
 (birbilis@cti.gr).

 Portions created by George Birbilis are
 Copyright (C) 1998-2003 George Birbilis

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

//06Feb1999 - birbilis: last known change before donation to Delphi-JEDI
//14May2000 - birbilis: donated to Delphi-JEDI
//26Jun2002 - birbilis: added FileFilterUPP/FileFilterProcPtr, NewFileFilterProc
//          -           updated StandardPutFile to use "ConstStr255Param"
//                      instead of Str255 parameters
//05Jul2003 - birbilis: fixed StandardGetFile and StatndardPutFile declarations

unit qt_StandardFile;

interface
 uses C_Types,qt_MacTypes,qt_Files;

 type StandardFileReply=packed record
	sfGood:Boolean;
	sfReplacing:Boolean;
	sfType:OSType;
	sfFile:FSSpec;
	sfScript:ScriptCode;
	sfFlags:short;
	sfIsFolder:Boolean;
	sfIsVolume:Boolean;
	sfReserved1:long;
        sfReserved2:short;
        end;

 SFTypeList=array[0..3] of OSType;
(*
    The GetFile "typeList" parameter type has changed from "SFTypeList" to "ConstSFTypeListPtr".
    For C, this will add "const" and make it an in-only parameter.
    For Pascal, this will require client code to use the @ operator, but make it easier to specify long lists.

    ConstSFTypeListPtr is a pointer to an array of OSTypes.
*)
 type
  ConstSFTypeListPtr={const} ^OSType;

 type
  FileFilterProcPtr=function(pb:CInfoPBPtr):Boolean; stdcall; //CALLBACK_API=stdcall on Windows
  FileFilterUPP=FileFilterProcPtr; //STACK_UPP_TYPE

 procedure StandardPutFile(prompt:ConstStr255Param; //can be nil
                           defaultName:ConstStr255Param;
                           var reply:StandardFileReply); cdecl; external 'qtmlClient.dll';

 procedure StandardGetFile(fileFilter:FileFilterUPP; //can be nil
                           numTypes:short;
                           typeList:ConstSFTypeListPtr; //can be nil
                           var reply:StandardFileReply); cdecl; external 'qtmlClient.dll';

 function NewFileFilterProc(procPtr:FileFilterProcPtr):FileFilterUPP;

implementation

function NewFileFilterProc;
begin
 result:=FileFilterUPP(procPtr);
end;

end.
