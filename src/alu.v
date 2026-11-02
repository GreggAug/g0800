`timescale 10ns/1ns
module alu(
    input wire [2:0] op,
    input wire use_c,
    input wire cin,
    input wire [7:0] A,
    input wire [7:0] B,
    output reg [7:0] out,
    output reg [4:0] flags  // Carry, Parity, Auxiliary Carry, Zero, Sign
);
    reg c; // Internal Carry
    reg [7:0] adderB;
    reg [7:0] complimentIn;

    localparam OP_ADD = 3'b000;
    localparam OP_SUB = 3'b001;
    localparam OP_MUL = 3'b010;
    localparam OP_LSHIFT = 3'b011;
    localparam OP_RSHIFT = 3'b100;
    localparam OP_AND = 3'b101;
    localparam OP_OR = 3'b110;
    localparam OP_COMP = 3'b111;

    wire [7:0] adder_out;
    wire [4:0] adder_flags;
    adder adder_unit (use_c & cin, A, adderB, adder_out, adder_flags);

    wire [7:0] compliment_out;
    compliment compliment_unit(complimentIn, compliment_out);
    

    always @(*) begin
        c = use_c & cin;
        out = 8'b00000000;
        flags = 5'b00000;

        case (op)
            OP_ADD: begin
                adderB = B;
                out = adder_out;
                flags = adder_flags;
            end
            OP_SUB: begin
                complimentIn = B;
                adderB = compliment_out + 1;
                out = adder_out;
                flags = adder_flags;
            end
            OP_LSHIFT: begin
                flags[0] = A[7];
                if (use_c) begin
                    out = (A << 1) + cin;
                end
                else begin
                    out = (A << 1) + A[7];
                end
            end
            OP_RSHIFT: begin
                flags[0] = A[0];
                if (use_c == 0) begin
                    out = {A[0], (A[6:0] >> 1)};
                end
                else begin
                    out = {cin, (A[6:0] >> 1)};
                end
            end
            OP_AND: begin
                out = A & B;
                flags[4] = out[7];
                flags[3] = out == 8'h00;
            end
            OP_OR: begin
                out = A | B;
                flags[4] = out[7];
                flags[3] = out == 8'h00;
            end
            OP_COMP: begin
                complimentIn = A;
                out = compliment_out;
                flags[3] = compliment_out == (8'h00);
                flags[4] = out [7];
            end
        endcase
    end

endmodule



module adder(
    input wire cin,
    input wire [7:0] A,
    input wire [7:0] B,
    output reg [7:0] out,
    output reg [4:0] flags 
);
    reg[8:0] add_result;
    always @(*) begin
        add_result = A + B + cin;
        out = add_result[7:0];
        flags[0] = add_result[8];
        flags[3] = (add_result == 8'b00000000);
        flags[4] = (add_result[7]);
    end
endmodule


module compliment(
    input wire [7:0] in,
    output reg [7:0] out
);
    always @(*) begin
        out = ~in;
    end
endmodule