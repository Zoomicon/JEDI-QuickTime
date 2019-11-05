//Version: 23Dec2009 (by George Birbilis)

unit C_Types;

interface

 //C->Delphi mappings//
 type

  float=single; //don't use "real" type: it changed size from Delphi3 to Delphi4
  floatPtr=^float;
  floatHandle=^floatPtr;

  short=smallInt;
  shortPtr=^short;
  shortHandle=^shortPtr;

  int=integer;
  intPtr=^int;
  intHandle=^intPtr;

  long=longInt;
  longPtr=^long;
  longHandle=^longPtr;

  unsigned_char=AnsiChar; {byte} //Delphi's char is unsigned ("AnsiChar" will always be 8-bits, whereas "char" type may change in the future)
  unsigned_charPtr=^unsigned_char;
  charHandle=^unsigned_charPtr;

  unsigned_short=word;
  unsigned_shortPtr=^unsigned_short;

  unsigned_long=cardinal;
  unsigned_longPtr=^unsigned_long;

implementation

end.

