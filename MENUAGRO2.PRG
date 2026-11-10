
// ARQUIVOS MORTO APCMOR VAI SER GRAVADO JUNTO COM O APCA00


// CHAMAR CALENDARIO NA DATA
// @ 10, 29 get M_LANDTA  F2 color _CORF2_ funcao "pegadata(10,29,@M_LANDTA)" retorno "re"



#include    'inkey.ch'
#include   'common.ch'
#include   'wvtwin.ch'
#include "hbgtinfo.ch"

#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)
#xtranslate ISNIL( <xValue> )       => HB_ISNIL( <xValue> )

//-------------------------------------------------------------------//
//
//   WvtSetObjects() array structure
//
#define WVT_OBJ_TYPE               1
#define WVT_OBJ_ID                 2
#define WVT_OBJ_ROW                3
#define WVT_OBJ_COL                4
#define WVT_OBJ_ROWTO              5
#define WVT_OBJ_COLTO              6
#define WVT_OBJ_ONDISP             7
#define WVT_OBJ_ONMOUSEOVER        8
#define WVT_OBJ_ONBUTTONDOWN       9
#define WVT_OBJ_ONBUTTONUP        10
#define WVT_OBJ_TOOLTIP           11
#define WVT_OBJ_STATE             12
#define WVT_OBJ_DUMMY             13
#define ALTD_DISABLE   0
#define ALTD_ENABLE    1
#define WVT_OBJ_VRBLS             13

//   WVT_OBJ_TYPE  Constants
//
#define OBJ_TYPE_BUTTON            1

//   WVT_OBJ_STATE
//
#define OBJ_STATE_HIDE             0
#define OBJ_STATE_DISP             1
#define OBJ_STATE_MOUSEOVER        2
#define OBJ_STATE_BUTTONDOWN       3
#define OBJ_STATE_BUTTONUP         4

//-------------------------------------------------------------------//

#define  IMAGE_VOUCH          'vouch1.bmp'
#define  IMAGE_BROWSE         'v_browse.ico'
#define  IMAGE_VR             'vr_1.ico'
#define  IMAGE_NOTES          'v_notes.ico'
#define  IMAGE_TOOLS          'v_tools.ico'
#define  IMAGE_HELP           'v_notes.ico'

//-------------------------------------------------------------------//
//
//   Candidate for inkey.ch
//
#define K_SBLINEUP              1051
#define K_SBLINEDOWN            1052
#define K_SBPAGEUP              1053
#define K_SBPAGEDOWN            1054

#define K_SBLINELEFT            1055
#define K_SBLINERIGHT           1056
#define K_SBPAGELEFT            1057
#define K_SBPAGERIGHT           1058

#define K_SBTHUMBTRACKVERT      1059
#define K_SBTHUMBTRACKHORZ      1060

//-------------------------------------------------------------------//

#ifndef __SQL__
//ANNOUNCE Hb_NoStartUpWindow
#endif

//-------------------------------------------------------------------//

#define CRLF   chr( 13 )+chr( 10 )

#define DBI_QUERY             1001
#define RDDI_CONNECT          1001
#define RDDI_DISCONNECT       1002
#define RDDI_EXECUTE          1003
#define RDDI_ERROR            1004
#define RDDI_ERRORNO          1005
#define RDDI_NEWID            1006
#define RDDI_AFFECTEDROWS     1007
#define RDDI_QUERY            1008


//-------------------------------------------------------------------//

static wvtScreen := {}
static pic_:= { , , , , , , , , , , , , , , , , , , , }
static keys_:= { , , , , , , , , , , , , , , , , , , , }

static ahFonts := {}
static shIcon, shImage
static aSlides := {}

#ifdef __XCC__
static paint_:= { { '', {} } }
#endif

//-------------------------------------------------------------------//
PROCEDURE Main()

   LOCAL aLastPaint, clr, scr
   LOCAL dDate   := ctod( '' )
   LOCAL nSlry   := 20000
   LOCAL nColGet := 8
   LOCAL GetList := {}
   LOCAL nTop    := 4
   LOCAL nLft    := 4
   LOCAL nBtm    := 20
   LOCAL nRgt    := 75
   LOCAL nMaxRows:= MaxRow()
   LOCAL nBtnRow := nMaxRows - 1

   LOCAL cLabel  := '(x)Harbour simulated GUI.'
   LOCAL aObjects:= WvtSetObjects( {} )
   LOCAL hPopup
   LOCAL oMenu

set talk off
set wrap on
set date british
set delete on
set exclusive off
set scoreboard off
set epoch to 1980


handleAberto=0

aChaRegistro := { }

MenuList := {}

_PATH_INOVA_ = ""

   M_DATA = dtoc(date())
   M_LOGPRV = ""
   s_cStdColor := "N/W,N/GR*,,,N/W*"

   _path_ = "C:\CIRUR"
   _PATHSQL_  = "localhost/3050:C:\dados\INOVA.fdb"
   _PATHODBC_ = "                                 "
   cNomAberto = space(10)
   M_LOGNOM = "SILAS"
   _CORBOXLISTA_ = "_W/BG+"
   _CORLETRAS_ = "N/W*"        // COR DAS LETRAS A SEREM MOSTRADAS SAY
   _CORPROMPT_ = "r/w,W+/N"
   _SOMBRA_   = "N*/N+"
   _COREDICAO_ = "N/W,N/GR*,,,N/W*"  // "N/W,N/W*"  // COR DOS CAMPOS GET
   _CORTELAS_  = "B/W"        // COR DO FUNDO E DAS LETRAS FIXAS
   _COREDICAO_FOSCO = "N/W,N/GR"  // "N/W,N/W*"  // COR DOS CAMPOS GET
   _CORPROMPT_ = "r/w,W+/N"
   _CORF2_ = "N/W*,W+/G"
    lAltCFOP = .t.  // nao pode alterar cfop

   _SOMBRA_   = "N+"
   lPosFunpro = 0
   M_FRAME1  =  "ÚÄ¿³ÙÄÀ³ "
   M_FRAME1A =  "ÚÄ¿³ÙÄÀ³ "
   AA_SESTOQUE = { }
   AA_PROMOCAO = { }
   AA_DESCONTO = { }
   ZZ_IMPRE = space(39)
   _IMPLIS_   = "L"
   _IMPFIL_   = "LPT1"
   cCRH27E = chr(27) + "E"
   cCRH27F = chr(27) + "F"
   _EMPPRT_ = "0100"



   RDDSETDEFAULT("DBFCDX")

   cF_ATV = "MENU          "
   cF_MOD = "PRINCIPAL     "
   cF_PRG = "SIS V.4.3     "
   M_FAN = "SISTEMA INGEGRADO"

   lLog = .f.
   _FONTET_   = 31
   _FONTEL_   = 18
   _FONTEN_   = "VISUALNOVA                                         "
*   _FONTEN_   = "Courier New                                        "


    ACBrNFe_ENT = "C:\NFE\ENTNFE.TXT"
    ACBrNFe_SAI = "C:\NFE\SAINFE.TXT"
    ACBrNFe_TMP = "C:\NFE\ARQTMP.TXT"
    ACBrNFe_UNI = "C"

    M_ABBOTT = "#40702#410#"
    CSOSN_900 =  "#5.551#6.912#5.912#6.910#5.909#6.915#6.949#5.949#5.917#5.915#5.918#6.202#5.202#5.910#5.929#1.908#1.909#1.949#"
    cCFOPFORA  = "#1910#1949#1117#1912#1908#1917#1918#1906#1911#1916#1923#2910#2949#2912#2908#2923#2917#2922#2117#2916#5910#5117#5918#5949#5917#5556#5927#5911#5915#5905#6910#6117#6915#6949#6918#6908#6911#6913#" // nao altera preco
    lAge   = .f.
    lf3pro = .f.
    lf3cli = .f.
    lCriandoid = "F"
    lVeiodoF3 = .t.
    lEmitindonota = .f.
    lEditandomov = .f.
    lPoslogrestricao = 0
    lPoslogAtual = 0
    lNovaInscricao = .f.
    lReemitenfs = .f.
    lPageUp = .t.
    lAltiteped = .f.  // se alterou e deu esc esclui o item
    nUltprod = 0
    nUltClid = 0
    nUltFord = 0
    nCodRetorno = 0
    nMotivoSQL = ""   // porque deu erro no sql
    cPESQUISA = ""
    cPESQUISAFor = ""
    cPESQUISACli = ""

    cCODPESQ = 0
    
    SET( _SET_DEBUG, .T. )

   lKeyfun = .f.

   M_EMP = 1
   ME_EMP = 1
   W_LOGGER = replicate("S",750)
   lKeyfun = .f.

  _EMPRESA_  = 1
  _FUNDO_    = "B "
  _SOMBRA_   = "N+"
  _FRENTE_   = "B+"
  _INFERIOR_ = "N "
  _PROTECAO_ = "B+"
  _PATH_    = "C:\CIRUR                      "
  _LPT1_    = "\\FATURA\EPSON1                   "
  _FONTET2_   = 31
  _FONTEL2_   = 18
  _FONTEN_   = "Visualnova                       "
  M_FRAME3  =  "         "
  _NOMEMP_ = "CIRURCENTER"

if file("CONFIG.MEM")
  restore from CONFIG.MEM additive
else
   _PATHSQL_  = "localhost/3050:C:\dados\INOVA.fdb        "
   _PATHODBC_ = "                                         "
  _EMPRESA_  = 1
  _FUNDO_    = "B "
  _SOMBRA_   = "N+"
  _FRENTE_   = "B+"
  _INFERIOR_ = "N "
  _PROTECAO_ = "B+"
  _PATH_     = "C:\CIRUR        "
  _EMPPRT_   = "0100"
  _NOMEMP_   = "CIRURCENTER"
  _IMPNOR_   = "LOCAL"  // REDE OU LOCAL
  _IMPNFS_   = "LPT1"
  clear
  set color to W+/BG
    @  08, 25 , 19, 55 box "         "
  set color to
  painel(08, 26, 19, 54,"W+/BG","N/BG")
  set color to GR+/BG
   @ 09, 27 say          "Empresa Padr„o :          "
   @ 10, 27 say          "Cor de Superior:          "
   @ 11, 27 say          "Cor de Fundo   :          "
   @ 12, 27 say          "Cor de Sombra  :          "
   @ 13, 27 say          "Cor Inferior   :          "
   @ 14, 27 say          "Cor Protecao   :          "
   @ 15, 27 say          "Diret¢rio Path :          "
   @ 16, 27 say          "Empresa Ativa  :          "
   @ 17, 27 say          "Impressora NOR :          "
   @ 18, 27 say          "           NFS :          "
   @ 19, 27 say          "SQL:                      "
  set color to
  lAge = .f.
  @ 09, 44 get _EMPRESA_  picture "##"
  @ 10, 44 get _FRENTE_   picture "@!"
  @ 11, 44 get _FUNDO_    picture "@!"
  @ 12, 44 get _SOMBRA_   picture "@!"
  @ 13, 44 get _INFERIOR_ picture "@!"
  @ 14, 44 get _PROTECAO_ picture "@!"
  @ 15, 44 get _PATH_     picture "@!" valid(!empty(_PATH_))
  @ 16, 44 get _NOMEMP_   picture "@!" valid(!empty(_NOMEMP_))
  @ 17, 44 get _IMPNOR_   picture "@!" valid(_IMPNOR_ $ "LPT1#LPT2#COM1#COM2")
  @ 18, 44 get _IMPNFS_   picture "@!" valid(_IMPNFS_ $ "LPT1#LPT2#COM1#COM2")
  @ 19, 44 get _PATHSQL_     picture "@!" valid(!empty(_PATHSQL_))
  read
  save to CONFIG
endif

_PATHSQL_ = ""
_PATHODBC_ = ""


nREQEMP = 51
lNanuvem = .F.
lPaint = .t.     // se repinta o formulario ou nao

XX_LOGSEN = space(10)

_path_ = alltrim(_path_)

xx_FISEST = ""
   SET DATE BRITISH
   lSoesse = ""

SET( _SET_EVENTMASK, INKEY_ALL )
Wvt_SetMouseMove( .t. )


*TESTEMENU()

*        abre_pch("0")
*CRIADBFTOSQL(alias(),.T.)  // IMPORTADO

*cria_addsql()

lTemporefhash = seconds()
cInicIMG826 := {} // Wvt_SaveScreen(Arg4, Arg5, Local5+2, Local6+3)
aInicIMG826 := {} // {Arg4, Arg5, Local5+2, Local6+3}


   _SOMBRA_   = "W/N*"



  MyDialogLocal()

   RETURN

//-------------------------------------------------------------------//

Function HB_GTSYS()
ANNOUNCE HB_GTSYS
   REQUEST HB_GT_WVG_DEFAULT
   Return nil

//------------------------------------------------------------------//


//-------------------------------------------------------------------//

   
//-------------------------------------------------------------------//
//      Wvt_Paint() must be a FUNCTION in your application
//      as it is called when Window gets WM_PAINT message.
//-------------------------------------------------------------------//
//-------------------------------------------------------------------//
//      Wvt_SetFocus() must be a FUNCTION in your application
//      needs to process messages sent through WM_SETFOCUS message
//      received by the window.
//-------------------------------------------------------------------//
//-------------------------------------------------------------------//
//      Wvt_KillFocus() must be a FUNCTION in your application
//      needs to process messages sent through WM_KILLFOCUS message
//      received by the window.
//-------------------------------------------------------------------//
//-------------------------------------------------------------------//
//
//      Wvt_Mouse() must be present if you want to catch and fire
//      mouse call back outside of the inkey() loop.
//
//-------------------------------------------------------------------//
FUNCTION Wvt_Mouse( nKey, nRow, nCol )
   LOCAL nLen, aObjects := WvtSetObjects()
   LOCAL nObj

   STATIC nLastObj := 0
   STATIC nLastKey := 0


   if ( nLen := len( aObjects ) ) == 0
      return nil
   endif

*   if !SetMouseCheck()
*      return nil
*   endif

      msw("aqui" + str(nrow) + " " + str(ncol))

   if nKey == -1000001
      for nObj :=   1 to nLen
         DO CASE
         CASE aObjects[ nObj, WVT_OBJ_STATE ] == OBJ_STATE_DISP
            eval( aObjects[ nObj, WVT_OBJ_ONDISP ] )
         CASE aObjects[ nObj, WVT_OBJ_STATE ] == OBJ_STATE_MOUSEOVER
            eval( aObjects[ nObj, WVT_OBJ_ONMOUSEOVER ] )
         CASE aObjects[ nObj, WVT_OBJ_STATE ] == OBJ_STATE_BUTTONDOWN
            eval( aObjects[ nObj, WVT_OBJ_ONBUTTONDOWN ] )
         CASE aObjects[ nObj, WVT_OBJ_STATE ] == OBJ_STATE_BUTTONUP
            eval( aObjects[ nObj, WVT_OBJ_ONDISP ] )
         CASE aObjects[ nObj, WVT_OBJ_STATE ] == OBJ_STATE_HIDE

         ENDCASE
      next
      return nil
   endif

   nObj := ascan( aObjects, {|e_| e_[ WVT_OBJ_ROW   ] <= nRow .and. ;
                                  e_[ WVT_OBJ_ROWTO ] >= nRow .and. ;
                                  e_[ WVT_OBJ_COL   ] <= nCol .and. ;
                                  e_[ WVT_OBJ_COLTO ] >= nCol     } )
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
      if aObjects[ nLastObj, WVT_OBJ_STATE ] != OBJ_STATE_MOUSEOVER
           aObjects[ nLastObj, WVT_OBJ_STATE ] := OBJ_STATE_MOUSEOVER
         if aObjects[ nObj, WVT_OBJ_ONMOUSEOVER ] != nil
            eval( aObjects[ nObj, WVT_OBJ_ONMOUSEOVER ] )
         endif
      endif

   CASE nKey == K_LBUTTONDOWN
        aObjects[ nLastObj, WVT_OBJ_STATE ] := OBJ_STATE_BUTTONDOWN
        if aObjects[ nObj, WVT_OBJ_ONBUTTONDOWN ] != nil
           eval( aObjects[ nObj, WVT_OBJ_ONBUTTONDOWN ] )
      endif

   CASE nKey == K_LBUTTONUP
        aObjects[ nLastObj, WVT_OBJ_STATE ] := OBJ_STATE_DISP
        if aObjects[ nObj, WVT_OBJ_ONBUTTONUP ] != nil
           eval( aObjects[ nObj, WVT_OBJ_ONBUTTONUP ] )
      endif

   ENDCASE

   RETURN nil
   
   Wvt_Paint()
//-------------------------------------------------------------------//
//  WvtSetBlocks() is a get/set FUNCTION to be used by Wvt_Paint()
//-------------------------------------------------------------------//

//-------------------------------------------------------------------//
STATIC FUNCTION rgb( r,g,b )

   RETURN ( r + ( g * 256 ) + ( b * 256 * 256 ) )
//-------------------------------------------------------------------//

//-------------------------------------------------------------------//
FUNCTION SELE_ARQUIVO(fARQUIVO,FCODIGO)

   LOCAL nKey, bBlock, aLastPaint, i, info_
   LOCAL lEnd    := .f.
   LOCAL aBlocks := {}
   LOCAL nTop    :=  1
   LOCAL nLeft   :=  3
   LOCAL nBottom := 20 // maxrow() - 8
   LOCAL nRight  := maxcol() - 3
   LOCAL nCursor := setCursor( 0 )
   LOCAL nRow    := row()
   LOCAL nCol    := col()
   LOCAL cColor  := SetColor( 'N/W*,W/N+,W/R,,N/W*,GR+/BG,R+/W*' )
   LOCAL cScr0    := SaveScreen( 0,0,maxrow(),maxcol() )
   LOCAL cScr2    := wvt_SaveScreen( 0,0,maxrow(),maxcol() )
   LOCAL aObjects:= WvtSetObjects( {} )
   LOCAL cFileIndex, cFileDbf, cRDD, nIndex
   LOCAL lpri
   
   STATIC nStyle := 0

do case

  case fARQUIVO == "CBNEF"
    seexistesql("CBNEF")
    cSql := "SELECT * FROM CBNEF ORDER BY DESCRICAO"

    dbusearea(.t.,"SQLMIX",cSql,"CBNEF")
    lTampesq = len(DESCRICAO)
    lTangrade = 72
    cTitulo = "PESQUISA BENEFICIO"
                 ********
  case fARQUIVO == "AFOR00"
                 ********

    arqABERTO = "AFOR00"

*    if seaberto("AFOR00")
*    else
*      if nUltFord = 0
        seexistesql("AFOR00")
        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}

        aadd(sqlARQUI,{"AFOR00","AFOR00"})
        aadd(sqlCAMPO,"first 50 FORNOM")
        aadd(sqlCAMPO,"FORCOD")
        aadd(sqlCAMPO,"FOREND")
        aadd(sqlCAMPO,"FOREST")
        aadd(sqlCHAVE,"FORNOM <> ' '")
        aadd(sqlORDEM,"FORNOM")
 *     endif
*    endif

      aadd(sqlORDEM,"AFOR00.FORNOM")

      if !empty(cPESQUISAfor)
        aadd(sqlCHAVE,"FORNOM LIKE '" + alltrim(cPESQUISAfor) + "%'")
      else
        aadd(sqlCHAVE,"FORNOM <> ' '")
      endif

      sqlrelation()

    select AFOR00
    
    lTampesq = len(FORNOM)
    lTangrade = 72
    cTitulo = "PESQUISA FORNECEDOR"


  case fARQUIVO == "APOR00"
    seexistesql("APOR00")
    cSql := "SELECT * FROM APOR00 ORDER BY PORNOM"
    dbusearea(.t.,"SQLMIX",cSql,"APOR00")
    lTampesq = len(PORNOM)
    lTangrade = 72
    cTitulo = "PESQUISA PORTADOR"

  case fARQUIVO == "ATRA00"
    seexistesql("ATRA00")
    select ATRA00
    set order to 2
    dbseek("A",.t.)
    lTampesq = len(TRANOM)
    lTangrade = 72
    cTitulo = "PESQUISA TRANSPORTE"
    locate for !empty(TRANOM)

  case fARQUIVO == "ACPG00"
    seexistesql("ACPG00")
    cSql := "SELECT first 50 * FROM ACPG00 WHERE CPGCOD > 0 and CPGDES <> ''"
    dbusearea(.t.,"SQLMIX",cSql,"ACPG00")
    lTampesq = len(CPGDES)
    lTangrade = 60
    cTitulo = "PESQUISA PAGAMENTO"
    locate for !empty(CPGDES)

  case fARQUIVO == "AHIS00"
    seexistesql("AHIS00")
    cSql := "SELECT * FROM AHIS00 ORDER BY HISDES"
    dbusearea(.t.,"SQLMIX",cSql,"AHIS00")
    lTampesq = len(HISDES)
    lTangrade = 46
    cTitulo = "PESQUISA HISTORICO"

  case fARQUIVO == "AMUN00"
    seexistesql("AMUN00")
    cSql := "SELECT * FROM AMUN00 WHERE MUNNOM LIKE 'PRESIDENTE%' ORDER BY MUNNOM"
    dbusearea(.t.,"SQLMIX",cSql,"AMUN00")
    lTampesq = len(MUNNOM)
    lTangrade = 72
    cTitulo = "PESQUISA MUNICIPIO"

  case fARQUIVO == "ACLI00"
    arqABERTO = "ACLI00"

*    if seaberto("ACLI00P")
*    else
*     if nUltClid = 0
        seexistesql("ACLI00")
        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}

        aadd(sqlARQUI,{"ACLI00","ACLI00"})
        aadd(sqlCAMPO,"first 50 CLINOM")
        aadd(sqlCAMPO,"CLICOD")
        aadd(sqlCAMPO,"CLIEND1")
        aadd(sqlCAMPO,"CLIUF1")
        aadd(sqlCAMPO,"CLIMUN1")
        aadd(sqlCAMPO,"CLICLF")
        aadd(sqlCHAVE,"CLINOM <> ' '")
        aadd(sqlORDEM,"CLINOM")
*     endif
    *endif

      aadd(sqlORDEM,"CLINOM")

      if !empty(cPESQUISAcli)
        aadd(sqlCHAVE,"CLINOM LIKE '" + alltrim(cPESQUISAcli) + "%'")
      else
        aadd(sqlCHAVE,"CLINOM <> ' '")
      endif

      sqlrelation()

    select ACLI00

    lTampesq = len(CLINOM)
    lTangrade = 101
    cTitulo = "PESQUISA CLIENTE"

  case fARQUIVO == "APCA00"

      arqABERTO = "APCA00"

*      if seaberto("APCA00P")
*      else
*        if nUltprod = 0
          seexistesql("APCA00")
          sqlRELATION = {}
          sqlCAMPO = {}
          sqlCHAVE =  {}
          sqlARQUI = {}
          sqlORDEM = {}

          aadd(sqlARQUI,{"APCA00","APCA00"})
          aadd(sqlCAMPO,"first 50 PCADES")
          aadd(sqlCAMPO,"PCAUNI")
          aadd(sqlCAMPO,"PCAMAR")
          aadd(sqlCAMPO,"PCAMAT")

          aadd(sqlCAMPO,"COALESCE(S1.SLDDIS,0) as SALDO1")
          aadd(sqlCAMPO,"COALESCE(S2.SLDDIS,0) as SALDO2")
          aadd(sqlCAMPO,"COALESCE(S1.SLDPRC,0) as SLDPRC")


          if AEMP00->EMPCGC == "037623347000109"
            aadd(sqlRELATION,{"ASLD00 S1",str(2, 2, 0),"S1.SLDEMP"})
            aadd(sqlRELATION,{"","S1.SLDMAT","APCA00.PCAMAT"})
            aadd(sqlRELATION,{"ASLD00 S2",str(10, 2, 0),"S2.SLDEMP"})
            aadd(sqlRELATION,{"","S2.SLDMAT","APCA00.PCAMAT"})
          else
            aadd(sqlRELATION,{"ASLD00 S1",str(1, 2, 0),"S1.SLDEMP"})
            aadd(sqlRELATION,{"","S1.SLDMAT","APCA00.PCAMAT"})
            aadd(sqlRELATION,{"ASLD00 S2",str(10, 2, 0),"S2.SLDEMP"})
            aadd(sqlRELATION,{"","S2.SLDMAT","APCA00.PCAMAT"})
          endif
          
*          if !lTodospro
*            aadd(sqlCHAVE,"ATIVO = 'S'")
*          endif

