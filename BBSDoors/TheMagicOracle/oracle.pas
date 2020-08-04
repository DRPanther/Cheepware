Program The_Magic_Oracle;

{ The Magic Oracle v15.4
  Written/developed by Sean Dennis
  (C)1998-2020 Sean Dennis-all rights reserved.
  This was developed using Turbo Pascal 7 and
  with FKFOSSIL v1.02.

  This source code and its accompanying documentation is being
  released under the Cheepware License.  The license should be
  part of this archive and is also available at:
  https://github.com/digimaus/Cheepware/blob/master/CheepwareLicense.txt

  Last touched 17 February 2020 at 1100 EDT. }

Uses DOS, CRT, FKFOSSIL, Doorunit;

Var
   TempFile : Text;
   IndexFile : File of Integer;
   Index, Count, Looper, RandomAnswer : Integer;
   TempLine, Answer : String;
   AnotherQuestion : Boolean;
   Ch : Char;
   RC : Integer;

Procedure CheckFiles;
Begin
  CatchError('answers.dat');
  CatchError('language.dat');
  If FExist('index.dat') Then
    Begin
      Assign(IndexFile, 'index.dat');
      {$I-}Reset(IndexFile);{$I+}
      CatchError('INDEX.DAT');
      Read(IndexFile, Index);
      Close(IndexFile);
    End
  Else
    Begin
      Count := 1;
      Assign(TempFile, 'answers.dat');
      {$I-}Reset(TempFile);{$I+}
      CatchError('ANSWERS.DAT');
      While Not EOF(TempFile) Do
        Begin
          ReadLn(TempFile, TempLine);
          If TempLine = '%' Then Inc(Count);
        End;
      Count := Count - 1;
      Close(TempFile);
      Assign(IndexFile, 'index.dat');
      {$I-}Rewrite(IndexFile);{$I+}
      Write(IndexFile, Count);
      Close(IndexFile);
    End;
End;

Procedure GetUserQuestion;
Begin
  fk_ClrScr;
  fk_WriteLn_ANSI('[2;1H[3;1H[9C[0;1;36mÉÍËÍ» Ë[9CÉÍËÍ»[17CÉÍÍ»[s', 0);
  fk_WriteLn_ANSI('[u[13C»[4;1H[11Cº   º[9Cº º º[9Co[7Cº  º[13Cº[5;1H[11Cº  [s', 0);
  fk_WriteLn_ANSI('[u ÌÍ» ÉÍ»   º º º ÉÍ» ÉÍ» Ë ÉÍ»   º  º ËÍ» ÉÍ» ÉÍ» º ÉÍ»[6;1H[s', 0);
  fk_WriteLn_ANSI('[u[11Cº   º º ÌÍ¼   º º º ÉÍ¹ º º º º[5Cº  º º   ÉÍ¹ º   º ÌÍ¼', 0);
  fk_WriteLn_ANSI('[7;1H[11CÊ   Ê Ê ÈÍ¼   Ê Ê Ê ÈÍÈ ÈÍ¹ Ê ÈÍ¼   ÈÍÍ¼ Ê   ÈÍÈ ÈÍ¼ Ê È[s', 0);
  fk_WriteLn_ANSI('[uÍ¼[8;1H[11C[35mVersion 15.4[14C[36mº[12C[31m(C)2020 Sean [s', 0);
  fk_WriteLn_ANSI('[uDennis[9;1H[35C[36mÈÍ¼[10;1H[11C[30mÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ[s', 0);
  fk_WriteLn_ANSI('[uÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ[0m', 1);
  fk_GotoXY(1,11);
  pWrite('`0BYour question for the Magic Oracle (press `0FENTER`0B to abort):`0F', True, True);
  TempLine := ReadIn(4, 74, False, 14, 1);
  If TempLine = '' then Goodbye;
End; {GetUserQuestion}

Procedure AnswerQuestion;
Begin
  Looper := 1;
  RandomAnswer := 0;
  Randomize;
  Repeat
    RandomAnswer := (Random(Index));
  Until (RandomAnswer >=1) or (RandomAnswer <=Index);
  Assign(TempFile, 'answers.dat');
  {$I-}Reset(TempFile);{$I+}
  CatchError('ANSWERS.DAT');
  Repeat
     ReadLn(TempFile, Answer);
     If Answer = '%' Then Inc(Looper);
   Until (Looper = RandomAnswer) or (Looper = Index);
  fk_GotoXy(1,11);
  fk_ClrEol;
  SRFColor('You asked the Oracle this question:', True);
  fk_ClrEol;
  pWrite('`0E' + Templine, True, True);
  NL;
  NL;
  SRFColor('The Oracle has consulted the stars and says:', True);
  Repeat
    ReadLn(Tempfile, Answer);
    If Answer <> '%' Then
      Begin
        pWrite(Answer, True, True);
      End;
  Until Answer = '%';
  Close(TempFile);
  NL;
  NL;
  pWrite('`0AWould you like to ask another question? `08[`0EY`08/`0EN`08]', True, True);
  Ch := LimitedInput('YN');
End; {AnswerQuestion}

Begin {Main block}
  fk_ProgramInfo.Title   := 'The Magic Oracle';
  fk_ProgramInfo.Version := '15.4';
  fk_ProgramInfo.Author  := 'Sean Dennis';
  fk_ProgramInfo.Other   := '(C)2020 Sean Dennis';
  fk_Host.Titleline      := True;
  StartDoor('ORACLE');
    Repeat
      CheckFiles;
      GetUserQuestion;
      AnswerQuestion;
    Until (Ch = 'N');
  Goodbye;
End.
