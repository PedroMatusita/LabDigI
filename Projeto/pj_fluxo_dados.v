/*
 * ------------------------------------------------------------------
 *  Arquivo   : pj_fluxo_dados.v
 *  Projeto   : MindFocus 
 * ------------------------------------------------------------------
 *  Descricao : Circuito do fluxo de dados do Projeto
 * 
 *     1) Projeto FPGA
 * ------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      10/03/2025  1.0     Pedro Matusita    Versao inicial
 * ------------------------------------------------------------------
 */

module fluxo_dados (
    input        clock,
    // Dados                
    input [3:0]  botoes,
    // Controle     
    input        zeraA, zeraE, zeraR,  // zerar
    input        registraR,               // registrar
    input        contaE, contaA             // contar
    output       fimE,                   // fim

    output       botaoIgualMemoria, jogada_feita, 
    // Saída
    output [3:0] acertos,
    //Depuracao
    output       db_tem_jogada,
    output [3:0] db_contagem, db_jogada, db_memoria
);


    // Sinais internos
    wire [3:0] s_endereco, s_memoria, s_botao;
    wire s_tem_jogada;

    // Contador da Sequencia
    contador_163 ContAcertos (
        .clock(clock),
        .clr(~zeraA),
        .ld(1'b1),
        .ent(1'b1),
        .enp(contaA),
        .D(1'b0),
        .Q(acertos),
        .rco()
    );

    // Contador de endereço
    contador_163 ContEnd (
        .clock(clock),
        .clr(~zeraE),
        .ld(1'b1),
        .ent(1'b1),
        .enp(contaE),
        .D(1'b0),
        .Q(s_endereco),
        .rco(fimE)
    );

    // Comparadores
    comparador_85 ComparadorJogada (
        .A(s_memoria),
        .B(s_botao),
        .AEBi(1'b1),
        .AGBi(1'b0),
        .ALBi(1'b0),
        .ALBo(),
        .AGBo(),
        .AEBo(botaoIgualMemoria)
    );

    // Memória ROM
    sync_rom_16x4 MemJogo (
        .clock(clock),
        .address(s_endereco),
        .data_out(s_memoria)
    );

    // Registrador botoes
    registrador_4 RegBotoes (
        .clock(clock),
        .clear(zeraR),
        .enable(registraR),
        .D(botoes),
        .Q(s_botao)
    );

    // Detector de borda
    edge_detector detector (
        .clock(clock),
        .reset(zeraE),
        .sinal(s_tem_jogada),
        .pulso(jogada_feita)
    );
   
   
    // Lógica combinacional
    assign s_tem_jogada = |botoes;

    // Sinais de depuração
    assign db_jogada = s_botao;
    assign db_contagem = s_endereco;
    assign db_tem_jogada = s_tem_jogada;
  
endmodule
