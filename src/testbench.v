`timescale 10ns/1ns
`include "alu.v"

module tb_alu();

    // Inputs
    reg [2:0] op;
    reg use_c;
    reg cin;
    reg [7:0] A;
    reg [7:0] B;

    // Outputs
    wire [7:0] out;
    wire [4:0] flags;

    alu uut (
        .op(op),
        .use_c(use_c),
        .cin(cin),
        .A(A),
        .B(B),
        .out(out),
        .flags(flags)
    );

    initial begin
        // Initialize inputs
        op = 3'b0;
        use_c = 1'b0;
        cin = 1'b0;
        A = 8'd0;
        B = 8'd0;

        // Wait for global reset / stabilization
        #20;

        // Test 1: Addition (OP_ADD = 3'b000)
        // 15 + 10 = 25
        $display("--- Testing OP_ADD ---");
        op = 3'b000;
        A = 8'hAA;
        B = 8'd01;
        #20;

        // Test 2: Subtraction (OP_SUB = 3'b001)
        // 30 - 10 = 20
        $display("--- Testing OP_SUB ---");
        // Toggle op to ensure enableAdder transitions low-to-high for the edge-triggered adder
        op = 3'b111; 
        #20;
        op = 3'b001;
        A = 8'h30;
        B = 8'h10;
        #20;

        $display("--- Testing OP_LSHIFT ---");

        op = 3'b011;
        use_c = 1'b1;
        cin = 1'b1;
        A = 8'b00110000;
        B = 8'h00;
        #20;

        $display("--- Testing OP_RSHIFT ---");

        op = 3'b100;
        use_c = 1'b0;
        cin = 1'b0;
        A = 8'b00110001;
        B = 8'h00;
        #20;


        $display("--- Testing OP_AND ---");

        op = 3'b101;
        A = 8'b00110001;
        B = 8'b00110000;
        #20;


        $display("--- Testing OP_OR ---");

        op = 3'b110;
        A = 8'b00110001;
        B = 8'b01001001;
        #20;

        // End simulation
        $display("--- Simulation Finished ---");
        $finish;
    end

    // Monitor continuous changes in signals
    initial begin
        $monitor("Time = %0t | op = %b | A = %h | B = %h | out = %b | flags = %b", 
                 $time, op, A, B, out, flags);
    end

endmodule