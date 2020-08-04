Program AttitudeAssessment;

{ Attitude Assessment - v2.8 - written by Sean Dennis
  Developed using Turbo Pascal 7.0 and FKFOSSIL v1.02
  (C)2020 Sean Dennis
  Last touched 15 February 2020 at 1510 EDT 

  This source code and its accompanying documentation is being
  released under the Cheepware License.  The license should be
  part of this archive and is also available at:
  https://github.com/digimaus/Cheepware/blob/master/CheepwareLicense.txt
}

Uses
  DOS, CRT, FKFOSSIL, DOORUNIT;

Var
  Score, X: Byte;
  Ch : Char;

Const
  FullTitle = 'Attitude Assessment - v2.8 - (C) 2020 Sean Dennis';

Procedure NewTitle;
Begin
  fk_ClrScr;
  IceText(FullTitle, True, True);
  NL;
End;

Procedure Title;
Begin
  NewTitle;
  pWrite('`0EQuestion `0B' + IntToStr(X) + ' `0Eof `0B10',True, False);
End;

Procedure Setup;
Begin
  NewTitle;
  pWrite('`0AWould you like instructions (press Q to quit)? [Y/N/Q]',True, True);
  Ch := LimitedInput('YNQ');
  Case Ch Of
    'Q' : Goodbye;
    'Y' : Begin
            NewTitle;
            pWrite('`0AAttitude Assessment is a very simple `0E''personality test'' `0Aconsisting of ten',True, True);
            pWrite('simple multiple-choice questions.  At the end of the test, you''ll see your',True, True);
            pWrite('results.  During the test, you can press `0EQ`0A at any time to quit and return',True, True);
            pWrite('back to the BBS.',True, True);
            NL;
            AnyKey('', True, True);
         End;
    Else
  End; {End Case}
End; {End Procedure}

