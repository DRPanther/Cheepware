Unit Doorunit;

{ DOORUNIT v20.1d
  (C) 2020 Sean Dennis

  This is a unit written for use with my Cheepware doors.

  This unit contains code written by Michael Preslar,
  Larry Athey, Mark Lewis, Shawn Highfield,
  Doug Reynolds, Michael Dillon, et al. with permission.

  The rest is (C)Sean Dennis.

  Developed/compiled using Turbo Pascal 7 (RTE200 patched).

  This unit is being released under the Cheepware License.
  https://github.com/digimaus/Cheepware/blob/master/CheepwareLicense.txt

  Last modified 17 February 2020 at 1330 EST. }

Interface

Uses
  CRT, DOS, FKFOSSIL;

Type
  Video_Buffer = ARRAY[1..4000] OF BYTE;

Var
  ForceANSI, Loc, PausePrompt, ScreenClear : Boolean;
  VBuff : ^Video_Buffer;
  Doorname, Path: String;
  Y, M, D, DOW, Today : Word;

Const
  Days : Array [0..6] of String[9] =
    ('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');
  TDays : Array[Boolean,0..12] of Word =
         ((0,31,59,90,120,151,181,212,243,273,304,334,365),
          (0,31,60,91,121,152,182,213,244,274,305,335,366));
  Months : Array [0..11] of String[10] =
    ('January', 'February', 'March', 'April', 'May', 'June', 'July',
         'August', 'September', 'October', 'November', 'December');

Function  AllCaps(S : String) : String;
Procedure AnyKey(PString : String; NewLine : Boolean; Centered : Boolean);
Function  BlankLine(Num : Byte) : String;
Function  BooleanToStr(B : Boolean) : String;
Procedure CatchError(Filename : String);
Procedure CommandLineHelp;
Function  CurrentPath(Filename : String) : String;
Procedure CursorHide;
Procedure CursorShow;
Function  DOY : Word;
Function  Dup(Ch : Char; Times : Byte) : String;
Procedure ErrorChecking;
Function  FExist(Fn : Pathstr) : Boolean;
Function  GetFileName(Instring : String) : String;
Function  GetFilePath(Instring : String) : String;
Procedure Goodbye;
Procedure IceText(TempStr : String; LF : Boolean; Centered: Boolean);
Function  IntToStr(N : Longint) : String;
Function  LimitedInput(Legal : String):Char;
Procedure Line;
Procedure NL;
Function  Numpad(I : Longint; Len : Byte) : String;
Function  PipeStringLength (ST : String) : Byte;
Procedure pWrite(Inp : String; NL : Boolean; Centered : Boolean);
Function  ReadIn(X: Byte; Len: Byte; Up: Boolean; FG: Byte; BG: Byte) : String;
Procedure RestoreScreen;
Function  ReturnDate(Style : Char) : String;
Procedure RFColor;
Procedure SaveScreen;
Procedure SRFColor(S : String; Centered : Boolean);
Procedure StartDoor(DName : String);
Function  StripBoth(St : String; Ch : Char) : String;
Function  StripLead(St : String; Ch : Char) : String;
Function  StripTrail(St : String; Ch : Char) : String;
Function  StrToInt(S : String) : Longint;
Procedure TrimFile(Fname: String;Numlines: Integer);
Procedure UpCaseStr(St : String);
Function  UpKey : Char;
Function  YesNo : Boolean;

Implementation

{ -------------------------------------------------------------------
  FUNCTION AllCaps
  Converts a string to all capital letters
  From the TDK doorkit
  ------------------------------------------------------------------- }
FUNCTION AllCaps(S : STRING) : STRING;
VAR
  SLen : BYTE ABSOLUTE S;
  X    : INTEGER;
BEGIN
  FOR X := 1 TO SLen DO S[X] := UPCASE(S[X]);
  AllCaps := S;
END;

{ -------------------------------------------------------------------
  Procedure AnyKey(PString : String; NewLine : Boolean; Centered : Boolean);
  Displays pause string
  Based on code from TDK
  ------------------------------------------------------------------- }
Procedure AnyKey(PString : String; NewLine : Boolean; Centered : Boolean);
Var
  Ch : Char;
Begin
  If PString = '' Then PString := '`01°±²`1F Press any key to continue `01²±°';
  NL;
  pWrite(PString, NewLine, Centered);
  Ch := fk_Read;
