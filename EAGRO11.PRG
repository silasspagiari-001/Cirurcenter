#include "HbLang.ch"
#include "Inkey.ch"
#include "GetExit.ch"

#define RDDI_CONNECT          1001
#define RDDI_DISCONNECT       1002

PROC RDDSYS()

RETURN


***************
function MANEMP
***************


parameters M_OPC,M_OPC1,M_OPC2
local aBlocks := {}
local aLastPaint

LOCAL oThisButton, nCont



_FUNMUN_ = "EMPRESA"

*aAdd( aBlocks, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )

      rodape("MENU","EMPRESA",M_FAN,"EAGRO11","Mem: " + str(memory(0), 5),M_EMP)

*        @ 05, 08 prompt "Inclus„o " HIGHLITE R/BG PERMITE 1,1,1
*        @ 06, 08 prompt "Altera‡„o" HIGHLITE R/BG PERMITE 1,1,2
*        @ 07, 08 prompt "Consulta " HIGHLITE R/BG PERMITE 1,1,3
*        @ 08, 08 prompt "Exclus„o " HIGHLITE R/BG PERMITE 1,1,4
*        @ 09, 08 prompt "Listagem " HIGHLITE R/BG PERMITE 1,1,5
*        @ 10, 08 prompt "Parametro" HIGHLITE R/BG PERMITE 1,1,6

      do case
         case M_OPC = 1 ; incemp()
         case M_OPC = 2 ; altemp()
         case M_OPC = 3 ; conemp()
         case M_OPC = 4 ; excemp()
         case M_OPC = 5 ; lisemp()
         case M_OPC = 6 ; paremp()
      endcase


return ""


FUNCTION IsPressed( nButton )
 IF GetActive():control:buffer
 ReadKill( .T. )
 ELSE
 nButton := 0
 ENDIF
 RETURN nButton
 
 
 FUNCTION RecChanged()
 LOCAL oGet := GetActive()
 LOCAL oTBrowse := oGet:control
 LOCAL nButton := 0
 IF oGet:exitState == GE_ENTER
 IF oTBrowse:cargo <> Recno()
 ReadKill( .T. )
 nButton := 2
 ENDIF
 ELSE
 DbGoto( oTBrowse:cargo )
 oTBrowse:refreshAll()
 oTBrowse:forceStable()
 ENDIF
 RETURN nButton
 
***************
function INCEMP
***************

//SALDOEXCEL()

*   seexiste("AVEN00")
*   cSQl := "SELECT * FROM AVEN00"
*   dbusearea(.T.,"SQLMIX",cSQL,"AVEN00")
*   select AVEN00
*   BROWSE()

*   select AVEN00
*   use
   
*TESTEWVT()

*CONTRATO()

*        abre_pch("0")
*CRIADBFTOSQL(alias(),.T.)  // IMPORTADO

*prodiet()

*acertache()

*ACERTANESTLE()

/*
LOCAL aRadio1[3], aRadio2[4]
 LOCAL nSpeed, cPages
 LOCAL cColor1 := "W/B,W+/B,R/W+"
 LOCAL cColor2 := "N/BG,N/BG,GR+/BG,GR+/BG,N/BG,W+/BG,GR+/BG"
 SET EVENTMASK TO INKEY_ALL
 SET COLOR TO N/BG
 CLS
 nSpeed := 1 //default to the first item.
 aRadio1[ 1 ] := HbRadioButton():new( 4, 22, "&slow" )
 aRadio1[ 2 ] := HbRadioButton():new( 5, 22, "&medium" )
 aRadio1[ 3 ] := HbRadioButton():new( 6, 22, "&fast" )
 AEval( aRadio1, {|o| o:colorSpec := cColor2 } )
 cPages := "all"
 aRadio2[ 1 ] := HbRadioButton():new( 10, 22, "&first page", "this" )
 aRadio2[ 2 ] := HbRadioButton():new( 11, 22, "&this page" , "first")
 aRadio2[ 3 ] := HbRadioButton():new( 12, 22, "&last page" , "last" )
 aRadio2[ 4 ] := HbRadioButton():new( 13, 22, "&all pages" , "all" )
 AEval( aRadio2, {|o| o:colorSpec := cColor2 } )
 @ 3, 20, 7, 40 GET nSpeed ;
 RADIOGROUP aRadio1 ;
 CAPTION "&Speed" ;
 COLOR cColor1
 @ 9, 20, 14, 40 GET cPages ;
 RADIOGROUP aRadio2 ;
 CAPTION "&Pages" ;
 COLOR cColor1
 READ

*/
 
/*
 LOCAL cLName, cFName, cPhone
 LOCAL lBtn1 := .F.
 LOCAL lBtn2 := .F.
 LOCAL lBtn3 := .F.
 LOCAL nBtn := 0
 LOCAL dummy := 1
 LOCAL cGetClr := "W+/B,W+/R,N/BG,GR+/BG"
 LOCAL cBtnClr := "N/G,W+/G,GR+/N,GR+/G"
 LOCAL oTBrowse, aCOlumns[3], bSkip, bSaved

 SET EVENTMASK TO INKEY_ALL
 SET COLOR TO N/BG
 CLS

 USE Customer ALIAS Cust
 oTBrowse := TBrowseDb( 8, 50, 14, 72 )
 oTBrowse:colorSPec := cGetClr
 oTBrowse:headSep := "-"
 oTBrowse:cargo := Recno()
 aColumns[1] := TBColumnNew( "Last" , {|| CUst->Last } )
 aColumns[2] := TBColumnNew( "First", {|| CUst->First } )
 aColumns[3] := TBColumnNew( "Phone", {|| CUst->City } )
 AEval( aCOlumns, {|o| oTBrowse:addColumn(o) } )

 cFName := Cust->First
 cLName := Cust->Last
 cPhone := Cust->City
 @ 8, 20 GET cFName ;
 CAPTION "&First name:" ;
 COLOR cGetClr
 @ 10, 20 GET cLName ;
 CAPTION " &Last name:" ;
 COLOR cGetClr
 @ 12, 20 GET cPhone ;
 CAPTION " &Phone:" ;
 COLOR cGetClr
 @ 8, 50, 14, 72 GET dummy ;
 TBROWSE oTBrowse ;
 GUISEND forceStable() ;
 VALID {|| nBtn := RecChanged( oTBrowse ), .T. }
 @ 16, 20 GET lBtn1 PUSHBUTTON ;
 CAPTION " &Save " ;
 COLOR cBtnClr ;
 STATE {|| nBtn := IsPressed( 1 ) }
 @ 16, 30 GET lBtn2 PUSHBUTTON ;
 CAPTION " &Undo " ;
 COLOR cBtnClr ;
 STATE {|| nBtn := IsPressed( 2 ) }
 @ 16, 40 GET lBtn3 PUSHBUTTON ;
 CAPTION " E&xit " ;
 COLOR cBtnClr ;
 STATE {|| nBtn := IsPressed( 3 ) }
 DO WHILE nBtn == 0
 READ SAVE




 DO CASE
 CASE nBtn == 1
 IF RLock()
 REPLACE Cust->First WITH cFName
 REPLACE Cust->Last WITH cLName
 REPLACE Cust->City WITH cPhone
 DbCommit()
 DbUnlock()
 ENDIF
 CASE nBtn == 2
 cFName := Cust->First
 cLName := Cust->Last
 cPhone := Cust->City
 nBtn := 0
 AEval( GetList, {|oGet| oGet:display() } )
 CASE nBtn == 3
 nBtn := 0
 ENDCASE
 ENDDO
 ASize( GetList, 0 )
 CLOSE ALL
 RETURN
 
/*
LOCAL aRadio1[3], aRadio2[4]
 LOCAL nSpeed, cPages
 LOCAL cColor1 := "W/B,W+/B,R/W+"
 LOCAL cColor2 := "N/BG,N/BG,GR+/BG,GR+/BG,N/BG,W+/BG,GR+/BG"
 SET EVENTMASK TO INKEY_ALL
 SET COLOR TO N/BG
 CLS
 nSpeed := 1 //default to the first item.
 aRadio1[ 1 ] := HbRadioButton():new( 4, 22, "&slow" )
 aRadio1[ 2 ] := HbRadioButton():new( 5, 22, "&medium" )
 aRadio1[ 3 ] := HbRadioButton():new( 6, 22, "&fast" )
 AEval( aRadio1, {|o| o:colorSpec := cColor2 } )
 cPages := "all"
 aRadio2[ 1 ] := HbRadioButton():new( 10, 22, "&first page", "this" )
 aRadio2[ 2 ] := HbRadioButton():new( 11, 22, "&this page" , "first")
 aRadio2[ 3 ] := HbRadioButton():new( 12, 22, "&last page" , "last" )
 aRadio2[ 4 ] := HbRadioButton():new( 13, 22, "&all pages" , "all" )
 AEval( aRadio2, {|o| o:colorSpec := cColor2 } )
 @ 3, 20, 7, 40 GET nSpeed ;
 RADIOGROUP aRadio1 ;
 CAPTION "&Speed" ;
 COLOR cColor1
 @ 9, 20, 14, 40 GET cPages ;
 RADIOGROUP aRadio2 ;
 CAPTION "&Pages" ;
 COLOR cColor1
 READ
 ? nSpeed, cPages
 RETURN
/*

/*
LOCAL cLName, cFName
 LOCAL lBtn1 := .F.
 LOCAL lBtn2 := .F.
 LOCAL lBtn3 := .F.
 LOCAL nBtn := 0
 LOCAL cGetClr := "W+/B,W+/R,N/BG,GR+/BG"
 LOCAL cBtnClr := "N/G,W+/G,GR+/N,GR+/G"
 SET EVENTMASK TO INKEY_ALL
 SET COLOR TO N/BG
 CLS
 cFName := "Cust->FirstName"
 cLName := "Cust->LastName"
 @ 8, 20 GET cFName ;
 CAPTION "&First name:" ;
 COLOR cGetClr
 @ 10, 20 GET cLName ;
 CAPTION " &Last name:" ;
 COLOR cGetClr
 @ 12, 20 GET lBtn1 PUSHBUTTON ;
 CAPTION " &Save " ;
 COLOR cBtnClr ;
 STATE {|| nBtn := IsPressed( 1 ) }
 @ 12, 30 GET lBtn2 PUSHBUTTON ;
 CAPTION " &Undo " ;
 COLOR cBtnClr ;
 STATE {|| nBtn := IsPressed( 2 ) }
 @ 12, 40 GET lBtn3 PUSHBUTTON ;
 CAPTION " E&xit " ;
 COLOR cBtnClr ;
 STATE {|| nBtn := IsPressed( 3 ) }
 DO WHILE .T.
 READ SAVE
 DO CASE
 CASE nBtn == 1
 IF RLock()
 REPLACE Cust->FirstName WITH cFName
 REPLACE Cust->LastName WITH cLName
 DbUnlock()
 EXIT
 ELSE
 Alert( "Unable to save;Retry again later" )
 ENDIF
 CASE nBtn == 2
 cFName := Cust->FirstName
 cLName := Cust->LastName
 nBtn := 0
 AEval( GetList, {|oGet| oGet:display() } )
 CASE nBtn == 3
 EXIT
 ENDCASE
 ENDDO
 ASize( GetList, 0 )
 CLOSE ALL
 RETURN
/*


/*
LOCAL aDays[7]
 LOCAL aHours[24]
 LOCAL cDay := "", nHour := 1
 LOCAL cColor := "N/BG,W+/BG,W+/BG,W+/R,GR+/BG,N/BG,GR+/BG,N/R"
 FOR i:=1 TO 7
 aDays[i] := HB_LangMessage( HB_LANG_ITEM_BASE_DAY + i-1 )
 NEXT
 FOR i:=1 TO 24
 aHours[i] := Padl( i-1, 2, "0" ) + ":00"
 NEXT
 SET EVENTMASK TO INKEY_ALL
 SET COLOR TO ( cColor )
 CLS

 @ 3, 15, 7, 25 GET cDay LISTBOX aDays CAPTION "Select &day " COLOR cColor
 @ 10, 15, 20, 25 GET nHour LISTBOX aHours CAPTION "Select &hour" COLOR cColor DROPDOWN SCROLLBAR
 READ

*/

*calculator()

*TesteSombra()
*MouseGet()
* VLTBrow()
*clear
*for a = 1 to 250
*  ?? chr(a)
*next
*inkey(0)

