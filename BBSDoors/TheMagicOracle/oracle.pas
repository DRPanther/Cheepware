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
  fk_WriteLn_ANSI('[2;1H[3;1H[9C[0;1;36m���ͻ �[9C���ͻ[17C��ͻ[s', 0);
  fk_WriteLn_ANSI('[u[13C�[4;1H[11C�   �[9C� � �[9Co[7C�  �[13C�[5;1H[11C�  [s', 0);
  fk_WriteLn_ANSI('[u �ͻ �ͻ   � � � �ͻ �ͻ � �ͻ   �  � �ͻ �ͻ �ͻ � �ͻ[6;1H[s', 0);
  fk_WriteLn_ANSI('[u[11C�   � � �ͼ   � � � �͹ � � � �[5C�  � �   �͹ �   � �ͼ', 0);
  fk_WriteLn_ANSI('[7;1H[11C�   � � �ͼ   � � � ��� �͹ � �ͼ   ��ͼ �   ��� �ͼ � �[s', 0);
  fk_WriteLn_ANSI('[uͼ[8;1H[11C[35mVersion 15.4[14C[36m�[12C[31m(C)2020 Sean [s', 0);
  fk_WriteLn_ANSI('[uDennis[9;1H[35C[36m�ͼ[10;1H[11C[30m����������������������[s', 0);
  fk_WriteLn_ANSI('[u������������������������������������[0m', 1);
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
