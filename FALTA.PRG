#include "common.ch"
#include "inkey.ch"
#INCLUDE "GETEXIT.CH"

#command @ <row> , <col>  GET <var> ;
[<clauses,...>]         ;
PASSWORD                ;
[<moreClauses,...>]     ;
;
=> @ <row> , <col>  GET <var> ;
[<clauses>]             ;
SEND reader := {|oGet|  ;
GetPassword(oGet) };
[<moreClauses>]


#xtranslate ISNIL( <xValue> )       => HB_ISNIL( <xValue> )
#xtranslate ISBLOCK( <xValue> )     => HB_ISBLOCK( <xValue> )
#xtranslate ISARRAY( <xValue> )     => HB_ISARRAY( <xValue> )
#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)

#ifdef K_MINMOUSE

#else
   #define K_MINMOUSE              1001
   #define K_MAXMOUSE              1007
#endif


STATIC STATIC1, STATIC2:= .F., STATIC3, STATIC4, STATIC5, STATIC6, ;
   STATIC7, STATIC8, STATIC9, STATIC10
STATIC STATIC11:= ""
STATIC STATIC12, STATIC13:= .T., STATIC14:= .F., STATIC15:= .F., ;
   STATIC16:= .F., STATIC17:= 0, STATIC18:= {}, STATIC19:= 0, ;
   STATIC20:= 0, STATIC21:= 0, STATIC22:= {60, {|| vlmarquee()}}
STATIC ;
   arrMouseInfLeft  := { 0,0,0 },;
   arrMouseInfRight := { 0,0,0 }
STATIC ;
   sbGuiSupport   := .F.,;
   sbGuiSupportEx := .F.


********************************
function DESKTOP(Arg1, Arg2,lCallSetMode,lCallSetFont)

   local Local1
   local c80 := MaxCol()+1
   local r24 := MaxRow()


   Arg1:= iif(ISNil(Arg1), "Silas Spagiari Sistemas - 4.0", Arg1)
   Arg2:= iif(ISNil(Arg2), "W+/BG", Arg2)
   if (vlmouseini(@Local1))
      vlmouseon()
   endif

   IF HB_ISNIL(lCallSetMode) .or. lCallSetMode
     wvt_DrawImage(2, 0, maxrow()-2, maxcol(), AEMP00->EMPLOGO)
     cInicIMG4 := Wvt_SaveScreen(2, 0, maxrow()-2, maxcol())  // salva a tela
   endif
   
   SetPos(0, 0)
   DevPos(0, 0)
   vldevout(padc(Arg1, c80), Arg2)

   DevPos(1, 0)
   vldevout(padc(" ", c80), "N*/W")

   DevPos(r24-2, 0)
   vldevout(padc(" ", c80), "N*/W")

   RETURN Nil

function VLMouseINI(a)
   RETURN mPresent()

function VLMouseON()
   RETURN mSetCursor(.T.)

function VLMouseOFF()
   RETURN mSetCursor(.F.)

function VLMouseUP(i,a)
   if i == 00
      RETURN aClone( arrMouseInfLeft )
   else
      RETURN aClone( arrMouseInfRight )
   endif
   RETURN

function VLSetMouse(l)
   //STATIC sl := .F.
   //   if l <> nil ; sl := l ; end
   //RETURN sl
   if pcount() == 00
      RETURN mSetCursor()
   else
      RETURN mSetCursor(l)
   endif

********************************
function VLSCROLL(Arg1, Arg2, Arg3, Arg4, Arg5)

   local Local1
   Local1:= vlsetmouse(.F.)
   Scroll(Arg1, Arg2, Arg3, Arg4, Arg5)
   vlsetmouse(Local1)
   RETURN Nil

********************************
function VLDEVOUT(Arg1, Arg2)

   local Local1
   Local1:= vlsetmouse(.F.)
   DevOut(Arg1, Arg2)
   vlmouseon(Local1)
   RETURN Nil

********************************
function NEWBARMENU

   RETURN {}

********************************
function NEWDOWNMENU
   RETURN NEWDOWNMEN()

function NEWDOWNMEN

   RETURN {}

function ADDDOWNITEM(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9)

   local Local1, Local2
   Local2:= Len(Arg1)

   Arg2:= iif(At("&", Arg2) == 0, "&" + Arg2, Arg2)
   Arg4:= iif(ISNil(Arg4), {|| nret()}, Arg4)
   Arg6:= iif(ISNil(Arg6), .T., Arg6)

   if ISNil(Arg9)
     Arg9 = 0
   else
     if substr(W_LOGGER,Arg9,1) == "N"
       Arg6:= .f.
     endif
   endif

   Arg8:= iif(ISNil(Arg8), 3, Arg8)
   Local1:= SubStr(Arg2, At("&", Arg2) + 1, 1)
   if (Local2 == 0)
      Arg7:= iif(ISNil(Arg7), 3, Arg7)
      Arg5:= iif(ISNil(Arg5), Len(Arg2) + 4, Arg5)
   else
      Arg7:= iif(ISNil(Arg7), Arg1[Local2][6] + 1, Arg7)
      Arg5:= iif(ISNil(Arg5), Max(Arg1[Local2][10], Len(Arg2) + 4), ;
         Arg5)
   endif
   AAdd(Arg1, {Arg2, Arg3, Arg4, Arg6, Local1, Arg7, Arg8, .F., .F., Arg5, Arg9})
   RETURN Nil

********************************
function NRET

   RETURN Nil

********************************
function ADDBARITEM(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9)

   local Local1, Local2, Local3
   Local3:= Len(Arg1)
   Arg2:= iif(At("&", Arg2) == 0, "&" + Arg2, Arg2)
   Arg4:= iif(ISNil(Arg4), {|| nret()}, Arg4)
   Arg5:= iif(ISNil(Arg5), .T., Arg5)
   Arg6:= iif(ISNil(Arg6), 1, Arg6)
   Local1:= SubStr(Arg2, At("&", Arg2) + 1, 1)
   Local2:= Len(Arg2) + 1
   if (Local3 == 0)
      Arg7:= iif(ISNil(Arg7), 1, Arg7)
   else
      Arg7:= iif(ISNil(Arg7), Arg1[Local3][7] + Arg1[Local3][8], Arg7)
   endif

   if ISNil(Arg9)
     Arg9 = 0
   endif


*  AAdd(Arg1, {Arg2, Arg3, Arg4, Arg6, Local1, Arg7, Arg8, .F.   , .F., Arg5, Arg9})
   AAdd(Arg1, {Arg2, Arg3, Arg4, Arg5, Local1, Arg6, Arg7, Local2,    ,     ,Arg9})
   RETURN Nil



********************************
function ADDDOWNSEP(Arg1, Arg2)

   local Local1, Local2, Local3
   Local3:= Len(Arg1)
   Arg2:= iif(ISNil(Arg2), 1, Arg2)
   Local2:= iif(ISNil(Local2), 3, Local2)
   if (Local3 == 0)
      Local1:= iif(ISNil(Local1), 3, Local1)
   else
      Local1:= iif(ISNil(Local1), Arg1[Local3][6] + 1, Local1)
   endif
   AAdd(Arg1, {Nil, Nil, Nil, .T., "", Local1, Local2, .F., .T., ;
      Arg2})
   RETURN Nil

********************************
function BARMENU(Arg1, Arg2, Arg3, Arg4)

   local Local1, Local2, Local3, Local4, Local5, Local6, Local7, ;
      Local8
   Local1:= array(4)
   Local2:= setcursor(0)
   Local6:= .T.
   Local7:= .T.
   Local8:= 0
   Arg2:= iif(ISNil(Arg2), 1, Arg2)
   Arg3:= iif(ISNil(Arg3), 1, Arg3)
   Arg4:= iif(PCount() == 4, Arg4, menucolors())
   keyboard Chr(13)
   InKey(0.2) //.1



   do while (Arg3 != 0)

   // PROBLEMA RELOIO
     Wvt_RestScreen(2, 0, maxrow()-2, maxcol(), cInicIMG4,.t. )  // restaura a tela


      if (Local6)
         displaybar(Arg1, Arg2, Arg4)
         showbarfoc(Arg1[Arg3], Arg4)
         Local6:= .F.
      endif
      do case
      case setmovleft()
         Arg3:= barleft(Arg1, Arg3, Arg4)
         setmovleft(.F.)
         keyboard Chr(13)
      case setmovrigh()
         Arg3:= barright(Arg1, Arg3, Arg4)
         setmovrigh(.F.)
         keyboard Chr(13)
      case setmovflag() .And. !setbarmsg() .And. (Local3[2] == 19 ;
            .Or. Local3[2] == 4)
         keyboard Chr(13)
      case Arg3 == Local8 .And. LastKey() == K_ESC
         keyboard Chr(13)
         InKey(0.2) //.1
         Local8:= 0
      endcase
      Local3:= waitstate()

      do case
      case Local3[1] == 1

         Local8:= 0
         do case
         case (Local5:= ascan(Arg1, {|_1| Upper(Chr(Local3[2])) ==  Upper(_1[5])})) != 0
            Arg3:= bargoto(Arg1, Arg3, Local5, Arg4)
            Arg3:= barexecute(Arg1, Arg3, Arg2, Local5, Arg4)
            Local6:= .T.

         case Local3[2] == 19
            Arg3:= barleft(Arg1, Arg3, Arg4)
         case Local3[2] == 4
            Arg3:= barright(Arg1, Arg3, Arg4)
         case Local3[2] == 27
            Arg3:= barescape(Arg1, Arg3, Arg4)
         case Local3[2] == 13 .And. Arg1[Arg3][4]
            Arg3:= barexecute(Arg1, Arg3, Arg2, Arg3, Arg4)
            Local6:= .T.
         endcase
      case Local3[1] == 2
         if ((Local4:= chkbrmouse(Arg1, Arg2, Local3, Arg3)) > 0)
            setbarmsg(.T.)
            setmovflag(.F.)
            Arg3:= bargoto(Arg1, Arg3, Local4, Arg4)
            Local7:= .T.
         else
            Local7:= .F.
         endif
      case Local3[1] == 3
         if ((Local4:= chkbrmouse(Arg1, Arg2, Local3, Arg3)) > 0 ;
               .And. Local7 .And. Local8 != Arg3 .Or. Local4 > 0 ;
               .And. ISBLOCK(Arg1[Arg3][3]))
            setbarmsg(.T.)
            setmovflag(.F.)
            Arg3:= bargoto(Arg1, Arg3, Local4, Arg4)
            Local8:= Arg3
            Arg3:= barexecute(Arg1, Local4, Arg2, Local4, Arg4)
            Local6:= .T.
         elseif (Local4 > 0)
            Local8:= 0
         endif
      case Local3[1] == 4

         if ((Local4:= chkbrmouse(Arg1, Arg2, Local3, Arg3)) > 0 ;
               .And. Local4 != Arg3 .And. Local7)
            setbarmsg(.T.)
            setmovflag(.F.)
            Arg3:= bargoto(Arg1, Arg3, Local4, Arg4)
            Local8:= 0
         elseif (Local4 == -1 .And. Local7)
            setbarmsg(.T.)
            setmovflag(.F.)
            Local8:= Arg3
            Arg3:= barexecute(Arg1, Arg3, Arg2, Local4, Arg4)
            Local6:= .T.
         endif
      endcase

   enddo


   setcursor(Local2)
   RETURN Arg3

********************************
function MENUCOLORS

   local Local1
   Local1:= {}
   AAdd(Local1, "N*/W")
   AAdd(Local1, "W*/W")
   AAdd(Local1, "W+/N")
   AAdd(Local1, "W/N")
   AAdd(Local1, "R+/N")
   AAdd(Local1, "R+*/W")
   AAdd(Local1, "W+/N")
   AAdd(Local1, "N*/W")
   AAdd(Local1, "N*/W")
   AAdd(Local1, "R*/W")
   RETURN Local1

********************************
STATIC function DISPLAYBAR(Arg1, Arg2, Arg3)

   aeval(Arg1, {|_1| (_1[6]:= Arg2, drawbarite(_1, 1, Arg3))})

   RETURN Nil


