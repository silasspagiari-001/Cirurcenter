**************
function IQVIA
**************

Local nBuffSize := 16                   // Read/write buffer size
Local l7143Supp := .F.                  // Is function 7143h supported?
local cRet := ""

msw("* * * AGUARDE... ABRINDO ARQUIVOS * * *")


NrAM = 9999999999999999
select AIND00
copy to CLIENV for VENIMS == "S"
select 0
inkey(1)
use CLIENV exclusive
go top
do while !eof()
  NrAM = randomize(NrAM)
  replace VENTEL with right(alltrim(str(randomize(NrAM),16)),7)
  skip
enddo
index on VENTEL to CLIENV

select 0
use ACLISP exclusive
index on NFSCLI tag 1 to ACLISP
set index to ACLISP
zap

select ANFS01
copy stru to APROD  // PRODUTOS
select 0
inkey(1)
use APROD exclusive
index on NFSMAT tag 1 to APROD
set index to APROD

@ 24, 00 clear

rodape("IQVIA","TRANSMISSAO",M_FAN,"","Mem: " + str(memory(0), 5),M_EMP)  

        store date()           to M_DATA1 ,;
                                  M_DATA2 

       sombra(14, 41, 16, 72,_SOMBRA_)

       set color to GR/W
         @ 14, 41 say                  "旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴커" 
         @ 15, 41 say                  "� Periodo:          a          �" 
         @ 16, 41 say                  "읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸" 
         @ 15, 52 get M_DATA1
         @ 15, 63 get M_DATA2
         read
       set color to

        if lastkey() = 27
          return ""
        endif

do while .t.
  M_OPC = msgbox3("Confirma Geracao da Remessa",,,"Escolha","Sim","Nao")

  if M_OPC = 3
    return ""
  endif

  if M_OPC = 2
    exit
  endif
enddo  

M_ARQ = "C:\CIRUR\IMS\C8660M" + strzero(month(M_DATA1),2) + ".D" + strzero(day(M_DATA1),2)
set print on
set printer to &M_ARQ
set console off

nSeq = 1

?? "108660" + pad(AEMP00->EMPNOM,30) + right(AEMP00->EMPCGC,14) +;
tira_bar4(M_DATA1) + ;
tira_bar4(M_DATA2) + ;
tira_bar4(date()) + ;
"1" + space(100) + space(171) + "imsbrcli1"

select ANFS00
set order to 2
dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)

do while !eof()

  if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
    exit
  endif

  ACLI00->(dbseek(str(ANFS00->NFSCLI,7)))

  if len(alltrim(ACLI00->CLICGC1)) > 11
    skip
    loop
  endif

  set color to I
    @ 24, 10 say NFSDTE 
    @ 24, col() + 5 say strzero(NFSNUM, 6, 0)
  set color to 

  select ANFS01

  dbseek(str(ANFS00->NFSEMP, 2) + str(ANFS00->NFSNUM, 6) + ANFS00->NFSSER, .t.)

  lTenvenda = .f.

  do while !eof()

    if !str(NFSEMP, 2) + str(NFSNUM, 6) + NFSSER == str(ANFS00->NFSEMP, 2) + str(ANFS00->NFSNUM, 6) + ANFS00->NFSSER
      exit
    endif

    APCA00->(dbseek(str(ANFS01->NFSMAT,6,0)))

    if !str(APCA00->PCAFOR,5) == str(410,5) // abbot
      skip
      loop
    endif

    lTenvenda = .t.

    select APROD 
    if !dbseek(ANFS01->NFSMAT)
      append blank
      replace NFSMAT with ANFS01->NFSMAT
    endif
    replace NFSQDE with NFSQDE + ANFS01->NFSQDE
    replace NFSVLI with NFSVLI + ANFS01->NFSLIQ

    select ANFS01
    skip
  enddo

  if lTenvenda 
    select ACLISP
    append blank
    replace NFSCLI with alltrim(str(CLIENV->VENCOD,7))
    replace NFSNUM with ANFS00->NFSNUM
    replace NFSSER with ANFS00->NFSSER
  endif

  select CLIENV
  skip

  if eof()
    go top
  endif

  select ANFS00
  skip
enddo

select ACUP00
set order to 2
dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)

