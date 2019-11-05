(*
  4Apr2000 - first creation, in the same "style" as Borland's OpenDialog control
 10Jun2000 - renamed to TJQTFileDialog and placing at "JEDI QuickTime" palette
             page
 13Apr2002 - removed {$R *.RES}, now component icon resource renamed to .DCR and
             linked into the package (open the .DPK file with a text editor)
 30Jun2002 - minor changes to the code to compile with the latest JEDI-QuickTime
             headers             
*)

unit JQTFileDialog;

interface

uses
  Classes, JQTComponent, qt_MacTypes;

type
 TJQTFileDialog = class(TJQTComponent)
  private
   fFileName:StrFileName;
   fInitialDir:string;
  public
   function execute:boolean;
  published
   //property filetype
   property FileName:StrFilename read fFileName write fFileName;
   property InitialDir:string read fInitialDir write fInitialDir;
  end;

implementation
 uses qt_StandardFile,qt_ImageCompression,qt_Movies;

function TJQTFileDialog.execute;
var myTypeList:SFTypeList; //can contain up to 4 file "types"
    myReply:StandardFileReply;
type char4=array[0..3]of char;
begin
 myTypeList[0]:= MovieFileType; //next 3 values not needed since we pass a count of 1 as second param at StandardGetFilePreview
 //myReply.sfFile.name:=filename;
 StandardGetFilePreview(nil, 1, @myTypeList, myReply);
 with myReply do
  begin
  result:=sfGood;
  if result then filename:=sfFile.name;
  end;
end;

end.