*WVT_GetOpenFileName(1,"C:\CIRURSQL\MENUAGRO.PRG","TITULO",

    do while .t.

      M_EMPCOD  = 0
      M_EMPFAN  = space(15)
      M_EMPNOM  = space(40)
      M_EMPEND  = space(40)
      M_EMPNRO  = space(05) // N£mero (Endere‡o)
      M_EMPCPE  = space(10) // Complemento do endere‡o
      M_EMPBAI  = space(20)
      M_EMPCEP  = 0
      M_EMPCCE  = 0
      M_EMPCDM  = 0
      M_EMPMUN  = space(20)
      M_EMPEST  = space(2)
      M_EMPTEL  = space(15)
      M_EMPTEX  = space(15)
      M_EMPFAX  = space(15)
      M_EMPJUN  = space(15)
      M_EMPCGC  = space(15)
      M_EMPIES  = space(15)
      M_EMPSEN  = "N"

      tlemp01()

      rodape("INCLUI","EMPRESA",M_FAN,"EAGRO11","Mem: " + str(memory(0), 5),M_EMP) 

      SetColor(_COREDICAO_)
      @ 08, 25 get     M_EMPCOD   picture "##"
      read

*      READMODAL()
      
      if M_EMPCOD = 0
        exit
      endif

      select AEMP00

  if BUSCAREGISTRO("AEMP00",1,{str(M_EMPCOD,2,0)},"SELECT")
    msg("* * * EMPRESA JA CADASTRADA * * *")
    loop
  endif

      edemp01()                      && edita dados da empresa 
      gremp01("INSERT")                      && grava dados da empresa

      msg("* * * EMPRESA INCLUIDA * * *")

    enddo

return ""

***************
function ALTEMP
***************
        
    do while .t.

      tlemp01() 

      rodape("ALTERA","EMPRESA",M_FAN,"EAGRO11","Mem: " + str(memory(0), 5),M_EMP) 

      M_EMPCOD = 0

      SetColor(_COREDICAO_)
      @ 08, 25 get     M_EMPCOD   picture "##"
      read

      if M_EMPCOD = 0
        exit
      endif

      if !BUSCAREGISTRO("AEMP00",1,{str(M_EMPCOD,2,0)},"SELECT")
        msg("* * * EMPRESA N?O CADASTRADA * * *")
        loop
      endif

      msemp01()                      && mostra dados da empresa

      M_EMPFAN  =  EMPFAN
      M_EMPNOM  =  EMPNOM
      M_EMPEND  =  EMPEND
      M_EMPNRO  =  EMPNRO
      M_EMPCPE  =  EMPCPE    
      M_EMPBAI  =  EMPBAI
      M_EMPCEP  =  EMPCEP
      M_EMPCCE  =  EMPCCE
      M_EMPCDM  =  EMPCDM
      M_EMPMUN  =  EMPMUN
      M_EMPEST  =  EMPEST
      M_EMPTEL  =  EMPTEL
      M_EMPTEX  =  EMPTEX
      M_EMPFAX  =  EMPFAX
      M_EMPJUN  =  EMPJUN 
      M_EMPCGC  =  EMPCGC 
      M_EMPIES  =  EMPIES
      M_EMPSEN  =  EMPSEN 

      edemp01() 

      if lastkey() = 27
        msg("* * * EMPRESA NŽO ALTERADA * * *")
        loop
      endif

      gremp01("UPDATE")                      && grava dados da empresa

      msg("* * * EMPRESA ALTERADA * * *")

    enddo

return ""

***************
function CONEMP
***************
        
    do while .t.

      tlemp01() 

      rodape("CONSULTA","EMPRESA",M_FAN,"EAGRO11","Mem: " + str(memory(0), 5),M_EMP) 

      M_EMPCOD = 0

      SetColor(_COREDICAO_)
      @ 08, 25 get     M_EMPCOD   picture "##"
      read

      if M_EMPCOD = 0
         exit
      endif

      BUSCAREGISTRO("AEMP00",1,{str(M_EMPCOD,2,0)},"SELECT")

      nEMPCOD = EMPCOD

      do while .t.

        msemp01()

        waitstate()

        if lastkey() = 5 .or. lastkey() = 19
         seexiste("AEMP00")
         cSQl := "SELECT * FROM AEMP00 WHERE EMPCOD = (SELECT max(EMPCOD) FROM AEMP00 WHERE EMPCOD < " + str(nEMPCOD, 2, 0) + ") and EMPCOD <> 0"
         dbusearea(.T.,"SQLMIX",cSQL,"AEMP00")
         if bof()
           seexiste("AEMP00")
           nEMPCOD = 999
           cSQl := "SELECT * FROM AEMP00 WHERE EMPCOD = (SELECT max(EMPCOD) FROM AEMP00 WHERE EMPCOD < " + str(nEMPCOD, 3, 0) + ") and EMPCOD <> 0"
           dbusearea(.T.,"SQLMIX",cSQL,"AEMP00")
         endif
        endif

        if lastkey() = 24 .or. lastkey() = 4
         seexiste("AEMP00")
         cSQl := "SELECT * FROM AEMP00 WHERE EMPCOD = (SELECT min(EMPCOD) FROM AEMP00 WHERE EMPCOD > " + str(nEMPCOD, 2, 0) + ") and EMPCOD <> 0"
         dbusearea(.t.,"SQLMIX",cSQL,"AEMP00")
         if eof()
           seexiste("AEMP00")
           nEMPCOD = 0
           cSQl := "SELECT * FROM AEMP00 WHERE EMPCOD = (SELECT min(EMPCOD) FROM AEMP00 WHERE EMPCOD > " + str(nEMPCOD, 2, 0) + ") and EMPCOD <> 0"
           dbusearea(.t.,"SQLMIX",cSQL,"AEMP00")
         endif
        endif

        nEMPCOD = EMPCOD

        if may_inkey(,.t.) = 27
         exit
        endif

       enddo

    enddo

return ""

***************
function EXCEMP
***************
        
private M_OPC
             
    do while .t.

      tlemp01() 
 
      rodape("EXCLUI","EMPRESA",M_FAN,"EAGRO11","Mem: " + str(memory(0), 5),M_EMP) 

        M_EMPCOD = 0
        SetColor(_COREDICAO_)
        @ 08, 25 get     M_EMPCOD   picture "##"
        read

        if M_EMPCOD = 0
          exit
        endif

        if !BUSCAREGISTRO("AEMP00",1,{str(M_EMPCOD,2,0)},"SELECT")
          msg("* * * EMPRESA N?O CADASTRADA * * *")
          loop
        endif

        msemp01()

        M_OPC = MsgBox2( "Confirma Exclus?o desta Empresa",,17,,,2 )

        if M_OPC != 1
          msg("* * * EMPRESA N?O EXCLUIDA * * *")
          loop
        endif

        if may_inkey(,.t.) = 27
          msg("* * * EMPRESA N?O EXCLUIDA * * *")
          loop
        endif

        gremp01("DELETE")

        msg("* * * EMPRESA EXCLUIDA * * *")

    enddo

return ""

***************
function LISEMP
*************** 

private M_EMPINI  ,;
        M_EMPFIN  ,; 
        LN      ,;
        PG      ,;
        M_ESC   ,;
        M_TELA
 
    do while .t.

      rodape("LISTA","EMPRESA",M_FAN,"EAGRO11","Mem: " + str(memory(0), 5),M_EMP) 

      store 0        to M_EMPINI,M_EMPFIN

      sombra(09, 12, 12, 33,_SOMBRA_)

      set color to GR+/W+
        @ 09, 13 say "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
        @ 10, 13 say "³Empresa Inicial:   ³" 
        @ 11, 13 say "³          Final:   ³" 
        @ 12, 13 say "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
      set color to 

      SetColor(_COREDICAO_)
      @ 10, 31 get M_EMPINI picture "##"
      @ 11, 31 get M_EMPFIN picture "##"   
      read

      if lastkey() = 27
        return ""
      endif

      M_EMPINI = iif(M_EMPINI = 0, 1,M_EMPINI)
      M_EMPFIN = iif(M_EMPFIN = 0,99,M_EMPFIN) 

      select AEMP00

      dbseek(str(M_EMPINI, 2, 0),.t.)

      if EMPCOD > M_EMPFIN
        msg("* * * NADA A LISTAR NO INTERVALO * * *")
        loop
      endif

      M_IMPRE = impresn()

      if M_IMPRE = "N"
        return ""
      endif

      ?? chr(15)                        && comprime

      select AEMP00

      store 0 to PG

      do while !eof()

        store PG + 1 to PG

        if PG > 1
            eject
        endif

        ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE EMPRESAS","EAGRO11",132) 
        ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
        ? "*--*-------------------*---------------*-------------------------------------- -*-------------------------------------*---------*--*"
        ? "*CD* CGC (MF)          * IES           * NOME                                   * ENDERECO                            * CEP     *UF*"
        ? "*--*-------------------*---------------*----------------------------------------*-------------------------------------*---------*--*"
*           99 999.999.999/9999-99 999999999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99999 999 XX

        store 5 to LN

        do while !eof() .and. LN < 60

          if  EMPCOD > M_EMPFIN
            go bottom
            skip
            loop
          endif 

          ? " "
            ?? str(EMPCOD, 2, 0)
            ?? " "
            ?? transform(EMPCGC,"@R 999.999.999/9999-99")
            ?? " "
            ?? EMPIES
            ?? " "
            ?? EMPNOM
            ?? " "
            ?? left(EMPEND, 37)
            ?? " "
            ?? str(EMPCEP, 5, 0)
            ?? " "
            ?? strzero(EMPCCE, 3, 0)
            ?? " "
            ?? EMPEST
  
            store LN + 1 to LN

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

      enddo

    ? replicate("-", 132)

    eject
 
desliga()

enddo 

return "" 

***************
function PAREMP
*************** 

rodape("PARAMETRO","EMPRESA",M_FAN,"EAGRO11","Mem: " + str(memory(0), 5),M_EMP) 

  sombra(07, 18, 20, 61,_SOMBRA_)

  set color to I
   @ 07, 18 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ 08, 18 say     "³Regime Tributario:    Destaca ICMS NFe:   ³"
   @ 09, 18 say     "³Impressora:                               ³"
   @ 10, 18 say     "³Ultima NFS:           Cliente  :          ³"
   @ 11, 18 say     "³Pedido VEN:           Produto  :          ³"
   @ 12, 18 say     "³Pedido CPA:           Cta Pagar:          ³"
   @ 13, 18 say     "³Fornecedor:           S e n h a:          ³"
   @ 14, 18 say     "³Mes Ativo :           Impressao:          ³"
   @ 15, 18 say     "³Requisicao:           Protecao :          ³"
   @ 16, 18 say     "³Pre-Venda :           Boleto   :          ³"
   @ 17, 18 say     "³Saldo Cx. :                               ³"
   @ 18, 18 say     "³Coo Cupom :           SerialECF:          ³"
   @ 19, 18 say     "³Ccf Cupom :                               ³"
   @ 20, 18 say     "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
  set color to

  BUSCAREGISTRO("AEMP00",1,{str(ME_EMP,2,0)},"SELECT")

  select AEMP00

  M_EMPNFS = EMPNFS
  M_EMPSER = iif(empty(EMPSER),"UN",EMPSER)
  M_EMPPED = EMPPED
  M_EMPPSE = iif(empty(EMPPSE),"PE",EMPPSE)

  M_EMPDOL = EMPDOL
  M_EMPPRT = EMPPRT
  
  M_EMPCLI = EMPCLI
  M_EMPFOR = EMPFOR
  M_EMPSEV = EMPSEV
  M_EMPDCP = EMPDCP
  M_EMPPRO = EMPPRO
  M_EMPSEN = EMPSEN
  M_EMPREQ = EMPREQ
  M_EMPRES = EMPRES
  M_EMPCPA = EMPCPA
  M_EMPCSE = EMPCSE
  M_EMPIND = EMPIND
  M_EMPBOL = EMPBOL
  M_EMPCAI = EMPCAI

  M_EMPORC = EMPORC
  M_EMPOSE = EMPOSE
  M_EMPECF = left(EMPECF,1)
  M_EMPCUP = EMPCUP  // Coo
  M_EMPNCU = EMPNCU  // Ccf
  M_EMPCFE = EMPCFE

  M_EMPHS1 = EMPHS1
  M_EMPHS2 = EMPHS2
  M_EMPHS3 = EMPHS3
  M_EMPHS4 = EMPHS4
  M_EMPHS5 = pad(EMPHS5,9)

  SetColor(_COREDICAO_)
  @ 08, 38 get M_EMPCFE picture "9" valid verregime(@M_EMPCFE)
  @ 08, 59 get M_EMPECF picture "@!" valid(M_EMPECF $ "SN")

  @ 09, 31 get M_EMPHS5 picture "@!" valid alltrim(M_EMPHS5) $ "#LASER#MATRICIAL#"

  @ 10, 31 get M_EMPNFS picture "######"
  @ 10, 38 get M_EMPSER picture "@!"

  @ 11, 31 get M_EMPPED picture "######"
  @ 11, 38 get M_EMPPSE picture "@!"

  @ 12, 31 get M_EMPCPA picture "######"
  @ 12, 38 get M_EMPCSE picture "@!"

  @ 13, 31 get M_EMPFOR picture "#######"

  @ 15, 31 get M_EMPREQ picture "######"
  @ 15, 38 get M_EMPRES picture "@!"

  @ 16, 31 get M_EMPORC picture "######"
  @ 16, 38 get M_EMPOSE picture "@!"

  @ 17, 31 get M_EMPCAI picture "9999999.99"

  @ 10, 52 get M_EMPCLI picture "#######"
  @ 11, 52 get M_EMPPRO picture "######"
  @ 12, 52 get M_EMPDCP picture "######"

  @ 13, 52 get M_EMPSEN picture "@!" valid(M_EMPSEN="S" .or. M_EMPSEN="N")

  @ 15, 52 get M_EMPPRT picture "@R 99:99" valid val(right(M_EMPPRT,2)) < 60
  @ 16, 52 get M_EMPBOL picture "#######"

  @ 18, 31 get M_EMPCUP picture "######"
  @ 18, 38 get M_EMPCFE picture "@!"
  @ 18, 52 get M_EMPECF picture "@!" valid(M_EMPECF $ "COM1#COM2#COM3")
  @ 19, 31 get M_EMPNCU picture "######"  
  read

  if lastkey() = 27
    msg("* * * PARAMETRO NŽO ALTERADO * * *")
    return ""
  endif

  set color to GR+/R
   @ 11, 22 say     "ÚÄÄÄÄÄÄÄÄÄMensagem no Cupom FiscalÄÄÄÄÄÄÄ¿"
   @ 12, 22 say     "³                                        ³"
   @ 13, 22 say     "³                                        ³"
   @ 14, 22 say     "³                                        ³"
   @ 15, 22 say     "³                                        ³"
   @ 16, 22 say     "³                                        ³"
   @ 17, 22 say     "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
  set color to

  SetColor(_COREDICAO_)
  @ 12, 23 get M_EMPHS1
  @ 13, 23 get M_EMPHS2
  @ 14, 23 get M_EMPHS3
  @ 15, 23 get M_EMPHS4
*  @ 16, 23 get M_EMPHS5
  read

sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {"AEMP00","UPDATE"}
aadd(sqlCHAVE,{"EMPCOD",str(ME_EMP,2)})
aadd(sqlCAMPO,{"EMPREQ",str(M_EMPREQ,6),.t.})
aadd(sqlCAMPO,{"EMPRES",M_EMPRES,.t.})
aadd(sqlCAMPO,{"EMPBOL",str(M_EMPBOL,6),.t.})
aadd(sqlCAMPO,{"EMPCUP",str(M_EMPCUP,6),.t.})
aadd(sqlCAMPO,{"EMPNCU",str(M_EMPNCU,6),.t.})

aadd(sqlCAMPO,{"EMPORC",str(M_EMPORC,6),.t.})
aadd(sqlCAMPO,{"EMPOSE",M_EMPOSE,.t.})
aadd(sqlCAMPO,{"EMPCFE",M_EMPCFE,.t.})
aadd(sqlCAMPO,{"EMPECF",M_EMPECF,.t.})

aadd(sqlCAMPO,{"EMPNFS",str(M_EMPNFS,6),.t.})
aadd(sqlCAMPO,{"EMPSER",M_EMPSER,.t.})
aadd(sqlCAMPO,{"EMPPED",str(M_EMPPED,6),.t.})
aadd(sqlCAMPO,{"EMPPSE",M_EMPPSE,.t.})
aadd(sqlCAMPO,{"EMPCLI",str(M_EMPCLI,6),.t.})
aadd(sqlCAMPO,{"EMPFOR",str(M_EMPFOR,6),.t.})
aadd(sqlCAMPO,{"EMPPRO",str(M_EMPPRO,6),.t.})
aadd(sqlCAMPO,{"EMPSEN",M_EMPSEN,.t.})
aadd(sqlCAMPO,{"EMPCPA",str(M_EMPCPA,6),.t.})
aadd(sqlCAMPO,{"EMPDCP",str(M_EMPDCP,6),.t.})
aadd(sqlCAMPO,{"EMPPRT",M_EMPPRT,.t.})
aadd(sqlCAMPO,{"EMPCSE",M_EMPCSE,.t.})
aadd(sqlCAMPO,{"EMPDOL",str(M_EMPDOL,1),.t.})
aadd(sqlCAMPO,{"EMPSEV",str(M_EMPSEV,6),.t.})
aadd(sqlCAMPO,{"EMPCAI",str1(M_EMPCAI,2),.t.})
aadd(sqlCAMPO,{"EMPHS1",M_EMPHS1,.t.})
aadd(sqlCAMPO,{"EMPHS2",M_EMPHS2,.t.})
aadd(sqlCAMPO,{"EMPHS3",M_EMPHS3,.t.})
aadd(sqlCAMPO,{"EMPHS4",M_EMPHS4,.t.})
aadd(sqlCAMPO,{"EMPHS5",M_EMPHS5,.t.})
executasql()

msg("* * * PARAMETRO ALTERADO * * *")

return ""

****************
function TLEMP01
****************

  nbox(7, 13, 17, 66,"W/W+",.T.)
  setcolor("B/W")
    @ 08, 13 say     " Codigo  :                Fantasia:                 "
    @ 09, 13 say     " Nome    :                                          "
    @ 10, 13 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    @ 11, 13 say     " Endereco:                                          "
    @ 12, 13 say     " Bairro  :                           Cep:           "
    @ 13, 13 say     " Cidade  :                                   Uf:    "
    @ 14, 13 say     " Telefone:                     CAE:                 "
    @ 15, 13 say     " Fax     :                   Junta:                 "
    @ 16, 13 say     " CNPJ(MF):                     IES:                 "
*    @ 17, 13 say     " Endereco Nota Fiscal S/N ........:                 "
  set color to

return ""

****************
function EDEMP01
****************

  SetColor(_COREDICAO_)
  @ 08, 50 get     M_EMPFAN picture "@!"
  @ 09, 25 get     M_EMPNOM picture "@!"
  @ 11, 25 get     M_EMPEND picture "@!" valid diginro("EMP")
  @ 12, 25 get     M_EMPBAI picture "@!"
  @ 12, 56 get     M_EMPCEP picture "#####"
  @ 12, 62 get     M_EMPCCE picture "###"
  @ 13, 25 get     M_EMPCDM picture "#######"   valid veremp02()
  @ 14, 25 get     M_EMPTEL picture "@!"
  @ 14, 50 get     M_EMPTEX picture "@!"
  @ 15, 25 get     M_EMPFAX picture "@!"
  @ 15, 50 get     M_EMPJUN picture "@!"
  @ 16, 25 get     M_EMPCGC picture "@R 999.999.999/9999-99"
  @ 16, 50 get     M_EMPIES picture "@!"
  read

return ""

****************
function MSEMP01
****************

  setcolor("N/W*")
    @ 08, 25 say     EMPCOD picture "##"
    @ 08, 50 say     EMPFAN picture "@!"    
    @ 09, 25 say     EMPNOM picture "@!"    
    @ 11, 25 say     EMPEND picture "@!"    
    @ 12, 25 say     EMPBAI picture "@!"    
    @ 12, 56 say     EMPCEP picture "#####"
    @ 12, 62 say     EMPCCE picture "###"
    @ 13, 25 say     EMPCDM picture "#######"
    @ 13, 33 say     EMPMUN picture "@!@S25"
    @ 13, 63 say     EMPEST picture "@!"
    @ 14, 25 say     EMPTEL picture "@!"               
    @ 14, 50 say     EMPTEX picture "@!"               
    @ 15, 25 say     EMPFAX picture "@!"               
    @ 15, 50 say     EMPJUN picture "@!"                        
    @ 16, 25 say     EMPCGC picture "@R 999.999.999/9999-99"    
    @ 16, 50 say     EMPIES picture "@!"                        
 set color to
  
return ""

****************
function GREMP01(cAcao)                       && grava dados da empresa
****************

sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {"AEMP00",cACAO}

aadd(sqlCHAVE,{"EMPCOD",str(M_EMPCOD,2)})

if !cACAO == "DELETE"
   aadd(sqlCAMPO,{"EMPCOD",str(M_EMPCOD,2),.t.})
   aadd(sqlCAMPO,{"EMPCEP",str(M_EMPCEP,5),.t.})
   aadd(sqlCAMPO,{"EMPCCE",str(M_EMPCCE,3),.t.})
   aadd(sqlCAMPO,{"EMPCDM",str(M_EMPCDM,7),.t.})

   aadd(sqlCAMPO,{"EMPFAN",M_EMPFAN,.t.})
   aadd(sqlCAMPO,{"EMPNOM",M_EMPNOM,.t.})
   aadd(sqlCAMPO,{"EMPEND",M_EMPEND,.t.})
   aadd(sqlCAMPO,{"EMPNRO",M_EMPNRO,.t.})
   aadd(sqlCAMPO,{"EMPCPE",M_EMPCPE,.t.})
   aadd(sqlCAMPO,{"EMPBAI",M_EMPBAI,.t.})
   aadd(sqlCAMPO,{"EMPMUN",M_EMPMUN,.t.})
   aadd(sqlCAMPO,{"EMPEST",M_EMPEST,.t.})
   aadd(sqlCAMPO,{"EMPTEL",M_EMPTEL,.t.})
   aadd(sqlCAMPO,{"EMPTEX",M_EMPTEX,.t.})
   aadd(sqlCAMPO,{"EMPFAX",M_EMPFAX,.t.})
   aadd(sqlCAMPO,{"EMPJUN",M_EMPJUN,.t.})
   aadd(sqlCAMPO,{"EMPCGC",M_EMPCGC,.t.})
   aadd(sqlCAMPO,{"EMPIES",M_EMPIES,.t.})
   aadd(sqlCAMPO,{"EMPSEN",M_EMPSEN,.t.})
   aadd(sqlCAMPO,{"EMPPRT","0100",.t.})
   aadd(sqlCAMPO,{"EMPIND","N",.t.})
endif

executasql()

return ""


*****************
function VEREMP02   && Munic¡pios conforme tabela IBGE
*****************

if M_EMPCDM = 0
  sele_arquivo("AMUN00")
  M_EMPCDM = MUNCOD
endif

if !BUSCAREGISTRO("AMUN00",1,{str(M_EMPCDM,7,0)},"SELECT")
  msg("* * * MUNICIPIO NAO CADASTRADO * * *")
  M_EMPCDM = 0
  return .f.
endif

M_EMPMUN = pad(AMUN00->MUNNOM, 32)
M_EMPEST = AMUN00->MUNEST

SetColor("N/W*")
  @ 13, 33 say    pad(M_EMPMUN, 25) picture "@!"
  @ 13, 63 say    M_EMPEST picture "@!"
set color to

return .t.

****************
function DESLIGA(F_TAM,F_LOCAL)
****************

if F_TAM = NIL
  F_TAM = 96
endif

    if M_IMPRE == "I"
*      ?? chr(18)                        && descomprime
*      ?? chr(27) + "2"
*      ?? chr(27) + "P"
      if F_LOCAL = NIL
        F_LOCAL = "F"
      endif
    endif


    if F_LOCAL = NIL
      F_LOCAL = "C"
    endif

    set print off
    set printer to
    set console on 
    set cursor on 
    set relation to

*    if !alltrim(AEMP00->EMPHS5) == "LASER"
*      if M_IMPRE == "I"
*        !copy RELATO.RPT LPT2 > nil
*        return ""
*      endif
*    endif
    
    if M_IMPRE = "A"
      ShowTime()
      MyDialogTwo()
     ShowTime( maxrow(), MaxCol()-9,,"N/W" ,.F. , .F. )

      
    else
*      if M_IMPRE == "I" // laser
        if F_TAM = 0 .or. F_TAM = 96
          if "SCILAS" $ M_LOGNOM
            oShell := CreateObject( "WScript.Shell" )
            oShell:Run( "nodosimp.exe RELATO.RPT 96 PRE/SEL", 0, .t. )
          else
            oShell := CreateObject( "WScript.Shell" )
            oShell:Run( "nodosimp.exe RELATO.RPT 96 /SEL", 0, .t. )
          endif
        else
          if F_TAM = 140
            if "SCILAS" $ M_LOGNOM
              oShell := CreateObject( "WScript.Shell" )
              oShell:Run( "nodosimp.exe RELATO.RPT 140 PRE/SEL", 0, .t. )
            else
              oShell := CreateObject( "WScript.Shell" )
              oShell:Run( "nodosimp.exe RELATO.RPT 140 SEL", 0, .t. )
            endif
          else
            if F_TAM = 80
              if "SCILAS" $ M_LOGNOM
                oShell := CreateObject( "WScript.Shell" )
                oShell:Run( "nodosimp.exe RELATO.RPT 80 PRE/SEL", 0, .t. )
              else
                oShell := CreateObject( "WScript.Shell" )
                oShell:Run( "nodosimp.exe RELATO.RPT 80 /SEL", 0, .t. )
              endif
            endif
          endif
        endif
      endif
*    endif


return ""


*******************
function ATU_NESTLE
*******************

M_DTAINI = M_DTA1

seexistesql("APCA00")

if file("PCALOC.CDX")
  erase("PCALOC.CDX")
endif

    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"APCA00","APCA00"})
    aadd(sqlCAMPO,"APCA00.*")
    aadd(sqlCHAVE,"PCAFAB <> ''")
    aadd(sqlORDEM,"PCAMAT")
    sqlrelation()

  select APCA00
  go top

  do while !eof()

    for ABC = 1 to 3  // 3 periodos 30 60 e 90 dias

      do case
        case ABC = 1
          M_DTAINI = M_DTA1
        case ABC = 2
          M_DTAINI = M_DTAINI - 30
        case ABC = 3
          M_DTAINI = M_DTAINI - 30
      endcase

      select APCA00
      
     msw("* * * AGUARDE ... PROCESSANDO: " +  transform(PCAMAT,"@E ###,###") + " * * *")

        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}

        aadd(sqlARQUI,{"AKAR00","AKAR00"})
        aadd(sqlCAMPO,"*")
        aadd(sqlRELATION,{"AFIS00","KARFISN","AFIS00.FISNOV"})
        aadd(sqlRELATION,{"ASLD00",str(ME_EMP, 2, 0),"ASLD00.SLDEMP"})
        aadd(sqlRELATION,{"","ASLD00.SLDMAT","AKAR00.KARMAT"})
        aadd(sqlCHAVE,"KARDTA BETWEEN " + aspas(formatdta(M_DTAINI)) + " and " + aspas(formatdta(M_DTA2)))
        aadd(sqlCHAVE,"KAREMP = " + str(ME_EMP, 2, 0))
        aadd(sqlCHAVE,"KARMAT = " + str(APCA00->PCAMAT, 6, 0))
        aadd(sqlORDEM,"KARDTA,KARFISN")
        sqlrelation()


     do while !eof()

        if KARFISN $ "5.102#5.104#5.405#6.102#6.104#6.405#"

          select ANESTLE
          if !dbseek(APCA00->PCAMAT)
            append blank
            replace PCAMAT with APCA00->PCAMAT
          endif

          do case
            case ABC = 1
            replace SLD30 with SLD30 + AKAR00->KARQDE
            case ABC = 2
            replace SLD60 with SLD60 + AKAR00->KARQDE
            case ABC = 3
            replace SLD90 with SLD90 + AKAR00->KARQDE
          endcase
        endif

        select AKAR00
        skip

        enddo

      next
      
      select APCA00

      skip

    enddo

    select ANESTLE