*/*/*/

          aadd(sqlORDEM,"APCA00.PCADES")

          if !empty(cPESQUISA)
            aadd(sqlCHAVE,"PCADES LIKE '" + alltrim(cPESQUISA) + "%'")
          else
            aadd(sqlCHAVE,"PCADES <> ' '")
          endif

          if !sqlrelation()
             msgbox1("Erro na consulta, verifique sua pesquisa")
             Wvt_SetPen( 0 )
             WvtSetBlocks( aLastPaint )
             WvtSetObjects( aObjects )

             DevPos( nRow, nCol )
             SetColor( cColor )
             SetCursor( nCursor )

             RestScreen( 0, 0, maxrow(), maxcol(), cScr )
            return ""
          endif

          if cCODPESQ > 0
            locate for PCAMAT = cCODPESQ
          endif

 *       endif
 *     endif

    select APCA00

    lTampesq = len(PCADES)
    lTangrade = 104

    cTitulo = "PESQUISA PRODUTO"

  case fARQUIVO == "ASUB00"
    seexistesql("ASUB00")
    cSql := "SELECT first 50 * FROM ASUB00 WHERE SUBCOD > 0"
    dbusearea(.t.,"SQLMIX",cSql,"ASUB00")

    select &fARQUIVO
    locate for !empty(SUBNOM)
    lTampesq = len(SUBNOM)
    lTangrade = 45
    cTitulo = "PESQUISA SUB-GRUPO"


                   ********
  case fARQUIVO == "AGRP00"
                   ********
    seexistesql("AGRP00")
    cSql := "SELECT first 50 * FROM AGRP00 WHERE GRPCOD > 0"
    dbusearea(.t.,"SQLMIX",cSql,"AGRP00")

    select &fARQUIVO
    locate for !empty(GRPNOM)
    lTampesq = len(GRPNOM)
    lTangrade = 45
    cTitulo = "PESQUISA GRUPO"


  case fARQUIVO == "IBGE"
  case fARQUIVO == "AHIE00"
  case fARQUIVO == "AVEN00"
    select AVEN00
    set order to 2
    dbseek("A",.t.)
    lTampesq = len(VENNOM)
    lTangrade = 45
    cTitulo = "PESQUISA VENDEDOR"

  case fARQUIVO == "AFIS00"
    seexistesql("AFIS00")

    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"AFIS00","AFIS00"})
    aadd(sqlCAMPO,"*")
    aadd(sqlCHAVE,"FISEMP = " + str(ME_EMP, 2, 0))
    aadd(sqlCHAVE,"FISNOV <> '    '")
    sqlrelation()
    lTampesq = len(FISNOM)
    lTangrade = 45
    cTitulo = "PESQUISA CFOP"
  case fARQUIVO == "ACTA00"
    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"ACTA00","ACTA00"})
    aadd(sqlCAMPO,"*")
    aadd(sqlCHAVE,"CTACTA <> ''")
    sqlrelation()
    lTampesq = len(CTACTA)
    lTangrade = 45
    cTitulo = "PESQUISA CONTA"
endcase

IN_COL = int((110 - lTangrade) /2)
UL_COL = lTangrade + IN_COL

* oBrowse := TBrowseNew( nTop + 3, IN_COL,21,UL_COL)
* oBrowse := TBrowseWVG():New( nTop + 3, nLeft + 2, nBottom - 1, nRight - 2 )

*win(nTop + 2, IN_COL-1,22,UL_COL+1 ,cTITULO,"W/G","G/W*")

*NBOX(nTop + 2, IN_COL-1,22,UL_COL+1)
*NBOX(nTop + 3, IN_COL,21,UL_COL)

oBrowse := TBrowseWVG():New( nTop + 3, IN_COL,21,UL_COL )

*oBrowse := TBrowsenew():New( nTop + 3, IN_COL,20,UL_COL )

do case
  case fARQUIVO == "CBNEF"
    oBrowse:addColumn(TBColumnNew("Descricao", FieldBlock("DESCRICAO")))
    oBrowse:addColumn(TBColumnNew("Beneficio",FieldBlock("CODCBNEF")))
    oBrowse:addColumn(TBColumnNew("Codigo",FieldBlock("CODIGO")))
    oBrowse:GetColumn(1):Picture := "@!@S50"
    oBrowse:GetColumn(3):Picture := "999999"
  case fARQUIVO == "AHIS00"
    oBrowse:addColumn(TBColumnNew("Descricao", FieldBlock("HISDES")))
    oBrowse:addColumn(TBColumnNew("Tipo",FieldBlock("HISTIP")))
    oBrowse:addColumn(TBColumnNew("Codigo",FieldBlock("HISCOD")))
    oBrowse:GetColumn(3):Picture := "999"
  case fARQUIVO == "ACTA00"
    oBrowse:addColumn(TBColumnNew("Conta", FieldBlock("CTACTA")))
    oBrowse:addColumn(TBColumnNew("Nome da Agencia",FieldBlock("CTAAGE")))
    oBrowse:addColumn(TBColumnNew("Banco",FieldBlock("CTABAN")))
    oBrowse:GetColumn(3):Picture := "999"
  case fARQUIVO == "APOR00"
    oBrowse:addColumn(TBColumnNew("DESCRICAO",FieldBlock("PORNOM")))
    oBrowse:addColumn(TBColumnNew("CODIGO", FieldBlock("PORCOD")))
    oBrowse:GetColumn(2):Picture := "99999"
  case fARQUIVO == "ATRA00"
    oBrowse:addColumn(TBColumnNew("NOME",FieldBlock("TRANOM")))
    oBrowse:addColumn(TBColumnNew("CODIGO", FieldBlock("TRACOD")))
    oBrowse:addColumn(TBColumnNew("ENDERECO",FieldBlock("TRAEND")))
    oBrowse:addColumn(TBColumnNew("UF", FieldBlock("TRAEST")))
    oBrowse:GetColumn(1):Picture := "@s35"
    oBrowse:GetColumn(2):Picture := "99999"
    oBrowse:GetColumn(3):Picture := "@s25"
  case fARQUIVO == "ACPG00"
    oBrowse:addColumn(TBColumnNew("Descricao",FieldBlock("CPGDES")))
    oBrowse:addColumn(TBColumnNew("COD", FieldBlock("CPGCOD")))
    oBrowse:addColumn(TBColumnNew("P",FieldBlock("CPGPAR")))
    oBrowse:addColumn(TBColumnNew("PZ1",FieldBlock("CPGPR1")))
    oBrowse:addColumn(TBColumnNew("PZ2",FieldBlock("CPGPR2")))
    oBrowse:addColumn(TBColumnNew("PZ3",FieldBlock("CPGPR3")))
    oBrowse:addColumn(TBColumnNew("PZ4",FieldBlock("CPGPR4")))
    oBrowse:addColumn(TBColumnNew("PZ5",FieldBlock("CPGPR5")))
    oBrowse:addColumn(TBColumnNew("PZ6",FieldBlock("CPGPR6")))

    oBrowse:GetColumn(1):Picture := "@!"
    oBrowse:GetColumn(2):Picture := "999"
    oBrowse:GetColumn(3):Picture := "99"
    oBrowse:GetColumn(4):Picture := "999"
    oBrowse:GetColumn(5):Picture := "999"
    oBrowse:GetColumn(6):Picture := "999"
    oBrowse:GetColumn(7):Picture := "999"
    oBrowse:GetColumn(8):Picture := "999"
    oBrowse:GetColumn(9):Picture := "999"
  case fARQUIVO == "AHIE00"
    oBrowse:addColumn(TBColumnNew("DESCRICAO",FieldBlock("HIENOM")))
    oBrowse:addColumn(TBColumnNew("CODIGO", FieldBlock("HIEOPE")))
    oBrowse:GetColumn(2):Picture := "99999"
  case fARQUIVO == "AMUN00"
    oBrowse:addColumn(TBColumnNew("MUNICIPIO DESCRICAO",FieldBlock("MUNNOM")))
    oBrowse:addColumn(TBColumnNew("UF",FieldBlock("MUNEST")))
    oBrowse:addColumn(TBColumnNew("CODIGO", FieldBlock("MUNCOD")))
    oBrowse:GetColumn(3):Picture := "9999999"
  case fARQUIVO == "ASUB00"
    oBrowse:addColumn(TBColumnNew("DESCRICAO DO SUB-GRUPO",FieldBlock("SUBNOM")))
    oBrowse:addColumn(TBColumnNew("COD", FieldBlock("SUBCOD")))
    oBrowse:GetColumn(2):Picture := "9999"
  case fARQUIVO == "AGRP00"
    oBrowse:addColumn(TBColumnNew("DESCRICAO DO GRUPO",FieldBlock("GRPNOM")))
    oBrowse:addColumn(TBColumnNew("COD", FieldBlock("GRPCOD")))
    oBrowse:GetColumn(2):Picture := "9999"
  case fARQUIVO == "AFOR00"
    oBrowse:addColumn(TBColumnNew("NOME FORNECEDOR",FieldBlock("FORNOM")))
    oBrowse:addColumn(TBColumnNew("COD", FieldBlock("FORCOD")))
    oBrowse:addColumn(TBColumnNew("ENDERECO",FieldBlock("FOREND")))
    oBrowse:addColumn(TBColumnNew("UF", FieldBlock("FOREST")))
    oBrowse:GetColumn(1):Picture := "@!"
    oBrowse:GetColumn(2):Picture := "99999"
    oBrowse:GetColumn(3):Picture := "@s23"
  case fARQUIVO == "AVEN00"
    oBrowse:addColumn(TBColumnNew("NOME",FieldBlock("VENNOM")))
    oBrowse:addColumn(TBColumnNew("COD", FieldBlock("VENCOD")))
    oBrowse:GetColumn(1):Picture := "@!"
    oBrowse:GetColumn(2):Picture := "99999"
  case fARQUIVO == "AFIS00"
    oBrowse:addColumn(TBColumnNew("NOME",FieldBlock("FISNOM")))
    oBrowse:addColumn(TBColumnNew("CFOP", FieldBlock("FISNOV")))
    oBrowse:addColumn(TBColumnNew("ESTOQUE",FieldBlock("FISEST")))
    oBrowse:addColumn(TBColumnNew("COMPLEMENTAR", FieldBlock("FISCPL")))
  case fARQUIVO == "ACLI00"

    oCol := TBColumnNew("NOME",FieldBlock("CLINOM"))
    oCol:Picture := "@!@S40"
    oBrowse:addColumn(oCol)

    oCol := TBColumnNew("COD", FieldBlock("CLICOD"))
    oCol:Picture := "99999"
    oBrowse:addColumn(oCol)

    oCol := TBColumnNew("ENDERECO DE ENTREGA",FieldBlock("CLIEND1"))
    oCol:Picture := "@s23"
    oBrowse:addColumn(oCol)

    oCol := TBColumnNew("MUNICIPIO",FieldBlock("CLIMUN1"))
    oCol:Picture := "@s23"
    oBrowse:addColumn(oCol)

    oCol := TBColumnNew("UF", FieldBlock("CLIUF1"))
    oCol:Picture := "@!@S2"
    oBrowse:addColumn(oCol)

  case fARQUIVO == "APCA00"

    oBrowse:addColumn(TBColumnNew("Descricao dos Produtos",FieldBlock("PCADES")))
    oBrowse:addColumn(TBColumnNew("Marca",FieldBlock("PCAMAR")))
    oBrowse:addColumn(TBColumnNew("Codigo", FieldBlock("PCAMAT")))
    oBrowse:addColumn(TBColumnNew("Un",&("{||TRAN(pad(PCAUNI,2),[@!])}")))

    if ME_EMP = 1
      oBrowse:addColumn(TBColumnNew("Saldo",&("{||TRAN(SALDO1,[99999999])}")))
    ELSE
      oBrowse:addColumn(TBColumnNew("Saldo",&("{||TRAN(SALDO2,[99999999])}")))
    endif
    oBrowse:addColumn(TBColumnNew("Preco",&("{||TRAN(SLDPRC,[@R 9,999.99])}")))
*    oBrowse:GetColumn(1):Picture := "@!@S39"
    oBrowse:GetColumn(2):Picture := "@!@S20"
    oBrowse:GetColumn(3):Picture := "999999"


endcase

   oBrowse:ColSep        := '  '
   oBrowse:HeadSep       := '__'
   oBrowse:GoTopBlock    := { || dbGoTop() }
   oBrowse:GoBottomBlock := { || dbGoBottom() }
   oBrowse:SkipBlock     := { | nSkip | dbSkipBlock( nSkip,oBrowse ) }
   oBrowse:freeze := 1
   oBrowse:colPos := 1
   oBrowse:configure()

*   if fARQUIVO == "APCA00"
*      oBrowse:colPos := 2
*   endif

   Wvt_SetPen( 0, 1, rgb( 210,210,210 ) )
*   aAdd( aBlocks, {|| Wvt_DrawGridVert( oBrowse:nTop, oBrowse:nBottom, oBrowse:aColumnsSep, len( oBrowse:aColumnsSep ) ) } )

   aAdd( aBlocks, {|| Wvt_DrawBoxRaised( nTop + 2, IN_COL-1,22,UL_COL+1 ) } )
   aAdd( aBlocks, {|| Wvt_DrawBoxRecessed( nTop + 2, IN_COL-1,22,UL_COL+1,{+2,+2,-2,-2} ) } )
   aAdd( aBlocks, {|| Wvt_DrawGridVert( oBrowse:nTop, oBrowse:nBottom, oBrowse:aColumnsSep, len( oBrowse:aColumnsSep ) ) } )
   aAdd( aBlocks, {|| Wvt_DrawGridHorz( oBrowse:nTop+3, oBrowse:nLeft, oBrowse:nRight, oBrowse:nBottom - oBrowse:nTop - 2 ) } )

   aLastPaint := WvtSetBlocks( aBlocks )

   win(nTop + 2, IN_COL-1,22,UL_COL+1 ,cTITULO,"W+/R","R/W*")


*aqui
*   rodape(cF_ATV,cF_MOD,M_FAN,cF_PRG)

   lKeyWaiting := .F.
   lBrowse := .T.
   lPosrecloc = 0

   M_PROC = ""
   NpOSIC = { }
   cPosic = ""

   nc = 1

   lPri = .t.
   
   DO WHILE (lBrowse)


     lErroconsulta = .f.
     oBrowse:RefreshCurrent()
     oBrowse:Stabilize()

*     @ 27, 10 say recno() % 2

*     @ 27, 50 say "TESTE"

*     if fARQUIVO == "APCA00"
*       if recno() % 2 > 0
*         oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{3,5} ) // linha/coluna que está com o cursor
*       else
*         oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{2,5} ) // linha/coluna que está com o cursor
*       endif
*     else
*       oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{2,5} ) // linha/coluna que está com o cursor
*     endif



*     if fARQUIVO == "ACLI00"
*       if CLICLF == "C"
*         oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{3,5} ) // linha/coluna que está com o cursor
*       else
*         oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{2,5} ) // linha/coluna que está com o cursor
*       endif
*     else
*       oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{2,5} ) // linha/coluna que está com o cursor
*     endif

     oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{2,5} ) // linha/coluna que est? com o cursor


*     if fARQUIVO == "APCA00"
*       if lPosrecloc # recno()
*         @ maxrow()-1, 0 say "     " + pad(PCADES,maxcol()) color "W+/N"
*       endif
*     endif

*     if lPri
*       aLastPaint := WvtSetBlocks( aBlocks )
*       lPri = .f.
*     endif

     oBrowse:colPos := 1



     do while .t.
       nKey := nInKey(1)
       if nKey # 0
         exit
       endif
     enddo

     if nKey == K_F2
 *       nIndex := IndexOrd()
 *       nIndex++
 *       if nIndex > 3
 *          nIndex := 1
 *       endif
 *       Set Order To ( nIndex )
 *       oBrowse:RefreshAll()
     endif

    do case
    CASE (nKey == 27)
      lBrowse := .F.

    CASE (nKey == K_ENTER)
       do case
          case fARQUIVO == "CBNEF"
               nCodRetorno = CODCBNEF
          case fARQUIVO == "AHIS00"
               nCodRetorno = HISCOD
          case fARQUIVO == "ACTA00"
               nCodRetorno = CTACTA
          case fARQUIVO == "APOR00"
               nCodRetorno = PORCOD
          case fARQUIVO == "AFIS00"
               nCodRetorno = FISNOV
          case fARQUIVO == "ASUB00"
               nCodRetorno = SUBCOD
          case fARQUIVO == "AVEN00"
               nCodRetorno = VENCOD
          case fARQUIVO == "ATRA00"
               nCodRetorno = TRACOD
          case fARQUIVO == "ACPG00"
               nCodRetorno = CPGCOD
          case fARQUIVO == "AGRP00"
               nCodRetorno = GRPCOD
          case fARQUIVO == "ACLI00"
              if !empty(M_PROC)
                 cPESQUISAcli = M_PROC
              endif
               nUltClid = recno()
               nCodRetorno = CLICOD
          case fARQUIVO == "AFOR00"
              if !empty(M_PROC)
                 cPESQUISAfor = M_PROC
              endif
               nUltFord = recno()
               nCodRetorno = FORCOD
          case fARQUIVO == "AMUN00"
               nCodRetorno = MUNCOD
          case fARQUIVO == "APCA00"
              if !empty(M_PROC)
                 cPESQUISA = M_PROC
              endif

              cCODPESQ = PCAMAT

              nUltprod = recno()
              nCodRetorno = PCAMAT
       endcase

