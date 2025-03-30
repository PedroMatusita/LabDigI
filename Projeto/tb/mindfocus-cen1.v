`timescale 1ns / 1ns

module tb_jogo_mindfocus;
    reg clock = 1;
    reg reset = 0 ;
    reg iniciar = 0;
    reg voltar = 0;
    reg [3:0] botoes = 4'b0000;
    wire pronto;
    wire [3:0] acertos;
    wire db_igual, db_clock, db_igualjogada, db_tem_jogada;
    wire [6:0]  db_estado, db_acertos, db_indice0, db_indice1, db_indice2, db_indice3;

    // Gera clock
    parameter clockPeriod = 1_000_000;

    reg[31:0] caso = 0;

    always #((clockPeriod/2)) clock = ~clock;

    // Instancia o módulo
    jogo_mindfocus uut (
        .clock(clock), .reset(reset), .iniciar(iniciar), .voltar(voltar), .botoes(botoes),
        .pronto(pronto), .acertos(acertos),
        .db_igual(db_igual), .db_clock(db_clock), 
        .db_igualjogada(db_igualjogada), .db_tem_jogada(db_tem_jogada),
        .db_estado(db_estado),
        .db_acertos(db_acertos),
        .db_indice0(db_indice0), .db_indice1(db_indice1), .db_indice2(db_indice2), .db_indice3(db_indice3)
    );


    initial begin
        $display("inicio da simulação");
        
        // Inicializa sinais
        caso = 0;
        clock = 1;
        reset = 0;
        iniciar = 0;
        voltar = 0;
        botoes = 4'b0000;
        #clockPeriod;

        caso = 1;
        @(negedge clock);
        reset = 1;
        #(clockPeriod);
        reset = 0;
        //espera
        #(clockPeriod);
        
        caso = 2;
        iniciar = 1;
        #(clockPeriod);
        iniciar = 0;
        #(5000 * clockPeriod); // Espera 5.007 segundos antes da jogada
        #(5000 * clockPeriod); 
        #(5000 * clockPeriod); 
        #(5000 * clockPeriod); 
        #(7000 * clockPeriod); 

        //espera

        caso = 3;
        @(negedge clock);
        #(100 * clockPeriod); 
        botoes = 4'b1000;
        #(10000 * clockPeriod); // Mantém o botão pressionado
        botoes = 4'b0000;
        #(clockPeriod);


        caso = 4;
        @(negedge clock);
        #(7000 * clockPeriod); 
        #(7000 * clockPeriod); 
        botoes = 4'b1000;
        #(10000 * clockPeriod); // Mantém o botão pressionado
        botoes = 4'b0000;
        #(clockPeriod);

        caso = 5;
        @(negedge clock);
        #(7000 * clockPeriod); 
        #(7000 * clockPeriod); 
        botoes = 4'b1000;
        #(10000 * clockPeriod); // Mantém o botão pressionado
        botoes = 4'b0000;
        #(clockPeriod);

        caso = 99; 
        #100;
        $display("fim da simulação");
        $stop;
    end
endmodule