return ""




**********************
function ATU_INVNESTLE
**********************

if file("PCALOC.CDX")
  erase("PCALOC.CDX")
endif
if file("SLDINOVA.CDX")
  erase("SLDINOVA.CDX")
endif
if file("SLDCIRUR.CDX")
  erase("SLDCIRUR.CDX")
endif

    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"APCA00","APCA00"})
    aadd(sqlCAMPO,"APCA00.*")
    aadd(sqlCAMPO,"ASLD00.SLDNESTLE as SALDONESTLE")
    aadd(sqlRELATION,{"ASLD00",str(ME_EMP, 2, 0),"ASLD00.SLDEMP"})
    aadd(sqlRELATION,{"","ASLD00.SLDMAT","APCA00.PCAMAT"})
    aadd(sqlCHAVE,"PCAFAB <> ''")
    aadd(sqlORDEM,"PCAMAT")
    sqlrelation()


// VAMOS PEGAR O SALDO LANCADO EM 31/08

cARQSLD = ""

if AEMP00->EMPCGC == "037623347000109" // NUTRI INOVA
  select APCA00
  cria_dbf("SLDINOVA")  // CRIA DBF A PARTIR DO ARQUIVO ABERTO COM O NOME INDICADO
  select 0
  use SLDINOVA exclusive
  index on PCAFAB tag 1 to SLDINOVA
  cARQSLD = "SLDINOVA"

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ASLD00","ASLD00"})
  aadd(sqlCAMPO,"ASLD00.SLDNESTLE")
  aadd(sqlCAMPO,"SLDMAT")
  aadd(sqlCHAVE,"ASLD00.SLDNESTLE > 0")
  aadd(sqlCHAVE,"APCA00.PCAFAB <> ''")
  aadd(sqlCAMPO,"APCA00.PCAFAB")
  aadd(sqlCAMPO,"APCA00.PCAUNI")
  aadd(sqlCAMPO,"APCA00.PCADES")
  aadd(sqlRELATION,{"APCA00","ASLD00.SLDMAT","APCA00.PCAMAT"})

  sqlrelation()

  select ASLD00
  go top

  do while !eof()

    select SLDINOVA
    if !dbseek(ASLD00->PCAFAB)
      append blank
      replace PCAFAB    with ASLD00->PCAFAB
      replace PCAUNI    with ASLD00->PCAUNI
      replace PCAMAT    with ASLD00->SLDMAT
      replace SLDNESTLE with ASLD00->SLDNESTLE
      replace PCADES    with ASLD00->PCADES
    else
      replace SLDNESTLE with SLDNESTLE + ASLD00->SLDNESTLE
    endif

    select ASLD00
    skip

  enddo

else  // PEGAMOS O SALDO INICIAL INOVA
  select APCA00
  cria_dbf("SLDCIRUR")  // CRIA DBF A PARTIR DO ARQUIVO ABERTO COM O NOME INDICADO
  select 0
  use SLDCIRUR exclusive
  index on PCAFAB tag 1 to SLDCIRUR
  cARQSLD = "SLDCIRUR"

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ASLD00","ASLD00"})
  aadd(sqlCAMPO,"ASLD00.SLDNESTLE")
  aadd(sqlCAMPO,"SLDMAT")
  aadd(sqlCHAVE,"ASLD00.SLDNESTLE > 0")
  aadd(sqlCHAVE,"APCA00.PCAFAB <> ''")
  aadd(sqlCAMPO,"APCA00.PCAFAB")
  aadd(sqlCAMPO,"APCA00.PCAUNI")
  aadd(sqlCAMPO,"APCA00.PCADES")
  aadd(sqlRELATION,{"APCA00","ASLD00.SLDMAT","APCA00.PCAMAT"})
  sqlrelation()

  select ASLD00
  go top

  do while !eof()

    select SLDCIRUR
    if !dbseek(ASLD00->PCAFAB)
      append blank
      replace PCAFAB    with ASLD00->PCAFAB
      replace PCAUNI    with ASLD00->PCAUNI
      replace PCAMAT    with ASLD00->SLDMAT
      replace SLDNESTLE with ASLD00->SLDNESTLE
      replace PCADES    with ASLD00->PCADES
    else
      replace SLDNESTLE with SLDNESTLE + ASLD00->SLDNESTLE
    endif

    select ASLD00
    skip

  enddo

endif

    private M_SLD

    msw("* * * P R O C E S S A N D O * * *")

    select APCA00
    go top

    do while !eof()

      msw("* * * AGUARDE ... PROCESSANDO: " +  transform(PCAMAT,"@E ###,###") + " * * *")

      M_SLD  =  0
      select &cARQSLD
      if dbseek(APCA00->PCAFAB)
        M_SLD  =  SLDNESTLE
      endif

        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}

        aadd(sqlARQUI,{"AKAR00","AKAR00"})
        aadd(sqlCAMPO,"AKAR00.*")
        aadd(sqlCAMPO,"AFIS00.FISEST")
        aadd(sqlRELATION,{"AFIS00","KARFISN","AFIS00.FISNOV"})
        aadd(sqlRELATION,{"ASLD00",str(ME_EMP, 2, 0),"ASLD00.SLDEMP"})
        aadd(sqlRELATION,{"","ASLD00.SLDMAT","AKAR00.KARMAT"})

        if AEMP00->EMPCGC == "037623347000109" // NUTRI INOVA
          aadd(sqlCHAVE,"KAREMP in (2)")
        else
          aadd(sqlCHAVE,"KAREMP in (1,10)")
        endif

        aadd(sqlCHAVE,"KAREMP = " + str(ME_EMP, 2, 0))
        aadd(sqlCHAVE,"KARMAT = " + str(APCA00->PCAMAT, 6, 0))
        aadd(sqlCHAVE,"KARDTA >= " + aspas(formatdta(ctod("01/09/2024"))))
        aadd(sqlORDEM,"KARDTA,KARFISN")
        sqlrelation()

        M_SLDCME = 0
        M_SLDFIN = 0
        M_SLDCPA = 0
        M_FLAG1  = 0
        M_FLAG2  = 0
        k_SAIDA   = 0
        k_ENTRADA = 0
        N_TOTVAL = 0
        N_TOTSAL = 0
        
        do while !eof()

          select AKAR00
          calc_sldmed()

          skip

        enddo


        select &cARQSLD
        if !dbseek(APCA00->PCAFAB)
          append blank
          replace PCAFAB with APCA00->PCAFAB
          replace PCAUNI with APCA00->PCAUNI
          replace PCAMAT with APCA00->PCAMAT
          replace PCADES with APCA00->PCADES
          replace SLDNESTLE with M_SLD
        else
          replace SLDNESTLE with M_SLD
        endif

        select APCA00
        
        skip

    enddo


return ""



***************
function NESTLEPRE
***************

   LOCAL oExcel, oAS

   TRY
      oExcel := GetActiveObject( "Excel.Application" )
   CATCH
      TRY
         oExcel := CreateObject( "Excel.Application" )
      CATCH
         Alert( "ERROR! Excel not avialable. [" + Ole2TxtError()+ "]" )
         RETURN
      END
   END


   oExcel:WorkBooks:Add()
   oAS := oExcel:ActiveSheet()
   oAS:Cells:Font:Name := "Arial"
   oAS:Cells:Font:Size := 12

*  oAS:Cells( 1, 1 ):Value := AEMP00->EMPNOM

   oAS:Cells[ 1, 1 ] := "RAZAO SOCIAL"
   oAS:Cells[ 2, 1 ] := "CNPJ"
   oAS:Cells[ 3, 1 ] := "CLIENTE"
   oAS:Cells[ 4, 1 ] := "ENDERECO"
   oAS:Cells[ 5, 1 ] := "CEP"
   oAS:Cells[ 6, 1 ] := "CIDADE"
   oAS:Cells[ 7, 1 ] := "UF"
   oAS:Cells[ 8, 1 ] := "SEGMENTO"
   oAS:Cells[ 9, 1 ] := "NOTA FISCAL"
   oAS:Cells[ 10, 1 ] := "DATA"
   oAS:Cells[ 11, 1 ] := "CODIGO NESTLE"
   oAS:Cells[ 12, 1 ] := "DESCRICAO"
   oAS:Cells[ 13, 1 ] := "QDE VENDA"
   oAS:Cells[ 14, 1 ] := "UN"

*   oAS:Cells( 3, 1 ):ColumnWidth := 15
*   oAS:Cells[ 1, 3 ] := "DATA"


xNome = AEMP00->EMPNOM // "Cirurcenter Produtos Hospitalares LTDA"
xSold = AEMP00->EMPSOLD // 6652328
xKey  = AEMP00->EMPKEY // "991031AA-DE65-45CC-8E0C-1AAA4BFA53C8"


fecha_arq()

if file("ANESTLE.CDX")
  erase("ANESTLE.CDX")
endif

if file("ANESTI.CDX")
  erase("ANESTI.CDX")
endif

if file("ANESTV.CDX")
  erase("ANESTV.CDX")
endif

select 0
use &_PATH_\USR\ESTOQUE\ANESTLE exclusive
zap
index on PCAMAT to ANESTLE


seexistesql("ANFS01")
cSQL := "SELECT first 1 * from ANFS01"
dbusearea(.t.,"SQLMIX",cSQL,"ANFS01")
cria_dbf("ANESTI")  // CRIA DBF A PARTIR DO ARQUIVO ABERTO COM O NOME INDICADO
select 0
use ANESTI
index on str(NFSMAT,6) to ANESTI


select ANFS01
copy stru to ANESTV  // VENDAS


select ANFS01
copy stru to ASALDO  // VENDAS
select 0
use ASALDO exclusive
index on str(NFSMAT,6) to ASALDO

select 0
use ANESTV
index on str(NFSMAT,6) to ANESTV


M_DTA1 = ctod("  /  /  ")
M_DTA2 = ctod("  /  /  ")


sombra(14, 41, 17, 73,_SOMBRA_)

