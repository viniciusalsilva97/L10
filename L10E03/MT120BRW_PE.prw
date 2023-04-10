#INCLUDE 'Totvs.ch'

/*/{Protheus.doc} User Function MT120BRW
    Ponto de Entrada para adicionar um botão na Rotina de Pedido de Compras. O objetivo aqui é criar um relatório com duas seções 
    @type  Function
    @author Vinicius Silva
    @since 06/04/2023
/*/
User Function MT120BRW()

   AAdd( aRotina, { 'Relatorio', 'U_L10E03', 0, 6 } ) //* Btn para o exercício 3 e 4
   AAdd( aRotina, { 'Exe 05', 'U_L10E05', 0, 6 } ) //* Btn para o exercício 5

Return 
