/*
 * ------------------------------------------------------------------
 *  Arquivo   : pj_fluxo_dados.v
 *  Projeto   : Projeto Final 
 * ------------------------------------------------------------------
 *  Descricao : Circuito do fluxo de dados da Atividade 1
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
    input        zeraR, zeraE, zeraS, zeraM, zeraTMR, 
    input        registraR, registraM, 
    input        contaE, contaS, contaTMR,
    output       fimS, fimE, fimTMR,

    output       jogada_feita, chavesIgualMemoria, enderecoIgualSequencia, enderecoMenorOuIgualSequencia, timeout, 
    //Depuracao
    output       db_tem_jogada,
    output [3:0] db_contagem, db_jogada, db_memoria, db_sequencia
);


    // Sinais internos
    wire [3:0] s_sequencia, s_jogada, s_dado, s_memoria, s_endereco;
    wire s_tem_jogada;

    // Contador da Sequencia
    contador_163 ContSeq (
        .clock(clock),
        .clr(~zeraS),
        .ld(1'b1),
        .ent(1'b1),
        .enp(contaS),
        .D(4'b0),
        .Q(s_sequencia),
        .rco(fimS)
    );

    // Contador de endereço
    contador_163 ContEnd (
        .clock(clock),
        .clr(~zeraE),
        .ld(1'b1),
        .ent(1'b1),
        .enp(contaE),
        .D(4'b0),
        .Q(s_endereco),
        .rco(fimE)
    );

    // Comparadores
    comparador_85 ComparadorJogada (
        .A(s_dado),
        .B(s_jogada),
        .AEBi(1'b1),
        .AGBi(1'b0),
        .ALBi(1'b0),
        .ALBo(),
        .AGBo(),
        .AEBo(chavesIgualMemoria)
    );

    // Memória ROM
    sync_rom_16x4 MemJogo (
        .clock(clock),
        .address(s_endereco),
        .data_out(s_dado)
    );

    // Registrador botoes
    registrador_4 RegBotoes (
        .clock(clock),
        .clear(zeraR),
        .enable(registraR),
        .D(botoes),
        .Q(s_jogada)
    );

    // Detector de borda
    edge_detector detector (
        .clock(clock),
        .reset(zeraS),
        .sinal(s_tem_jogada),
        .pulso(jogada_feita)
    );
   
   
    // Lógica combinacional
    assign s_tem_jogada = |botoes;

    // Sinais de depuração
    assign db_jogada = s_jogada;
    assign db_contagem = s_endereco;
    assign db_sequencia = s_sequencia;
    assign db_tem_jogada = s_tem_jogada;
  
endmodule
