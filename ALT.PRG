*              if !strzero(APCA00->PCAFOR,5) $ "#040702#00410#"  // ABBOTT
*                skip
*                loop
*              endif
*            endif

#include "common.ch"
#include "inkey.ch"
#INCLUDE "GETEXIT.CH"
#include 'wvtwin.ch'

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
static aAllButtons := {}   // for all the get radio buttons and check boxes


static wvtScreen := {}
static pic_:= { , , , , , , , , , , , , , , , , , , , }
static keys_:= { , , , , , , , , , , , , , , , , , , , }

*****************
function DBFTOSQL(fARQUIVO)
*****************

aFields := &fARQUIVO -> (dbStruct ())
nMax := len (aFields)

altd()

FOR i := 1 TO nMax
   aadd(sqlCAMPO,{aFields [i][1],,.t.})
   DO CASE
   CASE (aFields [i][2] == "C")
     sqlCAMPO[i][2] = fieldget(i)
   CASE (aFields [i][2] == "D")
     sqlCAMPO[i][2] = formatdta(fieldget(i))
   CASE (aFields [i][2] == "I")  // INTEIRO
     sqlCAMPO[i][2] = str(fieldget(i),9)
   CASE (aFields [i][2] == "N")
     if aFields [i][4] = 0 // TEM DECIMAL
       sqlCAMPO[i][2] = str(fieldget(i),aFields [i][3])
     else
       sqlCAMPO[i][2] = str1(fieldget(i),aFields [i][4])
     endif
   ENDCASE
next

return ""
*****************
function OUTREQ_C
*****************

  abre_ped0("14") && ped mestre 
  abre_ped1("15") && ped itens  

  declare MT_REQ[12],;
          MT_SER[12]

  for R = 1 to 12
    MT_REQ[R] = 0
    MT_SER[R] = AEMP00->EMPRES
  next 

  if file("AREQ02.CDX")
    erase("AREQ02.CDX")
  endif

  select 16         && pre temporario

  use AREQ02 alias AREQ02 exclusive

  if neterr()
    msg("* * ARQUIVO NAO DISPONIVEL * * *")
    clear
    clear all
    quit
  endif

  M_PEDGER := {}

  @ 24, 00 clear

  do while .t.

    rodape("PROCESSA","AGRUPAMENTO",M_FAN,"EAGRO23","Mem: " + str(memory(0), 5),M_EMP) 

       M_PEDCLI = 0
       M_PEDCPG = 128
       M_PEDDTE = date()

       sombra(09, 34, 11, 54,_SOMBRA_)

       set color to GR+/W+
         @ 09, 34 say           "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
         @ 10, 34 say           "³  Data:   /  /     ³" 
         @ 11, 34 say           "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
       set color to 

*        @ 10, 28 get M_PEDCLI   picture "#######"
         @ 10, 43 get M_PEDDTE 
*        @ 10, 58 get M_PEDCPG   picture "###"  
         read
  
        if lastkey() = 27
          exit
        endif

        select AREQ02

        if !flock()
          msg("* * * (AREQ02) ARQUIVO NAO DISPONIVEL * * *")
          return ""
        endif

        zap

        index on str(REQEMP, 2, 0) + str(REQCLI, 7, 0) + str(REQMAT, 6, 0) + str(REQNUM, 6, 0) + REQSER tag 1 to AREQ02
        set index to AREQ02     
        msw("* * * FASE 1 - AGRUPANDO ... AGUARDE !!! * * *")

        select AREQ00
        set order to 2          
        dbseek(str(51, 2, 0) + dtos(M_PEDDTE),.t.)

        do while !eof()

          if !str(REQEMP, 2, 0) + dtos(REQDTE) == str(51, 2, 0) + dtos(M_PEDDTE)
            exit
          endif
                
          if !REQNATN $ "5.104#5.102"
            skip
            loop
          endif

          if REQIPL == "A" // ja foi agrupado
            skip
            loop
          endif

          select AREQ01

          dbseek(str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) + AREQ00->REQSER,.t.)

          do while !eof()

            if !str(REQEMP, 2, 0) + str(REQNUM, 6, 0) + REQSER == str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) + AREQ00->REQSER
              exit
            endif

            if REQIPL == "A"
              skip
              loop
            endif

            do while .t.
              if rlock()
                replace REQIPL with "A"
                unlock
                exit
              endif
            enddo

            APCA00->(dbseek(str(AREQ01->REQMAT,6,0)))

            if APCA00->PCAGRP = 120 // aluguel
              skip
              loop
            endif

            if APCA00->PCAFOR = 40740 // meias
              skip
              loop
            endif

            ASLD00->(dbseek(str(1,2,0) + str(AREQ01->REQMAT,6,0)))

            select AREQ02
            append blank         

            replace REQNUM with AREQ01->REQNUM
            replace REQSER with AREQ01->REQSER
            replace REQREC with AREQ01->(recno())
            replace REQEMP with AREQ01->REQEMP
            replace REQCLI with AREQ00->REQCLI
            replace REQMAT with AREQ01->REQMAT
            replace REQNUM with AREQ00->REQNUM
            replace REQSER with AREQ00->REQSER
            replace REQQDE with AREQ01->REQQDE
            replace REQVLI with iif(ASLD00->SLDCPA =0,AREQ01->REQLIQ,((ASLD00->SLDCPA+(ASLD00->SLDCPA*.2)) *AREQ01->REQQDE))
            replace REQDTE with AREQ00->REQDTE
            replace REQNATN with AREQ00->REQNATN

            select AREQ01

            skip
 
          enddo

          select AREQ00 

          skip
 
        enddo

    AREQ00->(dbsetorder(1))

    *
    ** geracao do pedido      
    *

    msw("* * * FASE 2 - GERANDO PEDIDO ... AGUARDE !!! * * *")

    select AREQ02
    go top

    do while !eof()

      M_PEDNUM = AEMP00->EMPPED + 1
      M_PEDSER = AEMP00->EMPPSE

      select APED00

      do while .t.
        if dbseek(str(51, 2, 0) + str(M_PEDNUM, 6, 0) + M_PEDSER)
          M_PEDNUM++
          loop
        else
          select AEMP00                    && seleciona empresa e grava ultima nota fiscal
            do while .t.
              if rlock() 
                replace EMPPED with M_PEDNUM
                commit
                unlock
                exit
              else
                msg("* * * (AEMP00) REGISTRO SENDO USADO * * *")
                if lastkey()=17 
                  select AREQ00
                endif
              endif
            enddo 
            exit
          endif
        enddo

        R        = 1
        M_PEDVLN = 0

        select AREQ02
        go top
 
        do while !eof()

          select APED01                      && seleciona PED itens 
          _append("APED01")
          M_LIQUNI = round(AREQ02->REQVLI/AREQ02->REQQDE,2)
          do while .t.
            if rlock()
              replace PEDEMP     with 51
              replace PEDNUM     with M_PEDNUM
              replace PEDSER     with M_PEDSER
              replace PEDSEQ     with 0
              replace PEDMAT     with AREQ02->REQMAT
              replace PEDQDE     with AREQ02->REQQDE
              replace PEDQDEREAL with AREQ02->REQQDE
              replace PEDPRB     with M_LIQUNI
              replace PEDVLI     with M_LIQUNI*AREQ02->REQQDE
              replace PEDLIQ     with M_LIQUNI*AREQ02->REQQDE
              replace PEDDTE     with M_PEDDTE
              replace REQNUM     with AREQ02->REQNUM
              replace REQSER     with AREQ02->REQSER
              replace REQREC     with AREQ02->REQREC
              replace REQDTE     with AREQ02->REQDTE
              replace REQNATN     with AREQ02->REQNATN
              unlock
              exit
            else
              msg("* * * (APED01) REGISTRO SENDO USADO * * *") 
            endif
            if lastkey()=17
              exit
            endif
            loop            
          enddo

          M_PEDVLN = M_PEDVLN + PEDVLI

          R = R + 1
           
          select AREQ02
          skip
        enddo

        ACLI00->(dbseek(str(M_PEDCLI, 7, 0)))

        select APED00                    && seleciona PED mestre para gravacao 

        _append("APED00")
 
        do while .t. 
          if rlock()
            replace PEDEMP  with 51
            replace PEDNUM  with M_PEDNUM
            replace PEDSER  with M_PEDSER
            replace PEDDTE  with M_PEDDTE
            replace PEDCLI  with 1
            replace PEDNATN  with "5.000"
            replace PEDTRA  with 1
            replace PEDVLP  with M_PEDVLN
            replace PEDVEN  with 1
            replace PEDCPG  with 1
            replace PEDVLN  with M_PEDVLN
            replace PEDIPL  with " "
            unlock
            exit 
          else
            msg("* * * (APED00) REGISTRO SENDO USADO * * *")
          endif
          if lastkey()=17
            exit
          endif
        enddo

        aadd(M_PEDGER, M_PEDNUM)

        select AREQ02

    enddo

    *
    ** emissao do agrupamento
    *

    select APED00
    set relation to str(PEDCLI, 7, 0) into ACLI00 

    @ 24, 00 clear

    M_IMPRE = impresn()

    if M_IMPRE = "N"
      return ""
    endif

    if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
      ?? chr(15)                        && comprime
    endif

    store 0 to PG,LN   ,;
               M_TOTPED

    for R = 1 to len(M_PEDGER)

      select APED00
         
      dbseek(str(51, 2, 0) + str(M_PEDGER[R], 6, 0) + M_PEDSER)

      cabreq01()

      ? " "
        ?? str(PEDNUM, 6, 0)
        ?? " "
        ?? PEDSER
        ?? " "
        ?? PEDDTE
        ?? " "  
        ?? str(PEDCLI, 7, 0) 
        ?? " "
        ?? ACLI00->CLINOM
        ?? " "
        ?? ACLI00->CLIMUN3
        ?? " "
        ?? ACLI00->CLIUF3
        ?? " "
        ?? ACLI00->CLITEL3

        LN = LN + 1

        if LN > 60
          cabreq01()
        endif

        select APED01

        dbseek(str(51, 2, 0) + str(M_PEDGER[R], 6, 0) + M_PEDSER,.t.) 

        do while !eof()

          if !str(PEDEMP, 2, 0) + str(PEDNUM, 6, 0) + PEDSER == str(APED00->PEDEMP, 2, 0) + str(APED00->PEDNUM, 6, 0) + APED00->PEDSER  
            exit
          endif

          APCA00->(dbseek(str(APED01->PEDMAT, 6, 0)))

          ? space(32)
            ?? str(PEDMAT, 7, 0)
            ?? " "
            ?? pad(APCA00->PCAREF, 10)
            ?? " "
            ?? pad(APCA00->PCAUNI, 2)
            ?? " "
            ?? pad(APCA00->PCADES, 40)
            ?? " "
            ?? transform(PEDQDE,"@E ###,###.##")
            ?? " "
            ?? transform(PEDVLI/PEDQDE,"@E #,###,###.##")
            ?? " "
            ?? transform(PEDVLI,"@E #,###,###.##")
  
            store LN + 1 to LN

            if LN > 60
              cabreq01()
            endif

            M_TOTPED = M_TOTPED + PEDLIQ

            skip

            M_ESC = inkey()

            if M_ESC = 27
              if susimp()
                ? replicate("-", 132)
                ? "* * * IMPRESSAO SUSPENSA * * *"
                go bottom
                skip
              else
                M_ESC = inkey()
              endif
            endif

        enddo

        if M_TOTPED > 0
          ? space(90)
            ?? "TOTAL DO PEDIDO .....      " 
            ?? transform(M_TOTPED,"@E ###,###,###.##")
          ? replicate("-",132)
          M_TOTPED = 0
          LN = LN + 2
          if LN > 60
            cabreq01()
          endif
        endif

    next 

    eject

desliga()
  enddo 

return ""

*************
function MAPARES(F_OQUE)                      && relacao de vendas por produtos
*************

F_OQUE = "I"

private M_TOTAL ,;
        M_DATA1 ,;
        M_DATA2 ,;
        M_ESC   ,;
        PG, LN  ,;
        M_TOTGER,;
        M_TOTVIS,;
        M_TOTPRZ,;
        M_SOMPER,;
        M_TELA  ,;
        M_TIPO

select 14
use

if file("AREQ02.CDX")                   
  erase("AREQ02.CDX")                   
endif

select 14         && req temporario

use AREQ02 alias AREQ02 exclusive

