#INCLUDE 'Totvs.ch'

/*/{Protheus.doc} User Function MT120BRW
    Ponto de Entrada para adicionar um bot�o na Rotina de Pedido de Compras. O objetivo aqui � criar um relat�rio com duas se��es 
    @type  Function
    @author Vinicius Silva
    @since 06/04/2023
/*/
User Function MT120BRW()

   AAdd( aRotina, { 'Relatorio', 'U_L10E03', 0, 6 } ) //* Btn para o exerc�cio 3 e 4
   AAdd( aRotina, { 'Exe 05', 'U_L10E05', 0, 6 } ) //* Btn para o exerc�cio 5

Return 
