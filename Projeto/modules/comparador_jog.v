/* -----------------------------------------------------------------
 *  Arquivo   : comparador_jog.v
 *  Projeto   : MindFocus
 * -----------------------------------------------------------------
 * Descricao : comparador de jogadas para o jogo
 * -----------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     10/03/2025  1.0     Pedro Matusita     criacao
 * -----------------------------------------------------------------
 */

module comparador_jog ( A, B, acerto);

    input[3:0] B;
    input[7:0] A;
    output     acerto;

    wire CS1, CS2, CS3, CS4;

    assign CS1  = (A[7:6] == 2'b00) && B[3];
    assign CS2  = (A[5:4] == 2'b00) && B[2];
    assign CS3  = (A[3:2] == 2'b00) && B[1];
    assign CS4  = (A[1:0] == 2'b00) && B[0];

    assign acerto = CS1 | CS2 | CS3 | CS4;

endmodule /* comparador_jog */