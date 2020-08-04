Program Dr_Seuss_Purity_Test;

{ Dr. Seuss Purity Test v2.2
  Written and (C) 2020 by Sean Dennis
  All rights reserved.

  This source code and its accompanying documentation is being
  released under the Cheepware License.  The license should be
  part of this archive and is also available at:
  https://github.com/digimaus/Cheepware/blob/master/CheepwareLicense.txt

  Last touched 17 February 2020 at 1100 EST. }

Uses 
  DOS, CRT, FKFOSSIL, DOORUNIT;

Var
  Tempfile : Text;
  Purity, No, Loop : Integer;
  Question, Answer, Temp, Title : String;
  Ch : Char;
  Prompt : Array [1..4] of String;

Procedure TakeTheTest;
Begin
  CatchError('QUESTION.DAT');
  Assign(Tempfile, 'question.dat');
  {$I-}Reset(Tempfile);{$I+}
  fk_ClrScr;
  fk_GotoXY(1,3);
  IceText(Title, True, True);
  Loop := 1;
  No := 0;
  Repeat
    ReadLn(Tempfile, Question); {Get the next question}
    fk_Gotoxy(1,9);
    fk_ClrEol;
    IceText('Question #' + IntToStr(Loop) + ' of 50', True, True);
    fk_GotoXy(1,11);
    fk_ClrEol;
    pWrite('`0D' + Question, True, True);
      Repeat
        fk_GotoXY(1,13); fk_ClrEol;
        IceText('Y or N (Q to quit): ',False, True);
        Answer := LimitedInput('YNQ');
        If Answer = 'N' then Inc(No)
          Else
        If Answer = 'Q' then Goodbye;
      Until Answer <> '';
    Inc(Loop);
    If (Loop >=51) then Loop := 51;
  Until (Loop = 51); { Loop }
  Purity := No * 2;
  fk_GotoXY(1,13); fk_ClrEol; fk_Gotoxy(1,11); fk_ClrEol;
  pWrite('Your purity score is: ' + IntToStr(Purity) + ' percent.', False, True);
  Close(TempFile);
  fk_GotoXY(1,13);
  pWrite('`0FPress `0B<SPACE> `0Fto take the test again or `0B<ESC> `0Fto quit...', False, True);
  Repeat
    Ch := fk_Read;
     If (Ch = #32) then TakeTheTest;
     If (Ch = #27) then Goodbye;
  Until (Answer = #32) or (Answer = #27);
End; { Procedure TakeTheTest }

Procedure Instructions;
Begin
  fk_ClrScr;
  IceText(Title, True, True);
  nl;
  pWrite('`0BYOU MUST BE 18 OR OLDER TO USE THIS DOOR!', True, True);
  nl;
  pWrite('`0FPress `0AY`0F to continue or `0AN`0F to exit.', True, True);
  Temp := LimitedInput('YN');
  If Temp = 'N' Then Goodbye;
  fk_ClrScr;
  IceText(Title, True, True);
  NL;
  IceText('Do you want instructions [Y/N/Q]?', True, True);
  Ch := LimitedInput('YNQ');
  Case Ch Of
    'Y' :
      Begin
       fk_ClrScr;
       IceText(Title, True, True);
       nl;
       pWrite('`0EThis door is a "purity test" door, meaning that by answering certain', True, True);
       pWrite('questions, the door will determine how "sexually pure" you are.  `0AYou must', True, True);
       pWrite('be at least 18 years old or older to use this door!  If you are not, you must', True, True);
       pWrite('leave the door NOW.', True, True);
       nl;
       pWrite('`0DIf you''re easily offended by sexual and/or off-color remarks or suggestions,', True, True);
       pWrite('you need to leave this door NOW and never come back.  Your sysop will not be', True, True);
       pWrite('held responsible for any hurt feelings or insults if you continue to use', True, True);
       pWrite('this door!', True, True);
       nl;
       pWrite('`0FThis door is based on the original Dr. Seuss Purity Test as written by',True, True);
       pWrite('`0BWilliam Elton`0F.', True, True);
       nl;
       nl;
       IceText('Press ENTER to continue or any other key to exit the door.', True, True);
       Repeat
        Ch := UpKey;
       Until (Ch <> '');
       If (Ch = #13) Then TakeTheTest
         Else Goodbye;
      End;

    'Q' :
      Begin
        Goodbye;
      End;

    'N' :
      Begin
        TakeTheTest;
      End;
    Else
  End; { End Case }
End; { End Procedure Instructions }

Begin
  fk_ProgramInfo.Title   := 'Dr. Seuss Purity Test';
  fk_ProgramInfo.Version := '2.2';
  fk_ProgramInfo.Author  := 'Sean Dennis';
  fk_ProgramInfo.Other   := '(C)2020 Sean Dennis';
  fk_Host.TitleLine      := True;
  Title := 'Dr. Seuss Purity Test -- v' + fk_ProgramInfo.Version + ' -- (C) Sean Dennis';
  StartDoor('DRSEUSS');
  Instructions;
  TakeTheTest;
End.
