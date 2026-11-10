#include "ptmenu.ch"

***************
function MANPCH
***************
parameters M_OPC,M_OPC1,M_OPC2


      rodape("MENU","PARAMETROS",M_FAN,"EAGRO34F","Mem: " + str(memory(0), 5),M_EMP) 

*        @ 05, 52 prompt "Inclusao " HIGHLITE R/BG PERMITE 6,5,1
*        @ 06, 52 prompt "Alteracao" HIGHLITE R/BG PERMITE 6,5,2
*        @ 07, 52 prompt "Consultas" HIGHLITE R/BG PERMITE 6,5,3
*        @ 08, 52 prompt "Exclusao " HIGHLITE R/BG PERMITE 6,5,4
*        @ 09, 52 prompt "Listagens" HIGHLITE R/BG PERMITE 6,5,5
*        @ 10, 52 prompt "Lay-Out  " HIGHLITE R/BG PERMITE 6,5,6

      do case
         case M_OPC = 1 ; incpch()
         case M_OPC = 2 ; altpch()   
         case M_OPC = 3 ; conpch()     
         case M_OPC = 4 ; excpch()   
         case M_OPC = 5 ; lispch()   
         case M_OPC = 6 ; laypch()   
      endcase

    fecha_arq()

return ""

***************  
function INCPCH
***************  

private M_OPC

    do while .t.

      M_PCHBAN = 0
      M_PCHMA1 = 51
      M_PCHMA2 = 13
      M_PCHMA3 = 2
      M_PCHMA4 = 2
      M_PCHMA5 = 25
      M_PCHET1 = 0
      M_PCHET2 = 1
      M_PCHET3 = 1
      M_PCHET4 = 1
      M_PCHET5 = 2
      M_PCHET6 = 14
      M_PCHES1 = 1
      M_PCHES2 = 3
      M_PCHES3 = 8
      M_PCHPL1 = "X"
      M_PCHPL2 = " "

      tlpch01()                         && monta tela inicial 
                                                             
      rodape("INCLUI","PARAMETROS",M_FAN,"EAGRO34F","Mem: " + str(memory(0), 5),M_EMP) 

      SetColor(_COREDICAO_)
      @ 06, 26 get     M_PCHBAN picture "###"
      read

      if M_PCHBAN = 0
         exit
      endif        

      select APCH00

      if dbseek(str(M_PCHBAN, 3, 0))
        msg("* * * PARAMETROS JA CADASTRADO * * *")
        loop
      endif

      edpch01()

      if lastkey() = 27
        msg("* * * PARAMETRO NAO INCLUIDO * * *")
        loop
      endif

      select APCH00

      _append("APCH00")

        grpch01()             

        msg("* * * PARAMETRO INCLUIDO * * *")

     enddo

return ""

***************  
function ALTPCH
***************  

private M_OPC

    do while .t.

      M_PCHBAN = 0

      tlpch01()                         && monta tela inicial 
                                                             
      rodape("ALTERA","PARAMETROS",M_FAN,"EAGRO34F","Mem: " + str(memory(0), 5),M_EMP) 

      SetColor(_COREDICAO_)
      @ 06, 26 get     M_PCHBAN picture "###"
      read

      if M_PCHBAN = 0
         exit
      endif        

      select APCH00

      if !dbseek(str(M_PCHBAN, 3, 0))
        msg("* * * PARAMETROS NAO CADASTRADO * * *")
        loop
      endif

      if !rlock()
        msg("* * * (APCH00) REGISTRO SENDO USADO * * *")
        loop
      endif

      M_PCHMA1 = PCHMA1
      M_PCHMA2 = PCHMA2
      M_PCHMA3 = PCHMA3
      M_PCHMA4 = PCHMA4
      M_PCHMA5 = PCHMA5
      M_PCHET1 = PCHET1
      M_PCHET2 = PCHET2
      M_PCHET3 = PCHET3
      M_PCHET4 = PCHET4
      M_PCHET5 = PCHET5
      M_PCHET6 = PCHET6
      M_PCHES1 = PCHES1
      M_PCHES2 = PCHES2
      M_PCHES3 = PCHES3
      M_PCHPL1 = PCHPL1
      M_PCHPL2 = PCHPL2

      edpch01()

      if lastkey() = 27
        msg("* * * PARAMETRO NAO ALTERADO * * *")
        unlock
        loop
      endif

      grpch01()             

      msg("* * * PARAMETRO ALTERADO * * *")

   enddo

