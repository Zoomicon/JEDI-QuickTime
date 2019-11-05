unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  JQTComponent, JQTFileDialog, StdCtrls;

type
  TForm2 = class(TForm)
    JQTFileDialog1: TJQTFileDialog;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

procedure TForm2.Button1Click(Sender: TObject);
begin
 JQTFileDialog1.execute;
end;

end.
