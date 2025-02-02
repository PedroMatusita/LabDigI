`timescale 1ns/1ns

module circuito_exp5_tb_cen1;

    // Sinais para conectar com o DUT
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        iniciar_in = 0;
    reg  [3:0] chaves_in  = 4'b0000;

    wire       acertou_out;
    wire       errou_out;
    wire       pronto_out;
    wire [3:0] leds_out;

    wire       db_igual_out;
    wire [6:0] db_contagem_out;
    wire [6:0] db_memoria_out;
    wire [6:0] db_estado_out;
    wire [6:0] db_jogadafeita_out;
    wire       db_clock_out;
    wire       db_timeout;
    wire       db_iniciar_out;
    wire       db_tem_jogada_out;

    // Configuração do clock
    parameter clockPeriod = 1_000_000; // 1 ms, f = 1kHz

    // Identificação do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // Instanciação do DUT (Device Under Test)
    circuito_exp4_desafio dut (
        .clock          ( clock_in    ),
        .reset          ( reset_in    ),
        .iniciar        ( iniciar_in  ),
        .chaves         ( chaves_in   ),
        .acertou        ( acertou_out ),
        .errou          ( errou_out   ),
        .pronto         ( pronto_out  ),
        .leds           ( leds_out    ),
        .db_igual       ( db_igual_out       ),
        .db_timeout     ( db_timeout),
        .db_contagem    ( db_contagem_out    ),
        .db_memoria     ( db_memoria_out     ),
        .db_estado      ( db_estado_out      ),
        .db_jogadafeita ( db_jogadafeita_out ),
        .db_clock       ( db_clock_out       ),
        .db_iniciar     ( db_iniciar_out     ),
        .db_tem_jogada  ( db_tem_jogada_out  )
    );

    // Vetor de testes
    reg [3:0] test_vector [0:15];
    integer i, j;

    // Procedimento de teste
    initial begin
        $display("Início da simulação");

        // Inicializar vetor de testes
        test_vector[0]  = 4'b0001;
        test_vector[1]  = 4'b0010;
        test_vector[2]  = 4'b0100;
        test_vector[3]  = 4'b1000;
        test_vector[4]  = 4'b0100;
        test_vector[5]  = 4'b0010;
        test_vector[6]  = 4'b0001;
        test_vector[7]  = 4'b0001;
        test_vector[8]  = 4'b0010;
        test_vector[9]  = 4'b0010;
        test_vector[10] = 4'b0100;
        test_vector[11] = 4'b0100;
        test_vector[12] = 4'b1000;
        test_vector[13] = 4'b1000;
        test_vector[14] = 4'b0001;
        test_vector[15] = 4'b0100;

        // condicoes iniciais
        caso       = 0;
        clock_in   = 1;
        reset_in   = 0;
        iniciar_in = 0;
        chaves_in  = 4'b0000;
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
        iniciar_in = 1;
        #(5*clockPeriod);
        iniciar_in = 0;
        // espera
        #(10*clockPeriod);

        // Testes 4 a 19: jogadas com diferentes valores de chaves
        for (i = 0; i < 16; i = i + 1) begin
            caso = 4 + i; // Mudar caso de teste
            for (j = 0; j <= i; j = j + 1) begin
                @(negedge clock_in);
                chaves_in = test_vector[j];
                #(10*clockPeriod);
                chaves_in = 4'b0000; // Reset chaves_in
                // espera entre jogadas
                #(10*clockPeriod);
            end
        end

        // final dos casos de teste da simulacao
        caso = 99;
        #100;
        $display("Fim da simulacao");
        $stop;
    end

endmodule