********************************
STATIC function SHOWBARFOC(Arg1, Arg2)


   drawbarite(Arg1, 2, Arg2)
   showbarmsg(Arg1, Arg2)
   RETURN Nil

********************************
function SETMOVLEFT(Arg1)

   local Local1

   Local1:= STATIC14
   if (Arg1 != Nil)
      STATIC14:= Arg1
   endif
   RETURN Local1

********************************
STATIC function BARLEFT(Arg1, Arg2, Arg3)


   if (setmovflag() .And. setbarmsg())
      setbarmsg(.F.)
   endif
   hidebarfoc(Arg1[Arg2], Arg3)
   Arg2:= iif(--Arg2 == 0, Len(Arg1), Arg2)
   showbarfoc(Arg1[Arg2], Arg3)

*WvtSetBlocks( aLastPaint )

   RETURN Arg2

********************************
STATIC function BARRIGHT(Arg1, Arg2, Arg3)

   if (setmovflag() .And. setbarmsg())
      setbarmsg(.F.)
   endif
   hidebarfoc(Arg1[Arg2], Arg3)
   Arg2:= iif(++Arg2 > Len(Arg1), 1, Arg2)
   showbarfoc(Arg1[Arg2], Arg3)

   RETURN Arg2

********************************
STATIC function BARGOTO(Arg1, Arg2, Arg3, Arg4)

   hidebarfoc(Arg1[Arg2], Arg4)
   Arg2:= iif(Len(Arg1) >= Arg3, Arg3, Arg2)
   showbarfoc(Arg1[Arg2], Arg4)

   RETURN Arg2

********************************
function SETMOVFLAG(Arg1)

   local Local1
   Local1:= STATIC16
   if (Arg1 != Nil)
      STATIC16:= Arg1
   endif
   RETURN Local1

********************************
function SETMOVRIGHT(Arg1)
   RETURN SETMOVRIGH(Arg1)

function SETMOVRIGH(Arg1)

   local Local1
   Local1:= STATIC15
   if (Arg1 != Nil)
      STATIC15:= Arg1
   endif
   RETURN Local1

********************************
function SETBARMSG(Arg1)

   local Local1
   Local1:= STATIC13
   if (Arg1 != Nil)
      STATIC13:= Arg1
   endif
   RETURN Local1

********************************

********************************
STATIC function BAREXECUTE(Arg1, Arg2, Arg3, Arg4, Arg5)

   local Local1

   if (ISARRAY(Arg1[Arg2][3]) .And. Arg1[Arg2][4])

      Local1:= downmenu(Arg1[Arg2][3], 1, Arg1[Arg2][6] + 1, ;
         Arg1[Arg2][7], 1, Arg5, Arg3, Arg1)
      Arg2:= iif(Local1 == -1, Arg2, Local1)
   elseif (ISBLOCK(Arg1[Arg2][3]) .And. Arg1[Arg2][4] .And. Arg4 !=    -1)

      if (setmovflag() .And. !setbarmsg())
         setbarmsg(.T.)
      else
         setmovflag(.F.)
         eval(Arg1[Arg2][3])
      endif
   endif


   RETURN Arg2

********************************
STATIC function BARESCAPE(Arg1, Arg2, Arg3)

   RETURN 0

********************************
STATIC function CHKBRMOUSE(Arg1, Arg2, Arg3, Arg4)

   local Local1, Local2, Local3
   nret:= 0
   if (Arg3[2] == Arg2 + 2)
      Local2:= Arg1[Arg4][7]
      Local3:= Arg1[Arg4][7] + Arg1[Arg4][8]
      if (Arg3[3] >= Local2 .And. Arg3[3] <= Local3)
         nret:= -1
      endif
   elseif (Arg3[2] == Arg2)
      for Local1:= 1 to Len(Arg1)
         Local2:= Arg1[Local1][7]
         Local3:= Arg1[Local1][7] + Arg1[Local1][8]
         if (Arg3[3] >= Local2 .And. Arg3[3] <= Local3)
            nret:= Local1
            setmovflag(.F.)
            exit
         endif
      next
   endif
   RETURN nret

********************************
STATIC function DRAWBARITE(Arg1, Arg2, Arg3)

   local Local1, Local2, Local3, Local4

   Local3:= padr(" " + textmenu(Arg1[1]), Arg1[8])
   Local4:= At("&", Arg1[1])
   if (Arg2 == 1)
      Local1:= iif(Arg1[4], Arg3[1], Arg3[2])
      Local2:= iif(Arg1[4], Arg3[6], Arg3[8])
   elseif (Arg2 == 2)
      Local1:= iif(Arg1[4], Arg3[3], Arg3[4])
      Local2:= iif(Arg1[4], Arg3[5], Arg3[7])
   endif
   DevPos(Arg1[6], Arg1[7])
   vldevout(Local3, Local1)
   DevPos(Arg1[6], Arg1[7] + Local4)
   vldevout(Arg1[5], Local2)

   RETURN Nil

********************************
STATIC function SHOWBARMSG(Arg1, Arg2)

   if (setbarmsg() .And. (Arg1[2] != Nil .Or. Arg1[2] = ""))
      dwnmsg(Arg1[2], Arg2[10])
   endif
   RETURN Nil

********************************
STATIC function HIDEBARFOC(Arg1, Arg2)


   drawbarite(Arg1, 1, Arg2)


   RETURN Nil

********************************
function VLSCRSAVER(Arg1, Arg2)

   local Local1
   Local1:= aclone(STATIC22)
   STATIC22[1]:= iif(Arg1 != Nil, Arg1, STATIC22[1])
   STATIC22[2]:= iif(Arg2 != Nil, Arg2, STATIC22[2])
   RETURN Local1


********************************
function GETKEYMOUSE
   RETURN GETKEYMOUS()

function GETKEYMOUS
   RETURN STATIC18

********************************
function DOWNMENU(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8)

   local Local1, Local2, Local3, Local4, Local5, Local6, Local7, ;
      Local8, Local9, Local10, Local11, Local12, Local13, Local14, ;
      Local15, Local16

   Local1:= array(4)
   Local2:= setcursor(0)
   Local3:= Len(Arg1)
   Local4:= Arg1[1][10]
   Local8:= 1
   Local11:= {}
   Local15:= 0
   Local16:= .T.
   Arg7:= iif(ISNil(Arg7), -1, Arg7)
   Arg8:= iif(ValType(Arg8) != "A", {}, Arg8)
   Arg6:= iif(PCount() < 6, menucolors(), Arg6)

   if sbGuiSupportEx
      //Arg3 += 2
   endif


// voltar

   auxpshdown(Local11, Arg1, Arg2, Arg3, Arg4, Arg5, Local8, Arg6)



   do while (Local15 == 0)
      setmovflag(.F.)
      Local12:= Local11[Local8][1]
      Local13:= Local11[Local8][2]
      Arg2:= Local12[1]
      do while (Local13[Arg2][9])
         Arg2:= iif(++Arg2 > Len(Local13), 1, Arg2)
      enddo
      do while (Arg2 != 0)
         if (Local16)
            displaydow(Local11[Local8], Arg6)
            showdwnfoc(Local13[Arg2], Arg6)
            Local16:= .F.
         endif
         Local7:= waitstate()

*         if lLog = .t. .and.  Local7[2] = 32  // entra no modulo de alteracao
 *          SetDownItem(Arg1, Arg2)
 *        endif
         do case


         case Local7[1] == 1



            do case
            case (Local10:= ascan(Local13, {|_1| ;
                  Upper(Chr(Local7[2])) == Upper(_1[5])})) != 0
               Arg2:= dwngoto(Local13, Arg2, Local10, Arg6)
               Arg2:= dwnexecute(Local11, Local13, Arg2, Local12, ;
                  Local8, Arg6)
               Local8:= Len(Local11)
               Local16:= .T.
            case Local7[2] == 32 .and. lLog = .t. // espaco
                 SetDownItem(Local13, Arg2)
            case Local7[2] == 5
               Arg2:= dwnup(Local13, Arg2, Arg6)
            case Local7[2] == 24

            */*/*/

            *   do while .t.
            *     if Arg2-1 > 0
            *       if Local13[Arg2-1][4] = .t.
            *          exit
            *       endif
            *     endif
            *     Arg2 ++
            *   enddo

               Arg2:= dwndown(Local13, Arg2, Arg6)

            case Local7[2] == 19
               Arg2:= dwnleft(Local11, Local13, Local8, Arg6)
               Local8:= Len(Local11)
               Local15:= -1
            case Local7[2] == 4
               Arg2:= dwnrigh(Local11, Local13, Local8, Arg6)
               Local8:= Len(Local11)
               Local15:= -1
            case Local7[2] == 27

               Arg2:= dwnescape(Local11, Local13, Arg2, Arg6)
               Local8--
               Local15:= iif(Local8 == 0, -1, Local15)

            case Local7[2] == 13 .And.  lLog = .t. // espaco
               Arg2:= dwnexecute(Local11, Local13, Arg2, Local12, Local8, Arg6)
               Local8:= Len(Local11)
               Local16:= .T.

            case Local7[2] == 13 .And. Local13[Arg2][4]

               Arg2:= dwnexecute(Local11, Local13, Arg2, Local12, ;
                  Local8, Arg6)
               Local8:= Len(Local11)
               Local16:= .T.

            endcase
         case Local7[1] == 2
            Local14:= chkdnmouse(Local11, Local13, Arg2, Local7, ;
               Local8, Arg8, Arg7)
            if (Local14[2] != 0)
               do while (Local8 > Local14[1])
                  auxpopdown(Local11)
                  Local8--
               enddo
               if (Local8 > 0)
                  Local11[Local8][1][1]:= Local14[2]
               else
                  Local15:= Local14[2]
               endif
               Arg2:= 0
               Local16:= .T.
            endif
         case Local7[1] == 3
            if (Local8 > 0 .And. (Local9:= chkupmouse(Local11, ;
                  Local13, Arg2, Local7, Local8)) != 0)
               Arg2:= dwngoto(Local13, Arg2, Local9, Arg6)
               Arg2:= dwnexecute(Local11, Local13, Arg2, Local12, ;
                  Local8, Arg6)
               Local8:= Len(Local11)
               Local16:= .T.
            endif
         case Local7[1] == 4
            if (Local8 > 0 .And. (Local9:= chkupmouse(Local11, ;
                  Local13, Arg2, Local7, Local8)) != 0)
               Arg2:= dwngoto(Local13, Arg2, Local9, Arg6)
            endif
         endcase
      enddo
      if (Local8 == 0)
         exit
      endif
   enddo


   setcursor(Local2)



  // voltar


   RETURN Local15

********************************
function TEXTMENU(Arg1)

   local Local1, Local2, Local3
   Local1:= At("&", Arg1)
   Local2:= SubStr(Arg1, 1, Local1 - 1)
   Local3:= SubStr(Arg1, Local1 + 1)
   RETURN iif(Local1 != 0, Local2 + Local3, Arg1)

********************************
function DWNMSG(Arg1, Arg2)
   local r24 := MaxRow()
   local c80 := MaxCol()+1

   Arg2:= iif(ISNil(Arg2), "R*/W", Arg2)
   DevPos(r24, 0)
   vldevout(padc(Arg1, c80), Arg2)
   RETURN .T.