End;


{ -------------------------------------------------------------------
  PROCEDURE BlankLine
  Displays a blank line of variable length
  ------------------------------------------------------------------- }
Function BlankLine(Num : Byte) : String;
Var
  T : String;
Begin
  T := Dup(' ', Num);
  pWrite(T, False, False);
End;


{ -------------------------------------------------------------------
  FUNCTION BooleanToStr
  Converts a Boolean value to "True" or "False"
  From TDK
  ------------------------------------------------------------------- }
Function BooleanToStr(B : Boolean) : String;
Begin
  If B Then BooleanToStr := 'True' Else BooleanToStr := 'False';
End;


{ -------------------------------------------------------------------
  Procedure CatchError(Filename : String; RC : Integer);
  Captures file errors
  ------------------------------------------------------------------- }
Procedure CatchError(Filename : String);
Var
  ErrDesc : String;
  Ch : Char;
  RC : Integer;
Begin
  RC := IOResult;
  If (RC = 0) Then Exit;
  If Loc Then ClrScr Else fk_ClrScr;
  pWrite('`0C*** ERROR ***', True, True);
  NL;
  pWrite('`0EAn error ' + IntToStr(RC) + ' has occured with ' + Filename + '`0E.', True, True);
  NL;
  Case RC Of
       1: ErrDesc := 'Invalid function number';
       2: ErrDesc := 'File not found';
       3: ErrDesc := 'Path not found';
       4: ErrDesc := 'Too many open files';
       5: ErrDesc := 'File access denied';
       6: ErrDesc := 'Invalid file handle';
      12: ErrDesc := 'Invalid file access code';
      15: ErrDesc := 'Invalid drive number';
      16: ErrDesc := 'Cannot remove current directory';
      17: ErrDesc := 'Cannot rename across drives';
     100: ErrDesc := 'Disk read error';
     101: ErrDesc := 'Disk write error';
     102: ErrDesc := 'File not assigned';
     103: ErrDesc := 'File not open';
     104: ErrDesc := 'File not open for input';
     105: ErrDesc := 'File not open for output';
     106: ErrDesc := 'Invalid numeric format';
     150: ErrDesc := 'Disk is write-protected';
     151: ErrDesc := 'Bad drive request struct length';
     152: ErrDesc := 'Drive not ready';
     154: ErrDesc := 'CRC error in data';
     156: ErrDesc := 'Disk seek error';
     157: ErrDesc := 'Unknown media type';
     158: ErrDesc := 'Sector not found';
     159: ErrDesc := 'Printer out of paper';
     160: ErrDesc := 'Device write fault';
     161: ErrDesc := 'Device read fault';
     162: ErrDesc := 'Hardware failure';
     200: ErrDesc := 'Division by zero';
     201: ErrDesc := 'Range check error';
     202: ErrDesc := 'Stack overflow error';
     203: ErrDesc := 'Heap overflow error';
     204: ErrDesc := 'Invalid pointer operation';
     205: ErrDesc := 'Floating point overflow';
     206: ErrDesc := 'Floating point underflow';
     207: ErrDesc := 'Invalid floating point operation';
     210: ErrDesc := 'Object not initialized';
     211: ErrDesc := 'Call to abstract method';
     212: ErrDesc := 'Stream registration error';
     213: ErrDesc := 'Collection index out of range';
     214: ErrDesc := 'Collection overflow error';
     215: ErrDesc := 'Arithmetic overflow error';
     216: ErrDesc := 'General protection fault';
     217: ErrDesc := 'Unhandled exception occured';
     219: ErrDesc := 'Invalid typecast';
     222: ErrDesc := 'Variant dispatch error';
     223: ErrDesc := 'Variant array create';
     224: ErrDesc := 'Variant is not an array';
     225: ErrDesc := 'Var array bounds check error';
     227: ErrDesc := 'Assertion failed error';
     229: ErrDesc := 'Safecall error check';
     231: ErrDesc := 'Exception stack corrupted';
     232: ErrDesc := 'Threads not supported';
  Else
    ErrDesc := 'Unknown error';
  End;
  pWrite('`0BError description: `0C' + ErrDesc + '.',True ,True);
  NL;
  pWrite('`0DPlease consult this program''s documentation for further instructions on', True ,True);
  pWrite('how to handle an error.', True ,True);
  NL;
  pWrite('`0APress any key to stop the program.`07', True, True);
  { Turn off file locking if engaged }
  If Filemode = 34 Then Filemode := 66;
  If Loc Then
    Begin
      Ch := ReadKey;
      Halt;
    End
  Else
    Begin
      Ch := fk_Read;
      fk_DeInitFOSSIL;
    End;