return ""

***************  
function CONPCH
***************  

private M_OPC

    do while .t.

      M_PCHBAN = 0

      tlpch01()                         && monta tela inicial 
                                                             
      rodape("CONSULTA","PARAMETROS",M_FAN,"EAGRO34F","Mem: " + str(memory(0), 5),M_EMP) 

      SetColor(_COREDICAO_)
      @ 06, 26 get     M_PCHBAN picture "###"
      read

      if M_PCHBAN = 0
         exit
      endif        

      select APCH00

        set softseek on
          seek str(M_PCHBAN, 3, 0)
        set softseek off

        setas()

        do while .t.

          if PCHBAN = 0
            skip
            if eof()
              msg("* * * ARQUIVO VAZIO * * *")
              exit
            endif
            loop
          endif          

          mspch01()

          inkey(0)

          if lastkey() = 5
             skip - 1
          endif         

          if lastkey() = 24
            skip
          endif

          if eof() 
            go top
          endif

          if bof()
            go bottom
          endif

          if lastkey() = 27
            exit
          endif

        enddo 

        set cursor on
        set order to 1

    enddo

return ""

***************  
function EXCPCH
***************  

private M_OPC

    do while .t.

      M_PCHBAN = 0

      tlpch01()                         && monta tela inicial 
                                                             
      rodape("EXCLUI","PARAMETROS",M_FAN,"EAGRO34F","Mem: " + str(memory(0), 5),M_EMP) 

      SetColor(_COREDICAO_)
      @ 06, 26 get     M_PCHBAN picture "###"
      read

      if M_PCHBAN = 0
         exit
      endif        

      select APCH00

      if !dbseek(str(M_PCHBAN, 3, 0))
        msg("* * * PARAMETROS NAO CADASTRADO * * *")
        loop
      endif

      mspch01()

      if !rlock()
        msg("* * * (APCH00) REGISTRO SENDO USADO * * *")
        loop
      endif
       
      M_OPC = confirma("do Parametro")

        if M_OPC != 1
          msg("* * * PARAMETRO NAO EXCLUIDO * * *")
          unlock
          loop
        endif
        elimina()

      msg("* * * PARAMETRO EXCLUIDO * * *")

   enddo

return ""

***************  
function LISPCH
***************  

  do while .t.

      M_BCOINI = 0 
      M_BCOFIN = 0

 nbox(12, 51, 15, 72,"W/W+",.t.)
 setcolor("B/W")
        @ 13, 52 say " Banco Inicial:     "
        @ 14, 52 say "         Final:     "

      SetColor(_COREDICAO_)
      @ 13, 68 get M_BCOINI picture "###"
      @ 14, 68 get M_BCOFIN picture "###" 
      read

      if lastkey() = 27
        exit
      endif

      M_BCOINI = iif(M_BCOINI = 0,  1,M_BCOINI)
      M_BCOFIN = iif(M_BCOFIN = 0,999,M_BCOFIN) 

      select APCH00
 
      set softseek on
        seek str(M_BCOINI, 3, 0)
      set softseek off

      M_IMPRE = impresn()

      if M_IMPRE = "N"
        loop
      endif

    store 0 to PG

    do while !eof()

        store PG + 1 to PG

        if PG > 1
            eject
        endif

        ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE PARAMETROS","EAGRO34F",80) 
        ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
        ? "*-----*--------------------*---------------------*--------------*--------------*"
        ? "*BANCO*       MARGENS      *      ENTRELINHA     *    ESPACOS   * 1/8      1/6 *"
        ? "*-----*--------------------*---------------------*--------------*--------------*"
