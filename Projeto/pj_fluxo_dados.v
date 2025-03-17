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
    wire [15:0] s_seed, s_numero_aletorio, s_contador_jogada, s_perm, s_indice;

    // Contador de Acertos
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

    // Contador das rodadas
    contador_163 ContRodada (
        .clock(clock),
        .clr(~zeraRod),
        .ld(1'b1),
        .ent(1'b1),
        .enp(contaRod),
        .D(1'b0),
        .Q(s_rodada),
        .rco()
    );

    // Comparadores
    comparador_jog ComparadorJogada (
        .A(), // indices
        .B(s_botao),
        .acerto(botaoIgualMemoria)
    );

    comparador_85 ComparadorRodada (
        .A(4'b0011), // 3 rodadas no final
        .B(s_rodada),
        .AEBi(1'b1),
        .AGBi(1'b0),
        .ALBi(1'b0),
        .AGBo(),
        .ALBo(),
        .AEBo(rodadaIgualFinal)
    );

    // Memória ROM
    sync_rom_16x4 MemJogo (
        .clock(clock),
        .address(),
        .data_out()
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
        .reset(zeraRod),
        .sinal(s_tem_jogada),
        .pulso(jogada_feita)
    );

    contador_m #(.M(65536), .N(16)) contador_tempo_jogada (
        .clock(clock), 
        .zera_s(),
        .zera_as(),
        .conta(),             
        .Q(s_contador_jogada),
        .fim(),
        .meio()
    );

    mux2x1_n #(.BITS(16)) mux_randomizador (
        .clock(clock),
        .D0(s_contador_jogada),
        .D1(s_numero_aleatorio),
        .SEL(),
        .OUT(s_seed),
    );                                      


    // Randomizador
    lfsr randomizador (
         .clock(clock),
         .reset(reset),              
         .entrada(s_seed),
         .saida(s_numero_aleatorio)
    );


    //Índices
    gerador_indices GeradorIndices (
        .clock(clock),
        .reset(),
        .entrada(s_numero_aleatorio),

        .perm(s_perm),
        .ready()
    );

    registrador_m #(.BITS(16)) RegistradorIndice (
        .clock(clock),
        .clear(),
        .enable(),
        .D(s_perm),
        .Q(s_indice)
    );

//    GameRam MemoriaJogo (
//         .clock(clock),
//         .gameIndex(),
//         .extGamesPlayed(),
//         .extGameArray(),
//         .loadRAM(),
//         .updateRam(),
//         .played(),
//         .gameLocation()
//     );

//     SelectGameIndex SelecionaJogo (
//         .clock(clock),
//         .gameArray(),
//         .randomNumber(),
//         .gameIndex(),
//         .loadRAM(),
//         .valid()
//     );
   
   
    // Lógica combinacional
    assign s_tem_jogada = |botoes;

    // Sinais de depuração
    assign db_jogada = s_botao;
    assign db_contagem = s_endereco;
    assign db_tem_jogada = s_tem_jogada;
  
endmodule