End;


{ -------------------------------------------------------------------
  PROCEDURE CommandLineHelp
  Displays command line help
  ------------------------------------------------------------------- }
Procedure CommandLineHelp;
Begin
  Loc := True;
  ClrScr;
  NL;
  IceText(fk_ProgramInfo.Title + ' ' + fk_ProgramInfo.Version, True, False);
  IceText('(C)2020 Sean Dennis.  All rights reserved.', True, False);
  IceText('Another Cheepware production!', True, False);
  IceText('========================================================================', True, False);
  pWrite('`03Example: `0C' + DoorName + '.EXE /DD:\BBS\DOOR.SYS', True, False);
  pWrite('         `0C' + DoorName + '.EXE /N%1 /DD:\BBS\NODE%1\DORINFO1.DEF', True, False);
  NL;
  pWrite('`0E/N `0BNode number `0C(not needed with DOOR.SYS)', True, False);
  pWrite('`0E/D `0BFull path and filename of dropfile', True, False);
  pWrite('`0E/F `0BForce ANSI emulation on', True, False);
  pWrite('`0E/L `0BRun in local mode', True, False);
  If (Doorname = 'QOTD') Then
    Begin
      pWrite('`0E/C `0BToggles screen clearing (default: on)', True, False);
      pWrite('`0E/P `0BToggles "pause prompt"  (default: on)', True, False);
    End;
  pWrite('`0E/? `0BThis help screen', True, False);
  NL;
  Halt;
End;


{ -------------------------------------------------------------------
  FUNCTION CurrentPath(Filename : String) : String;
  Gets the current path for Filename and returns a string with
  the full filepath plus the filename.
  (I don't know why I keep this in here; I don't really use it.)
  ------------------------------------------------------------------- }
Function CurrentPath(Filename : String) : String;
Begin
  CurrentPath := GetFilePath(Filename) + Filename;
End;


{ -------------------------------------------------------------------
  PROCEDURE CursorHide;
  Turns off the cursor using an ANSI sequence (that's a lowercase L
  in the command).  May not work in all cases.
  ------------------------------------------------------------------- }
Procedure CursorHide;
Begin
  fk_WriteLn_ANSI(Chr(27) + '[25l', 0);
End;

{ -------------------------------------------------------------------
  PROCEDURE CursorShow;
  Turns on the cursor using an ANSI sequence.  May not work in all
  cases.
  ------------------------------------------------------------------- }
Procedure CursorShow;
Begin
  fk_WriteLn_ANSI(Chr(27) + '[25h', 0);
End;


{ -------------------------------------------------------------------
  FUNCTION DOY : Word;
  Returns the number of the current day of the year in the current
  year.  Valid for 1901-2078.  From SWAG.

  Uses PackedDate.  Use this to call get the current DOY:
    Today := DOY(ReturnDate(Y, M, D));
  ------------------------------------------------------------------- }
Function DOY : Word;
Var
  Temp  : Word;
  LeapYear : Boolean;
Begin
  GetDate(Y, M, D, DOW);
  LeapYear := (Y Mod 4 = 0);
  Temp  := TDays[LeapYear][M - 1];
  Inc(Temp, D);
  DOY := Temp;
End;

{ -------------------------------------------------------------------
  FUNCTION Dup
  Creates a string x long of a character
  From the TDK doorkit
  ------------------------------------------------------------------- }
FUNCTION Dup(Ch : CHAR; Times : BYTE) : STRING;
VAR
  Temp : STRING;
BEGIN
  FILLCHAR(Temp[1],Times,Ch);
  Temp[0] := CHAR(Times);
  Dup := Temp;
END;


{ -------------------------------------------------------------------
  PROCEDURE ErrorChecking;
  Checks for errors with FOSSIL and dropfiles
  ------------------------------------------------------------------- }
Procedure ErrorChecking;
Var
  Error : String;
