Program Chinese_Zodiac;

{ Chinese Zodiac v4.7 - (C) 2020 Sean Dennis.
  Developed using Turbo Pascal 7 and FKFOSSIL v1.02.

  This source code and its accompanying documentation is being
  released under the Cheepware License.  The license should be
  part of this archive and is also available at:
  https://github.com/digimaus/Cheepware/blob/master/CheepwareLicense.txt

  Last modified 17 February 2020 at 1100 EDT. }

Uses
  DOS, CRT, FKFOSSIL, DOORUNIT;

Var
  DatFileNum, Loop, X, Y : Integer;
  Tempfile : Text;
  Filename, TempStr, UserYear : String;
  Choice : Char;

Const
   Signs : Array [1..12] of String[10] = ('Goat', 'Monkey',
    'Cock', 'Dog', 'Boar', 'Rat', 'Ox', 'Tiger', 'Rabbit',
    'Dragon', 'Snake', 'Horse');

Procedure GetYear;
  Begin
     fk_ClrScr;
     fk_WriteLn_ANSI('[2;1H[5C[0;1mÜÛÛÛ[30mÛÛÛÜ[9C[0;34mÚÄ¿ Â Â ÚÂ¿ Ú¿Ú ÂÄ[s', 0);
     fk_WriteLn_ANSI('[u¿ ÚÄ¿ ÂÄ¿   ÚÄÄ¿ ÚÄ¿ ÂÄ¿ ÚÂ¿  Ú¿  ÚÄ¿[3;1H    [1;37mÛÛ[30mÛÛ[37mÛ[s', 0);
     fk_WriteLn_ANSI('[u[30mÛÛÛÛÛ[8C[34m³   ³Ä´  ³  ³³³ ³Ä  ÀÄ¿ ³Ä    ÚÄÄÙ ³ ³ ³ ³  ³  Ú´Ã[s', 0);
     fk_WriteLn_ANSI('[u¿ ³[4;1H   [37mÛÛÛÛÛÛ[30mÛÛÛÛÛÛ[7C[37mÁÄÙ Á Á ÀÁÙ ÙÀÙ ÁÄÙ ÀÄÙ ÁÄ[s', 0);
     fk_WriteLn_ANSI('[uÙ   ÀÄÄÙ ÀÄÙ ÁÄÙ ÀÁÙ À  Ù ÁÄÙ[5;1H    ÛÛÛÛÛ[30mÛ[37mÛÛ[30mÛÛ[11C[s', 0);
     fk_WriteLn_ANSI('[u[0;36mVersion 4.7 -- Developed & (C)2020 by Sean Dennis[6;1H[5C[s', 0);
     fk_WriteLn_ANSI('[u[1;37mßÛÛÛ[30mÛÛÛß[7;1H   ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ[s', 0);
     fk_WriteLn_ANSI('[uÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ[0m', 0);
     NL;
     pWrite('`0EEnter the year you were born (1907 or later) or `0CENTER`0E to quit: `0A', True, True);
     Repeat
       fk_GotoXY(38, 10);
       fk_ClrEOL;
       UserYear := ReadIn(38, 4, False, 14, 1);
       Val(UserYear, Y, X);
       If Y = 0 then Goodbye;
     Until Y >= 1907;
     DatFileNum := (Y-1907) MOD 12 + 1;
  End;

Procedure ShowYear;
  Begin
    fk_GotoXY(1,8);
    fk_ClrEOL;
    pWrite('`0BYou were born under the sign of the `0E' + Signs[DatFileNum] + '`0B in `0F' + UserYear +'`0B.', True, True);
    fk_ClrEOL;
    NL;
    Filename := IntToStr(DatFileNum)+'.dat';
    Assign(Tempfile, Filename);
    {$I-}Reset(Tempfile);{$I+}
    Repeat
      ReadLn(Tempfile, TempStr);
      pWrite(TempStr, True, True);
    Until Eof(Tempfile);
    Close(Tempfile);
    pWrite('`0BWould you like to try another year? `08[`0EY`08/`0EN`08]`07', True, True);
    Choice := LimitedInput('YN');
  end;

Begin
  fk_ProgramInfo.Title := 'Chinese Zodiac';
  fk_ProgramInfo.Version := '4.7';
  fk_ProgramInfo.Author := 'Sean Dennis';
  fk_ProgramInfo.Other := '(C)2020 Sean Dennis';
  fk_Host.TitleLine := True;
  StartDoor('CZODIAC');
  CursorHide;
  Repeat
    GetYear;
    ShowYear;
  Until Choice = 'N';
  CursorShow;
  Goodbye;
End.