*             999    99 99 99 99 99      99 99 99 99 99 99     99 99 99 99   X          X

        store 5 to LN

        do while !eof() .and. LN < 60

          if  PCHBAN > M_BCOFIN
            go bottom
            skip
            loop
          endif 

            ? "   "
              ?? PCHBAN
              ?? "    "
              ?? PCHMA1
              ?? " "
              ?? PCHMA2
              ?? " "
              ?? PCHMA3
              ?? " "
              ?? PCHMA4
              ?? " "
              ?? PCHMA5
              ?? "      "
              ?? PCHET1
              ?? " "
              ?? PCHET2
              ?? " "
              ?? PCHET3
              ?? " "
              ?? PCHET4
              ?? " "
              ?? PCHET5
              ?? " "
              ?? PCHET6
              ?? "      "
              ?? PCHES1
              ?? " "
              ?? PCHES2
              ?? " "
              ?? PCHES3
              ?? "     "
              ?? PCHPL1
              ?? "          "
              ?? PCHPL2
  
            store LN + 1 to LN

            skip

            M_ESC = inkey()

            if M_ESC = 27
                if susimp()
                  ? replicate("-", 80)
                  ? "* * * IMPRESSAO SUSPENSA * * *"
                  go bottom
                  skip
                else
                  M_ESC = inkey()
                endif
            endif

        enddo

    enddo

    ? replicate("-", 80)

    eject

desliga()
  enddo  

return ""

***************  
function LAYPCH
***************  

  do while .t.

     M_BANCO = 0

 nbox(12, 51, 15, 77,"W/W+",.t.)
 setcolor("B/W")
        @ 13, 52 say "     Numero do Banco     "
        @ 14, 52 say "                         "
      SetColor(_COREDICAO_)

      @ 14, 62 get M_BANCO picture "###" 
      read

      if M_BANCO = 0
        exit
      endif

      select APCH00

      if !dbseek(str(M_BANCO, 3, 0))
        msg("* * * BANCO NAO CADASTRADO * * *")
        return ""
      endif

      M_IMPRE = impresn()

      if M_IMPRE = "N"
        loop
      endif

      ?? chr(27) + "@"

      if PCHPL1 = "X"
        ?? chr(27) + "0" 
      endif

      ?? chr(27) + "x" + "1"

      for R=1 to PCHET1
        ?
      next

      ? space(PCHMA1)
        ?? "###.###.###,##"

      for R=1 to PCHET2
        ?
      next

      ? space(PCHMA2)
        ?? "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

      for R=1 to PCHET3
        ?
      next 

      ? space(PCHMA3)
        ?? "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

      for R=1 to PCHET4
        ?
      next 

      ? space(PCHMA4)
        ?? "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

      for R=1 to PCHET5
        ?
      next 

      ? space(PCHMA5) 
        ?? "XXXXXXXXXXXXXXX"
        ?? space(PCHES1)
        ?? "99"
        ?? space(PCHES2)
        ?? "XXXXXXXXX"
        ?? space(PCHES3)
        ?? "99"

      for R = 1 to PCHET6
        ?
      next

desliga()
  enddo  

return ""

****************
function TLPCH01
****************

 nbox(05, 17, 19, 62,"W/W+",.t.)
 setcolor("B/W")
  @ 06, 18 say " Banco:                                     "
  @ 07, 18 say "                  ÄÄÄÄÄÄÄÄÄÄ¿    ( ) 1/8    "
  @ 08, 18 say "         Valor              ³               "
  @ 09, 18 say "                  ÄÄÄÄÄÄÄÄÄÄ´    ( ) 1/6    "
  @ 10, 18 say "        Extenso 1           ³               "
  @ 11, 18 say "                  ÄÄÄÄÄÄÄÄÄÄÅÄÄÄ ENTRELINHA "
  @ 12, 18 say "        Extenso 2           ³               "
  @ 13, 18 say "                  ÄÄÄÄÄÄÄÄÄÄ´               "
  @ 14, 18 say "        Portador            ³ ÚÄ ESPACOS    "
  @ 15, 18 say "                  ÄÄÄÄÄÄÄÄÄÄ´               "
  @ 16, 18 say "        Cidade    Dia    Mes³   Ano         "
  @ 17, 18 say "   ³              ÄÄÄÄÄÄÄÄÄÄÙ               "
  @ 18, 18 say "   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ MARGENS    "

  @ 11, 49 say chr(16)
  @ 14, 49 say chr(16)
  @ 18, 49 say chr(16)
