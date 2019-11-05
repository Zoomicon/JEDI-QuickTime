unit ChooseInstrument;

interface

uses
  forms, Classes, Controls, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    instr : integer;
    instName : String;
  end;

var
  Form1: TForm1;

procedure pickInstrument(VAR inst : integer; VAR name : String);

implementation
uses qt_QTML,
     qt_Components,
     qt_QuickTimeMusic,
     qt_Movies,
     qt_MacTypes;

{$R *.DFM}

procedure pickInstrument(VAR inst : integer; VAR name : String);
var na : NoteAllocator;    {=ComponentInstance}
    nr : NoteRequest;
    thisError : ComponentResult;
    OStr : Str255;
begin
 na := OpenDefaultComponent(kNoteAllocatorComponentType, 0);
 if na = nil
  then inst := 0
  else
   begin
   with nr.info do
    begin
    Polyphony := 1;
    TypicalPolyphony := $00010000;
    end;

   //thisError :=
   NAStuffToneDescription(na, inst, nr.tone);

   OStr := 'Pick an Instrument';
   thisError := NAPickInstrument(
    na,
    nil {this shouldn't be nil, need to pass a ModalFilterProc here},
    @OStr,
    nr.tone,
    0,0,0,0);
   if thisError <> 0
    then inst := 0
    else
     if nr.tone.instrumentNumber > 0
      then inst := nr.tone.instrumentNumber
      else inst := nr.tone.gmNumber;

     if inst <> 0
      then name := nr.tone.instrumentName
      else name := 'Beep';   {if this happens I use the sound manager to play instead}

     //thisError :=
     CloseComponent(na);
   end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 pickInstrument(instr, instName);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 MoviesTask(nil,0);
end;

initialization
 InitializeQTML(0);
finalization
 TerminateQTML;
end.


