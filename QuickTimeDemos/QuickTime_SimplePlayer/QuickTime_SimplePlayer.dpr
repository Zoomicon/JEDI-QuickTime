program QuickTime_SimplePlayer;

uses
  Forms,
  QuickTimeTestForm in 'QuickTimeTestForm.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
