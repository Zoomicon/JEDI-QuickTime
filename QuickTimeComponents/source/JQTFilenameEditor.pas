(*
  7Mar1999 - first creation
  4Apr2000 - renamed "Filename" property of TQTControl to "FileName". Delphi
             should be case insensitive, but changed here too, just for sure
 25Jun2000 - renamed unit to JQTFilenameEditor and added to JEDI QuickTime
             components package
 30Jun2002 - minor changes to the code to compile with the latest JEDI-QuickTime
             headers
 16Dec2003 - changed code and split in Runtime&Designtime packages so that it
             compiles with Delphi6 too (thanks to Vaclav Krmela who pointed me
             to http://bdn.borland.com/article/0,1410,27717,00.html)
 17Dec2003 - using external "DelphiVersion.inc" file
  7Aug2004 - removed unused units from "uses" clause
*)

unit JQTFilenameEditor;

interface

{$i DelphiVersion.inc}

uses
{$IFDEF BEFORE_DELPHI6}
DsgnIntf;
{$ELSE}
DesignIntf, DesignEditors;
{$ENDIF}

type
  TStrFilenameProperty=class(TStringProperty)
  public
   function GetAttributes: TPropertyAttributes; override;
   procedure Edit; override;
  end;

implementation
 uses
  qt_StandardFile,
  qt_ImageCompression,
  qt_Movies;

function TStrFileNameProperty.GetAttributes;
begin
 Result:=[paDialog];
end;

procedure TStrFileNameProperty.Edit;
var myTypeList:SFTypeList; //takes only 4 file "types"
    myReply:StandardFileReply;
begin
 myTypeList[0]:= MovieFileType; //next 3 values not needed since we pass a count of 1 as second param at StandardGetFilePreview
 StandardGetFilePreview(nil, 1, @myTypeList, myReply);
 if (myReply.sfGood)
  then setValue(myReply.sfFile.name);
end;

end.
