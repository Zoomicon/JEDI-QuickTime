//Version: 5Jul2003 (by George Birbilis)

unit C_Types;

interface

 //C->Delphi mappings//
 type float=single; //don't use "real" type: it changed size from Delphi3 to Delphi4
      floatPtr=^float;
      short=smallInt;
      shortPtr=^short;
      int=integer;
      intPtr=^int;
      long=longInt;
      longPtr=^long;
      unsigned_char=AnsiChar; {byte} //Delphi's char is unsigned ("AnsiChar" will always be 8-bits, whereas "char" type may change in the future)
      unsigned_charPtr=^unsigned_char;
      charHandle=^unsigned_charPtr;
      unsigned_short=word;
      unsigned_shortPtr=^unsigned_short;
      unsigned_long=cardinal;
      unsigned_longPtr=^unsigned_long;

implementation

end.