set color to GR/W
@ 14, 41 say                  "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 15, 41 say                  "³   Data Emissao Inicial:           ³"
@ 16, 41 say                  "³                  Final:           ³"
@ 17, 41 say                  "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
SetColor(_COREDICAO_)
@ 15, 67 get M_DTA1  valid !empty(M_DTA1)
@ 16, 67 get M_DTA2  valid !empty(M_DTA2)
read
set color to

if lastkey() = 27
   return ""
endif

atu_invnestle()
atu_nestle()

select APCA00
go top

// ENVIAMOS INVENTARIO

aPRODUTOS = { }

do while !eof()

  EXIT  // JA SABEMOS QUE AQUI ESTA OK


  M_VENDAS = 0
  select ANESTV  // VENDAS
    if dbseek(str(APCA00->PCAMAT,6))
    M_VENDAS = NFSQDE
  endif

  M_DIAEST = int(APCA00->SLD51/M_VENDAS)

  select APCA00

  if val(APCA00->PCAFAB) = 0 .or. APCA00->SLD51 < 0
    skip
    loop
  endif

  msw(PCADES)

  M_PRO = '{"secrectKeyDistribuidora":"' + xKey + '",'
  M_PRO = M_PRO + '"soldDistribuidor":' + str(xSold,7) + ","
  M_PRO = M_PRO + '"grupoDistribuidor":"Nutri Inova",'
  M_PRO = M_PRO + '"nomeDistribuidor":"' +  xNOME  + '",'
  M_PRO = M_PRO + '"periodoRef":"' + FORDTA(M_DTA1) + '",'


  M_PRO = M_PRO + '"produtos":['
  M_PRO = M_PRO + '{"codProdutoNestle_CodEAN":' +  APCA00->PCAFAB + ","
  M_PRO = M_PRO + '"nomeProduto":"' + APCA00->PCADES + '",'
  M_PRO = M_PRO + '"unidades":' + str(APCA00->SLD51,6) + ","
  M_PRO = M_PRO + '"unidadeMedida":"' + APCA00->PCAUNI + '",'
  M_PRO = M_PRO + '"diasDeEstoque":'+ str(M_DIAEST,3) + ","
  M_PRO = M_PRO + '"fator":1}'

  M_PRO = M_PRO + ']}'

  set print on
  set printer to "NESTLE.TXT"
  ? M_PRO
  set printer to
  set print off


  URLGRA  = 'https://apinestleselloutintegracaodev.magically.com.br/api/Inventario'
  oHttp1:= CreateObject( 'Msxml2.ServerXMLHTTP.6.0' )

  oHttp1:Open( "POST",URLGRA, .f. )
  oHttp1:setRequestHeader('Accept','application/json')
  oHttp1:setRequestHeader('x-api-version','1.0')
  oHttp1:setRequestHeader('Content-Type','application/json-patch+json')
  oHttp1:Send(M_PRO)

  IF oHttp1:status != 200
    IF oHttp1:status = 400  // nenhum pedido encontrado
      lTempedido = .f.
    else
      alert( Alltrim(Str(oHttp1:status)) +" - "+ oHttp1:statusText , "Erro na requisição")
      RETURN NIL
    endif
  ENDIF

  select APCA00
  skip

  alert(Str(oHttp1:status))
  alert(oHttp1:statusText)

enddo


nLin = 3


        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}

        aadd(sqlARQUI,{"ANFS00","ANFS00"})
        aadd(sqlCAMPO,"*")
        aadd(sqlRELATION,{"AFIS00","NFSNATN","AFIS00.FISNOV"})
        aadd(sqlRELATION,{"","NFSEMP","AFIS00.FISEMP"})
        aadd(sqlCHAVE,"NFSDTE BETWEEN " + aspas(formatdta(M_DTA1)) + " and " + aspas(formatdta(M_DTA2)))
        aadd(sqlCHAVE,"NFSEMP = " + str(ME_EMP, 2, 0))
        aadd(sqlCHAVE,"ANFS00.nfscan not in ('C','D')")
        aadd(sqlCHAVE,"ANFS00.NFSNATN in ('5.102','5.104','5.405','6.102','6.104','6.405')")
        aadd(sqlCHAVE,"(ANFS00.NFSCPG < 3 or ANFS00.NFSCPG > 24)")
        aadd(sqlORDEM,"NFSDTE")
        sqlrelation()

       do while !eof()

        *  if !alltrim(tira_pto(NFSNATN)) $ "5102#5104#5405#6102#6104#6405#"
        *    skip
        *    loop
        *  endif

          BUSCAREGISTRO("ANFS01",1,{str(ANFS00->NFSEMP, 2, 0),str(ANFS00->NFSNUM, 6, 0),aspas(ANFS00->NFSSER)},"SELECT")

          do while !eof()

            BUSCAREGISTRO("APCA00",1,{str(ANFS01->NFSMAT,6,0)},"SELECT")

            if eof()
              select ANFS01
              skip
              loop
            endif

            select ANFS01
            
            msw(APCA00->PCADES)

            if val(APCA00->PCAFAB) = 0
              select ANFS01
              skip
              loop
            endif

            BUSCAREGISTRO("ACLI00",1,{str(ANFS00->NFSCLI,7,0)},"SELECT")
            BUSCAREGISTRO("ATIP00",1,{aspas(ACLI00->CLITIP)},"SELECT")

            select ASALDO
            if !dbseek(str(ANFS01->NFSMAT,6))
              append blank
              replace NFSMAT with ANFS01->NFSMAT
            endif

            select ANFS01
            
            if ACLI00->CLITIP == "C"
              oAS:Cells[ 1, nLin ]:Value := "CONSUMIDOR"
            else
              oAS:Cells[ 1, nLin ]:Value := alltrim(ACLI00->CLINOM)
            endif

            if ACLI00->CLITIP == "C"
              oAS:Cells[ 2, nLin ]:Value := ""
            else
              if len(alltrim(ACLI00->CLICGC1)) = 15
                oAS:Cells[ 2, nLin ]:Value := transform(right(ACLI00->CLICGC1,14),"@R 99.999.999/9999-99")
              else
                oAS:Cells[ 2, nLin ]:Value := transform(alltrim(ACLI00->CLICGC1),"@R 999.999.999-99")
              endif
            endif

            oAS:Cells[ 3, nLin ]:Value := str(ANFS00->NFSCLI,7)

            if ACLI00->CLITIP == "C"
              oAS:Cells[ 4, nLin ]:Value := ""
              oAS:Cells[ 5, nLin ]:Value := ""
              oAS:Cells[ 6, nLin ]:Value := ACLI00->CLIMUN2
              oAS:Cells[ 7, nLin ]:Value := ACLI00->CLIUF2
            else
              oAS:Cells[ 4, nLin ]:Value := ACLI00->CLIEND2
              oAS:Cells[ 5, nLin ]:Value := strzero(ACLI00->CLICEP2, 5, 0) + strzero(ACLI00->CLICCL2, 3, 0)
              oAS:Cells[ 6, nLin ]:Value := ACLI00->CLIMUN2
              oAS:Cells[ 7, nLin ]:Value := ACLI00->CLIUF2
            endif


            oAS:Cells[ 8, nLin ]:Value := upper(ATIP00->CVENOM)

*            do case
*              case ACLI00->CLITIP == "A"
*                oAS:Cells[ 8, nLin ]:Value := "ASSOCIACAO"
*              case ACLI00->CLITIP == "C"
*                oAS:Cells[ 8, nLin ]:Value := "CONSUMIDOR"
*              case ACLI00->CLITIP == "D"
*                oAS:Cells[ 8, nLin ]:Value := "DRS"
*              case ACLI00->CLITIP == "E"
*                oAS:Cells[ 8, nLin ]:Value := "HOME CARE"
*              case ACLI00->CLITIP == "F"
*                oAS:Cells[ 8, nLin ]:Value := "PDV FARMACIA"
*              case ACLI00->CLITIP == "H"
*                oAS:Cells[ 8, nLin ]:Value := "HOSPITAL"
*              case ACLI00->CLITIP == "P"
*                oAS:Cells[ 8, nLin ]:Value := "PONTO DE VENDA"
*              case ACLI00->CLITIP == "R"
*                oAS:Cells[ 8, nLin ]:Value := "PREFEITURA"
*              case ACLI00->CLITIP == "G"
*                oAS:Cells[ 8, nLin ]:Value := "PDV CIRURGICA"
*              case ACLI00->CLITIP == "T"
*                oAS:Cells[ 8, nLin ]:Value := "FILANTROPIA/HOSP PUB/STA CASA"
*              case ACLI00->CLITIP == "S"
*                oAS:Cells[ 8, nLin ]:Value := "OPERADORA DE SAUDE"
*              case ACLI00->CLITIP == "I"
*                oAS:Cells[ 8, nLin ]:Value := "RESIDENCIA DE IDOSO"
*              case ACLI00->CLITIP == "L"
*                oAS:Cells[ 8, nLin ]:Value := "CONSULTORIA/CLINICA/AMBULATORI"
*            ENDCASE

            oAS:Cells[ 9, nLin ]:Value := str(ANFS00->NFSNUM,6)
            oAS:Cells[ 10, nLin ]:Value := dtoc(ANFS00->NFSDTE)
            oAS:Cells[ 11, nLin ]:Value := APCA00->PCAFAB
            oAS:Cells[ 12, nLin ]:Value := APCA00->PCADES
            oAS:Cells[ 13, nLin ]:Value := STR(ANFS01->NFSQDE,5)
            oAS:Cells[ 14, nLin ]:Value := APCA00->PCAUNI
            oAS:Cells[ 15, nLin ]:Value := APCA00->PCAMAT

            nLin = nLin + 1

            select ANFS01

            if inkey() = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                select ANFS02
                use
                return ""
              endif
            endif

            skip

          enddo

          select ANFS00

          skip

        enddo

// CUPOM FISCAL

        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}

        aadd(sqlARQUI,{"ACUP00","ACUP00"})
        aadd(sqlCAMPO,"*")
        aadd(sqlCHAVE,"CUPDTE BETWEEN " + aspas(formatdta(M_DTA1)) + " and " + aspas(formatdta(M_DTA2)))
        aadd(sqlCHAVE,"CUPEMP = " + str(ME_EMP, 2, 0))
        aadd(sqlCHAVE,"ACUP00.CUPCAN = 'E'")
        aadd(sqlORDEM,"CUPDTE")
        sqlrelation()

       do while !eof()

          BUSCAREGISTRO("ACUP01",1,{str(ACUP00->CUPEMP, 2, 0),str(ACUP00->CUPNUM, 6, 0),aspas(ACUP00->CUPSER)},"SELECT")

          do while !eof()

            if !BUSCAREGISTRO("APCA00",1,{str(ACUP01->CUPMAT,6,0)},"SELECT")
              select ACUP01
              skip
              loop
            endif

            msw(APCA00->PCADES)

            if val(APCA00->PCAFAB) = 0
              select ACUP01
              skip
              loop
            endif

            select ASALDO
            if !dbseek(str(ACUP01->CUPMAT,6))
              append blank
              replace NFSMAT with ACUP01->CUPMAT
            endif

            BUSCAREGISTRO("ACLI00",1,{str(ACUP00->CUPCLI,7,0)},"SELECT")
            BUSCAREGISTRO("ATIP00",1,{aspas(ACLI00->CLITIP)},"SELECT")

            select ACUP01

            if ACLI00->CLITIP == "C"
              oAS:Cells[ 1, nLin ]:Value := "CONSUMIDOR"
            else
              oAS:Cells[ 1, nLin ]:Value := alltrim(ACLI00->CLINOM)
            endif

            if ACLI00->CLITIP == "C"
              oAS:Cells[ 2, nLin ]:Value := ""
            else
              if len(alltrim(ACLI00->CLICGC1)) = 15
                oAS:Cells[ 2, nLin ]:Value := transform(right(ACLI00->CLICGC1,14),"@R 99.999.999/9999-99")
              else
                oAS:Cells[ 2, nLin ]:Value := transform(alltrim(ACLI00->CLICGC1),"@R 999.999.999-99")
              endif
            endif

            oAS:Cells[ 3, nLin ]:Value := str(ACUP00->CUPCLI,7)

            if ACLI00->CLITIP == "C"
              oAS:Cells[ 4, nLin ]:Value := ""
              oAS:Cells[ 5, nLin ]:Value := ""
              oAS:Cells[ 6, nLin ]:Value := ACLI00->CLIMUN2
              oAS:Cells[ 7, nLin ]:Value := ACLI00->CLIUF2
            else
              oAS:Cells[ 4, nLin ]:Value := ACLI00->CLIEND2
              oAS:Cells[ 5, nLin ]:Value := strzero(ACLI00->CLICEP2, 5, 0) + strzero(ACLI00->CLICCL2, 3, 0)
              oAS:Cells[ 6, nLin ]:Value := ACLI00->CLIMUN2
              oAS:Cells[ 7, nLin ]:Value := ACLI00->CLIUF2
            endif

            oAS:Cells[ 8, nLin ]:Value := upper(ATIP00->CVENOM)

        *    do case
        *      case ACLI00->CLITIP == "A"
        *        oAS:Cells[ 8, nLin ]:Value := "ASSOCIACAO"
        *      case ACLI00->CLITIP == "C"
        *        oAS:Cells[ 8, nLin ]:Value := "CONSUMIDOR"
        *      case ACLI00->CLITIP == "D"
        *        oAS:Cells[ 8, nLin ]:Value := "DRS"
        *      case ACLI00->CLITIP == "E"
        *        oAS:Cells[ 8, nLin ]:Value := "HOME CARE"
        *      case ACLI00->CLITIP == "F"
        *        oAS:Cells[ 8, nLin ]:Value := "PDV FARMACIA"
        *      case ACLI00->CLITIP == "H"
        *        oAS:Cells[ 8, nLin ]:Value := "HOSPITAL"
        *      case ACLI00->CLITIP == "P"
        *        oAS:Cells[ 8, nLin ]:Value := "PONTO DE VENDA"
        *      case ACLI00->CLITIP == "R"
        *        oAS:Cells[ 8, nLin ]:Value := "PREFEITURA"
        *      case ACLI00->CLITIP == "G"
        *        oAS:Cells[ 8, nLin ]:Value := "PDV CIRURGICA"
        *      case ACLI00->CLITIP == "T"
        *        oAS:Cells[ 8, nLin ]:Value := "FILANTROPIA/HOSP PUB/STA CASA"
        *      case ACLI00->CLITIP == "S"
        *        oAS:Cells[ 8, nLin ]:Value := "OPERADORA DE SAUDE"
        *      case ACLI00->CLITIP == "I"
        *        oAS:Cells[ 8, nLin ]:Value := "RESIDENCIA DE IDOSO"
        *      case ACLI00->CLITIP == "L"
        *        oAS:Cells[ 8, nLin ]:Value := "CONSULTORIA/CLINICA/AMBULATORI"
        *    ENDCASE

            oAS:Cells[ 9, nLin ]:Value := str(ACUP00->CUPNUM,6)
            oAS:Cells[ 10, nLin ]:Value := dtoc(ACUP00->CUPDTE)
            oAS:Cells[ 11, nLin ]:Value := APCA00->PCAFAB
            oAS:Cells[ 12, nLin ]:Value := APCA00->PCADES
            oAS:Cells[ 13, nLin ]:Value := STR(ACUP01->CUPQDE,5)
            oAS:Cells[ 14, nLin ]:Value := APCA00->PCAUNI
            oAS:Cells[ 15, nLin ]:Value := APCA00->PCAMAT

            nLin = nLin + 1

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


        nLin += 4
        
        
        if ME_EMP = 9999 // 1 CIRURCENTER tiramos isso

          seexistesql("SLDINOVA")
          seexistesql("SLDCIRUR")

          if file("SLDINOVA.CDX")
            erase("SLDINOVA.CDX")
          endif
          if file("SLDCIRUR.CDX")
            erase("SLDCIRUR.CDX")
          endif

          select 0
          use SLDINOVA exclusive
          index on PCAFAB tag 1 to SLDINOVA

          select 0
          use SLDCIRUR exclusive
          index on PCAFAB tag 1 to SLDCIRUR

          select SLDINOVA
          go top
          do while !eof()

            select SLDCIRUR
            if !dbseek(SLDINOVA->PCAFAB)
              append blank
              replace PCAMAT with SLDINOVA->PCAMAT
              replace PCAFAB with SLDINOVA->PCAFAB
              replace PCAUNI with SLDINOVA->PCAUNI
              replace PCADES with SLDINOVA->PCADES
              replace SLDNESTLE with SLDINOVA->SLDNESTLE
            else
              replace SLDNESTLE with SLDNESTLE + SLDINOVA->SLDNESTLE
            endif

            select SLDINOVA
            skip

          enddo

          select SLDCIRUR
          go top
          do while !eof()

            BUSCAREGISTRO("APCA00",1,{str(SLDCIRUR->PCAMAT,6,0)},"SELECT")

            oAS:Cells[ 11, nLin ]:Value := SLDCIRUR->PCAFAB
            oAS:Cells[ 12, nLin ]:Value := SLDCIRUR->PCADES
            oAS:Cells[ 13, nLin ]:Value := STR(SLDCIRUR->SLDNESTLE,5)
            oAS:Cells[ 14, nLin ]:Value := SLDCIRUR->PCAUNI
            oAS:Cells[ 15, nLin ]:Value := SLDCIRUR->PCAMAT

            nLin ++

            select SLDCIRUR
            skip

          enddo
        endif

  oAS:Columns( 1 ):AutoFit()
  oAS:Columns( 2 ):AutoFit()
  oAS:Columns( 3 ):AutoFit()
  oAS:Columns( 4 ):AutoFit()
  oAS:Columns( 5 ):AutoFit()
  oAS:Columns( 6 ):AutoFit()
  oAS:Columns( 7 ):AutoFit()
  oAS:Columns( 8 ):AutoFit()
  oAS:Columns( 9 ):AutoFit()
  oAS:Columns( 10):AutoFit()
  oAS:Columns( 11):AutoFit()
  oAS:Columns( 12):AutoFit()
  oAS:Columns( 13):AutoFit()

  oExcel:Visible := .T.




