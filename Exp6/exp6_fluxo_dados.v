/*
 * ------------------------------------------------------------------
 *  Arquivo   : exp6_fluxo_dados.v
 *  Projeto   : Experiencia 6 
 * ------------------------------------------------------------------
 *  Descricao : Circuito do fluxo de dados da Atividade 1
 * 
 *     1) Projeto FPGA
 * ------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      11/01/2024  1.0     Edson Midorikawa  versao inicial
 *      13/01/2025  1.1     Thomaz Stecca     experiencia 2 
 *      18/01/2025  1.2     Pedro Matusita    experiencia 3 
 *      21/01/2025  1.3     Pedro Matusita    experiencia 4 
 *      31/01/2025  1.4     Pedro Matusita    experiencia 5
 *      06/01/2025  1.5     Pedro Matusita    experiencia 6
 *      09/02/2025  1.6     Thomaz Stecca     Refatoração
 * ------------------------------------------------------------------
 */

module fluxo_dados (
    input        clock,
    // Dados                
    input [3:0]  botoes,
    // Controle     
    input        zeraR, zeraE, zeraL, zeraM, zeraTMR, 
    input        registraR, registraM, 
    input        contaE, contaL, contaTMR,
    output       fimL, fimE, fimTMR,
    output       jogada_feita, chavesIgualMemoria, enderecoIgualLimite, enderecoMenorOuIgualLimite, timeout, 
    // Depuração
    output       db_tem_jogada,
    output [3:0] db_contagem, db_jogada, db_memoria, db_limite
);


    // Sinais internos
    wire [3:0] s_limite, s_jogada, s_dado, s_endereco;
    wire s_tem_jogada;

    // Contador de limite
    contador_163 ContadorL (
        .clock(clock),
        .clr(~zeraL),
        .ld(1'b1),
        .ent(1'b1),
        .enp(contaL),
        .D(4'b0),
        .Q(s_limite),
        .rco(fimL)
    );

    // Contador de endereço
    contador_163 ContadorE (
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
        .AEBo(chavesIgualMemoria)
    );

    comparador_85 ComparadorL (
        .A(s_limite),
        .B(s_endereco),
        .AEBi(1'b1),
        .AGBi(1'b0),
        .ALBi(1'b0),
        .AGBo(enderecoMenorOuIgualLimite),
        .AEBo(enderecoIgualLimite)
    );

    // Memória ROM
    sync_rom_16x4 MemoriaJogada (
        .clock(clock),
        .address(s_endereco),
        .data_out(s_dado)
    );

    // Registrador botoes
    registrador_4 RegR (
        .clock(clock),
        .clear(zeraR),
        .enable(registraR),
        .D(botoes),
        .Q(s_jogada)
    );

    registrador_4 RegM(
        .clock(clock),
        .clear(zeraM),
        .enable(registraM),
        .D(db_memoria),
        .Q(s_dado)
    );

    // Detector de borda
    edge_detector detector (
        .clock(clock),
        .reset(zeraL),
        .sinal(s_tem_jogada),
        .pulso(jogada_feita)
    );

    // Contadores temporizadores para um relógio de 1000Hz
    contador_m #(.M(5000), .N(13)) contador_timeout (
        .clock(clock), 
        .zera_s(),
        .zera_as(contaE || zeraE),
        .conta(!s_tem_jogada && !timeout),             
        .Q(),
        .fim(timeout),
        .meio()
    );

    contador_m #(.M(500), .N(10)) contadorTMR (
        .clock(clock), 
        .zera_s(zeraTMR),
        .zera_as(),
        .conta(contaTMR),             
        .Q(),
        .fim(fimTMR),
        .meio()
    );

    // Lógica combinacional
    assign s_tem_jogada = |botoes;

    // Sinais de depuração
    assign db_jogada = s_jogada;
    assign db_contagem = s_endereco;
    assign db_limite = s_limite;
    assign db_tem_jogada = s_tem_jogada;
  
endmodule
