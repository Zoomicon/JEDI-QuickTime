unit SoundForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
 uses qt_QTML,qt_Sound;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
 InitializeQTML(0);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 TerminateQTML;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 SysBeep(2000);
end;

end.
