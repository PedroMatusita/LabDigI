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

module comparador_jogo ( input[7:0] indices, input[3:0] jogada, output acerto);

    wire CS1, CS2, CS3, CS4;

    assign CS1  = (indices[7:6] == 2'b00) && jogada[3];
    assign CS2  = (indices[5:4] == 2'b00) && jogada[2];
    assign CS3  = (indices[3:2] == 2'b00) && jogada[1];
    assign CS4  = (indices[1:0] == 2'b00) && jogada[0];

    assign acerto = CS1 | CS2 | CS3 | CS4;

endmodule /* comparador_jogo */