Procedure Quiz;
Begin
  X := 1;
  { Start first question }
  Title;
  pWrite('`0CWhen do you feel your best?',True, False);
  NL;
  pWrite('`0DA) `07In the morning',True, False);
  pWrite('`0DB) `07During the afternoon and early evening',True, False);
  pWrite('`0DC) `07Late at night',True, False);
  NL;
  pWrite('`0AEnter your choice or press `0EQ`0A to quit.',True, False);
  Ch := LimitedInput('QABC');
  Case Ch Of
    'Q': Goodbye;
    'A': Score := Score + 2;
    'B': Score := Score + 4;
    'C': Score := Score + 6;
  End; { First question }
  Inc(X);
  { Begin second question }
  Title;
  pWrite('`0CYou usually walk:',True, False);
  NL;
  pWrite('`0DA) `07Fairly fast with long steps',True, False);
  pWrite('`0DB) `07Fairly fast with little steps',True, False);
  pWrite('`0DC) `07Less fast with your head up, looking straight ahead',True, False);
  pWrite('`0DD) `07Less fast with your head down',True, False);
  pWrite('`0DE) `07Very slowly',True, False);
  NL;
  pWrite('`0AEnter your choice or press `0EQ`0A to quit.',True, False);
  Ch := LimitedInput('ABCDEQ');
  Case Ch Of
    'Q': Goodbye;
    'A': Score := Score + 6;
    'B': Score := Score + 4;
    'C': Score := Score + 7;
    'D': Score := Score + 2;
    'E': Score := Score + 1;
  End;
  Inc(X);
  { Start third question }
  Title;
  pWrite('`0CWhen talking to people, you:',True, False);
  NL;
  pWrite('`0DA) `07Stand with your arms folded',True, False);
  pWrite('`0DB) `07Have your hands clasped',True, False);
  pWrite('`0DC) `07Have one or both of your hands on your hips (akimbo)',True, False);
  pWrite('`0DD) `07Touch or push the person you''re talking to',True, False);
  pWrite('`0DE) `07Fidget (play with your ear, smooth your hair, etc.)',True, False);
  NL;
  pWrite('`0AEnter your choice or press `0EQ`0A to quit.',True, False);
  Ch := LimitedInput('ABCDEQ');
  Case Ch Of
    'Q': Goodbye;
    'A': Score := Score + 4;
    'B': Score := Score + 2;
    'C': Score := Score + 5;
    'D': Score := Score + 7;
    'E': Score := Score + 6;
  End; { Third question }
  Inc(X);
  { Start fourth question }
  Title;
  pWrite('`0CWhen relaxing, you sit with:',True, False);
  NL;
  pWrite('`0DA) `07Your knees bent with your legs neatly side by side',True, False);
  pWrite('`0DB) `07Your legs crossed',True, False);
  pWrite('`0DC) `07Your legs stretched out or straight',True, False);
  pWrite('`0DD) `07One leg curled under you',True, False);
  NL;
  pWrite('`0AEnter your choice or press `0EQ`0A to quit.',True, False);
  Ch := LimitedInput('ABCDQ');
  Case Ch Of
    'Q': Goodbye;
    'A': Score := Score + 4;
    'B': Score := Score + 6;
    'C': Score := Score + 2;
    'D': Score := Score + 1;
  End;
  Inc(X);
  { Start fifth question }
  Title;
  pWrite('`0CWhen something really amuses you, you react with:',True, False);
  NL;
  pWrite('`0DA) `07A big, appreciated laugh',True, False);
  pWrite('`0DB) `07A soft laugh',True, False);
  pWrite('`0DC) `07A quiet chuckle',True, False);
  pWrite('`0DD) `07A sheepish smile',True, False);
  NL;
  pWrite('`0AEnter your choice or press `0EQ`0A to quit.',True, False);
  Ch := LimitedInput('ABCDQ');
  Case Ch Of
    'Q': Goodbye;
    'A': Score := Score + 6;
    'B': Score := Score + 4;
    'C': Score := Score + 3;
    'D': Score := Score + 2;
  End;
  Inc(X);
  { Start sixth question }
  Title;
  pWrite('`0CWhen you go to a party or a social gathering, you:',True, False);
  NL;
  pWrite('`0DA) `07Make a loud entrance so everyone notices you',True, False);
  pWrite('`0DB) `07Make a quiet entrance, looking for someone you know',True, False);
  pWrite('`0DC) `07Make the quietest entrance, trying to stay unnoticed',True, False);
  NL;
  pWrite('`0AEnter your choice or press `0EQ`0A to quit.',True, False);
  Ch := LimitedInput('ABCQ');
  Case Ch Of
    'Q': Goodbye;
    'A': Score := Score + 6;
    'B': Score := Score + 4;
    'C': Score := Score + 2;
  End;
  Inc(X);
  { Start seventh question }
  Title;
  pWrite('`0CYou''re working very hard and you''re interrupted.  Do you:',True, False);
  NL;
  pWrite('`0DA) `07Welcome the break',True, False);
  pWrite('`0DB) `07Feel extremely irritated',True, False);
  pWrite('`0DC) `07Vary between these two extremes',True, False);
  NL;
  pWrite('`0AEnter your choice or press `0EQ`0A to quit.',True, False);
  Ch := LimitedInput('ABCQ');
  Case Ch Of
    'Q': Goodbye;
    'A': Score := Score + 6;
    'B': Score := Score + 2;
    'C': Score := Score + 4;
  End;
  Inc(X);
  { Start eighth question }
  Title;
  pWrite('`0CWhich of the following colors do you like most:',True, False);
  NL;
  pWrite('`0DA) `07Red or orange',True, False);
  pWrite('`0DB) `07Black',True, False);
  pWrite('`0DC) `07Yellow or light blue',True, False);
  pWrite('`0DD) `07Green',True, False);
  pWrite('`0DE) `07Dark blue or purple',True, False);
  pWrite('`0DF) `07White',True, False);
  pWrite('`0DG) `07Brown or gray',True, False);
  NL;
  pWrite('`0AEnter your choice or press `0EQ`0A to quit.',True, False);
  Ch := LimitedInput('ABCDEFGQ');
  Case Ch Of
    'Q': Goodbye;
    'A': Score := Score + 6;
    'B': Score := Score + 7;
    'C': Score := Score + 5;
    'D': Score := Score + 4;
    'E': Score := Score + 3;
    'F': Score := Score + 2;
    'G': Score := Score + 1;
  End;
  Inc(X);
  { Start ninth question }
  Title;
  pWrite('`0CWhen in bed at night, in twilight sleep, you are:',True, False);
  NL;
  pWrite('`0DA) `07Stretched out on your back',True, False);
  pWrite('`0DB) `07Stretched out face down on your stomach',True, False);
  pWrite('`0DC) `07On your side, slightly curled',True, False);
  pWrite('`0DD) `07With your head on one arm',True, False);
  pWrite('`0DE) `07With your head under the covers',True, False);
  NL;
  pWrite('`0AEnter your choice or press `0EQ`0A to quit.',True, False);
  Ch := LimitedInput('ABCDEQ');
  Case Ch Of
    'Q': Goodbye;
    'A': Score := Score + 7;
    'B': Score := Score + 6;
    'C': Score := Score + 4;
    'D': Score := Score + 2;
    'E': Score := Score + 1;
  End;  
  Inc(X);
  { Start tenth (and final) question }
  Title;
  pWrite('`0CYou often dream that you are:',True, False);
  NL;
  pWrite('`0DA) `07Falling',True, False);
  pWrite('`0DB) `07Fighting or struggling',True, False);
  pWrite('`0DC) `07Searching for something or someone',True, False);
  pWrite('`0DD) `07Flying or floating',True, False);
  pWrite('`0DE) `07You usually have dreamless sleep',True, False);
  pWrite('`0DF) `07Your dreams are always pleasant',True, False);
  NL;
  pWrite('`0AEnter your choice or press `0EQ`0A to quit.',True, False);
  Ch := LimitedInput('ABCDEFQ');
  Case Ch Of
    'Q': Goodbye;
    'A': Score := Score + 4;
    'B': Score := Score + 2;
    'C': Score := Score + 3;
    'D': Score := Score + 5;
    'E': Score := Score + 6;
    'F': Score := Score + 1;
  End;
