#INCLUDE 'Totvs.ch'
#INCLUDE 'Report.ch'
#INCLUDE 'Topconn.ch'


/*/{Protheus.doc} User Function L10E01
    Relatório TReport dos cadastros de produtos
    @type  Function
    @author Vinicius Silva
    @since 05/04/2023
    /*/
User Function L10E01()
    Local oReport := GeraReport() 
	
 	oReport:PrintDialog()
Return 

Static Function GeraReport()
	Local cAlias	:= GetNextAlias()
	
	Local oReport	:= TReport():New('L10E01', 'Relatório de Produtos',,{|oReport| Imprime(oReport, cAlias)}, 'Esse relatório imprimirá todos os produtos cadastrados',.F.,,,, .T., .T.)	
	
	Local oSection	:= TRSection():New(oReport, "Produtos Cadastrados",,,.F.,.T.)		
	
	TRCell():New(oSection, 'B1_COD', 'SB1', 'Codigo',, 8,,, 'LEFT', .T., 'LEFT',,, .T.,,, .T.)
	
	TRCell():New(oSection, 'B1_DESC', 'SB1', 'Descricao',, 30,,, 'LEFT', .T., 'LEFT',,, .T.,,, .T.)
	
	TRCell():New(oSection, 'B1_UM', 'SB1', 'Un. Medida',, 30,,, 'CENTER', .T., 'CENTER',,, .T.,,, .T.)
	
	TRCell():New(oSection, 'B1_PRV1', 'SB1', 'Preco de Venda',, 20,,, 'CENTER', .T., 'CENTER',,, .T.,,, .T.)
	
	TRCell():New(oSection, 'B1_LOCPAD', 'SB1', 'Armazem',, 20,,, 'CENTER', .T., 'CENTER',,, .T.,,, .T.)
	
Return oReport

Static Function Imprime(oReport, cAlias)
	Local oSection := oReport:Section(1)
	Local nTotReg		:= 0
	Local cQuery		:= GeraQuery()	
	
	DBUseArea(.T., 'TOPCONN', TcGenQry(,, cQuery), cAlias, .T., .T.)	

	Count TO nTotReg 

	oReport:SetMeter(nTotReg)
	oReport:StartPage()
	oSection:Init()  

	(cAlias)->(DBGoTop())
	while !(cAlias)->(EoF())
		if oReport:Cancel() 
			Exit
		endif

		oSection:Cell('Codigo'):SetValue((cAlias)->B1_COD)
		oSection:Cell('Descricao'):SetValue((cAlias)->B1_DESC)
		oSection:Cell('Un. Medida'):SetValue((cAlias)->B1_UM)

        if Empty((cAlias)->B1_PRV1)
            oSection:Cell('Preco de Venda'):SetValue((cAlias)->B1_PRV1, 'R$0,00')
        else    
		    oSection:Cell('Preco de Venda'):SetValue((cAlias)->B1_PRV1)
        endif


		oSection:Cell('Armazem'):SetValue((cAlias)->B1_LOCPAD)
		
		oSection:PrintLine()
		oReport:ThinLine()
		oReport:IncMeter()
		(cAlias)->(DBSkip())
	enddo   
	
	(cAlias)->(DBCloseArea())
	
	oSection:Finish()			
	
	oReport:EndPage()
Return 

Static Function GeraQuery()
	Local cQuery := ''

	cQuery += 'SELECT B1_COD, B1_DESC, B1_UM, B1_PRV1, B1_LOCPAD' + CRLF
	cQuery += 'FROM ' + RetSqlName('SB1') + ' SB1' + CRLF
	cQuery += "WHERE D_E_L_E_T_= ' '" + CRLF
    
Return cQuery

