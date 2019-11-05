(*
  7Dec2003 - first creation
 17Dec2003 - using external "DelphiVersion.inc" file
*)

unit QuickTimeComponentsReg;

interface

procedure Register;

implementation

{$i DelphiVersion.inc}

uses
 Classes,
 JQTComponent,
 JQTFileDialog,
 JQTFilenameEditor,
 qt_MacTypes,
{$IFDEF BEFORE_DELPHI6}
 DsgnIntf;
{$ELSE}
 DesignIntf, DesignEditors;
{$ENDIF}

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(StrFileName),TJQTComponent,'FileName',TStrFilenameProperty);
 //provide the 'Filename' string, else all shortString=TStrFileName properties of the above components would use this editor
 //all TJQTComponent descendents will use this property editor for their "FileName" properties

  RegisterComponents('JEDI QuickTime', [TJQTFileDialog]);
end;

end.