set color to 

return ""

****************
function EDPCH01
****************

  SetColor(_COREDICAO_)
  @ 08, 21 get  M_PCHMA1 picture "##"
  @ 10, 21 get  M_PCHMA2 picture "##"  
  @ 12, 21 get  M_PCHMA3 picture "##"  
  @ 14, 21 get  M_PCHMA4 picture "##"  
  @ 16, 21 get  M_PCHMA5 picture "##"

  @ 07, 29 get  M_PCHET1 picture "##"  
  @ 09, 29 get  M_PCHET2 picture "##"  
  @ 11, 29 get  M_PCHET3 picture "##"  
  @ 13, 29 get  M_PCHET4 picture "##"  
  @ 15, 29 get  M_PCHET5 picture "##"
  @ 17, 29 get  M_PCHET6 picture "##"  

  @ 16, 33 get  M_PCHES1 picture "##"  
  @ 16, 40 get  M_PCHES2 picture "##"
  @ 16, 47 get  M_PCHES3 picture "##"  

  @ 07, 52 get  M_PCHPL1 picture "@!" valid(M_PCHPL1 $ "X ") 
  @ 09, 52 get  M_PCHPL2 picture "@!" valid(M_PCHPL2 $ "X ") 
  read

return ""

****************
function MSPCH01
****************

 setcolor("N/W*")
  @ 06, 26 say  PCHBAN picture "###"
  @ 08, 21 say  PCHMA1 picture "##"  
  @ 10, 21 say  PCHMA2 picture "##"  
  @ 12, 21 say  PCHMA3 picture "##"  
  @ 14, 21 say  PCHMA4 picture "##"  
  @ 16, 21 say  PCHMA5 picture "##"

  @ 07, 29 say  PCHET1 picture "##"  
  @ 09, 29 say  PCHET2 picture "##"  
  @ 11, 29 say  PCHET3 picture "##"  
  @ 13, 29 say  PCHET4 picture "##"  
  @ 15, 29 say  PCHET5 picture "##"
  @ 17, 29 say  PCHET6 picture "##"  

  @ 16, 33 say  PCHES1 picture "##"  
  @ 16, 40 say  PCHES2 picture "##"
  @ 16, 47 say  PCHES3 picture "##"  

  @ 07, 52 say  PCHPL1 picture "@!" 
  @ 09, 52 say  PCHPL2 picture "@!" 
set color to

return ""

****************
function GRPCH01
****************

   select APCH00

     do while .t. 
       if rlock()                   
         replace PCHBAN with   M_PCHBAN

         replace PCHMA1 with   M_PCHMA1
         replace PCHMA2 with   M_PCHMA2
         replace PCHMA3 with   M_PCHMA3
         replace PCHMA4 with   M_PCHMA4
         replace PCHMA5 with   M_PCHMA5

         replace PCHET1 with   M_PCHET1
         replace PCHET2 with   M_PCHET2
         replace PCHET3 with   M_PCHET3
         replace PCHET4 with   M_PCHET4
         replace PCHET5 with   M_PCHET5
         replace PCHET6 with   M_PCHET6

         replace PCHES1 with   M_PCHES1
         replace PCHES2 with   M_PCHES2
         replace PCHES3 with   M_PCHES3

         replace PCHPL1 with   M_PCHPL1
         replace PCHPL2 with   M_PCHPL2
         unlock
         commit 
         exit 
       else
         msg("* * * (APCH00) REGISTRO SENDO USADO * * *")
       endif
       if lastkey()=17
         exit
       endif
     enddo

return ""