********************************
STATIC function AUXPSHDOWN(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, ;
   Arg8)

   local Local1, Local2, Local3, Local4, Local5, Local6, Local7
   local r22 := MaxRow()-2
   local c80 := MaxCol()

   Local1:= Len(Arg2)
   Local2:= Arg2[1][10]
   Arg3:= iif(ISNil(Arg3), 1, Arg3)
   for Local4:= 1 to Local1
      Local2:= Max(Arg2[Local4][10], Local2)
   next
   for Local4:= 1 to Local1
      Arg2[Local4][10]:= Local2
   next
   Local5:= Arg4 + Local1 + 1
   Local6:= Arg5 + Arg2[1][10] + 1
   if (Arg7 > 1 .And. (Arg5 > 45 .Or. Arg5 + Arg6 > 65))
      Arg5:= Arg5 + Arg6
      Local6:= Local6 + Arg6
      Arg5:= Arg5 - iif(Local6 + 3 > c80, Arg6 + Arg2[1][10] + 2, 0)
      Local6:= Local6 - iif(Local6 + 3 > c80, Arg6 + Arg2[1][10] + 2, ;
         0)
      Arg4:= Arg4 - iif(Local5 + 1 > r22, Local5 + 1 - r22, 0)
      Local5:= Local5 - iif(Local5 + 1 > r22, Local5 + 1 - r22, 0)
      if (Arg5 < 0)
         Arg5:= MaxCol()-2 - (Local6 - Arg5)
         Local6:= Arg5 + Arg2[1][10] + 1
      endif
   elseif (Arg7 > 1)
      Arg5:= Arg5 + Arg6
      Local6:= Local6 + Arg6
      Arg5:= Arg5 - iif(Local6 + 3 > c80, Local6 + 3 - c80, 0)
      Local6:= Local6 - iif(Local6 + 3 > c80, Local6 + 3 - c80, 0)
      Arg4:= Arg4 - iif(Local5 + 1 > r22, Local5 + 1 - r22, 0)
      Local5:= Local5 - iif(Local5 + 1 > r22, Local5 + 1 - r22, 0)
   else
      Arg5:= Arg5 - iif(Local6 + 3 > c80, Local6 + 3 - c80, 0)
      Local6:= Local6 - iif(Local6 + 3 > c80, Local6 + 3 - c80, 0)
      Arg4:= Arg4 - iif(Local5 + 1 > r22, Local5 + 1 - r22, 0)
      Local5:= Local5 - iif(Local5 + 1 > r22, Local5 + 1 - r22, 0)
   endif

   if sbGuiSupportEx
      Local7:= nbox(Arg4, Arg5, Local5, Local6, Arg8[9],.F.)
   else

     cImagemlocal := Wvt_SaveScreen(Arg4, Arg5, Local5+2, Local6+3)


     aadd(cInicIMG826,cImagemlocal)
     aadd(aInicIMG826,{Arg4, Arg5, Local5+2, Local6+3})
     
     
     Local7:= nbox(Arg4, Arg5, Local5, Local6, Arg8[9],.F.)


   end


   for Local4:= 1 to Local1
      Arg2[Local4][6]:= Arg4 + Local4
      Arg2[Local4][7]:= Arg5 + 1
   next
   AAdd(Arg1, {{Arg3, Local7, Arg4, Arg5, Local5, Local6}, Arg2})



   RETURN Nil

********************************
STATIC function DISPLAYDOWN(Arg1, Arg2)
   RETURN DISPLAYDOW(Arg1, Arg2)

STATIC function DISPLAYDOW(Arg1, Arg2)

   local Local1
   

   for Local1:= 1 to Len(Arg1[2])
      drawdownit(Arg1[2][Local1], 1, Arg2)
   next

*   cTelaIMG := savescreen(2, 0, 24, 80 )  // salva a tela


   RETURN Nil

********************************
STATIC function SHOWDWNFOC(Arg1, Arg2)

   drawdownit(Arg1, 2, Arg2)
   showdownms(Arg1, Arg2)

   RETURN Nil

********************************
STATIC function DWNGOTO(Arg1, Arg2, Arg3, Arg4)

   hidedwnfoc(Arg1[Arg2], Arg4)
   Arg2:= iif(Arg1[Arg3][9], Arg2, Arg3)
   showdwnfoc(Arg1[Arg2], Arg4)
   RETURN Arg2

********************************
STATIC function DWNEXECUTE(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)
   local lSavepri

   *    if !alltrim(netname()) $ "#PC-VIRTUAL#REDE#SERVIDOR#SILASNITRO#"
 *     nAtua:= directory("\\servidor\disk_ser\tmp\maxilit.EXE")
 *     nLoca:= directory("C:\MAXI\maxilit.EXE")

 *     if nAtua[1][2] # nLoca[1][2] .or. nAtua[1][3] # nLoca[1][3] .or. nAtua[1][4] # nLoca[1][4]
 *       clear
 *       alert2("* * * FAVOR ATUALIZAR O SISTEMA * * *")
 *       clear
 *       quit
 *     endif
 *   endif

   if (ISARRAY(Arg2[Arg3][3]) .And. lLog = .t.)
      Arg4[1]:= Arg3
      Arg5++
      auxpshdown(Arg1, Arg2[Arg3][3], 1, Arg2[Arg3][6] - 1, ;
      Arg2[Arg3][7], Arg2[Arg3][10], Arg5, Arg6)
      Arg3:= 0

   elseif (ISARRAY(Arg2[Arg3][3]) .And. Arg2[Arg3][4])
      Arg4[1]:= Arg3
      Arg5++
      auxpshdown(Arg1, Arg2[Arg3][3], 1, Arg2[Arg3][6] - 1, ;
         Arg2[Arg3][7], Arg2[Arg3][10], Arg5, Arg6)
      Arg3:= 0

      // POSICAO SENHA RESTRICAO

   elseif (ISBLOCK(Arg2[Arg3][3]) .And. Arg2[Arg3][4]) .or. (Arg2[Arg3][11] = 430 .and.  lLog = .t.)

     if Arg2[Arg3][11] = 430 .and.  lLog = .t.  // entra no modulo de alteracao// restricao vamos liberar para concluir
     else
       if lLog = .t.  // entra no modulo de alteracao
         alertnew("Voce esta no modulo de permissoes;Conclua a alteracao das senhas",{"Ok"},,,,,,,"VERDE")
         return 0
       endif
     endif

     cTelaIMG3 := Wvt_SaveScreen(0, 0, maxrow(), maxcol())  // salva a tela
     eval(Arg2[Arg3][3])
     Wvt_RestScreen(0, 0, maxrow(), maxcol(), cTelaIMG3 )  // restaura a tela

*     wvt_DrawLabel(MAXROW()-1 ,0,space(100),,, RGB( 0, 0,0), RGB( 255, 255,255 )  , "Visualnova", _FONTET_, , , , , .f., .f. ,.f.)

     cF_ATV = "MENU          "
     cF_MOD = "PRINCIPAL     "
     cF_PRG = "SIS V.4.2     "
     M_FAN = "SISTEMA INGEGRADO"
     rodape()
   endif


   RETURN Arg3

********************************
function SETDOWNITEM(Arg1, Arg2, Arg3)
   RETURN SETDOWNITE(Arg1, Arg2, Arg3)

function SETDOWNITE(Arg1, Arg2, Arg3)

   local Local1

   Local1:= Arg1[Arg2][4]
*   if (Arg3 != Nil)

    Arg1[Arg2][4]:= !Arg1[Arg2][4] // !Arg3
    W_LOGGER = stuff(W_LOGGER,Arg1[Arg2][11],1,iif(substr(W_LOGGER,Arg1[Arg2][11],1)=="N","S","N"))

*   endif
   RETURN Local1

********************************
STATIC function DWNUP(Arg1, Arg2, Arg3)

   hidedwnfoc(Arg1[Arg2], Arg3)
   Arg2:= iif(--Arg2 == 0, Len(Arg1), Arg2)
   do while (Arg1[Arg2][9])
      Arg2:= iif(--Arg2 == 0, Len(Arg1), Arg2)
   enddo
   showdwnfoc(Arg1[Arg2], Arg3)

   RETURN Arg2

********************************
STATIC function DWNDOWN(Arg1, Arg2, Arg3)

   hidedwnfoc(Arg1[Arg2], Arg3)
   Arg2:= iif(++Arg2 > Len(Arg1), 1, Arg2)
   do while (Arg1[Arg2][9])
      Arg2:= iif(++Arg2 > Len(Arg1), 1, Arg2)
   enddo
   showdwnfoc(Arg1[Arg2], Arg3)

   RETURN Arg2

********************************
STATIC function DWNLEFT(Arg1, Arg2, Arg3)

   do while (Arg3 > 0)
      auxpopdown(Arg1)
      Arg3--
   enddo
   setmovflag(.T.)
   setmovleft(.T.)
   setbarmsg(.F.)
   RETURN 0

********************************
STATIC function DWNRIGH(Arg1, Arg2, Arg3)


   do while (Arg3 > 0)
      auxpopdown(Arg1)
      Arg3--
   enddo
   setmovflag(.T.)
   setmovrigh(.T.)
   setbarmsg(.F.)

   RETURN 0

********************************
STATIC function DWNESCAPE(Arg1, Arg2, Arg3)

   auxpopdown(Arg1)
   setbarmsg(.T.)
   
   RETURN 0

********************************
STATIC function CHKDNMOUSE(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7)

   local Local1, Local2, Local3, Local4, Local5, Local6, Local7, ;
      Local8, Local9, Local10, Local11
   Local11:= xmik2:= 0
   if (Arg4[2] == Arg7)
      for Local3:= 1 to Len(Arg6)
         Local4:= Arg6[Local3][7]
         Local5:= Arg6[Local3][7] + Arg6[Local3][8]
         if (Arg4[3] >= Local4 .And. Arg4[3] <= Local5)
            Local11:= 0
            xmik2:= Local3
            exit
         endif
      next
   else
      for Local1:= 1 to Arg5
         Local10:= Len(Arg1[Local1][2])
         Local6:= Arg1[Local1][1][3] + 1
         Local7:= Arg1[Local1][1][4] + 1
         Local8:= Arg1[Local1][1][5] - 1
         Local9:= Arg1[Local1][1][6] - 1
         if (Arg4[2] >= Local6 .And. Arg4[2] <= Local8 .And. Arg4[3] ;
               >= Local7 .And. Arg4[3] <= Local9)
            for Local2:= 1 to Local10
               if (Arg4[2] == Arg1[Local1][2][Local2][6] .And. ;
                     !Arg1[Local1][2][Local2][9])
                  Local11:= Local1
                  xmik2:= Local2
                  exit
               endif
            next
         endif
         if (Local11 != 0)
            exit
         endif
      next
   endif
   RETURN {Local11, xmik2}

********************************
STATIC function AUXPOPDOWN(Arg1)

   local Local1
   Local1:= Len(Arg1)
*   rstenv(Arg1[Local1][1][2])
   asize(Arg1, Local1 - 1)

   // a tela foi gravada em AUXPSHDOWN

   Wvt_RestScreen(aInicIMG826[len(aInicIMG826)][1], aInicIMG826[len(aInicIMG826)][2], aInicIMG826[len(aInicIMG826)][3], aInicIMG826[len(aInicIMG826)][4],cInicIMG826[len(cInicIMG826)])  // restaura a tela

   adel(cInicIMG826,len(cInicIMG826))
   asize(cInicIMG826,len(cInicIMG826) - 1)

   adel(aInicIMG826,len(aInicIMG826))
   asize(aInicIMG826,len(aInicIMG826) - 1)


   RETURN Nil

********************************
STATIC function CHKUPMOUSE(Arg1, Arg2, Arg3, Arg4, Arg5)

   local Local1, Local2, Local3, Local4, Local5, Local6, Local7
   Local7:= 0
   Local6:= Len(Arg2)
   Local2:= Arg1[Arg5][1][3] + 1
   Local3:= Arg1[Arg5][1][4] + 1
   Local4:= Arg1[Arg5][1][5] - 1
   Local5:= Arg1[Arg5][1][6] - 1
   if (Arg4[2] >= Local2 .And. Arg4[2] <= Local4 .And. Arg4[3] >= ;
         Local3 .And. Arg4[3] <= Local5)
      for Local1:= 1 to Local6
         if (Arg4[2] == Arg2[Local1][6] .And. !Arg2[Local1][9])
            Local7:= Local1
            exit
         endif
      next
   endif
   RETURN Local7

********************************
function NBOX(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7)
   local Local1


      if (Arg6)
         sombran(Arg1, Arg2, Arg3, Arg4)
         setcolor(Arg5)
         @ Arg1, Arg2, Arg3, Arg4 box M_FRAME3
         setcolor()
      endif

   if sbGuiSupportEX