***************
function NESTLE
***************

*if AEMP00->EMPCGC == "002715655000171"
*  xNome =  "Cirurcenter Produtos Hospitalares LTDA"
*  xSold =  6652328
*  xKey  =  "991031AA-DE65-45CC-8E0C-1AAA4BFA53C8"

xNome = AEMP00->EMPNOM // "Cirurcenter Produtos Hospitalares LTDA"
xSold = AEMP00->EMPSOLD // 6652328
xKey  = AEMP00->EMPKEY // "991031AA-DE65-45CC-8E0C-1AAA4BFA53C8"
*
*else
*  xNome = "Nutri Inova Suplementos Nutricionais LTDA"
*  xSold=  6224089
*  xKey = "809E2870-08B5-4768-8D83-11BBFFAC3EA2"
*endif


fecha_arq()

if file("ANESTLE.CDX")
  erase("ANESTLE.CDX")
endif


if file("ANESTI.CDX")
  erase("ANESTI.CDX")
endif

if file("ANESTV.CDX")
  erase("ANESTV.CDX")
endif

select 0
use &_PATH_\USR\ESTOQUE\ANESTLE exclusive
zap
index on PCAMAT to ANESTLE

seexistesql("ANFS01")
cSQL := "SELECT first 1 * from ANFS01"
dbusearea(.t.,"SQLMIX",cSQL,"ANFS01")
cria_dbf("ANESTI")  // CRIA DBF A PARTIR DO ARQUIVO ABERTO COM O NOME INDICADO
select 0
use ANESTI
index on str(NFSMAT,6) to ANESTI


select ANFS01
copy stru to ANESTV  // VENDAS

select 0
use ANESTV
index on str(NFSMAT,6) to ANESTV


select ANFS01
copy stru to ASOMAV  // VENDAS

select 0
use ASOMAV exclusive
index on str(NFSMAT,6) to ASOMAV



M_DTA1 = ctod("  /  /  ")
M_DTA2 = ctod("  /  /  ")


sombra(14, 41, 17, 73,_SOMBRA_)

set color to GR/W
@ 14, 41 say                  "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 15, 41 say                  "³   Data Emissao Inicial:           ³"
@ 16, 41 say                  "³                  Final:           ³"
@ 17, 41 say                  "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
SetColor(_COREDICAO_)
@ 15, 67 get M_DTA1  valid !empty(M_DTA1)
@ 16, 67 get M_DTA2  valid !empty(M_DTA2)
read
set color to

if lastkey() = 27
   return ""
endif

atu_invnestle()
atu_nestle()

select APCA00
go top

// ENVIAMOS INVENTARIO

do while !eof()

  EXIT  // JA SABEMOS QUE AQUI ESTA OK


  M_VENDAS = 0
  select ANESTV  // VENDAS
  if dbseek(str(APCA00->PCAMAT,6))
    M_VENDAS = NFSQDE
  endif

  M_DIAEST = int(APCA00->SLD51/M_VENDAS)

  select APCA00

  if val(APCA00->PCAFAB) = 0 .or. APCA00->SLD51 < 0
    skip
    loop
  endif

  msw(PCADES)

  M_PRO = '{"secrectKeyDistribuidora":"' + xKey + '",'
  M_PRO = M_PRO + '"soldDistribuidor":' + str(xSold,7) + ","
  M_PRO = M_PRO + '"grupoDistribuidor":"Nutri Inova",'
  M_PRO = M_PRO + '"nomeDistribuidor":"' +  xNOME  + '",'
  M_PRO = M_PRO + '"periodoRef":"' + FORDTA(M_DTA1) + '",'


  M_PRO = M_PRO + '"produtos":['
  M_PRO = M_PRO + '{"codProdutoNestle_CodEAN":' +  APCA00->PCAFAB + ","
  M_PRO = M_PRO + '"nomeProduto":"' + APCA00->PCADES + '",'
  M_PRO = M_PRO + '"unidades":' + str(APCA00->SLD51,6) + ","
  M_PRO = M_PRO + '"unidadeMedida":"' + APCA00->PCAUNI + '",'
  M_PRO = M_PRO + '"diasDeEstoque":'+ str(M_DIAEST,3) + ","
  M_PRO = M_PRO + '"fator":1}'

  M_PRO = M_PRO + ']}'

* set print on
* set printer to "NESTLE.TXT"
* ? M_PRO
* set printer to
 *set print off


  URLGRA  = 'https://apinestleselloutintegracaoprod.magically.com.br/api/Inventario'

*  URLGRA  = 'https://apinestleselloutintegracaodev.magically.com.br/api/Inventario'
  oHttp1:= CreateObject( 'Msxml2.ServerXMLHTTP.6.0' )

  oHttp1:Open( "POST",URLGRA, .f. )
  oHttp1:setRequestHeader('Accept','application/json')
  oHttp1:setRequestHeader('x-api-version','1.0')
  oHttp1:setRequestHeader('Content-Type','application/json-patch+json')
  oHttp1:Send(M_PRO)

  IF oHttp1:status != 200
    IF oHttp1:status = 400  // nenhum pedido encontrado
      lTempedido = .f.
    else
      alert( Alltrim(Str(oHttp1:status)) +" - "+ oHttp1:statusText , "Erro na requisição")
      RETURN NIL
    endif
  ENDIF

  select APCA00
  skip

  *MSW(Str(oHttp1:status))
  *alert(oHttp1:statusText)

enddo

        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}

        aadd(sqlARQUI,{"ANFS00","ANFS00"})
        aadd(sqlCAMPO,"*")
        aadd(sqlRELATION,{"AFIS00","NFSNATN","AFIS00.FISNOV"})
        aadd(sqlRELATION,{"","NFSEMP","AFIS00.FISEMP"})
        aadd(sqlCHAVE,"NFSDTE BETWEEN " + aspas(formatdta(M_DTA1)) + " and " + aspas(formatdta(M_DTA2)))
        aadd(sqlCHAVE,"NFSEMP = " + str(ME_EMP, 2, 0))
        aadd(sqlCHAVE,"ANFS00.nfscan not in ('C','D')")
        aadd(sqlCHAVE,"ANFS00.NFSNATN in ('5.102','5.104','5.405','6.102','6.104','6.405')")
        aadd(sqlCHAVE,"(ANFS00.NFSCPG < 3 or ANFS00.NFSCPG > 24)")
        aadd(sqlORDEM,"NFSDTE")
        sqlrelation()


       do while !eof()


*          if !alltrim(tira_pto(NFSNATN)) $ "5102#5104#5405#6102#6104#6405#"
*            skip
*            loop
*          endif

          select ASOMAV
          zap

          BUSCAREGISTRO("ANFS01",1,{str(ANFS00->NFSEMP, 2, 0),str(ANFS00->NFSNUM, 6, 0),aspas(ANFS00->NFSSER)},"SELECT")

          do while !eof()

            if !BUSCAREGISTRO("APCA00",1,{str(ANFS01->NFSMAT,6,0)},"SELECT")
              select ANFS01
              skip
              loop
            endif

            msW(APCA00->PCADES)

            if val(APCA00->PCAFAB) = 0
              select ANFS01
              skip
              loop
            endif

            select ASOMAV
            if !dbseek(str(ANFS01->NFSMAT,6))
              append blank
            endif

            replace NFSMAT with ANFS01->NFSMAT
            replace NFSQDE with NFSQDE + ANFS01->NFSQDE

            select ANFS01
            skip

          enddo


          BUSCAREGISTRO("ACLI00",1,{str(ANFS00->NFSCLI,7,0)},"SELECT")
          BUSCAREGISTRO("ATIP00",1,{aspas(ACLI00->CLITIP)},"SELECT")

          select ASOMAV
          go top
          do while !eof()

            BUSCAREGISTRO("APCA00",1,{str(ASOMAV->NFSMAT,6,0)},"SELECT")

            M_PRO = '{'
            M_PRO = M_PRO + '  "sold": ' + str(xSold,7) + ","
            M_PRO = M_PRO + '  "secrectKeyDistribuidora": "' + xKey + '",'
            M_PRO = M_PRO + '  "periodo": "' + FORDTA(ANFS00->NFSDTE)  + '",'
            M_PRO = M_PRO + '  "clientes": ['
            M_PRO = M_PRO + '    {'

            if ACLI00->CLITIP == "C"
              M_PRO = M_PRO + '      "razaoSocialFaturado": "CONSUMIDOR",'
            else
              M_PRO = M_PRO + '      "razaoSocialFaturado": "'  + alltrim(ACLI00->CLINOM) + '",'
            endif

            if ACLI00->CLITIP == "C"
               M_PRO = M_PRO + '      "cnpjFaturado": "00000000000",'
            else
              if len(alltrim(ACLI00->CLICGC1)) = 15
                 M_PRO = M_PRO + '      "cnpjFaturado": "'  + right(ACLI00->CLICGC1,14) + '",'
              else
                 M_PRO = M_PRO + '      "cnpjFaturado": "'  + alltrim(ACLI00->CLICGC1) + '",'
              endif
            endif

            if ACLI00->CLITIP == "C"
              M_PRO = M_PRO + '      "codCLienteFaturado": ' + aspasduplas(str(ANFS00->NFSCLI,7)) + ","
              M_PRO = M_PRO + '      "enderecoClienteFaturado": ".",'
              M_PRO = M_PRO + '      "cepFaturado": "0",'
              M_PRO = M_PRO + '      "cidadeFaturado": ' + alltrim(aspasduplas(ACLI00->CLIMUN2)) + ","
              M_PRO = M_PRO + '      "ufFaturado": ' + alltrim(aspasduplas(ACLI00->CLIUF2)) + ","
              M_PRO = M_PRO + '      "tipoClienteFaturado": "PF",'
            else
              M_PRO = M_PRO + '      "codCLienteFaturado": ' + aspasduplas(str(ANFS00->NFSCLI,7)) + ","
              M_PRO = M_PRO + '      "enderecoClienteFaturado": ' + alltrim(aspasduplas(ACLI00->CLIEND2))+ ","
              M_PRO = M_PRO + '      "cepFaturado": ' + aspasduplas(strzero(ACLI00->CLICEP2, 5, 0) + strzero(ACLI00->CLICCL2, 3, 0)) + ","
              M_PRO = M_PRO + '      "cidadeFaturado": ' + alltrim(aspasduplas(ACLI00->CLIMUN2)) + ","
              M_PRO = M_PRO + '      "ufFaturado": ' + alltrim(aspasduplas(ACLI00->CLIUF2)) + ","
              if len(alltrim(ACLI00->CLICGC1)) = 15
                M_PRO = M_PRO + '      "tipoClienteFaturado": "PJ",'
              else
                M_PRO = M_PRO + '      "tipoClienteFaturado": "PF",'
              endif
            endif

            M_PRO = M_PRO + '      "segmentoClienteFaturado": "' + alltrim(upper(ATIP00->CVENOM)) + '",'

*            do case
*              case ACLI00->CLITIP == "A"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "ASSOCIAÇÃO",'
*              case ACLI00->CLITIP == "C"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "CONSUMIDOR",'
*              case ACLI00->CLITIP == "D"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "DRS",'
*              case ACLI00->CLITIP == "E"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "HOME CARE",'
*              case ACLI00->CLITIP == "F"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "PDV FARMACIA",'
*              case ACLI00->CLITIP == "H"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "HOSPITAL",'
*              case ACLI00->CLITIP == "P"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "PONTO DE VENDA",'
*              case ACLI00->CLITIP == "R"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "PREFEITURA",'
*              case ACLI00->CLITIP == "G"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "PDV CIRURGICA",'
*              case ACLI00->CLITIP == "T"
 *               M_PRO = M_PRO + '      "segmentoClienteFaturado": "FILANTROPIA/HOSP PUB/STA CASA",'
 *             case ACLI00->CLITIP == "S"
 *               M_PRO = M_PRO + '      "segmentoClienteFaturado": "OPERADORA DE SAUDE",'
 *             case ACLI00->CLITIP == "I"
 *               M_PRO = M_PRO + '      "segmentoClienteFaturado": "RESIDENCIA DE IDOSO",'
 *             case ACLI00->CLITIP == "L"
 *               M_PRO = M_PRO + '      "segmentoClienteFaturado": "CONSULTORIA/CLINICA/AMBULATORI",'
 *           ENDCASE


            M_PRO = M_PRO + '      "vendas": ['
            M_PRO = M_PRO + '        {'

            if ACLI00->CLITIP == "C"
              M_PRO = M_PRO + '      "razaoSocialEntrega": "CONSUMIDOR",'
              M_PRO = M_PRO + '      "cnpjEntrega": "00000000000",'
              M_PRO = M_PRO + '          "codClienteEntrega": ' + aspasduplas(str(ANFS00->NFSCLI,7)) + ","
              M_PRO = M_PRO + '          "enderecoClienteEntrega": ".",'
              M_PRO = M_PRO + '          "cepEntrega": "0",'
              M_PRO = M_PRO + '          "cidadeEntrega": ' + alltrim(aspasduplas(ACLI00->CLIMUN2)) + ","
              M_PRO = M_PRO + '          "ufEntrega": ' + alltrim(aspasduplas(ACLI00->CLIUF2)) + ","
              M_PRO = M_PRO + '      "tipoClienteEntrega": "PF",'
            else
              M_PRO = M_PRO + '          "razaoSocialEntrega": "'  + alltrim(ACLI00->CLINOM) + '",'
              if len(alltrim(ACLI00->CLICGC1)) = 15
                 M_PRO = M_PRO + '      "cnpjEntrega": "'  + right(ACLI00->CLICGC1,14) + '",'
              else
                 M_PRO = M_PRO + '      "cnpjEntrega": "'  + alltrim(ACLI00->CLICGC1) + '",'
              endif
              M_PRO = M_PRO + '          "codClienteEntrega": ' + aspasduplas(str(ANFS00->NFSCLI,7)) + ","
              M_PRO = M_PRO + '          "enderecoClienteEntrega": ' + alltrim(aspasduplas(ACLI00->CLIEND2))+ ","
              M_PRO = M_PRO + '          "cepEntrega": ' + aspasduplas(strzero(ACLI00->CLICEP2, 5, 0) + strzero(ACLI00->CLICCL2, 3, 0)) + ","
              M_PRO = M_PRO + '          "cidadeEntrega": ' + alltrim(aspasduplas(ACLI00->CLIMUN2)) + ","
              M_PRO = M_PRO + '          "ufEntrega": ' + alltrim(aspasduplas(ACLI00->CLIUF2)) + ","
              if len(alltrim(ACLI00->CLICGC1)) = 15
                M_PRO = M_PRO + '      "tipoClienteEntrega": "PJ",'
              else
                M_PRO = M_PRO + '      "tipoClienteEntrega": "PF",'
              endif
            endif

            M_PRO = M_PRO + '          "tipoDeDocumento": "VE",'
            M_PRO = M_PRO + '      "segmentoClienteEntrega": "' + alltrim(upper(ATIP00->CVENOM)) + '",'