do while !eof()

  if str(CUPEMP, 2, 0) + dtos(CUPDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
    exit
  endif

  if CUPCAN == "C"
    skip
    loop
  endif

  set color to I
    @ 24, 10 say CUPDTE 
    @ 24, col() + 5 say strzero(CUPNUM, 6, 0)
  set color to 

  select ACUP01

  dbseek(str(ACUP00->CUPEMP, 2) + str(ACUP00->CUPNUM, 6) + ACUP00->CUPSER, .t.)

  lTenvenda = .f.

  do while !eof()

    if !str(CUPEMP, 2) + str(CUPNUM, 6) + CUPSER == str(ACUP00->CUPEMP, 2) + str(ACUP00->CUPNUM, 6) + ACUP00->CUPSER
      exit
    endif

    APCA00->(dbseek(str(ACUP01->CUPMAT,6,0)))

    if !str(APCA00->PCAFOR,5) == str(410,5) // abbot
      skip
      loop
    endif

    lTenvenda = .t.

    select APROD 
    if !dbseek(ACUP01->CUPMAT)
      append blank
      replace NFSMAT with ACUP01->CUPMAT
    endif
    replace NFSQDE with NFSQDE + ACUP01->CUPQDE
    replace NFSVLI with NFSVLI + ACUP01->CUPLIQ

    select ACUP01
    skip
  enddo

  if lTenvenda 
    select ACLISP
    append blank
    replace NFSCLI with alltrim(str(CLIENV->VENCOD,7))
    replace CUPNUM with ACUP00->CUPNUM
    replace CUPSER with ACUP00->CUPSER
  endif

  select CLIENV
  skip

  if eof()
    go top
  endif

  select ACUP00
  skip
enddo


select ACLISP
index on NFSCLI to E1 unique
go top

do while !eof()

  select CLIENV
  locate for VENCOD = val(ACLISP->NFSCLI)

  ? "2" + ;
        strzero(VENCOD,14) + ; 
              strzero(0,14) +;  // strzero(val(VENCPF),14) +;
              "2" +; 
              pad(VENNOM,40)                  +;  
              pad(VENNOM,40)                  +;
              "1"                            +;  
              pad(VENEND,70) + space(20)     +;  
              strzero(VENCEP,5)              +;  
              strzero(VENCCE,3)              +;  
              pad(VENMUN,30)                 +;  
              VENEST                          +;  
              pad(VENTEL,20)                 +;
              pad("",20)                 +;
              tira_bar4(CTOD("01/01/2018")) + ;
              pad("",35) +;       // EMAIL
              pad("",25) +;   // SITE
              "     " +;
              "C" 
  nSeq ++

  select ACLISP
  skip

enddo

 ? "308660" +;
 strzero(nSeq+1,8) +;                  // SEQUENCIAL      POS 395 400 006
 space(200) + space(132) + "imsbrcli3"

set printer to
set print off


*********** P R O D U T O S *******************

M_ARQ = "C:\CIRUR\IMS\P8660M" + strzero(month(M_DATA1),2) + ".D" + strzero(day(M_DATA1),2)

set print on
set printer to &M_ARQ
set console off

nSeq = 1

?? "708660" + pad(AEMP00->EMPNOM,30) + right(AEMP00->EMPCGC,14) +;
tira_bar4(M_DATA1) + ;
tira_bar4(M_DATA2) + ;
tira_bar4(date()) + ;
"1" + space(118) + "imsbrpro7"

select ACLISP
set index to

select APROD
go top
do while !eof()

  APCA00->(dbseek(str(APROD->NFSMAT,6,0)))
  AFOR00->(dbseek(str(APCA00->PCAFOR,7,0)))
  ASLD00->(dbseek(str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0)))

  ? "8 0" + ;
        strzero(APCA00->PCAMAT,13) + ; 
              "0" + ;
              APCA00->PCABAR +;
              "1" +;
              pad(APCA00->PCADES,70) + space(08)     +;  
              pad(AFOR00->FORNOM,40)                 +;  
              strzero((ASLD00->SLDPRC*100),9) +;
              space(20) + space(15) + ;
              "01012015P"
  nSeq ++

  select APROD  

  skip

enddo

 ? "908660" +;
 strzero(nSeq+1,8) +;                  // SEQUENCIAL      POS 395 400 006
 space(179) + "imsbrpro9"

set printer to
set print off



******** VENDAS ***************

M_ARQ = "C:\CIRUR\IMS\V8660M" + strzero(month(M_DATA1),2) + ".D" + strzero(day(M_DATA1),2)

