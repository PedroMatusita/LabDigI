`timescale 1ns/1ns

module circuito_exp5_tb_cen1;

    // Sinais para conectar com o DUT
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        jogar_in = 0;
    reg  [3:0] botoes_in  = 4'b0000;

    wire       ganhou_out;
    wire       perdeu_out;
    wire       pronto_out;
    wire [3:0] leds_out;

    wire       db_igual_out;
    wire [6:0] db_contagem_out;
    wire [6:0] db_memoria_out;
    wire [6:0] db_estado_out;
    wire [6:0] db_jogadafeita_out;
    wire [6:0] db_sequencia_out;
    wire       db_clock_out;
    wire db_timeout;
    wire       db_iniciar_out;
    wire       db_tem_jogada_out;
    wire db_fimseq_out;
    wire db_igualseq_out;
    wire db_igualjogada_out;

    // Configuração do clock
    parameter clockPeriod = 1_000_000; // 1 ms, f = 1kHz

    // Identificação do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // Instanciação do DUT (Device Under Test)
    circuito_exp5 dut (
        .clock          ( clock_in    ),
        .reset          ( reset_in    ),
        .jogar        ( jogar_in  ),
        .botoes         ( botoes_in   ),
        .ganhou        ( ganhou_out ),
        .perdeu          ( perdeu_out   ),
        .pronto         ( pronto_out  ),
        .leds           ( leds_out    ),
        .db_igual       ( db_igual_out       ),
        .db_contagem    ( db_contagem_out    ),
        .db_memoria     ( db_memoria_out     ),
        .db_estado      ( db_estado_out      ),
        .db_jogadafeita ( db_jogadafeita_out ),
        .db_sequencia   (db_sequencia_out),
        .db_clock       ( db_clock_out       ),
        .db_iniciar     ( db_iniciar_out     ),
        .db_fimseq      (db_fimseq_out),
        .db_igualseq    (db_igualseq_out),
        .db_igualjogada (db_igualjogada_out),
        .db_tem_jogada  ( db_tem_jogada_out  ),
        .db_timeout	    ( db_timeout)
    );

    // Procedimento de teste
    initial begin
        $display("Início da simulação");

        // condicoes iniciais
        caso       = 0;
        clock_in   = 1;
        reset_in   = 0;
        jogar_in = 0;
        botoes_in  = 4'b0000;
        #clockPeriod;



         // Teste 1. resetar circuito
      caso = 1;
      // gera pulso de reset
      @(negedge clock_in);
      reset_in = 1;
      #(clockPeriod);
      reset_in = 0;
      // espera
      #(10*clockPeriod);

     // Teste 2. espera 10 periodos de clock
      caso = 2;
      #(5*clockPeriod);
      // espera
      #(10*clockPeriod);

      // Teste 3. iniciar=1 por 5 periodos de clock
      caso = 3;
      jogar_in = 1;
      #(5*clockPeriod);
      jogar_in = 0;
      // espera
      #(10*clockPeriod);

      // Teste 4. jogada #1 (ajustar chaves para 0001 por 10 periodos de clock
      caso = 4;
      @(negedge clock_in);
      botoes_in = 4'b0001;
      #(10*clockPeriod);

      // Teste 5. jogada #2 (ajustar chaves para 0010 por 10 periodos de clock
      caso = 5;
      @(negedge clock_in);
      botoes_in = 4'b0010;
      #(10*clockPeriod);

      // Teste 6. jogada #3 (ajustar chaves para 0100 por 10 periodos de clock
      caso = 6;
      @(negedge clock_in);
      botoes_in = 4'b0100;
      #(10*clockPeriod);

      // Teste 7. jogada #4 (ajustar chaves para 1000 por 10 periodos de clock
      caso = 7;
      @(negedge clock_in);
      botoes_in = 4'b1000;
      #(10*clockPeriod);

    // Teste 8. jogada #5 (ajustar chaves para 0100 por 10 periodos de clock
      caso = 8;
      @(negedge clock_in);
      botoes_in = 4'b0100;
      #(10*clockPeriod);

    // Teste 9. jogada #6 (ajustar chaves para 0010 por 10 periodos de clock
      caso = 9;
      @(negedge clock_in);
      botoes_in = 4'b0010;
      #(10*clockPeriod);

    // Teste 10. jogada #7 (ajustar chaves para 0001 por 10 periodos de clock
      caso = 10;
      @(negedge clock_in);
      botoes_in = 4'b0001;
      #(10*clockPeriod);

    // Teste 11. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock
      caso = 11;
      @(negedge clock_in);
      botoes_in = 4'b001;
      #(10*clockPeriod);

    // Teste 12. jogada #9 (ajustar chaves para 0010 por 10 periodos de clock
      caso = 12;
      @(negedge clock_in);
      botoes_in = 4'b0010;
      #(10*clockPeriod);

    // Teste 13. jogada #10 (ajustar chaves para 0010 por 10 periodos de clock
      caso = 13;
      @(negedge clock_in);
      botoes_in = 4'b0010;
      #(10*clockPeriod);

    // Teste 14. jogada #11 (ajustar chaves para 0100 por 10 periodos de clock
      caso = 14;
      @(negedge clock_in);
      botoes_in = 4'b0100;
      #(10*clockPeriod);

    // Teste 15. jogada #12 (ajustar chaves para 0100 por 10 periodos de clock
      caso = 15;
      @(negedge clock_in);
      botoes_in = 4'b0100;
      #(10*clockPeriod);

    // Teste 16. jogada #13(ajustar chaves para 1000 por 10 periodos de clock
      caso = 16;
      @(negedge clock_in);
      botoes_in = 4'b1000;
      #(10*clockPeriod);

    // Teste 17. jogada #14 (ajustar chaves para 1000 por 10 periodos de clock
      caso = 17;
      @(negedge clock_in);
      botoes_in = 4'b1000;
      #(10*clockPeriod);

    // Teste 18. jogada #15 (ajustar chaves para 0001 por 10 periodos de clock
      caso = 18;
      @(negedge clock_in);
      botoes_in = 4'b0001;
      #(10*clockPeriod);

    // Teste 19. jogada #16 (ajustar chaves para 0100 por 10 periodos de clock
      caso = 19;
      @(negedge clock_in);
      botoes_in = 4'b0100;
      #(10*clockPeriod);

      // final dos casos de teste da simulacao
      caso = 99;
      #100;
      $display("Fim da simulacao");
      $stop;
    end

  endmodule
