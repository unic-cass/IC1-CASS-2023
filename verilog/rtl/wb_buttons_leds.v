`default_nettype none
`timescale 1ns/1ns

module cla 
#(
    parameter WIDTH = 32
)
(
    input [WIDTH-1:0] in1,
    input [WIDTH-1:0] in2,
    input carry_in,
    output  [WIDTH-1:0] sum,
    output  carry_out
);

wire [WIDTH-1:0] gen;
wire [WIDTH-1:0] pro;
wire [WIDTH:0] carry_tmp;

genvar j, i;
generate
 assign carry_tmp[0] = carry_in;
 
 for(j = 0; j < WIDTH; j = j + 1) begin: carry_generator
    assign gen[j] = in1[j] & in2[j];
    assign pro[j] = in1[j] | in2[j];
    assign carry_tmp[j+1] = gen[j] | pro[j] & carry_tmp[j];
 end
  
 assign carry_out = carry_tmp[WIDTH];
 
 for(i = 0; i < WIDTH; i = i+1) begin: sum_without_carry
    assign sum[i] = in1[i] ^ in2[i] ^ carry_tmp[i];
 end 
endgenerate 
endmodule

module wb_buttons_leds #(
    parameter   [31:0]  BASE_ADDRESS    = 32'h3000_0000,        // base address
    parameter   [31:0]  SUMA_ADDRESS     = BASE_ADDRESS,
    parameter   [31:0]  SUMB_ADDRESS     = BASE_ADDRESS + 12,
    parameter   [31:0]  BUTTON_ADDRESS  = BASE_ADDRESS + 4,
    parameter   [31:0]  OPCODE_ADDRESS = BASE_ADDRESS + 16,
    parameter   [31:0]  SALIDA_ADDRESS  = BASE_ADDRESS + 8,
    parameter   [31:0]  SALIDA2_ADDRESS  = BASE_ADDRESS + 20
    ) (
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif
    input wire          clk,
    input wire          reset,
    // wb interface
    input wire          i_wb_cyc,       // wishbone transaction
    input wire          i_wb_stb,       // strobe - data valid and accepted as long as !o_wb_stall
    input wire          i_wb_we,        // write enable
    input wire  [31:0]  i_wb_addr,      // address
    input wire  [31:0]  i_wb_data,      // incoming data
    output reg          o_wb_ack,       // request is completed 
    output wire         o_wb_stall,     // cannot accept req
    output reg  [31:0]  o_wb_data,      // output data

    input wire  buttons,
<<<<<<< HEAD
    output wire [7:0] led_enb,
    output reg [3:0] leds
=======
    output wire [11:0] led_enb,
    output reg [11:0] leds
>>>>>>> 469f40a
 
    );

    cla cla_inst(
        .in1(sum_a),
        .in2(sum_b),
        .carry_in(1'b0),
        .sum(sum_cla),
        .carry_out(carry_cla)
    );    
    
    wire [31:0] sum_cla;
    wire carry_cla;
    wire [32:0] s_cla;
    reg [63:0] salida;
    reg [31:0] sum_a;
    reg [31:0] sum_b;
    reg [3:0] op_code;


    assign o_wb_stall = 0;
    assign led_enb = 4'b0;
    assign s_cla = {carry_cla,sum_cla};

    always @(posedge clk) begin
        case (op_code)
            4'b0000: begin
                salida[63:32]= 32'b0; 
                salida[31:0] = ~sum_a;
            end
            4'b0001: begin
                salida[63:32]= 32'b0;
                salida[31:0] = sum_a & sum_b;
            end
            4'b0010: begin
                salida[63:32]= 32'b0;
                salida[31:0] = sum_a;
            end
            4'b0011: begin
                salida[63:32]= 32'b0;
                salida[31:0] = sum_a | sum_b;
            end
            4'b0100: begin
                salida[63:32]= 32'b0;
                salida[31:0] = sum_a-1;
            end
            4'b0101: begin
                salida[63:33]= 31'b0;
                salida[32:0] = sum_a + sum_b;
            end
            4'b0110: begin
                salida[63:32]= 32'b0;
                salida[31:0] = sum_a -sum_b;
            end
            4'b0111: begin
                salida[63:33]= 31'b0;
                salida[32:0] = sum_a + 1;
            end
<<<<<<< HEAD
            // 4'b1000:
            //     salida = sum_a*sum_b;
            // 4'b1001: begin
            //     salida[63:33]= 31'b0;
            //     salida[32:0] = s_cla;
            // end
            // 4'b1010:
            //     salida = {32'b0,sum_a} << sum_b;
            // 4'b1011:
            //     salida = {32'b0,sum_a} >> sum_b;
=======
            4'b1000:
                salida = sum_a*sum_b;
            4'b1001: begin
                salida[63:33]= 31'b0;
                salida[32:0] = s_cla;
            end
            4'b1010:
                salida = {32'b0,sum_a} << sum_b;
            4'b1011:
                salida = {32'b0,sum_a} >> sum_b;
>>>>>>> 469f40a
            default: 
                salida = 'b0;
        endcase
    end

    always @(posedge clk) begin
        if(reset) begin
            sum_a <= 32'b0;
            sum_b <= 32'b0;
        end else if(i_wb_stb && i_wb_cyc && i_wb_we && !o_wb_stall && i_wb_addr == SUMA_ADDRESS) begin
            sum_a <= i_wb_data[31:0];
        end else if(i_wb_stb && i_wb_cyc && i_wb_we && !o_wb_stall && i_wb_addr == SUMB_ADDRESS) begin
            sum_b <= i_wb_data[31:0];
        end else if(i_wb_stb && i_wb_cyc && i_wb_we && !o_wb_stall && i_wb_addr == OPCODE_ADDRESS) begin
            op_code <= i_wb_data[3:0];
        end
        leds[3:0] <= sum_a[3:0];
<<<<<<< HEAD
        // leds[7:4] <= salida[3:0];
        // leds[11:8] <= op_code[3:0];
=======
        leds[7:4] <= salida[3:0];
        leds[11:8] <= op_code[3:0];
>>>>>>> 469f40a
    end

    always @(posedge clk) begin
        if(reset)
            o_wb_data <= 0;
        else if(i_wb_stb && i_wb_cyc && !i_wb_we && !o_wb_stall)
            case(i_wb_addr)
                SALIDA2_ADDRESS: 
                    o_wb_data <= {salida[63:32]};
                SALIDA_ADDRESS: 
                    o_wb_data <= {salida[31:0]};
                BUTTON_ADDRESS: 
                    o_wb_data <= {31'b0, buttons};
                default:
                    o_wb_data <= 32'b0;
            endcase

    end

    always @(posedge clk) begin
        if(reset)
            o_wb_ack <= 0;
        else
            o_wb_ack <= (i_wb_stb && !o_wb_stall && (i_wb_addr == OPCODE_ADDRESS ||  i_wb_addr == SUMA_ADDRESS || 
                                                    i_wb_addr == SUMB_ADDRESS || i_wb_addr == SALIDA_ADDRESS || 
                                                    i_wb_addr == BUTTON_ADDRESS || i_wb_addr == SALIDA2_ADDRESS));
    end

endmodule
