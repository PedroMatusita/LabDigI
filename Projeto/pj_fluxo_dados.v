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
    input        clock, reset, 
    // Dados                
    input [3:0]  botoes,
    // Controle     
    input        zeraA, zeraRod, zeraR, zeraM, zeraI, zeraContImg, // zerar 
    input        registraR, registraM,               // registrar
    input        contaRod, contaA, contaI, contaimg,             // contar
    // output       fimE,                   // fim

    output       botaoIgualMemoria, jogada_feita, rodadaIgualFinal, indiceReady,
    // Saída
    output [3:0] acertos,
    //Depuracao
    output       db_tem_jogada,
    output [7:0] db_indices,
    output [3:0] db_contagem, db_jogada, db_memoria,
    output timeout_img
);

    
    


    // Sinais internos
    wire [3:0] s_endereco, s_memoria, s_botao, s_rodada;
    wire s_tem_jogada;
    wire [15:0] s_seed, s_numero_aletorio, s_contador_jogada;
    wire [7:0]  s_perm, s_indice;

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
    comparador_jogo ComparadorJogada (
        .indices(s_indice), 
        .jogada(s_botao),
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

    // // Memória ROM
    // sync_rom_16x4 MemJogo (
    //     .clock(clock),
    //     .address(),
    //     .data_out()
    // );

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
        .zera_as(zeraI),
        .conta(contaI),             
        .Q(s_contador_jogada),
        .fim(),
        .meio()
    );

    mux2x1_n #(.BITS(16)) mux_randomizador (
        .D0(s_contador_jogada),
        .D1(s_numero_aletorio),
        .SEL(1'b0),
        .OUT(s_seed)
    );                                      


    // Randomizador
    lfsr randomizador (
         .clock(clock),
         .reset(reset),              
         .entrada(s_seed),
         .saida(s_numero_aletorio)
    );


    //Índices
    gerador_indices GeradorIndices (
        .clock(clock),
        .reset(reset),
        .entrada(s_numero_aletorio),

        .perm(s_perm),
        .ready(indiceReady)
    );

    registrador_m #(.BITS(8)) RegistradorIndice (
        .clock(clock),
        .clear(zeraM),
        .enable(registraM),
        .D(s_perm),
        .Q(s_indice)
    );
    contador_m #(.M(5000), .N(13)) contador_tempo_imagem (
        .clock(clock), 
        .zera_s(),
        .zera_as(zeraContImg),
        .conta(contaimg),             
        .Q(),
        .fim(timeout_img),
        .meio()
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
    assign db_contagem = s_rodada;
    assign db_indices = s_indice;
  
endmodule