*            do case
*              case ACLI00->CLITIP == "A"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "ASSOCIAÇÃO",'
*              case ACLI00->CLITIP == "C"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "CONSUMIDOR",'
*              case ACLI00->CLITIP == "D"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "DRS",'
*              case ACLI00->CLITIP == "E"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "HOME CARE",'
*              case ACLI00->CLITIP == "F"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "PDV FARMACIA",'
*              case ACLI00->CLITIP == "H"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "HOSPITAL",'
*              case ACLI00->CLITIP == "P"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "PONTO DE VENDA",'
*              case ACLI00->CLITIP == "R"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "PREFEITURA",'
*              case ACLI00->CLITIP == "G"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "PDV CIRURGICA",'
*              case ACLI00->CLITIP == "T"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "FILANTROPIA/HOSP PUB/STA CASA",'
*              case ACLI00->CLITIP == "S"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "OPERADORA DE SAUDE",'
*              case ACLI00->CLITIP == "I"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "RESIDENCIA DE IDOSO",'
*              case ACLI00->CLITIP == "L"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "CONSULTORIA/CLINICA/AMBULATORI",'
*            ENDCASE


            M_PRO = M_PRO + '          "notaFiscal": ' + aspasduplas(str(ANFS00->NFSNUM,6)) + ","
            M_PRO = M_PRO + '          "codCupom": "",'
            M_PRO = M_PRO + '          "dataVenda": ' + aspasduplas(FORDTA(ANFS00->NFSDTE)) + ","
            M_PRO = M_PRO + '          "produtos": ['
            M_PRO = M_PRO + '            {'
            M_PRO = M_PRO + '              "codProdutoNestle": ' + aspasduplas(APCA00->PCAFAB) +  ","
            M_PRO = M_PRO + '              "nomeProduto": ' + aspasduplas(APCA00->PCADES) + ","
            M_PRO = M_PRO + '              "unidade": ' + aspasduplas(str(ASOMAV->NFSQDE,4)) + ","
            M_PRO = M_PRO + '              "unidadeMedida": ' + aspasduplas(APCA00->PCAUNI) + ","
            M_PRO = M_PRO + '              "fator": "1"'
            M_PRO = M_PRO + '            }'
            M_PRO = M_PRO + '          ]'
            M_PRO = M_PRO + '        }'
            M_PRO = M_PRO + '      ]'
            M_PRO = M_PRO + '    }'
            M_PRO = M_PRO + '  ]'
            M_PRO = M_PRO + '}'


            MSw("ENVIANDO NOTA - " + str(ANFS00->NFSNUM,6))

           URLGRA  = 'https://apinestleselloutintegracaoprod.magically.com.br/api/Importacao'
*           URLGRA  = 'https://apinestleselloutintegracaodev.magically.com.br/api/Importacao'
           oHttp1:= CreateObject( 'Msxml2.ServerXMLHTTP.6.0' )

           oHttp1:Open( "POST",URLGRA, .f. )
           oHttp1:setRequestHeader('Accept','application/json')
           oHttp1:setRequestHeader('x-api-version','1.0')
           oHttp1:setRequestHeader('Content-Type','application/json-patch+json')
           oHttp1:Send(M_PRO)

           IF oHttp1:status != 200
             IF oHttp1:status = 400  // nenhum pedido encontrado
               lTempedido = .f.
             else
               alert( Alltrim(Str(oHttp1:status)) +" - "+ oHttp1:statusText , "Erro na requisição")
               RETURN NIL
             endif
           ENDIF

   *        alert(Str(oHttp1:status))
   *        alert(oHttp1:statusText)



            select ASOMAV

            if inkey() = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                select ANFS02
                use
                return ""
              endif
            endif

            skip

          enddo

          select ANFS00

          skip

        enddo



// CUPOM FISCAL

        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}

        aadd(sqlARQUI,{"ACUP00","ACUP00"})
        aadd(sqlCAMPO,"*")
        aadd(sqlCHAVE,"CUPDTE BETWEEN " + aspas(formatdta(M_DTA1)) + " and " + aspas(formatdta(M_DTA2)))
        aadd(sqlCHAVE,"CUPEMP = " + str(ME_EMP, 2, 0))
        aadd(sqlCHAVE,"ACUP00.CUPCAN = 'E'")
        aadd(sqlORDEM,"CUPDTE")
        sqlrelation()

       do while !eof()

          BUSCAREGISTRO("ACUP01",1,{str(ACUP00->CUPEMP, 2, 0),str(ACUP00->CUPNUM, 6, 0),aspas(ACUP00->CUPSER)},"SELECT")

          do while !eof()

            if !BUSCAREGISTRO("APCA00",1,{str(ACUP01->CUPMAT,6,0)},"SELECT")
              select ACUP01
              skip
              loop
            endif

            msW(APCA00->PCADES)

            if val(APCA00->PCAFAB) = 0
              select ACUP01
              skip
              loop
            endif

            BUSCAREGISTRO("ACLI00",1,{str(ACUP00->CUPCLI,7,0)},"SELECT")
            BUSCAREGISTRO("ATIP00",1,{aspas(ACLI00->CLITIP)},"SELECT")


*            IF ACLI00->CLITIP == "C"
*              skip
*              loop
*            endif


            M_PRO = '{'
            M_PRO = M_PRO + '  "sold": ' + str(xSold,7) + ","
            M_PRO = M_PRO + '  "secrectKeyDistribuidora": "' + xKey + '",'
            M_PRO = M_PRO + '  "periodo": "' + FORDTA(ACUP00->CUPDTE)  + '",'
            M_PRO = M_PRO + '  "clientes": ['
            M_PRO = M_PRO + '    {'

            if ACLI00->CLITIP == "C"
              M_PRO = M_PRO + '      "razaoSocialFaturado": "CONSUMIDOR",'
            else
              M_PRO = M_PRO + '      "razaoSocialFaturado": "'  + alltrim(ACLI00->CLINOM) + '",'
            endif

            if ACLI00->CLITIP == "C"
               M_PRO = M_PRO + '      "cnpjFaturado": "00000000000",'
            else
              if len(alltrim(ACLI00->CLICGC1)) = 15
                 M_PRO = M_PRO + '      "cnpjFaturado": "'  + right(ACLI00->CLICGC1,14) + '",'
              else
                 M_PRO = M_PRO + '      "cnpjFaturado": "'  + alltrim(ACLI00->CLICGC1) + '",'
              endif
            endif

            if ACLI00->CLITIP == "C"
              M_PRO = M_PRO + '      "codCLienteFaturado": ' + aspasduplas(str(ACUP00->CUPCLI,7)) + ","
              M_PRO = M_PRO + '      "enderecoClienteFaturado": ".",'
              M_PRO = M_PRO + '      "cepFaturado": "0",'
              M_PRO = M_PRO + '      "cidadeFaturado": ' + alltrim(aspasduplas(ACLI00->CLIMUN2)) + ","
              M_PRO = M_PRO + '      "ufFaturado": ' + alltrim(aspasduplas(ACLI00->CLIUF2)) + ","
              M_PRO = M_PRO + '      "tipoClienteFaturado": "PF",'
            else
              M_PRO = M_PRO + '      "codCLienteFaturado": ' + aspasduplas(str(ACUP00->CUPCLI,7)) + ","
              M_PRO = M_PRO + '      "enderecoClienteFaturado": ' + alltrim(aspasduplas(ACLI00->CLIEND2))+ ","
              M_PRO = M_PRO + '      "cepFaturado": ' + aspasduplas(strzero(ACLI00->CLICEP2, 5, 0) + strzero(ACLI00->CLICCL2, 3, 0)) + ","
              M_PRO = M_PRO + '      "cidadeFaturado": ' + alltrim(aspasduplas(ACLI00->CLIMUN2)) + ","
              M_PRO = M_PRO + '      "ufFaturado": ' + alltrim(aspasduplas(ACLI00->CLIUF2)) + ","
              if len(alltrim(ACLI00->CLICGC1)) = 15
                M_PRO = M_PRO + '      "tipoClienteFaturado": "PJ",'
              else
                M_PRO = M_PRO + '      "tipoClienteFaturado": "PF",'
              endif
            endif

            M_PRO = M_PRO + '      "segmentoClienteFaturado": "' + alltrim(upper(ATIP00->CVENOM)) + '",'


*            do case
*              case ACLI00->CLITIP == "A"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "ASSOCIAÇÃO",'
*              case ACLI00->CLITIP == "C"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "CONSUMIDOR",'
*              case ACLI00->CLITIP == "D"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "DRS",'
*              case ACLI00->CLITIP == "E"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "HOME CARE",'
*              case ACLI00->CLITIP == "F"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "PDV FARMACIA",'
*              case ACLI00->CLITIP == "H"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "HOSPITAL",'
*              case ACLI00->CLITIP == "P"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "PONTO DE VENDA",'
*              case ACLI00->CLITIP == "R"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "PREFEITURA",'
*              case ACLI00->CLITIP == "G"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "PDV CIRURGICA",'
*              case ACLI00->CLITIP == "T"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "FILANTROPIA/HOSP PUB/STA CASA",'
*              case ACLI00->CLITIP == "S"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "OPERADORA DE SAUDE",'
*              case ACLI00->CLITIP == "I"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "RESIDENCIA DE IDOSO",'
*              case ACLI00->CLITIP == "L"
*                M_PRO = M_PRO + '      "segmentoClienteFaturado": "CONSULTORIA/CLINICA/AMBULATORI",'
*            ENDCASE


            M_PRO = M_PRO + '      "vendas": ['
            M_PRO = M_PRO + '        {'

            if ACLI00->CLITIP == "C"
              M_PRO = M_PRO + '      "razaoSocialEntrega": "CONSUMIDOR",'
              M_PRO = M_PRO + '      "cnpjEntrega": "00000000000",'
              M_PRO = M_PRO + '          "codClienteEntrega": ' + aspasduplas(str(ACUP00->CUPCLI,7)) + ","
              M_PRO = M_PRO + '          "enderecoClienteEntrega": ".",'
              M_PRO = M_PRO + '          "cepEntrega": "0",'
              M_PRO = M_PRO + '          "cidadeEntrega": ' + alltrim(aspasduplas(ACLI00->CLIMUN2)) + ","
              M_PRO = M_PRO + '          "ufEntrega": ' + alltrim(aspasduplas(ACLI00->CLIUF2)) + ","
              M_PRO = M_PRO + '      "tipoClienteEntrega": "PF",'
            else
              M_PRO = M_PRO + '          "razaoSocialEntrega": "'  + alltrim(ACLI00->CLINOM) + '",'
              if len(alltrim(ACLI00->CLICGC1)) = 15
                 M_PRO = M_PRO + '      "cnpjEntrega": "'  + right(ACLI00->CLICGC1,14) + '",'
              else
                 M_PRO = M_PRO + '      "cnpjEntrega": "'  + alltrim(ACLI00->CLICGC1) + '",'
              endif
              M_PRO = M_PRO + '          "codClienteEntrega": ' + aspasduplas(str(ACUP00->CUPCLI,7)) + ","
              M_PRO = M_PRO + '          "enderecoClienteEntrega": ' + alltrim(aspasduplas(ACLI00->CLIEND2))+ ","
              M_PRO = M_PRO + '          "cepEntrega": ' + aspasduplas(strzero(ACLI00->CLICEP2, 5, 0) + strzero(ACLI00->CLICCL2, 3, 0)) + ","
              M_PRO = M_PRO + '          "cidadeEntrega": ' + alltrim(aspasduplas(ACLI00->CLIMUN2)) + ","
              M_PRO = M_PRO + '          "ufEntrega": ' + alltrim(aspasduplas(ACLI00->CLIUF2)) + ","
              if len(alltrim(ACLI00->CLICGC1)) = 15
                M_PRO = M_PRO + '      "tipoClienteEntrega": "PJ",'
              else
                M_PRO = M_PRO + '      "tipoClienteEntrega": "PF",'
              endif
            endif

            M_PRO = M_PRO + '          "tipoDeDocumento": "VE",'
            M_PRO = M_PRO + '      "segmentoClienteEntrega": "' + alltrim(upper(ATIP00->CVENOM)) + '",'

*            do case
*              case ACLI00->CLITIP == "A"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "ASSOCIAÇÃO",'
*              case ACLI00->CLITIP == "C"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "CONSUMIDOR",'
*              case ACLI00->CLITIP == "D"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "DRS",'
*              case ACLI00->CLITIP == "E"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "HOME CARE",'
*              case ACLI00->CLITIP == "F"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "PDV FARMACIA",'
*              case ACLI00->CLITIP == "H"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "HOSPITAL",'
*              case ACLI00->CLITIP == "P"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "PONTO DE VENDA",'
*              case ACLI00->CLITIP == "R"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "PREFEITURA",'
*              case ACLI00->CLITIP == "G"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "PDV CIRURGICA",'
*              case ACLI00->CLITIP == "T"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "FILANTROPIA/HOSP PUB/STA CASA",'
*              case ACLI00->CLITIP == "S"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "OPERADORA DE SAUDE",'
*              case ACLI00->CLITIP == "I"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "RESIDENCIA DE IDOSO",'
*              case ACLI00->CLITIP == "L"
*                M_PRO = M_PRO + '      "segmentoClienteEntrega": "CONSULTORIA/CLINICA/AMBULATORI",'
*            ENDCASE

            M_PRO = M_PRO + '          "notaFiscal": ' + aspasduplas(str(ACUP00->CUPNUM,6)) + ","
            M_PRO = M_PRO + '          "codCupom": "",'
            M_PRO = M_PRO + '          "dataVenda": ' + aspasduplas(FORDTA(ACUP00->CUPDTE)) + ","
            M_PRO = M_PRO + '          "produtos": ['
            M_PRO = M_PRO + '            {'
            M_PRO = M_PRO + '              "codProdutoNestle": ' + aspasduplas(APCA00->PCAFAB) +  ","
            M_PRO = M_PRO + '              "nomeProduto": ' + aspasduplas(APCA00->PCADES) + ","
            M_PRO = M_PRO + '              "unidade": ' + aspasduplas(str(ACUP01->CUPQDE,4)) + ","
            M_PRO = M_PRO + '              "unidadeMedida": ' + aspasduplas(APCA00->PCAUNI) + ","
            M_PRO = M_PRO + '              "fator": "1"'
            M_PRO = M_PRO + '            }'
            M_PRO = M_PRO + '          ]'
            M_PRO = M_PRO + '        }'
            M_PRO = M_PRO + '      ]'
            M_PRO = M_PRO + '    }'
            M_PRO = M_PRO + '  ]'
            M_PRO = M_PRO + '}'

            MSw("ENVIANDO CUPOM - " + str(ACUP00->CUPNUM,6))

* set print on
* set printer to "NESTLE.TXT"
* ? M_PRO
* set printer to
* set print off

           URLGRA  = 'https://apinestleselloutintegracaoprod.magically.com.br/api/Importacao'
*           URLGRA  = 'https://apinestleselloutintegracaodev.magically.com.br/api/Importacao'
           oHttp1:= CreateObject( 'Msxml2.ServerXMLHTTP.6.0' )

           oHttp1:Open( "POST",URLGRA, .f. )
           oHttp1:setRequestHeader('Accept','application/json')
           oHttp1:setRequestHeader('x-api-version','1.0')
           oHttp1:setRequestHeader('Content-Type','application/json-patch+json')
           oHttp1:Send(M_PRO)

           IF oHttp1:status != 200
             IF oHttp1:status = 400  // nenhum pedido encontrado
               lTempedido = .f.
             else
               alert( Alltrim(Str(oHttp1:status)) +" - "+ oHttp1:statusText , "Erro na requisição")
               RETURN NIL
             endif
           ENDIF

   *        alert(Str(oHttp1:status))
   *        alert(oHttp1:statusText)



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


msg("* * * FIM DO PROCESSO * * *")


****************
function VERREGIME
****************

LOCAL scr, clr
LOCAL aBlocks := {}

parameters F_HELP,F_OQUE

if lastkey(,.t.) = 5
  return .t.
endif

lTela = savescreen(7,39,22,76)
M_TIPOS = { }

aadd(M_TIPOS,"1 Simples Nacional.                               ")
aadd(M_TIPOS,"2 Simples Nacional excesso sublimite receita bruta")
aadd(M_TIPOS,"3 Regime Normal.                                  ")

PosAcho = 1

for A = 1 to len(M_TIPOS)
  if left(M_TIPOS[A],1) == alltrim(F_HELP)
    PosAcho = A
    exit
  endif
next

scr := SaveScreen( 7,38,11,85 )
clr := SetColor( 'N/W*,GR+/B*,,,GR+/B' )

Wvt_DrawBoxRaised( 8, 40, 10, 84 )
aLastPaint4 := WvtSetBlocks( aBlocks )

TIPO1 = achoice(8,40,10,84,M_TIPOS,,,PosAcho)
setcolor("")

setColor( clr )
RestScreen( 7,38,11,85, scr )

WvtSetBlocks( aLastPaint4 )

if lastkey() = 27
  return .t.
endif

F_HELP = left(M_TIPOS[TIPO1],1)

return .t.

function TesteSombra

//Win() desenha janela nas coordenadas especificadas
local aEnv := Win( 05, 02, 19, 77, "Paleta de Cores" )

setcolor( "N/N" )     ; @ 07, 04 clear to 18, 07
setcolor( "B/B" )     ; @ 07, 08 clear to 18, 11
setcolor( "G/G" )     ; @ 07, 12 clear to 18, 15
setcolor( "BG/BG" )   ; @ 07, 16 clear to 18, 19
setcolor( "R/R" )     ; @ 07, 20 clear to 18, 23
setcolor( "RB/RB" )   ; @ 07, 24 clear to 18, 27
setcolor( "GR/GR" )   ; @ 07, 28 clear to 18, 31
setcolor( "W/W" )     ; @ 07, 32 clear to 18, 35
setcolor( "N+*/N" )   ; @ 07, 36 clear to 18, 39
setcolor( "B+*/B" )   ; @ 07, 40 clear to 18, 43
setcolor( "G+*/G" )   ; @ 07, 44 clear to 18, 47
setcolor( "BG+*/BG" ) ; @ 07, 48 clear to 18, 51
setcolor( "R+*/R" )   ; @ 07, 52 clear to 18, 55
setcolor( "RB+*/RB" ) ; @ 07, 56 clear to 18, 59
setcolor( "GR+*/GR" ) ; @ 07, 60 clear to 18, 63
setcolor( "W+*/W" )   ; @ 07, 64 clear to 18, 67

