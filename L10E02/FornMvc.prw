#INCLUDE 'Totvs.ch'
#INCLUDE 'Report.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Fwmvcdef.ch'

/*/{Protheus.doc} User Function Relat

    Relatório para imprimir os dados do fornecedor selecionado. Esse relatório será chamado através de um botão
    @type  Function
    @author Vinicius Silva
    @since 05/04/2023
	@See https://devforum.totvs.com.br/1165-obter-os-dados-da-linha-posicionada-no-browse
/*/
User Function FornMvc()
    Local cAlias := "SA2"
    Local cTitle := "Cadastro de Fornecedores"
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias(cAlias) 
    oBrowse:SetDescription(cTitle) 
	oBrowse:AddButton("Relatorio", "U_Relat"  , 6, 1)   
    oBrowse:DisableDetails()
    oBrowse:DisableReport() 
    oBrowse:Activate() 
Return 

Static Function MenuDef()
    Local aRotina := {}

    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.FornMvc" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.FornMvc" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.FornMvc" OPERATION 5 ACCESS 0
    
Return aRotina

Static Function ModelDef()
    Local oModel   := MPFormModel():New("FORNMVC_M")
    Local oStruSA2 := FWFormStruct(1, "SA2")

    oModel:AddFields("SA2MASTER",,oStruSA2)

    oModel:SetPrimaryKey({"A2_COD"})

Return oModel

Static Function ViewDef()
    Local oModel   := FwLoadModel("FornMvc") 
    Local oStruSA2 := FWFormStruct(2, "SA2")
    Local oView    := FwFormView():New()

    oView:SetModel(oModel) 
    oView:AddField("VIEW_SA2", oStruSA2, "SA2MASTER")

Return oView

User Function Relat()
    Local oReport := GeraReport() 
	
 	oReport:PrintDialog()
Return 

Static Function GeraReport()
	Local cAlias	:= GetNextAlias()
	
	Local oReport	:= TReport():New('FornMvc', 'Relatório de Fornecedores',,{|oReport| Imprime(oReport, cAlias)}, 'Esse relatório imprimirá todos os fornecedores cadastrados',.F.,,,, .T., .T.)	
	
	Local oSection	:= TRSection():New(oReport, "Fornecedores Cadastrados",,,.F.,.T.)		
	
	TRCell():New(oSection, 'A2_COD', 'SA2', 'Codigo',, 8,,, 'LEFT', .T., 'LEFT',,, .T.,,, .T.)
	
	TRCell():New(oSection, 'A2_NOME', 'SA2', 'Razao Social',, 30,,, 'LEFT', .T., 'LEFT',,, .T.,,, .T.)
	
	TRCell():New(oSection, 'A2_BAIRRO', 'SA2', 'Bairro',, 30,,, 'CENTER', .T., 'CENTER',,, .T.,,, .T.)
	
	TRCell():New(oSection, 'A2_EST', 'SA2', 'Estado',, 20,,, 'CENTER', .T., 'CENTER',,, .T.,,, .T.)
	
Return oReport

Static Function Imprime(oReport, cAlias)
	Local oSection := oReport:Section(1)
	Local nTotReg  := 0
	Local cQuery   := GeraQuery()	
	
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

		oSection:Cell('Codigo'):SetValue((cAlias)->A2_COD)
		oSection:Cell('Razao Social'):SetValue((cAlias)->A2_NOME)
		oSection:Cell('Bairro'):SetValue((cAlias)->A2_BAIRRO)
        oSection:Cell('Estado'):SetValue((cAlias)->A2_EST)
      
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

	cQuery += 'SELECT A2_COD, A2_NOME, A2_BAIRRO, A2_EST' + CRLF
	cQuery += 'FROM ' + RetSqlName('SA2') + ' SA2' + CRLF
	cQuery += "WHERE D_E_L_E_T_= ' '" + CRLF
	cQuery += "AND" + CRLF
	cQuery += "A2_COD = '" + SA2->A2_COD + "'" + CRLF //* Tras para nós o campo que está selecionado no Browse
    
Return cQuery