Begin
If fk_Host.Error = 0 Then Exit
  Else
    Begin
      Case fk_Host.Error Of
        1 : Error := 'FOSSIL driver not initialized';
        2 : Error := 'Error initializing FOSSIL driver';
        9 : Error := 'System can''t find a dropfile';
       10 : Error := 'Function not compatible with user''s screen mode';
       11 : Error := 'Invalid call to function';
      End;
      pWrite('`0BWARNING: `14' + Error + '!`07', True, True);
      If Loc Then Halt Else fk_DeInitFOSSIL;
    End;
End;


{ -------------------------------------------------------------------
  FUNCTION FExist
  Checks to see if a file exists
  From TDK
  ------------------------------------------------------------------- }
FUNCTION FExist(Fn : PathStr) : BOOLEAN;
VAR
  DirInfo : SEARCHREC;
BEGIN
  FINDFIRST(Fn,Anyfile - Directory - VolumeID,DirInfo);
  FExist := DOSERROR = 0;
END;


{ -------------------------------------------------------------------
  FUNCTION GetFileName
  Returns a filename from a fully qualified path string
  From TDK
  ------------------------------------------------------------------- }

FUNCTION GetFileName(InString : STRING) : STRING;
VAR
  Work : BYTE;
BEGIN
  InString := StripBoth(InString,' ');
  REPEAT
    Work := POS('\',InString);
    IF Work <> 0 THEN DELETE(InString,1,Work);
  UNTIL Work = 0;
  GetFileName := InString;
END;


{ -------------------------------------------------------------------
  FUNCTION GetFilePath
  Returns a file's full path
  From TDK
  ------------------------------------------------------------------- }
FUNCTION GetFilePath(InString : STRING) : STRING;
VAR
  Loop : BYTE;
BEGIN
  InString := StripBoth(InString,' ');
  IF InString[LENGTH(InString)] = '\' THEN BEGIN
    GetFilePath := InString;
    EXIT;
  END;
  Loop := LENGTH(InString);
  REPEAT DEC(Loop) UNTIL ((Loop = 0) OR (InString[Loop] = '\'));
  IF Loop <> 0 THEN DELETE(InString,Loop + 1,LENGTH(InString) - Loop) ELSE InString := '';
  GetFilePath := InString;
END;


{ -------------------------------------------------------------------
  PROCEDURE Goodbye
  Displays closing program ad and deinitializes the doorkit/FOSSIL
  ------------------------------------------------------------------- }
Procedure Goodbye;
Var
  Temp : String;
Begin
  Temp := Dup('Ä' , 75);
  fk_ClrScr;
  fk_GotoXY(1,7);
  IceText(Temp, True, True);
  IceText(fk_ProgramInfo.Title + ' ' + fk_ProgramInfo.Version, True, True);
  IceText('(C)2020 Sean Dennis - another Cheepware production!', True, True);
  NL;
  IceText('FKFOSSIL v1.02 (C)1993-1994 by Tim Strike and Forbidden Knights Systems', True, True);
  NL;
  pWrite('`0FThis door was made in the USA. `1F***`4F'+ Chr(220) + Chr(220) + Chr(220) + '`07', True, True);
  IceText(Temp, True, True);
  NL;
  AnyKey('', True, True);
  { Turn off file locking if engaged }
  If Filemode = 34 Then Filemode := 66;
  If Loc Then
    Begin
      TextColor(7);
      TextBackground(0);
      Halt;
    End
   Else
    Begin
      fk_TextForeground(7);
      fk_TextBackground(0);
      fk_FlushOutputBuffer;
      fk_DeInitFossil;
    End;
End;


{ -------------------------------------------------------------------
  PROCEDURE IceText
  Displays text in the "Ice Technologies" style
  Based on code from TDK but heavily modified by me
  ------------------------------------------------------------------- }
Procedure IceText(TempStr : String; LF : Boolean; Centered: Boolean);
Var
   TLength : Byte;
   Loop    : Byte;
   TLen    : Integer;
Begin
   TLength := Length(TempStr);
   If Centered Then If Loc Then GotoXY(40 - (TLength Div 2), WhereY)
     Else fk_GotoXY(40 - (TLength div 2), WhereY);
  For Loop := 1 To TLength Do Begin
     If (ORD(TempStr[Loop]) >= 65) And (ORD(TempStr[Loop]) <= 90) Then
       If Loc Then TextColor(15) Else fk_TextForeground(15) Else
     If (ORD(TempStr[Loop]) >= 97) And (ORD(TempStr[Loop]) <= 122) Then
       If Loc Then TextColor(11) Else fk_TextForeground(11) Else
     If (ORD(TempStr[Loop]) > 127) Or (ORD(TempStr[Loop]) < 32) Then
       If Loc Then TextColor(1) Else fk_TextForeground(1)
     Else If Loc Then TextColor(1) Else fk_TextForeground(9);
     If Loc Then Write(TempStr[Loop]) Else fk_Write(TempStr[Loop]);
  End;
  If LF Then NL;
  TempStr := '';
End;


{ -------------------------------------------------------------------
  FUNCTION IntToStr
  Converts an integer to a string
  ------------------------------------------------------------------- }
Function IntToStr(N : LongInt) : String;
Var
  St : String;
Begin
  Str(N, St);
  IntToStr := St;
End;


{ -------------------------------------------------------------------
  FUNCTION LimitedInput
  Gets a key from the keyboard limited to the characters in a
  specified string
  ------------------------------------------------------------------- }
Function LimitedInput(Legal : String): Char;
Var
  C : Char;
Begin
   Repeat
   C := UpCase(fk_Read);
   If Pos(C, Legal) <> 0 then
     Begin
       LimitedInput := C;
       Exit;
     End;
   Until Pos(C, Legal) <> 0;
End;


{ -------------------------------------------------------------------
  PROCEDURE Line
  Displays a line of '-' 79 chars in length
  ------------------------------------------------------------------- }
Procedure Line;
Begin
  pWrite(Dup('-', 79), True, False);
End;


{ -------------------------------------------------------------------
  PROCEDURE NL
  Displays a blank line
  ------------------------------------------------------------------- }
Procedure NL;
Begin
  If Loc Then WriteLn('') Else fk_WriteLn('', 1);
End;


{ -------------------------------------------------------------------
  FUNCTION Numpad
  Pads numbers with zeros to x length
  ------------------------------------------------------------------- }
Function numpad(i: longint;len: byte): String;
 Var S: String;
 Begin
  S := InttoStr(i);
  if length(s) < len then While length(s) < len Do S := '0' + S;
  NumPad := S;
 End;


{ --------------------------------------------------------------------
  FUNCTION PipeStringLength (ST : String) : Byte;
  This computes the correct length of a string that has
  my pipe codes in it to be properly centered.

  Based on code originally by Michael Preslar and further
  modified by Sean Dennis.
  -------------------------------------------------------------------- }
Function PipeStringLength (ST : String) : Byte;
Var
  B  : Byte;
  S1 : String;
Begin
  S1 := '';
  If Length(ST) < 1 Then
  Begin
    PipeStringLength := 0;
    Exit;
  End;
  B := 1;
  While B <= Length(ST) do
  Begin
    If (ST[B] = '`') Then
    Begin
      If (ST[B + 1] In ['0'..'7']) And (ST[B + 2] In ['0'..'F']) Then
        Inc(B, 2)
    End
    Else
      S1 := S1 + ST[B];
    Inc(B);
  End;
  PipeStringLength := Length(S1);
End;


{ --------------------------------------------------------------------
  Procedure pWrite(Stream: String255; LF: Boolean; Centered: Boolean);
  Based on code by Doug Reynolds but heavily modified by me.  No pipe
  color code support; just TG-style (more compact).
  -------------------------------------------------------------------- }
Procedure pWrite(Inp : String; NL : Boolean; Centered : Boolean);
Var
  A, Error, Len : Integer;
  B, C : Byte;
  IncA, Blink : Boolean;

Begin
  If Centered Then If Loc Then GotoXY(40 - PipeStringLength(Inp) Div 2, WhereY) Else
    fk_GotoXY(40 - PipeStringLength(Inp) Div 2, WhereY);
  For A := 1 to Length(Inp) do
    Begin
      Blink := False;
      IncA := False;
      B := 0;
      If (Inp[A] = '`') And (Length(Inp) - A >= 2) Then
        Case Inp[A + 1] Of '0'..'9', 'A'..'F':
          Case Inp[A + 2] Of '0'..'9', 'A'..'F':
            Begin {convert loop Begin}
              Case Inp[A + 1] Of
              '0'..'7':
                Begin
                  Val(Inp[A + 1], B, Error);
                  If Loc Then TextBackground(B) Else fk_TextBackground(B);
                End
              Else
                Begin
                  Blink := True;
                  Case Inp[A + 1] Of
                    'A'..'F': B := Ord(Inp[A + 1]) - 55;
                  End;
                  B := B - 8;
                  If Loc Then TextBackground(B) Else fk_TextBackground(B);
                End;
              End;
              Case Inp[A + 2] Of '0'..'9':
                Begin
                  Val(Inp[A + 2], B, Error);
                  If Blink Then B := B +  128;
                  If Loc Then TextColor(B) Else fk_TextForeground(B);
                End
              Else
                Begin
                  B := Ord(Inp[A + 2]) - 55;
                  If Blink Then B := B + 128;
                  If Loc Then TextColor(B) Else fk_TextForeground(B);
                End;
              End;
              IncA := True;
            End; {convert loop End}
          End;
        End;
      If IncA Then A := A +  2;
      If Not IncA Then If Loc Then Write(Inp[A]) Else fk_write(Inp[A]);
    End;
  If NL Then If Loc Then WriteLn Else fk_WriteLn('', 1) Else
    If Loc Then Write('') Else fk_Write('');
End;


{ -------------------------------------------------------------------
  Function ReadIn(X: Byte; Len: Byte; Up: Boolean; FG: Byte;
    BG: Byte) : String;
  Does basic input for a string allowing backspace.
  Works only when FOSSIL initialized (no local use).

  X   : Column location (if 0, just assumes current position)
  Len : Length of input field
  Up  : Uppercase (True) or lowercase (False)
  FG  : Foreground color for prompt
  BG  : Background color for prompt

  When done, FG/BG set to 7 (gray) and 0 (black).
  ------------------------------------------------------------------- }
Function ReadIn(X: Byte; Len: Byte; Up: Boolean; FG: Byte; BG: Byte) : String;
Var
 Inkey   : Char;
 InString: String;
Begin
  fk_TextForeground(FG); fk_TextBackground(BG);
  fk_GotoXY(X, WhereY);
  pWrite(Dup(' ', Len), False, False);
  fk_GotoXY(X, WhereY);
  ReadIn := fk_ReadLn(Len, Up);
  fk_TextForeground(7); fk_TextBackground(0);
End;


{ -------------------------------------------------------------------
  FUNCTION ReturnDate (Style : Char) : String;
  Returns today's date in these formats:
    ReturnDate('N'): MM/DD/YYY
    ReturnDate('D'): DDDDDDD MM/DD/YYYY
    ReturnDate('F'): DDDDDDD DD MonthName YYYY
    ReturnDate('O'): DDDDDDD DD MonthName YYYY (day DOY) [my
          preferred style for my ALLFILES/NEWFILES FILE_ID.DIZ
          date listing)
  ------------------------------------------------------------------- }
Function ReturnDate(Style : Char) : String;
Begin
  GetDate(Y, M, D, DOW);
  Style := UpCase(Style);
  Case Style Of
    'N' : ReturnDate := IntToStr(M) + '/' + IntToStr(D) + '/' + IntToStr(Y);
    'D' : ReturnDate := Days[DOW] + ' ' + IntToStr(M) + '/' + IntToStr(D) + '/' + IntToStr(Y);
    'F' : ReturnDate := Days[DOW] + ' ' + IntToStr(D) + ' ' + Months[M] + ' ' + IntToStr(Y);
    'O' : ReturnDate := Days[DOW] + ' ' + IntToStr(D) + ' ' + Months[M] + ' ' + IntToStr(Y) +
          ' ' + '(day ' + IntToStr(DOY) + ')';
   Else
  End;
End;


{ -------------------------------------------------------------------
  PROCEDURE RestoreScreen
  Restores screen saved to high memory
  From TDK
  ------------------------------------------------------------------- }
PROCEDURE RestoreScreen;
BEGIN
  IF VBuff = NIL THEN EXIT;
  MOVE(VBuff^,Mem[$B800 : 0000],4000);
  DISPOSE(VBuff);
  VBuff := NIL;
END;


{ -------------------------------------------------------------------
  PROCEDURE RFColor
  Displays text in random colors
  ------------------------------------------------------------------- }
Procedure RFColor;
Var
  X : Byte;
Begin
  Repeat
    Randomize;
    X := Trunc(Random(15));
  Until ( X >= 1);
  If Loc Then TextColor(X) Else fk_Textforeground(X);
End;


{ -------------------------------------------------------------------
  PROCEDURE SaveScreen
  Saves the current screen to high memory
  From TDK
  ------------------------------------------------------------------- }
PROCEDURE SaveScreen;
BEGIN
  IF VBuff <> NIL THEN EXIT;
  NEW(VBuff);
  MOVE(Mem[$B800 : 0000],VBuff^,4000);
END;

{ -------------------------------------------------------------------
  PROCEDURE SRFColor (S : String; Centered : Boolean);
  Displays a text string in random colors
  ------------------------------------------------------------------- }
Procedure SRFColor(S : String; Centered : Boolean);
Var
  SLen : Byte Absolute S;
  N, TLen, X : Integer;
Begin
  Randomize;
  If Centered Then
    Begin
      TLen := 40 - (Length(S) Div 2);
      If Loc Then GotoXY(TLen, WhereY) Else fk_GotoXY(TLen, WhereY);
    End;
  For N := 1 To SLen Do
    Begin
      Repeat
        X := 0;
        X := Random(15);
      Until X >= 1;
      If Loc Then
        Begin
          TextColor(X);
          Write(S[N]);
        End
      Else
        Begin
          fk_TextForeground(X);
          fk_Write(S[N]);
        End;
    End;
  NL;
End;

{ -------------------------------------------------------------------
  PROCEDURE StartDoor(DName: String)
  Starts the door/adds a local login mode to FKFOSSIL.
  Based partially on code from TDK
  ------------------------------------------------------------------- }
Procedure StartDoor(DName: String);
Var
  TempParam, DropFile, Path, Temp : String;
  Loop : Integer;
Begin
  Loc := False;
  ForceANSI := False;
  ScreenClear := True;
  PausePrompt := True;
  fk_Host.TitleLine := True;
  DoorName := DName;
  If Paramcount = 0 Then CommandLineHelp;
  For Loop := 1 To Paramcount Do Begin {Loop 1}
    TempParam := AllCaps(Paramstr(Loop));
    If (TempParam[1] = '/') Or (TempParam[1] = '-') Then Begin {Loop 2}
      Case TempParam[2] Of
        { Screen clearing toggle }
        'C' : If (DName = 'QOTD') Then ScreenClear := False;
        { Read dropfiles }
        'D' : Begin
                Temp := Copy(TempParam, 3, 255);
                DropFile := AllCaps(GetFileName(Temp));
                Path := GetFilePath(Temp);
                If DropFile = 'DORINFO1.DEF' Then fk_ReadDORINFO(Path);
                If DropFile = 'DOOR.SYS' Then fk_ReadDOORSYS(Path);
                ErrorChecking;
                Loc := False;
                If fk_Task.Share Then Filemode := 34;
              End;
        { Force ANSI on; doesn't always work! }
        'F' : Begin
                ForceANSI := True;
              End;
        { Local login }
        'L' : Begin
                Loc := True;
                ClrScr;
                IceText('* ' + fk_ProgramInfo.Title + ' Local Login', True, False);
                IceText('* Enter your name (press ENTER for ''SysOp''): ', True, False);
                ReadLn(Temp);
                If fk_Task.Share Then Filemode := 34;
                If Temp = '' then Temp := 'Sysop';
                fk_InitFossil(0, 0, 0, Temp, Temp, 3000, 1, 25);
              End;
        { Read node number from command line }
        'N' : Begin
                fk_Host.Node := StrToInt(Copy(TempParam,3,4));
              End;
        { Pause prompt toggle }
        'P' : If (DName = 'QOTD') Then PausePrompt := False;
        { Show help screen }
        '?','H' : CommandLineHelp;
        Else
          CommandLineHelp;
      End; {Loop 2}
    End Else
          CommandLineHelp;
  End; {Loop 1}
  If Not Loc Then
    Begin
      fk_InitFOSSIL_DF(25);
      ErrorChecking;
      { This forces ANSI emulation on in the door.  This
        may or may not always work. }
      If ForceANSI Then fk_Client.Screentype := 1;
    End;
End;


{ -------------------------------------------------------------------
  PROCEDURE StripBoth
  Strips leading and trailing characters from ST
  From TDK
  ------------------------------------------------------------------- }
FUNCTION StripBoth(St : STRING; Ch : CHAR) : STRING;
BEGIN
  StripBoth := StripTrail(StripLead(St,Ch),Ch);
END;


{ -------------------------------------------------------------------
  FUNCTION StripLead
  Strips leading characters off of a string
  From TDK
  ------------------------------------------------------------------- }
FUNCTION StripLead(St : STRING; Ch : CHAR) : STRING;
VAR
  TempStr : STRING;
BEGIN
  TempStr := St;
  WHILE ((TempStr[1] = Ch) AND (LENGTH(TempStr) > 0)) DO TempStr := COPY(TempStr,2,LENGTH(TempStr));
  StripLead := TempStr;
END;


{ -------------------------------------------------------------------
  PROCEDURE StripTrail
  Strips trailing characters from a string
  ------------------------------------------------------------------- }
FUNCTION StripTrail(St : STRING; Ch : CHAR) : STRING;
VAR
  TempStr : STRING;
  I       : INTEGER;

BEGIN
  TempStr := St;
  I := LENGTH(St);
  WHILE ((I > 0) AND (St[I] = Ch)) DO I := I - 1;
  TempStr[0] := CHR(I);
  StripTrail := TempStr;
END;

{ -------------------------------------------------------------------
  FUNCTION StrToInt
  Converts a string to an integer
  ------------------------------------------------------------------- }
Function StrToInt(S : String) : Longint;
Var
  L : Longint;
  U : Integer;

Begin
  Val(S, L, U);
  StrToInt := L;
End;


{ -------------------------------------------------------------------
  PROCEDURE TrimFile
  Trims a text file to x lines long
  ------------------------------------------------------------------- }
Procedure TrimFile(FName : String; NumLines : Integer);
Var
  LineCount, I, RC : Integer;
  S : String;
  TempFile, F: text;
Begin
  If Not FExist(FName) Then Exit;
  {$I-}Assign(F,FName);{$I+}
  RC := IOResult;
  CatchError(FName);
  If NumLines = 0 Then Exit;
  {$I-}Reset(F);{$I+}
  LineCount := 1;
  While Not EOF(F) Do
    Begin
      ReadLn(F, S);
      Inc(LineCount);
    End;
  Close(F);
  If LineCount <= NumLines Then Exit;
  Assign(F, FName);
  {$I-}Reset(F);{$I+}
  For I := 1 to (NumLines - LineCount) Do
    Begin
      ReadLn(F, S);
      Assign(TempFile, 'trim.' + NumPad(fk_Host.Node,3));
      {$I-}Rewrite(TempFile);{$I+}
      While Not EOF(F) Do
        Begin
          ReadLn(F, S);
          WriteLn(TempFile, S);
        End;
      Close(F);
      Close(TempFile);
      Erase(F);
      Rename(TempFile,FName);
    End;
End;

{ -------------------------------------------------------------------
  FUNCTION UpKey
  Returns an uppercase character
  ------------------------------------------------------------------- }
Function UpKey : Char;
Var
  Key : Char;
Begin
  Repeat
    Key := UpCase(fk_Read);
  Until (Key <> '');
  UpKey := Key;
End;


{ -------------------------------------------------------------------
  PROCEDURE UpCaseStr
  Returns an uppercase string
  ------------------------------------------------------------------- }
Procedure UpCaseStr(St : String);
Var
  N : Integer;
Begin
  For N := 1 to Length(St) Do
    If St[N] In ['a'..'z'] Then St[N] := UpCase(St[N]);
End;


{ -------------------------------------------------------------------
  FUNCTION YesNo
  Checks for 'Y' or 'N' and returns that char as its value
  ------------------------------------------------------------------- }
Function YesNo : Boolean;
Var
  Ch : Char;
Begin
  If Not Loc Then fk_FlushInputBuffer;
  Repeat
    If Loc Then Ch := Upcase(ReadKey) Else Ch := Upcase(fk_Read);
  Until (Ch = 'Y') or (Ch = 'N');
If Ch = 'Y' then YesNo := True Else
   YesNo := False;
End;

Begin
End.
