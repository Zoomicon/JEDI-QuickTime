program JQTComponents_Demo;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