if neterr()
  msg("* * ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

@ 24, 00 clear

    rodape("REQUISICAO","PRODUTO",M_FAN,"EAGRO23","Mem: " + str(memory(0), 5),M_EMP) 

    store date() to M_DATA1 ,;
                    M_DATA2

    store "S"    to M_TIPO
    M_TIPCL = "        " 

    M_NFSIND = 0
    M_REQFOR = 0
    M_INDICADO = 0
    M_PCAFOR = 0

    _FUNIND_ = "NFS"
    set key 28 to FUNIND()

     sombra(11, 41, 16, 67,_SOMBRA_)
     set color to GR+/W+
       @ 11, 41 say                    "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 12, 41 say                    "³<F1> Indicado:                 ³" 
       @ 13, 41 say                    "³     Fornecedor:               ³" 
       @ 14, 41 say                    "³Periodo Inicial:               ³" 
       @ 15, 41 say                    "³          Final:               ³" 
       @ 16, 41 say                    "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
     set color to 
*     @ 12, 59 get     M_NFSIND picture "999" valid VERIND1()
     @ 13, 59 get     M_PCAFOR valid M_PCAFOR > 0
     @ 14, 59 get     M_DATA1
     @ 15, 59 get     M_DATA2
     read

     if lastkey() = 27
        return ""
     endif

     M_CLITIP = ""
     aTIPCLI = { }

     vertip(.t.)

     for A = 1 to len(aTIPCLI)
       if left(aTIPCLI[A],1) == "§"
         M_CLITIP += substr(aTIPCLI[A],3,1)
       endif
     next

     store 0 to M_TOTGER

     select AREQ02

     if !flock()
       msg("* * * (AREQ02) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     index on CLASSIFIC + str(REQMAT, 6, 0) + str(REQVEN,3) + PACIENTE tag 1 to AREQ02
     index on str(REQVEN,3) + CLASSIFIC + str(REQMAT, 6, 0) + PACIENTE  tag 2 to AREQ02

     set index to AREQ02

     M_PROD = { }
     M_QDEP = { }
  
        abre_nfs0( "2") && nfs mestre 4
        abre_nfs1( "3") && nfs itens  2


// EMPRESA 01

        select ANFS00

        set order to 2 
         
        dbseek(str(1, 2, 0) + dtos(M_DATA1),.t.)

        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(1, 2, 0) + dtos(M_DATA2)
            exit
          endif 

          if NFSCPG > 2 
            if NFSCPG < 10
              skip
              loop
            endif
          endif       

          if NFSCAN == "C"
            skip
            loop
          endif

          if NFSNATN = "5.929"
            skip
            loop
          endif

          valorescli(NFSCLI)

          if !M_CLITIP == " "
            if !ACLI00->CLITIP $ M_CLITIP
              select ANFS00
              skip
              loop
            endif
          endif

          if M_NFSIND > 0
            if !str(NFSIND,3) == str(M_NFSIND,3)
              select ANFS00
              skip
              loop
            endif
          endif

          msw("Lendo nota: " + str(NFSNUM, 6))  

          select ANFS01

          dbseek(str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER,.t.)

          do while !eof()

            if str(ANFS01->NFSEMP, 2, 0) + str(ANFS01->NFSNUM, 6, 0) + ANFS01->NFSSER > str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER
              exit
            endif

            APCA00->(dbseek(str(ANFS01->NFSMAT, 6, 0)))
            if !str(APCA00->PCAFOR,5) == str(M_PCAFOR,5)
              skip
              loop
            endif

            msw("Lendo Item nota: " + str(NFSNUM, 6) + " " + str(NFSSEQ, 2))

            M_QDE = NFSQDE
            M_VAL = (ANFS01->NFSLIQ - ANFS01->NFSDSP + ANFS01->NFSVIP)/NFSQDE

            M_VAL = M_VAL*M_QDE

            select AREQ02
            if !dbseek(APCA00->REFERE01 + str(ANFS01->NFSMAT, 6, 0) + str(ANFS00->NFSIND,3) + ACLI00->CLINOM)
              append blank         
              replace CLASSIFIC with APCA00->REFERE01
              replace REQMAT with ANFS01->NFSMAT
              replace PACIENTE with ACLI00->CLINOM // ANFS01->PACIENTE
              replace INDICADO with ANFS01->INDICADO
              replace REQDES with APCA00->PCADES
              replace REQTIP with ANFS01->SN0800
              replace REQNUM with ANFS01->NFSNUM
              replace REQSER with ANFS01->NFSSER
              replace REQVEN with ANFS00->NFSIND
     
            endif

            replace REQQDE with REQQDE + M_QDE
            replace REQVLN with REQVLN + M_VAL

            select ANFS01

            if inkey() = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                return ""
              endif
            endif

            skip
 
          enddo
 
          select ANFS00
 
          skip

        enddo


// EMPRESA 10

        select ANFS00

        set order to 2 
         
        dbseek(str(10, 2, 0) + dtos(M_DATA1),.t.)

        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(10, 2, 0) + dtos(M_DATA2)
            exit
          endif 

          if NFSCPG > 2 
            if NFSCPG < 10
              skip
              loop
            endif
          endif       

          if NFSCAN == "C"
            skip
            loop
          endif

          if NFSNATN = "5.929"
            skip
            loop
          endif

          valorescli(NFSCLI)

          if !M_CLITIP == " "
            if !ACLI00->CLITIP $ M_CLITIP
              select ANFS00
              skip
              loop
            endif
          endif

          if M_NFSIND > 0
            if !str(NFSIND,3) == str(M_NFSIND,3)
              select ANFS00
              skip
              loop
            endif
          endif

          msw("Lendo nota: " + str(NFSNUM, 6))  

          select ANFS01

          dbseek(str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER,.t.)

          do while !eof()

            if str(ANFS01->NFSEMP, 2, 0) + str(ANFS01->NFSNUM, 6, 0) + ANFS01->NFSSER > str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER
              exit
            endif

            APCA00->(dbseek(str(ANFS01->NFSMAT, 6, 0)))
            if !str(APCA00->PCAFOR,5) == str(M_PCAFOR,5)
              skip
              loop
            endif

            msw("Lendo Item nota: " + str(NFSNUM, 6) + " " + str(NFSSEQ, 2))

            M_QDE = NFSQDE
            M_VAL = (ANFS01->NFSLIQ - ANFS01->NFSDSP + ANFS01->NFSVIP)/NFSQDE

            M_VAL = M_VAL*M_QDE

            select AREQ02
            if !dbseek(APCA00->REFERE01 + str(ANFS01->NFSMAT, 6, 0) + str(ANFS00->NFSIND,3) + ACLI00->CLINOM)
              append blank         
              replace CLASSIFIC with APCA00->REFERE01
              replace REQMAT with ANFS01->NFSMAT
              replace PACIENTE with ACLI00->CLINOM // ANFS01->PACIENTE
              replace INDICADO with ANFS01->INDICADO
              replace REQDES with APCA00->PCADES
              replace REQTIP with ANFS01->SN0800
              replace REQNUM with ANFS01->NFSNUM
              replace REQSER with ANFS01->NFSSER
              replace REQVEN with ANFS00->NFSIND
     
            endif

            replace REQQDE with REQQDE + M_QDE
            replace REQVLN with REQVLN + M_VAL

            select ANFS01

            if inkey() = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                return ""
              endif
            endif

            skip
 
          enddo
 
          select ANFS00
 
          skip

        enddo





*** Agora os cupons fiscais



        abre_cup0( "2") && cup mestre 4
        abre_cup1( "3") && cup itens  2

        select ACUP00

        set order to 2 
         
        dbseek(str(1, 2, 0) + dtos(M_DATA1),.t.)

        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(CUPEMP, 2, 0) + dtos(CUPDTE) > str(1, 2, 0) + dtos(M_DATA2)
            exit
          endif 

          if CUPCAN $ "ZXC"
            skip
            loop
          endif

          valorescli(CUPCLI)

          if !M_CLITIP == " "
            if !ACLI00->CLITIP $ M_CLITIP
              select ACUP00
              skip
              loop
            endif
          endif

          if M_NFSIND > 0
            if !str(CUPIND,3) == str(M_NFSIND,3)
              select ACUP00
              skip
              loop
            endif
          endif

          msw("Lendo Cupom: " + str(CUPNUM, 6) + CUPSER)  

          select ACUP01

          dbseek(str(ACUP00->CUPEMP, 2) + str(ACUP00->CUPNUM, 6) + ACUP00->CUPSER,.t.)

          do while !eof()

            if str(ACUP01->CUPEMP, 2, 0) + str(ACUP01->CUPNUM, 6, 0) + ACUP01->CUPSER > str(ACUP00->CUPEMP, 2, 0) + str(ACUP00->CUPNUM, 6, 0) + ACUP00->CUPSER
              exit
            endif

            APCA00->(dbseek(str(ACUP01->CUPMAT, 6, 0)))

            if !str(APCA00->PCAFOR,5) == str(M_PCAFOR,5)
              skip
              loop
            endif

            msw("Lendo Item Cupom: " + str(CUPNUM, 6) + " " + str(CUPSEQ, 2))

            M_QDE = CUPQDE
            M_VAL = CUPLIQ/CUPQDE
            M_VAL = M_VAL*M_QDE

            select AREQ02
            if !dbseek(APCA00->REFERE01 + str(ACUP01->CUPMAT, 6) + str(ACUP00->CUPIND,3) + ACLI00->CLINOM)
              append blank         
              replace CLASSIFIC with APCA00->REFERE01
              replace REQMAT with ACUP01->CUPMAT
              replace PACIENTE with ACLI00->CLINOM // ACUP01->PACIENTE
              replace INDICADO with ACLI00->NOMEPAI
              replace REQDES with APCA00->PCADES
              replace REQTIP with ACUP01->SN0800
              replace REQNUM with ACUP01->CUPNUM
              replace REQSER with ACUP01->CUPSER
              replace REQVEN with ACUP00->CUPIND
            endif

            replace REQQDE with REQQDE + M_QDE
            replace REQVLN with REQVLN + M_VAL

            select ACUP01

            if inkey() = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                return ""
              endif
            endif

            skip
 
          enddo
 
          select ACUP00
 
          skip

        enddo

        abre_req0( "2") && nfs mestre 4
        abre_req1( "3") && nfs itens  2
  
        @ 24, 00 clear
  
        M_IMPRE = imprelaser()

        if M_IMPRE = "N"
          return ""
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        store  0 to PG, LN   ,;
                    M_TOTVIS ,;
                    M_TOTPRZ ,;
                    M_SOMPER ,; 
                    M_SOMQDE,; 
                    M_VENDIDO,;
                    M_COMPRA 
          
        select AREQ02
        set relation to str(REQMAT, 6, 0) into APCA00,; 
                        str(REQFOR, 7, 0) into AFOR00,;
                        str(REQVEN, 3, 0) into AIND00

        if F_OQUE == "N"
          set order to 1
        else
          set order to 2
        endif

        go top

        M_PROANT = 0
        M_CLASANT = space(20)
        M_REQVLI = 0
        M_REQVLIS = 0
        lNovalinha = .t.                
        M_REQTIP = " "
        M_REQIND = 0

        M_PROD = { }
        M_QDEP = { }

        AEMP00->(dbseek(str(1, 2, 0)))
        ?? chr(18)
        ?? chr(27) + "E"
        ? AEMP00->EMPNOM
        ? alltrim(AEMP00->EMPEND) + " - " + alltrim(AEMP00->EMPBAI)
        ? strzero(AEMP00->EMPCEP,5) + "-" + strzero(AEMP00->EMPCCE,3) + "  " + AEMP00->EMPMUN
        ? "Fone: " + AEMP00->EMPTEL
        ? 
        ? "PERIODO DE " + dtoc(M_DATA1) + " a " + dtoc(M_DATA2)
        ?? chr(15)
        ?? chr(27) + "F"
        AEMP00->(dbseek(str(51, 2, 0)))

        store 6 to LN

        do while !eof()

          PG ++

          if PG > 1
            eject
            LN = 0
          endif

          ? "+---------------------------------------+----------------------------------+------------------------------+-------+-----------+"
          ? "| PRODUTO                               | CLIENTE                          |       INDICACAO              | QTDE  | R$ TOTAL  |"
          ? "+---------------------------------------+----------------------------------+------------------------------+-------+-----------+"                              
          LN += 3
  
            do while !eof() 
               
              if LN > 60
                exit
              endif 

              if F_OQUE == "N"
                if M_CLASANT # CLASSIFIC

                  if M_REQVLI+M_REQVLIS > 0
                    ? "  Total Venda: "
                    ?? transform(M_REQVLI,"@E@z ###,###,###.##")             
                    M_REQVLI = 0
                    ? replicate("-",131)
                    LN += 2
                  endif
                  ? CLASSIFIC
                  ? 
                  LN += 2
                  M_CLASANT = CLASSIFIC
                endif
              else
                if str(M_REQIND,3) # str(REQVEN,3)  //  INDICADO

                  if M_REQVLI+M_REQVLIS > 0
                    ? "  Total Venda: "
                    ?? transform(M_REQVLI,"@E@z ###,###,###.##")             
                    M_REQVLI = 0
                    ? replicate("-",131)
                    LN += 2
                  endif
                  ? AIND00->VENNOM
                  ? 
                  LN += 2
                  M_REQIND = REQVEN
                endif
              endif

              if M_PROANT # REQMAT
                ? pad(REQDES,40)
                LN ++
                M_PROANT = REQDES
                lNovalinha = .f.
              endif
              
              M_SLD = 0
              M_CPA = 0
              M_SLD51 = 0
              M_CPA51 = 0
              M_MEDMES = 0

              M_PROANT = REQMAT
              M_COMPRA += M_CPA

             select AREQ02

             if lNovalinha
               ? space(40)
               LN ++
             endif

             lNovalinha = .t.

             ?? " " 
             ?? pad(PACIENTE,34)
             ?? " " 
             ?? pad(AIND00->VENNOM,30)
             ?? " " 
             ?? str(REQQDE,7)
             ?? " "
             ?? transform(REQVLN,"@E@Z ####,###.##")

             M_VENDIDO = 0

             M_REQVLI += REQVLN 
             M_SOMPER = M_SOMPER + REQVLN
             M_SOMQDE = M_SOMQDE + REQQDE

             skip
         
            if inkey() = 27
                if susimp()
                  ? replicate("-", 132)
                  ? "* * * IMPRESSAO SUSPENSA * * *"
                  go bottom
                  skip
                endif
            endif

          enddo

      enddo

      if M_REQVLI+M_REQVLIS > 0
        ? "  Total Venda: "
         ?? transform(M_REQVLI-M_REQVLIS,"@E@z ###,###,###.##")             
         ?? "      Total Transferencia: "
         ?? transform(M_REQVLIS,"@E@z ###,###,###.##")             
         ?? "      Total Fornecedor. . "
         ?? transform(M_REQVLI,"@E@z ###,###,###.##")             
         M_REQVLI = 0
         M_REQVLIS = 0
       endif

      ? replicate("-", 132)
        ? "                                                                            TOTAL GERAL . . . . "
        ?? transform(M_SOMPER,"@E@z ###,###,###.##")             
      ? replicate("-", 132)
      ?
      
    ?

    if M_IMPRE == "L"
    else
      eject
    endif

    unlock all

select 14
use

desliga(80)

return ""

*******************
function VALORESCLI(CLIENTE)
*******************

lLoqarq = alias()
lOrdem = indexord()

if !BUSCAREGISTRO("ACLI00",1,{str(CLIENTE,7,0)},"SELECT")
  if !BUSCAREGISTRO("ACLMOR",1,{str(CLIENTE,7,0)},"SELECT")
    return .f.
  endif
endif

        zCLICOD   = CLICOD
        zCLICDM2  = CLICDM2
        zCLICGC1  = CLICGC1
        zCLITIP   = CLITIP
        zCLINOM   = CLINOM
        zCLIDTE   = CLIDTE
        zCLIEND1  = CLIEND1
        zCLIUF1   = CLIUF1
        zCLIBAI1  = CLIBAI1
        zCLINRO2  = CLINRO2
        zCLICEP1  = CLICEP1
        zCLICCL1  = CLICCL1
        zCLICCL2  = CLICCL2
        zCLICCL3  = CLICCL3
        zCLIMUN1  = CLIMUN1
        zCLITEL1  = CLITEL1
        zCLIFAX1  = CLIFAX1
        zCLITEX1  = CLITEX1
        zCLIIES1  = CLIIES1
        zCLIREG   = CLIREG
        zCLIDCC   = CLIDCC
        zCLIVEN   = CLIVEN
        zCLICLF   = CLICLF
        zCLIEND2  = CLIEND2
        zCLITRA   = CLITRA
        zCLIUF2   = CLIUF2
        zCLIBAI2  = CLIBAI2
        zCLICEP2  = CLICEP2
        zCLIMUN2  = CLIMUN2
        zCLIIES2  = CLIIES1
        zCLICGC2  = CLICGC1
        zCLIAC    = CLIAC
        zCLIEND3  = CLIEND3
        zCLIUF3   = CLIUF3
        zCLIBAI3  = CLIBAI3
        zCLICEP3  = CLICEP3
        zCLIMUN3  = CLIMUN3
        zCLITEL3  = CLITEL3
        zCLIFAX3  = CLIFAX3
        zCLITEX3  = CLITEX3
        zCLICON   = CLICON
        zCLIBCO   = CLIBCO
        zCLIULC   = CLIULC
        zCLISITE  = CLISITE
        zCLIEMAIL = CLIEMAIL
        zINDICADO = pad(NOMEPAI,20)
        zNOMEPAI = pad(NOMEPAI,20)
        zREVENDA = REVENDA

return .t.


function CRIA_ADDSQL

        abre_pch("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_mun("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_log("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_mcp("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_mcr("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_pcafor("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_par("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_sld("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_sld10("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO

        abre_msg2("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO

        abre_ncm("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_cup0("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_cup1("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_etq("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_nfscan("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_for("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_formor("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_pca("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_pcamor("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_cve("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_grp("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_kar("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_fis("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_cli("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_tip("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_climor("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_dol("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_ano("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_cpg("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_ven("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_ind("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_nfe0("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_nfe1("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_nfs0("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_nfsel("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_nfs1("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_tra("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_por("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_che("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_cta("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_lab("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_lap("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_hib("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_dcp("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_lcp("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_dcr("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_bol("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_lcr("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_ret("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_bcr("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_bcp("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_ped0("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_ped1("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_req0("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_req1("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_req0tm("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_req1tm("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_pen("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_prd("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_plx("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_lax("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_orc0("0")
CRIADBFTOSQL(alias(),.T.)  // IMPORTADO
        abre_orc1("0")



return ""


*****************
function ABRE_NCM
*****************

fechaexist("ANCM00")

select 0
use &_PATH_\USR\ESTOQUE\ANCM00 alias ANCM00

if neterr()
  msg("* * * (ANCM00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !file("&_PATH_\USR\ESTOQUE\ANCM00.CDX")
  if !flock()
    return .f.
  endif
  msw("* * * CRIANDO INDICES (ANCM00) AGUARDE !!! * * *")
  index on  NCMCOD   tag 1 to &_PATH_\USR\ESTOQUE\ANCM00
  index on  NCMNOM01 tag 2 to &_PATH_\USR\ESTOQUE\ANCM00
  unlock all
  select ANCM00
  use
  select ANCM00
endif

set index to &_PATH_\USR\ESTOQUE\ANCM00

return ""

********************************
function NInkey(Arg1)

   local Local1, Local2, Local3

   n_Tempo = time()

   do while (.T.)
      Local1:= .F.

*      oBar:update(7,time())

      if (Arg1 = Nil)
         Local2:= InKey(0.10,159)
      else
         Local2:= InKey(Arg1,159)
      endif

      do case
         case Local2 == -40 // F11
*           INCMOVC()
         case Local2 == -8 // F9
*           INC_MOVC()
      endcase


      if Local2 >= K_MINMOUSE .And. ;
         Local2 <= K_MAXMOUSE

         if Local2 == K_LBUTTONDOWN .or. ;
            Local2 == K_LBUTTONUP .or. ;
            Local2 == K_LDBLCLK

            if Local2 == K_LDBLCLK
               arrMouseInfLeft[1] := 2
            else
               arrMouseInfLeft[1] := 1
            end
            arrMouseInfLeft[2] := mRow()
            arrMouseInfLeft[3] := mCol()
         end

         if Local2 == K_RBUTTONDOWN .or. ;
            Local2 == K_RBUTTONUP .or. ;
            Local2 == K_RDBLCLK

            if Local2 == K_RDBLCLK
               arrMouseInfRight[1] := 2
            else
               arrMouseInfRight[1] := 1
            end
            arrMouseInfRight[2] := mRow()
            arrMouseInfRight[3] := mCol()
         end
         Local2 := 0
         Setswmouse(.T.)
      end

      if (Local2 != 0 .And. (Local3:= SetKey(Local2)) != Nil)
         eval(Local3, procname(2), procline(2), "")
         Local1:= .T.
         resettimer()
      endif
      if (!Local1)
         exit
      endif
   enddo
   RETURN Local2

   function WAITSTATE

   local Local1, Local2, Local3, Local4, Local5, Local6, Local7
   Local1:= {0, Nil, Nil}
   Local3:= array(4)
   Local4:= vlscrsaver()
   resettimer()


   do while (Local1[1] == 0)

*   msw("timer " + time())

      if (Seconds() - gettimer()) > 0
*         oBar:update(7,time())
         resettimer()
      endif
      if ((Local2:= nInkey()) != 0)//.1
         Local1[2]:= Local2
         Local1[1]:= 1
      else
         vlmouseinf(Local3)
         if (Local3[1] .Or. Local3[2])
            if (STATIC19 == 0 .Or. STATIC19 == 3)
               Local1[1]:= STATIC19:= 2
               Local1[2]:= Local3[3]
               Local1[3]:= Local3[4]
               STATIC20:= Local3[3]
               STATIC21:= Local3[4]
            elseif ((STATIC19 == 2 .Or. STATIC19 == 4) .And. ;
                  (Local3[3] != STATIC20 .Or. Local3[4] != STATIC21))
               Local1[1]:= STATIC19:= 4
               Local1[2]:= Local3[3]
               Local1[3]:= Local3[4]
               STATIC20:= Local3[3]
               STATIC21:= Local3[4]
            endif
         elseif (STATIC19 == 2 .Or. STATIC19 == 4)
            Local1[1]:= STATIC19:= 3
            Local1[2]:= Local3[3]
            Local1[3]:= Local3[4]
         else
            Local1[1]:= STATIC19:= 0
         endif
      endif



      if (Local1[1] == 3)
         Local7:= aclone(getkeymouse())
         for Local6:= 1 to Len(Local7)
            if (Local1[2] >= Local7[Local6][2][1] .And. Local1[2] <= ;
                  Local7[Local6][2][2] .And. Local1[3] >= ;
                  Local7[Local6][2][3] .And. Local1[3] <= ;
                  Local7[Local6][2][4])
               Local1[1]:= STATIC19:= 0
               if ((Local5:= SetKey(Local7[Local6][1])) != Nil)
                  eval(Local5, procname(1), procline(1), "")
               endif
            endif
         next
      endif
   enddo


   RETURN Local1

   ********************************
function GETTimeR

   RETURN STATIC17


function VLMouseINF(a)
      a[1] = mLeftDown()   // .F.
      a[2] = mRightDown()  // .F.
      a[3] = mRow()        // 00
      a[4] = mCol()        // 00
   RETURN

   function Setswmouse(x)
   STATIC swMouse := .F.

   if pcount()<>00
      swMouse := x
   end

   RETURN swMouse

   ********************************
function RESETTimeR

   RETURN STATIC17:= Seconds()









*******************
*AQUI SEMPRE TESTE


/*
³  Radio Buttons and Check Boxes for Clipper 5.2d
³
³  For a demonstration, run the batch file MAKEDEMO.BAT to make an EXE or use
³  the command:
³
³            rmake radiobtn /dTEST
³
³  To this radio button and check box GET Reader in an application, recompile
³  RADIOBTN.PRG without the /dTEST preprocessor directive.
³
³  Check out RADIOBTN.CH for the syntax.  Note that you must put the options
³  in same order as defined in RADIOBTN.CH or else it won't work.
³
³  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³  ³ The functions contained herein are the original work of Dan Comeau ³
³  ³ and others and are placed in the public domain.                    ³
³  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
³
³  Modifications:
³
³  Version     Changes
³  ÄÄÄÄÄÄÄ     ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³    2.0b      ş Handle array elements for GET variables.
³ (Dec '94)
³    2.0a      ş Comments and TXT file changed. No code changes.
³ (Nov '94)
³    2.0       ş Added checkbox option. If array contains only 1 element
³ (Nov '94)      then a checkbox appears. Thanks to the person who sent me
³                the heart of this new code -- I've misplaced his/her name.
³                The new alternate syntax is VIA CHECKBOX to show that it
³                is a checkbox.  Note, however, that this is only cosmetic
³                since the radiobutton reader decides whether to display
³                radiobuttons or a checkbox depending on the length of the
³                array. Checkboxes return 1 when on and 0 when off.
³              ş Value no longer set to zero if the WHEN condition is false.
³                Thanks to another forgotten person who showed me the light
³                on this and gave me some code modifications. If this breaks
³                your code, have a look below and uncomment the two affected
³                sections.  Search for the work "uncomment."
³              ş The same person also included some code that moves the cursor
³                to the last button of a GET if you moved to it with the UP
³                key.
³              ş Added new option to set marker for Yes and No conditions.
³                For radiobuttons, the default Yes marker is a dot.  For
³                checkboxes, the default Yes marker is a check mark.  The
³                default No marker is a blank. You can change these defaults
³                by changing the DEFINE statements below.
³
³    1.2       ş Horizontal spacing option, HSPACING, added.  Thanks to
³ (Apr '93)      Rich Miller [70632,734] for this modification.
³              ş New syntax: VIA RADIOBUTTONS. The previous syntax of
³                WITH RADIOBUTTONS is still supported. You don't need to
³                change your code because of this change.
³              ş Made several minor internal changes to optimize display.
³
³    1.1       ş VALID clause now supported.
³
³    1.0b      ş New parameter for drawing shadow around box.  See
³                RADIOBTN.CH for syntax.  Thanks (again) to John Forsberg
³                [75170,641] for this modification.  Check out the
³                DrawBoxShadow() function he wrote to draw a shadow around a
³                box using pure Clipper code.
³
³    1.0a      ş Disabled GET variables now return 0; ie., when the WHEN
³                expression is false.  Thanks to John Forsberg [75170,641]
³                for this modification.  Note that if the user ends the READ
³                with Esc, PgUp, or PgDn, the disabled GET value may not
³                be 0.
³
³    1.0       ş Original release.
³
³
³  I'd like to hear about any enhancements you make to these functions.  In
³  fact, with your permission, I'd like to add your enhancements and make a
³  new version.  Send revised source code or questions to my CompuServe
³  account [70451,2312], Internet 70451.2312@compuserve.com, or my mailing
³  address, as of December, 1994:
³
³            Dan Comeau
³            702-1025 Grenon Ave.
³            Ottawa, Ontario
³            K2B 8S5, CANADA
³
³  By the way, Clipper 5.3 will have radiobuttons and checkboxes.
³  Therefore, I do not plan to enhance this code once 5.3 is available.
³
³  If you end up using all or parts of this code in a commercial or
³  shareware library, I'd appreciate it if you let me know.
³
*/
// Function/Procedure Prototype Table  -  Last Update: 12-10-94 @ 02:49:29pm
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Return Value         Function/Arguments
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// nil                  static function DrawBoxShadow( nTop, nLeft, nBottom, nRight )
// nil                  static function DrawRadioButtons( nRow, nCol, aChoices, nChoice, nCursor, ;
// valid                static function GetPostValidate( get )
// when                 static function GetPreValidate( get )
// nil                  function RBCB_Kill()
// Void                 function RBCB_New( oGet, bWhen, ;
// nil                  function RBCB_Reader( oGet, lNoBox, lHoriz, cTitle, cYesMarker, cNoMarker )
// Void                 function test()


#include "radiobtn.ch"

#include "box.ch"          // as shipped with Clipper 5.2d
#include "getexit.ch"      // ''   ''     ''     ''
#include "inkey.ch"        // ''   ''     ''     ''
#include "common.ch"       // ''   ''     ''     ''

#define HBRACKETSPACING  4    // space (ie.,"( ) ") between 1st bracket & text of horizontal choices
#ifndef K_SPACE               // this was finally defined in Clipper 5.2
  #define K_SPACE       32
#endif



/*
³ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³  Test function for the radio buttons.
³
³  To make the test version, use:  rmake radiobtn /dTEST
³ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/
#DEFINE TEST

#ifdef TEST

  #define SCREEN_COLOR    "GR+/B"    // regular screen color
  #define SHADOWBOX_COLOR "GR+/R"    // for box with a shadow around it
  #define GREYED_COLOR    "W/R"      // color of disabled GET

  // To demo use of arrays for GET variables:
  #define CITIES      1              // 1st element of aMyGets[]
  #define PLACES      2              // 2nd element of aMyGets[]

  function test()

    local aGet1     := { "1 Choice1", "2 Disable Buttons #3", "3 Choice1" }
    local cGet1     := "Get 1"
    local cGet2     := "Get 2"
    local GetList   := {}
    local nChoice1  := 2          // initial choices for radio buttons
    local nChoice2  := 1
    local nChoice3  := 1
    local nChoice3b := 1          // Checkbox choice
    local nChoice3c := 1          // Checkbox choice
    local nChoice3d := 1          // Checkbox choice
    local nChoice4  := 2
    local nChoice5  := 2
    // To demo use of arrays for GET variables:
    local aMyGets   := { 3, 2 }
    local aCities   := {"Sao Paulo", "Curitiba", "Rio de Janeiro"}
    local aPlaces   := {"Here", "There", "Anywhere"}

    set scoreboard off

    // demonstrate set key ability within a radio button GET
    setkey( K_F1, { |s,r,c| s:=savescreen(), ;
			    r:=row(),;
			    c:=col(),;
			    scroll(), ;
			    setpos(5,5), ;
			    dispout("You pressed F1.  Press any key to continue . . ."), ;
			    inkey(0), ;
			    restscreen(,,,,s),;
			    setpos(r,c) } )

    setcolor( SCREEN_COLOR )
    clear screen

    @ 2, 5 say "Use the Tab, Shift-Tab, arrow, space bar, and Enter keys to move around."
    @ 3, 5 say "Press F1 to show use of setkey within GETs."

    @ 5, 5 say "Normal Get #1:" ;
	   get cGet1

    @ 6, 5 say "Buttons #1" ;
	   get nChoice1 ;
	   color SCREEN_COLOR ;
	   via radiobuttons aGet1

    @ 6,40 get nChoice2 ;
	   color SCREEN_COLOR ;
	   via radiobuttons { "1 Choice2","2 Choice2","3 Choice2","4 Choice2" } ;
	   nobox

    @ 7,60 say "Buttons #3" ;
	   get nChoice3 ;
	   color SHADOWBOX_COLOR+","+GREYED_COLOR ;
	   when nChoice1 != 2 ;
	   via radiobuttons { "1 Choice3","2 Choice3","3 Choice3","4 Choice3","5 Choice3" } ;
	   shadow

    @11, 5 get nChoice3b ;                       // Uses MARKER
	   color SCREEN_COLOR ;
	   via checkbox { "Checkbox 1" } ;
	   nobox ;
	   yesmarker "X" ;
	   nomarker  "-"

    @12, 5 get nChoice3c ;
	   color SCREEN_COLOR ;
	   via radiobuttons { "Checkbox 2" } ;
	   nobox

    @13, 5 get nChoice3d ;
	   color SCREEN_COLOR ;
	   via radiobuttons { "Checkbox 3" } ;
	   nobox



    @12,30 say "Normal Get #2:" ;
	   get cGet2

    @14, 5 say "Buttons #4:"
    @14,col()+1 get nChoice4 ;
		color SCREEN_COLOR ;
		via radiobuttons { "1 Choice4","2 Choice4","3 Choice4" } ;
		nobox ;
		horizontal

    @19,2 say "This is a radiobutton with a shadowed box drawn around it."
    @16,5 say"Choice 5 With Horizontal Spacing = 5 and a Long Title" ;
	  get nChoice5 ;
	  color SHADOWBOX_COLOR ;
	  via radiobuttons { "1 Choice5","2 Choice5" } ;
	  double ;
	  horizontal ;
	  hspacing 5 ;
	  shadow

    // To demo use of arrays for GET variables (aMyGets):
    @20,5 say 'Cities' ;
	  get aMyGets[ CITIES ] ;
	  color SCREEN_COLOR ;
	  via radiobuttons aCities
    @20,30 say 'Places' ;
	   get aMyGets[ PLACES ] ;
	   color SCREEN_COLOR ;
	   via radiobuttons aPlaces

    read
    RBCB_Kill()  // reduce memory requirement by setting array to NIL

    // display values
    devpos( 24, 0 )
    ? "Normal Get Values..:", cGet1, cGet2
    ? "Radio Button Values:", nChoice1, nChoice2, nChoice3, nChoice4, nChoice5
    ? "Check Box Value....:", nChoice3b, nChoice3c
    ? "City, Place Values.:", aCities[ aMyGets[ CITIES ] ] + ", " + ;
			      aPlaces[ aMyGets[ PLACES ] ]
  return nil

#endif


/*
³ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³  Initialization for Radio Buttons and Check Boxes.  Display title and
³  choices.  Optionally draw box around choices.  Horizontal choices must
³  fit on one line.
³ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/
function RBCB_New( oGet, bWhen,                      ;
		   nRow, nCol, cTitle, nChoice,      ;
		   aChoices, lNoBox, lDblBox,        ;
		   lHoriz, lShadow, nHSpacing, cYesMarker, cNoMarker )

  local cColorSpec    // color string
  local n             // temp variable
  local nWidth        // width of button box

  dispbegin()         // buffer the display output

    if cTitle == NIL
      cTitle := ""      // init to enable testing in len()
    endif

    if valtype( nHSpacing ) != "N"  // set default horizontal spacing
       nHSpacing := 2
    endif

    if (nChoice < 1) .or. (nChoice > len( aChoices ))  // make sure nChoice is in valid range
      if len( aChoices ) > 1
	nChoice := 1            //--- Only if a radio button not a check box
      endif
    endif

    // Add choices array to the aAllButtons array.
    aadd( aAllButtons, { oGet:Name, aChoices, nHSpacing, oGet:subscript } )

    // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    // ³ Draw box around buttons ³
    // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    if ! lNoBox   // draw box around buttons
      if lHoriz   // draw horizontal box

	// find total width of aChoices choices
	nWidth := 0
	aeval( aChoices, { |c, n| nWidth += if( n == 1, 1, nHSpacing ) ;
					  + HBRACKETSPACING ;
					  + len( c )  } )
	nWidth := max( nWidth + 1, len( cTitle ) + 2 ) //  make sure title fits

	// draw single or double line box
	dispbox( nRow, nCol, nRow+2, nCol+nWidth+1, ;
		 if( lDblBox, B_DOUBLE, B_SINGLE )+space(1), oGet:ColorSpec )

	if lShadow // draw shadow around box
	  DrawBoxShadow( nRow, nCol, nRow+2, nCol+nWidth+1 )
	endif

      else        // draw vertical box

	// find max width of aChoices choices
	nWidth := len( aChoices[1] )
	aeval( aChoices, { |c| nWidth := max(nWidth, len(c)) } )
	nWidth := max( nWidth+5, len(cTitle)+1 )    // add 5 spaces for " ( ) "

	// draw single or double line box
	dispbox( nRow, nCol, nRow+len(aChoices)+1, nCol+nWidth+2, ;
		 if( lDblBox, B_DOUBLE, B_SINGLE )+space(1), oGet:ColorSpec )

	if lShadow // draw shadow around box
	  DrawBoxShadow( nRow, nCol, nRow+len(aChoices)+1, nCol+nWidth+2 )
	endif

      endif
    endif

    // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    // ³ Put title at top left corner ³
    // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    if !empty( cTitle )
      if lNoBox   // no box around buttons
	@ nRow, nCol say cTitle && color oGet:ColorSpec
      else        // box drawn around buttons
	@ nRow, nCol+1 say " "+cTitle+" " && color oGet:ColorSpec
      endif
    endif

    // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    // ³ Display radio button choices ³
    // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    // check when condition for this get; use this to set colors
    if ( bWhen == NIL ) .or. eval( bWhen, oGet )
      // normal color
      cColorSpec := setcolor() && oGet:ColorSpec
    else
      // failed pre-validation (ie., WHEN)
      // grey out the radio button box choices
      cColorSpec := if( (n:=at(",",oGet:ColorSpec)) > 0, ;       // find comma delimiter
		    substr(setcolor()/*oGet:ColorSpec*/,n+1), ; // remainder of color string
		    setcolor()/*oGet:ColorSpec*/)              // same color as regular

      // Uncomment the next lines to change data value if WHEN condition fails
      //-x- nChoice := 0   // don't show any choices for greyed out radio buttons
      //-x- // return zero for disabled button
      //-x- oGet:VarPut( nChoice )   // update get var

    endif

    // draw the buttons
    /*
    ³  Note: 1 is subtracted from nCol when horizontal and no box or
    ³        title. This was needed to line up the buttons with the oGet
    ³        supplied coordinates when DrawRadioButtons() is called from
    ³        RBCB_Reader().
    */
    DrawRadioButtons( nRow, ;
		      nCol - if( lHoriz .and. lNoBox .and. empty( cTitle ), ;
				 1, 0 ;
			       ), ;
		      aChoices, nChoice, nChoice, cColorSpec, ;
		      lNoBox, lHoriz, empty( cTitle ), nHSpacing, cYesMarker, cNoMarker ;
		    )
  dispend()

return nil


/*
* ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*  Draw Radio Buttons choices
* ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/

// code blocks to display the buttons
#xtranslate bHORIZONTALCONTROL ;
	 => { | c, n | dispout( replicate( " ", if( n == 1, if( lNoBox, 0, 1 ), nHSpacing ) ) + ;  // space before bracket
				cLeftBracket + ;                                                  // left bracket
				( if( n == nCursor, nCursorPos := col() + ;                        // set position of selected button
								  if( n == 1, ;
								      0, ;
								      nHSpacing-if( lNoBox, 0, 1 ) ), ), ;
				  if( n == nChoice, cYesMarker, cNoMarker ) ;             // bw the brackets
				) + ;
				cRightBracket + " " + c, ;                             // right bracket + text
				cColorSpec ;
			      ) ;
	    }

#xtranslate bVERTICALCONTROL ;
	 => { | c, n | setpos( row() + 1, if( lNoBox, nCol, nCol + 2 ) ), ;
		       dispout( cLeftBracket + ( if( n == nCursor, nCursorPos := row(), ), ;
					    if( n == nChoice, cYesMarker, cNoMarker );
					  ) + ;
				cRightBracket + " " + c, ;
				cColorSpec ;
			      ) ;
	    }


static function DrawRadioButtons( nRow, nCol, aChoices, nChoice, nCursor, ;
				  cColorSpec, lNoBox, lHoriz, lNoTitle, ;
				  nHSpacing, cYesMarker, cNoMarker)

  local cLeftBracket
  local cRightBracket
  local nCursorPos := 0   // cursor position (could be either row or col)

  if len( aChoices ) == 1                        // checkbox
    DEFAULT cLeftBracket  TO CB_LEFT
    DEFAULT cRightBracket TO CB_RIGHT
    DEFAULT cYesMarker    TO CB_YES
    DEFAULT cNoMarker     TO CB_NO
  else                                           // radiobutton
    DEFAULT cLeftBracket  TO RB_LEFT
    DEFAULT cRightBracket TO RB_RIGHT
    DEFAULT cYesMarker    TO RB_YES
    DEFAULT cNoMarker     TO RB_NO
  endif

  dispbegin()

    set cursor off

    if lHoriz   // horizontal radio buttons
      if lNoBox
	setpos( nRow + if(lNoTitle,0,1), nCol )
	aeval( aChoices, bHORIZONTALCONTROL )            // show buttons
	setpos( nRow + if(lNoTitle,0,1), nCursorPos+1 )  // display cursor at this coordinate

      else   // with a box around buttons
	setpos( nRow+1, nCol+1 )
	aeval( aChoices, bHORIZONTALCONTROL )          // show buttons
	setpos( nRow+1, nCursorPos+2 )                 // display cursor at this coordinate
      endif

    else        // vertical radio buttons
      if lNoBox
	setpos( nRow-if(lNoTitle,1,0), nCol )
	aeval( aChoices, bVERTICALCONTROL )            // show buttons
	setpos( nCursorPos, nCol+1 )                   // display cursor at this coordinate
      else
	setpos( nRow, nCol )
	aeval( aChoices, bVERTICALCONTROL )            // show buttons
	setpos( nCursorPos, nCol+3 )                   // display cursor at this coordinate
      endif
    endif

    set cursor on

  dispend()

return nil


/*
³ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³  Radio and Check Buttons GET Reader.
³  Supports WHEN and VALID.
³ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/
function RBCB_Reader( oGet, lNoBox, lHoriz, cTitle, cYesMarker, cNoMarker )

  local aChoices      // radio button choices
  local cGreyColor    // greyed out color if WHEN condition failed
  local cSavedScreen  // to save portion of screen normally showing GET value
  local n             // temp variable
  local nChoice       // button choices (1st one is name of get variable)
  local nCursor       // button cursor (may be different than nChoice)
  local nFoundChoice  // array position of this gadget in all gadgets
  local nHSpacing     // how many spaces to leave between horizontal choices
  local nKey          // key pressed
  local nMaxChoices   // max number of choices
  local nOldChoice    // to save current choice
  local nOldCursor    // to save current cursor position
  local bHotKey       // code block for a set key that is pressed

  // initialize variables
  // 1st element of aAllButtons == GET var name
  // 4th   ''    ''     ''      == array subscript if GET var was an array
  nFoundChoice := ascan( aAllButtons, { |a| a[1] == oGet:Name .and.;  // compare against name
					    if( a[4] == NIL, ;        // compare against possible array subscript
					       .t., ;                 // no array used if NIL
					       a[4] == oGet:subscript ) } )
  aChoices     := aAllButtons[ nFoundChoice, 2 ]
  nHSpacing    := aAllButtons[ nFoundChoice, 3 ]

  // read the GET if the WHEN condition is satisfied
  if ( GetPreValidate( oGet ) )  // note: see our own version of this udf below

    // initialize variables
    n           := 0
    nKey        := 0
    nMaxChoices := len( aChoices )
    if nMaxChoices > 1                           // Only if a radio button
      // make a copy of the get var value
      nChoice := if( oGet:VarGet() != 0, oGet:VarGet(), 1 )
      if LastKey() == K_UP
	nCursor := nMaxChoices                   // On an UP that changes GET objects
      else
	nCursor := nChoice                       // cursor position
      endif                                      // move to last button of the new get
    else
      nChoice := oGet:VarGet()                   // Retain prior value
      nCursor := 1                               // cursor position
    endif

    // activate the GET for reading
    dispbegin()
    // save the 1 character spot where the GET value is about to be displayed
    cSavedScreen := savescreen( oGet:row, oGet:col, oGet:row, oGet:col )
    oGet:SetFocus()
    // restore the 1 character spot where the GET displayed its value
    restscreen( oGet:row, oGet:col, oGet:row, oGet:col, cSavedScreen )
    // redraw buttons: sets cursor under choice
    DrawRadioButtons( oGet:Row, oGet:Col, aChoices, nChoice, nCursor, ;
		      setcolor()/*oGet:ColorSpec*/, lNoBox, lHoriz, empty(cTitle), ;
		      nHSpacing, cYesMarker, cNoMarker )
    dispend()

    do while ( oGet:ExitState == GE_NOEXIT )

      nOldChoice := nChoice      // save "old" choice before movement
      nOldCursor := nCursor      // save "old" cursor choice before movement
      nKey       := inkey(0)     // wait for a key to be pressed

      // see if a hot key was pressed

      if ( bHotKey := setkey( nKey ) ) != nil
	eval( bHotKey, procname(1), procline(1), readvar() )
	loop  // get next key
      endif

      // determine what key was pressed

      do case
      case nKey == K_ESC        // cancel selection
	oGet:ExitState := GE_ESCAPE

      case nKey == K_SPACE      // move to cursor or the next radio button choice
	if ! nCursor == nChoice
	  // move choice to cursor position
	  nChoice := nCursor
	else
	  if nMaxChoices == 1                    // It's a tick box
	    nChoice := 0                         // Toggle the only choice
	  else                                   // Only if a radio button
	    // move choice to next button
	    nCursor := nChoice := if( nChoice == nMaxChoices, 1, nChoice+1 )
	  endif
	endif

      case nKey == K_ENTER      // get to the next get
	oGet:ExitState := GE_ENTER

      case nKey == K_UP         // up arrow
	if lHoriz               // horizontal box: exit to previous get
	  oGet:exitstate := GE_UP
	else                    // vertical box: move cursor up
	  if nCursor == 1
	    oGET:exitstate := GE_UP  // move to previous get
	  else
	    nCursor--
	  endif
	endif

      case nKey == K_DOWN       // down arrow
	if lHoriz               // horizontal box: exit to next get
	  oGET:exitstate := GE_DOWN
	else                    // vertical box: move cursor down
	  if nCursor == nMaxChoices
	    oGET:exitstate := GE_DOWN  // move to next get
	  else
	    nCursor++
	  endif
	endif

      case nKey == K_LEFT       // left arrow
	if lHoriz               // horizontal box: move cursor to previous choice
	  if nCursor == 1
	    nCursor := nMaxChoices
	    // to move to the previous get,
	    // comment the line above and uncomment the next line
	    // oGET:exitstate := GE_UP  // move to previous get
	  else
	    nCursor--
	  endif
	else                    // vertical box
	  // uncomment this line if you want the cursor to move to previous get
	  // oGet:exitstate := GE_UP
	endif

      case nKey == K_RIGHT      // right arrow
	if lHoriz               // horizontal box: move cursor to next choice
	  if nCursor == nMaxChoices
	    nCursor := 1
	    // to move to the next get,
	    // comment the line above and uncomment the next line
	    // oGET:exitstate := GE_DOWN  // move to next get
	  else
	    nCursor++
	  endif
	else                    // vertical box
	  // uncomment this line if you want the cursor to move to next get
	  // oGET:exitstate := GE_DOWN
	endif

      case nKey == K_TAB        // tab: exit to next get
	oGET:exitstate := GE_DOWN

      case nKey == K_SH_TAB     // shift-tab: exit to previous get
	oGet:exitstate := GE_UP

      case nKey == K_PGUP       // page up
	oGET:ExitState := GE_WRITE

      case nKey == K_PGDN       // page down
	oGet:ExitState := GE_WRITE

      otherwise
	if Len(aChoices) > 1
	  // handle if user pressed a key to select the first letter
	  // 1st, continue search from current location
	  n := ascan( aChoices, ;
		      { |c| upper( left(c,1) ) == upper ( chr(nKey) ) },;
		      nChoice+1, nMaxChoices )
	  if n == 0
	    // 2nd, if another not found, restart search from the top
	    n := ascan( aChoices, ;
			{ |c| upper( left(c,1) ) == upper ( chr(nKey) ) },;
			1, nChoice - 1 )
	  endif
	  nCursor := nChoice := if( n > 0, n, nChoice )  // move cursor if a match

	elseif upper( left(aChoices[1],1) ) == upper ( chr(nKey) )
	  nChoice := if( nChoice == 0, 1, 0)  // Toggle the tick box for check box

	endif

      endcase

      // check if moved to new radio button selection
      if ! nOldChoice == nChoice .or. ! nOldCursor == nCursor
	DrawRadioButtons( oGet:Row, oGet:Col, aChoices, nChoice, nCursor, ;
			  setcolor()/*oGet:ColorSpec*/, lNoBox, lHoriz, empty(cTitle), ;
			  nHSpacing, cYesMarker, cNoMarker)
      endif

      // disallow exit if the VALID condition is not satisfied
      if ! GetPostValidate( oGet )
	oGet:ExitState := GE_NOEXIT
      end

    enddo ( oGet:ExitState == GE_NOEXIT )

    oGet:VarPut( nChoice )   // update get var

    // de-activate the GET
    dispbegin()
    // save the 1 character spot where the GET value is about to be displayed
    cSavedScreen := savescreen( oGet:row, oGet:col, oGet:row, oGet:col )
    oGet:KillFocus()
    // restore the 1 character spot where the GET displayed its value
    restscreen( oGet:row, oGet:col, oGet:row, oGet:col, cSavedScreen )
    dispend()

  else
    // failed pre-validation (ie., WHEN)
    // grey out the radio button box choices
    cGreyColor := if( (n:=at(",",oGet:ColorSpec)) > 0, ;  // find comma dilimiter
		  substr(oGet:ColorSpec,n+1), ;           // remainder of color string
		  oGet:ColorSpec )                        // same color as regular

    // Uncomment the next lines to change data value if WHEN condition fails
    //-x- // return zero for disabled button
    //-x- oGet:VarPut( 0 )   // update get var
    oGet:VarPut( nChoice )   // update get var

    DrawRadioButtons( oGet:Row, oGet:Col, aChoices, nChoice, nCursor, ;
		      cGreyColor, lNoBox, lHoriz, empty(cTitle), ;
		      nHSpacing, cYesMarker, cNoMarker)

  endif

return nil


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// A copy from Nantucket's version with some modifications.
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
/*
³ GetPreValidate()
³ Test entry condition (WHEN clause) for a GET.
*/
static function GetPreValidate( get )

  local when := .t.

	if ( get:preBlock <> NIL )
    when := Eval(get:preBlock, get)
  end

  if ( !when )
    get:exitState := GE_WHEN    // indicates failure

	else
		get:exitState := GE_NOEXIT              // prepares for editing

	end

return when


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// A copy from Nantucket's version with some modifications.
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
/*
³ GetPostValidate()
³ Test exit condition (VALID clause) for a GET.
*/
static function GetPostValidate( get )

  local valid := .t.

	if ( get:exitState == GE_ESCAPE )
		return (.t.)                                    // NOTE
	end

	// check VALID condition if specified
  if ( get:postBlock <> NIL )
    valid := Eval(get:postBlock, get)
  end

return (valid)


/*
³ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³  Draw Shadow to the right and under Box
³ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/
static function DrawBoxShadow( nTop, nLeft, nBottom, nRight )

  // save old color
  local cOldColor := set( _SET_COLOR )

  // build bottom shadow buffer array (account for screen height)
  local BottomBuf := if( nBottom < maxrow(), ;
			 { nBottom + 1, ;
			   nLeft + 1, ;
			   nBottom + 1, ;
			   if( nRight < maxcol(), ;
			       nRight + 1, ;
			       nRight ;
			     ), ;
			   savescreen( nBottom + 1, ;
				       nLeft + 1, ;
				       nBottom+1, ;
				       if( nRight < maxcol(), ;
					   nRight + 1, ;
					   nRight ;
					 ) ;
				     ) ;
			 }, ;
			 nil ;
		       )

  // build right shadow buffer array (account for screen width)
  local RightBuf := if( nRight < maxcol(), ;
			{ nTop + 1, ;
			  nRight + 1, ;
			  if( nBottom < maxrow(), ;
			      nBottom + 1, ;
			      nBottom ;
			    ), ;
			  nRight + 1, ;
			  savescreen( nTop + 1, ;
				      nRight + 1, ;
				      if( nBottom < maxrow(), ;
					  nBottom + 1, nBottom ;
					), ;
				      nRight + 1 ;
				    ) ;
			}, ;
			nil ;
		      )

  // code block to evaluate shadow buffer arrays
  local ShdwStrip := { | buf | ( restscreen( buf[1], buf[2], buf[3], buf[4], ;
				   transform( buf[5], ;
					      replicate( "X" + chr(8), ;
							 len( buf[5] ) * 0.5 ;
						       ) ;
					    ) ;
					   ) ;
			       ) ;
		     }

  // draw bottom shadow
  if ! BottomBuf == NIL
    eval( ShdwStrip, BottomBuf )
  endif

  // draw right shadow
  if ! RightBuf == NIL
    eval( ShdwStrip, RightBuf )
  endif

  // restore original color
  set( _SET_COLOR, cOldColor )

return nil


/*
³ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³  Clear the radio button array.  Do this after the READ to free up memory.
³ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/
function RBCB_Kill()
  aAllButtons := {}
return nil







**********************************************
// NOVO







//-------------------------------------------------------------------//
//
// WvtSetObjects() array structure
//
#define WVT_OBJ_TYPE 1
#define WVT_OBJ_ID 2
#define WVT_OBJ_ROW 3
#define WVT_OBJ_COL 4
#define WVT_OBJ_ROWTO 5
#define WVT_OBJ_COLTO 6
#define WVT_OBJ_ONDISP 7
#define WVT_OBJ_ONMOUSEOVER 8
#define WVT_OBJ_ONBUTTONDOWN 9
#define WVT_OBJ_ONBUTTONUP 10
#define WVT_OBJ_TOOLTIP 11
#define WVT_OBJ_STATE 12
#define WVT_OBJ_DUMMY 13

#define WVT_OBJ_VRBLS 13

// WVT_OBJ_TYPE Constants
//
#define OBJ_TYPE_BUTTON 1

// WVT_OBJ_STATE
//
#define OBJ_STATE_HIDE 0
#define OBJ_STATE_DISP 1
#define OBJ_STATE_MOUSEOVER 2
#define OBJ_STATE_BUTTONDOWN 3
#define OBJ_STATE_BUTTONUP 4

//-------------------------------------------------------------------//

#define IMAGE_VOUCH 'vouch1.bmp'
#define IMAGE_BROWSE 'v_browse.ico'
#define IMAGE_VR 'vr_1.ico'
#define IMAGE_NOTES 'v_notes.ico'
#define IMAGE_TOOLS 'v_tools.ico'
#define IMAGE_HELP 'v_notes.ico'

//-------------------------------------------------------------------//
//
// Candidate for inkey.ch
//
#define K_SBLINEUP 1051
#define K_SBLINEDOWN 1052
#define K_SBPAGEUP 1053
#define K_SBPAGEDOWN 1054

#define K_SBLINELEFT 1055
#define K_SBLINERIGHT 1056
#define K_SBPAGELEFT 1057
#define K_SBPAGERIGHT 1058

#define K_SBTHUMBTRACKVERT 1059
#define K_SBTHUMBTRACKHORZ 1060

//-------------------------------------------------------------------//

#define CRLF chr( 13 )+chr( 10 )

//-------------------------------------------------------------------//


//-------------------------------------------------------------------//
//PROCEDURE Main()



function TESTEMENU

LOCAL aLastPaint, clr, scr, bWhen, bValid
LOCAL dDate := ctod( '' )
LOCAL cName := Pad( 'Pritpal Bedi', 35 )
LOCAL cAdd1 := Pad( '60, New Professor Colony', 35 )
LOCAL cAdd2 := Pad( 'Ludhiana, INDIA', 35 )
LOCAL cAdd3 := Pad( 'http://www.vouchcac.com', 35 )
LOCAL nSlry := 20000
LOCAL aBlocks := {}
LOCAL nColGet := 8
LOCAL GetList := {}
LOCAL nTop := 4
LOCAL nLft := 4
LOCAL nBtm := 20
LOCAL nRgt := 75
LOCAL nMaxRows:= MaxRow()
LOCAL nBtnRow := nMaxRows - 1
LOCAL cLabel := 'xHarbour simulated GUI.'
LOCAL aObjects:= WvtSetObjects( {} )
LOCAL aObj := {}
LOCAL hPopup := Wvt_SetPopupMenu()
LOCAL oMenu := CreateMainMenu()

lNanuvem = .f.

SET DATE BRITISH

WvtSetKeys( .t. )
Popups( 1 )

Wvt_SetFont( 'Courier New', 18, 0, 0 )
Wvt_SetMouseMove( .t. )

// Force mouse pointer right below the xHarbour label
//
Wvt_SetMousePos( 2,40 )

aAdd( aBlocks, {|| Wvt_SetIcon( 'vr_1.ico' ) } )
aAdd( aBlocks, {|| Wvt_SetTitle( 'Vouch' ) } )
aAdd( aBlocks, {|| Wvt_DrawLabel( 1,40, cLabel,6,, rgb(255,255,255), rgb(198,198,198), 'Arial', 26, , , , , .t., .t. ) } )
aAdd( aBlocks, {|| Wvt_DrawBoxRaised( nTop, nLft, nBtm, nRgt ) } )
aAdd( aBlocks, {|| Wvt_DrawBoxRecessed( 7, 61, 13, 70 ) } )
aAdd( aBlocks, {|| Wvt_DrawBoxGroup( 15, 59, 18, 72 ) } )
aAdd( aBlocks, {|| Wvt_DrawBoxGroup( 5, 6, 19, 44 ) } )
aAdd( aBlocks, {|| Wvt_DrawImage( 8,62,12,69, IMAGE_VOUCH ) } )
aAdd( aBlocks, {|| Wvt_DrawBoxRecessed( 7, 48, 13, 55 ) } )
aAdd( aBlocks, {|| Wvt_DrawLine( maxrow()-2,0,maxrow()-2,maxcol(),WVT_LINE_HORZ,WVT_LINE_RECESSED,WVT_LINE_BOTTOM ) } )

aAdd( aBlocks, {|| Wvt_DrawLine( maxrow()-1, 4,maxrow(), 4,WVT_LINE_VERT,WVT_LINE_RECESSED,WVT_LINE_CENTER ) } )
aAdd( aBlocks, {|| Wvt_DrawLine( maxrow()-1,41,maxrow(),41,WVT_LINE_VERT,WVT_LINE_RECESSED,WVT_LINE_CENTER ) } )

aAdd( aBlocks, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )

#define btnFDisp WVT_BTN_FORMAT_FLAT
#define btnFMOver WVT_BTN_FORMAT_RAISED
#define btnFBDown WVT_BTN_FORMAT_RECESSED
#define btnFBUp WVT_BTN_FORMAT_FLAT

#define  IMAGE_VOUCH          'vouch1.bmp'
#define  IMAGE_BROWSE         'v_browse.ico'
#define  IMAGE_VR             'vr_1.ico'
#define  IMAGE_NOTES          'v_notes.ico'
#define  IMAGE_TOOLS          'v_tools.ico'
#define  IMAGE_HELP           'v_notes.ico'
#define OBJ_TYPE_BUTTON            1


*WvtSetObjects( { OBJ_TYPE_BUTTON, 1, nBtnRow, 6,nBtnRow+1, 9}) //, ;
*{|| Wvt_DrawButton( nBtnRow, 6,nBtnRow+1, 9, ,IMAGE_VOUCH,btnFDisp ) },;
*{|| Wvt_DrawButton( nBtnRow, 6,nBtnRow+1, 9, ,IMAGE_VOUCH,btnFMOver ) },;
*{|| Wvt_DrawButton( nBtnRow, 6,nBtnRow+1, 9, ,IMAGE_VOUCH,btnFBDown ) },;
*{|| Wvt_DrawButton( nBtnRow, 6,nBtnRow+1, 9, ,IMAGE_VOUCH,btnFBUp ) ,;
*eval( SetKey( K_F2 ) ) } ;
*} )

aAdd( aBlocks,{|| Wvt_DrawButton( nBtnRow, 6,nBtnRow+1, 9, ,IMAGE_VOUCH,btnFDisp ) } )
aAdd( aBlocks,{|| Wvt_DrawButton( nBtnRow, 6,nBtnRow+1, 9, ,IMAGE_VOUCH,btnFMOver) } )
aAdd( aBlocks,{|| Wvt_DrawButton( nBtnRow, 6,nBtnRow+1, 9, ,IMAGE_VOUCH,btnFBDown) } )
aAdd( aBlocks,{|| Wvt_DrawButton( nBtnRow, 6,nBtnRow+1, 9, ,IMAGE_VOUCH,btnFBUp ) } )

*WvtSetObjects( { OBJ_TYPE_BUTTON, 2, nBtnRow,11,nBtnRow+1,14, ;
*{|| Wvt_DrawButton( nBtnRow,11,nBtnRow+1,14, ,IMAGE_BROWSE, btnFDisp ) },;
*{|| Wvt_DrawButton( nBtnRow,11,nBtnRow+1,14, ,IMAGE_BROWSE, btnFMOver ) },;
*{|| Wvt_DrawButton( nBtnRow,11,nBtnRow+1,14, ,IMAGE_BROWSE, btnFBDown ) },;
*{|| Wvt_DrawButton( nBtnRow,11,nBtnRow+1,14, ,IMAGE_BROWSE, btnFBUp ) ,;
*eval( SetKey( K_F5 ) ) } ;
*} )

*WvtSetObjects( { OBJ_TYPE_BUTTON, 3, nBtnRow,16,nBtnRow+1,19, ;
*{|| Wvt_DrawButton( nBtnRow,16,nBtnRow+1,19,'Expand',IMAGE_NOTES,btnFDisp ) },;
*{|| Wvt_DrawButton( nBtnRow,16,nBtnRow+1,19,'Expand',IMAGE_NOTES,btnFMOver ) },;
*{|| Wvt_DrawButton( nBtnRow,16,nBtnRow+1,19,'Expand',IMAGE_NOTES,btnFBDown ) },;
*{|| Wvt_DrawButton( nBtnRow,16,nBtnRow+1,19,'Expand',IMAGE_NOTES,btnFBUp ) ,;
*eval( SetKey( K_F3 ) ) } ;
*} )

*WvtSetObjects( { OBJ_TYPE_BUTTON, 4, nBtnRow,21,nBtnRow+1,24, ;
*{|| Wvt_DrawButton( nBtnRow,21,nBtnRow+1,24,'Shrink', , btnFDisp , rgb( 100,22,241 ), rgb( 0,100,0 ) ) },;
*{|| Wvt_DrawButton( nBtnRow,21,nBtnRow+1,24,'Shrink', , btnFMOver, rgb( 100,22,241 ), rgb( 0,100,0 ) ) },;
*{|| Wvt_DrawButton( nBtnRow,21,nBtnRow+1,24,'Shrink', , btnFBDown, rgb( 100,22,241 ), rgb( 0,100,0 ) ) },;
*{|| Wvt_DrawButton( nBtnRow,21,nBtnRow+1,24,'Shrink', , btnFBUp , rgb( 100,22,241 ), rgb( 0,100,0 ) ) ,;
*eval( SetKey( K_F4 ) ) } ;
*} )

*WvtSetObjects( { OBJ_TYPE_BUTTON, 5, nBtnRow,26,nBtnRow+1,29, ;
*{|| Wvt_DrawButton( nBtnRow,26,nBtnRow+1,29,'Minimize',IMAGE_TOOLS, btnFDisp ) },;
*{|| Wvt_DrawButton( nBtnRow,26,nBtnRow+1,29,'Minimize',IMAGE_TOOLS, btnFMOver ) },;
*{|| Wvt_DrawButton( nBtnRow,26,nBtnRow+1,29,'Minimize',IMAGE_TOOLS, btnFBDown ) },;
*{|| Wvt_DrawButton( nBtnRow,26,nBtnRow+1,29,'Minimize',IMAGE_TOOLS, btnFBUp ) ,;
*eval( SetKey( K_F6 ) ) },;
*} )

*WvtSetObjects( { OBJ_TYPE_BUTTON, 6, nBtnRow,31,nBtnRow+1,34, ;
*{|| Wvt_DrawButton( nBtnRow,31,nBtnRow+1,34,'Partial',IMAGE_HELP, btnFDisp ) },;
*{|| Wvt_DrawButton( nBtnRow,31,nBtnRow+1,34,'Partial',IMAGE_HELP, btnFMOver ) },;
*{|| Wvt_DrawButton( nBtnRow,31,nBtnRow+1,34,'Partial',IMAGE_HELP, btnFBDown ) },;
*{|| Wvt_DrawButton( nBtnRow,31,nBtnRow+1,34,'Partial',IMAGE_HELP, btnFBUp ) ,;
*eval( SetKey( K_F7 ) ) },;
*} )

*WvtSetObjects( { OBJ_TYPE_BUTTON, 7, nBtnRow,36,nBtnRow+1,39, ;
*{|| Wvt_DrawButton( nBtnRow,36,nBtnRow+1,39,'Lines',IMAGE_VR, btnFDisp , rgb( 100,22,241 ), rgb( 0,100,0 ) ) },;
*{|| Wvt_DrawButton( nBtnRow,36,nBtnRow+1,39,'Lines',IMAGE_VR, btnFMOver, rgb( 100,22,241 ), rgb( 0,100,0 ) ) },;
*{|| Wvt_DrawButton( nBtnRow,36,nBtnRow+1,39,'Lines',IMAGE_VR, btnFBDown, rgb( 100,22,241 ), rgb( 0,100,0 ) ) },;
*{|| Wvt_DrawButton( nBtnRow,36,nBtnRow+1,39,'Lines',IMAGE_VR, btnFBUp , rgb( 100,22,241 ), rgb( 0,100,0 ) ) ,;
*eval( SetKey( K_F8 ) ) } ;
*} )

aAdd( aBlocks, {|| Wvt_Mouse( -1000001 ) } )


aLastPaint := WvtSetBlocks( aBlocks )

scr := SaveScreen( 0,0,maxrow(),maxcol() )
clr := SetColor( 'N/W' )

CLS

SetColor( 'N/W,N/GR*,,,N/W*' )

Wvt_SetMenu( oMenu:hMenu )
Wvt_DrawMenuBar()
SetKey( Wvt_SetMenuKeyEvent(), { || ActivateMenu( oMenu ) } )

@ 6, nColGet SAY '< Date >'
@ 9, nColGet SAY '<' + PadC( 'Name', 33 ) + '>'
@ 12, nColGet SAY '<' + PadC( 'Address', 33 ) + '>'
@ 16, 61 SAY '< Salary >'

dDate := ctod( '04/01/04' )

@ 7, nColGet GET dDate WHEN DispStatusMsg( 'Date must be Valid' );
VALID ClearStatusMsg()
@ 10, nColGet GET cName WHEN DispStatusMsg( 'Must be one of the list!' );
VALID ( VouChoice() < 7 .and. ClearStatusMsg() )
@ 13, nColGet GET cAdd1
@ 15, nColGet GET cAdd2
@ 17, nColGet GET cAdd3
@ 17, 61 GET nSlry PICTURE '@Z 9999999.99'

READ



// Restore Environment
//
WvtSetBlocks( aLastPaint )
WvtSetObjects( aObjects )
SetColor( clr )
RestScreen( 0,0,maxrow(),maxcol(), scr )
WvtSetKeys( .f. )
Wvt_SetPopupMenu( hPopup )

RETURN

//-------------------------------------------------------------------//
PROCEDURE WvtNextGets()

LOCAL aLastPaint, clr
LOCAL dDate := ctod( '' )
LOCAL cName := Space( 35 )
LOCAL cAdd1 := Space( 35 )
LOCAL cAdd2 := Space( 35 )
LOCAL cAdd3 := Space( 35 )
LOCAL nSlry := 0
LOCAL aBlocks := {}
LOCAL nColGet := 8
LOCAL GetList := {}
LOCAL nTop := 4
LOCAL nLft := 4
LOCAL nBtm := 20
LOCAL nRgt := 75
LOCAL kf2 := SetKey( K_F2, {|| WvtGets() } )
LOCAL kf3 := SetKey( K_F3, {|| WvtWindowExpand( 1 ) } )
LOCAL kf4 := SetKey( K_F4, {|| WvtWindowExpand( -1 ) } )
LOCAL cLabel := 'VOUCH, that GROWS with you'
LOCAL aPalette := Wvt_GetPalette()
LOCAL aNewPalette:= aclone( aPalette )
LOCAL aObjects := WvtSetObjects( {} )
LOCAL nRow := Row()
LOCAL nCol := Col()
LOCAL scr := SaveScreen( 0,0,maxrow(),maxcol() )
LOCAL wvtScr := Wvt_SaveScreen( 0,0,maxrow(),maxcol() )

// Change the values of pallatte arbitrarily though yu can fine tune
// these values with realistic values.
//
aNewPalette[ 8 ] := aNewPalette[ 8 ] + 100000

Wvt_SetPalette( aNewPalette )

aAdd( aBlocks, {|| Wvt_SetTitle( 'Wvt Gets 2nd Window with Different Palette' ) } )
aAdd( aBlocks, {|| Wvt_DrawLine( maxrow()-1,0,maxrow()-1,maxcol() ) })
aAdd( aBlocks, {|| Wvt_SetBrush( 0, rgb( 32,255,100 ) ) } )
aAdd( aBlocks, {|| Wvt_DrawEllipse( 6,50,10,58 ) } )
aAdd( aBlocks, {|| Wvt_SetBrush( 2, rgb( 255,255,100 ),1 ) } )
aAdd( aBlocks, {|| Wvt_DrawRectangle( 11, 50, 13, 58 ) } )
aAdd( aBlocks, {|| Wvt_DrawBoxGroupRaised( 5, 6, 19, 72 ) } )
aAdd( aBlocks, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )

aAdd( aBlocks, {|| Wvt_DrawButton( 21, 6,22, 9,'New' ,'vouch1.bmp' ) } )
aAdd( aBlocks, {|| Wvt_DrawButton( 21,11,22,14,'Browse','vouch1.bmp', 1, rgb( 255,255,255 ) ) } )
aAdd( aBlocks, {|| Wvt_DrawButton( 21,16,22,19, ,'vouch1.bmp' ) } )
aAdd( aBlocks, {|| Wvt_DrawButton( 21,21,22,24,'Data',, 0, rgb( 100,22,241 ), rgb( 198,198,198 ) ) } )
aAdd( aBlocks, {|| Wvt_DrawButton( 21,26,22,29,'Flat',IMAGE_VR,2 ) } )
aAdd( aBlocks, {|| Wvt_DrawButton( 21,31,22,34,'Outline',IMAGE_VR,3 ) } )
aAdd( aBlocks, {|| Wvt_DrawButton( 22,36,22,41,'Data',, 0, rgb( 100,22,241 ), rgb( 198,198,198 ) ) } )

aLastPaint := WvtSetBlocks( aBlocks )
clr := SetColor( 'N/W,N/GR*,,,N/W*' )

CLS

@ MaxRow(), 0 SAY PadC( 'xHarbour + WVT Console GUI Screen',80 ) COLOR 'R+/W'

@ 6, nColGet SAY '< Date >'
@ 9, nColGet SAY '<' + PadC( 'Name', 33 ) + '>'
@ 12, nColGet SAY '<' + PadC( 'Address', 33) + '>'
@ 16, 61 SAY '< Salary >'

@ 7, nColGet GET dDate
@ 10, nColGet GET cName
@ 13, nColGet GET cAdd1
@ 15, nColGet GET cAdd2
@ 17, nColGet GET cAdd3
@ 17, 61 GET nSlry PICTURE '@Z 9999999.99'

READ

// Restore Environment
//
Wvt_SetPalette( aPalette )
WvtSetObjects( aObjects )
WvtSetBlocks( aLastPaint )
SetColor( clr )
RestScreen( 0,0,maxrow(),maxcol(), scr )
Wvt_RestScreen( wvtScr )
SetPos( nRow, nCol )
RETURN

//-------------------------------------------------------------------//
FUNCTION WvtSetKeys( lSet )

if lSet
keys_[ 2 ] := SetKey( K_F2, {|| WvtNextGets() } )
keys_[ 3 ] := SetKey( K_F3, {|| WvtWindowExpand( 1 ) } )
keys_[ 4 ] := SetKey( K_F4, {|| WvtWindowExpand( -1 ) } )
keys_[ 5 ] := SetKey( K_F5, {|| WvtMyBrowse() } )
keys_[ 6 ] := SetKey( K_F6, {|| Wvt_Minimize() } )
keys_[ 7 ] := SetKey( K_F7, {|| WvtPartialScreen() } )
keys_[ 8 ] := SetKey( K_F8, {|| WvtLines() } )
keys_[ 9 ] := SetKey( K_F9, {|| Wvt_ChooseFont() } )
keys_[ 10] := SetKey( K_F10,{|| Wvt_ChooseColor() } )
else
SetKey( K_F2, keys_[ 2 ] )
SetKey( K_F3, keys_[ 3 ] )
SetKey( K_F4, keys_[ 4 ] )
SetKey( K_F5, keys_[ 5 ] )
SetKey( K_F6, keys_[ 6 ] )
SetKey( K_F7, keys_[ 7 ] )
SetKey( K_F8, keys_[ 8 ] )
SetKey( K_F9, keys_[ 9 ] )
SetKey( K_F10, keys_[ 10] )
endif

RETURN Nil
//-------------------------------------------------------------------//
// Wvt_Paint() must be a FUNCTION in your application
// as it is called when Window gets WM_PAINT message.
//-------------------------------------------------------------------//

//-------------------------------------------------------------------//
// Wvt_SetFocus() must be a FUNCTION in your application
// needs to process messages sent through WM_SETFOCUS message
// received by the window.
//-------------------------------------------------------------------//
FUNCTION Wvt_SetFocus( hWnd )

*LOCAL nRow := row()
*LOCAL nCol := col()

*DispOutAt( 1,3, 'Focus Gained!', 'r/w' )

*DevPos( nRow, nCol )

RETURN nil

//-------------------------------------------------------------------//
// Wvt_KillFocus() must be a FUNCTION in your application
// needs to process messages sent through WM_KILLFOCUS message
// received by the window.
//-------------------------------------------------------------------//
FUNCTION Wvt_KillFocus( hWnd )

*LOCAL nRow := row()
*LOCAL nCol := col()

*DispOutAt( 1,3, 'Focus Lost...', 'B/w' )

*DevPos( nRow, nCol )

RETURN nil
//-------------------------------------------------------------------//
//
// Wvt_Mouse() must be present if you want to catch and fire
// mouse call back outside of the inkey() loop.
//
//-------------------------------------------------------------------//


nObj := ascan( aObjects, {|e_| e_[ WVT_OBJ_ROW ] <= nRow .and. ;
e_[ WVT_OBJ_ROWTO ] >= nRow .and. ;
e_[ WVT_OBJ_COL ] <= nCol .and. ;
e_[ WVT_OBJ_COLTO ] >= nCol } )
if nObj == 0
if nLastObj > 0
aObjects[ nLastObj, WVT_OBJ_STATE ] := OBJ_STATE_DISP
eval( aObjects[ nLastObj, WVT_OBJ_ONDISP ] )
nLastObj := 0
endif
return nil
endif

if nLastObj == nObj .and. nLastKey == nKey
return nil
endif

nLastObj := nObj
nLastKey := nKey

DO CASE
CASE nKey == K_MOUSEMOVE
if aObjects[ nLastObj, WVT_OBJ_STATE ] <> OBJ_STATE_MOUSEOVER
aObjects[ nLastObj, WVT_OBJ_STATE ] := OBJ_STATE_MOUSEOVER
if aObjects[ nObj, WVT_OBJ_ONMOUSEOVER ] <> nil
eval( aObjects[ nObj, WVT_OBJ_ONMOUSEOVER ] )
endif
endif

CASE nKey == K_LBUTTONDOWN
aObjects[ nLastObj, WVT_OBJ_STATE ] := OBJ_STATE_BUTTONDOWN
if aObjects[ nObj, WVT_OBJ_ONBUTTONDOWN ] <> nil
eval( aObjects[ nObj, WVT_OBJ_ONBUTTONDOWN ] )
endif

CASE nKey == K_LBUTTONUP
aObjects[ nLastObj, WVT_OBJ_STATE ] := OBJ_STATE_DISP
if aObjects[ nObj, WVT_OBJ_ONBUTTONUP ] <> nil
eval( aObjects[ nObj, WVT_OBJ_ONBUTTONUP ] )
endif

ENDCASE

RETURN nil
//-------------------------------------------------------------------//
//-------------------------------------------------------------------//
//-------------------------------------------------------------------//
// WvtSetBlocks() is a get/set FUNCTION to be used by Wvt_Paint()
//-------------------------------------------------------------------//
FUNCTION WvtSetBlocks( a_ )

LOCAL o
STATIC s := {}

o := aClone( s )

IF a_ <> nil
  s := aClone( a_ )
ENDIF

RETURN o
//-------------------------------------------------------------------//
// WvtSetObjects() is a get/set FUNCTION to be used by Wvt_Mouse()
//-------------------------------------------------------------------//
FUNCTION WvtSetObjects( aObject )

LOCAL oObjects
STATIC aObjects := {}

oObjects := aclone( aObjects )

if aObject <> nil
  if empty( aObject )
    aObjects := {}
  else
    if valtype( aObject[ 1 ] ) == 'A'
      aeval( aObject, {|e_| aadd( aObjects, e_ ) } )
    else
      aSize( aObject, WVT_OBJ_VRBLS )

      DEFAULT aObject[ WVT_OBJ_STATE ] TO OBJ_STATE_DISP

      aadd( aObjects, aObject )
    endif
  endif
endif

RETURN oObjects
//-------------------------------------------------------------------//
FUNCTION SetMouseCheck( lYes )
LOCAL lOYes
STATIC lSYes := .t.

lOYes := lSYes
if lYes <> nil
lSYes := lYes
endif

RETURN lOYes

//-------------------------------------------------------------------//

FUNCTION WvtWindowExpand( nUnits )

STATIC sUnits := 18

sUnits += nUnits

Wvt_setFont( 'Courier New', sUnits )

RETURN .t.

//-------------------------------------------------------------------//
//STATIC FUNCTION rgb( r,g,b )

//RETURN ( r + ( g * 256 ) + ( b * 256 * 256 ) )

//-------------------------------------------------------------------//
FUNCTION VouChoice( aChoices )

LOCAL scr, clr, nChoice

DEFAULT aChoices TO { 'One','Two','Three','Four','Five','Six','Seven' }

scr := SaveScreen( 7,48,13,55 )
clr := SetColor( 'N/W*,GR+/B*,,,GR+/B' )

nChoice := aChoice( 7, 48, 13, 55, aChoices )

setColor( clr )
RestScreen( 7, 48, 13, 55, scr )

RETURN nChoice

//-------------------------------------------------------------------//
FUNCTION WvtMyBrowse()

LOCAL nKey, bBlock, oBrowse , aLastPaint, i
LOCAL lEnd := .f.
LOCAL aBlocks := {}
LOCAL info_ := {}
LOCAL nTop := 3
LOCAL nLeft := 3
LOCAL nBottom := maxrow() - 2
LOCAL nRight := maxcol() - 3
LOCAL nCursor := setCursor( 0 )
LOCAL nRow := row()
LOCAL nCol := col()
LOCAL cColor := SetColor( 'N/W*,N/GR*,,,N/W*' )
LOCAL cScr := SaveScreen( 0,0,maxrow(),maxcol() )
LOCAL aObjects:= WvtSetObjects( {} )
LOCAL hPopup := Wvt_SetPopupMenu()

STATIC nStyle := 0

USE 'TEST' NEW
if NetErr()
return nil
endif
info_:= DbStruct()

Popups( 2 )

oBrowse := TBrowseNew( nTop + 3, nLeft + 2, nBottom - 1, nRight - 2 )

oBrowse:ColSep = ' '
oBrowse:HeadSep = '__'
oBrowse:GoTopBlock = { || dbGoTop() }
oBrowse:GoBottomBlock = { || dbGoBottom() }
oBrowse:SkipBlock = { | nSkip | dbSkipBlock( nSkip,oBrowse ) }

for i := 1 to len( info_ )
bBlock := VouBlockField( i )
oBrowse:AddColumn( TBColumnNew( info_[ i,1 ], bBlock ) )
next

oBrowse:configure()

if nStyle > 5
nStyle := 0
endif

Wvt_SetPen( nStyle, 0, rgb( 210,1210,210 ) )

nStyle++

aAdd( aBlocks, {|| Wvt_SetIcon( 'DIA_EXCL.ico' ) } )
aAdd( aBlocks, {|| Wvt_SetTitle( 'WVT Gui TBrowse()' ) } )
aAdd( aBlocks, {|| Wvt_DrawBoxRaised( nTop, nLeft, nBottom, nRight ) } )
aAdd( aBlocks, {|| Wvt_DrawBoxRecessed( nTop+3, nLeft+2, nBottom-1, nRight-2 ) } )
aAdd( aBlocks, {|| Wvt_DrawGridHorz( oBrowse:nTop+3, oBrowse:nLeft, oBrowse:nRight, oBrowse:nBottom - oBrowse:nTop - 2 ) } )
aAdd( aBlocks, {|| Wvt_DrawGridVert( oBrowse:nTop, oBrowse:nBottom, oBrowse:aColumnsSep, len( oBrowse:aColumnsSep ) ) } )

aLastPaint := WvtSetBlocks( aBlocks )

DispBox( 0, 0, maxrow(), maxcol(), ' ', 'N/W' )
*DispOutAt( nTop + 1, nleft, padc( HB_CurDrive()+':'+CurDir()+'\'+'Test.dbf', nRight - nLeft + 1 ), 'W+/W' )

While !lEnd
oBrowse:ForceStable()

nKey = InKey( 0 )

BrwHandleKey( oBrowse, nKey, @lEnd )
end

Wvt_SetPen( 0 )
WvtSetBlocks( aLastPaint )
WvtSetObjects( aObjects )

DevPos( nRow, nCol )
SetColor( cColor )
SetCursor( nCursor )

DBCloseArea()
RestScreen( 0,0, maxrow(),maxcol(), cScr )
Wvt_setPopupMenu( hPopup )

RETURN nil
//-------------------------------------------------------------------//
STATIC FUNCTION DbSkipBlock( n, oTbr )

LOCAL nSkipped := 0

if n = 0
DBSkip( 0 )

elseif n > 0
do while nSkipped != n .and. TBNext( oTbr )
nSkipped++
enddo
else
do while nSkipped != n .and. TBPrev( oTbr )
nSkipped--
enddo
endif

RETURN nSkipped

//-------------------------------------------------------------------//
STATIC FUNCTION TBNext( oTbr )

LOCAL nSaveRecNum := recno()
LOCAL lMoved := .T.

if Eof()
lMoved := .F.
else
DBSkip( 1 )
if Eof()
lMoved := .F.
DBGoTo( nSaveRecNum )
endif
endif

RETURN lMoved
//-------------------------------------------------------------------//
STATIC FUNCTION TBPrev( oTbr )
LOCAL nSaveRecNum := Recno()
LOCAL lMoved := .T.

DBSkip( -1 )

if Bof()
DBGoTo( nSaveRecNum )
lMoved := .F.
endif

RETURN lMoved
//-------------------------------------------------------------------//
STATIC FUNCTION VouBlockField( i )

RETURN {|| fieldget( i ) }
//-------------------------------------------------------------------//
STATIC FUNCTION BrwHandleKey( oBrowse, nKey, lEnd )
LOCAL lRet := .t.

do case
case nKey == K_ESC
lEnd = .t.

case nKey == K_ENTER
lEnd := .t.

case nKey == K_DOWN
oBrowse:Down()

case nKey == K_UP
oBrowse:Up()

case nKey == K_LEFT
oBrowse:Left()

case nKey == K_RIGHT
oBrowse:Right()

case nKey = K_PGDN
oBrowse:pageDown()

case nKey = K_PGUP
oBrowse:pageUp()

case nKey = K_CTRL_PGUP
oBrowse:goTop()

case nKey = K_CTRL_PGDN
oBrowse:goBottom()

case nKey = K_HOME
oBrowse:home()

case nKey = K_END
oBrowse:end()

case nKey = K_CTRL_LEFT
oBrowse:panLeft()

case nKey = K_CTRL_RIGHT
oBrowse:panRight()

case nKey = K_CTRL_HOME
oBrowse:panHome()

case nKey = K_CTRL_END
oBrowse:panEnd()

case nKey == K_MWBACKWARD
oBrowse:down()

case nKey == K_MWFORWARD
oBrowse:up()

otherwise
lRet := .f.

endcase

RETURN lRet

//-------------------------------------------------------------------//

STATIC FUNCTION BrwOnEvent( oWvtBrw, cPaintID, oBrowse, nKey )
LOCAL lRet := .t., lRefAll := .f.

do case
case nKey == K_DOWN
oBrowse:Down()

case nKey == K_UP
oBrowse:Up()

case nKey == K_LEFT
oBrowse:Left()

case nKey == K_RIGHT
oBrowse:Right()

case nKey = K_PGDN
oBrowse:pageDown()
lRefAll := .t.

case nKey = K_PGUP
oBrowse:pageUp()
lRefAll := .t.

case nKey = K_CTRL_PGUP
oBrowse:goTop()
lRefAll := .t.

case nKey = K_CTRL_PGDN
oBrowse:goBottom()
lRefAll := .t.

case nKey = K_HOME
oBrowse:home()

case nKey = K_END
oBrowse:end()

case nKey = K_CTRL_LEFT
oBrowse:panLeft()

case nKey = K_CTRL_RIGHT
oBrowse:panRight()

case nKey = K_CTRL_HOME
oBrowse:panHome()

case nKey = K_CTRL_END
oBrowse:panEnd()

case nKey == K_MWBACKWARD
oBrowse:down()

case nKey == K_MWFORWARD
oBrowse:up()

case nKey == K_SBTHUMBTRACKVERT
OrdKeyGoTo( oWvtBrw:oVBar:GetPos() )
lRefAll := .t.

case nKey == K_SBTHUMBTRACKHORZ
oBrowse:ColPos := oWvtBrw:oHBar:GetPos()

case nKey == K_SBLINEUP
oBrowse:up()

case nKey == K_SBLINEDOWN
oBrowse:down()

case nKey == K_SBPAGEUP
oBrowse:PageUp()

case nKey == K_SBPAGEDOWN
oBrowse:PageDown()

case nKey == K_SBLINELEFT
oBrowse:Left()

case nKey == K_SBLINERIGHT
oBrowse:Right()

case nKey == K_SBPAGELEFT
oBrowse:Left()

case nKey == K_SBPAGERIGHT
oBrowse:right()

otherwise
lRet := .f.

endcase

if lRet
if lRefAll
oBrowse:RefreshAll()
endif
oBrowse:ForceStable()

oWvtBrw:oVBar:SetPos( OrdKeyCount(),OrdKeyNo() )
oWvtBrw:oHBar:SetPos( oBrowse:ColCount, oBrowse:ColPos )
endif

RETURN Nil

//-------------------------------------------------------------------//

FUNCTION WvtPartialScreen()
LOCAL scr := SaveScreen( 7,20,15,60 )
LOCAL wvtScr := Wvt_SaveScreen( 0, 0, MaxRow(), MaxCol() )
LOCAL wvtScr1
LOCAL aLastPaint
LOCAL hPopup := Wvt_SetPopupMenu()

aLastPaint := WvtSetBlocks( {} )

DispBox( 7, 20, 15, 60, ' ', 'W/GR*' )
@ 10,25 SAY 'Wvt_SaveScreen()' COLOR 'N/GR*'
@ 11,25 SAY 'Wvt_RestScreen()' COLOR 'N/GR*'
@ 13,25 SAY 'Press Esc ' COLOR 'N/GR*'
Wvt_DrawBoxRecessed( 8,22,14,58 )

wvtScr1 := Wvt_SaveScreen( 7,20,15,60 )

do while inkey( 0 ) <> K_ESC
enddo

DispBox( 7, 20, 15, 60, ' ', 'W/B*' )
@ 10,25 SAY 'Wvt_SaveScreen()' COLOR 'N/B*'
@ 11,25 SAY 'Wvt_RestScreen()' COLOR 'N/B*'
@ 13,25 SAY 'Press Esc ' COLOR 'N/B*'
Wvt_DrawBoxRecessed( 8,22,14,58 )

do while inkey( 0 ) <> K_ESC
enddo

Wvt_RestScreen( 7,20,15,60, wvtScr1 )

do while inkey( 0 ) <> K_ESC
enddo

RestScreen( 7,20,15,60,scr )
Wvt_RestScreen( 0, 0, MaxRow(), MaxCol(), wvtScr )
WvtSetBlocks( aLastPaint )
Wvt_SetPopupMenu( hPopup )

RETURN NIL
//-------------------------------------------------------------------//

function WvtLines()
LOCAL scr := SaveScreen( 0,0,maxrow(),maxcol() )
LOCAL clr := SetColor( 'N/W' )
LOCAL nRows := maxrow()
LOCAL nCols := maxcol()
LOCAL aLastPaint := WvtSetBlocks( {} )
LOCAL aObjects := WvtSetObjects( {} )
LOCAL hPopup := Wvt_SetPopupMenu()

CLS

Wvt_DrawLine( 0, 0, 0, nCols, WVT_LINE_HORZ, WVT_LINE_RAISED , WVT_LINE_CENTER )
Wvt_DrawLine( 1, 0, 1, nCols, WVT_LINE_HORZ, WVT_LINE_RECESSED, WVT_LINE_TOP )
Wvt_DrawLine( 2, 0, 2, nCols, WVT_LINE_HORZ, WVT_LINE_PLAIN , WVT_LINE_CENTER, WVT_LINE_SOLID, 4, Rgb( 255,255,255 ) )
Wvt_DrawLine( 3, 0, 3, nCols, WVT_LINE_HORZ, WVT_LINE_RAISED , WVT_LINE_CENTER, WVT_LINE_DASH , 0, Rgb( 255,0,0 ) )
Wvt_DrawLine( 4, 0, 4, nCols, WVT_LINE_HORZ, WVT_LINE_RECESSED, WVT_LINE_BOTTOM )

@ 0, 1 SAY 'Center Raised'
@ 1,11 say 'Top Recessed'
@ 2,21 say 'Center Plain White 3 Pixels'
@ 3,31 say 'Center Raised Dotted'
@ 4,41 SAY 'Bottom Recessed'
@ 5, 1 SAY 'Bottom Checked'

@ nRows, 0 Say PadC( 'Press ESC to Quit', nCols+1 ) COLOR 'GR+/W'

Wvt_DrawLine( 11, 5,nRows-2, 5, WVT_LINE_VERT, WVT_LINE_RAISED , WVT_LINE_CENTER )
Wvt_DrawLine( 11, 6,nRows-2, 6, WVT_LINE_VERT, WVT_LINE_RECESSED, WVT_LINE_CENTER )
Wvt_DrawLine( 11, 7,nRows-2, 7, WVT_LINE_VERT, WVT_LINE_PLAIN , WVT_LINE_LEFT )
Wvt_DrawLine( 11, 8,nRows-2, 8, WVT_LINE_VERT, WVT_LINE_PLAIN , WVT_LINE_CENTER )
Wvt_DrawLine( 11, 9,nRows-2, 9, WVT_LINE_VERT, WVT_LINE_PLAIN , WVT_LINE_RIGHT )
Wvt_DrawLine( 11,10,nRows-2,10, WVT_LINE_VERT, WVT_LINE_PLAIN , WVT_LINE_CENTER, WVT_LINE_DOT, 0, RGB( 0,0,255 ) )
Wvt_DrawLine( 11,11,nRows-2,11, WVT_LINE_VERT, WVT_LINE_PLAIN , WVT_LINE_CENTER, WVT_LINE_DASH, 0, RGB( 255,0,0 ) )
Wvt_DrawLine( 11,12,nRows-2,12, WVT_LINE_VERT, WVT_LINE_PLAIN , WVT_LINE_CENTER, WVT_LINE_DASHDOT, 0, RGB( 0,255,0 ) )

@ 12,5 Say 'A'
@ 13,6 Say 'B'
@ 14,7 Say 'C'
@ 15,8 Say 'D'
@ 16,9 Say 'E'

do while ( inkey(0) <> 27 )
enddo

// Restore Environments
//
SetColor( clr )

RestScreen( 0,0,maxrow(),maxcol(), scr )
WvtSetBlocks( aLastPaint )
WvtSetObjects( aObjects )
Wvt_SetPopupMenu( hPopup )

RETURN nil

//-------------------------------------------------------------------//

FUNCTION DispStatusMsg( cMsg )

Wvt_DrawLabel( MaxRow(), 60, cMsg, 6, , 0, rgb(198,198,198), 'Arial', 18, , 900 )

RETURN .t.

//-------------------------------------------------------------------//

FUNCTION ClearStatusMsg()
LOCAL nRow := Row()
LOCAL nCol := Col()

DispOutAt( MaxRow(), 42, space( 37 ), 'W/W' )

SetPos( nRow, nCol )

RETURN .t.

//-------------------------------------------------------------------//

FUNCTION Popups( nID, lDestroy )
LOCAL hPop, hPop1
LOCAL nPrompt := MF_ENABLED+MF_STRING

static hPop_:= { , , , , , , , , }

if nID == nil
Wvt_SetPopupMenu()
return nil
endif

if lDestroy <> nil
Wvt_DestroyMenu( hPop_[ nID ] )
return nil
endif

hPop := hPop_[ nID ]

do case
case nID == 1 // Data Entry Module

if hPop == nil
hPop := Wvt_CreatePopupMenu()
Wvt_AppendMenu( hPop, nPrompt, K_F2, 'Second Get Screen' )
Wvt_AppendMenu( hPop, nPrompt, K_F3, 'Expand Window' )
Wvt_AppendMenu( hPop, nPrompt, K_F4, 'Shrink Window' )
Wvt_AppendMenu( hPop, nPrompt, K_F5, 'Browse' )
Wvt_AppendMenu( hPop, nPrompt, K_F6, 'Minimize' )
Wvt_AppendMenu( hPop, nPrompt, K_F7, 'Partial Screen' )
Wvt_AppendMenu( hPop, nPrompt, K_F8, 'Lines' )
Wvt_AppendMenu( hPop, nPrompt, K_F9, 'Choose Font' )
Wvt_AppendMenu( hPop, nPrompt, K_F10,'Choose Color' )

Wvt_AppendMenu( hPop, MF_SEPARATOR )

Wvt_AppendMenu( hPop, nPrompt, K_F5, 'Browse' )

endif

case nID == 2 // Browser

if hPop == nil
hPop := Wvt_CreatePopupMenu()
Wvt_AppendMenu( hPop, nPrompt, K_DOWN , 'Down' )
Wvt_AppendMenu( hPop, nPrompt, K_UP , 'Up' )
Wvt_AppendMenu( hPop, nPrompt, K_PGDN , 'Page Down' )
Wvt_AppendMenu( hPop, nPrompt, K_PGUP , 'Page Up' )
Wvt_AppendMenu( hPop, nPrompt, K_CTRL_PGUP, 'Top' )
Wvt_AppendMenu( hPop, nPrompt, K_CTRL_PGDN, 'Bottom' )

Wvt_AppendMenu( hPop, MF_SEPARATOR )

hPop1 := Wvt_CreatePopupMenu()
Wvt_AppendMenu( hPop1, nPrompt, K_RIGHT , 'Right' )
Wvt_AppendMenu( hPop1, nPrompt, K_LEFT , 'Left' )
Wvt_AppendMenu( hPop1, nPrompt, K_END , 'End' )
Wvt_AppendMenu( hPop1, nPrompt, K_HOME , 'Home' )

Wvt_AppendMenu( hPop, MF_ENABLED+MF_POPUP, hPop1, 'Column Movement' )

endif

endcase

hPop_[ nID ] := hPop

RETURN Wvt_SetPopupMenu( hPop_[ nID ] )

//-------------------------------------------------------------------//

FUNCTION WvtPictures( nSlot,cFilePic )

if nSlot <> nil .and. nSlot <= 20 .and. file( cFilePic )
if pic_[ nSlot ] <> cFilePic
if Wvt_LoadPicture( cFilePic, nSlot )
pic_[ nSlot ] := cFilePic
endif
endif
endif

RETURN nil

//-------------------------------------------------------------------//

FUNCTION WvtExePicture( nTop, nLeft, nBottom, nRight, nSlot, aOffset )

if pic_[ nSlot ] <> nil
Wvt_DrawPicture( nTop, nLeft, nBottom, nRight, nSlot, aOffSet )
endif

RETURN nil

//-------------------------------------------------------------------//

FUNCTION CreateMainMenu()
LOCAL oMenu
LOCAL g_oMenuBar := wvtMenu():new():create()

oMenu := wvtMenu():new():create()
oMenu:Caption:= "Wvt*Classes"
oMenu:AddItem( "Dialog One", {|| MyDialogOne() } )
oMenu:AddItem( "Dialog Two", {|| MyDialogTwo() } )
oMenu:AddItem( "-" )
oMenu:AddItem( "Exit" , {|| __keyboard( K_ESC ) } )
g_oMenuBar:addItem( "",oMenu )

oMenu := wvtMenu():new():create()
oMenu:Caption := "Traditional"
oMenu:AddItem( "Next Gets" , {|| WvtNextGets() } )
oMenu:AddItem( "Browser" , {|| WvtMyBrowse() } )
oMenu:AddItem( "Partial Screen", {|| WvtPartialScreen() } )
oMenu:AddItem( "-")
oMenu:AddItem( "Wvt Lines" , {|| WvtLines() } )
g_oMenuBar:addItem( "",oMenu )

oMenu := wvtMenu():new():create()
oMenu:Caption:= "Common Dialogs"
oMenu:AddItem( "Fonts" ,{|| Wvt_ChooseFont() } )
oMenu:AddItem( "-")
oMenu:AddItem( "Colors",{|| Wvt_ChooseColor() } )
g_oMenuBar:addItem( "",oMenu)

oMenu := wvtMenu():new():create()
oMenu:Caption:= "Functionality"
oMenu:AddItem( "Expand" ,{|| WvtWindowExpand( 1 ) } )
oMenu:AddItem( "Shrink" ,{|| WvtWindowExpand( -1 ) } )
oMenu:AddItem( "-")
oMenu:AddItem( "Minimize",{|| Wvt_Minimize() } )
g_oMenuBar:addItem( "",oMenu)

RETURN g_oMenuBar

//-------------------------------------------------------------------//

STATIC FUNCTION ActivateMenu( oMenu )
LOCAL nMenu := Wvt_GetLastMenuEvent()
LOCAL aMenuItem

IF !EMPTY( nMenu )

IF HB_ISOBJECT( oMenu )
IF !EMPTY( aMenuItem := oMenu:FindMenuItemById( nMenu ) )
IF HB_ISBLOCK( aMenuItem[ WVT_MENU_ACTION ] )
EVAL( aMenuItem[ WVT_MENU_ACTION ] )
ENDIF
ENDIF
ENDIF
ENDIF

RETURN ( NIL )

//-------------------------------------------------------------------//

STATIC FUNCTION MyDialogOne()
LOCAL aObjects:= WvtSetBlocks( {} )
Local nWinRows, nWinCols, cWinTitle, cFont, nHeight, nWidth
Local oDlg, obj_, oBar, d_, nN, cUseAlias
Local oText, oTBar, aImg_, oImg, oLine, oBox, oBtn, oBtn2
Local oBBox, oCon, oGet, oGet2, nRowG, oBBox2, oBnr, oTBx
Local oBRsd, cTxt, oRct, nGetCol, nSayCol, bBlock, bBlock1
Local oMnu, oWvtBrw, oWvtBrw1, lOpen, lOpen1, cUseAlias1, oGetArea, oGet1
LOCAL hPopup, nGetRow, aGets_, lChkMouse

WvtSetKeys( .f. )
lChkMouse := SetMouseCheck( .f. )

hPopup := Wvt_SetPopupMenu()
Popups()

cTxt := 'GtWvt is capable of designing virtually any preceivable control '
cTxt := cTxt + 'Windows offers.'
cTxt := cTxt + CRLF + CRLF
cTxt := cTxt + 'This text is placed in a WvtTextBox() control with '
cTxt := cTxt + 'font and alignment adjustments!'
cTxt := cTxt + CRLF + CRLF
cTxt := cTxt + 'Enjoy - Pritpal Bedi, INDIA'

aImg_:={}
aadd( aImg_, 'v_lock.bmp' )
aadd( aImg_, 'v_new.bmp' )
aadd( aImg_, 'v_clclt.bmp' )
aadd( aImg_, 'v_calend.bmp' )
aadd( aImg_, 'v_index.bmp' )
aadd( aImg_, 'v_notes1.bmp' )
aadd( aImg_, 'v_selct1.bmp' )

nWinRows := 55
nWinCols := 185
cWinTitle := 'WvtGui Dialog One'
cFont := 'Courier New'
nHeight := 13

oDlg := WvtDialog():New( nWinRows, nWinCols, cWinTitle, cFont, nHeight )
oDlg:nTooltipWidth := 300
oDlg:nTooltipTextColor := RGB( 255,0,0 )

oBar := WvtStatusBar():New( oDlg,201 )
oBar:SetPanels( { 50,100 } )
oBar:SetText( 1, 'Tab.SH_Tab.Left_Click - Select a Browse' )
oBar:SetText( 2, 'GtWvt is Fantastic', 'w+/W' )
oBar:SetText( 3, 'WOW' )
oBar:nPointer := WVT_IDC_HAND
oBar:Tooltip := 'GtWvt Statusbar with 3 panels'
oDlg:AddObject( oBar )

oBox := WvtStatic():New( oDlg,110,4,oDlg:MaxCol()-40,7,oDlg:MaxCol()-2 )
oBox:nStatic := WVT_STATIC_BOXRECESSED
oDlg:AddObject( oBox )

oText := WvtLabel():New( oDlg, 101, 4, oDlg:MaxCol()-40, 7,oDlg:MaxCol()-2 )
oText:Text := 'xHarbour'
oText:Height := 36
oText:AlignHorz := 2
oText:AlignVert := 2
oText:Weight := 700
oText:TextColor := RGB( 100, 255, 12 )
oText:BackColor := RGB( 0, 0, 255 )
oText:TextColorHoverOn := RGB( 255, 255, 0 )
oText:BackColorHoverOn := RGB( 255, 100, 12 )
oText:ToolTip := 'Software that GROWS with you'
oText:bOnSelect := {|o,v| .t. }
oText:Italic := .t.
oDlg:AddObject( oText )

oImg := WvtImage():New( oDlg,102,20,oDlg:MaxCol()-40,37,oDlg:MaxCol()-2 )
oImg:cImage := aImg_[ 5 ]
oImg:Tooltip := 'WvtImage():New()'
oDlg:AddObject( oImg )

oTBar := WvtToolbar():New( oDlg,103, 0,0,2 )
oTBar:lFloating := .f.
oTBar:Tooltip := 'Toolbar'
oTBar:AddButton( aImg_[ 1 ], {|| oImg:SetImage( aImg_[ 1 ] ) } , 'Lock' )
oTBar:AddButton( aImg_[ 2 ], {|| oImg:SetImage( aImg_[ 2 ] ), oText:SetText( 'xHarbour' ) } , 'New' )
oTBar:AddButton( aImg_[ 3 ], {|| oImg:SetImage( aImg_[ 3 ] ) } , 'Calculator' )
oTBar:AddButton()
oTBar:AddButton( aImg_[ 5 ], {|| oImg:SetImage( aImg_[ 5 ] ) } , 'Restore' )
oTBar:AddButton( aImg_[ 4 ], {|| oImg:SetImage( aImg_[ 4 ] ), oText:SetText( 'Vouch' ) } , 'Calendar' )
oTBar:AddButton( aImg_[ 6 ], {|| oImg:SetImage( aImg_[ 6 ] ) } , 'Notes' )
oTBar:AddButton( aImg_[ 7 ], {|| oImg:SetImage( aImg_[ 7 ] ) } , 'Press to Send Browse on Top' )
oTBar:AddButton()
oDlg:AddObject( oTBar )

oLine := WvtStatic():New( oDlg, 105, 39, 0, 39, oDlg:MaxCol() )
oLine:nStatic := WVT_STATIC_LINE
oDlg:AddObject( oLine )

oBBox := WvtStatic():New( oDlg,125,4,127,37,139 )
oBBox:nStatic := WVT_STATIC_BOXGROUP
oDlg:AddObject( oBBox )

oBtn := WvtPushButton():New(oDlg, 124, 6, 129, 7, 137 )
oBtn:cCaption := 'Print'
oBtn:bOnLeftUp := {|| Wvt_Keyboard( 379 ) }
oBtn:Tooltip := 'Open Printing Dialog for the Browser in Focus'
oDlg:AddObject( oBtn )

oBtn2 := WvtPushButton():New( oDlg, 124, 9, 129, 12, 137 )
oBtn2:cFileImage := aImg_[ 3 ]
oBtn2:block := {|| oCon:Say( 1,60,' This is Triggering Read ','w+/w' ),oGet:Read() }
oBtn2:Tooltip := 'This Push Button will trigger Gets at the right!'
oDlg:AddObject( oBtn2 )

oBBox2 := WvtStatic():New( oDlg, , 9, oDlg:MaxCol()-40, 18, oDlg:Maxcol()-2 )
oBBox2:nStatic := WVT_STATIC_BOXGROUP
oDlg:AddObject( oBBox2 )

oCon := WvtConsole():New( oDlg )
oDlg:AddObject( oCon )

nGetCol := 158
bBlock := {|| oCon:Say( 12, 148, 'Name' ,'N/W' ),;
oCon:Say( 14, 148, 'Date' ,'N/W' ),;
oCon:Say( 16, 148, 'Amount','N/W' ) }

oGet := WvtGets():New( oDlg, 210, 9, oDlg:Maxcol()-40, 18, oDlg:Maxcol()-2 )
oGet:AddGets( 12, nGetCol, 'GTWvt ', '@! ','W+/B*,N/W*' )
oGet:AddGets( 14, nGetCol, date() )
oGet:AddGets( 16, nGetCol, 2122.57, '@Z 99999999.99','w+/R,GR+/B' )
oGet:Tooltip := 'WvtGets():New() - ReadModal() like Clipper'
oGet:cDesc := 'Normal Get Box'
oGet:bOnCreate := bBlock
oDlg:AddObject( oGet )

oBnr := WvtBanner():New( oDlg, 101, 0, 127, 1,oDlg:MaxCol()-2 )
oBnr:nTimeDelay := 0.25
oBnr:cText := 'the compiler that EXTENDS with you'
oBnr:nFontHeight := 24
oBnr:nDirection := 0
oBnr:nAlignVert := 2
oBnr:nFontWeight := 0
oBnr:nTextColor := RGB( 253,251,170 )
oBnr:nBackColor := RGB( 128,227,142 )
oBnr:nTextColorHoverOn := RGB( 255,255,0 )
oBnr:nBackColorHoverOn := RGB( 255,100,12 )
oBnr:Tooltip := 'WvtBanner():New()'
oDlg:AddObject( oBnr )

oBRsd := WvtStatic():New( oDlg, , 41,127,52,oDlg:MaxCol()-2 )
oBRsd:nStatic := WVT_STATIC_BOXGROUPRAISED
oDlg:AddObject( oBRsd )

oRct := WvtStatic():New( oDlg, , 41,127,52,oDlg:MaxCol()-2 )
oRct:nStatic := WVT_STATIC_SHADEDRECT
oRct:aRGBb := { 0xffff, 0x0000, 0x0000, 0x0000 }
oRct:aRGBe := { 0x0000, 0xffff, 0xffff, 0x0000 }
oDlg:AddObject( oRct )

oTBx := WvtTextBox():New( oDlg, , 42,129,51,oDlg:MaxCol()-4 )
oTBx:cText := cTxt
oTBx:Tooltip := 'WvtTextBox():New()'
oTBx:nFontHeight := 16
oTBx:lItalic := .t.
oTBx:lUnderline := .t.
oTBx:nAlignHorz := 2
oTBx:nTextColor := RGB( 255,255,255 )
oTBx:nTextColorHoverOn := RGB( 0,0,255 )
oTBx:aPopup := {}
aadd( oTBx:aPopup, { 'Getsome' , {|| .t. } } )
aadd( oTBx:aPopup, { 'Getsome2', {|| .t. } } )
oDlg:AddObject( oTBx )

oGetArea := WvtStatic():New( oDlg, , 4, 2, 37, 62 )
oGetArea:nStatic := WVT_STATIC_BOXRAISED
oDlg:AddObject( oGetArea )

nGetCol := 20
nSayCol := 7
nGetRow := 7
bBlock1 := {|| oCon:Say( nGetRow+00, nSayCol, 'First Name' ,'N/W' ),;
oCon:Say( nGetRow+02, nSayCol, 'Last Name ' ,'N/W' ),;
oCon:Say( nGetRow+04, nSayCol, 'Street' ,'N/W' ),;
oCon:Say( nGetRow+06, nSayCol, 'City' ,'W+/W'),;
oCon:Say( nGetRow+08, nSayCol, 'State' ,'N/W' ),;
oCon:Say( nGetRow+10, nSayCol, 'Zip' ,'B+/W'),;
oCon:Say( nGetRow+12, nSayCol, 'Date Hired' ,'B+/W'),;
oCon:Say( nGetRow+14, nSayCol, 'Married' ,'B+/W'),;
oCon:Say( nGetRow+16, nSayCol, 'Age' ,'B+/W'),;
oCon:Say( nGetRow+18, nSayCol, 'Salary' ,'B+/W'),;
oCon:Say( nGetRow+20, nSayCol, 'Notes', ,'B+/W') ;
}

aGets_:= { pad('Pritpal',20 ), pad( 'Bedi',20 ), pad( '60, New Professor Colony',30 ), ;
pad( 'Ludhiana, INDIA',30 ),;
'PB', pad( '141004',10 ), ctod( '22/06/04' ), .t., 48, 17000, ;
pad( 'Wvtgui is a classical example of xHarbour capabilities...',65 ) }

oGet1 := WvtGets():New( oDlg, , 4, 2, 37, 62 )
oGet1:AddGets( nGetRow+00, nGetCol, aGets_[ 1 ], '@ ' , 'N/W*,N/GR*' )
oGet1:AddGets( nGetRow+02, nGetCol, aGets_[ 2 ], '@ ' , 'N/W*,N/GR*' )
oGet1:AddGets( nGetRow+04, nGetCol, aGets_[ 3 ], '@ ' , 'N/W*,N/GR*' )
oGet1:AddGets( nGetRow+06, nGetCol, aGets_[ 4 ], '@ ' , 'N/W*,N/GR*' )
oGet1:AddGets( nGetRow+08, nGetCol, aGets_[ 5 ], '@ ' , 'N/W*,N/GR*' )
oGet1:AddGets( nGetRow+10, nGetCol, aGets_[ 6 ], '@ ' , 'N/W*,N/GR*' )
oGet1:AddGets( nGetRow+12, nGetCol, aGets_[ 7 ], '@ ' , 'N/W*,N/GR*' )
oGet1:AddGets( nGetRow+14, nGetCol, aGets_[ 8 ], '@Y' , 'N/W*,N/GR*' )
oGet1:AddGets( nGetRow+16, nGetCol, aGets_[ 9 ], '@Z 99' , 'N/W*,N/GR*' )
oGet1:AddGets( nGetRow+18, nGetCol, aGets_[ 10], '@Z 999999', 'N/W*,N/GR*' )
oGet1:AddGets( nGetRow+20, nGetCol, aGets_[ 11], '@S35' , 'N/W*,N/GR*' )
oGet1:cDesc := 'Test.dbf Fields'
oGet1:Tooltip := 'Double Click to Activate ReadModal()'
oGet1:bOnCreate := bBlock1
oDlg:AddObject( oGet1 )


oMnu := WvtMenu():New():Create()
oMnu:Caption := 'Dialogs'
oMnu:AddItem( 'Dialog Two', {|| MyDialogTwo() } )

oDlg:oMenu := oMnu

lOpen := .f.
cUseAlias := 'TEST'
USE 'TEST' NEW ALIAS ( cUseAlias ) SHARED
if !NetErr()
lOpen := .t.
oWvtBrw := CfgMyBrowse( { 1,7,9,10,8 }, cUseAlias, { 6,67,36,120 }, 'Test.dbf - 1,7,9,10,8', oDlg, 'N/W*,N/GR*',1001 )
oDlg:AddObject( oWvtBrw )
endif

lOpen1 := .f.
cUseAlias1 := 'TEST1'
USE 'TEST' NEW ALIAS ( cUseAlias1 ) SHARED
if !NetErr()
lOpen1 := .t.
oWvtBrw1 := CfgMyBrowse( { 1,2,3,4,5,6 }, cUseAlias1, { 43,4,51,120 }, 'Test.dbf - 1,2,3,4,5,6',oDlg, 'N/BG*,N/W*',1002 )
oDlg:AddObject( oWvtBrw1 )
endif

oDlg:Create()
oDlg:Execute()
oDlg:Destroy()

if lOpen
Select( cUseAlias )
USE
endif
if lOpen1
Select( cUseAlias1 )
USE
endif

WvtSetBlocks( aObjects )
WvtSetKeys( .t. )
Wvt_SetPopupMenu( hPopup )
SetMouseCheck( lChkMouse )

RETURN Nil

//-------------------------------------------------------------------//


//-------------------------------------------------------------------//

STATIC FUNCTION CfgMyBrowse( aFields, cUseAlias, aTLBR, cDesc, oParent, cColorSpec, nID )
LOCAL info_, oWvtBrw, oBrowse, i, bBlock
LOCAL aPopup := {}

aadd( aPopup, { 'Down' , {|| oBrowse:Down() , oBrowse:ForceStable() } } )
aadd( aPopup, { 'Up' , {|| oBrowse:Up() , oBrowse:ForceStable() } } )
aadd( aPopup, { 'Page Down', {|| oBrowse:PageDown(), oBrowse:ForceStable() } } )
aadd( aPopup, { 'Page Up' , {|| oBrowse:PageUp() , oBrowse:ForceStable() } } )
aadd( aPopup, { 'Top' , {|| oBrowse:GoTop() , oBrowse:ForceStable() } } )
aadd( aPopup, { 'Bottom' , {|| oBrowse:GoBottom(), oBrowse:ForceStable() } } )

Select( cUseAlias )
info_:= DbStruct()

oBrowse := TBrowseNew( aTLBR[ 1 ], aTLBR[ 2 ], aTLBR[ 3 ], aTLBR[ 4 ] )

oBrowse:ColSep := ' '
oBrowse:HeadSep := '__'
oBrowse:ColorSpec := cColorSpec
oBrowse:GoTopBlock := { || dbGoTop() }
oBrowse:GoBottomBlock := { || dbGoBottom() }
oBrowse:SkipBlock := { | nSkip | dbSkipBlock( nSkip,oBrowse ) }

for i := 1 to len( aFields )
bBlock := VouBlockField( aFields[ i ] )
oBrowse:AddColumn( TBColumnNew( info_[ aFields[ i ],1 ], bBlock ) )
next

oBrowse:configure()

oWvtBrw := WvtBrowse():New( oParent,nID )

oWvtBrw:nTop := aTLBR[ 1 ]
oWvtBrw:nLeft := aTLBR[ 2 ]
oWvtBrw:nBottom := aTLBR[ 3 ]
oWvtBrw:nRight := aTLBR[ 4 ]
oWvtBrw:cAlias := cUseAlias
oWvtBrw:oBrw := oBrowse
oWvtBrw:cDesc := cDesc
oWvtBrw:nPointer := WVT_IDC_HAND
oWvtBrw:cColorHilite := 'W+/B*'
oWvtBrw:Tooltip := cDesc
oWvtBrw:aPopup := aPopup

oWvtBrw:bHandleEvent := {|oWvtBrw,cPaintID,oBrowse,nKey| BrwOnEvent( oWvtBrw,cPaintID,oBrowse,nKey ) }

RETURN oWvtBrw

//-------------------------------------------------------------------//

//-------------------------------------------------------------------//
STATIC FUNCTION rgb( r,g,b )

RETURN ( r + ( g * 256 ) + ( b * 256 * 256 ) )