setcolor( "N/N" )     ; @ 07, 68 clear to 18, 71
setcolor( "B/B" )     ; @ 07, 72 clear to 18, 75

win( 09, 17, 15, 63, "Teste da Sombra" )
setcolor( "N*/W" )

@ 11, 27 say "Veja como o efeito de sombra"
@ 12, 27 say "da Visual Lib se aproxima do"
@ 13, 27 say "    padrÆo real das cores."

WaitState()     //VL-Aqui, apenas esperamos uma tecla ou um click do mouse

RstEnv( aEnv )
return nil





***************
function PRODIET
***************

   LOCAL oExcel, oAS
   LOCAL cServer := "localhost:"
   LOCAL cDatabase
   LOCAL cUser := "SYSDBA"
   LOCAL cPass := "masterkey"
   LOCAL nPageSize := 1024
   LOCAL cCharSet := "ASCII"
   LOCAL nDialect := 3
   LOCAL cQuery, cName

   TRY
      oExcel := GetActiveObject( "Excel.Application" )
   CATCH
      TRY
         oExcel := CreateObject( "Excel.Application" )
      CATCH
         Alert( "ERROR! Excel not avialable. [" + Ole2TxtError()+ "]" )
         RETURN
      END
   END

fecha_arq()

if file("ANESTLE.CDX")
  erase("ANESTLE.CDX")
endif

if file("ANESTI.CDX")
  erase("ANESTI.CDX")
endif

if file("ANESTV.CDX")
  erase("ANESTV.CDX")
endif

select 0
use &_PATH_\USR\ESTOQUE\ANESTLE exclusive
zap
index on PCAMAT to ANESTLE

seexistesql("ANFS01")
cSQL := "SELECT first 1 * from ANFS01"
dbusearea(.t.,"SQLMIX",cSQL,"ANFS01")
cria_dbf("ANESTI")  // CRIA DBF A PARTIR DO ARQUIVO ABERTO COM O NOME INDICADO
select 0
use ANESTI
index on str(NFSMAT,6) to ANESTI


select ANFS01
copy stru to ANESTV  // VENDAS

select 0
use ANESTV
index on str(NFSMAT,6) to ANESTV


M_DATA1 = ctod("  /  /  ")
M_DATA2 = ctod("  /  /  ")


nbox(14, 41, 17, 77,"W/W+",.t.)
setcolor("B/W")

@ 15, 42 say                  "   Data Emissao Inicial:            "
@ 16, 42 say                  "                  Final:            "
SetColor(_COREDICAO_)
@ 15, 67 get M_DATA1  valid !empty(M_DATA1)
@ 16, 67 get M_DATA2  valid !empty(M_DATA2)
read
set color to

if lastkey() = 27
   return ""
endif

nLin = 2

cSql  = "SELECT  ACLI00.CLICOD,"
cSql += "        char_length( TRIM(ACLI00.clicgc1)) as CPF,"
cSql += "        ACLI00.CLINOM,"
cSql += "        APCA00.PCADES,"
cSql += "        ANFS01.NFSMAT,"
cSql += "        SUM(ANFS01.NFSQDE) as NFSQDE FROM ANFS00"
cSql += "    left outer join ANFS01 ON ANFS01.NFSEMP = ANFS00.NFSEMP"
cSql += "                          and ANFS01.NFSNUM = ANFS00.NFSNUM"
cSql += "                          and ANFS01.NFSSER = ANFS00.nfsser"
cSql += "    left outer join APCA00 ON APCA00.PCAMAT = ANFS01.NFSMAT"
cSql += "    left outer join ACLI00 ON ACLI00.CLICOD = ANFS00.NFSCLI"
cSql += "    where APCA00.PCAFOR = 861"
cSql += "    and ANFS00.NFSDTE BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2))
cSql += "    and ANFS00.NFSEMP in (1,10,2)"
cSql += "    and ANFS00.nfscan not in ('C','D')"
cSql += "    and ANFS00.NFSNATN <> '5.929'"
cSql += " "
cSql += "    GROUP BY ACLI00.CLICOD, ACLI00.CLINOM, APCA00.PCADES, ANFS01.NFSMAT,ACLI00.CLICGC1"
cSql += "    UNION ALL"
cSql += " "
cSql += "SELECT  ACLI00.CLICOD,"
cSql += "        char_length( TRIM(ACLI00.clicgc1)) as CPF,"
cSql += "        ACLI00.CLINOM,"
cSql += "        APCA00.PCADES,"
cSql += "        ACUP01.CUPMAT,"
cSql += "        SUM(ACUP01.CUPQDE) as NFSQDE FROM ACUP00"
cSql += "    left outer join ACUP01 ON ACUP01.CUPEMP = ACUP00.CUPEMP"
cSql += "                          and ACUP01.CUPNUM = ACUP00.CUPNUM"
cSql += "                          and ACUP01.CUPSER = ACUP00.CUPSER"
cSql += "    left outer join APCA00 ON APCA00.PCAMAT = ACUP01.CUPMAT"
cSql += "    left outer join ACLI00 ON ACLI00.CLICOD = ACUP00.CUPCLI"
cSql += "    where APCA00.PCAFOR = 861"
cSql += "    and ACUP00.CUPDTE BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2))
cSql += "    and ACUP00.CUPEMP in (1,10,2)"
cSql += "    and ACUP00.CUPCAN in ('E')"
cSql += "    GROUP BY ACLI00.CLICOD, ACLI00.CLINOM, APCA00.PCADES, ACUP01.CUPMAT, ACLI00.CLICGC1"
cSql += " "
cSql += "ORDER by 2 descending ,1,5"

*set print on
*set printer to "pro.sql"
*? csql
*set printer to
*set print off

dbusearea(.t.,"SQLMIX",cSQL,"ANFS00")
go top

cria_dbf("PRODIE")  // CRIA DBF A PARTIR DO ARQUIVO ABERTO COM O NOME INDICADO
select 0
use PRODIE
index on descend(str(CPF,6)) to PRODIE

select ANFS00

do while !eof()
*  msw(str(CPF))
  if !str(CPF,2) == "15"
    replace CLICOD WITH 999999

    select ANESTLE
    if !dbseek(ANFS00->NFSMAT)
       append blank
       replace PCAMAT with ANFS00->NFSMAT
    endif
    replace SLD30 with SLD30 + ANFS00->NFSQDE
  endif
  select ANFS00
  skip
enddo

select ANFS00
go top
do while !eof()
  select PRODIE
  append blank
  replace CLICOD with ANFS00->CLICOD
  replace CPF with ANFS00->CPF
  replace CLINOM with ANFS00->CLINOM
  replace PCADES with ANFS00->PCADES
  replace NFSMAT with ANFS00->NFSMAT
  replace NFSQDE with ANFS00->NFSQDE

  select ANFS00
  skip

enddo

select PRODIE

****** NUTRI NOVA


cSql  = "SELECT  ACLI00.CLICOD,"
cSql += "        char_length( TRIM(ACLI00.clicgc1)) as CPF,"
cSql += "        ACLI00.CLINOM,"
cSql += "        APCA00.PCADES,"
cSql += "        ANFS01.NFSMAT,"
cSql += "        SUM(ANFS01.NFSQDE) as NFSQDE FROM ANFS00"
cSql += "    left outer join ANFS01 ON ANFS01.NFSEMP = ANFS00.NFSEMP"
cSql += "                          and ANFS01.NFSNUM = ANFS00.NFSNUM"
cSql += "                          and ANFS01.NFSSER = ANFS00.nfsser"
cSql += "    left outer join APCA00 ON APCA00.PCAMAT = ANFS01.NFSMAT"
cSql += "    left outer join ACLI00 ON ACLI00.CLICOD = ANFS00.NFSCLI"
cSql += "    where APCA00.PCAFOR = 61"
cSql += "    and ANFS00.NFSDTE BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2))
cSql += "    and ANFS00.NFSEMP in (1,10,2)"
cSql += "    and ANFS00.nfscan not in ('C','D')"
cSql += "    and ANFS00.NFSNATN <> '5.929'"
cSql += " "
cSql += "    GROUP BY ACLI00.CLICOD, ACLI00.CLINOM, APCA00.PCADES, ANFS01.NFSMAT,ACLI00.CLICGC1"
cSql += "    UNION ALL"
cSql += " "
cSql += "SELECT  ACLI00.CLICOD,"
cSql += "        char_length( TRIM(ACLI00.clicgc1)) as CPF,"
cSql += "        ACLI00.CLINOM,"
cSql += "        APCA00.PCADES,"
cSql += "        ACUP01.CUPMAT,"
cSql += "        SUM(ACUP01.CUPQDE) as NFSQDE FROM ACUP00"
cSql += "    left outer join ACUP01 ON ACUP01.CUPEMP = ACUP00.CUPEMP"
cSql += "                          and ACUP01.CUPNUM = ACUP00.CUPNUM"
cSql += "                          and ACUP01.CUPSER = ACUP00.CUPSER"
cSql += "    left outer join APCA00 ON APCA00.PCAMAT = ACUP01.CUPMAT"
cSql += "    left outer join ACLI00 ON ACLI00.CLICOD = ACUP00.CUPCLI"
cSql += "    where APCA00.PCAFOR = 61"
cSql += "    and ACUP00.CUPDTE BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2))
cSql += "    and ACUP00.CUPEMP in (1,10,2)"
cSql += "    and ACUP00.CUPCAN in ('E')"
cSql += "    GROUP BY ACLI00.CLICOD, ACLI00.CLINOM, APCA00.PCADES, ACUP01.CUPMAT, ACLI00.CLICGC1"
cSql += " "
cSql += "ORDER by 2 descending ,1,5"


//_PATHSQL_ = "localhost/3050:C:\dados\INOVA.fdb"

_PATHSQL_ = "192.168.15.88/3050:C:\dados\INOVA.fdb"

cAttributes:="Server=;Database=" + _PATHSQL_ + ";User=SYSDBA;Password=masterkey;Driver={Firebird/InterBase(r) driver};DIALECT=3"
db2 := FBConnect(_PATHSQL_, "SYSDBA", "masterkey")
qry := FBQuery( db2, CSQL, nDialect)


   IF HB_ISARRAY( qry )
      DO WHILE FBFetch( qry ) == 0
        select PRODIE
        append blank

        replace CLICOD with val(FBGetdata( qry, 1 ))
        replace CPF    with val(FBGetdata( qry, 2 ))
        replace CLINOM with FBGetdata( qry, 3 )
        replace PCADES with FBGetdata( qry, 4 )
        replace NFSMAT with val(FBGetdata( qry, 5 ))
        replace NFSQDE with val(FBGetdata( qry, 6 ))

*        if !alltrim(FBGetdata( qry, 2 )) == "15"
*          replace CLICOD WITH 999999

*          select ANESTLE
*          if !dbseek(FBGetdata( qry, 5 ))
*             append blank
*             replace PCAMAT with FBGetdata( qry, 5 )
*          endif
*          replace SLD30 with SLD30 + FBGetdata( qry, 6)
*        endif

*         @ 15, 10 SAY FBGetdata( qry, 1 )
*         @ 16, 10 SAY FBGetdata( qry, 2 )
*         @ 17, 10 SAY FBGetdata( qry, 3 )
*         @ 18, 10 SAY FBGetdata( qry, 4 )
*         @ 19, 10 SAY FBGetdata( qry, 5 )
*         @ 20, 10 SAY FBGetdata( qry, 6 )

*         AAdd( result, FBGetdata( qry, 1 ) )
 *        INKEY(0)
      ENDDO

      FBFree( qry )
    endif

SELECT ANFS00

select PRODIE
go top

   oExcel:WorkBooks:Add()
   oAS := oExcel:ActiveSheet()
   oAS:Cells:Font:Name := "Arial"
   oAS:Cells:Font:Size := 12

   oAS:Cells( 1, 1 ):Value := "RELATÓRIO MOVIMENTO DE VENDAS - PERIODO DE " + dtoc(M_DATA1) + " A " + dtoc(M_DATA2)
   oAS:Cells( 1, 1 ):Font:Size := 14
   oAS:Range( "A1:F1" ):HorizontalAlignment := 3
   oAS:Range( "A1:F1" ):merge()

   oAS:Cells( 2, 1 ):Font:Size := 14
   oAS:Cells( 2, 1 ):Value := "EMPRESA :-  CIRURCENTER PRODUTOS HOSPITALARES LTDA"
   oAS:Range( "A2:F2" ):HorizontalAlignment := 3
   oAS:Range( "A2:F2" ):merge()
   oAS:Range( "A2:F2" ):Font:Bold = .t.

   oAS:Cells[ 1, 4 ] := "Distribuidor"
   oAS:Cells[ 2, 4 ] := "Data"
   oAS:Cells[ 3, 4 ] := "Órgão"
   oAS:Cells[ 4, 4 ] := "Produto"
   oAS:Cells[ 5, 4 ] := "Qtde"
   oAS:Range( "A4:E4" ):HorizontalAlignment := 3
   oAS:Range( "A4:F4" ):Font:Bold = .t.

   oAS:Cells[ 1, 5 ] := "Cirurcenter"
   oAS:Range( "A5:F5" ):Font:Bold = .t.

   nLin = 6

   M_CLICOD = 0

       do while !eof()

         if M_CLICOD # CLICOD
            nLin = nLin + 1

            if CPF # 15
              oAS:Cells[ 3, nLin ]:Value := "CONSUMIDOR"
            else
              oAS:Cells[ 3, nLin ]:Value := alltrim(CLINOM)
            endif
            oAS:Cells[ 3, nLin ]:Font:Bold = .t.
            M_CLICOD = CLICOD
         endif

         if CPF # 15
           select ANESTLE
           go top
           do while !eof()
             BUSCAREGISTRO("APCA00",1,{str(ANESTLE->PCAMAT,6,0)},"SELECT")
             select ANESTLE

             oAS:Cells[ 4, nLin ]:Value := APCA00->PCADES
             oAS:Cells[ 5, nLin ]:Value := STR(SLD30,5)

             nLin = nLin + 1
             skip
           enddo
           exit
         else
            oAS:Cells[ 4, nLin ]:Value := PCADES
            oAS:Cells[ 5, nLin ]:Value := STR(NFSQDE,5)

            nLin = nLin + 1

         endif

         select PRODIE
         skip

        enddo


  oAS:Columns( 1 ):AutoFit()
  oAS:Columns( 2 ):AutoFit()
  oAS:Columns( 3 ):AutoFit()
  oAS:Columns( 4 ):AutoFit()
  oAS:Columns( 5 ):AutoFit()
  oAS:Columns( 6 ):AutoFit()
  oAS:Columns( 7 ):AutoFit()
  oAS:Columns( 8 ):AutoFit()
  oAS:Columns( 9 ):AutoFit()
  oAS:Columns( 10):AutoFit()
  oAS:Columns( 11):AutoFit()
  oAS:Columns( 12):AutoFit()
  oAS:Columns( 13):AutoFit()

  oExcel:Visible := .T.




***************
function NESTLESALDO
***************


* _PATHSQL_  = "localhost/3060:C:\dados\CIRUR.fdb"  // local
* _PATHSQL_ = "fbserver.com.br/9249:/firebird/db/icm1633/inova.fdb"

* cAttributes:="Server=;Database=" + _PATHSQL_ + ";User=SYSDBA;Password=masterkey;Driver={Firebird/InterBase(r) driver};DIALECT=3"

*oCn := TOLEAUTO():New("ADODB.Connection")
*oCn:ConnectionString := cAttributes
*oCn:Open()

*
*oRs := TOLEAUTO():New("ADODB.RecordSet")
*cSql := "SELECT * from aemp00"
*oRs:open( cSql,oCn )

*oRS:MoveFirst()


*do while !oRS:EOF()
*  msg((oRS:Fields("EMPNOM"):value))
*oRS:Fields("nome"):value := "ACME Inc."
*oRS:Update()
*endi
*  oRS:MoveNext()
*enddo
*oRS:Close()
*oCn:Close()


if !AEMP00->EMPCGC == "037623347000109" // NUTRI INOVA
  msg("somente gerar na Nutri Inova")
  return ""
endif


xNome = AEMP00->EMPNOM // "Cirurcenter Produtos Hospitalares LTDA"
xSold = AEMP00->EMPSOLD // 6652328
xKey  = AEMP00->EMPKEY // "991031AA-DE65-45CC-8E0C-1AAA4BFA53C8"

fecha_arq()

set century on
store substr(dtoc(date()), 4, 7) to M_PROEXE
set century off

sombra(13, 25, 16, 49,_SOMBRA_)