*      Local1:= savenv(Arg1, Arg2, Arg3, Arg4, Arg6 )
      dispbox(Arg1, Arg2, Arg3, Arg4, "           ", Arg5)
   else
 *     Local1:= savenv(Arg1, Arg2, Arg3 + 1, Arg4 + 2)
      Arg5:= iif(ISNil(Arg5), "N*/W", Arg5)
      Arg6:= iif(ISNil(Arg6), .T., Arg6)
      Arg7:= iif(ISNil(Arg7), .F., Arg7)

      if sbGuiSupport
         //vldispbox(Arg1, Arg2, Arg3, Arg4, "ÚÄ¿³ÙÄÀ³ " /*"ÉÍ»º¼ÍÈº "*/, Arg5)
      else
         //vldispbox(Arg1, Arg2, Arg3, Arg4, "ÉÐËÜÊÌÈº ", Arg5)

         //vldispbox(Arg1, Arg2, Arg3, Arg4, "ÚÄ¿³ÙÄÀ³ ", Arg5)

         B0 := "ÚÄ¿³ÙÄÀ³ "

         B1 := 'ÕÝ©º½ÐÓÜ '
         B2 := 'ÕÑ©º½ÏÓÜ '
         B3 := '×Ñ¸¹¾ÏÔÛ '
         B4 := 'ÛÏ¹¹¹ØÛ '
         B5 := 'ÚÄ¿°ÙÄÀ° '

         B6 := 'ÉÐËÜÊÌÈº ' //  ÐÐÐÐ  º

         //220 Ü
         //186 º
         //208 Ð  Ï ÐÑÒ


         if alltrim(_FONTEN_) == "NORMAL"
            vldispbox(Arg1, Arg2, Arg3, Arg4, B0, Arg5)
         else
         //vldispbox(Arg1, Arg2, Arg3, Arg4, "ÉÐËÜÊÌÈº ", Arg5)
           If Arg7
            vldispbox(Arg1, Arg2, Arg3, Arg4, B0, Arg5)
           Else
             vldispbox(Arg1, Arg2, Arg3, Arg4, B6, Arg5)
           Endif
         endif
      end

   end
   RETURN Local1

********************************
function NBOX2(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)
   local Local1

   Local1:= savenv(Arg1, Arg2, Arg3 + 1, Arg4 + 2)
   Arg5:= iif(ISNil(Arg5), "W/W+", Arg5)
   Arg6:= iif(ISNil(Arg6), "W/W+", Arg6)

   B0 := "ÚÄ¿³ÙÄÀ³"
   B6 := 'ÉÐËÜÊÌÈº'


   if alltrim(_FONTEN_) == "NORMAL"
     vldispbox(Arg1, Arg2, Arg3, Arg4, B0, Arg5)
   else
     vldispbox(Arg1, Arg2, Arg3, Arg4, B6, Arg5)
   endif

*   painel(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)

  sombran(Arg1, Arg2, Arg3, Arg4)

   RETURN Local1


********************************
STATIC function DRAWDOWNIT(Arg1, Arg2, Arg3)

   local Local1, Local2, Local3, Local4, Local5, Local6

   Local5:= iif(Arg1[8], "û ", "  ")
   Local6:= iif(ISARRAY(Arg1[3]), iif(sbGuiSupport,'>',Chr(16)), " ")
   Local3:= iif(Arg1[9], Replicate("Ä", Arg1[10]), padr(Local5 + ;
      textmenu(Arg1[1]), Arg1[10] - 1) + Local6)
   Local4:= iif(Arg1[9], 0, At("&", Arg1[1]) + 1)
   if (Arg2 == 1)
      Local1:= iif(Arg1[4], Arg3[1], Arg3[2])
      Local2:= iif(Arg1[4], Arg3[6], Arg3[8])
   elseif (Arg2 == 2)
      Local1:= iif(Arg1[4], Arg3[3], Arg3[4])
      Local2:= iif(Arg1[4], Arg3[5], Arg3[7])
   endif
   if (Arg1[9])
      if !sbGuiSupport
         DevPos(Arg1[6], Arg1[7])
         vldevout(Local3, Local1)
      else
         DevPos(Arg1[6], Arg1[7]-1)
         if sbGuiSupportEX
            vldevout(' '+Local3+' ', Local1)
         else
            vldevout('Ã'+Local3+'´', Local1)
         end
      end
   else
      DevPos(Arg1[6], Arg1[7])
      vldevout(Local3, Local1)
      DevPos(Arg1[6], Arg1[7] + Local4)
      vldevout(Arg1[5], Local2)
   endif

   RETURN Nil

********************************
STATIC function SHOWDOWNMS(Arg1, Arg2)

   if (Arg1[2] != Nil .Or. Arg1[2] = "")
      dwnmsg(Arg1[2], Arg2[10])
   endif
   RETURN Nil

********************************
STATIC function HIDEDWNFOC(Arg1, Arg2)

   drawdownit(Arg1, 1, Arg2)
   RETURN Nil

**********************
Static Function Opcoes(nRow, aCol, aOptions, nBeginOption)
**********************

Local nCtr,lKeyValid,cLetter,nLastOption

Local nOption     := nBeginOption,  ;
nKeyPress   := 0,             ;
nOptions    := Len(aOptions), ;
cIniLets    := ""

*nRow--

For nCtr := 1 To nOptions
  cIniLets=cIniLets+Upper(Left(Ltrim(aOptions[nCtr]),1))
  @ nRow, aCol[nCtr] Say aOptions[nCtr] Color cCorNormal
Next nCtr

@ nRow, aCol[nOption] Say aOptions[nOption] Color cCorInverso

nLastOption := nOption

While .T.

  lKeyValid := .F.

  While !lKeyValid

    cLetter := Upper( Chr(nKeyPress) )

    If cLetter $ cIniLets

      nOption := At(cLetter, cIniLets)

      @ nRow, aCol[nLastOption] Say aOptions[nLastOption] Color cCorNormal
      @ nRow, aCol[nOption]     Say aOptions[nOption]     Color cCorInverso

      nLastOption := nOption

*      KeyBoard Chr(13)

    End

    nKeyPress := InKey(0)

    lKeyValid := ( nKeyPress == K_HOME  .Or. nKeyPress == K_END   .Or. ;
    nKeyPress == K_LEFT  .Or. nKeyPress == K_RIGHT .Or. ;
    nKeyPress == K_ENTER .Or. nKeyPress == K_ESC )

  End

  If nKeyPress == K_ESC

    nOption := 0

    Exit

  ElseIf nKeyPress == K_ENTER

    Exit

  ElseIf nKeyPress == K_LEFT

    If nOption > 1
      nOption --
    Else
      nOption := 1
    End

  ElseIf nKeyPress == K_RIGHT

    If nOption < nOptions
      nOption ++
    Else
      nOption := nOptions
    End

  ElseIf nKeyPress == K_HOME

    nOption := 1

  ElseIf nKeyPress == K_END

    nOption := nOptions

End

@ nRow, aCol[nLastOption] Say aOptions[nLastOption] Color cCorNormal
@ nRow, aCol[nOption] Say aOptions[nOption] Color cCorInverso

nLastOption := nOption

End

Return nOption

********************************
function RstEnv(Arg1)
   LOCAL i := 00
   LOCAL b,c,d

   return nil
   
   if sbGuiSupportEx

      b := &( "{|| WVW_NNUMWINDOWS() }" )
      c := &( "{|| WVW_lCloseWindow() }" )
      d := &( "{|_1| WVW_NSETCURWINDOW(_1) }" )

      While ( b:Eval() <> Arg1[11] )
            i++
            c:Eval()

            if i > 5
               exit
            end
      End

      d:Eval( Arg1[10] )
   else
      vlrestscre(Arg1[1], Arg1[2], Arg1[3], Arg1[4], Arg1[5])
*    	RestScreen(Arg1[1], Arg1[2], Arg1[3], Arg1[4], Arg1[13] )  // restaura a tela
      set color to (Arg1[6])
      setcursor(Arg1[7])
      SetPos(Arg1[8], Arg1[9])
   end
   RETURN Nil

********************************
function SavEnv(Arg1, Arg2, Arg3, Arg4,lNoCaption)
   local Local1
   local win
   local a,b,c

   Local1:= {}

   Arg4++

   AAdd(Local1, Arg1)
   AAdd(Local1, Arg2)
   AAdd(Local1, Arg3)
   AAdd(Local1, Arg4)
   AAdd(Local1, vlsavescre(Arg1, Arg2, Arg3, Arg4))
   AAdd(Local1, SetColor())
   AAdd(Local1, setcursor())
   AAdd(Local1, Row())
   AAdd(Local1, Col())

   if sbGuiSupportEx
      a := &("{|| WVW_NSETCURWINDOW() }")
      b := &("{|| WVW_NNUMWINDOWS() }")
      c := &("{|p1,p2,p3,p4,p5,p6,p7| WVW_nOpenWindow(p1,p2,p3,p4,p5,p6,p7) }")

      AADD(Local1, a:Eval() ) // 10 item
      AADD(Local1, b:EVal() )   // 11 item

      if lNoCaption <> nil .And. lNoCaption
         win := c:EVal('',Arg1, Arg2, Arg3, Arg4,KS_NOCAPTION(),0)
      else
         win := c:EVal('',Arg1, Arg2, Arg3, Arg4)
      end
      AADD(Local1, win )                 // 12 item
   else
      AADD(Local1, 00 )   // 10 item
      AADD(Local1, 00 )   // 11 item
      AADD(Local1, nil )  // 12 item
   end

   cTelaIMG1 := savescreen(Arg1, Arg2, Arg3, Arg4)  // salva a tela
   AADD(Local1, cTelaIMG1 )  // 13 item

   RETURN Local1

********************************
function VLDISPBOX(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)


   local Local1
   Local1:= vlsetmouse(.F.)
   @ Arg1, Arg2, Arg3, Arg4 box Arg5 color Arg6
   vlmouseon(Local1)

   RETURN Nil

function SOMBRAN(Arg1, Arg2, Arg3, Arg4)


*   local Local1, Local2, Local3, Local4, vSombra

   sombra(Arg1, Arg2, Arg3, Arg4,_SOMBRA_)


*   vSombra = savescreen(Arg1 + 1, Arg4 + 1, Arg3 + 1, Arg4 + 1)
*             restscreen(Arg1 + 1, Arg4 + 1, Arg3 + 1, Arg4 + 1, replicate(" " + CHR(129), len(vSombra)))
*   vSombra:= vlsavescre(Arg3 + 1, Arg2 + 1, Arg3 + 1, Arg4 + 1)
*             restscreen(Arg3 + 1, Arg2 + 1, Arg3 + 1, Arg4 + 1, replicate(" " + CHR(129), len(vSombra)))

*   vSombra = savescreen(Arg1 + 1, Arg4 + 1, Arg3 + 1, Arg4 + 1)
*             restscreen(Arg1 + 1, Arg4 + 1, Arg3 + 1, Arg4 + 1, replicate(" " + chr(261), len(vSombra)))
*   vSombra:= vlsavescre(Arg3 + 1, Arg2 + 1, Arg3 + 1, Arg4 + 1)
*             restscreen(Arg3 + 1, Arg2 + 1, Arg3 + 1, Arg4 + 1, replicate(" " + chr(261), len(vSombra)))
*
RETURN Nil

*set console off
*clear screen

   Local3:= vlsavescre(Arg1 + 1, Arg4 + 1, Arg3 + 1, Arg4 + 2)
   Local4:= vlsavescre(Arg3 + 1, Arg2 + 2, Arg3 + 1, Arg4 + 2)

   for Local1:= 2 to Len(Local3) step 2
      Local2:= shadow(Asc(SubStr(Local3, Local1, 1)))
      Local3:= stuff(Local3, Local1, 1, Local2)
   next
   for Local1:= 2 to Len(Local4) step 2
      Local2:= shadow(Asc(SubStr(Local4, Local1, 1)))
      Local4:= stuff(Local4, Local1, 1, Local2)
   next
   vlrestscre(Arg1 + 1, Arg4 + 1, Arg3 + 1, Arg4 + 2, Local3)
   vlrestscre(Arg3 + 1, Arg2 + 2, Arg3 + 1, Arg4 + 2, Local4)

   RETURN Nil

********************************
STATIC function SHADOW(Arg1)

   local Local1, Local2, Local3
   Local1:= Arg1 % 16
   Local2:= (Arg1 - Local1) / 16
