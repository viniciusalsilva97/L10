#INCLUDE 'Totvs.ch'

/*/{Protheus.doc} User Function MA020ROT
    Ponto de Entrada que que vai adicionar um botão no cadastro de Fornecedores. Esse botão vai imprimir um relatório do fornecedor selecionado
    @type  Function
    @author Vinicius SIlva
    @since 06/04/2023
    @see https://devforum.totvs.com.br/1165-obter-os-dados-da-linha-posicionada-no-browse
    /*/
User Function MA020ROT() 
    Local aRotUser := {} 

    Aadd(aRotUser, {"Imprimir Relatorio", "U_Rel", 0, 6})

Return aRotUser 
