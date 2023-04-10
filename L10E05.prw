#INCLUDE 'Totvs.ch'
#INCLUDE 'Report.ch'
#INCLUDE 'Topconn.ch'

/*/{Protheus.doc} User Function L10E05
    Adicionar um novo bot�o que vai gerar um  relat�rio com todos os pedidos existentes
    @type  Function
    @author Vinicius Silva
    @since 05/04/2023
    /*/
User Function L10E05()
    Local oReport := GeraReport() 
	
 	oReport:PrintDialog()
Return 

Static Function GeraReport()
	Local cAlias	:= GetNextAlias()
	
	Local oReport	:= TReport():New('L10E05', 'Relat�rio de Pedidos de Compra',,{|oReport| Imprime(oReport, cAlias)}, 'Esse relat�rio imprimir� os Pedidos de Compra',.F.)	
	
	Local oSection	:= TRSection():New(oReport, "Cabe�alho do Pedido")	

	Local oSection2	:= TRSection():New(oSection, "Itens do Pedido")

	//* Adi��o do Exerc�cio 04
	Local oBreak 		
	
    //! SE��O 1 DO RELAT�RIO
	TRCell():New(oSection, 'C7_NUM', 'SC7', 'Numero do Pedido',, 8,,, 'LEFT', .T., 'LEFT',,, .T.,,, .T.)
	TRCell():New(oSection, 'C7_EMISSAO', 'SC7', 'Data de Emissao',, 30,,, 'LEFT', .T., 'LEFT',,, .T.,,, .T.)
	TRCell():New(oSection, 'C7_FORNECE', 'SC7', 'Codigo do Fornecedor',, 30,,, 'CENTER', .T., 'CENTER',,, .T.,,, .T.)
	TRCell():New(oSection, 'C7_LOJA', 'SC7', 'Loja do Fornecedor',, 20,,, 'CENTER', .T., 'CENTER',,, .T.,,, .T.)
	TRCell():New(oSection, 'C7_COND', 'SC7', 'Condicao de Pagamento',, 20,,, 'CENTER', .T., 'CENTER',,, .T.,,, .T.)
	
    //! SE��O 2 DO RELAT�RIO
	TRCell():New(oSection2, 'C7_PRODUTO', 'SC7', 'Codigo do Produto',, 8,,, 'LEFT', .T., 'LEFT',,, .T.,,, .T.)
	TRCell():New(oSection2, 'C7_DESCRI', 'SC7', 'Descricao do Produto',, 30,,, 'LEFT', .T., 'LEFT',,, .T.,,, .T.)
	TRCell():New(oSection2, 'C7_QUANT', 'SC7', 'Quantidade Pedida',, 30,,, 'CENTER', .T., 'CENTER',,, .T.,,, .T.)
	TRCell():New(oSection2, 'C7_PRECO', 'SC7', 'Preco Unitario',, 20,,, 'CENTER', .T., 'CENTER',,, .T.,,, .T.)
	TRCell():New(oSection2, 'C7_TOTAL', 'SC7', 'Valor Total',, 20,,, 'CENTER', .T., 'CENTER',,, .T.,,, .T.)

	//* Adi��o do Exerc�cio 04
	oBreak := TrBreak():New(oSection, oSection:Cell('C7_NUM'), '', .T.)
    TRFunction():New(oSection2:Cell('Valor Total'),'VALTOT','SUM',oBreak,'Valor Total',,,.F.,.F.,.F.)
	
Return oReport

Static Function Imprime(oReport, cAlias)
	Local oSection  := oReport:Section(1)
    Local oSection2 := oSection:Section(1)
	Local nTotReg   := 0
	Local cQuery    := GeraQuery()
    Local cCodAnt   := ""	   

	DBUseArea(.T., 'TOPCONN', TcGenQry(,, cQuery), cAlias, .T., .T.)	

	Count TO nTotReg 

	oReport:SetMeter(nTotReg)
	oReport:StartPage()
	// oSection:Init()  
	// oSection2:Init()  

    (cAlias)->(DBGoTop())
	while !(cAlias)->(EoF())
		if oReport:Cancel() 
			Exit
		endif

        if cCodAnt <> (cAlias)->(C7_NUM)
            //! Se��o 1
            oSection:Init()
            oSection:Cell('Numero do Pedido'):SetValue((cAlias)->C7_NUM)
            oSection:Cell('Data de Emissao'):SetValue((cAlias)->C7_EMISSAO)
            oSection:Cell('Codigo do Fornecedor'):SetValue((cAlias)->C7_FORNECE)
            oSection:Cell('Loja do Fornecedor'):SetValue((cAlias)->C7_LOJA)
            oSection:Cell('Condicao de Pagamento'):SetValue((cAlias)->C7_COND)
            oSection:PrintLine()
            oSection:Finish()
            oSection2:Init()
            cCodAnt := (cAlias)->(C7_NUM)
        endif

        //! Se��o 2
		oSection2:Cell('Codigo do Produto'):SetValue((cAlias)->C7_PRODUTO)
		oSection2:Cell('Descricao do Produto'):SetValue((cAlias)->C7_DESCRI)
		oSection2:Cell('Quantidade Pedida'):SetValue((cAlias)->C7_QUANT)
        oSection2:Cell('Preco Unitario'):SetValue((cAlias)->C7_PRECO)
        oSection2:Cell('Valor Total'):SetValue((cAlias)->C7_TOTAL)
		oSection2:PrintLine()
        oSection2:Finish()
		(cAlias)->(DBSkip())
	enddo

	oReport:ThinLine()
	oReport:IncMeter()

	(cAlias)->(DBCloseArea())
	
	// oSection:Finish()
	// oSection2:Finish()
	
	oReport:EndPage()
Return  

Static Function GeraQuery()
	Local cQuery := ''

	cQuery += 'SELECT * ' + CRLF
	cQuery += 'FROM ' + RetSqlName('SC7') + ' SC7' + CRLF
	cQuery += "WHERE D_E_L_E_T_= ' '" + CRLF
Return cQuery