*   Local3:= {0, 0, 8, 8, 0, 8, 0, 8, 0, 1, 2, 3, 4, 5, 6, 7}
   Local3:= {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

   Local1:= Local3[Local1 + 1]
   Local2:= Local3[Local2 + 1]
   RETURN Chr(16 * Local2 + Local1)


********************************
function VLRESTSCREEN(Arg1, Arg2, Arg3, Arg4, Arg5)
   RETURN VLRESTSCRE(Arg1, Arg2, Arg3, Arg4, Arg5)

function VLRESTSCRE(Arg1, Arg2, Arg3, Arg4, Arg5)

   local Local1
   Local1:= vlsetmouse(.F.)
   RestScreen(Arg1, Arg2, Arg3, Arg4, Arg5)
   vlsetmouse(Local1)
   RETURN Nil

********************************
function VLSAVESCREEN(Arg1, Arg2, Arg3, Arg4)
   RETURN VLSAVESCRE(Arg1, Arg2, Arg3, Arg4)

function VLSAVESCRE(Arg1, Arg2, Arg3, Arg4)

   local Local1, Local2
   Local2:= vlsetmouse(.F.)
   Local1:= SaveScreen(Arg1, Arg2, Arg3, Arg4)
   vlsetmouse(Local2)
   RETURN Local1


********************************
function WIN(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8,lNoCaption)
   local Local1
   local a

   Arg5:= iif(ISNil(Arg5), "", Arg5)
   Arg6:= iif(ISNil(Arg6), "W+/B", Arg6)
   Arg7:= iif(ISNil(Arg7), "B*/W", Arg7)
   Arg8:= iif(ISNil(Arg8), .T., Arg8)

   if sbGuiSupportEX
      Local1:= nbox(Arg1, Arg2, Arg3, Arg4, Arg7, /*Arg8*/lNoCaption)
      a := &( "{|_1,_2| WVW_SETTITLE(_1,_2) }")
      a:Eval(,hb_oemtoansi(Arg5))
   else
      Local1:= nbox(Arg1, Arg2, Arg3, Arg4, Arg7, Arg8)
      DevPos(Arg1, Arg2)
      vldevout(padc(Arg5, Arg4 - Arg2 + 1), Arg6)
   end
   RETURN Local1




********************************
function VLMARQUEE(Arg1, Arg2, Arg3)

*if !upper(alltrim(netname())) $ _NAOPEDESENHA_
  nRowLocal = Row()
  nColLocal = Col()
  cTelaIMGp := savescreen(0, 0, maxrow(), maxcol() )  // salva a tela
  PROTEGEA()
  RestScreen(0, 0, maxrow(), maxcol(), cTelaIMGp )  // restaura a tela
  SetPos(nRowLocal, nColLocal)
*endif

return ""

********************************
function DRAWFN(Arg1, Arg2, Arg3, Arg4)

   local Local1
   local r24 := MaxRow()-1

  ( devpos(MAXROW()-1, 0) , devout(padc("", Maxcol()+1),"N/W*") )

   Local1:= {1, 3, 12, 20, 28, 36, 44, 52, 60, 68, 76,80}
   Arg3:= iif(ISNil(Arg3), "G/W*", Arg3)
   Arg4:= iif(ISNil(Arg4), "N/W*", Arg4)
   DevPos(r24, Local1[Arg1])
   vldevout(Left(Arg2, 7), Arg4)
   DevPos(r24, Local1[Arg1] - 1)

   if sbGuiSupport
      if Arg1 == 10
         Arg1 := 48
      else
         Arg1 += 48
      end
      vldevout(Chr(Arg1), Arg3)
   else
      vldevout(Chr(Arg1), Arg3)
   end
   RETURN Nil

********************************
function MSGBOX3(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, ;
   Arg9, Arg10, Arg11)

   local Local1, Local2, Local3, Local4
   LOCAL aBlocks := {}
   LOCAL aLastPaint4

   aLastPaint4 := WvtSetBlocks( aBlocks )

   Arg4:= iif(ISNil(Arg4), "Sim", Arg4)
   Arg5:= iif(ISNil(Arg5), "NÆo", Arg5)
   Arg6:= iif(ISNil(Arg6), "Cancelar", Arg6)
   Arg7:= iif(ISNil(Arg7), 1, Arg7)
   Arg8:= iif(ISNil(Arg8), 3, Arg8)
   Arg1:= iif(ISNil(Arg1), "", Arg1)
   Arg2:= iif(ISNil(Arg2), "Aten‡Æo!", Arg2)
   Local1:= iif(ISARRAY(Arg1), Len(Arg1), 1)
   Arg3:= iif(ISNil(Arg3), Int(12 - (Local1 + 7) / 2), Arg3)
   Arg9:= iif(ISNil(Arg9), "W+/R", Arg9)
   Arg10:= iif(ISNil(Arg10), "R/W*", Arg10)
   Arg11:= iif(ISNil(Arg11), "N*/W", Arg11)
   Local3:= newbutton()
   nColIni:=(MaxCol()-54) / 2

   ciAdicional = 0
   TamStr = 0
   TamOpc = 0
   TamOpc += len(Arg4)+4+4
   TamOpc += len(Arg5)+4+4
   TamOpc += len(Arg6)+4

   if (ISARRAY(Arg1)) // mensagem
     for Local4:= 1 to len(Arg1)
       TamStr = iif(len(Arg1[Local4]) > TamStr,len(Arg1[Local4]),TamStr)
     next
   else
     TamStr = len(Arg1)
   endif

   if TamOpc < TamStr
     ciAdicional = (TamStr-TamOpc)/2
   endif

   TamStr = iif(TamStr>TamOpc,TamStr,TamOpc)

   Ci:=int(((maxcol()-TamStr)/2))
   Cf:=Ci+TamStr

   addbutton(Local3, Arg3 + 3 + Local1, Ci+ciAdicional                              ,len(Arg4)+6, Arg4, Nil, iif(Arg8 == 1, .T., .F.))
   addbutton(Local3, Arg3 + 3 + Local1, Ci+len(Arg4)+8+ciAdicional          ,len(Arg5)+6, Arg5, Nil, iif(Arg8 == 2, .T., .F.))
   addbutton(Local3, Arg3 + 3 + Local1, Ci+len(Arg4)+8+len(Arg5)+8+ciAdicional,len(Arg6)+6, Arg6, Nil, iif(Arg8 == 3, .T., .F.))


   cImageBOX3 := Wvt_SaveScreen(Arg3-2, Ci-4, Arg3 + 6 + Local1, cf+6)

   Local2:= win(Arg3, Ci-3, Arg3 + 5 + Local1, cf+3, Arg2, Arg9, Arg10)

   if (ISARRAY(Arg1)) // mensagem
      for Local4:= 1 to len(Arg1)
         DevPos(Arg3 + 1 + Local4, ci)
         vldevout(padc(Arg1[Local4],TamStr), Arg11)
      next
   else
      DevPos(Arg3 + 2, ci)
      vldevout(padc(Arg1,TamStr), Arg11)
   endif
   setcursor(0)

   Local4:= procbutton(Local3, 2, iif(Arg7 < 3, Arg7, 2))

   rstenv(Local2)
   Wvt_RestScreen(Arg3-2, Ci-4, Arg3 + 6 + Local1, cf+6,cImageBOX3)

   WvtSetBlocks( aLastPaint4 )
   RETURN Local4

********************************
FUNCTION MSGBOX2(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, ;
   Arg9, Arg10)

   local Local1, Local2, Local3, Local4
   LOCAL aBlocks := {}
   LOCAL aLastPaint4

   aLastPaint4 := WvtSetBlocks( aBlocks )

   Arg4:= iif(ISNil(Arg4), "Sim", Arg4)
   Arg5:= iif(ISNil(Arg5), "NÆo", Arg5)
   Arg6:= iif(ISNil(Arg6), 1, Arg6)
   Arg7:= iif(ISNil(Arg7), 2, Arg7)
   Arg1:= iif(ISNil(Arg1), "", Arg1)
   Arg2:= iif(ISNil(Arg2), "Aten‡Æo!", Arg2)
   Local1:= iif(ISARRAY(Arg1), Len(Arg1), 1)
   Arg3:= iif(ISNil(Arg3), Int(12 - (Local1 + 7) / 2), Arg3)
   Arg8:= iif(ISNil(Arg8), "W+/R", Arg8)
   Arg9:= iif(ISNil(Arg9), "R/W*", Arg9)
   Arg10:= iif(ISNil(Arg10), "N*/W", Arg10)

   ciAdicional = 0
   TamStr = 0
   TamOpc = 0
   TamOpc += len(Arg4)+4+4
   TamOpc += len(Arg5)+4

   if (ISARRAY(Arg1)) // mensagem
     for Local4:= 1 to len(Arg1)
       TamStr = iif(len(Arg1[Local4]) > TamStr,len(Arg1[Local4]),TamStr)
     next
   else
     TamStr = len(Arg1)
   endif

   if TamOpc < TamStr
     ciAdicional = (TamStr-TamOpc)/2
   endif

   TamStr = iif(TamStr>TamOpc,TamStr,TamOpc)

   Ci:=((maxcol()-TamStr)/2)
   Cf:=Ci+TamStr

   Local3:= newbutton()

   addbutton(Local3, Arg3 + 3 + Local1, Ci+ciAdicional                        ,len(Arg4)+6, Arg4, Nil, iif(Arg7 == 1, .T., .F.))
   addbutton(Local3, Arg3 + 3 + Local1, Ci+len(Arg4)+8+ciAdicional            ,len(Arg5)+6, Arg5, Nil, iif(Arg7 == 2, .T., .F.))

   cImageBOX3 := Wvt_SaveScreen(Arg3-2, Ci-4, Arg3 + 6 + Local1, cf+6)


   Local2:= win(Arg3, Ci-3, Arg3 + 5 + Local1, cf+3, Arg2, Arg8, Arg9)

   if (ISARRAY(Arg1))
      for Local4:= 1 to Local1
         DevPos(Arg3 + 1 + Local4, ci)
         vldevout(padc(Arg1[Local4],TamStr), Arg10)
      next
   else
      DevPos(Arg3 + 2, ci)
      vldevout(padc(Arg1,TamStr), Arg10)
   endif
   setcursor(0)
   Local4:= procbutton(Local3, 2, iif(Arg6 < 3, Arg6, 2))

   rstenv(Local2)
   Wvt_RestScreen(Arg3-2, Ci-4, Arg3 + 6 + Local1, cf+6,cImageBOX3)
   WvtSetBlocks( aLastPaint4 )

   RETURN Local4

   ********************************
function NEWBUTTON

   RETURN {}

********************************
function ADDBUTTON(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, ;
   Arg9)

   local Local1
   Arg5:= iif(At("&", Arg5) == 0, "&" + Arg5, Arg5)
   Arg7:= iif(ISNil(Arg7), .F., Arg7)
   Arg8:= iif(ISNil(Arg8), {|| Nil}, Arg8)
   Arg9:= iif(ISNil(Arg9), .T., Arg9)
   Local1:= SubStr(Arg5, At("&", Arg5) + 1, 1)
   AAdd(Arg1, {Arg5, Arg6, Arg8, Arg9, Arg7, Arg2, Arg3, Local1, ;
      Arg4})
   RETURN Nil

********************************
function PROCBUTTON(Arg1, Arg2, Arg3, Arg4)

   local Local1, Local2, Local3, Local4, Local5
   Local1:= setcursor(0)
   Local5:= 0
   Arg2:= iif(ISNil(Arg2), 1, Arg2)
   Arg3:= iif(ISNil(Arg3), 1, Arg3)

   showbutton(Arg1, Arg2, Arg4)

   do while (!Arg1[Arg3][4])
      Arg3:= iif(++Arg3 > Len(Arg1), 1, Arg3)
   enddo
   do while (Local5 == 0)
      showbutfoc(Arg1[Arg3], Arg2, Arg4)

      Local2:= waitstate()

      do case
      case Local2[1] == 1
         do case
         case (Local3:= ascan(Arg1, {|_1| Upper(Chr(Local2[2])) == ;
               Upper(_1[8])})) != 0
            Arg3:= butgoto(Arg1, Arg3, Local3, Arg2, Arg4)
            Arg3:= Local5:= butexecute(Arg1, Arg3, Arg2, Arg4)
         case Local2[2] == 19 .Or. Local2[2] == 271 .Or. Local2[2] ;
               == 5
            Arg3:= butleft(Arg1, Arg3, Arg2, Arg4)
         case Local2[2] == 4 .Or. Local2[2] == 9 .Or. Local2[2] == 24
            Arg3:= butright(Arg1, Arg3, Arg2, Arg4)
         case Local2[2] == 27
            if ((Local3:= ascan(Arg1, {|_1| _1[5]})) != 0 .And. ;
                  Arg1[Local3][4])
               Arg3:= butgoto(Arg1, Arg3, Local3, Arg2, Arg4)
               Arg3:= Local5:= butexecute(Arg1, Arg3, Arg2, Arg4)
            endif
         case Local2[2] == 13 .And. Arg1[Arg3][4]
            Arg3:= Local5:= butexecute(Arg1, Arg3, Arg2, Arg4)
         endcase
      case Local2[1] == 2
         if ((Local4:= chkbtmouse(Arg1, Local2)) != 0 .And. Local4 != Arg3)
            Arg3:= butgoto(Arg1, Arg3, Local4, Arg2, Arg4)
         endif
      case Local2[1] == 3
         if ((Local4:= chkbtmouse(Arg1, Local2)) != 0)
            Arg3:= butgoto(Arg1, Arg3, Local4, Arg2, Arg4)
            Arg3:= Local5:= butexecute(Arg1, Local4, Arg2, Arg4)
         endif
      case Local2[1] == 4
         if ((Local4:= chkbtmouse(Arg1, Local2)) != 0 .And. Local4 ;
               != Arg3)
            Arg3:= butgoto(Arg1, Arg3, Local4, Arg2, Arg4)
         endif
      endcase
   enddo
   setcursor(Local1)
   RETURN Local5

********************************
function SETKEYMOUSE(Arg1, Arg2)
   RETURN SETKEYMOUS(Arg1, Arg2)

function SETKEYMOUS(Arg1, Arg2)

   local Local1, Local2, Local3
   Local3:= {}
   if (PCount() == 1)
      Local1:= ascan(STATIC18, {|_1| _1[1] == Arg1})
      if (Local1 > 0)
         Local3:= STATIC18[Local1][2]
      endif
   elseif (Len(Arg2) == 4)
      Local1:= ascan(STATIC18, {|_1| _1[1] == Arg1})
      if (Local1 > 0)
         Local3:= STATIC18[Local1][2]
         STATIC18[Local1][1]:= Arg1
         STATIC18[Local1][2]:= Arg2
      else
         AAdd(STATIC18, {Arg1, Arg2})
      endif
   elseif (Len(Arg2) == 0)
      Local1:= ascan(STATIC18, {|_1| _1[1] == Arg1})
      if (Local1 > 0)
         Local3:= STATIC18[Local1][2]
         adel(STATIC18, Local1)
         asize(STATIC18, Len(STATIC18) - 1)
      else
      endif
   endif
   RETURN Local3

********************************
function SHOWBUTTON(Arg1, Arg2, Arg3)

   aeval(Arg1, {|_1| drawbutton(_1, Arg2, Arg3)})
   RETURN Nil

********************************
function SHOWBUTFOC(Arg1, Arg2, Arg3)

   drawbutton(Arg1, Arg2, Arg3, 2, .F.)
   showbutmsg(Arg1, Arg2, Arg3)
   RETURN Nil

********************************
function BUTGOTO(Arg1, Arg2, Arg3, Arg4, Arg5)

   hidebutfoc(Arg1[Arg2], Arg4, Arg5)
   Arg2:= iif(Len(Arg1) >= Arg3, Arg3, Arg2)
   showbutfoc(Arg1[Arg2], Arg4, Arg5)
   RETURN Arg2

********************************
function BUTEXECUTE(Arg1, Arg2, Arg3, Arg4)

   drawbutton(Arg1[Arg2], Arg3, Arg4, 3, .F., .F.)
   InKey(0.1) //.1
   drawbutton(Arg1[Arg2], Arg3, Arg4, 2, .F.)
   eval(Arg1[Arg2][3])
   InKey(0.1) //.1
   hidebutfoc(Arg1[Arg2], Arg3, Arg4)
   RETURN Arg2

********************************
function BUTLEFT(Arg1, Arg2, Arg3, Arg4)

   hidebutfoc(Arg1[Arg2], Arg3, Arg4)
   Arg2:= iif(--Arg2 == 0, Len(Arg1), Arg2)
   showbutfoc(Arg1[Arg2], Arg3, Arg4)
   RETURN Arg2

********************************
function BUTRIGHT(Arg1, Arg2, Arg3, Arg4)

   hidebutfoc(Arg1[Arg2], Arg3, Arg4)
   Arg2:= iif(++Arg2 > Len(Arg1), 1, Arg2)
   showbutfoc(Arg1[Arg2], Arg3, Arg4)
   RETURN Arg2

********************************
function CHKBTMOUSE(Arg1, Arg2)

   local Local1, Local2, Local3, Local4
   Local1:= nbut:= 0
   for Local1:= 1 to Len(Arg1)
      Local2:= Arg1[Local1][6]
      Local3:= Arg1[Local1][7]
      Local4:= Arg1[Local1][7] + Arg1[Local1][9] - 1
      if (Arg2[2] == Local2 .And. Arg2[3] >= Local3 .And. Arg2[3] <= ;
            Local4)
         nbut:= Local1
         exit
      endif
   next
   RETURN nbut

   ********************************
function MSGBOX4(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, ;
   Arg9, Arg10, Arg11, Arg12)

   local Local1, Local2, Local3, Local4
   LOCAL aBlocks := {}
   LOCAL aLastPaint4
   LOCAL lTelabox4
   
   aLastPaint4 := WvtSetBlocks( aBlocks )

   Arg4:= iif(ISNil(Arg4), "&Sim", Arg4)
   Arg5:= iif(ISNil(Arg5), "&NÆo", Arg5)
   Arg6:= iif(ISNil(Arg6), "&Cancelar", Arg6)
   Arg7:= iif(ISNil(Arg7), "&Outros", Arg7)

   Arg8:= iif(ISNil(Arg8), 1, Arg8)
   Arg9:= iif(ISNil(Arg9), 3, Arg9)
   Arg1:= iif(ISNil(Arg1), "", Arg1)
   Arg2:= iif(ISNil(Arg2), "Aten‡Æo!", Arg2)
   Local1:= iif(ISARRAY(Arg1), Len(Arg1), 1)
   Arg3:= iif(ISNil(Arg3), Int(12 - (Local1 + 7) / 2), Arg3)
   Arg10:= iif(ISNil(Arg10), "W+/R", Arg10)
   Arg11:= iif(ISNil(Arg11), "R/W*", Arg11)
   Arg12:= iif(ISNil(Arg12), "N*/W", Arg12)
   Local3:= newbutton()
   nColIni:=(MaxCol()-64) / 2
   addbutton(Local3, Arg3 + 3 + Local1, nColIni,16, Arg4, Nil, iif(Arg9 ;
      == 1, .T., .F.))
   addbutton(Local3, Arg3 + 3 + Local1, nColIni+17, 16, Arg5, Nil, iif(Arg9 ;
      == 2, .T., .F.))
   addbutton(Local3, Arg3 + 3 + Local1, nColIni+34, 16, Arg6, Nil, iif(Arg9 ;
      == 3, .T., .F.))
   addbutton(Local3, Arg3 + 3 + Local1, nColIni+51, 16, Arg7, Nil, iif(Arg9 ;
      == 3, .T., .F.))

   lTelabox4 = wvt_savescreen(Arg3, 6, Arg3 + 7 + Local1, MaxCol()-3)


   Local2:= win(Arg3, 6, Arg3 + 5 + Local1, MaxCol()-5, Arg2, Arg10, Arg11)
   if (ISARRAY(Arg1))
      for Local4:= 1 to Local1
         DevPos(Arg3 + 1 + Local4, 13)
         vldevout(padc(Arg1[Local4], MaxCol()-25), Arg12)
      next
   else
      DevPos(Arg3 + 2, 13)
      vldevout(padc(Arg1, MaxCol()-25), Arg12)
   endif
   setcursor(0)
   Local4:= procbutton(Local3, 2, iif(Arg8 < 3, Arg8, 2))

   wvt_restscreen(Arg3, 6, Arg3 + 7 + Local1, MaxCol()-3,lTelabox4)

*   rstenv(Local2)

   WvtSetBlocks( aLastPaint4 )
   RETURN Local4

********************************
STATIC function DRAWBUTTON(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)

   local Local1, Local2, Local3, Local4, Local5, Local6, Local7, ;
      Local8, Local9, Local10, Local11, Local12, Local13, Local14, ;
      Local15, Local16, Local17, Local18, Local19, Local20, Local21
   Arg4:= iif(ISNil(Arg4), 1, Arg4)
   Arg5:= iif(ISNil(Arg5), .T., Arg5)
   Arg6:= iif(ISNil(Arg6), .T., Arg6)
   Local10:= textbutton(Arg1[1])
   if (Arg2 == 1)
      Local1:= "N/W"
      Local2:= iif(Arg6, "W*/N", "N*/N")
      Local3:= "W+*/N"
      Local4:= "W*/N"
      Local6:= "W+*/N"
      Local7:= "N+*/N"
      Local9:= iif(Arg1[4], "GR+*/N", "W*/N")
   elseif (Arg2 == 2)
      Local1:= "N*/W"
      Local2:= iif(Arg6, "W+/W", "N/W")
      Local3:= "N/W"
      Local4:= "N+/W"
      Local6:= "N/W"
      Local7:= "W/W"
      Local9:= iif(Arg1[4], "R/W", "N/W")
   elseif (Arg2 == 3)
      Local1:= Arg3[1]
      Local2:= iif(Arg6, Arg3[2], Arg3[3])
      Local3:= Arg3[4]
      Local4:= Arg3[5]
      Local6:= Arg3[6]
      Local7:= Arg3[7]
      Local9:= iif(Arg1[4], Arg3[8], Arg3[5])
   endif
   if (Arg4 == 1)
      Local10:= padc(Local10, Arg1[9] - 3)
      Local11:= At(Upper(Arg1[8]), Upper(Local10)) - 1
      Local5:= iif(Arg1[4], Local3, Local4)
      Local8:= Local7
   elseif (Arg4 == 2)
      Local10:= padc(Local10, Arg1[9] - 3)
      Local11:= At(Upper(Arg1[8]), Upper(Local10)) - 1
      Local5:= iif(Arg1[4], Local3, Local4)
      Local8:= Local6
   elseif (Arg4 == 3)
      Local10:= " " + Left(padc(Local10, Arg1[9] - 3), Arg1[9] - 4)
      Local11:= At(Upper(Arg1[8]), Upper(Local10)) - 1
      Local5:= iif(Arg1[4], Local3, Local4)
      Local8:= Local6
   endif
   Local20:= At(alltrim(Local10), Local10) - 1
   Local21:= Local20 + Len(Arg1[1]) + 2
   if (Arg5)


     if alltrim(_FONTEN_) == "NORMAL"
       Local12:= "Ú"
       Local13:= "Ä"
       Local14:= "¿"
       Local15:= "³"
       Local16:= "Ù"
       Local17:= "Ä"
       Local18:= "À"
       Local19:= "³"
    else
       Local12:= "Õ"
       Local13:= iif(Arg6, "Ý", "×")
       Local14:= "©"
       Local15:= "º"
       Local16:= "½"
       Local17:= "Ð"
       Local18:= "Ó"
       Local19:= "Ü"
     endif
   else
     if alltrim(_FONTEN_) == "NORMAL"

      Local12:= "Ú"
      Local13:= "Ä"
      Local14:= "¿"
      Local15:= "³"
      Local16:= "Ù"
      Local17:= "Ä"
      Local18:= "À"
      Local19:= "³"
    else
      Local12:= "Õ"
      Local13:= "Ý"
      Local14:= "©"
      Local15:= "º"
      Local16:= "½"
      Local17:= "Ð"
      Local18:= "Ó"
      Local19:= "Ü"
    endif

   endif

      Local12:= chr(249)
      Local13:= chr(127)
      Local14:= chr(250)
      Local15:= chr(177)
      Local16:= chr(253)
      Local17:= chr(178)
      Local18:= chr(28)
      Local19:= chr(176)


*   DevPos(Arg1[6] - 1, Arg1[7])
*   vldevout(Local12, ;
*      Local1)


   * SUPERIOR

   DevPos(Arg1[6] - 1, Arg1[7]+1)
   vldevout(Replicate(Local13, Arg1[9] - 1), Local1)

   DevPos(Arg1[6] - 1, Arg1[7]+ Arg1[9] - 1)
   vldevout(Local14, Local1)

   DevPos(Arg1[6] - 1, Arg1[7])
   vldevout(Local12, Local1)


   DevPos(Arg1[6] + 1, Arg1[7]+1)
   vldevout(Replicate(Local17, Arg1[9] - 1), Local1)

   DevPos(Arg1[6] + 1, Arg1[7]+ Arg1[9] - 1)
   vldevout(Local16, Local1)

   DevPos(Arg1[6] + 1, Arg1[7])
   vldevout(Local18, Local1)



 *  vldevout(Local12 + Replicate(Local13, Arg1[9] - 3) + Local14, Local1)

*   DevPos(Arg1[6] - 1, Arg1[7]+1)
*   vldevout(Replicate(Local13, Arg1[9] - 2), ;
*      Local1)

   DevPos(Arg1[6], Arg1[7])             // LATERAL ESQUERDA |
   vldevout(Local19, Local1)

   DevPos(Arg1[6], Arg1[7] + 2)  // LETRAS
   vldevout(Local10, Local5)

   DevPos(Arg1[6], Arg1[7] + 1)
   vldevout("º", Local2)

   DevPos(Arg1[6], Arg1[7] + 2 + Local11)
   vldevout(Arg1[8], Local9)

   DevPos(Arg1[6], Arg1[7] + Arg1[9] - 1)
   vldevout(Local15, Local1)




   DevPos(Arg1[6], Arg1[7] + Local20)
   vldevout(iif( sbGuiSupport,"®","ò"), Local8)

   DevPos(Arg1[6], Arg1[7] + Local21)
   vldevout(iif( sbGuiSupport,"¯","ó"), Local8)

/*
   DevPos(Arg1[6] - 1, Arg1[7])
   vldevout(Local12 + Replicate(Local13, Arg1[9] - 2) + Local14, ;
      Local1)


   DevPos(Arg1[6], Arg1[7])
   vldevout(Local19, Local1)
   DevPos(Arg1[6], Arg1[7] + 1)

   vldevout("º", Local2)

   DevPos(Arg1[6], Arg1[7] + 2)
   vldevout(Local10, Local5)
   DevPos(Arg1[6], Arg1[7] + 2 + Local11)
   vldevout(Arg1[8], Local9)
   DevPos(Arg1[6], Arg1[7] + Arg1[9] - 1)
   vldevout(Local15, Local1)
   DevPos(Arg1[6] + 1, Arg1[7])
   vldevout(Local18 + Replicate(Local17, Arg1[9] - 2) + Local16, ;
      Local1)
   DevPos(Arg1[6], Arg1[7] + Local20)
   vldevout(iif( sbGuiSupport,"®","ò"), Local8)
   DevPos(Arg1[6], Arg1[7] + Local21)
   vldevout(iif( sbGuiSupport,"¯","ó"), Local8)
*/



   RETURN Nil

********************************
STATIC function SHOWBUTMSG(Arg1, Arg2, Arg3)

   local Local1
   Local1:= iif(Arg2 == 3, Arg3[9], "R*/W")
   if (Arg1[2] != Nil .Or. Arg1[2] != "")
      dwnmsg(Arg1[2], Local1)
   endif
   RETURN Nil

********************************
STATIC function HIDEBUTFOC(Arg1, Arg2, Arg3)

   drawbutton(Arg1, Arg2, Arg3, 1, .T.)
   RETURN Nil

********************************
function VLExit(Arg1, Arg2, Arg3, Arg4)

   local Local1
   //Local1:= savenv(33, 0, 33, 79)
   Arg4:= iif(ISNil(Arg4), .T., Arg4)

   if lLog = .t.  // entra no modulo de alteracao
     alertnew("Voce esta no modulo de permissoes;Conclua a alteracao das senhas",{"Ok"},,,,,,,"VERDE")
     return nil
   endif


do while .t.
SELEEMPRESA()
*  veremp()                               && carrega variavel M_EMP

  if lastkey() = 27
    finaliza()
    loop
  endif
  exit
enddo



// voltar

Wvt_RestScreen(2, 0, maxrow()-2, maxcol(), cInicIMG4,.f. )  // restaura a tela
wvt_DrawImage(2, 0, maxrow()-2, maxcol(), AEMP00->EMPLOGO)
*cInicIMG4 := Wvt_SaveScreen(2, 0, maxrow(), maxcol())  // salva a tela


Desktop(alltrim(AEMP00->EMPNOM)) //Fun‡Æo que inicializa a Visual Lib - Sempre deve ser chamada no inicio


return .t.



   do while .t.
     veremp()                               && carrega variavel M_EMP
     if lastkey() = 27

     if (!Arg4)
        if sbGuiSupport
           vlmouseoff()
           set color to
           vlscroll()
           SetPos(0, 0)
           close databases
           setcursor(1)
        else
           vlmouseoff()
           set color to n/n
           setcursor(0)
           vlscroll()
  *         run vlfont.exe off

           set color to
           vlscroll()
           SetPos(0, 0)
           vlsetmode(25, MaxCol()+1)
           close databases
           vlsetblink(.T.)
           setcursor(1)
        end
        quit
     elseif (msgbox2("Confirma o encerramento ?", "Sa¡da", Nil, Nil, ;
           Nil, Nil, 2) == 1)
        if sbGuiSupport
           setcursor(0)
           vlmouseoff()
           set color to
           vlscroll()
           SetPos(0, 0)
           close databases
           setcursor(1)
        else
           setcursor(0)
           vlmouseoff()
           set color to n/n
           vlscroll()
  *         run vlfont.exe off

           set color to
           vlscroll()
           SetPos(0, 0)
           vlsetmode(25, MaxCol()+1)
           close databases
           vlsetblink(.T.)
           setcursor(1)
        end
        quit
     endif

       loop
     endif
     exit
   enddo

   Desktop(alltrim(AEMP00->EMPNOM)) //Fun‡Æo que inicializa a Visual Lib - Sempre deve ser chamada no inicio

   //rstenv(Local1)
   RETURN Nil

********************************
STATIC function TEXTBUTTON(Arg1)

   local Local1, Local2, Local3, Local4
   Local1:= ""
   Local2:= At("&", Arg1)
   Local3:= SubStr(Arg1, 1, Local2 - 1)
   Local4:= SubStr(Arg1, Local2 + 1)
   RETURN iif(Local2 != 0, Local3 + Local4, Arg1)

********************************
function VLSETMODE(Arg1, Arg2)

   local Local1, Local2
   Local1:= vlsetmouse(.F.)
   Local2:= setmode(Arg1, Arg2)
   vlmouseini()
   vlsetmouse(Local1)
   RETURN Local2

function vlSetBlink( l )
   STATIC x := .T.
   local u  := x
   local c := setcursor(0)
   if sbGuiSupport; RETURN u; end
   if l <> nil
      l := 'vlfont.exe ' + iif( !l, 'noblink', 'blink' )
      __Run( l )
   endif
   setcursor(c)
   RETURN u


**************
function _SEEK                         && pesquisa
**************

  parameters F_CHAVE

  seek F_CHAVE

  if !eof()
    return .t.
  endif

return .f.


**************
function MOD11_STD                         && calculo digito verificador
**************

parameters F_DIG

private M_SOMA  ,;
        M_DIG

M_SOMA = (val(substr(F_DIG, 7, 1)) * 2) + ;
         (val(substr(F_DIG, 6, 1)) * 3) + ;
         (val(substr(F_DIG, 5, 1)) * 4) + ;
         (val(substr(F_DIG, 4, 1)) * 5) + ;
         (val(substr(F_DIG, 3, 1)) * 6) + ;
         (val(substr(F_DIG, 2, 1)) * 7) + ;
         (val(substr(F_DIG, 1, 1)) * 8)

M_DIG = iif((M_SOMA % 11)=0,0,iif((M_SOMA % 11)=1,0,(11-(M_SOMA % 11))))

return str(M_DIG, 1, 0)

********************************
function MSGBOX1(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7)

   local Local1, Local2, Local3, Local4
   LOCAL aBlocks := {}
   LOCAL aLastPaint4
   aLastPaint4 := WvtSetBlocks( aBlocks )

   Arg4:= iif(ISNil(Arg4), "OK", Arg4)
   Arg1:= iif(ISNil(Arg1), "", Arg1)
   Arg2:= iif(ISNil(Arg2), "Aten‡Æo!", Arg2)
   Local1:= iif(ISARRAY(Arg1), Len(Arg1), 1)
   Arg3:= iif(ISNil(Arg3), Int(12 - (Local1 + 5) / 2), Arg3)
   Arg5:= iif(ISNil(Arg5), "W+/R", Arg5)
   Arg6:= iif(ISNil(Arg6), "R/W*", Arg6)
   Arg7:= iif(ISNil(Arg7), "N*/W", Arg7)

   ciAdicional = 0
   TamStr = 0
   TamOpc = 0
   TamOpc += len(Arg4)+4

   if (ISARRAY(Arg1)) // mensagem
     for Local4:= 1 to len(Arg1)
       TamStr = iif(len(Arg1[Local4]) > TamStr,len(Arg1[Local4]),TamStr)
     next
   else
     TamStr = len(Arg1)
   endif

   if TamOpc < TamStr
     ciAdicional = (TamStr-TamOpc)/2
   endif

   TamStr = iif(TamStr>TamOpc,TamStr,TamOpc)

   Ci:=((maxcol()-TamStr)/2)
   Cf:=Ci+TamStr

   Local3:= newbutton()

   addbutton(Local3, Arg3 + 3 + Local1,Ci+ciAdicional,len(Arg4)+6, Arg4, Nil,.T.)

   Local2:= win(Arg3, Ci-3, Arg3 + 5 + Local1, cf+3       , Arg2, Arg5, Arg6)

   if (ISARRAY(Arg1))
      for Local4:= 1 to Local1
         DevPos(Arg3 + 1 + Local4, ci)
         vldevout(padc(Arg1[Local4],TamStr), Arg7)
      next
   else
      DevPos(Arg3 + 2, ci)
      vldevout(padc(Arg1,TamStr)      , Arg7)
   endif
   setcursor(0)
   procbutton(Local3, 2, 1)

   rstenv(Local2)
   WvtSetBlocks( aLastPaint4 )
   RETURN Nil

**************
function MESES(TIPO)
**************

private MT_MES[12]

declare MT_MES[12]

MT_MES[ 1] = "JANEIRO"
MT_MES[ 2] = "FEVEREIRO"
MT_MES[ 3] = "MARCO"
MT_MES[ 4] = "ABRIL"
MT_MES[ 5] = "MAIO"
MT_MES[ 6] = "JUNHO"
MT_MES[ 7] = "JULHO"
MT_MES[ 8] = "AGOSTO"
MT_MES[ 9] = "SETEMBRO"
MT_MES[10] = "OUTUBRO"
MT_MES[11] = "NOVEMBRO"
MT_MES[12] = "DEZEMBRO"

return MT_MES[TIPO]


***************
Function JANELA(Li,Ci,Lf,Cf,Cor)
***************

sombra(li,Ci,Lf,Cf,_SOMBRA_)
SetColor(Cor)
@ li,Ci,Lf,Cf box M_FRAME1
painel(li, ci, lf, cf,"G+/G","N/G")
Return ""

function IMPTELA

local cSrc := ""
local cLin
local l,c

for l := 0 to 24
  clin := SaveScreen(l,0,l,80)
  for c := 1 to 80
    cLin := Stuff(clin,c+1,1,"")
  next
  cSrc += cLin+chr(13)+chr(10)
next

set console off
set print on
set printer to "TELA.TXT"

? cSrc
set printer to
set print off

filecopy("TELA.TXT","RELATO.RPT",.T.)
M_IMPRE = "L"
desliga(80)

set console on

return ""

* PROXIMA SENHA 498

**************
Function ALERT2(string,Opcoes,som,poslinha,limpar,semopc,corfundo)
**************
Local CorSalva:=SetColor()
Local TamOpc:=0, TamStr:=0, nPos
Local NroLin:=1,A,linhas,texto
Local linha

if corfundo = NIL
  corfundo = "W+/G"
endif

if limpar = NIL
  limpar = .t.
endif

if SemOpc = NIL
  SemOpc = .f.
endif

if poslinha = NIL
  poslinha = 0
endif

linha = { }
texto = ""

for A = 1 to len(String)
  if substr(String,A,1) == ";"
    aadd(linha,TEXTO)
    TamStr = iif(len(TEXTO) > TamStr,len(TEXTO),TamStr)
    texto = ""
    NroLin ++
  else
    texto += substr(String,A,1)
  endif
next

TamStr = iif(len(TEXTO) > TamStr,len(TEXTO),TamStr)
aadd(linha,TEXTO)

If Opcoes == Nil
  if !SemOpc
    Opcoes:={"$Ok"}
  endif
EndIf

if !SemOpc
  For I:=1 To Len(Opcoes)
    nPos:=At("$",Opcoes[I])
    If nPos = 0
      TamOpc+=Len(Opcoes[I])
    Else
      TamOpc+=Len(Opcoes[I]) -1
    EndIf
  Next
  NroOpc:=Len(Opcoes)
else
  NroOpc:=0
endif


TamOpc+=(4*NroOpc)+(3*(NroOpc-1))
Li:=(maxrow()-NroLin-poslinha)/2
Lf:=Li+NroLin+4
TamStr = iif(TamStr>TamOpc,TamStr,TamOpc)

Ci:=((maxcol()-TamStr)/2)
Cf:=Ci+TamStr

*Telaalert:=SaveScreen(Li,Ci-3,Lf+1,Cf+3)

res1 = Li-3
res2 = Ci-3
res3 = Lf+4
res4 = Cf+5

Telaalert2:=WvT_SaveScreen(res1,res2,res3,res4)

nbox(li,ci-2,lf,cf+2,corfundo)
setcolor(corfundo)


ColBot:=((80-TamOpc)/2)+1
Li+=1

For I:= 1 To NroLin
  @ Li++,Ci Say Padc(linha[I],(Cf-Ci)+2)
Next

if !SemOpc
  Opc:=Botaoa(Lf-2,ColBot,Opcoes,som)
endif

if limpar
  *RestScreen(Li,Ci-3,Lf+1,Cf+3,Telaalert)
  WvT_RestScreen(res1,res2,res3,res4,Telaalert2)
 * zrevwindow()
endif

SetColor(CorSalva)

if !SemOpc
  Return(Opc)
else
  return 0
endif

**************
Function Botaoa(Li,Ci,Opcoes,som)
**************

// Parametros
//** Li - Linha onde vai ser desenhado o botao
//** Ci - Coluna Inicial onde vai ser comecado a desenhar o botao
//** Opcoes - Matriz com as Opcäes

Local CorSalva:=SetColor(), Col:={}, nPos, nTam, OpcAnt, nPosAnt
Local NroOpc:=Len(Opcoes), LetraCon:={}, NumOpc:=1, Escolheu:=.F.
Local CorFundo:=SubStr(CorSalva,At("/",CorSalva)+1,At(",",CorSalva)-At("/",CorSalva)-1)
Local CursorSalvo:=SetCursor()

Local CorBot1:="W+/BG", CorBot2:="GR+/BG"  // Variaveis que setam as
Local CorBot3:="W+/R" , CorBot4:="GR+/R"   // Cores do Botao

SetCursor(0)
For I:=1 To Len(Opcoes)
  nPos:=At("$",Opcoes[I])
  If nPos = 0
    nPos:=1
    Opcoes[I]:="$"+Opcoes[I]
  EndIf
  nTam:=Len(Opcoes[I]) - 1
  SetColor("B/B")
  @ Li  ,Ci+nTam+4 Say " "
  SetColor("U/"+ CorFundo)

  @ Li+1,Ci+1 Say Replicate("ß",nTam+4)
  AADD(Col,Ci)
  AADD(LetraCon,Upper(SubStr(Opcoes[I],nPos+1,1)))
  SetColor(CorBot1)
  @ Li,Ci Say "  " + SubStr(Opcoes[I],1,nPos - 1)
  @ Li,Ci+nPos+2 Say SubStr(Opcoes[I],nPos+2) +  "  "
  SetColor(CorBot2)
  @ Li,Ci+nPos+1 Say SubStr(Opcoes[I],nPos+1,1)
  Ci+=nTam+7
Next

nPos:=At("$",Opcoes[1])
SetColor(CorBot3)
@ Li,Col[1] Say " <" + SubStr(Opcoes[1],1,nPos - 1)
@ Li,Col[1]+nPos+2 Say SubStr(Opcoes[1],nPos+2) +  "> "
SetColor(CorBot4)
@ Li,Col[1]+nPos+1 Say SubStr(Opcoes[1],nPos+1,1)

Do While .T.

  do while .t.
    Tecla  :=ninkey()
    if Tecla > 0
      exit
    endif
    if som = nil
    else
      Tecla  :=ninkey()
      if Tecla > 0
        exit
      endif
      Tecla  :=ninkey()
      if Tecla > 0
        exit
      endif
    endif
  enddo

  OpcAnt :=NumOpc
  nPosAnt:=AT("$",Opcoes[NumOpc])

  If Tecla = 19 .or. Tecla = 5
    If NumOpc = 1
      NumOpc:=Len(Opcoes)
    Else
      NumOpc--
    EndIf
  ElseIf Tecla = 4 .or. Tecla = 24
    If NumOpc = Len(Opcoes)
      NumOpc:=1
    Else
      NumOpc++
    EndIf
  ElseIf (Tecla >= 65 .and. Tecla <= 90)  .or.;
    (Tecla >= 97 .and. Tecla <= 122) .or.;
    (Tecla >= 48 .and. Tecla <= 57)
    Letra:=Upper(Chr(Tecla))
    If Ascan(LetraCon,Letra) # 0
      NumOpc:=Ascan(LetraCon,Letra)
      Escolheu:=.T.
    Else
      Loop
    EndIf
  ElseIf Tecla = 13 .or.;
    Tecla = 32
    Escolheu:=.T.
  ElseIf Tecla = 27
    NumOpc:=0
    Exit
  EndIf

  If Escolheu = .T.

    If OpcAnt # NumOpc

      SetColor(CorBot1)
      @ Li,Col[OpcAnt] Say "  " + SubStr(Opcoes[OpcAnt],1,nPosAnt-1)
      @ Li,Col[OpcAnt]+nPos+2 Say SubStr(Opcoes[OpcAnt],nPosAnt+2) +  "  "
      SetColor(CorBot2)
      @ Li,Col[OpcAnt]+nPos+1 Say SubStr(Opcoes[OpcAnt],nPosAnt+1,1)

    EndIf

    nTam:=Len(Opcoes[NumOpc]) - 1
    SetColor(CorFundo + "/" + CorFundo)
    @ Li,Col[NumOpc]+nTam+4 Say Replicate("Û",1)
    @ Li+1,Col[NumOpc] Say Replicate("ß",nTam+5)
    @ Li,Col[NumOpc] Say "Û"
    @ Li,Col[NumOpc]+1 Say Replicate("Û",nTam+3)

    nPos:=At("$",Opcoes[NumOpc])
    SetColor(CorBot3)
    @ Li,Col[NumOpc]+1 Say "  " + SubStr(Opcoes[NumOpc],1,nPos - 1)
    @ Li,Col[NumOpc]+nPos+3 Say SubStr(Opcoes[NumOpc],nPos+2) +  "  "
    SetColor(CorBot4)
    @ Li,Col[NumOpc]+nPos+2 Say SubStr(Opcoes[NumOpc],nPos+1,1)
    ninkey(0.1)
    Exit
  EndIf

  SetColor(CorBot1)
  @ Li,Col[OpcAnt] Say "  " + SubStr(Opcoes[OpcAnt],1,nPos - 1)
  @ Li,Col[OpcAnt]+nPos+2 Say SubStr(Opcoes[OpcAnt],nPos+2) +  "  "
  SetColor(CorBot2)
  @ Li,Col[OpcAnt]+nPos+1 Say SubStr(Opcoes[OpcAnt],nPos+1,1)

  nPos:=At("$",Opcoes[NumOpc])
  SetColor(CorBot3)
  @ Li,Col[NumOpc] Say " <" + SubStr(Opcoes[NumOpc],1,nPos - 1)
  @ Li,Col[NumOpc]+nPos+2 Say SubStr(Opcoes[NumOpc],nPos+2) +  "> "
  SetColor(CorBot4)
  @ Li,Col[NumOpc]+nPos+1 Say SubStr(Opcoes[NumOpc],nPos+1,1)

EndDo
SetColor(CorSalva)
SetCursor(CursorSalvo)
Return(NumOpc)

**************************
function GetF2(oGet,funcao,retorno,validar)
**************************

local nKey,nChar,cKey

set cursor on

if (GetPrevalidate(oGet))
  oGet:SetFocus()
  oGet:cargo:=""
*  n_tempo = time()

  while(oGet:exitState==GE_NOEXIT)
    if(oget:typeOut)
      oGet:exitState:=GE_ENTER
    endif
    do while(oGet:exitState==GE_NOEXIT)
      nKey:=may_inkey(0)  // inkey(0)

      do case
        CASE ( nKey == K_INS )
        SET( _SET_INSERT, !SET( _SET_INSERT ) )
        ShowScoreboard()

        CASE ( nKey == K_HOME )
        oGet:home()

        CASE ( nKey == K_END )
        oGet:end()

        CASE ( nKey == K_RIGHT )
        oGet:right()

        CASE ( nKey == K_LEFT )
        oGet:left()

        CASE ( nKey == K_DEL )
        oGet:delete()

        CASE ( nKey == K_UP )
        oGet:exitState := GE_UP

        CASE ( nKey == K_SH_TAB )
        oGet:exitState := GE_UP

        CASE ( nKey == K_DOWN )
        oGet:exitState := GE_DOWN

        CASE ( nKey == K_TAB )
        oGet:exitState := GE_DOWN
        case ( nKey == K_ESC )
          oGet:undo()
          oGet:exitState := GE_ESCAPE
        case ( nKey == K_F2 )
          &funcao
          retorno = nCodRetorno
          oGet:updateBuffer()
        endcase
      if nkey>=32.and.nkey<=255
        oGet:cargo+=chr(nkey)
        getApplykey(oGet,chr(nkey))
      elseif nkey==K_BS
        oGet:cargo:=substr(oGet:cargo,1,len(oGet:cargo)-1)
        GetApplykey(oGet,nKey)
      elseif nkey==K_ENTER
        GetApplykey(oGet,nKey)
      elseif !(( bKeyBlock := setkey( nKey )) == NIL )
        GetDoSetKey( bKeyBlock, oGet )
      endif
    enddo
    if(!GetPostValidate(oGet))
      oGet:exitState:=GE_NOEXIT
    endif
  enddo
  oget:KillFocus()
endif

return""

*******************************
procedure SHOWSCOREBOARD()
*******************************

LOCAL nRow
LOCAL nCol

IF ( SET( _SET_SCOREBOARD ) )
nRow := ROW()
nCol := COL()

SETPOS( SCORE_ROW, SCORE_COL )
DISPOUT( IF( SET( _SET_INSERT ), NationMsg(_GET_INSERT_ON),;
NationMsg(_GET_INSERT_OFF)) )
SETPOS( nRow, nCol )
endif

RETURN