*       set order to 1

       Wvt_SetPen( 0 )
       WvtSetBlocks( aLastPaint )
       WvtSetObjects( aObjects )

       DevPos( nRow, nCol )
       SetColor( cColor )
       SetCursor( nCursor )

       RestScreen( 0, 0, maxrow(), maxcol(), cScr0 )
       wvt_RestScreen( 0, 0, maxrow(), maxcol(), cScr2 )

       return ""

    CASE (nKey == K_DOWN)
      oBrowse:down()

    CASE (nKey == K_UP)
      oBrowse:up()

    CASE (nKey == K_PGDN)
      oBrowse:pageDown()

    CASE (nKey == K_PGUP)
      oBrowse:pageUp()

    CASE (nKey == K_CTRL_PGUP)
      oBrowse:goTop()

    CASE (nKey == K_CTRL_PGDN)
      oBrowse:goBottom()

    CASE (nKey == K_RIGHT)
      oBrowse:right()

    CASE (nKey == K_LEFT)
      oBrowse:left()

    CASE (nKey == K_HOME)
      oBrowse:home()

    CASE (nKey == K_END)
      oBrowse:end()

    CASE (nKey == K_CTRL_LEFT)
      oBrowse:panLeft()

    CASE (nKey == K_CTRL_RIGHT)
      oBrowse:panRight()

    CASE (nKey == K_CTRL_HOME)
      oBrowse:panHome()

    CASE (nKey == K_CTRL_END)
      oBrowse:panEnd()

    CASE (nKey == K_F3)

    CASE (nKey == K_F2)

    CASE (nKey == K_SPACE)

    CASE (nKey == K_ESC)
      lBrowse := .F.

    CASE (nKey # 13) .and. nkey > 0
      if oBrowse:colPos = 1
        save get to M_GETBRO
        keyboard chr(nKey)
        M_PROC = space(lTampesq)
        setcolor("W+/N,W/N+")
        @ oBrowse:rowpos+5,IN_COL get M_PROC picture "@!"
        read

        restore get from M_GETBRO

        do case
           case fARQUIVO == "CBNEF"
             seexistesql("CBNEF")
             cSql := "SELECT * FROM CBNEF WHERE DESCRICAO LIKE '%" + alltrim(M_PROC) + "%'"

             try
               dbusearea(.t.,"SQLMIX",cSql,"CBNEF")
             catch oErro
               lErroconsulta = .t.
             end

           case fARQUIVO == "ACTA00"
             seexistesql("ACTA00")
             cSql := "SELECT * FROM ACTA00 WHERE CTACTA LIKE '%" + alltrim(M_PROC) + "%'"
             try
               dbusearea(.t.,"SQLMIX",cSql,"ACTA00")
             catch oErro
               lErroconsulta = .t.
             end

           case fARQUIVO == "APOR00"
             seexistesql("APOR00")
             cSql := "SELECT * FROM APOR00 WHERE PORNOM LIKE '" + alltrim(M_PROC) + "%'"
             dbusearea(.t.,"SQLMIX",cSql,"APOR00")

           case fARQUIVO == "AHIS00"
             seexistesql("AHIS00")
             cSql := "SELECT * FROM AHIS00 WHERE HISNOM LIKE '" + alltrim(M_PROC) + "%' ORDER BY HISDES"
             dbusearea(.t.,"SQLMIX",cSql,"AHIS00")
           case fARQUIVO == "ASUB00"
             set order to 2
             dbseek( M_PROC,.t.)
           case fARQUIVO == "AVEN00"
             set order to 2
             dbseek( M_PROC,.t.)
           case fARQUIVO == "ATRA00"
             set order to 2
             dbseek( M_PROC,.t.)
           case fARQUIVO == "ACPG00"
             seexistesql("ACPG00")
             cSql := "SELECT * FROM ACPG00 WHERE CPGDES LIKE '" + alltrim(M_PROC) + "%' ORDER BY CPGDES"
             dbusearea(.t.,"SQLMIX",cSql,"ACPG00")
           case fARQUIVO == "AGRP00"
             seexistesql("AGRP00")
             cSql := "SELECT * FROM AGRP00 WHERE GRPNOM LIKE '" + alltrim(M_PROC) + "%'"
             try
               dbusearea(.t.,"SQLMIX",cSql,"AGRP00")
             catch oErro
               lErroconsulta = .t.
             end
           case fARQUIVO == "APCA00"
              seexistesql("APCA00")
              sqlRELATION = {}
              sqlCAMPO = {}
              sqlCHAVE = {}
              sqlARQUI = {}
              sqlORDEM = {}

              aadd(sqlARQUI,{"APCA00","APCA00"})
              aadd(sqlCAMPO,"PCADES")
              aadd(sqlCAMPO,"PCAUNI")
              aadd(sqlCAMPO,"PCAMAR")
              aadd(sqlCAMPO,"PCAMAT")
              aadd(sqlCAMPO,"COALESCE(S1.SLDDIS,0) as SALDO1")
              aadd(sqlCAMPO,"COALESCE(S2.SLDDIS,0) as SALDO2")
              aadd(sqlCAMPO,"COALESCE(S1.SLDPRC,0) as SLDPRC")
              if AEMP00->EMPCGC == "037623347000109"
                aadd(sqlRELATION,{"ASLD00 S1",str(2, 2, 0),"S1.SLDEMP"})
                aadd(sqlRELATION,{"","S1.SLDMAT","APCA00.PCAMAT"})
                aadd(sqlRELATION,{"ASLD00 S2",str(10, 2, 0),"S2.SLDEMP"})
                aadd(sqlRELATION,{"","S2.SLDMAT","APCA00.PCAMAT"})
              else
                aadd(sqlRELATION,{"ASLD00 S1",str(1, 2, 0),"S1.SLDEMP"})
                aadd(sqlRELATION,{"","S1.SLDMAT","APCA00.PCAMAT"})
                aadd(sqlRELATION,{"ASLD00 S2",str(10, 2, 0),"S2.SLDEMP"})
                aadd(sqlRELATION,{"","S2.SLDMAT","APCA00.PCAMAT"})
              endif
              
              aadd(sqlCHAVE,"PCADES LIKE '" + alltrim(M_PROC) + "%'")
              aadd(sqlORDEM,"APCA00.PCADES")
              if !sqlrelation()
                lErroconsulta = .t.
              else
                oBrowse:RefreshCurrent()
           	    oBrowse:Stabilize()
              endif

           case fARQUIVO == "AMUN00"
              seexistesql("AMUN00")
              cSql := "SELECT * FROM AMUN00 WHERE MUNNOM LIKE '" + alltrim(M_PROC) + "%'"
               try
                 dbusearea(.t.,"SQLMIX",cSql,"AMUN00")
               catch oErro
                 lErroconsulta = .t.
               end
              oBrowse:RefreshCurrent()
              oBrowse:Stabilize()
           case fARQUIVO == "ACLI00"
              seexistesql("ACLI00P")
              sqlRELATION = {}
              sqlCAMPO = {}
              sqlCHAVE =  {}
              sqlARQUI = {}
              sqlORDEM = {}

              aadd(sqlARQUI,{"ACLI00","ACLI00P"})
              aadd(sqlCAMPO,"CLINOM")
              aadd(sqlCAMPO,"CLICOD")
              aadd(sqlCAMPO,"CLIEND1")
              aadd(sqlCAMPO,"CLIMUN1")
              aadd(sqlCAMPO,"CLICLF")
              aadd(sqlCAMPO,"CLIUF1")
              aadd(sqlCHAVE,"CLINOM LIKE '" + alltrim(M_PROC) + "%'")
              aadd(sqlORDEM,"CLINOM")
              if !sqlrelation()
                lErroconsulta = .t.
              else
                oBrowse:RefreshCurrent()
            	  oBrowse:Stabilize()
              endif



           case fARQUIVO == "AFOR00"
              seexistesql("AFOR00")
              sqlRELATION = {}
              sqlCAMPO = {}
              sqlCHAVE =  {}
              sqlARQUI = {}
              sqlORDEM = {}

              aadd(sqlARQUI,{"AFOR00","AFOR00"})
              aadd(sqlCAMPO,"first 50 FORNOM")
              aadd(sqlCAMPO,"FORCOD")
              aadd(sqlCAMPO,"FOREND")
              aadd(sqlCAMPO,"FOREST")
              aadd(sqlCHAVE,"FORNOM LIKE '" + alltrim(M_PROC) + "%'")
              aadd(sqlORDEM,"FORNOM")
             if !sqlrelation()
                lErroconsulta = .t.
             else
               oBrowse:RefreshCurrent()
            	oBrowse:Stabilize()
             endif

           case fARQUIVO == "AFIS00"
              sqlRELATION = {}
              sqlCAMPO = {}
              sqlCHAVE =  {}
              sqlARQUI = {}
              sqlORDEM = {}

              aadd(sqlARQUI,{"AFIS00","AFIS00"})
              aadd(sqlCAMPO,"*")
              aadd(sqlCHAVE,"FISEMP = " + str(1, 2, 0))
              aadd(sqlCHAVE,"FISNOV <> '    '")
              aadd(sqlCHAVE,"FISNOM LIKE '%" + alltrim(M_PROC) + "%'")
              if !sqlrelation()
                lErroconsulta = .t.
              else
                oBrowse:RefreshCurrent()
            	  oBrowse:Stabilize()
              endif
           case fARQUIVO == "AHIE00"
             dbseek( M_PROC,.t.)
        endcase

        if lErroconsulta
          msgbox1("Nenhum registro encontrado")
          Wvt_SetPen( 0 )
          WvtSetBlocks( aLastPaint )
          WvtSetObjects( aObjects )

          DevPos( nRow, nCol )
          SetColor( cColor )
          SetCursor( nCursor )
          RestScreen( 0, 0, maxrow(), maxcol(), cScr0 )
          return 0
        endif

        oBrowse:refreshALL()
        oBrowse:ForceStable()

      endif
    ENDCASE

   end

   Wvt_SetPen( 0 )
   WvtSetBlocks( aLastPaint )
   WvtSetObjects( aObjects )

   DevPos( nRow, nCol )
   SetColor( cColor )
   SetCursor( nCursor )

   RestScreen( 0, 0, maxrow(), maxcol(), cScr0 )
   wvt_RestScreen( 0, 0, maxrow(), maxcol(), cScr2 )

   nCodRetorno = 0
   RETURN ""

//-------------------------------------------------------------------//
FUNCTION DbSkipBlock( n, oTbr )

   LOCAL nSkipped := 0

   if n == 0
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

   RETURN  nSkipped
//-------------------------------------------------------------------//
FUNCTION TBNext()

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
FUNCTION TBPrev()
   LOCAL nSaveRecNum := Recno()
   LOCAL lMoved := .T.

   DBSkip( -1 )

   if Bof()
      DBGoTo( nSaveRecNum )
      lMoved := .F.
   endif

   RETURN lMoved
//-------------------------------------------------------------------//
FUNCTION VouBlockField( i )

   RETURN  {|| fieldget( i ) }
//-------------------------------------------------------------------//
FUNCTION BrwHandleKey( oBrowse, nKey, lEnd )
   LOCAL lRet := .t.

   do case
   case nKey == K_ESC
      lEnd := .t.

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

   case nKey == K_PGDN
      oBrowse:pageDown()

   case nKey == K_PGUP
      oBrowse:pageUp()

   case nKey == K_CTRL_PGUP
      oBrowse:goTop()

   case nKey == K_CTRL_PGDN
      oBrowse:goBottom()

   case nKey == K_HOME
      oBrowse:home()

   case nKey == K_END
      oBrowse:end()

   case nKey == K_CTRL_LEFT
      oBrowse:panLeft()

   case nKey == K_CTRL_RIGHT
      oBrowse:panRight()

   case nKey == K_CTRL_HOME
      oBrowse:panHome()

   case nKey == K_CTRL_END
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

FUNCTION BrwOnEvent( oWvtBrw, cPaintID, oBrowse, nKey )
   LOCAL lRet := .t., lRefAll := .f.

   HB_SYMBOL_UNUSED( cPaintID )

   do case
   case nKey == K_DOWN
      oBrowse:Down()

   case nKey == K_UP
      oBrowse:Up()

   case nKey == K_LEFT
      oBrowse:Left()

   case nKey == K_RIGHT
      oBrowse:Right()

   case nKey == K_PGDN
      oBrowse:pageDown()
      lRefAll := .t.

   case nKey == K_PGUP
      oBrowse:pageUp()
      lRefAll := .t.

   case nKey == K_CTRL_PGUP
      oBrowse:goTop()
      lRefAll := .t.

   case nKey == K_CTRL_PGDN
      oBrowse:goBottom()
      lRefAll := .t.

   case nKey == K_HOME
      oBrowse:home()

   case nKey == K_END
      oBrowse:end()

   case nKey == K_CTRL_LEFT
      oBrowse:panLeft()

   case nKey == K_CTRL_RIGHT
      oBrowse:panRight()

   case nKey == K_CTRL_HOME
      oBrowse:panHome()

   case nKey == K_CTRL_END
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

   RETURN lRet

//-------------------------------------------------------------------//

FUNCTION CfgMyBrowse( aFields, cUseAlias, aTLBR, cDesc, oParent, cColorSpec, nID )
   LOCAL info_, oWvtBrw, oBrowse, i, bBlock
   LOCAL aPopup := {}

   aadd( aPopup, { 'Down'     , {|| oBrowse:Down()    , oBrowse:ForceStable() } } )
   aadd( aPopup, { 'Up'       , {|| oBrowse:Up()      , oBrowse:ForceStable() } } )
   aadd( aPopup, { 'Page Down', {|| oBrowse:PageDown(), oBrowse:ForceStable() } } )
   aadd( aPopup, { 'Page Up'  , {|| oBrowse:PageUp()  , oBrowse:ForceStable() } } )
   aadd( aPopup, { 'Top'      , {|| oBrowse:GoTop()   , oBrowse:ForceStable() } } )
   aadd( aPopup, { 'Bottom'   , {|| oBrowse:GoBottom(), oBrowse:ForceStable() } } )

   Select( cUseAlias )
   info_ := DbStruct()

   oBrowse := TBrowseWVG():New( aTLBR[ 1 ], aTLBR[ 2 ], aTLBR[ 3 ], aTLBR[ 4 ] )

   oBrowse:ColSep        := '  '
   oBrowse:HeadSep       := '__'
   oBrowse:ColorSpec     := cColorSpec
   oBrowse:GoTopBlock    := { || dbGoTop() }
   oBrowse:GoBottomBlock := { || dbGoBottom() }
   oBrowse:SkipBlock     := { | nSkip | dbSkipBlock( nSkip,oBrowse ) }

   for i := 1 to len( aFields )
      bBlock := VouBlockField( aFields[ i ] )
      oBrowse:AddColumn( TBColumnNew( info_[ aFields[ i ],1 ], bBlock ) )
   next

   oBrowse:configure()

   oWvtBrw := WvtBrowse():New( oParent,nID )

   oWvtBrw:nTop         := aTLBR[ 1 ]
   oWvtBrw:nLeft        := aTLBR[ 2 ]
   oWvtBrw:nBottom      := aTLBR[ 3 ]
   oWvtBrw:nRight       := aTLBR[ 4 ]
   oWvtBrw:cAlias       := cUseAlias
   oWvtBrw:oBrw         := oBrowse
   oWvtBrw:cDesc        := cDesc
   oWvtBrw:nPointer     := WVT_IDC_HAND
   oWvtBrw:cColorHilite := 'W+/B*'
   oWvtBrw:Tooltip      := cDesc
   oWvtBrw:aPopup       := aPopup

   oWvtBrw:bHandleEvent := {|oWvtBrw,cPaintID,oBrowse,nKey| BrwOnEvent( oWvtBrw,cPaintID,oBrowse,nKey ) }

   RETURN oWvtBrw

//-------------------------------------------------------------------//


//-------------------------------------------------------------------//


//-------------------------------------------------------------------//


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

FUNCTION MyDialogOne()
   LOCAL aObjects := WvtSetBlocks( {} )
   Local nWinRows, nWinCols, cWinTitle, cFont, nHeight
*   Local oDlg, cUseAlias
   Local oText, oTBar, aImg_, oImg, oLine, oBox, oBtn, oBtn2
   Local oBBox, oCon, oGet, oBBox2, oTBx
   Local oBRsd, cTxt, oRct, nGetCol, nSayCol, bBlock, bBlock1
   Local oWvtBrw, oWvtBrw1, lOpen, lOpen1, cUseAlias1, oGetArea, oGet1
   LOCAL hPopup, nGetRow, aGets_, lChkMouse
   LOCAL g_oMenuBar, oMenu,oPBar3

*   oDlg, cUseAlias


*   cUseAlias := 'TEST'
*   USE 'TEST' NEW ALIAS ( cUseAlias ) SHARED

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
   aadd( aImg_, 'v_lock.bmp'   )
   aadd( aImg_, 'v_new.bmp'    )
   aadd( aImg_, 'v_clclt.bmp'  )
   aadd( aImg_, 'v_calend.bmp' )
   aadd( aImg_, 'v_index.bmp'  )
   aadd( aImg_, 'v_notes1.bmp' )
   aadd( aImg_, 'v_selct1.bmp' )

   nWinRows  := 55
   nWinCols  := 185
   cWinTitle := 'WvtGui Dialog One'
   cFont     := 'Courier New'
   nHeight   := 13

   oDlg := WvtDialog():New( nWinRows, nWinCols, cWinTitle, cFont, nHeight,8 )
   oDlg:nTooltipWidth     := 300
   oDlg:nTooltipTextColor := RGB( 255,0,0 )

   oBar := WvtStatusBar():New( oDlg,201 )
   oBar:SetPanels( { 50,100 } )
   oBar:SetText( 1, 'Tab.SH_Tab.Left_Click - Select a Browse' )
   oBar:SetText( 2, 'GtWvt is Fantastic', 'w+/W' )
   oBar:SetText( 3, 'WOW' )
   oBar:nPointer := WVT_IDC_HAND
   oBar:Tooltip  := 'GtWvt Statusbar with 3 panels'
   oDlg:AddObject( oBar )

   oBox := WvtStatic():New( oDlg,110,4,oDlg:MaxCol()-40,7,oDlg:MaxCol()-2 )
   oBox:nStatic := WVT_STATIC_BOXRECESSED
   oDlg:AddObject( oBox )

   oText := WvtLabel():New( oDlg, 101, 4, oDlg:MaxCol()-40, 7,oDlg:MaxCol()-2 )
   oText:Text              := '(x)Harbour'
   oText:nFontHeight       := 36
   oText:nAlignHorz        := 2
   oText:nAlignVert        := 2
   oText:nFontWeight       := 700
   oText:nTextColor        := RGB( 100, 255,  12 )
   oText:nBackColor        := RGB(   0,   0, 255 )
   oText:nTextColorHoverOn := RGB( 255, 255,   0 )
   oText:nBackColorHoverOn := RGB( 255, 100,  12 )
   oText:lItalic           := .t.
   oText:ToolTip           := 'Software that GROWS with you'
   oText:bOnSelect         := {|| .t. }
   oDlg:AddObject( oText )

   oImg := WvtImage():New( oDlg,102,20,oDlg:MaxCol()-40,37,oDlg:MaxCol()-2 )
   oImg:cImage  := aImg_[ 5 ]
   oImg:Tooltip := 'WvtImage():New()'
   oDlg:AddObject( oImg )

   oTBar := WvtToolbar():New( oDlg,103, 0,0,2 )
   oTBar:lFloating := .f.
   oTBar:Tooltip   := 'Toolbar'
   oTBar:AddButton( aImg_[ 1 ], {|| oImg:SetImage( aImg_[ 1 ] ) } , 'Lock' )
   oTBar:AddButton( aImg_[ 2 ], {|| oImg:SetImage( aImg_[ 2 ] ), oText:SetText( '(x)Harbour' ) } , 'New' )
   oTBar:AddButton( aImg_[ 3 ], {|| oImg:SetImage( aImg_[ 3 ] ) } , 'Calculator' )
   oTBar:AddButton()
   oTBar:AddButton( aImg_[ 5 ], {|| oImg:SetImage( aImg_[ 5 ] ) } , 'Restore' )
   oTBar:AddButton( aImg_[ 4 ], {|| oImg:SetImage( aImg_[ 4 ] ), oText:SetText( 'Vouch' )    } , 'Calendar' )
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
   oBtn:cCaption  := 'Print'
   oBtn:bOnLeftUp := {|| Wvt_Keyboard( 379 ) }
   oBtn:Tooltip   := 'Open Printing Dialog for the Browser in Focus'
   oDlg:AddObject( oBtn )

   oBtn2 := WvtPushButton():New( oDlg, 124, 9, 129, 12, 137 )
   oBtn2:cFileImage := aImg_[ 3 ]
   oBtn2:block      := {|| ExeProgressBar( oPBar2, oPBar3 ) }
   oBtn2:Tooltip    := 'Execute Progress Bar'
   oDlg:AddObject( oBtn2 )

   oPBar2 := WvtProgressBar():New( oDlg, , 14, 129, 25, 137 )
   oPBar2:nBarColor  := RGB( 240,240,0 )
   oPBar2:cBackColor := 'W/N*'
   oPBar2:lVertical  := .t.
   oPBar2:nDirection := 0
   oPBar2:cImage     := 'vouch1.bmp'
   oDlg:AddObject( oPBar2 )

   oPBar3 := WvtProgressBar():New( oDlg, , 26, 129, 36, 137 )
   oPBar3:nBarColor  := RGB( 240,240,0 )
   oPBar3:cBackColor := 'W/N*'
   oPBar3:lVertical  := .t.
   oPBar3:nDirection := 1
   oPBar3:cImage     := 'vouch1.bmp'
   oDlg:AddObject( oPBar3 )

   oBBox2 := WvtStatic():New( oDlg, , 9, oDlg:MaxCol()-40, 18, oDlg:Maxcol()-2 )
   oBBox2:nStatic := WVT_STATIC_BOXGROUP
   oDlg:AddObject( oBBox2 )

   oCon := WvtConsole():New( oDlg )
   oDlg:AddObject( oCon )

   nGetCol := 158
   bBlock  := {|| oCon:Say( 12, 148, 'Name'  ,'N/W' ),;
                  oCon:Say( 14, 148, 'Date'  ,'N/W' ),;
                  oCon:Say( 16, 148, 'Amount','N/W' ) }

*   oGet := WvtGets():New( oDlg, 210, 9, oDlg:Maxcol()-40, 18, oDlg:Maxcol()-2 )
*   oGet:AddGets( 12, nGetCol, 'GTWvt               ', '@! ','W+/B*,N/W*' )
*   oGet:AddGets( 14, nGetCol, date() )
*   oGet:AddGets( 16, nGetCol, 2122.57, '@Z 99999999.99','w+/R,GR+/B' )
*   oGet:Tooltip   := 'WvtGets():New() - ReadModal() like Clipper'
*   oGet:cDesc     := 'Normal Get Box'
*   oGet:bOnCreate := bBlock
*   oDlg:AddObject( oGet )

   oBnr := WvtBanner():New( oDlg, 101, 0, 127, 1, oDlg:MaxCol()-2 )
   oBnr:nTimeDelay        := 0.25
   oBnr:cText             := 'the compiler that EXTENDS with you'
   oBnr:nFontHeight       := 24
   oBnr:nFontWeight       := 0
   oBnr:nDirection        := 0
   oBnr:nAlignVert        := 2
   oBnr:nTextColor        := RGB( 253,251,170 )
   oBnr:nBackColor        := RGB( 128,227,142 )
   oBnr:nTextColorHoverOn := RGB( 255,255,  0 )
   oBnr:nBackColorHoverOn := RGB( 255,100, 12 )
   oBnr:Tooltip           := 'WvtBanner():New()'
   oDlg:AddObject( oBnr )

   oBRsd := WvtStatic():New( oDlg, , 41,127,52,oDlg:MaxCol()-2 )
   oBRsd:nStatic := WVT_STATIC_BOXGROUPRAISED
   oDlg:AddObject( oBRsd )

   oRct := WvtStatic():New( oDlg, , 41,127,52,oDlg:MaxCol()-2 )
   oRct:nStatic := WVT_STATIC_SHADEDRECT
   oRct:aRGBb   := { 0xffff, 0x0000, 0x0000, 0x0000 }
   oRct:aRGBe   := { 0x0000, 0xffff, 0xffff, 0x0000 }
   oDlg:AddObject( oRct )

   oTBx := WvtTextBox():New( oDlg, , 42,129,51,oDlg:MaxCol()-4 )
   oTBx:cText       := cTxt
   oTBx:Tooltip     := 'WvtTextBox():New()'
   oTBx:nFontHeight := 16
   oTBx:lItalic     := .t.
   oTBx:lUnderline  := .t.
   oTBx:nAlignHorz  := 2
   oTBx:nTextColor  := RGB( 255,255,255 )
   oTBx:nTextColorHoverOn := RGB( 0,0,255 )
   oTBx:aPopup      := {}
   aadd( oTBx:aPopup, { 'Getsome' , {|| .t. } } )
   aadd( oTBx:aPopup, { 'Getsome2', {|| .t. } } )
   oDlg:AddObject( oTBx )

   oGetArea := WvtStatic():New( oDlg, , 4, 2, 37, 62 )
   oGetArea:nStatic := WVT_STATIC_BOXRAISED
   oDlg:AddObject( oGetArea )

   nGetCol := 20
   nSayCol := 7
   nGetRow := 7
   bBlock1 := {|| oCon:Say( nGetRow+00, nSayCol, 'First Name'  ,'N/W' ),;
                  oCon:Say( nGetRow+02, nSayCol, 'Last Name '  ,'N/W' ),;
                  oCon:Say( nGetRow+04, nSayCol, 'Street'      ,'N/W' ),;
                  oCon:Say( nGetRow+06, nSayCol, 'City'        ,'W+/W'),;
                  oCon:Say( nGetRow+08, nSayCol, 'State'       ,'N/W' ),;
                  oCon:Say( nGetRow+10, nSayCol, 'Zip'         ,'B+/W'),;
                  oCon:Say( nGetRow+12, nSayCol, 'Date Hired'  ,'B+/W'),;
                  oCon:Say( nGetRow+14, nSayCol, 'Married'     ,'B+/W'),;
                  oCon:Say( nGetRow+16, nSayCol, 'Age'         ,'B+/W'),;
                  oCon:Say( nGetRow+18, nSayCol, 'Salary'      ,'B+/W'),;
                  oCon:Say( nGetRow+20, nSayCol, 'Notes',      ,'B+/W') ;
                  }

   aGets_:= { pad('Pritpal',20 ), pad( 'Bedi',20 ), pad( '60, New Professor Colony',30 ), ;
              pad( 'Ludhiana, INDIA',30 ),;
              'PB', pad( '141004',10 ), ctod( '22/06/04' ), .t., 48, 17000, ;
              pad( 'Wvtgui is a classical example of (x)Harbour capabilities...',65 ) }

*   oGet1 := WvtGets():New( oDlg, , 4, 2, 37, 62 )
*   oGet1:AddGets( nGetRow+00, nGetCol, aGets_[ 1 ], '@ '       , 'N/W*,N/GR*' )
*   oGet1:AddGets( nGetRow+02, nGetCol, aGets_[ 2 ], '@ '       , 'N/W*,N/GR*' )
*   oGet1:AddGets( nGetRow+04, nGetCol, aGets_[ 3 ], '@ '       , 'N/W*,N/GR*' )
*   oGet1:AddGets( nGetRow+06, nGetCol, aGets_[ 4 ], '@ '       , 'N/W*,N/GR*' )
*   oGet1:AddGets( nGetRow+08, nGetCol, aGets_[ 5 ], '@ '       , 'N/W*,N/GR*' )
*   oGet1:AddGets( nGetRow+10, nGetCol, aGets_[ 6 ], '@ '       , 'N/W*,N/GR*' )
*   oGet1:AddGets( nGetRow+12, nGetCol, aGets_[ 7 ], '@ '       , 'N/W*,N/GR*' )
*   oGet1:AddGets( nGetRow+14, nGetCol, aGets_[ 8 ], '@Y'       , 'N/W*,N/GR*' )
 *  oGet1:AddGets( nGetRow+16, nGetCol, aGets_[ 9 ], '@Z 99'    , 'N/W*,N/GR*' )
 *  oGet1:AddGets( nGetRow+18, nGetCol, aGets_[ 10], '@Z 999999', 'N/W*,N/GR*' )
 *  oGet1:AddGets( nGetRow+20, nGetCol, aGets_[ 11], '@S35'     , 'N/W*,N/GR*' )
 *  oGet1:cDesc     := 'Test.dbf Fields'
 *  oGet1:Tooltip   := 'Double Click to Activate ReadModal()'
 *  oGet1:bOnCreate := bBlock1
 *  oDlg:AddObject( oGet1 )

   g_oMenuBar := WvtMenu():new():create()
   oMenu      := WvtMenu():new():create()
   oMenu:Caption := 'Other Dialogs'
   oMenu:AddItem( 'Dialog Two', {|| MyDialogTwo() } )
   oMenu:AddItem( '-' )
   oMenu:AddItem( 'Exit',       {|| Wvt_Keyboard( K_ESC ) } )
   g_oMenuBar:addItem( "",oMenu )

   oDlg:oMenu := g_oMenuBar

   lOpen := .f.
   cUseAlias := 'TEST'
   USE 'TEST' NEW ALIAS ( cUseAlias ) SHARED
   if !NetErr()
      lOpen := .t.
      oWvtBrw := CfgMyBrowse( { 1,7,9,10,8 }, cUseAlias, { 6,10,35,120 }, 'Test.dbf - 1,7,9,10,8', oDlg, 'N/W*,N/GR*',1001 )
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

********************
FUNCTION MyDialogTwo()
********************

   LOCAL aObjects := WvtSetBlocks( {} )
   LOCAL oDlg1
   LOCAL g_oMenuBar, oMenu, oPBar
   LOCAL oPBar1,oPBar3, oPBar4
   Local lTela := wvt_savescreen(2,0,MAXROW()-2,maxcol())

   LOCAL sUnits := 10
   LOCAL lUnits := 6
   LOCAL lMaquinaok := .f.

   nWinRows  := 30
   nWinCols  := 132

   nHeight = 10
   nWidth  = 6


   sqlORDEM = {}
   sqlCAMPO = {}
   sqlCHAVE =  {}
   sqlARQUI = {"CONFIGURAR","SELECT"}
   aadd(sqlCHAVE,{"MAQUINA",aspas(netname())})

   if executasql()
     if FONTET_R > 0
       lMaquinaok := .t.
       nHeight = FONTET_R
     endif
     if FONTEL_R > 0
       nWidth = FONTEL_R
     endif
     Wvt_setFont( 'Visualnova', FONTET_R,FONTEL_R)
   endif

   cWinTitle := 'Visualizar Relatorios'
   cFont     := 'Visualnova'

   oDlg1 := WvtDialog():New( nWinRows, nWinCols, cWinTitle, cFont,nHeight,nWidth)
   oDlg1:Create()


   if !lMaquinaok
     For ABC = 1 to 40
       sUnits += 1
       Wvt_setFont( 'Visualnova', sUnits)
     next

     fnt_:= Wvt_GetFontInfo()
     sUnits = fnt_[ 2 ]

     sUnits -= 1
     Wvt_setFont( 'Visualnova', sUnits)
     fnt_:= Wvt_GetFontInfo()

     sUnits = fnt_[ 2 ]
     lUnits = ((sUnits * 12)/23)

     fnt_:= Wvt_GetFontInfo()
     Wvt_setFont( 'Visualnova', sUnits,lUnits)

     fnt_:= Wvt_GetFontInfo()
      Wvt_setFont( 'Visualnova', fnt_[ 2 ],fnt_[ 3 ])
     _FONTET_R   = fnt_[ 2 ]
     _FONTEL_R   = fnt_[ 3 ]

     sqlORDEM = {}
     sqlCAMPO = {}
     sqlCHAVE =  {}
     sqlARQUI = {"CONFIGURAR","UPDATE OR INSERT"}
     aadd(sqlCHAVE,{"MAQUINA"})
     aadd(sqlCAMPO,{"MAQUINA",netname(),.t.})
     aadd(sqlCAMPO,{"FONTET_R",str(_FONTET_R,3),.f.})
     aadd(sqlCAMPO,{"FONTEL_R",str(_FONTEL_R,3),.f.})
     executasql()
   endif


*   ShowTime( maxrow(), MaxCol()-9,,"N/W" ,.F. , .T. )

*   HB_GtInfo( HB_GTI_MAXIMIZED, .T. )

   EDITREL()

   oDlg1:Destroy()

*   ShowTime( maxrow(), MaxCol()-9,,"N/W" ,.F. , .T. )

    sqlORDEM = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {"CONFIGURAR","SELECT"}
    aadd(sqlCHAVE,{"MAQUINA",aspas(netname())})

    if executasql()
       if FONTET > 0
         lMaquinaok := .t.
         nHeight = FONTET
       endif
       if FONTEL > 0
         nWidth = FONTEL
       endif
       Wvt_setFont( 'Visualnova', FONTET,FONTEL)
    endif

   _FONTET_   = nHeight
   _FONTEL_   = nWidth


   wvt_Restscreen(2,0,MAXROW()-2,maxcol(),lTela)
   WvtSetBlocks( aObjects )
   RETURN Nil



STATIC FUNCTION ExeProgBar( oPBar,oPBar1,oPBar2,oPBar3,oPBar4 )
   LOCAL i

   oPBar:Activate()
   oPBar1:Activate()
   oPBar2:Activate()
   oPBar3:Activate()
   oPBar4:Activate()
   for i := 1 to 100
      oPBar:Display( i, 100 )
      oPBar1:Display( i, 100 )
      oPBar2:Display( i, 100 )
      oPBar3:Display( i, 100 )
      oPBar4:Display( i, 100 )
      inkey( 0.3 )
   next
   inkey( 0 )
   oPBar:DeActivate()
   oPBar1:DeActivate()
   oPBar2:DeActivate()
   oPBar3:DeActivate()
   oPBar4:DeActivate()

   RETURN nil
//-------------------------------------------------------------------//

STATIC FUNCTION ExeProgressBar( oPBar, oPBar3 )
   LOCAL i

   oPBar:Activate()
   oPBar3:Activate()
   for i := 1 to 100
      oPBar:Display( i, 100 )
      oPBar3:Display( i, 100 )
      inkey( 0.3 )
   next
   oPBar:DeActivate()
   oPBar3:DeActivate()

   RETURN NIL

//-------------------------------------------------------------------//

Function DynDialog_1()
   Local hDlg, aDlg, nStyle

   Static nInfo := 1
   nInfo++

   nStyle := + WS_CAPTION    + WS_SYSMENU               ;
             + WS_GROUP      + WS_TABSTOP + DS_SETFONT  ;
             + WS_THICKFRAME + WS_VISIBLE + WS_POPUP

   aDlg := Wvt_MakeDlgTemplate( 1, 2, 15, 40, {0,0,0,0},  ;
                     ltrim( str( nInfo,10,0 ) ) + ' - Modeless Dialog', nStyle )

   nStyle := WS_VISIBLE + WS_TABSTOP + ES_AUTOVSCROLL + ES_MULTILINE + ES_WANTRETURN + WS_BORDER + WS_VSCROLL
   aDlg   := Wvt_AddDlgItem( aDlg,  1, 2, 9, 28, {}, 10, 'EDIT'  , nStyle, /* cText, nHelpId, nExStyle */ )

   nStyle := WS_VISIBLE + SS_ETCHEDHORZ
   aDlg   := Wvt_AddDlgItem( aDlg, 12, 2, 1, 36, {}, 12, 'STATIC', nStyle )

   nStyle := WS_VISIBLE + WS_TABSTOP + BS_AUTOCHECKBOX
   aDlg   := Wvt_AddDlgItem( aDlg, 13, 2, 1, 10, {}, 11, 'BUTTON', nStyle, 'Is It Checked?' )

   hDlg := Wvt_CreateDialog( aDlg, .f., 'DynDlgProc_1' )

   Return hDlg

//-------------------------------------------------------------------//

Function DynDlgProc_1( hDlg, nMsg, wParam, lParam )
   Local /*cText,*/ lClicked

   HB_SYMBOL_UNUSED( lParam )

   Switch ( nMsg )

   case WM_INITDIALOG
      Win_SetDlgItemText( hDlg, 10, 'This is multiline text which will be displayed in the edit window!' )
      Win_CheckDlgButton( hDlg, 11, .t. )
      exit

   case WM_DESTROY
      // Do whatevert you want to do with cText
      // Each box will retrieve its own text.
      //
      /*cText := */ Win_GetDlgItemText( hDlg, 10 )

      exit

   case WM_TIMER
      // Do some processing

      exit

   case WM_COMMAND
      do case

      case wParam == 11
         lClicked := ( Win_IsDlgButtonChecked( hDlg,11 ) == 1 )
         Win_MessageBox( hDlg, 'Button ' + iif( lClicked, 'Clicked', 'Unclicked' ), 'CheckBoxStatus' )

      endcase
      exit

   end

   Return .f.

//-------------------------------------------------------------------//

#define ID_BTN_OK          1
#define ID_MLE            10
#define ID_CHK_SATIS      11
#define ID_EDT_TIME       51
#define ID_LST_LIST       13
#define ID_CMB_COMBO      31
#define ID_RDO_XH         21
#define ID_RDO_CLIP       22
#define ID_RDO_XBASE      23
#define ID_EDT_TEXT       14
#define ID_EDT_NUMB       15
#define ID_STA_TEXT       71
#define ID_STA_IMAGE      72
#define ID_ICO_VOUCH      81

#define ID_GRP_COMP      113

#define ID_MNU_FILE      201
#define ID_MNU_CONTROL   202

//-------------------------------------------------------------------//

Function DynDialog_2()
   Local hDlg, aDlg, nStyle, /*nTimerTicks,*/ cDlgIcon, cDlgProc, lOnTop, hMenu /*, bDlgProc*/

   Static nInfo := 0
   nInfo++

   nStyle := DS_SETFONT + WS_VISIBLE + WS_POPUP + WS_CAPTION + WS_SYSMENU + WS_THICKFRAME + WS_MINIMIZEBOX

   aDlg := Wvt_MakeDlgTemplate( 1, 4, 21, 60, {0,0,0,0},  ;
               'Dialog First [ ' + ltrim( str( nInfo,10,0 ) ) + ' ] '+;
                        iif( nInfo%2==0, 'Modeless', 'Modal' ),' Dialog !', nStyle )

   // Multi line edit control
   //
   nStyle := WS_CHILD + WS_VISIBLE + WS_TABSTOP + ES_AUTOVSCROLL + ES_MULTILINE + ;
             ES_WANTRETURN + WS_BORDER  + WS_VSCROLL
   aDlg   := Wvt_AddDlgItem( aDlg,  1, 2, 15, 35, {}, ID_MLE       , 'EDIT'   , nStyle, /* cText, nHelpId, nExStyle */ )

   // Two Horz and Vert Lines
   //
   nStyle := WS_CHILD + WS_VISIBLE + SS_ETCHEDVERT
   aDlg   := Wvt_AddDlgItem( aDlg, 1, 39,  16, 1, {}, 111          , 'STATIC' , nStyle )
   nStyle := WS_CHILD + WS_VISIBLE + SS_ETCHEDHORZ
   aDlg   := Wvt_AddDlgItem( aDlg, 17, 2,  1, 56, {}, 112          , 'STATIC' , nStyle )

   // Icon
   nStyle := WS_CHILD + WS_VISIBLE + SS_ICON //+ SS_CENTERIMAGE
   aDlg   := Wvt_AddDlgItem( aDlg, 18, 2, 2, 6, {}, ID_ICO_VOUCH  , 'STATIC' , nStyle, '' )
/*
   // Bitmap
   nStyle := WS_CHILD + WS_VISIBLE + SS_BITMAP + SS_REALSIZEIMAGE
   aDlg   := Wvt_AddDlgItem( aDlg, 18, 41, 2,8, {-3,0,3}, ID_STA_IMAGE, 'STATIC' , nStyle, '' )
*/
   nStyle := WS_CHILD + WS_VISIBLE + WS_TABSTOP + BS_AUTOCHECKBOX
   aDlg   := Wvt_AddDlgItem( aDlg, 18, 15,  1, 10, {}, ID_CHK_SATIS , 'BUTTON' , nStyle, 'Satisfied?' )

   nStyle := WS_CHILD + WS_VISIBLE + WS_TABSTOP + ES_RIGHT + ES_READONLY
   aDlg   := Wvt_AddDlgItem( aDlg, 18, 30, 1,  7, {3}, ID_EDT_TIME , 'EDIT' , nStyle, '' )

   nStyle := WS_CHILD + WS_VISIBLE + WS_TABSTOP + LBS_NOTIFY + WS_VSCROLL + WS_BORDER
   aDlg   := Wvt_AddDlgItem( aDlg, 1, 41,  4, 17, {}, ID_LST_LIST  , 'LISTBOX', nStyle, 'ListBox'  )

   nStyle := WS_CHILD + WS_VISIBLE + SS_LEFT
   aDlg   := Wvt_AddDlgItem( aDlg, 4, 41,  1, 17, {3,0,0,0}, -1    , 'STATIC' , nStyle, 'Degree'     )
   nStyle := WS_VISIBLE + WS_TABSTOP + CBS_DROPDOWNLIST + WS_BORDER + WS_VSCROLL
   aDlg   := Wvt_AddDlgItem( aDlg, 5, 41,  6, 17, {}, ID_CMB_COMBO , 'COMBOBOX' , nStyle, 'Combo' )

   nStyle := WS_CHILD + WS_VISIBLE + WS_TABSTOP + BS_GROUPBOX
   aDlg   := Wvt_AddDlgItem( aDlg, 7, 41,  4, 17, {0,0,4,0},ID_GRP_COMP, 'BUTTON' , nStyle, 'Compiler' )
   nStyle := WS_CHILD + WS_VISIBLE + WS_TABSTOP + BS_AUTORADIOBUTTON
   aDlg   := Wvt_AddDlgItem( aDlg, 8, 43,  1, 14, {}, ID_RDO_XH    , 'BUTTON' , nStyle, '(x)Harbour' )
   aDlg   := Wvt_AddDlgItem( aDlg, 9, 43,  1, 14, {}, ID_RDO_CLIP  , 'BUTTON' , nStyle, 'Clipper'  )
   aDlg   := Wvt_AddDlgItem( aDlg,10, 43,  1, 14, {}, ID_RDO_XBASE , 'BUTTON' , nStyle, 'Xbase++'  )

   nStyle := WS_CHILD + WS_VISIBLE + SS_LEFT
   aDlg   := Wvt_AddDlgItem( aDlg, 12, 41, 1, 17, {3,0,0,0}, ID_STA_TEXT, 'STATIC' , nStyle, 'Scrollable Text'    )
   nStyle := WS_CHILD + WS_VISIBLE + WS_TABSTOP + ES_AUTOHSCROLL + WS_BORDER
   aDlg   := Wvt_AddDlgItem( aDlg, 13, 41, 1, 17, {}, ID_EDT_TEXT  , 'EDIT'   , nStyle, 'This is Text Field' )

   nStyle := WS_CHILD + WS_VISIBLE + SS_LEFT
   aDlg   := Wvt_AddDlgItem( aDlg, 14, 41, 1, 17, {3,0,0,0}, -1, 'STATIC' , nStyle, 'Right Justified Numerics' )
   nStyle := WS_CHILD + WS_VISIBLE + WS_TABSTOP + ES_AUTOHSCROLL + ES_NUMBER + ES_RIGHT + WS_BORDER
   aDlg   := Wvt_AddDlgItem( aDlg, 15, 41, 1, 17, {}, ID_EDT_NUMB  , 'EDIT'   , nStyle, '1234567' )

   nStyle := WS_CHILD + WS_VISIBLE + WS_TABSTOP + BS_PUSHBUTTON
   aDlg   := Wvt_AddDlgItem( aDlg, 18, 50, 1,  8, {-3,0,3,0}, ID_BTN_OK, 'BUTTON' , nStyle, 'OK' )

   hMenu  := Wvt_CreateMenu()
   Wvt_AppendMenu( hMenu, MF_STRING + MF_ENABLED, ID_MNU_FILE   , 'File'     )
   Wvt_AppendMenu( hMenu, MF_STRING + MF_ENABLED, ID_MNU_CONTROL, 'Controls' )

   lOnTop      := .f.
   cDlgProc    := 'DynDlgProc_2'
   //bDlgProc    := {|a,b,c,d| DYNDLGPROC_2(a,b,c,d) }
   cDlgIcon    := 'V_Notes.Ico'
   //nTimerTicks := 1000  // 1 second

   if nInfo % 2 == 1
      // Modal Dialog
      //
      //hDlg := Wvt_DialogBox( aDlg, bDlgProc, Wvt_GetWindowHandle() )
      hDlg := Wvt_DialogBox( aDlg, cDlgProc, Wvt_GetWindowHandle() )
   else
      // Modeless Dialog
      //
      hDlg := Wvt_CreateDialog( aDlg, lOnTop, cDlgProc, cDlgIcon, /*nTimerTicks*/, hMenu )

      // Using Function name.
      //hDlg  := Wvt_CreateDialog( aDlg, lOnTop, cDlgProc, cDlgIcon, nTimerTicks, hMenu, lModal )
   endif

   Return hDlg

//-------------------------------------------------------------------//

Function DynDlgProc_2( hDlg, nMsg, wParam, lParam )
   Local /*cText,*/ lClicked, cPrompt, nIndex, hFont

   Switch ( nMsg )

   case WM_TIMER
      Win_SetDlgItemText( hDlg, ID_EDT_TIME, Time() )
      exit

   case WM_COMMAND
      do case

      case wParam == ID_CHK_SATIS
         lClicked := ( Win_IsDlgButtonChecked( hDlg,ID_CHK_SATIS ) == 1 )
         Win_MessageBox( hDlg, iif( lClicked, 'Satisfied', 'UnSatisfied' ), 'CheckBoxStatus' )

      case wParam == ID_RDO_XH
         Win_MessageBox( hDlg, '(x)Harbour', 'Compiler' )

      case wParam == ID_RDO_CLIP
         Win_MessageBox( hDlg, 'Clipper', 'Compiler' )

      case wParam == ID_RDO_XBASE
         Win_MessageBox( hDlg, 'Xbase++', 'Compiler' )

      case wParam == ID_MNU_FILE
         Win_MessageBox( hDlg, 'Execute Menu Action!', 'File' )

      case wParam == ID_MNU_CONTROL
         Win_MessageBox( hDlg, 'Controls are from Windows!', 'Controls' )

      case Win_LoWord( wParam ) == ID_LST_LIST
         if Win_HiWord( wParam ) == LBN_SELCHANGE
            nIndex  := Win_SendMessage( Win_GetDlgItem( hDlg, ID_LST_LIST ), LB_GETCURSEL, 0, 0 )
            cPrompt := space( 20 )
            Win_SendMessage( Win_GetDlgItem( hDlg, ID_LST_LIST ), LB_GETTEXT, nIndex, @cPrompt )
            Win_MessageBox( hDlg, cPrompt, 'ListBox' )
         endif

      case Win_LoWord( wParam ) == ID_CMB_COMBO
         if Win_HiWord( wParam ) == CBN_SELCHANGE
            nIndex  := Win_SendMessage( Win_GetDlgItem( hDlg, ID_CMB_COMBO ), CB_GETCURSEL, 0, 0 )
            cPrompt := space( 20 )
            Win_SendMessage( Win_GetDlgItem( hDlg, ID_CMB_COMBO ), CB_GETLBTEXT, nIndex, @cPrompt )
            Win_MessageBox( hDlg, cPrompt, 'Combo Box' )
         endif

      endcase
      exit

   case WM_CTLCOLOREDIT
      if ( Win_GetDlgItem( hDlg,ID_MLE ) == lParam )
         Win_SetTextColor( wParam, RGB( 0,0,255 ) )
         Win_SetBkColor( wParam, RGB( 255,255,200 ) )
         return ( 1 )
      elseif ( Win_GetDlgItem( hDlg,ID_EDT_TEXT ) == lParam )
         Win_SetTextColor( wParam, RGB( 255,255,255 ) )
         Win_SetBkColor( wParam, RGB( 10,200,45 ) )
         Return ( 1 )
      endif

      exit

   case WM_CTLCOLORSTATIC
      if ( Win_GetDlgItem( hDlg,ID_STA_TEXT ) == lParam )
         Win_SetTextColor( wParam, RGB( 255,255,255 ) )
         Return ( 1 )
      endif
      exit

   case WM_INITDIALOG
      Win_SetTimer( hDlg, 5001, 1000 ) // 1 sec

      if empty( ahFonts )
         if ( hFont := Wvt_CreateFont( "Times New Roman", 18 ) ) != 0
            aadd( ahFonts, hFont )
         endif
      endif

      if len( ahFonts ) > 0
         Win_SendMessage( Win_GetDlgItem( hDlg, ID_MLE ), WM_SETFONT, ahFonts[ 1 ], 0 )
      endif

      if shIcon == nil
         shIcon := Win_LoadIcon( 'Vr_1.ico' )
      endif
      if shIcon != nil .or. shIcon != 0
         Win_SendMessage( Win_GetDlgItem( hDlg, ID_ICO_VOUCH ), STM_SETIMAGE, IMAGE_ICON, shIcon )
      endif

      /*
      if shImage == nil
         shImage := Win_LoadImage( 'Vouch1.bmp', 2 )
      endif
      if shImage != nil .and. shImage != 0
         Win_SendMessage( Win_GetDlgItem( hDlg, ID_STA_IMAGE ), STM_SETIMAGE, IMAGE_BITMAP, shImage )
      endif
      */
      Win_SetDlgItemText( hDlg, ID_MLE      , GetEditText() )
      Win_CheckDlgButton( hDlg, ID_CHK_SATIS, .t.           )

      Win_CheckRadioButton( hDlg, ID_RDO_XH, ID_RDO_XBASE, ID_RDO_XH )

      Wvt_LBAddString( hDlg, ID_LST_LIST, '(x)Harbour'  )
      Wvt_LBAddString( hDlg, ID_LST_LIST, 'Gtwvt'     )
      Wvt_LBAddString( hDlg, ID_LST_LIST, 'Wvtgui'    )
      Wvt_LBAddString( hDlg, ID_LST_LIST, 'Modeless'  )
      Wvt_LBAddString( hDlg, ID_LST_LIST, 'Dialogs'   )
      Wvt_LBAddString( hDlg, ID_LST_LIST, 'WVT'       )

      Wvt_LBSetCurSel( hDlg, ID_LST_LIST, 1 )

      Wvt_CBAddString( hDlg, ID_CMB_COMBO, 'First'    )
      Wvt_CBAddString( hDlg, ID_CMB_COMBO, 'Second'   )
      Wvt_CBAddString( hDlg, ID_CMB_COMBO, 'Third'    )
      Wvt_CBAddString( hDlg, ID_CMB_COMBO, 'Fourth'   )
      Wvt_CBAddString( hDlg, ID_CMB_COMBO, 'Fifth'    )

      Wvt_CBSetCurSel( hDlg, ID_CMB_COMBO, 1 )

      Win_InvalidateRect( hDlg )

      exit

   case WM_DESTROY
      // Do whatevert you want to do with cText
      // Each box will retrieve its own text.
      //
      /*cText :=*/ Win_GetDlgItemText( hDlg, ID_MLE )
      //cText := nil
      exit

   end

   Return ( 0 )

//-------------------------------------------------------------------//

static function GetEditText()
   Local cText := ''

   cText += 'Welcome in the Wonderful World of (x)Harbour!'
   cText += CRLF + CRLF
   cText += 'When Peter Rees first published GTWVT, a Windows '
   cText += 'Terminal Driver, on 22 Dec 2003, everybody took it '
   cText += 'lightly, except for me, as I was aware that what '
   cText += 'wonderful contribution to (x)Harbour he has made, '
   cText += 'what immense possibilities he has opened for (x)Harbour '
   cText += 'developers, what limitations he has cleared for Clipper '
   cText += 'savvy user base.'
   cText += CRLF + CRLF
   cText += 'With a little effort I could extend GTWVT '
   cText += 'to give it a GUI look. I also tried to give it '
   cText += 'an event driven functionality, and up came Wvt*Classes.'
   cText += CRLF + CRLF
   cText += 'And yet another feather is added in the cap of GTWVT '
   cText += 'as it is now capable of firing modeless dialogs like the one '
   cText += 'you are viewing. These dialogs can be constructed dynamically ( Courtesy What32 ) '
   cText += 'at run time or can be one of resources. At present 20 such dialogs '
   cText += 'can be active at any given time. Also note that dialogs created '
   cText += 'dynamically respect Top, Left, Rows, Cols coordinates, which is an '
   cText += 'undisputed productivity boost!'
   cText += CRLF + CRLF
   cText += 'Enjoy!' + CRLF
   cText += 'Pritpal Bedi, INDIA'

   Return cText

//-------------------------------------------------------------------//

EXIT PROCEDURE CleanHandles()
   LOCAL i

   for i := 1 to len( ahFonts )
      Win_DeleteObject( ahFonts[ i ] )
   next

   if shIcon != nil
      Win_DeleteObject( shIcon )
   endif

   if shImage != nil
      Win_DeleteObject( shImage )
   endif

   Return

//-------------------------------------------------------------------//

FUNCTION DlgSlideShow()
   LOCAL hDlg, aDlg, nStyle

   aSlides := { 'Vouch1.bmp', 'V_Notes.ico', '2000.gif', 'V_Lock.bmp', 'V_Help.ico' }

   nStyle  := DS_SETFONT + WS_VISIBLE + WS_POPUP + WS_CAPTION + WS_SYSMENU + WS_THICKFRAME + WS_MINIMIZEBOX

   aDlg    := Wvt_MakeDlgTemplate( 0, 0, 20, 40, {}, 'Slide Show', nStyle )

   hDlg    := Wvt_CreateDialog( aDlg, .f., 'DlgSlideShowProc', 'Vr_1.ico', 5000 )

   Return hDlg

//-------------------------------------------------------------------//

FUNCTION DlgSlideShowProc( hDlg, nMsg, wParam, lParam )
   STATIC nSlide := 1

   HB_SYMBOL_UNUSED( wParam )
   HB_SYMBOL_UNUSED( lParam )

   Switch nMsg

   case WM_INITDIALOG
      DrawSlide( hDlg, nSlide )
      exit

   case WM_PAINT
      DrawSlide( hDlg, nSlide )
      exit

   case WM_TIMER
      nSlide++
      if nSlide > len( aSlides )
         nSlide := 1
      endif
      DrawSlide( hDlg, nSlide )

      exit

   end

   Return ( 0 )

//-------------------------------------------------------------------//

FUNCTION DrawSlide( hDlg, nSlide )
   LOCAL hDC, aRect

   hDC   := Win_GetDC( hDlg )
   aRect := Win_GetClientRect( hDlg )

   Win_Rectangle( hDC, aRect[ 1 ]+10, aRect[ 2 ]+10, aRect[ 3 ]-10, aRect[ 4 ]-10 )
   Win_DrawImage( hDC, aRect[ 1 ]+10, aRect[ 2 ]+10, aRect[ 3 ] - aRect[ 1 ] -20, ;
                                  aRect[ 4 ] - aRect[ 2 ] - 20, aSlides[ nSlide ] )

   Win_ReleaseDC( hDlg,hDC )

   Return nil

//----------------------------------------------------------------------//

STATIC FUNCTION MyDialogLocal()

*   LOCAL aObjects := WvtSetBlocks( {} )

   Local nWinRows, nWinCols, cWinTitle, cFont, nHeight
   Local cUseAlias
   Local oText, oTBar, aImg_, oImg, oLine, oBox, oBtn, oBtn2
   Local oBBox, oCon, oGet, oBBox2, oTBx
   Local oBRsd, cTxt, oRct, nGetCol, nSayCol, bBlock, bBlock1
   Local oWvtBrw, oWvtBrw1, lOpen, lOpen1, cUseAlias1, oGetArea, oGet1
   LOCAL hPopup, nGetRow, aGets_, lChkMouse
   LOCAL g_oMenuBar, oMenu,oPBar3
   LOCAL dDate   := ctod( '' )
   LOCAL cName   := Pad( 'Pritpal Bedi', 35 )
   LOCAL cAdd1   := Pad( '60, New Professor Colony', 35 )
   LOCAL cAdd2   := Pad( 'Ludhiana, INDIA', 35 )
   LOCAL cAdd3   := Pad( 'http://www.vouchcac.com', 35 )
   LOCAL nColGet := 8
   LOCAL nSlry   := 20000


   STATIC sUnits := 18
   STATIC lUnits := 10

   aBlocks := {}

*   aAdd( aBlocks, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
   aLastPaint := WvtSetBlocks( aBlocks )

*   REQUEST SDDODBC,SQLMIX,SIXCDX
   REQUEST SQLMIX,SIXCDX
   ANNOUNCE RDDSYS

   RDDSETDEFAULT("SQLMIX")

   if file("CONFIG.CFG")
      le_config()
   else
     _PATHSQL_  = "servidor/3050:C:\dados\CIRUR.fdb"  // local
     _PATHODBC_ = ""
   endif

   cAttributes:="Server=;Database=" + _PATHSQL_ + ";User=SYSDBA;Password=masterkey;Driver={Firebird/InterBase(r) driver};DIALECT=3"

   //cAttributesInova:="Server=;Database=" + _PATH_INOVA_ + ";User=SYSDBA;Password=masterkey;Driver={Firebird/InterBase(r) driver};DIALECT=3"


*   cAttributesODBC:="Server=;Database=" + _PATHSQL_ + ";User=SYSDBA;Password=masterkey;Driver={Firebird/InterBase(r) driver};DIALECT=3"

   if empty(_PATHODBC_)  // se odbc nao configurado pegamos mesmo path
     cAttributesOdbc:= cAttributes
   else
     cAttributesOdbc:=    cAttributes:="Server=;Database=" + _PATHODBC_ + ";User=SYSDBA;Password=masterkey;Driver={Firebird/InterBase(r) driver};DIALECT=3"
     cAttributesOdbc:=  _PATHODBC_
   endif

   db := FBConnect(_PATHSQL_, "SYSDBA", "masterkey")
//   db_inova := FBConnect(_PATH_INOVA_, "SYSDBA", "masterkey")

*   nConn := RDDINFO( RDDI_CONNECT,{"ODBC", cAttributesOdbc} )  // este somente conecta assim funciona

//   nConn_inova := RDDINFO( RDDI_CONNECT,{"ODBC", cAttributesInova} )  // este somente conecta assim funciona
   nConn := RDDINFO( RDDI_CONNECT,{"ODBC", cAttributesOdbc} )  // este somente conecta assim funciona

   // quando na nuvem criar conexao ODBC
   // nConn := RDDINFO( RDDI_CONNECT,{"ODBC","DSN=TESTE"} )


   IF nConn == 0
     nHan := FCreate("errosql.txt")   // a tentar CRIAR.
     FWrite( nHan, "nao conectado" )
     FClose( nHan )   // Fechamos o Arquivo.
     @ 24, 00 SAY "Unable connect to the server"
     ALERT("NAO CONECTADO")
     RETURN
   else
     nHan := FCreate("errosql.txt")   // a tentar CRIAR.
     FWrite( nHan, "conectado" )
     FClose( nHan )   // Fechamos o Arquivo.
   eNDIF

   nWinRows  := 28
   nWinCols  := 110
   cWinTitle := 'Sistema Integrado V. 4.3'
   cFont     := 'VISUALNOVA'

   nHeight   := 10
   _FONTET_   = 5

   _FONTET_   = 10
   _FONTEL_   = 5

    nHeight = 0
    nWidth  = 0

    lMaquinaok := .f.

    sqlORDEM = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {"CONFIGURAR","SELECT"}
    aadd(sqlCHAVE,{"MAQUINA",aspas(netname())})

    if executasql()
       if FONTET > 0
         lMaquinaok := .t.
         nHeight = FONTET
       endif
       if FONTEL > 0
         nWidth = FONTET
       endif
       wvw_SETFONT(,'VisualLib', FONTET, FONTET, 0,255 )
    endif

   _FONTET_   = nHeight
   _FONTEL_   = nWidth

   msgbox1("passei")


*   aImg_:={}
*   aadd( aImg_, 'v_lock.bmp'   )
*   aadd( aImg_, 'v_new.bmp'    )
*   aadd( aImg_, 'v_clclt.bmp'  )
*   aadd( aImg_, 'v_calend.bmp' )
*   aadd( aImg_, 'v_index.bmp'  )
*   aadd( aImg_, 'v_notes1.bmp' )
*   aadd( aImg_, 'v_selct1.bmp' )

*   oTBar := WvtToolbar():New( oDlg,103, 6,0,1)
*   oTBar:lFloating := .f.
*   oTBar:Tooltip   := 'Toolbar'
*   oTBar:AddButton( aImg_[ 1 ], {|| oImg:SetImage( aImg_[ 1 ] ) } , 'Lock' )
*   oTBar:AddButton( aImg_[ 2 ], {|| oImg:SetImage( aImg_[ 2 ] ), oText:SetText( '(x)Harbour' ) } , 'New' )
*   oTBar:AddButton( aImg_[ 3 ], {|| oImg:SetImage( aImg_[ 3 ] ) } , 'Calculator' )
 *  oTBar:AddButton()
 *  oTBar:AddButton( aImg_[ 5 ], {|| oImg:SetImage( aImg_[ 5 ] ) } , 'Restore' )
 *  oTBar:AddButton( aImg_[ 4 ], {|| oImg:SetImage( aImg_[ 4 ] ), oText:SetText( 'Vouch' )    } , 'Calendar' )
 *  oTBar:AddButton( aImg_[ 6 ], {|| oImg:SetImage( aImg_[ 6 ] ) } , 'Notes' )
 *  oTBar:AddButton( aImg_[ 7 ], {|| oImg:SetImage( aImg_[ 7 ] ) } , 'Press to Send Browse on Top' )
 *  oTBar:AddButton()
 *  oDlg:AddObject( oTBar )


*           |                 |            |                 |                 |                 |

   oBar := WvtStatusBar():New( oDlg,201 )
   oBar:SetPanels({12,30,43,61,79,97 } )
   oBar:update(1,padc(alltrim(cF_ATV),14))
   oBar:update(2,padc(alltrim(cF_MOD),13))
   oBar:update(3,pad(M_LOGNOM,12),"G/W")
   oBar:update(4,pad(cF_PRG,13))
   oBar:update(5,"EMPRESA: " + STR(ME_EMP,2))
   oBar:update(6,"  " + dtoc(date()))

   // voltar
*   oBar:update(7,time())

   oDlg:AddObject( oBar )

   oBar2 := WvtStatusBar():New( oDlg,201,nWinRows-2, -1, nWinRows-2, nWinCols)
   oBar2:SetPanels({nWinCols} )
*   oBar2:update(1,padc(alltrim(" "),nWinCols),"GR+/N")
   oDlg:AddObject( oBar2 )

   oPBar3a := WvtProgressBar():New( oDlg, , nWinRows - 3, 0, nWinRows - 3, nWinCols - 1 )
   oPBar3a:nBarColor  := RGB( 0,128,0 )
   oPBar3a:cBackColor := 'W/N*'
   oPBar3a:lVertical  := .f.
   oPBar3a:nDirection := 0
   oDlg:AddObject( oPBar3a )
   
   oPBar2 := WvtProgressBar():New( oDlg, , nWinRows - 1, 0, nWinRows - 1, nWinCols - 1 )
   oPBar2:nBarColor  := RGB( 0,128,0 )
   oPBar2:cBackColor := 'W/N*'
   oPBar2:lVertical  := .f.
   oPBar2:nDirection := 0
   oDlg:AddObject( oPBar2 )



*
* g_oMenuBar := WvtMenu():new():create()
* oMenu      := WvtMenu():new():create()
*  oMenu:Caption := 'Other Dialogs'
*  oMenu:AddItem( 'Dialog Two', {|| MyDialogTwo() } )
*  oMenu:AddItem( '-' )
*  oMenu:AddItem( 'Exit',       {|| Wvt_Keyboard( K_ESC ) } )
*  oMenu:AddItem( 'Empresa', {|| MyDialogTwo() } )
*  oMenu:AddItem( 'Estoque', {|| MyDialogTwo() } )
*  oMenu:AddItem( 'Kardex', {|| MyDialogTwo() } )
*  oMenu:AddItem( 'Nota', {|| MyDialogTwo() } )
*  oMenu:AddItem( 'Forecedor', {|| MyDialogTwo() } )
*  oMenu:AddItem( 'Produtos', {|| MyDialogTwo() } )

*  g_oMenuBar:addItem( "",oMenu )

   */*/*/

*   oDlg:oMenu := CreateMainMenu()


*   lOpen1 := .f.
*   cUseAlias1 := 'TEST1'
*   USE 'TEST' NEW ALIAS ( cUseAlias1 ) SHARED   VIA "DBFCDX"
*   if !NetErr()
*      lOpen1 := .t.
*      oWvtBrw1 := CfgMyBrowse( { 1,2,3,4,5,6 }, cUseAlias1, { 43,4,51,120 }, 'Test.dbf - 1,2,3,4,5,6',oDlg, 'N/BG*,N/W*',1002 )
*      oDlg:AddObject( oWvtBrw1 )
*   endif


*   oBtn := WvtPushButton():New(oDlg, 20, 6, 22, 8, 35 )
*   oBtn:cCaption  := 'Print'
*   oBtn:bOnLeftUp := {|| Wvt_Keyboard( 379 ) }
*   oBtn:Tooltip   := 'Open Printing Dialog for the Browser in Focus'

*   oDlg:AddObject( oBtn )


*   oText := WvtLabel():New( oDlg, 101, 4, oDlg:MaxCol()-40, 7,oDlg:MaxCol()-2 )
*   oText:Text              := 'teste de mensagem para ver como fica quando o texto e maior'
*   oText:nFontHeight       := 36
*   oText:nAlignHorz        := 2
*   oText:nAlignVert        := 2
*   oText:nFontWeight       := 700
*   oText:nTextColor        := RGB( 100, 255,  12 )
*   oText:nBackColor        := RGB(   0,   0, 255 )
*   oText:nTextColorHoverOn := RGB( 255, 255,   0 )
*   oText:nBackColorHoverOn := RGB( 255, 100,  12 )
*   oText:lItalic           := .f.
*   oText:ToolTip           := 'Software that GROWS with you'
*   oText:bOnSelect         := {|| .t. }

 *  oDlg:AddObject( oText )


   REQUEST DBFCDX
   RDDSETDEFAULT("DBFCDX")


   oDlg1:Create()
*   oDlg:Create()

   if !alltrim(upper(netname())) $ "#SERVIDOR#"
    oScriptObj := CREATEOBJECT( "wbemScripting.SwbemLocator" )
    oWmiService := oScriptObj:ConnectServer()
    oListaProcess := oWmiService:ExecQuery( "select * from Win32_Process where Name='Cirursql.exe'" )
     oProcessos = ""
     nQdeInstancia = 0
     for Each oProcessos in oListaProcess
       nQdeInstancia ++
     next
     if nQdeInstancia > 1
        MSGBOX1("O programa ja se encontra em uso!","Verifique no rodape")
        quit
     endif
   endif

   if !lMaquinaok

     For ABC = 1 to 40
       sUnits += 1
       Wvt_setFont( 'Visualnova', sUnits)
     next

     fnt_:= Wvt_GetFontInfo()
     sUnits = fnt_[ 2 ]

     sUnits -= 1
     Wvt_setFont( 'Visualnova', sUnits)
     fnt_:= Wvt_GetFontInfo()
     sUnits = fnt_[ 2 ]


  *   lUnits = ((sUnits * 12)/23)
  *   Wvt_setFont( 'Visualnova', sUnits,lUnits)

     For ABC = 1 to 40
       Wvt_setFont( 'Visualnova', sUnits,lUnits)
       lUnits += 1
      next

     fnt_:= Wvt_GetFontInfo()
      Wvt_setFont( 'Visualnova', fnt_[ 2 ],fnt_[ 3 ])
     _FONTET_   = fnt_[ 2 ]
     _FONTEL_   = fnt_[ 3 ]

     sqlORDEM = {}
     sqlCAMPO = {}
     sqlCHAVE =  {}
     sqlARQUI = {"CONFIGURAR","UPDATE OR INSERT"}
     aadd(sqlCHAVE,{"MAQUINA"})
     aadd(sqlCAMPO,{"MAQUINA",netname(),.t.})
     aadd(sqlCAMPO,{"FONTET",str(_FONTET_,3),.f.})
     aadd(sqlCAMPO,{"FONTEL",str(_FONTEL_,3),.f.})
     executasql()

   endif



*DynDlgProc_2()

*   msg("down")
*   obtn:LeftDown()

*   msg("up")
*
*   obtn:LeftUp()

   SetColor( 'N/W,N/GR*,,,N/W*' )

*   @  6, nColGet SAY '< Date >'
*   @  9, nColGet SAY '<' + PadC( 'Name', 33 ) + '>'
*   @ 12, nColGet SAY '<' + PadC( 'Address', 33 ) + '>'
*   @ 16, 61      SAY '< Salary >'

*   dDate := ctod( '04/01/04' )

*   @  7, nColGet GET dDate WHEN  DispStatusMsg( 'Date must be Valid' );
*                           VALID ClearStatusMsg()
*   @ 10, nColGet GET cName WHEN  DispStatusMsg( 'Must be one of the list!' );
*                           VALID ( VouChoice() < 7 .and. ClearStatusMsg() )
*   @ 13, nColGet GET cAdd1
*   @ 15, nColGet GET cAdd2
*   @ 17, nColGet GET cAdd3
*   @ 17, 61      GET nSlry PICTURE '@Z 9999999.99'
*   READ

*    mankar(3,1)

*s_amiscobjlist := {}      //x misc object list (actually: list of codeblocks)
*s_aGuiObjs := {}
*   sbGuiSupport   := .t.
*   sbGuiSupportEx := .t.
*REQUEST HB_LANG_PT
*REQUEST HB_CODEPAGE_PT850
*REQUEST WvW_GetScreenWidth
*REQUEST WVw_SetFont
*REQUEST WVw_SetCodePage

*wvw_setcodepage(,255)
*SETMODE(25,80)  // VOLTAR
*wvw_SetFont(0,alltrim(_FONTEN_),_FONTET_,_FONTEL_,200,1)
*WVW_SetMainCoord(, .t. )  // for‡a o maxrow ser a 1a linha da janela
*wvw_setcodepage(,255)
*SETMODE(25,80)  // VOLTAR

*wvw_setmaincoord(.T.)
*WVW_SetCodePage(,255)
*WvW_SetMouseMove( .t. )
*WvW_SetTitle(, 'Visual OPAS - Sistema de Controle Empresarial Vs. 4.3.6' )
*wvw_SetVertCaret(.T.)
*WvW_SetPaintRefresh( 200 )
*WvW_SetAltF4Close( .F. )
*WvW_SetMainCoord( .T. )
*wvw_setmaincoord(.T.)
*WVW_SetCodePage(,255)
*WvW_SetMouseMove( .t. )
*wvw_SetVertCaret(.T.)
*WvW_SetPaintRefresh( 2200 )
*WvW_SetAltF4Close( .F. )
*WvW_SetMainCoord( .T. )

*hWndlocal  := WVW_nNumWindows()

// funciona perfeitamente
*REQUEST DBFCDX
RDDSETDEFAULT("DBFCDX")
REQUEST DBFCDX

*IMPORTARDBF()

* sqlRELATION = {}
* sqlCAMPO = {}
* sqlCHAVE =  {}
* sqlARQUI = {}
* sqlORDEM = {}

* aadd(sqlARQUI,{"AGRP00","AGRP00"})
* aadd(sqlCAMPO,"max(GRPCOD)")
* sqlrelation()


*oSQL_Conect:= Todbc():new('DRIVER=Firebird/InterBase(r) driver;UID=SYSDBA;PWD=masterkey;DBNAME='+_PATHSQL_+";'")

*/

*WVT_MESSAGEBOX("teste")



*lin = 1
*for AB = 1 to 500
*  @ lin, 10 say str(ab,3) + chr(ab)
*  if lin = 25
*    inkey(0)
*    clear
*    lin = 1
*  endif
*  lin ++
*next

*inkey(0)

*ABRE_PROF()

*ABRE_CTA()
*CRIADBFTOSQL("ACTA00",.T.)

*M_CLICOD = 53742
*do while .t.
*  sqlCAMPO = {}
*  sqlCHAVE = {}
*  sqlARQUI = {"ACLI00","INSERT"}
*  aadd(sqlCAMPO,{"CLICOD",str(M_CLICOD,6),.T.})
*  if !executasql()
*    if nMotivoSQL == "DUPLICADO"
*      M_CLICOD ++
*      loop
*    endif
*  endif
*  exit
*enddo

*msgbox1("OK CODIGO: " + str(M_CLICOD,6))

*ACERTAR()

*TIRA_NULLO("ADEV00")
*TIRA_NULLO("AMAR01")


********************************


*DynDialog_2()

*cAttributes:="Server=;Database=" + _PATHSQL_ + ";User=SYSDBA;Password=MASTERKEY;Driver={Firebird/InterBase(r) driver};DIALECT=3"

*oCn := TOLEAUTO():New("ADODB.Connection")

*CNN:=CreateObject("ADODB.Connection")
*ocn:Open("DRIVER=Firebird/InterBase(r) driver;User=SYSDBA;Password=MASTERKEY;Persist Security Info=True;Location=" + _PATHSQL_ + ";ctype=ISO8859_1;auto_commit=True;dbclient_library=fbclient.dll")
*oCn:ConnectionString := "Server=;Database=" + _PATHSQL_ + ";User=SYSDBA;Password=MASTERKEY;Driver={Firebird/InterBase(r) driver};DIALECT=3"
*oCn:Open()

*cn := CreateObject( "ADODB.Connection" )
*CN:stringconnection

*fbserver.com.br/4050:/firebird/db/SYSDBA30/CIRUR.FDB
*CN:Open("DRIVER=Firebird/InterBase(r) driver;Persist Security Info=True;User=SYSDBA;Password=MASTERKEY;Database=" + _PATHSQL_ + ";auto_commit=True;dbclient_library=fbclient.dll")
*cn:Open(_PATHSQL_)

public cInicIMG3
public cInicIMG4



MS = strzero(ME_EMP,2)
XMSG_1&MS = space(80)
XMSG_2&MS = space(80)
XMSG_3&MS = space(80)
XMSG_4&MS = space(80)
XMSG_5&MS = space(80)
XMSG_6&MS = space(80)
XMSG_7&MS = space(80)
XMSG_8&MS = space(80)
XMSG_9&MS = space(80)




SELEEMPRESA()


lNanuvem = .f.

*abre_emp()

   oDlg1:Destroy()
   oDlg:Create()

   // somente este para o timer

   Win_SetTimer( oDlg, 5001, 1000 ) // 1 sec
   ShowTime( maxrow(), MaxCol()-9,,"N/W" ,.F. , .T. )

wvt_DrawImage(2, 0, maxrow()-1, maxcol(), AEMP00->EMPLOGO)
cInicIMG4 := Wvt_SaveScreen(2, 0, maxrow()-2, maxcol())  // salva a tela

( devpos(MAXROW()-1, 0) , devout(padc("", Maxcol()+1),"N/W*") )

   novomenu()

   oDlg:Execute()
   oDlg:Destroy()

   WvtSetBlocks( aObjects )
   WvtSetKeys( .t. )
   Wvt_SetPopupMenu( hPopup )
   SetMouseCheck( lChkMouse )

   RETURN Nil

*****************
FUNCTION NOVOMENU
*****************

local aEnv


set key K_F10 to VLMARQUEE()  //Funcao utilizar  VLExit() da Visual Lib

//set key K_F10 to Saida  //Funcao utilizar  VLExit() da Visual Lib

SetKeyMouse( K_F1,  { 24, 24, 00, 07 } ) //VL-Associa tecla de fun‡Æo … uma
//SetKeyMouse( K_F10, { 24, 24, 72, 79 } ) //regiao da tela - uso do mouse

//VL-Desenha a  rea de trabalho e inicializa mouse
Desktop(alltrim("")) //Fun‡Æo que inicializa a Visual Lib - Sempre deve ser chamada no inicio

*DrawFn( 01, "Sobre" )   //VL-Desenha fun‡Æo na linha 24
*DrawFn( 02, "Ajuda" )   //VL-Desenha fun‡Æo na linha 24
*DrawFn( 10, "Sa¡da" )   //VL-Desenha fun‡Æo na linha 24

mBar := NewBarMenu()            //(VL) Cria Menu de Barra

mEst := NewDownMenu()           //(VL) Cria Menu Down vinculado a mBar
mFat := NewDownMenu()           //(VL) Cria Menu Down vinculado a mBar
mRec := NewDownMenu()           //(VL) Cria Menu Down vinculado a mBar
mPag := NewDownMenu()           //(VL) Cria Menu Down vinculado a mBar
mBan := NewDownMenu()           //(VL) Cria Menu Down vinculado a mBar
mCai := NewDownMenu()           //(VL) Cria Menu Down vinculado a mBar
mOut := NewDownMenu()           //(VL) Cria Menu Down vinculado a mBar

mOpcoes := NewDownMenu()          //(VL) Cria Sub-Menu vinculado a mPdn

mEstemp := NewDownMenu()
mEstpro := NewDownMenu()
mEstfor := NewDownMenu()           //(VL) Cria Menu Down vinculado a mBar
mEstKar := NewDownMenu()
mEstGru := NewDownMenu()
mEstNcm := NewDownMenu()
mEstNfe := NewDownMenu()


AddDownItem( mEst, "&Empresas"           ,,mEstemp,,,,,1)
AddDownItem( mEst, "&Produtos"           ,,mEstpro,,,,,2 )
AddDownItem( mEst, "&Fornecedores"       ,,mEstFor,,,,,3 )
AddDownSep ( mEst )                                       // Linha de separa‡Æo
AddDownItem( mEst, "&Kardex"             ,,mEstkar,,,,,4 )
AddDownItem( mEst, "&Grupos"             ,,mEstGru,,,,,5 )
AddDownItem( mEst, "&Codigo NCM"         ,,mEstNcm,,,,,6 )
AddDownSep ( mEst )                                                // Linha de separa‡Æo
AddDownItem( mEst, "&Nota Fiscal Entrada",,mEstNfe,,,,,7)

*AddDownItem( mPdnSet, "Set &1", "Habilita/Desabilita Set 1", { || SetDownItem( mPdnSet, 1, !SetDownItem( mPdnSet, 1 ) ) } )

// EMPRESA
   AddDownItem( mEstemp, "&InclusÆo"  ,,{ || manemp(1) },,,,,8)
   AddDownItem( mEstemp, "&Altera‡Æo" ,,{ || manemp(2) },,,,,9)
   AddDownItem( mEstemp, "&Consulta"  ,,{ || manemp(3) },,,,,10)
   AddDownItem( mEstemp, "&ExclusÆo"  ,,{ || manemp(4) },,,,,11)
   AddDownItem( mEstemp, "&Listagem"  ,,{ || manemp(5) },,,,,12)
   AddDownItem( mEstemp, "&Parametro" ,,{ || manemp(6) },,,,,13)

// PRODUTOS
AddDownItem( mEstpro, "&InclusÆo"                   ,,{ ||manpro(1)},,,,,14)
AddDownItem( mEstpro, "&Altera‡Æo"                  ,,{ ||manpro(2)},,,,,15)
AddDownItem( mEstpro, "&Consulta"                   ,,{ ||manpro(3)},,,,,16)
AddDownItem( mEstpro, "&ExclusÆo"                   ,,{ ||manpro(4)},,,,,17)
   mEstProlis := NewDownMenu()
   AddDownItem( mEstProlis, "&Rela‡„o de Compra"      ,,{ ||manpro(5,1)},,,,,18 )
   AddDownItem( mEstProlis, "&Rela‡„o por Grupo"      ,,{ ||manpro(5,2)},,,,,19 )
   AddDownItem( mEstProlis, "&Lista Pre‡os Venda"     ,,{ ||manpro(5,3)},,,,,20 )
   AddDownItem( mEstProlis, "&Planilha Balanco"       ,,{ ||manpro(5,4)},,,,,21 )
   AddDownItem( mEstProlis, "&Inventario Conferencia" ,,{ ||manpro(5,5)},,,,,22 )

     mEstProlisSaldo := NewDownMenu()
     AddDownItem( mEstProlisSaldo, "&Saldos de todos os Produtos"       ,,{ ||manpro(5,6,1)},,,,,23 )
     AddDownItem( mEstProlisSaldo, "&Produtos Com Saldo Positivo"       ,,{ ||manpro(5,6,2)},,,,,24 )
     AddDownItem( mEstProlisSaldo, "&Produtos Com Saldo Negativo"       ,,{ ||manpro(5,6,3)},,,,,25 )
     AddDownItem( mEstProlisSaldo, "&Produtos Com Saldo Zerado"         ,,{ ||manpro(5,6,4)},,,,,26 )
     AddDownItem( mEstProlisSaldo, "&N„o Movimentados desde (MM/AA)"    ,,{ ||manpro(5,6,5)},,,,,27 )
     AddDownItem( mEstProlisSaldo, "&Produtos Acima Estoque MAXIMO"     ,,{ ||manpro(5,6,6)},,,,,28 )
     AddDownItem( mEstProlisSaldo, "&Produtos Abaixo Estoque MINIMO"    ,,{ ||manpro(5,6,7)},,,,,29 )

   AddDownItem( mEstProlis, "&Lista de Saldos"       ,,mEstProlisSaldo     ,,,,,30 )
   AddDownItem( mEstProlis, "&Inventario Efetivo"    ,,{ ||manpro(5,7)}    ,,,,,31 )

     mEstProlisFabri := NewDownMenu()
     AddDownItem( mEstProlisFabri, "&Saldos de todos os Produtos"       ,,{ ||manpro(5,8,1)},,,,,32 )
     AddDownItem( mEstProlisFabri, "&Produtos Com Saldo Positivo"       ,,{ ||manpro(5,8,2)},,,,,33 )
     AddDownItem( mEstProlisFabri, "&Produtos Com Saldo Negativo"       ,,{ ||manpro(5,8,3)},,,,,34 )
     AddDownItem( mEstProlisFabri, "&Produtos Com Saldo Zerado"         ,,{ ||manpro(5,8,4)},,,,,35 )
     AddDownItem( mEstProlisFabri, "&N„o Movimentados desde (MM/AA)"    ,,{ ||manpro(5,8,5)},,,,,36 )
     AddDownItem( mEstProlisFabri, "&Produtos Acima Estoque MAXIMO"     ,,{ ||manpro(5,8,6)},,,,,37 )
     AddDownItem( mEstProlisFabri, "&Produtos Abaixo Estoque MINIMO"    ,,{ ||manpro(5,8,7)},,,,,38 )

   AddDownItem( mEstProlis, "&Lista por Fabricante"  ,,mEstProlisFabri    ,,,,,39 )
   AddDownItem( mEstProlis, "&Classificacao Fiscal"  ,,{ ||manpro(5,9)}   ,,,,,40 )

AddDownItem( mEstpro, "&Listagem"                   ,,mEstProlis          ,,,,,41 )
   mEstProPre := NewDownMenu()
   AddDownItem( mEstProPre, "&Altera pre‡o Custo"   ,,{ ||manpro(6,1)}      ,,,,,42 )
   AddDownItem( mEstProPre, "&Altera pre‡o Venda"   ,,{ ||manpro(6,2)}      ,,,,,43 )
   AddDownItem( mEstProPre, "&Altera pre‡o Geral"   ,,{ ||manpro(6,3)}      ,,,,,44 )
AddDownItem( mEstpro, "&Pre‡os"                     ,,mEstProPre            ,,,,,45 )
AddDownItem( mEstpro, "&Arquivo Morto"              ,,{ ||manpro(7)}        ,,,,,46 )
AddDownItem( mEstpro, "&Codigos Fornecedores"       ,,{ ||manpro(8)}        ,,,,,47 )

// FORNECEDOR
AddDownItem( mEstFor, "&InclusÆo"     ,,{ ||manfor(1)},,,,,48)
AddDownItem( mEstFor, "&Altera‡Æo"    ,,{ ||manfor(2)},,,,,49)
AddDownItem( mEstFor, "&Consulta"     ,,{ ||manfor(3)},,,,,50)
AddDownItem( mEstFor, "&ExclusÆo"     ,,{ ||manfor(4)},,,,,51)
AddDownItem( mEstFor, "&Listagem"     ,,{ ||manfor(5)},,,,,52)
AddDownItem( mEstFor, "&Etiquetas"    ,,{ ||manfor(6)},,,,,53)
AddDownItem( mEstFor, "&Arquivo Morto",,{ ||manfor(7)},,,,,54)

AddDownItem( mEstkar, "&InclusÆo"                   ,,{ ||mankar(1)}   ,,,,,55)
AddDownItem( mEstkar, "&Altera‡Æo"                  ,,{ ||mankar(2)}   ,,,,,56)

   mEstkarConsulta := NewDownMenu()
   AddDownItem( mEstkarConsulta, "&Movimento"      ,,{ ||mankar(3,1)} ,,,,,57)
   AddDownItem( mEstkarConsulta, "&Compras"        ,,{ ||mankar(3,2)} ,,,,,58)
   AddDownItem( mEstkarConsulta, "&Vendas"         ,,{ ||mankar(3,3)} ,,,,,59)
   AddDownItem( mEstkarConsulta, "&Grafico V"      ,,{ ||mankar(3,4)} ,,,,,60)
   AddDownItem( mEstkarConsulta, "&Grafico C"      ,,{ ||mankar(3,5)} ,,,,,61)
AddDownItem( mEstkar, "&Consulta"                  ,,mEstkarConsulta  ,,,,,62)
AddDownItem( mEstkar, "&ExclusÆo"                  ,,{ ||mankar(4)}   ,,,,,63)
   mEstkarListagem := NewDownMenu()
   AddDownItem( mEstkarListagem, "&Movimento"      ,,{ ||mankar(5,1)} ,,,,,64)
   AddDownItem( mEstkarListagem, "&Entrada/Saida"  ,,{ ||mankar(5,2)} ,,,,,65)
AddDownItem( mEstkar, "&Listagem"                  ,,mEstkarListagem  ,,,,,66)
   mEstkarOutros := NewDownMenu()
   AddDownItem( mEstkarOutros, "&Saldo Individual"  ,,{ ||mankar(6,1)} ,,,,,67)
   AddDownItem( mEstkarOutros, "&Saldo Geral"       ,,{ ||mankar(6,2)} ,,,,,68)
   AddDownItem( mEstkarOutros, "&Custo Medio"       ,,{ ||mankar(6,3)} ,,,,,70)
   AddDownItem( mEstkarOutros, "&Grafico Anual"     ,,{ ||mankar(6,4)} ,,,,,71)
   AddDownItem( mEstkarOutros, "&Finaliza Exercicio",,{ ||mankar(6,5)} ,,,,,72)
AddDownItem( mEstkar, "&Outros"                     ,,mEstkarOutros    ,,,,,73)


AddDownItem( mEstGru, "&InclusÆo" ,,{ ||mangrp(1)},,,,,74)
AddDownItem( mEstGru, "&Altera‡Æo",,{ ||mangrp(2)},,,,,75)
AddDownItem( mEstGru, "&Consulta" ,,{ ||mangrp(3)},,,,,76)
AddDownItem( mEstGru, "&ExclusÆo" ,,{ ||mangrp(4)},,,,,77)
AddDownItem( mEstGru, "&Listagem" ,,{ ||mangrp(5)},,,,,78)


AddDownItem( mEstNfe, "&InclusÆo"             ,,{ ||mannfe(1)}   ,,,,,79)
AddDownItem( mEstNfe, "&Altera‡Æo"            ,,{ ||mannfe(2)}   ,,,,,80)
AddDownItem( mEstNfe, "&Consulta"             ,,{ ||mannfe(3)}   ,,,,,81)
AddDownItem( mEstNfe, "&ExclusÆo"             ,,{ ||mannfe(4)}   ,,,,,82)
   mEstNfeListagem := NewDownMenu()
   AddDownItem( mEstNfeListagem, "&Analitico" ,,{ ||mannfe(5,1)} ,,,,,83)
   AddDownItem( mEstNfeListagem, "&Sint‚tico" ,,{ ||mannfe(5,2)} ,,,,,84)
AddDownItem( mEstNfe, "&Listagem"             ,,mEstNfeListagem  ,,,,,85)
AddDownItem( mEstNfe, "&Implementacao"        ,,{ ||mannfe(6)}   ,,,,,86)
AddDownItem( mEstNfe, "&Ler XML"              ,,{ ||mannfe(7)}   ,,,,,87)

*mEstncm := NewDownMenu()
AddDownItem( mEstNcm, "&InclusÆo"             ,,{ ||manncm(1)},,,,,88)
AddDownItem( mEstNcm, "&Altera‡Æo"            ,,{ ||manncm(2)},,,,,89)
AddDownItem( mEstNcm, "&Consulta"             ,,{ ||manncm(3)},,,,,90)
AddDownItem( mEstNcm, "&ExclusÆo"             ,,{ ||manncm(4)},,,,,91)
AddDownItem( mEstNcm, "&Listagem"             ,,{ ||manncm(5)},,,,,92)


AddBarItem( mBar, "&Estoque"   ,, mEst,,,,,93 )
AddBarItem( mBar, "&Faturar"   ,, mFat,,,,,94 )
AddBarItem( mBar, "&Receber"   ,, mRec,,,,,95 )
AddBarItem( mBar, "&Pagar"     ,, mPag,,,,,96 )
AddBarItem( mBar, "&Bancos"    ,, mBan,,,,,97 )
AddBarItem( mBar, "&Caixa"     ,, mCai,,,,,98 )
AddBarItem( mBar, "&Outros"    ,, mOut,,,,,99 )


 //  SetDownItem( mEstemp, 2, .f. )  // desabilita uma opcao exemplo empresa altera

   mFatNotas := NewDownMenu()
   AddDownItem( mFatNotas, "&EmissÆo" ,,{ || mannfs(1) },,,,,100)

     mFatNotasAlt := NewDownMenu()
     AddDownItem( mFatNotasAlt, "&Nota Fiscal"     ,,{ || mannfs(2,1) } ,,,,,101)
     AddDownItem( mFatNotasAlt, "&Escrituracao"    ,,{ || mannfs(2,2) } ,,,,,102)
     AddDownItem( mFatNotasAlt, "&Natureza"        ,,{ || mannfs(2,3) } ,,,,,103)
     AddDownItem( mFatNotasAlt, "&Relatorio"       ,,{ || mannfs(2,4) } ,,,,,104)

   AddDownItem( mFatNotas, "&Altera‡Æo"                         ,,mFatNotasAlt   ,,,,,105 )
   AddDownItem( mFatNotas, "&Consulta"                          ,,{ || mannfs(3)},,,,,106 )
   AddDownItem( mFatNotas, "&ExclusÆo"                          ,,{ || mannfs(4)},,,,,107 )
      mFatNotasListagem := NewDownMenu()
      AddDownItem( mFatNotasListagem, "&Sintetica Notas Fiscais"  ,,{ || mannfs(5,1) }       ,,,,,108)
      AddDownItem( mFatNotasListagem, "&Cliente Analitico"        ,,{ || mannfs(5,2) }       ,,,,,109)
      AddDownItem( mFatNotasListagem, "&Cliente Sintetico"        ,,{ || mannfs(5,3) }       ,,,,,110)
      AddDownItem( mFatNotasListagem, "&Nota de Servico"          ,,{ || mannfs(5,4) }       ,,,,,111)
      AddDownItem( mFatNotasListagem, "&Vendedor Notas"           ,,{ || mannfs(5,5) }       ,,,,,112)
      AddDownItem( mFatNotasListagem, "&Vendedor Sintetico"       ,,{ || mannfs(5,6) }       ,,,,,113)
      AddDownItem( mFatNotasListagem, "&Municipio Sintetico"      ,,{ || mannfs(5,7) }       ,,,,,114)
      AddDownItem( mFatNotasListagem, "&Produto Sintetico"        ,,{ || mannfs(5,8) }       ,,,,,115)
      AddDownItem( mFatNotasListagem, "&Notas Emitidas no Periodo",,{ || mannfs(5,9) }       ,,,,,116)
      AddDownItem( mFatNotasListagem, "&Margem Bruta de Vendas"   ,,{ || mannfs(5,11) }      ,,,,,117)
      AddDownItem( mFatNotasListagem, "&Etiquetas de Caixa"       ,,{ || mannfs(5,11) }      ,,,,,118)
      AddDownItem( mFatNotasListagem, "&Faturamento"              ,,{ || mannfs(5,12) }      ,,,,,119)
      AddDownItem( mFatNotasListagem, "&Notas no Periodo (Antigo)",,{ || mannfs(5,14) }      ,,,,,120)
      AddDownItem( mFatNotasListagem, "&Produtos Isentos"         ,,{ || mannfs(5,15) }      ,,,,,121)
      AddDownItem( mFatNotasListagem, "&IMS"                      ,,{ || mannfs(5,16) }      ,,,,,122)
      AddDownItem( mFatNotasListagem, "&Prodiet"                  ,,{ || mannfs(5,17) }      ,,,,,122)
   AddDownItem( mFatNotas, "&Listagem"                          ,,mFatNotasListagem          ,,,,,123)

     mFatNotasOut := NewDownMenu()
     AddDownItem( mFatNotasOut, "&Carta de Correcao"  ,,{ || mannfs(6,1)} ,,,,,124)
     AddDownItem( mFatNotasOut, "&Cancelamento"       ,,{ || mannfs(6,2)} ,,,,,125)
     AddDownItem( mFatNotasOut, "&Reemissao"          ,,{ || mannfs(6,3)} ,,,,,126)
     AddDownItem( mFatNotasOut, "&Enviar Email"       ,,{ || mannfs(6,4)} ,,,,,127)

   AddDownItem( mFatNotas, "&Outros"                  ,,mFatNotasOut      ,,,,,128)

   AddDownItem( mFatNotas, "&Transporte"              ,,{ || mannfs(7)}   ,,,,,129)
   AddDownItem( mFatNotas, "&Inclusao"                ,,{ || mannfs(8) }  ,,,,,130)


     mFatNotasNestle := NewDownMenu()
     AddDownItem( mFatNotasNestle, "&Conferencia Excel"     ,,{ || nestlepre()} ,,,,,124)
     AddDownItem( mFatNotasNestle, "&Transmitir Movimento"  ,,{ || nestle()} ,,,,,125)
     AddDownItem( mFatNotasNestle, "&Transmitir Saldo"      ,,{ || nestleSaldo()} ,,,,,125)
     AddDownItem( mFatNotasNestle, "&CNPJ/Endere‡o Entrega" ,,{ || mannfs(2,5)} ,,,,,125)

   AddDownItem( mFatNotas, "&Nestle"                  ,,mFatNotasNestle      ,,,,,128)



AddDownItem( mFat, "&Nota Fiscal"                     ,,mFatNotas         ,,,,,131)


   mFatPedidos := NewDownMenu()
   AddDownItem( mFatPedidos, "&EmissÆo"   ,,{ || manped(1)},,,,,132)
   AddDownItem( mFatPedidos, "&Altera‡Æo" ,,{ || manped(2)},,,,,133)

        mFatPedidosCon := NewDownMenu()
     AddDownItem( mFatPedidosCon, "&Pedido"     ,,{ || manped(3,1)},,,,,134)
     AddDownItem( mFatPedidosCon, "&Cliente"    ,,{ || manped(3,2)},,,,,135)
*     AddDownItem( mFatPedidosCon, "&Fornecedor" ,,{ || manped(3,3)},,,,,136)

   AddDownItem( mFatPedidos, "&Consulta"       ,,mFatPedidosCon            ,,,,,137)
   AddDownItem( mFatPedidos, "&ExclusÆo"  ,,{ || manped(4)}                ,,,,,138)

      mFatPedidosListagem := NewDownMenu()
      AddDownItem( mFatPedidosListagem, "&Listagem de Pedidos"  ,,{ || manped(5,1)}             ,,,,,139)
      AddDownItem( mFatPedidosListagem, "&Relacao por Produto"  ,,{ || manped(5,2)}             ,,,,,140)
      AddDownItem( mFatPedidosListagem, "&Sintetica Pedidos"    ,,{ || manped(5,3)}             ,,,,,141)
      AddDownItem( mFatPedidosListagem, "&Relacao por Grupo"    ,,{ || manped(5,4)}             ,,,,,142)
      AddDownItem( mFatPedidosListagem, "&Relacao por Cliente"  ,,{ || manped(5,5)}             ,,,,,143)
      AddDownItem( mFatPedidosListagem, "&Analitico Vendedor"   ,,{ || manped(5,6)}             ,,,,,144)
   AddDownItem( mFatPedidos, "&Listagem",,mFatPedidosListagem       ,,,,,145)

      mFatPedidosOutros := NewDownMenu()
      AddDownItem( mFatPedidosOutros, "&Alteracao"      ,,{ || manped(6,1)}    ,,,,,146)
      AddDownItem( mFatPedidosOutros, "&Emissao Nota"   ,,{ || manped(6,2)}    ,,,,,147)
   AddDownItem( mFatPedidos, "&Agrupamento",,mFatPedidosOutros                 ,,,,,148)

AddDownItem( mFat, "&Orcamento",,mFatPedidos,,,,,149 )

   mFatRequisi := NewDownMenu()
   AddDownItem( mFatRequisi, "&EmissÆo"   ,,{ || manreq(1)},,,,,150)
   AddDownItem( mFatRequisi, "&ReemissÆo"   ,,{ || manreq(7)},,,,,150)
   AddDownItem( mFatRequisi, "&Altera‡Æo" ,,{ || manreq(2)},,,,,151)

        mFatRequisiCon := NewDownMenu()
     AddDownItem( mFatRequisiCon, "&Aluguel" ,,{ || manreq(3,1)},,,,,152)
     AddDownItem( mFatRequisiCon, "&Cliente"    ,,{ || manreq(3,2)},,,,,153)

   AddDownItem( mFatRequisi, "&Consulta"        ,,mFatRequisiCon           ,,,,,154 )
   AddDownItem( mFatRequisi, "&ExclusÆo"  ,,{ || manreq(4)}                ,,,,,155)

      mFatRequisiListagem := NewDownMenu()
      AddDownItem( mFatRequisiListagem, "&Listagem de Requisicoes",,{ || manreq(5,1)}      ,,,,,156)
      AddDownItem( mFatRequisiListagem, "&Relacao por Produto"    ,,{ || manreq(5,2)}      ,,,,,157)
      AddDownItem( mFatRequisiListagem, "&Analitica Requisicao"   ,,{ || manreq(5,3)}      ,,,,,158)
      AddDownItem( mFatRequisiListagem, "&Sintetica Requisicao"   ,,{ || manreq(5,4)}      ,,,,,159)
      AddDownItem( mFatRequisiListagem, "&Relacao por Cliente"    ,,{ || manreq(5,5)}      ,,,,,160)
      AddDownItem( mFatRequisiListagem, "&Analitico Vendedor"     ,,{ || manreq(5,6)}      ,,,,,161)
      AddDownItem( mFatRequisiListagem, "&Analitico Clilente"     ,,{ || manreq(5,7)}      ,,,,,162)
      AddDownItem( mFatRequisiListagem, "&Resumo de Vendas"       ,,{ || manreq(5,8)}      ,,,,,163)
      AddDownItem( mFatRequisiListagem, "&Mapa Resumido Indicado" ,,{ || manreq(5,9)}      ,,,,,164)
   AddDownItem( mFatRequisi, "&Listagem",,mFatRequisiListagem       ,,,,,165)

      mFatRequisiOutros := NewDownMenu()
      AddDownItem( mFatRequisiOutros, "&Renovacao"      ,,{ || manreq(6,1)}    ,,,,,166)
      AddDownItem( mFatRequisiOutros, "&Encerramento"   ,,{ || manreq(6,2)}    ,,,,,167)
      AddDownItem( mFatRequisiOutros, "&Listagem"       ,,{ || manreq(6,3)}    ,,,,,168)
   AddDownItem( mFatRequisi, "&Aluguel",,mFatRequisiOutros                     ,,,,,169)
AddDownItem( mFat, "&Aluguel",,mFatRequisi,,,,,170 )

// CUPOM SAT

   mFatSat := NewDownMenu()
   AddDownItem( mFatSat, "&EmissÆo"   ,,{ || mansat(1,1)},,,,,171)
   AddDownItem( mFatSat, "&InclusÆo"  ,,{ || mansat(1,2)},,,,,172)
   AddDownItem( mFatSat, "&Altera‡Æo" ,,{ || mansat(2)}  ,,,,,173)

        mFatSatCon := NewDownMenu()
     AddDownItem( mFatSatCon, "&Cupom Fiscal" ,,{ || mansat(3,1)},,,,,174)
     AddDownItem( mFatSatCon, "&Cliente"      ,,{ || mansat(3,2)},,,,,175)

   AddDownItem( mFatSat, "&Consulta"                        ,,mFatSatCon,,,,,176)
   AddDownItem( mFatSat, "&ReemissÆo"  ,,{ || mansat(4)}                ,,,,,177)

      mFatSatListagem := NewDownMenu()
      AddDownItem( mFatSatListagem, "&Faturamento do Dia" ,,{ || mansat(5,1)}     ,,,,,178)
      AddDownItem( mFatSatListagem, "&Mapa Resumo Fiscal" ,,{ || mansat(5,2)}     ,,,,,179)
      AddDownItem( mFatSatListagem, "&Produto Sintetica"  ,,{ || mansat(5,3)}     ,,,,,180)
   AddDownItem( mFatSat, "&Listagem",,mFatSatListagem                             ,,,,,181)
   AddDownItem( mFatSat, "&Cancelamento"  ,,{ || mansat(6)}                       ,,,,,182)

AddDownItem( mFat, "&Cupom Eletronico",,mFatSat,,,,,183 )

   mFatCli := NewDownMenu()
   AddDownItem( mFatCli, "&InclusÆo"  ,,{ || mancli(1) }  ,,,,,183)
   AddDownItem( mFatCli, "&Altera‡Æo" ,,{ || mancli(2) }  ,,,,,184)
   AddDownItem( mFatCli, "&Consulta"  ,,{ || mancli(3)}   ,,,,,185)
   AddDownItem( mFatCli, "&ExclusÆo"  ,,{ || mancli(4)}   ,,,,,186)

      mFatCliLista := NewDownMenu()
      AddDownItem( mFatCliLista, "&Completa Codigo"     ,,{ || mancli(5,1)} ,,,,,187 )
      AddDownItem( mFatCliLista, "&Completa CPF/CNPJ"   ,,{ || mancli(5,2)} ,,,,,188 )
      AddDownItem( mFatCliLista, "&Completa Alfabetica" ,,{ || mancli(5,3)} ,,,,,189 )
      AddDownItem( mFatCliLista, "&Catalogo Codigo"     ,,{ || mancli(5,4)} ,,,,,190 )
      AddDownItem( mFatCliLista, "&Catalogo CPF/CNPJ"   ,,{ || mancli(5,5)} ,,,,,191 )
      AddDownItem( mFatCliLista, "&Catalogo Alfabetica" ,,{ || mancli(5,6)} ,,,,,192 )
      AddDownItem( mFatCliLista, "&Catalogo Municipio"  ,,{ || mancli(5,7)} ,,,,,193 )
   AddDownItem( mFatCli, "&Listagem"        ,,mFatCliLista      ,,,,,194 )

      mFatCliEtiqueta := NewDownMenu()
      AddDownItem( mFatCliEtiqueta, "&Codigo"     ,,{ || mancli(6,1)} ,,,,,194 )
      AddDownItem( mFatCliEtiqueta, "&Sele‡Æo"    ,,{ || mancli(6,2)} ,,,,,195 )
      AddDownItem( mFatCliEtiqueta, "&Nome"       ,,{ || mancli(6,3)} ,,,,,196 )
      AddDownItem( mFatCliEtiqueta, "&Parametro"  ,,{ || mancli(6,4)} ,,,,,197 )

   AddDownItem( mFatCli, "&Etiqueta"              ,,mFatCliEtiqueta         ,,,,,198)
   AddDownItem( mFatCli, "&Arquivo Morto"         ,,{ || mancli(7)}         ,,,,,199)

      mFatCliTipo := NewDownMenu()
   AddDownItem( mFatCliTipo, "&InclusÆo"  ,,{ || mancli(8,1)} ,,,,,200)
   AddDownItem( mFatCliTipo, "&Altera‡Æo" ,,{ || mancli(8,2)} ,,,,,201)
   AddDownItem( mFatCliTipo, "&Consulta"  ,,{ || mancli(8,3)} ,,,,,202)
   AddDownItem( mFatCliTipo, "&ExclusÆo"  ,,{ || mancli(8,4)} ,,,,,203)
   AddDownItem( mFatCliTipo, "&Listagem"  ,,{ || mancli(8,5)} ,,,,,204)
   AddDownItem( mFatCli, "&Tipo Cliente"  ,,mFatCliTipo       ,,,,,205)


AddDownItem( mFat, "&Clientes",,mFatCli,,,,,206 )

AddDownSep ( mFat )     // Linha de separa‡Æo

   mFatVen := NewDownMenu()
   AddDownItem( mFatVen, "&InclusÆo"    ,,{ || manven(1)},,,,,207)
   AddDownItem( mFatVen, "&Altera‡Æo"   ,,{ || manven(2)},,,,,208)
   AddDownItem( mFatVen, "&Consulta"    ,,{ || manven(3)},,,,,209)
   AddDownItem( mFatVen, "&ExclusÆo"    ,,{ || manven(4)},,,,,210)
   AddDownItem( mFatVen, "&Listagem"    ,,{ || manven(5)},,,,,211)

      mFatVenComissao := NewDownMenu()
      AddDownItem( mFatVenComissao, "&Pagameto"      ,,{ || manven(6,1)},,,,,212)
      AddDownItem( mFatVenComissao, "&Vencimento"    ,,{ || manven(6,2)},,,,,213)
      AddDownItem( mFatVenComissao, "&Emissao"       ,,{ || manven(6,3)},,,,,214)
      AddDownItem( mFatVenComissao, "&Aberto"        ,,{ || manven(6,4)},,,,,215)
   AddDownItem( mFatVen, "&ComissÆo"    ,,mFatVenComissao,,,,,216)

AddDownItem( mFat, "&Vendedores",,mFatVen ,,,,,217)

   mFatTra := NewDownMenu()
   AddDownItem( mFatTra, "&InclusÆo"        ,,{ || mantra(1)},,,,,218)
   AddDownItem( mFatTra, "&Altera‡Æo"       ,,{ || mantra(2)},,,,,219)
   AddDownItem( mFatTra, "&Consulta"        ,,{ || mantra(3)},,,,,220)
   AddDownItem( mFatTra, "&ExclusÆo"        ,,{ || mantra(4)},,,,,221)
   AddDownItem( mFatTra, "&Listagem"        ,,{ || mantra(5)},,,,,222)
AddDownItem( mFat, "&Transportadora",,mFatTra ,,,,,223)
AddDownSep ( mFat )     // Linha de separa‡Æo

   mFatCpg := NewDownMenu()
   AddDownItem( mFatCpg, "&InclusÆo"      ,,{ || mancpg(1)},,,,,224)
   AddDownItem( mFatCpg, "&Altera‡Æo"     ,,{ || mancpg(2)},,,,,225)
   AddDownItem( mFatCpg, "&Consulta"      ,,{ || mancpg(3)},,,,,226)
   AddDownItem( mFatCpg, "&ExclusÆo"      ,,{ || mancpg(4)},,,,,227)
   AddDownItem( mFatCpg, "&Listagem"      ,,{ || mancpg(5)},,,,,228)
AddDownItem( mFat, "&Pagamentos",,mFatCpg   ,,,,,229)


   mFatInd := NewDownMenu()
   AddDownItem( mFatInd, "&InclusÆo"      ,,{ || manind(1)},,,,,230)
   AddDownItem( mFatInd, "&Altera‡Æo"     ,,{ || manind(2)},,,,,231)
   AddDownItem( mFatInd, "&Consulta"      ,,{ || manind(3)},,,,,232)
   AddDownItem( mFatInd, "&ExclusÆo"      ,,{ || manind(4)},,,,,233)
   AddDownItem( mFatInd, "&Listagem"      ,,{ || manind(5)},,,,,234)
AddDownItem( mFat, "&Indicado",,mFatInd   ,,,,,235)

AddDownItem( mFat, "&Mensagem NF",,{ || manmsg()},,,,,234)


  mFinReceberDup := NewDownMenu()

  AddDownItem( mFinReceberDup, "&InclusÆo",,{ || mandcr(1)}  ,,,,,236  )

    mFinReceberDupAlt := NewDownMenu()
    AddDownItem( mFinReceberDupAlt, "&Titulo"   ,,{ || mandcr(2,1)} ,,,,,237)
*    AddDownItem( mFinReceberDupAlt, "&Comissao" ,,{ || mandcr(2,2)} ,,,,,238)
    AddDownItem( mFinReceberDupAlt, "&Pagamento",,{ || mandcr(2,3)} ,,,,,239)
    AddDownItem( mFinReceberDupAlt, "&Exportar" ,,{ || mandcr(2,4)} ,,,,,240)
  AddDownItem( mFinReceberDup, "&Alteracao"     ,,mFinReceberDupAlt ,,,,,241)

    mFinReceberDupCon := NewDownMenu()
    AddDownItem( mFinReceberDupCon, "&Sequencia",,{ || mandcr(3,1)} ,,,,,242)
    AddDownItem( mFinReceberDupCon, "&Vencidas" ,,{ || mandcr(3,2)} ,,,,,243)
    AddDownItem( mFinReceberDupCon, "&Emissao"  ,,{ || mandcr(3,3)} ,,,,,244)
    AddDownItem( mFinReceberDupCon, "&Codigos"  ,,{ || mandcr(3,4)} ,,,,,245)
    AddDownItem( mFinReceberDupCon, "&Portador" ,,{ || mandcr(3,5)} ,,,,,246)
    AddDownItem( mFinReceberDupCon, "&Pagamento",,{ || mandcr(3,6)} ,,,,,247)
  AddDownItem( mFinReceberDup, "&Consulta"      ,,mFinReceberDupCon ,,,,,248)

  AddDownItem( mFinReceberDup, "&ExclusÆo",,{ || mandcr(4)}  ,,,,,249  )

    mFinReceberDupLis := NewDownMenu()
    AddDownItem( mFinReceberDupLis, "&Perda"    ,,{ || mandcr(5,1)} ,,,,,250)
    AddDownItem( mFinReceberDupLis, "&Vencidas" ,,{ || mandcr(5,2)} ,,,,,251)
    AddDownItem( mFinReceberDupLis, "&Nome"     ,,{ || mandcr(5,3)} ,,,,,252)
    AddDownItem( mFinReceberDupLis, "&Codigo"   ,,{ || mandcr(5,4)} ,,,,,253)
    AddDownItem( mFinReceberDupLis, "&Portador" ,,{ || mandcr(5,5)} ,,,,,254)
    AddDownItem( mFinReceberDupLis, "&Pagamento",,{ || mandcr(5,6)} ,,,,,255)
    AddDownItem( mFinReceberDupLis, "&Sequencia",,{ || mandcr(5,7)} ,,,,,256)
    AddDownItem( mFinReceberDupLis, "&EmissÆo"  ,,{ || mandcr(5,8)} ,,,,,257)
    AddDownItem( mFinReceberDupLis, "&Cidade"   ,,{ || mandcr(5,9)} ,,,,,258)
  AddDownItem( mFinReceberDup, "&Listagem"      ,,mFinReceberDupLis ,,,,,259)

    mFinReceberDupTit := NewDownMenu()
    AddDownItem( mFinReceberDupTit, "&Duplicata"  ,,{ || mandcr(6,1)} ,,,,,260)
    AddDownItem( mFinReceberDupTit, "&Banespa"    ,,{ || mandcr(6,2)} ,,,,,261)
    AddDownItem( mFinReceberDupTit, "&Banestado"  ,,{ || mandcr(6,3)} ,,,,,262)
    AddDownItem( mFinReceberDupTit, "&Itau"       ,,{ || mandcr(6,4)} ,,,,,263)
    AddDownItem( mFinReceberDupTit, "&Brasil"     ,,{ || mandcr(6,5)} ,,,,,264)
    AddDownItem( mFinReceberDupTit, "&Bamerindus" ,,{ || mandcr(6,6)} ,,,,,265)
    AddDownItem( mFinReceberDupTit, "&Santander"  ,,{ || mandcr(6,7)} ,,,,,266)
  AddDownItem( mFinReceberDup, "&Titulos"         ,,mFinReceberDupTit ,,,,,267)
  AddDownItem( mRec, "&Duplicata"          ,,mFinReceberDup           ,,,,,268)


  mFinReceberIns := NewDownMenu()
  AddDownItem( mFinReceberIns, "&InclusÆo"        ,,{ || manlcr(1)}       ,,,,,269)
  AddDownItem( mFinReceberIns, "&Altera‡Æo"       ,,{ || manlcr(2)}       ,,,,,270)

    mFinReceberInsCon := NewDownMenu()
    AddDownItem( mFinReceberInsCon, "&Instru‡Æo"  ,,{ || manlcr(3,1)}     ,,,,,271)
    AddDownItem( mFinReceberInsCon, "&Duplicata"  ,,{ || manlcr(3,2)}     ,,,,,272)
    AddDownItem( mFinReceberInsCon, "&Cliente"    ,,{ || manlcr(3,3)}     ,,,,,273)
  AddDownItem( mFinReceberIns, "&Consulta"        ,,mFinReceberInsCon     ,,,,,274)

  AddDownItem( mFinReceberIns, "&ExclusÆo"        ,,{ || manlcr(4)}       ,,,,,275)

    mFinReceberInsLis := NewDownMenu()
    AddDownItem( mFinReceberInsLis, "&Instru‡Æo"  ,,{ || manlcr(5,1)}     ,,,,,276)
    AddDownItem( mFinReceberInsLis, "&Diario"     ,,{ || manlcr(5,2)}     ,,,,,277)
    AddDownItem( mFinReceberInsLis, "&RazÆo"      ,,{ || manlcr(5,3)}     ,,,,,278)
  AddDownItem( mFinReceberIns, "&Listagem"        ,,mFinReceberInsLis     ,,,,,279)
  AddDownItem( mFinReceberIns, "&Fechamento"      ,,{ || manlcr(6)}       ,,,,,280)

  AddDownItem( mRec, "&Instru‡Æo"          ,,mFinReceberIns        ,,,,,281)



  mFinBaixa := NewDownMenu()
  AddDownItem( mFinBaixa, "&Documento"     ,,{ || manbcr(1)}        ,,,,,282)
  AddDownItem( mFinBaixa, "&Clientes"      ,,{ || manbcr(2)}        ,,,,,283)
  AddDownItem( mFinBaixa, "&RecepcÆo"      ,,{ || manbcr(3)}        ,,,,,284)
  AddDownItem( mFinBaixa, "&Consiste"      ,,{ || manbcr(4)}        ,,,,,285)
  AddDownItem( mFinBaixa, "&Listagem"      ,,{ || manbcr(5)}        ,,,,,286)
  AddDownItem( mRec, "&Baixas"          ,,mFinBaixa        ,,,,,287)


  mFinOpera := NewDownMenu()
  AddDownItem( mFinOpera, "&Inclusao"      ,,{ || manmcr(1)}        ,,,,,288)
  AddDownItem( mFinOpera, "&Alteracao"     ,,{ || manmcr(2)}        ,,,,,289)
  AddDownItem( mFinOpera, "&Consulta"      ,,{ || manmcr(3)}        ,,,,,290)
  AddDownItem( mFinOpera, "&Exclusao"      ,,{ || manmcr(4)}        ,,,,,291)
  AddDownItem( mFinOpera, "&Listagem"      ,,{ || manmcr(5)}        ,,,,,292)
  AddDownItem( mRec, "&Operacoes"       ,,mFinOpera        ,,,,,293)

  mFinBcoPor := NewDownMenu()
  AddDownItem( mFinBcoPor, "&InclusÆo"      ,,{ || manpor(1)},,,,,294)
  AddDownItem( mFinBcoPor, "&Altera‡Æo"     ,,{ || manpor(2)},,,,,295)
  AddDownItem( mFinBcoPor, "&Consulta"      ,,{ || manpor(3)},,,,,296)
  AddDownItem( mFinBcoPor, "&ExclusÆo"      ,,{ || manpor(4)},,,,,297)
  AddDownItem( mFinBcoPor, "&Listagem"      ,,{ || manpor(5)},,,,,298)
AddDownItem( mRec, "&Portadores",, mFinBcoPor ,,,,,299)

  mFinExport := NewDownMenu()
  AddDownItem( mFinExport, "&Remessa"       ,,{ || manexp(1)},,,,,300)
  AddDownItem( mFinExport, "&Lista Retorno" ,,{ || manexp(2)},,,,,301)
  AddDownItem( mFinExport, "&Baixa Retorno" ,,{ || manexp(3)},,,,,302)
AddDownItem( mRec, "&Exportar",, mFinExport ,,,,,303)


  mFinEtique := NewDownMenu()
  AddDownItem( mFinEtique, "&InclusÆo"      ,,{ || manetq(1)},,,,,304)
  AddDownItem( mFinEtique, "&Altera‡Æo"     ,,{ || manetq(2)},,,,,305)
  AddDownItem( mFinEtique, "&Consulta"      ,,{ || manetq(3)},,,,,306)
  AddDownItem( mFinEtique, "&ExclusÆo"      ,,{ || manetq(4)},,,,,307)
  AddDownItem( mFinEtique, "&Listagem"      ,,{ || manetq(5)},,,,,308)
  AddDownItem( mFinEtique, "&Parametro"     ,,{ || manetq(6)},,,,,309)
AddDownItem( mRec, "&Etiquetas",, mFinEtique ,,,,,310)


  mFinPagarDup := NewDownMenu()

  AddDownItem( mFinPagarDup, "&InclusÆo",,{ || mandcp(1)}  ,,,,,311  )

    mFinPagarDupAlt := NewDownMenu()
    AddDownItem( mFinPagarDupAlt, "&Titulo"   ,,{ || mandcp(2,1)} ,,,,,312)
    AddDownItem( mFinPagarDupAlt, "&Portador" ,,{ || mandcp(2,3)} ,,,,,313)
  AddDownItem( mFinPagarDup, "&Alteracao"      ,,mFinPagarDupAlt  ,,,,,314)

    mFinPagarDupCon := NewDownMenu()
    AddDownItem( mFinPagarDupCon, "&Sequencia",,{ || mandcp(3,1)} ,,,,,315)
    AddDownItem( mFinPagarDupCon, "&Vencidas" ,,{ || mandcp(3,2)} ,,,,,316)
    AddDownItem( mFinPagarDupCon, "&Emissao"  ,,{ || mandcp(3,3)} ,,,,,317)
    AddDownItem( mFinPagarDupCon, "&Codigos"  ,,{ || mandcp(3,4)} ,,,,,318)
    AddDownItem( mFinPagarDupCon, "&Portador" ,,{ || mandcp(3,5)} ,,,,,319)
    AddDownItem( mFinPagarDupCon, "&Pagamento",,{ || mandcp(3,6)} ,,,,,320)
  AddDownItem( mFinPagarDup, "&Consulta"      ,,mFinPagarDupCon   ,,,,,321)

  AddDownItem( mFinPagarDup, "&ExclusÆo",,{ || mandcp(4)}  ,,,,,322  )

    mFinPagarDupLis := NewDownMenu()
    AddDownItem( mFinPagarDupLis, "&Sequencia",,{ || mandcp(5,1)} ,,,,,323)
    AddDownItem( mFinPagarDupLis, "&Vencidas" ,,{ || mandcp(5,2)} ,,,,,324)
    AddDownItem( mFinPagarDupLis, "&Nome"     ,,{ || mandcp(5,3)} ,,,,,325)
    AddDownItem( mFinPagarDupLis, "&Codigo"   ,,{ || mandcp(5,4)} ,,,,,326)
    AddDownItem( mFinPagarDupLis, "&Portador" ,,{ || mandcp(5,5)} ,,,,,327)
    AddDownItem( mFinPagarDupLis, "&Pagamento",,{ || mandcp(5,6)} ,,,,,328)
  AddDownItem( mFinPagarDup, "&Listagem"      ,,mFinPagarDupLis   ,,,,,329)

  AddDownItem( mPag, "&Duplicata"          ,,mFinPagarDup         ,,,,,330)


  mFinPagarIns := NewDownMenu()
  AddDownItem( mFinPagarIns, "&InclusÆo"        ,,{ || manlcp(1)}        ,,,,,331)
  AddDownItem( mFinPagarIns, "&Altera‡Æo"       ,,{ || manlcp(2)}        ,,,,,332)

    mFinPagarInsCon := NewDownMenu()
    AddDownItem( mFinPagarInsCon, "&Instru‡Æo"  ,,{ || manlcp(3,1)}      ,,,,,333)
    AddDownItem( mFinPagarInsCon, "&Duplicata"  ,,{ || manlcp(3,2)}      ,,,,,334)
    AddDownItem( mFinPagarInsCon, "&Fornecedor" ,,{ || manlcp(3,3)}      ,,,,,335)
  AddDownItem( mFinPagarIns, "&Consulta"        ,,mFinPagarInsCon        ,,,,,336)

  AddDownItem( mFinPagarIns, "&ExclusÆo"        ,,{ || manlcp(4)}        ,,,,,337)

    mFinPagarInsLis := NewDownMenu()
    AddDownItem( mFinPagarInsLis, "&Instru‡Æo"  ,,{ || manlcp(5,1)}      ,,,,,338)
    AddDownItem( mFinPagarInsLis, "&Diario"     ,,{ || manlcp(5,2)}      ,,,,,339)
    AddDownItem( mFinPagarInsLis, "&RazÆo"      ,,{ || manlcp(5,3)}      ,,,,,340)
  AddDownItem( mFinPagarIns, "&Listagem"        ,,mFinPagarInsLis        ,,,,,341)
  AddDownItem( mFinPagarIns, "&Fechamento"      ,,{ || manlcp(6)}        ,,,,,342)

  AddDownItem( mPag, "&Instru‡Æo"          ,,mFinPagarIns        ,,,,,343)


  mFinBaixap := NewDownMenu()
  AddDownItem( mFinBaixap, "&Documento"     ,,{ || manbcp(1)}        ,,,,,344)
  AddDownItem( mFinBaixap, "&Fornecedor"    ,,{ || manbcp(2)}        ,,,,,345)
  AddDownItem( mFinBaixap, "&Listagem"      ,,{ || manbcp(3)}        ,,,,,346)
  AddDownItem( mPag, "&Baixas"          ,,mFinBaixap        ,,,,,347)


  mFinOperap := NewDownMenu()
  AddDownItem( mFinOperap, "&Inclusao"      ,,{ || manmcp(1)}        ,,,,,348)
  AddDownItem( mFinOperap, "&Alteracao"     ,,{ || manmcp(2)}        ,,,,,349)
  AddDownItem( mFinOperap, "&Consulta"      ,,{ || manmcp(3)}        ,,,,,350)
  AddDownItem( mFinOperap, "&Exclusao"      ,,{ || manmcp(4)}        ,,,,,351)
  AddDownItem( mFinOperap, "&Listagem"      ,,{ || manmcp(5)}        ,,,,,352)
  AddDownItem( mPag, "&Operacoes"       ,,mFinOperap        ,,,,,353)


  mFinBcoCta := NewDownMenu()
  AddDownItem( mFinBcoCta, "&InclusÆo"      ,,{ || manban(1)},,,,,354)
  AddDownItem( mFinBcoCta, "&Altera‡Æo"     ,,{ || manban(2)},,,,,355)
  AddDownItem( mFinBcoCta, "&Consulta"      ,,{ || manban(3)},,,,,356)
  AddDownItem( mFinBcoCta, "&ExclusÆo"      ,,{ || manban(4)},,,,,357)
  AddDownItem( mFinBcoCta, "&Listagem"      ,,{ || manban(5)},,,,,358)
  AddDownItem( mFinBcoCta, "&Exercicio"     ,,{ || manban(6)},,,,,359)
  AddDownItem( mBan, "&Conta",,mFinBcoCta    ,,,,,360)

     mFinFluxoHis := NewDownMenu()
     AddDownItem( mFinFluxoHis, "&InclusÆo"       ,,{ || manhib(1)},,,,,361)
     AddDownItem( mFinFluxoHis, "&Altera‡Æo"      ,,{ || manhib(2)},,,,,362)
     AddDownItem( mFinFluxoHis, "&Consulta"       ,,{ || manhib(3)},,,,,363)
     AddDownItem( mFinFluxoHis, "&ExclusÆo"       ,,{ || manhib(4)},,,,,364)
     AddDownItem( mFinFluxoHis, "&Listagem"       ,,{ || manhib(5)},,,,,365)
  AddDownItem( mBan, "&Historico",,mFinFluxoHis,,,,,366)

    mFinBcoMov := NewDownMenu()
    AddDownItem( mFinBcoMov, "&InclusÆo"      ,,{ || manlab(1)},,,,,367)
    AddDownItem( mFinBcoMov, "&Altera‡Æo"     ,,{ || manlab(2)},,,,,368)
    AddDownItem( mFinBcoMov, "&Consulta"      ,,{ || manlab(3)},,,,,369)
    AddDownItem( mFinBcoMov, "&ExclusÆo"      ,,{ || manlab(4)},,,,,370)

    mFinBanMovLis := NewDownMenu()
    AddDownItem( mFinBanMovLis, "&Analitico"  ,,{ || manlab(5,1)}      ,,,,,371)
    AddDownItem( mFinBanMovLis, "&Sintetico"  ,,{ || manlab(5,2)}      ,,,,,372)
    AddDownItem( mFinBanMovLis, "&Conciliar"  ,,{ || manlab(5,3)}      ,,,,,373)
    AddDownItem( mFinBanMovLis, "&Extrato"    ,,{ || manlab(5,4)}      ,,,,,374)
  AddDownItem( mFinBcoMov, "&Listagem"        ,,mFinPagarInsLis     ,,,,,375)
    AddDownItem( mFinBcoMov, "&Conciliar"     ,,{ || manlab(6)},,,,,376)

  AddDownItem( mBan, "&Movimento",,mFinBcoMov,,,,,377)


  mFinBcoCheDup := NewDownMenu()
  AddDownItem( mFinBcoCheDup, "&InclusÆo"   ,,{ || manche(1)},,,,,378)
  AddDownItem( mFinBcoCheDup, "&Alteracao"  ,,{ || manche(2)},,,,,379)

    mFinBcoCheCon := NewDownMenu()
    AddDownItem( mFinBcoCheCon, "&Cheque"     ,,{ || manche(3,1)}    ,,,,,380)
    AddDownItem( mFinBcoCheCon, "&Fornecedor" ,,{ || manche(3,2)}    ,,,,,381)
  AddDownItem( mFinBcoCheDup, "&Consulta"        ,,mFinBcoCheCon     ,,,,,382)
  AddDownItem( mFinBcoCheDup, "&Exclusao"   ,,{ || manche(4)},,,,,383)
  AddDownItem( mFinBcoCheDup, "&Listagem"   ,,{ || manche(5)},,,,,384)

    mFinBcoCheOut := NewDownMenu()
    AddDownItem( mFinBcoCheOut, "&Emissao",,{ || manche(6,1)}      ,,,,,385)
    AddDownItem( mFinBcoCheOut, "&Copia"  ,,{ || manche(6,2)}      ,,,,,386)
    AddDownItem( mFinBcoCheOut, "&Elimina",,{ || manche(6,3)}      ,,,,,387)
  AddDownItem( mFinBcoCheDup, "&Outros"        ,,mFinBcoCheOut     ,,,,,388)

  AddDownItem( mFinBcoCheDup, "&Liberacao",,{ || manche(7)},,,,,389)
AddDownItem( mBan, "&Cheque",,mFinBcoCheDup,,,,,390)


  mFinBcoChePre := NewDownMenu()
  AddDownItem( mFinBcoChePre, "&InclusÆo"   ,,{ || manprd(1)},,,,,391)
  AddDownItem( mFinBcoChePre, "&Alteracao"  ,,{ || manprd(2)},,,,,392)

    mFinBcoChePreCon := NewDownMenu()
    AddDownItem( mFinBcoChePreCon, "&Cheque"     ,,{ || manprd(3,1)}      ,,,,,393)
    AddDownItem( mFinBcoChePreCon, "&Banco"      ,,{ || manprd(3,2)}      ,,,,,394)
    AddDownItem( mFinBcoChePreCon, "&Emissao"    ,,{ || manprd(3,3)}      ,,,,,395)
    AddDownItem( mFinBcoChePreCon, "&Vencimento" ,,{ || manprd(3,4)}      ,,,,,396)
    AddDownItem( mFinBcoChePreCon, "&Cliente"    ,,{ || manprd(3,5)}      ,,,,,397)
    AddDownItem( mFinBcoChePreCon, "&Valor"      ,,{ || manprd(3,6)}      ,,,,,398)
    AddDownItem( mFinBcoChePreCon, "&Entrada"    ,,{ || manprd(3,7)}      ,,,,,399)
  AddDownItem( mFinBcoChePre, "&Consulta"        ,,mFinBcoChePreCon     ,,,,,400)

  AddDownItem( mFinBcoChePre, "&Exclusao"   ,,{ || manprd(4)},,,,,401)

    mFinBcoCheLis := NewDownMenu()
    AddDownItem( mFinBcoCheLis, "&Cheque"     ,,{ || manprd(5,1)}      ,,,,,402)
    AddDownItem( mFinBcoCheLis, "&Banco"      ,,{ || manprd(5,2)}      ,,,,,403)
    AddDownItem( mFinBcoCheLis, "&Emissao"    ,,{ || manprd(5,3)}      ,,,,,404)
    AddDownItem( mFinBcoCheLis, "&Vencimento" ,,{ || manprd(5,4)}      ,,,,,405)
    AddDownItem( mFinBcoCheLis, "&Cliente"    ,,{ || manprd(5,5)}      ,,,,,406)
    AddDownItem( mFinBcoCheLis, "&Entrada"    ,,{ || manprd(5,6)}      ,,,,,407)
  AddDownItem( mFinBcoChePre, "&Listagem"        ,,mFinBcoCheLis     ,,,,,408)
  AddDownItem( mFinBcoChePre, "&Baixa",,{ || manprd(6)},,,,,409)
AddDownItem( mBan, "&Cheque Pre",,mFinBcoChePre,,,,,410)

    mFinBcoPar := NewDownMenu()
    AddDownItem( mFinBcoPar, "&InclusÆo"      ,,{ || manpch(1)},,,,,411)
    AddDownItem( mFinBcoPar, "&Altera‡Æo"     ,,{ || manpch(2)},,,,,412)
    AddDownItem( mFinBcoPar, "&Consulta"      ,,{ || manpch(3)},,,,,413)
    AddDownItem( mFinBcoPar, "&ExclusÆo"      ,,{ || manpch(4)},,,,,414)
    AddDownItem( mFinBcoPar, "&Listagem"      ,,{ || manpch(5)},,,,,415)
    AddDownItem( mFinBcoPar, "&Lay-Out"       ,,{ || manpch(6)},,,,,416)
  AddDownItem( mBan, "&Parametro"        ,,mFinBcoPar,,,,,417)

    mFinFluxoApl := NewDownMenu()
     AddDownItem( mFinFluxoApl, "&InclusÆo"       ,,{ || manplx(1)},,,,,418)
     AddDownItem( mFinFluxoApl, "&Altera‡Æo"      ,,{ || manplx(2)},,,,,419)
     AddDownItem( mFinFluxoApl, "&Consulta"       ,,{ || manplx(3)},,,,,420)
     AddDownItem( mFinFluxoApl, "&ExclusÆo"       ,,{ || manplx(4)},,,,,421)
     AddDownItem( mFinFluxoApl, "&Listagem"       ,,{ || manplx(5)},,,,,422)
    AddDownItem( mCai, "&Aplica‡Æo",,mFinFluxoApl,,,,,423)

    mFinBcoHis := NewDownMenu()
    AddDownItem( mFinBcoHis, "&InclusÆo"      ,,{ || manhix(1)},,,,,424)
    AddDownItem( mFinBcoHis, "&Altera‡Æo"     ,,{ || manhix(2)},,,,,425)
    AddDownItem( mFinBcoHis, "&Consulta"      ,,{ || manhix(3)},,,,,426)
    AddDownItem( mFinBcoHis, "&ExclusÆo"      ,,{ || manhix(4)},,,,,427)
    AddDownItem( mFinBcoHis, "&Listagem"      ,,{ || manhix(5)},,,,,428)
  AddDownItem( mCai, "&Historico",,mFinBcoHis,,,,,429)


     mFinFluxoMov := NewDownMenu()
     AddDownItem( mFinFluxoMov, "&InclusÆo"       ,,{ || manlax(1)},,,,,430)
     AddDownItem( mFinFluxoMov, "&Altera‡Æo"      ,,{ || manlax(2)},,,,,431)
     AddDownItem( mFinFluxoMov, "&Consulta"       ,,{ || manlax(3)},,,,,432)
     AddDownItem( mFinFluxoMov, "&ExclusÆo"       ,,{ || manlax(4)},,,,,433)

     mFinFluxoLis := NewDownMenu()
     AddDownItem( mFinFluxoLis, "&Periodo"  ,,{ || manlax(5,1)},,,,,434)
     AddDownItem( mFinFluxoLis, "&Contas"   ,,{ || manlax(5,2)},,,,,435)
     AddDownItem( mFinFluxoMov, "&Listagem" ,,mFinFluxoLis,,,,,436)
  AddDownItem( mCai, "&Fluxo de Caixa",,mFinFluxoMov   ,,,,,437)


     mCaiAnalitic := NewDownMenu()
     AddDownItem( mCaiAnalitic, "&Titulos"  ,,{ || mananx(1)},,,,,438)
     AddDownItem( mCaiAnalitic, "&Aplicacao",,{ || mananx(2)},,,,,439)
     AddDownItem( mCaiAnalitic, "&Caixa"    ,,{ || mananx(3)},,,,,440)
  AddDownItem( mCai, "&Analitico",,mCaiAnalitic   ,,,,,441)

     mCaiSintetic := NewDownMenu()
     AddDownItem( mCaiSintetic, "&Titulos"  ,,{ || mansix(1)},,,,,442)
     AddDownItem( mCaiSintetic, "&Aplicacao",,{ || mansix(2)},,,,,443)
  AddDownItem( mCai, "&Sintetico",,mCaiSintetic   ,,,,,444)

  AddDownItem( mCai, "&Resultado",,{ || demonx()},,,,,445)

   mFatCve := NewDownMenu()
   AddDownItem( mFatCve, "&InclusÆo"      ,,{ || mancve(1)},,,,,446)
   AddDownItem( mFatCve, "&Altera‡Æo"     ,,{ || mancve(2)},,,,,447)
   AddDownItem( mFatCve, "&Consulta"      ,,{ || mancve(3)},,,,,448)
   AddDownItem( mFatCve, "&ExclusÆo"      ,,{ || mancve(4)},,,,,449)
   AddDownItem( mFatCve, "&Listagem"      ,,{ || mancve(5)},,,,,450)
AddDownItem( mOut, "&Convenios",, mFatCve   ,,,,,451)

  mFisCfop := NewDownMenu()
  AddDownItem( mFisCfop, "&InclusÆo"      ,,{ || manfis(1)},,,,,452)
  AddDownItem( mFisCfop, "&Altera‡Æo"     ,,{ || manfis(2)},,,,,453)
  AddDownItem( mFisCfop, "&Consulta"      ,,{ || manfis(3)},,,,,454)
  AddDownItem( mFisCfop, "&ExclusÆo"      ,,{ || manfis(4)},,,,,455)
  AddDownItem( mFisCfop, "&Listagem"      ,,{ || manfis(5)},,,,,456)
AddDownItem( mOut, "&CFOP Fiscal",,mFisCfop ,,,,,457)


  mFisCfop := NewDownMenu()
  AddDownItem( mFisCfop, "&Resumo ICMS"     ,,{ || manapu(1)},,,,,458)
  AddDownItem( mFisCfop, "&Livro ICMS"      ,,{ || manapu(2)},,,,,459)
  AddDownItem( mFisCfop, "&Apuracao ICMS"   ,,{ || manapu(3)},,,,,460)
  AddDownItem( mFisCfop, "&Pis/Cofins"      ,,{ || manapu(4)},,,,,461)
  AddDownItem( mFisCfop, "&Sped ICMS"       ,,{ || manapu(5)},,,,,462)
AddDownItem( mOut, "&Fiscal",,mFisCfop ,,,,,463)

  mOutUsu  := NewDownMenu()
  AddDownItem( mOutUsu, "&InclusÆo"   ,,{ || manlog(1)},,,,,464)
  AddDownItem( mOutUsu, "&Altera‡Æo"  ,,{ || manlog(2)},,,,,465)
  AddDownItem( mOutUsu, "&Consulta"   ,,{ || manlog(3)},,,,,466)
  AddDownItem( mOutUsu, "&ExclusÆo"   ,,{ || manlog(4)},,,,,467)
  AddDownItem( mOutUsu, "&Restricoes" ,,{ || manlog(5)},,,,,468)

*AddDownItem( mOutUsu, "LinButton&1()", , { || LinButton1( ,,,,), Clrted( 20 ) } )
*AddDownItem( mOutUsu, "LinButton&2()", , { || LinButton2( ,,,,,,,,), Clrted( 20 ) } )
*AddDownItem( mOutUsu, "LinButton&3()", , { || LinButton3( ,,,,,,,,,,), Clrted( 20 ) } )
*AddDownItem( mOutUsu, "LinButton&4()", , { || LinButton4( ,,,,,,,,,,,,), Clrted( 20 ) } )
*AddDownItem( mOutUsu, "Check &1", "Marca/Desmarca Check 1", { || ChkDownItem( mOutUsu, 3, !ChkDownItem( mOutUsu, 3 ) ) } )
*AddDownItem( mOutUsu, "&TBrowse"   , "TBrowse com uso de Mouse na Visual Lib", { || VLTBrow() } )

*AddDownItem( mOutUsu, "Estilo &1", "T¡tulo … esquerda / Baixo relevo" , { || aEnv := SavEnv( 02, 00, 23, 79 ), Clrted(), Frame( 05, 05, 16, 74, "T¡tulo" ), WaitState(), RstEnv( aEnv ) } )
*AddDownItem( mOutUsu, "Estilo &2", "T¡tulo centralizado / Alto relevo", { || aEnv := SavEnv( 02, 00, 23, 79 ), Clrted(), Frame( 05, 05, 16, 74, "T¡tulo", 2, 2 ), WaitState(), RstEnv( aEnv ) } )
*AddDownItem( mOutUsu, "Estilo &3", "T¡tulo … direita / Normal"        , { || aEnv := SavEnv( 02, 00, 23, 79 ), Clrted(), Frame( 05, 05, 16, 74, "T¡tulo", 3, 3 ), WaitState(), RstEnv( aEnv ) } )
*AddDownItem( mOutUsu, "Estilo &1", "DeskBox() em baixo relevo" , { || aEnv := SavEnv( 02, 00, 23, 79 ), Clrted(), DeskBox( 05, 05, 16, 74, 1 ), WaitState(), RstEnv( aEnv ) } )
*AddDownItem( mOutUsu, "Estilo &2", "DeskBox() em alto relevo"  , { || aEnv := SavEnv( 02, 00, 23, 79 ), Clrted(), DeskBox( 05, 05, 16, 74, 2 ), WaitState(), RstEnv( aEnv ) } )

*AddDownItem( mOutUsu, "Estilo &1", "T¡tulo … esquerda / Baixo relevo" , { || aEnv := SavEnv( 02, 00, 23, 79 ), Clrted(), win( 05, 05, 16, 74, "T¡tulo" ), WaitState(), RstEnv( aEnv ) } )
*AddDownItem( mOutUsu, "Estilo &2", "T¡tulo centralizado / Alto relevo", { || aEnv := SavEnv( 02, 00, 23, 79 ), Clrted(), win( 05, 05, 16, 74, "T¡tulo", 2, 2 ), WaitState(), RstEnv( aEnv ) } )
*AddDownItem( mOutUsu, "Estilo &3", "T¡tulo … direita / Normal"        , { || aEnv := SavEnv( 02, 00, 23, 79 ), Clrted(), win( 05, 05, 16, 74, "T¡tulo", 3, 3 ), WaitState(), RstEnv( aEnv ) } )

AddDownItem( mOut, "&Usuarios",,mOutUsu,,,,,469)
AddDownItem( mOut, "&Salva Configura‡Æo",, { || salvaconf() },,,,,469)
/*


*PROXIMA SENHA 556

*AddDownItem( mPdn, "Sai&r", "Encerra o programa", { || Saida() } )

*AddDownItem( mPdnChk, "Check &1", "Marca/Desmarca Check 1", { || ChkDownItem( mPdnChk, 1, !ChkDownItem( mPdnChk, 1 ) ) } )
*AddDownItem( mPdnChk, "Check &2", "Marca/Desmarca Check 2", { || ChkDownItem( mPdnChk, 2, !ChkDownItem( mPdnChk, 2 ) ) } )
*AddDownItem( mPdnChk, "Check &3", "Marca/Desmarca Check 3", { || ChkDownItem( mPdnChk, 3, !ChkDownItem( mPdnChk, 3 ) ) } )
*AddDownItem( mPdnChk, "Check &4", "Marca/Desmarca Check 4", { || ChkDownItem( mPdnChk, 4, !ChkDownItem( mPdnChk, 4 ) ) } )
*AddDownItem( mPdnChk, "Check &5", "Marca/Desmarca Check 5", { || ChkDownItem( mPdnChk, 5, !ChkDownItem( mPdnChk, 5 ) ) } )

*AddDownItem( mPdnSet, "Set &1", "Habilita/Desabilita Set 1", { || SetDownItem( mPdnSet, 1, !SetDownItem( mPdnSet, 1 ) ) } )
*AddDownItem( mPdnSet, "Set &2", "Habilita/Desabilita Set 2", { || SetDownItem( mPdnSet, 2, !SetDownItem( mPdnSet, 2 ) ) } )
*AddDownItem( mPdnSet, "Set &3", "Habilita/Desabilita Set 3", { || SetDownItem( mPdnSet, 3, !SetDownItem( mPdnSet, 3 ) ) } )
*AddDownItem( mPdnSet, "Set &4", "Habilita/Desabilita Set 4", { || SetDownItem( mPdnSet, 4, !SetDownItem( mPdnSet, 4 ) ) } )
*AddDownItem( mPdnSet, "Set &5", "Habilita/Desabilita Set 5", { || SetDownItem( mPdnSet, 5, !SetDownItem( mPdnSet, 5 ) ) } )




*AddDownItem( mDiv, "&Mouse/GET" , "Mouse no sistema GET padrÆo do Clipper", { || MouseGet() } )
*AddDownItem( mDiv, "&TBrowse"   , "TBrowse com uso de Mouse na Visual Lib", { || VLTBrow() } )
*AddDownItem( mDiv, "&Sombra..." , "Efeito de sombra da Visual Lib"       , { || TesteSombra() } )

*/




// terceiro parametro CHAMA LOGO NOVAMENTE OU NAO

Desktop(alltrim(AEMP00->EMPNOM),,.f.) //Fun‡Æo que inicializa a Visual Lib - Sempre deve ser chamada no inicio

set key 288 to NULO()

lPri = .t.

while .t.           // Loop principal

  BarMenu( mBar )  //VL-Ap¢s a definicao dos menus, BarMenu( mBar ) controla tudo

  set key K_F10 to // Desligamos set key
  SetKeyMouse( K_F10, {} ) //VL-Desativamos o Mouse para F10


  VLExit()         //VL-Pede confirmacao para sair

  set key K_F10 to VLMARQUEE() // Se chegou aqui, significa que nao saiu...
  SetKeyMouse( K_F10, { 24, 24, 72, 79 } ) //VL-Define novamente F10 p/ mouse

end

return nil


function SALVACONF

  fnt_:= Wvt_GetFontInfo()
 _FONTET_   = fnt_[ 2 ]
 _FONTEL_   = fnt_[ 3 ]

 sqlORDEM = {}
 sqlCAMPO = {}
 sqlCHAVE =  {}
 sqlARQUI = {"CONFIGURAR","UPDATE OR INSERT"}
 aadd(sqlCHAVE,{"MAQUINA"})
 aadd(sqlCAMPO,{"MAQUINA",netname(),.t.})
 aadd(sqlCAMPO,{"FONTET",str(_FONTET_,3),.f.})
 aadd(sqlCAMPO,{"FONTEL",str(_FONTEL_,3),.f.})
 executasql()

 msgbox1("Configuracao de tela salva")
 return ""
 
 function Clrted
 return .t.
 

***************
function RODAPE
***************

parameters F_ATV,F_MOD,F_NADA,F_PRG

if !isnil(F_ATV)
  cF_ATV = F_ATV
endif
if !isnil(F_MOD)
  cF_MOD = F_MOD
endif
if !isnil(F_PRG)
  cF_PRG = F_PRG
endif


*  cF_ATV = pad(F_ATV,15)
*  cF_MOD = pad(F_MOD,15)
*  cF_PRG = pad(F_PRG,15)

  oBar:update(1,padc(alltrim(cF_ATV),14))
  oBar:update(2,padc(alltrim(cF_MOD),13))
  oBar:update(3,M_LOGNOM,"G/W")
  oBar:update(4,cF_PRG)
  oBar:update(5,"EMPRESA: " + STR(ME_EMP,2))
*  oBar:update(7,time())

return .T.



******************
function SE_EMITINDO(fTIPO,fOQUE)
******************

if fTIPO
  do case
    case fOQUE == "APED00"
      if file("&_PATH_\ABERTOP.TXT")
        handleAberto=fopen("&_PATH_\ABERTOP.TXT",16)
      else
        handleAberto=fcreate("&_PATH_\ABERTOP.TXT")
        fclose(handleAberto)
        handleAberto=fopen("&_PATH_\ABERTOP.TXT",16)
      endif
    case fOQUE == "ANFS00"
      if file("&_PATH_\ABERTON.TXT")
        handleAberto=fopen("&_PATH_\ABERTON.TXT",16)
      else
        handleAberto=fcreate("&_PATH_\ABERTON.TXT")
        fclose(handleAberto)
        handleAberto=fopen("&_PATH_\ABERTON.TXT",16)
      endif
  endcase
  if handleAberto < 0
    return .t.
  else
    return .f.
  endif
else
  fclose(handleAberto)
  return .t.
endif



*****************
function SEEXISTESQL
*****************

local A
parame F_ABREARQUIVO

if select(F_ABREARQUIVO) > 0
  select &F_ABREARQUIVO
  use
  return .F.
endif

return .T.



*****************
function CRIADBFTOclasse(fARQUIVO,fCRIAR)
*****************

select &farquivo

aFields := &fARQUIVO -> (dbStruct ())
nMax := len (aFields)

M_ARQ = fARQUIVO + ".pas"

set print on
set printer to &M_ARQ
set console off

? "unit classe_" + fARQUIVO + ";"
?
? "{$mode ObjFPC}{$H+}"
?
? "interface"
?
? "uses"
? "  Classes, SysUtils, Controls, ExtCtrls, Dialogs,utabela, ZDataset;"
? "  type"
?
? "    { T" + fARQUIVO  + " }"
?
? "    TAEMP00 = class"
? "      private"

FOR i := 1 TO nMax
   ? "        T" + aFields [i][1]
   ?? ":"
   DO CASE
*     CASE (aFields [i][2] == "L")
*       ?? "CHAR(1) DEFAULT ''"
   CASE (aFields [i][2] == "C")
     ?? "string;"
   CASE (aFields [i][2] == "D")
     ?? "tDATE;"
   CASE (aFields [i][2] == "N")
     if aFields [i][4] = 0 // TEM DECIMAL
       ?? "Integer;"
     else
       ?? "Double;"
     endif
   ENDCASE
next

? "        function retornaAI:Integer;"
? "      public"
? "        function incluir:Boolean;"
? "        function localiza(CODIGO:Integer):Boolean;"
? "        function altera(CODIGO:Integer):Boolean;"
? "        function excluir(CODIGO:Integer):Boolean;"
? "      published"
FOR i := 1 TO nMax
   ? "        property " + aFields [i][1]
   ?? ":"
   DO CASE
*     CASE (aFields [i][2] == "L")
*       ?? "CHAR(1) DEFAULT ''"
   CASE (aFields [i][2] == "C")
     ??   "string  read " + "T" + aFields [i][1] + " write T" + aFields [i][1] + ";"
   CASE (aFields [i][2] == "D")
     ??   "tDATE   read " + "T" + aFields [i][1] + " write T" + aFields [i][1] + ";"
   CASE (aFields [i][2] == "N")
     if aFields [i][4] = 0 // TEM DECIMAL
       ?? "Integer read " + "T" + aFields [i][1] + " write T" + aFields [i][1] + ";"
     else
       ?? "Double  read " + "T" + aFields [i][1] + " write T" + aFields [i][1] + ";"
     endif
   ENDCASE
next

? "    end;"
?
? "implementation"
?
? "{ T" + fARQUIVO + " }"
?
? "function T" + fARQUIVO + ".retornaAI: Integer;"
? "  var"
? "    qrAI : TZQuery;"
? "begin"
? "  qrAI := TZQuery.Create(Nil);"
? "  qrAI.Connection := TabGlobal.conexao;"
? "  qrAI.SQL.Add('select coalesce(max( IDARQUIVO_TROCAR ),0) + 1 as CODIGO from " + fARQUIVO + "');"
? "  qrAI.Open;"
? "  Result := qrAI.FieldByName('CODIGO').Value;"
? "  if Assigned(qrAI) then"
? "      FreeAndNil(qrAI);"
? "end;"
?
? "function T" + fARQUIVO + ".incluir: Boolean;"
? "var"
? "  qrInc : TZQuery;"
? "  cSQL : String;"
? "begin"
?
? "  cSQL:= 'INSERT INTO " + fARQUIVO + "'+"
? "  ' ('+"
FOR i := 1 TO nMax
  ? "   ' " + aFields [i][1]
  if i = nMax
   ?? ") VALUES (' +"
  else
   ?? ",'+"
  endif
next

FOR i := 1 TO nMax
  ? "   ' :" + aFields [i][1]
  if i = nMax
    ?? ")';"
  else
    ?? ",'+"
  endif
next

?
? "  qrInc := TZQuery.Create(Nil);"
? "  qrInc.Connection := TabGlobal.conexao;"
? "  qrInc.SQL.Text:= cSQL;"
?
? "  qrInc.ParamByName('CAMPOID_TROCAR').AsInteger:=retornaAI;"

FOR i := 1 TO nMax
  ? "  qrInc.ParamByName('" + aFields [i][1] + "').As"
  DO CASE
   CASE (aFields [i][2] == "C")
     ??   "string:=T" + aFields [i][1] + ";"
   CASE (aFields [i][2] == "D")
     ??   "DATE:=T" + aFields [i][1] + ";"
   CASE (aFields [i][2] == "N")
     if aFields [i][4] = 0 // TEM DECIMAL
       ?? "Integer:=T" + aFields [i][1] + ";"
     else
       ?? "Currency:=T" + aFields [i][1] + ";"
     endif
   ENDCASE
next

?
? "  TRY"
? "     qrInc.ExecSQL;"
? "     Result := True;"
? "  Except"
? "    On e: Exception do"
? "       Begin"
? "         Result := False;"
? "         ShowMessage('Erro ao incluir a Empresa' + sLineBreak + e.ClassName"
? "         +sLineBreak+e.Message);"
? "       end;"
? "  end;"
? "  if Assigned(qrInc) then"
? "    FreeAndNil(qrInc);"
? "end;"
?
? "function T" + fARQUIVO + ".localiza(CODIGO: Integer): Boolean;"
? "var"
? "  QrPesquisa : TZQuery;"
? "begin"
? "QrPesquisa := TZQuery.Create(Nil);"
? "QrPesquisa.Connection := TabGlobal.conexao;"
? "QrPesquisa.SQL.Text:= 'select * from " + fARQUIVO + " where IDCODIGO_TROCAR = :nCODIGO';"
? "QrPesquisa.ParamByName('nCODIGO').AsInteger:=CODIGO;"
? "QrPesquisa.Open;"
?
? "IF QrPesquisa.RecordCount >= 1 then"
? "  BEGIN"

FOR i := 1 TO nMax
  ? "    Self.T" + aFields [i][1] + ":= QrPesquisa.FieldByName('" + aFields [i][1] + "').As"
  DO CASE
  CASE (aFields [i][2] == "C")
    ?? "string;"
  CASE (aFields [i][2] == "D")
    ?? "DateTime;"
  CASE (aFields [i][2] == "N")
    if aFields [i][4] = 0 // TEM DECIMAL
      ?? "Integer;"
    else
      ?? "Currency;"
    endif
  ENDCASE
NEXT

? "    Result := True"
? "  end"
? "ELSE"
? "  Result := False;"
?
? "if Assigned(QrPesquisa) then"
? "    FreeAndNil(QrPesquisa);"
? "end;"
?
? "function T" + fARQUIVO + ".altera(CODIGO: Integer): Boolean;"
? "var"
? "  qrALT : TZQuery;"
? "  cSQL : String;"
? "begin"
?
? "  cSQL:= ' UPDATE " + fARQUIVO + " SET'+"
FOR i := 1 TO nMax
  ? "    ' " + aFields [i][1] + " = :" + aFields [i][1]
  if i < nMax
    ?? ",'+"
  endif
NEXT
??"         WHERE '+"
?"         ' " + fARQUIVO + ".IDCHAVE = :OLD_IDCHAVE';"
?
? "  qrALT := TZQuery.Create(Nil);"
? "  qrALT.Connection := TabGlobal.conexao;"
? "  qrALT.SQL.Text:= cSQL;"
? "  qrALT.ParamByName('OLD_IDCHAVE').AsInteger:=CODIGO;"

FOR i := 1 TO nMax
  ?"  qrALT.ParamByName('" + aFields [i][1] + "').As"
  DO CASE
  CASE (aFields [i][2] == "C")
    ?? "string:=T"
  CASE (aFields [i][2] == "D")
    ?? "DATE:=T"
  CASE (aFields [i][2] == "N")
    if aFields [i][4] = 0 // TEM DECIMAL
      ?? "Integer:=T"
    else
      ?? "Currency:=T"
    endif
  ENDCASE
  ?? aFields [i][1] + ";"
NEXT
?
? "  TRY"
? "     qrALT.ExecSQL;"
? "     Result := True;"
? "  Except"
? "    On e: Exception do"
? "       Begin"
? "         Result := False;"
? "         ShowMessage('Erro ao alterar Empresa' + sLineBreak + e.ClassName"
? "         +sLineBreak+e.Message);"
? "       end;"
? "  end;"
? "  if Assigned(qrALT) then"
? "    FreeAndNil(qrALT);"
? "end;"
?
? "function T" + fARQUIVO + ".excluir(CODIGO: Integer): Boolean;"
? "var"
? "  qrEXC : TZQuery;"
? "  cSQL : String;"
? "begin"
?
?"  cSQL:= 'DELETE FROM " + fARQUIVO + "'+"
?"         ' WHERE '+"
?"         ' " + fARQUIVO + ".IDCHAVE_ALTERAR = :OLD_IDCHAVE';"
?
? "  qrEXC := TZQuery.Create(Nil);"
? "  qrEXC.Connection := TabGlobal.conexao;"
? "  qrEXC.SQL.Text:= cSQL;"
? "  qrEXC.ParamByName('OLD_IDCHAVE').AsInteger:=CODIGO;"
?
? "  TRY"
? "     qrEXC.ExecSQL;"
? "     Result := True;"
? "  Except"
? "    On e: Exception do"
? "       Begin"
? "         Result := False;"
? "         ShowMessage('Erro ao excluir Empresa' + sLineBreak + e.ClassName"
? "         +sLineBreak+e.Message);"
? "       end;"
? "  end;"
? "  if Assigned(qrEXC) then"
? "    FreeAndNil(qrEXC);"
?
? "end;"
?
? "end."

set printer to
set print off


return ""


*****************
function CRIADBFTOSQL(fARQUIVO,fCRIAR,fCONDICAO)
*****************

select &farquivo

if fCRIAR
  aFields := &fARQUIVO -> (dbStruct ())
  nMax := len (aFields)

  M_ARQ = "C:\CIRURSQL\DADOS\" + fARQUIVO + ".SQL"

  set print on
  set printer to &M_ARQ
  set console off

  ? "CREATE TABLE " + fARQUIVO + " ("

  FOR i := 1 TO nMax
     ? aFields [i][1]
     ?? " "
     DO CASE
     CASE (aFields [i][2] == "L")
       ?? "CHAR(1) DEFAULT ''"
     CASE (aFields [i][2] == "C")
       ?? "CHAR(" + str(aFields [i][3],3) + ")  DEFAULT ''"
     CASE (aFields [i][2] == "D")
       ?? "DATE"
     CASE (aFields [i][2] == "N")
       if aFields [i][4] = 0 // TEM DECIMAL
         ?? 'NUMERIC(' + str(aFields[i][3],3) + ',0) DEFAULT 0'
       else
         ?? 'NUMERIC(' + str(aFields[i][3],3) + ',' + str(aFields[i][4],3) + ') DEFAULT 0'
       endif
     ENDCASE

     if i < nMax
       ?? ","
     endif

  next

  ?? ")"


  set printer to
  set print off
endif

M_ARQ = "C:\CIRURSQL\DADOS\" + fARQUIVO + "dados.SQL"

set print on
set printer to &M_ARQ
set console off

aFields := &fARQUIVO -> (dbStruct ())
nMax := len (aFields)

go top

do while !eof()

  if !fCONDICAO = NIL
  if &fCONDICAO
    skip
    loop
  endif
  endif

msw(str(recno()))

  ? "INSERT INTO " + fARQUIVO + " ("

  FOR i := 1 TO nMax
    ?? aFields [i][1]
    if i < nMax
      ?? ","
    endif
  next
  ?? ")"
  ? "     VALUES ("

  FOR i := 1 TO nMax

     DO CASE
     CASE (aFields [i][2] == "L")
       ?? "'" + iif(fieldget(i),"S","N") + "'"
     CASE (aFields [i][2] == "C")
       ?? "'" + TIRA_ACENTUACAO(fieldget(i)) + "'"
     CASE (aFields [i][2] == "D")
       if HB_ISNIL(fieldget(i)) .or. empty(fieldget(i))
         ?? "NULL"
       else
         ?? "'" + formatdta(fieldget(i)) + "'"
       endif
     CASE (aFields [i][2] == "N")
       if aFields [i][4] = 0 // TEM DECIMAL
         ?? str(fieldget(i))
       else
         ?? str1(fieldget(i),aFields [i][4])
       endif
     ENDCASE

    if i < nMax
      ?? ","
    endif

  next
  ?? ");"

  skip

enddo
? "COMMIT WORK;"

set printer to
set print off

return ""


// PEGAR OS XML NA CONSULTA

/*
Dim oErro, oExceptionInterop
Dim oConfiguracao, oConsSitNfe, oProcEventoNFe, X, oConsultaProtocolo, xmlEvento, nHandle, nomeArqDistribEvento
Dim oConfig, oConsSitNfeChNfe

'Criar configuraçao básica para consumir o serviço
Set oConfig = CreateObject("Unimake.Business.DFe.Servicos.Configuracao")
oConfig.TipoDFe = 0 '// 0=nfe
oConfig.CertificadoSenha = "12345678"
oConfig.CertificadoArquivo = "D:\projetos\UnimakePV.pfx"

'Criar XML da consulta protocolo
Set oConsSitNfe = CreateObject("Unimake.Business.DFe.Xml.NFe.ConsSitNfe")
oConsSitNfe.Versao = "4.00"
oConsSitNfe.TpAmb = 2   'Homologação
oConsSitNfe.ChNfe = "31240402046163000130550010000570591001308457"  'Chave da NFE

'Enviar a consulta
Set oConsultaProtocolo = CreateObject("Unimake.Business.DFe.Servicos.NFe.ConsultaProtocolo")
oConsultaProtocolo.Executar (oConsSitNfe), (oConfig)

MsgBox (oConsultaProtocolo.RetornoWSString)

If oConsultaProtocolo.Result.GetProcEventoNFeCount > 0 Then
   For X = 1 To oConsultaProtocolo.Result.GetProcEventoNFeCount
       Set oProcEventoNFe = oConsultaProtocolo.Result.GetProcEventoNFe(X - 1)

       nomeArqDistribEvento = "d:\testenfe\" + oProcEventoNFe.NomeArquivoDistribuicao

       MsgBox (nomeArqDistribEvento)

       xmlEvento = oProcEventoNFe.GerarXMLString() 'String do xml do evento

       MsgBox (xmlEvento)


       'Se quiser pegar um evento específico, só comparar o tipo de evento, conforme segue
       If oProcEventoNFe.Evento.InfEvento.tpEvento = 110111 Then ' //Cancelamento
          'Aqui dentro do IF só fazer o que foi feito fora dele, nas linhas anteriores,
          'mas só vai fazer se for um cancelamento.
       End If
     Next
End If

*/


******************
function LE_CONFIG
******************

feof = .f.

handle=fopen("CONFIG.CFG")

do while .t.
  if feof
    exit
  endif

  M_FRAZE = alltrim(freadline(handle))

  do case
     case left(M_FRAZE,9) == "_PATHSQL_"   ; _PATHSQL_ = alltrim(substr(M_FRAZE,at("=",M_FRAZE)+1,(at("*",M_FRAZE)-1)-at("=",M_FRAZE)))
     case left(M_FRAZE,10) == "_PATHODBC_"   ; _PATHODBC_ = alltrim(substr(M_FRAZE,at("=",M_FRAZE)+1,(at("*",M_FRAZE)-1)-at("=",M_FRAZE)))
     case left(M_FRAZE,12) == "_PATH_INOVA_"   ; _PATH_INOVA_ = alltrim(substr(M_FRAZE,at("=",M_FRAZE)+1,(at("*",M_FRAZE)-1)-at("=",M_FRAZE)))
  endcase

enddo

fclose(handle)