set print on
set printer to &M_ARQ
set console off

nSeq = 1

?? "408660" +;
tira_bar4(M_DATA1) + ;
tira_bar4(M_DATA2) + ;
tira_bar4(date()) + ;
"D   " + "imsbrven4"


select ANFS00
set order to 1
select ACUP00

set order to 1

select ACLISP
go top
nQdeTot =  0

do while !eof()

  if NFSNUM > 0
    select ANFS00
    dbseek(str(ME_EMP,2) + str(ACLISP->NFSNUM,6) + ACLISP->NFSSER)
    set color to I
      @ 24, 10 say NFSDTE 
      @ 24, col() + 5 say strzero(NFSNUM, 6, 0)
    set color to 

    select ANFS01

    dbseek(str(ANFS00->NFSEMP, 2) + str(ANFS00->NFSNUM, 6) + ANFS00->NFSSER, .t.)

    do while !eof()

      if !str(NFSEMP, 2) + str(NFSNUM, 6) + NFSSER == str(ANFS00->NFSEMP, 2) + str(ANFS00->NFSNUM, 6) + ANFS00->NFSSER
        exit
      endif

      APCA00->(dbseek(str(ANFS01->NFSMAT,6,0)))

      if !str(APCA00->PCAFOR,5) == str(410,5) // abbot
        skip
        loop
      endif

      select ANFS01

      ? "5" + strzero(day(ANFS00->NFSDTE),2) + ;
          strzero(val(ACLISP->NFSCLI),14) + "10" + ; 
          strzero(APCA00->PCAMAT,13) + "1N" + ;
          strzero(ANFS01->NFSQDE,8) + ;
              "V"
      nSeq ++
      nQdeTot += ANFS01->NFSQDE

      select ANFS01

      skip
    enddo
  else
    select ACUP00
    dbseek(str(ME_EMP,2) + str(ACLISP->CUPNUM,6) + ACLISP->CUPSER)
    set color to I
      @ 24, 10 say CUPDTE 
      @ 24, col() + 5 say strzero(CUPNUM, 6, 0)
    set color to 

    select ACUP01

    dbseek(str(ACUP00->CUPEMP, 2) + str(ACUP00->CUPNUM, 6) + ACUP00->CUPSER, .t.)

    do while !eof()

      if !str(CUPEMP, 2) + str(CUPNUM, 6) + CUPSER == str(ACUP00->CUPEMP, 2) + str(ACUP00->CUPNUM, 6) + ACUP00->CUPSER
        exit
      endif

      APCA00->(dbseek(str(ACUP01->CUPMAT,6,0)))

      if !str(APCA00->PCAFOR,5) == str(410,5) // abbot
        skip
        loop
      endif

      select ACUP01

      ? "5" + strzero(day(ACUP00->CUPDTE),2) + ;
        strzero(val(ACLISP->NFSCLI),14) + "10" + ; 
        strzero(APCA00->PCAMAT,13) + "1N" + ;
        strzero(ACUP01->CUPQDE,8) + ;
              "V"
      nSeq ++
      nQdeTot += ACUP01->CUPQDE

      select ACUP01

      skip
    enddo
  endif

  select ACLISP
  skip
  
enddo

 ? "608660" +;
 strzero(nSeq+1,8) +;                  // SEQUENCIAL      POS 395 400 006
 strzero(nQdeTot,10) + ;
 strzero(0,10) + ;
 "imsbrven6"

set printer to
set print off

set print on
set printer to "RELATO.RPT"
M_IMPRE = "A"

nqdetot =0
nvaltot = 0

select APROD
go top
do while !eof()

  APCA00->(dbseek(str(APROD->NFSMAT,6,0)))

  ? str(APCA00->PCAMAT,6)
  ??  " "  
  ?? pad(APCA00->PCADES,40)
  ?? " "
  ?? str(NFSQDE,5)
  ?? " "
  ?? transform(NFSVLI,"@R 999,999.99")

  nqdetot += NFSQDE
  nvaltot += NFSVLI

  select APROD  

  skip

enddo
?
  ? space(6)
  ??  " "  
  ?? space(40)
  ?? " "
  ?? str(nqdetot,5)
  ?? " "
  ?? transform(nvaltot,"@R 999,999.99")

?

set printer to
set print off
desliga()


fecha_arq()

return "" 