End; { End Quiz }

Procedure Result;
Begin
  NewTitle;
  pWrite('`0DThe result of your test is:`07',True, True);
  NL;
  fk_TextForeground(14);
  Case Score Of
     60..100:
       Begin
         pWrite('Others see you as someone they should "handle with care".  You''re',True, True);
         pWrite('seen as vain, self-centered and someone who is extremely dominant.',True, True);
         pWrite('Others may admire you, wishing they could be more like you, but don''t',True, True);
         pWrite('always trust you, hesitating to become too deeply involved with you.',True, True);
       End;

     51..60:
       Begin
         pWrite('Others see you as exciting, highly volatile, rather impulsive',True, True);
         pWrite('personality; a natural leader who''s quick to make decisions',True, True);
         pWrite('though not always the right ones.  They see you as bold and',True, True);
         pWrite('adventuresome, someone who will try anything once and someone',True, True);
         pWrite('who takes chances and enjoys an adventure.  They enjoy being',True, True);
         pWrite('in your company because of the excitement you radiate.',True, True);
       End;

     41..50:
       Begin
         pWrite('Others see you as fresh, lively, charming, amusing, practical',True, True);
         pWrite('and always interesting; someone who''s constantly in the center',True, True);
         pWrite('of attention, but sufficiently well-balanced not to let it go to',True, True);
         pWrite('their head.  They also see you as kind, considerate and',True, True);
         pWrite('understanding; someone who''ll always cheer them up and help them out.',True, True);
       End;

     31..40:
       Begin
         pWrite('Others see you as sensible, cautious, careful and practical.',True, True);
         pWrite('They see you as clever, gifted or talented, but modest.  Not',True, True);
         pWrite('a person who makes friends too quickly or easily, but someone',True, True);
         pWrite('who''s extremely loyal to friends you do make and who expects',True, True);
         pWrite('the same loyalty in return.  Those who really get to know you',True, True);
         pWrite('realize it takes a lot to shake your trust in your friends, but',True, True);
         pWrite('equally that it takes you a long time to get over it if that',True, True);
         pWrite('trust is ever broken.',True, True);
       End;

     21..30:
       Begin
        pWrite('Your friends see you as painstaking and fussy.  They see you as',True, True);
        pWrite('very cautious, extremely careful and a slow and steady plodder.',True, True);
        pWrite('It would really suprise them if you ever did something impulsively',True, True);
        pWrite('or on the spur of the moment, expecting you to examine everything',True, True);
        pWrite('carefully from every angle and then usually decide against it.  They',True, True);
        pWrite('think this reaction is caused partly by your careful nature.',True, True);
       End;

     0..21:
       Begin
         pWrite('People think you are shy, nervous and indecisive...someone who needs',True, True);
         pWrite('looking after...someone who always wants someone else to make the',True, True);
         pWrite('decisions and who doesn''t want to get involved with anyone or',True, True);
         pWrite('anything.  They see you as a worrier who always sees problems that',True, True);
         pWrite('don''t exist.  Some people think you''re boring.  Only those who',True, True);
         pWrite('know you well know that you aren''t.',True, True);
       End
     Else
  End;
  NL;
  pWrite('`0AThank you for taking the `0FAttitude Assessment`0A!',True, True);
  NL;
  NL;
  AnyKey('', True, True);
  fk_TextForeground(7);
End;

Begin
  fk_ProgramInfo.Title   := 'Attitude Assessment';
  fk_ProgramInfo.Version := '2.8';
  fk_ProgramInfo.Author  := 'Sean Dennis';
  fk_ProgramInfo.Other   := '(C)2020 Sean Dennis';
  fk_Host.TitleLine      := True;
  StartDoor('ATTITUDE');
  Setup;
  Quiz;
  Result;
  Goodbye;
End.