set color to GR+/W
@ 13, 25 say "                           "
@ 15, 25 say "      Referencia:          "
@ 16, 25 say "                           "
set color to

@ 15, 43 get     M_PROEXE valid vekar5()
read

if lastkey() = 27
  return ""
endif

nDialect = 3
M_MES    = substr(M_PROEXE, 1, 2)
M_ANO    = substr(M_PROEXE, 4, 4)
M_DTA1 = ctod("01/" + M_PROEXE)
M_DTA2 = lastday(M_DTA1) + 1


*set print on
*set printer to "SALDO2025.TXT"

cSQL := "SELECT * FROM NESTLE"
dbusearea(.t.,"SQLMIX",cSQL,"NESTLE")

_PATHSQL_ = "localhost/3050:C:\dados\CIRUR.fdb"
cAttributes:="Server=;Database=" + _PATHSQL_ + ";User=SYSDBA;Password=masterkey;Driver={Firebird/InterBase(r) driver};DIALECT=3"
db1 := FBConnect(_PATHSQL_, "SYSDBA", "masterkey")

do while !eof()

  M_VENDAMES = 0
  M_VENDAS = 0
  M_COMPRA = 0

  if BUSCAREGISTRO("AANO00",1,{str(ME_EMP, 2, 0),NESTLE->A,M_ANO},"SELECT")
    for ABC = 1 to 12  // pegamos todos os meses
      X_MES = strzero(ABC,2)
      M_VENDAS += iif(HB_ISNIL(ANOQDS&X_MES),0,ANOQDS&X_MES)
      M_COMPRA += iif(HB_ISNIL(ANOQDE&X_MES),0,ANOQDE&X_MES)
      if X_MES = M_MES
        M_VENDAMES += iif(HB_ISNIL(ANOQDS&X_MES),0,ANOQDS&X_MES)
      endif
    next
  endif

  // aqui ja pegamos das 2 empresas empresa 1 e 10



  CSQL = "SELECT * FROM AANO00 WHERE ANOFAB = " + NESTLE->A + " and ANONUM = " + M_ANO + " and ANOEMP = 1"
  qry := FBQuery( db1, CSQL, nDialect)

  IF HB_ISARRAY( qry )
    DO WHILE FBFetch( qry ) == 0
      for ABC = 4 to 15  // pegamos todos os meses
        M_VENDAS += iif(HB_ISNIL(FBGetdata( qry, ABC )),0,val(FBGetdata( qry, ABC )))
      next

      M_VENDAMES += iif(HB_ISNIL(FBGetdata( qry, val(M_MES)+3 )),0,val(FBGetdata( qry, val(M_MES)+3 )))

      for ABC = 16 to 27  // pegamos todos os meses
        M_COMPRA += iif(HB_ISNIL(FBGetdata( qry, ABC )),0,val(FBGetdata( qry, ABC )))
      next
    ENDDO
  ENDIF
  FBFree( qry )

  CSQL = "SELECT * FROM AANO00 WHERE ANOFAB = " + NESTLE->A + " and ANONUM = " + M_ANO + " and ANOEMP = 10"
  qry := FBQuery( db1, CSQL, nDialect)

  IF HB_ISARRAY( qry )
    DO WHILE FBFetch( qry ) == 0
      for ABC = 4 to 15  // pegamos todos os meses
        M_VENDAS += iif(HB_ISNIL(FBGetdata( qry, ABC )),0,val(FBGetdata( qry, ABC )))
      next

      M_VENDAMES += iif(HB_ISNIL(FBGetdata( qry, val(M_MES)+3 )),0,val(FBGetdata( qry, val(M_MES)+3 )))

      for ABC = 16 to 27  // pegamos todos os meses
        M_COMPRA += iif(HB_ISNIL(FBGetdata( qry, ABC )),0,val(FBGetdata( qry, ABC )))
      next
    ENDDO
  ENDIF
  FBFree( qry )

  M_SALDO = NESTLE->SLD2025 + M_COMPRA - M_VENDAS

  M_DIAEST = int(M_SALDO/M_VENDAMES)

  msw(NESTLE->B)

  M_PRO = '{"secrectKeyDistribuidora":"' + xKey + '",'
  M_PRO = M_PRO + '"soldDistribuidor":' + str(xSold,7) + ","
  M_PRO = M_PRO + '"grupoDistribuidor":"Nutri Inova",'
  M_PRO = M_PRO + '"nomeDistribuidor":"' +  xNOME  + '",'
  M_PRO = M_PRO + '"periodoRef":"' + FORDTA(M_DTA2) + '",'

  M_PRO = M_PRO + '"produtos":['
  M_PRO = M_PRO + '{"codProdutoNestle_CodEAN":' +  alltrim(NESTLE->A) + ","
  M_PRO = M_PRO + '"nomeProduto":"' + NESTLE->B + '",'
  M_PRO = M_PRO + '"unidades":' + str(M_SALDO,6) + ","
  M_PRO = M_PRO + '"unidadeMedida":"' + alltrim(NESTLE->D) + '",'
  M_PRO = M_PRO + '"diasDeEstoque":'+ str(M_DIAEST,3) + ","
  M_PRO = M_PRO + '"fator":1}'

  M_PRO = M_PRO + ']}'

* set print on
* set printer to "NESTLE.TXT"
* ? M_PRO
* set printer to
 *set print off

* if 1 = 2
  URLGRA  = 'https://apinestleselloutintegracaoprod.magically.com.br/api/Inventario'
  oHttp1:= CreateObject( 'Msxml2.ServerXMLHTTP.6.0' )

  oHttp1:Open( "POST",URLGRA, .f. )
  oHttp1:setRequestHeader('Accept','application/json')
  oHttp1:setRequestHeader('x-api-version','1.0')
  oHttp1:setRequestHeader('Content-Type','application/json-patch+json')
  oHttp1:Send(M_PRO)

  IF oHttp1:status != 200
    IF oHttp1:status = 400  // nenhum pedido encontrado
      lTempedido = .f.
    else
      alert( Alltrim(Str(oHttp1:status)) +" - "+ oHttp1:statusText , "Erro na requisição")
      RETURN NIL
    endif
  ENDIF
* endif
 
  select NESTLE
  skip

  *MSW(Str(oHttp1:status))
  *alert(oHttp1:statusText)

enddo



***************
function GERASALDO
***************

altd()
* _PATHSQL_  = "localhost/3060:C:\dados\CIRUR.fdb"  // local
* _PATHSQL_ = "fbserver.com.br/9249:/firebird/db/icm1633/inova.fdb"

*cAttributes:="Server=;Database=" + _PATHSQL_ + ";User=SYSDBA;Password=masterkey;Driver={Firebird/InterBase(r) driver};DIALECT=3"

*oCn := TOLEAUTO():New("ADODB.Connection")
*oCn:ConnectionString := cAttributes
*oCn:Open()


*oRs := TOLEAUTO():New("ADODB.RecordSet")
*cSql := "SELECT * from aemp00"
*oRs:open( cSql,oCn )

*oRS:MoveFirst()


*do while !oRS:EOF()
*  msg((oRS:Fields("EMPNOM"):value))
*oRS:Fields("nome"):value := "ACME Inc."
*oRS:Update()
*endi
*  oRS:MoveNext()
*enddo
*oRS:Close()
*oCn:Close()

if !AEMP00->EMPCGC == "037623347000109" // NUTRI INOVA
  msg("somente gerar na Nutri Inova")
  return ""
endif

xNome = AEMP00->EMPNOM // "Cirurcenter Produtos Hospitalares LTDA"
xSold = AEMP00->EMPSOLD // 6652328
xKey  = AEMP00->EMPKEY // "991031AA-DE65-45CC-8E0C-1AAA4BFA53C8"

fecha_arq()

set century on
store substr(dtoc(date()), 4, 7) to M_PROEXE
set century off

sombra(13, 25, 16, 49,_SOMBRA_)

set color to GR+/W
@ 13, 25 say "                           "
@ 15, 25 say "      Referencia:          "
@ 16, 25 say "                           "
set color to

@ 15, 43 get     M_PROEXE valid vekar5()
read

if lastkey() = 27
  return ""
endif

nDialect = 3
M_MES    = substr(M_PROEXE, 1, 2)
M_ANO    = substr(M_PROEXE, 4, 4)
M_DTA1 = ctod("01/" + M_PROEXE)
M_DTA2 = lastday(M_DTA1) + 1

cSQL := "SELECT * FROM NESTLE"
dbusearea(.t.,"SQLMIX",cSQL,"NESTLE")

_PATHSQL_ = "localhost/3060:C:\dados\CIRUR.fdb"
cAttributes:="Server=;Database=" + _PATHSQL_ + ";User=SYSDBA;Password=masterkey;Driver={Firebird/InterBase(r) driver};DIALECT=3"
db1 := FBConnect(_PATHSQL_, "SYSDBA", "masterkey")

select NESTLE

do while !eof()

  M_VENDAMES = 0
  M_VENDAS = 0
  M_COMPRA = 0

  if BUSCAREGISTRO("AANO00",1,{str(ME_EMP, 2, 0),NESTLE->A,M_ANO},"SELECT")
    for ABC = 1 to 12  // pegamos todos os meses
      X_MES = strzero(ABC,2)
      M_VENDAS += iif(HB_ISNIL(ANOQDS&X_MES),0,ANOQDS&X_MES)
      M_COMPRA += iif(HB_ISNIL(ANOQDE&X_MES),0,ANOQDE&X_MES)
      if X_MES = M_MES
        M_VENDAMES += iif(HB_ISNIL(ANOQDS&X_MES),0,ANOQDS&X_MES)
      endif
    next
  endif

  // aqui ja pegamos das 2 empresas empresa 1 e 10

  CSQL = "SELECT * FROM AANO00 WHERE ANOFAB = " + NESTLE->A + " and ANONUM = " + M_ANO + " and ANOEMP = 1"
  qry := FBQuery( db1, CSQL, nDialect)

  IF HB_ISARRAY( qry )
    DO WHILE FBFetch( qry ) == 0
      for ABC = 4 to 15  // pegamos todos os meses
        M_VENDAS += iif(HB_ISNIL(FBGetdata( qry, ABC )),0,val(FBGetdata( qry, ABC )))
      next

      M_VENDAMES += iif(HB_ISNIL(FBGetdata( qry, val(M_MES)+3 )),0,val(FBGetdata( qry, val(M_MES)+3 )))

      for ABC = 16 to 27  // pegamos todos os meses
        M_COMPRA += iif(HB_ISNIL(FBGetdata( qry, ABC )),0,val(FBGetdata( qry, ABC )))
      next
    ENDDO
  ENDIF
  FBFree( qry )

  CSQL = "SELECT * FROM AANO00 WHERE ANOFAB = " + NESTLE->A + " and ANONUM = " + M_ANO + " and ANOEMP = 10"
  qry := FBQuery( db1, CSQL, nDialect)

  IF HB_ISARRAY( qry )
    DO WHILE FBFetch( qry ) == 0
      for ABC = 4 to 15  // pegamos todos os meses
        M_VENDAS += iif(HB_ISNIL(FBGetdata( qry, ABC )),0,val(FBGetdata( qry, ABC )))
      next

      M_VENDAMES += iif(HB_ISNIL(FBGetdata( qry, val(M_MES)+3 )),0,val(FBGetdata( qry, val(M_MES)+3 )))

      for ABC = 16 to 27  // pegamos todos os meses
        M_COMPRA += iif(HB_ISNIL(FBGetdata( qry, ABC )),0,val(FBGetdata( qry, ABC )))
      next
    ENDDO
  ENDIF
  FBFree( qry )


  M_SALDO = val(NESTLE->C) + M_COMPRA - M_VENDAS

  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"NESTLE","UPDATE"}
  aadd(sqlCHAVE,{"A",NESTLE->A})
  aadd(sqlCAMPO,{"SLD2024",str(M_SALDO,7),.t.})
  executasql()

  select NESTLE
  skip

  *MSW(Str(oHttp1:status))
  *alert(oHttp1:statusText)

enddo




*******************
function SALDOEXCEL
*******************


if !AEMP00->EMPCGC == "037623347000109" // NUTRI INOVA
  msg("somente gerar na Nutri Inova")
  return ""
endif


xNome = AEMP00->EMPNOM // "Cirurcenter Produtos Hospitalares LTDA"
xSold = AEMP00->EMPSOLD // 6652328
xKey  = AEMP00->EMPKEY // "991031AA-DE65-45CC-8E0C-1AAA4BFA53C8"

fecha_arq()

set century on
store substr(dtoc(date()), 4, 7) to M_PROEXE
set century off

sombra(13, 25, 16, 49,_SOMBRA_)

set color to GR+/W
@ 13, 25 say "                           "
@ 15, 25 say "      Referencia:          "
@ 16, 25 say "                           "
set color to

@ 15, 43 get     M_PROEXE valid vekar5()
read

if lastkey() = 27
  return ""
endif

nDialect = 3
M_MES    = substr(M_PROEXE, 1, 2)
M_ANO    = substr(M_PROEXE, 4, 4)
M_DTA1 = ctod("01/" + M_PROEXE)
M_DTA2 = lastday(M_DTA1) + 1

cSQL := "SELECT * FROM NESTLE"
dbusearea(.t.,"SQLMIX",cSQL,"NESTLE")

_PATHSQL_ = "localhost/3050:C:\dados\CIRUR.fdb"
cAttributes:="Server=;Database=" + _PATHSQL_ + ";User=SYSDBA;Password=masterkey;Driver={Firebird/InterBase(r) driver};DIALECT=3"
db1 := FBConnect(_PATHSQL_, "SYSDBA", "masterkey")

set print on
set printer to "SALDO.TXT"

? "PERIODO    CODIGO NESTLE DESCRICAO                                  UN     QUANTIDADE"

do while !eof()

  M_VENDAMES = 0
  M_VENDAS = 0
  M_COMPRA = 0

  if BUSCAREGISTRO("AANO00",1,{str(ME_EMP, 2, 0),NESTLE->A,M_ANO},"SELECT")
    for ABC = 1 to 12  // pegamos todos os meses
      X_MES = strzero(ABC,2)
      M_VENDAS += iif(HB_ISNIL(ANOQDS&X_MES),0,ANOQDS&X_MES)
      M_COMPRA += iif(HB_ISNIL(ANOQDE&X_MES),0,ANOQDE&X_MES)
      if X_MES = M_MES
        M_VENDAMES += iif(HB_ISNIL(ANOQDS&X_MES),0,ANOQDS&X_MES)
      endif
    next
  endif

  // aqui ja pegamos das 2 empresas empresa 1 e 10



  CSQL = "SELECT * FROM AANO00 WHERE ANOFAB = " + NESTLE->A + " and ANONUM = " + M_ANO + " and ANOEMP = 1"
  qry := FBQuery( db1, CSQL, nDialect)

  IF HB_ISARRAY( qry )
    DO WHILE FBFetch( qry ) == 0
      for ABC = 4 to 15  // pegamos todos os meses
        M_VENDAS += iif(HB_ISNIL(FBGetdata( qry, ABC )),0,val(FBGetdata( qry, ABC )))
      next

      M_VENDAMES += iif(HB_ISNIL(FBGetdata( qry, val(M_MES)+3 )),0,val(FBGetdata( qry, val(M_MES)+3 )))

      for ABC = 16 to 27  // pegamos todos os meses
        M_COMPRA += iif(HB_ISNIL(FBGetdata( qry, ABC )),0,val(FBGetdata( qry, ABC )))
      next
    ENDDO
  ENDIF
  FBFree( qry )

  CSQL = "SELECT * FROM AANO00 WHERE ANOFAB = " + NESTLE->A + " and ANONUM = " + M_ANO + " and ANOEMP = 10"
  qry := FBQuery( db1, CSQL, nDialect)

  IF HB_ISARRAY( qry )
    DO WHILE FBFetch( qry ) == 0
      for ABC = 4 to 15  // pegamos todos os meses
        M_VENDAS += iif(HB_ISNIL(FBGetdata( qry, ABC )),0,val(FBGetdata( qry, ABC )))
      next

      M_VENDAMES += iif(HB_ISNIL(FBGetdata( qry, val(M_MES)+3 )),0,val(FBGetdata( qry, val(M_MES)+3 )))

      for ABC = 16 to 27  // pegamos todos os meses
        M_COMPRA += iif(HB_ISNIL(FBGetdata( qry, ABC )),0,val(FBGetdata( qry, ABC )))
      next
    ENDDO
  ENDIF
  FBFree( qry )

  M_SALDO = NESTLE->SLD2025 + M_COMPRA - M_VENDAS

  M_DIAEST = int(M_SALDO/M_VENDAMES)

  msw(NESTLE->B)

  ? dtoc(M_DTA2) + ";"
  ?? alltrim(NESTLE->A) + ";"
  ?? NESTLE->B + ";"
  ?? alltrim(NESTLE->D) + ";"
  ?? str(M_SALDO,6) + ";"

  select NESTLE
  skip

enddo

set print off
set printer to
