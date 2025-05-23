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
    input        memoria,
    input        pronto,       
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
    wire [3:0] s_sequencia, s_jogada, s_dado, s_dado0, s_dado1,  s_endereco;
    wire s_memoria, s_tem_jogada;

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

    comparador_85 ComparadorSeq (
        .A(s_sequencia),
        .B(s_endereco),
        .AEBi(1'b1),
        .AGBi(1'b0),
        .ALBi(1'b0),
        .AGBo(enderecoMenorOuIgualSequencia),
        .ALBo(),
        .AEBo(enderecoIgualSequencia)
    );

    // Memória ROM
    sync_rom_16x4 MemJogo0 (
        .clock(clock),
        .address(s_endereco),
        .data_out(s_dado0)
    );

    
    // Memória ROM
    sync_rom_16x4_desafio MemJogo1 (
        .clock(clock),
        .address(s_endereco),
        .data_out(s_dado1)
    );
   
    // Registrador botoes
    registrador_4 RegBotoes (
        .clock(clock),
        .clear(zeraR),
        .enable(registraR),
        .D(botoes),
        .Q(s_jogada)
    );

    registrador_4 RegMem(
        .clock(clock),
        .clear(zeraM),
        .enable(registraM),
        .D(s_dado),
        .Q(s_memoria)
    );

    // Detector de borda
    edge_detector detectorJog (
        .clock(clock),
        .reset(zeraS),
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
    //Multiplexadores 
    mux2x1_n seletorLeds(
        .D0(s_dado),
        .D1(botoes),
        .SEL(s_tem_jogada),
        .OUT(db_memoria)
    );

    mux2x1_n seletorJogo(
        .D0(s_dado0),
        .D1(s_dado1),
        .SEL(r_memoria[0]),
        .OUT(s_dado)
    );   
   
    registrador_4 regS_Mem(
        .clock(clock),
        .clear(pronto),
        .enable(zeraM)
        .D(s_memoria),
        .Q(r_memoria)
    );
   
    // Lógica combinacional
    assign s_tem_jogada = |botoes;
    assign s_memoria = {3'b0, memoria};
   

    // Sinais de depuração
    assign db_jogada = s_jogada;
    assign db_contagem = s_endereco;
    assign db_sequencia = s_sequencia;
    assign db_tem_jogada = s_tem_jogada;
  
endmodule
