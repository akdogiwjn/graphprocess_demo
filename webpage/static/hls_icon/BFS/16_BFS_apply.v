// BFS apply.v
`timescale 1ns / 1ps

`include "data_width.vh"

module sequential_accumulator #(parameter
    DST_ID_DWIDTH = `DST_ID_DWIDTH,
    VERTEX_BRAM_AWIDTH = `VERTEX_BRAM_AWIDTH, VERTEX_BRAM_DWIDTH = `VERTEX_BRAM_DWIDTH,
    WB_VALID_WIDTH = `WB_VALID_WIDTH
    ) (
        input                           clk,
        input                           rst,
        input [DST_ID_DWIDTH - 1 : 0]   front_dst_id_1,
        input [DST_ID_DWIDTH - 1 : 0]   front_dst_id_2,
        input [DST_ID_DWIDTH - 1 : 0]   front_dst_id_3,
        input [DST_ID_DWIDTH - 1 : 0]   front_dst_id_4,
        input [VERTEX_BRAM_DWIDTH - 1 : 0]  front_src_1,
        input [VERTEX_BRAM_DWIDTH - 1 : 0]  front_src_2,
        input [VERTEX_BRAM_DWIDTH - 1 : 0]  front_src_3,
        input [VERTEX_BRAM_DWIDTH - 1 : 0]  front_src_4,
        input                           front_dst_data_valid_1,
        input                           front_dst_data_valid_2,
        input                           front_dst_data_valid_3,
        input                           front_dst_data_valid_4,

        output [DST_ID_DWIDTH - 1 : 0]     wb_dst_addr_1,
        output [DST_ID_DWIDTH - 1 : 0]     wb_dst_addr_2,
        output [DST_ID_DWIDTH - 1 : 0]     wb_dst_addr_3,
        output [DST_ID_DWIDTH - 1 : 0]     wb_dst_addr_4,
        output [VERTEX_BRAM_DWIDTH - 1 : 0] wb_dst_data_1,
        output [VERTEX_BRAM_DWIDTH - 1 : 0] wb_dst_data_2,
        output [VERTEX_BRAM_DWIDTH - 1 : 0] wb_dst_data_3,
        output [VERTEX_BRAM_DWIDTH - 1 : 0] wb_dst_data_4,
        output [WB_VALID_WIDTH - 1 : 0]  wb_dst_data_valid_1,
        output [WB_VALID_WIDTH - 1 : 0]  wb_dst_data_valid_2,
        output [WB_VALID_WIDTH - 1 : 0]  wb_dst_data_valid_3,
        output [WB_VALID_WIDTH - 1 : 0]  wb_dst_data_valid_4);

    sequential_accumulator_pipeline P0
        (.clk(clk), .rst(rst),
         .front_dst_id(front_dst_id_1), .front_src(front_src_1), .front_dst_data_valid(front_dst_data_valid_1),
         
         .wb_dst_addr(wb_dst_addr_1), .wb_dst_data(wb_dst_data_1), .wb_dst_data_valid(wb_dst_data_valid_1));

    sequential_accumulator_pipeline P1
        (.clk(clk), .rst(rst),
         .front_dst_id(front_dst_id_2), .front_src(front_src_2), .front_dst_data_valid(front_dst_data_valid_2),
         
         .wb_dst_addr(wb_dst_addr_2), .wb_dst_data(wb_dst_data_2), .wb_dst_data_valid(wb_dst_data_valid_2));

    sequential_accumulator_pipeline P2
        (.clk(clk), .rst(rst),
         .front_dst_id(front_dst_id_3), .front_src(front_src_3), .front_dst_data_valid(front_dst_data_valid_3),
         
         .wb_dst_addr(wb_dst_addr_3), .wb_dst_data(wb_dst_data_3), .wb_dst_data_valid(wb_dst_data_valid_3));

    sequential_accumulator_pipeline P3
        (.clk(clk), .rst(rst),
         .front_dst_id(front_dst_id_4), .front_src(front_src_4), .front_dst_data_valid(front_dst_data_valid_4),
         
         .wb_dst_addr(wb_dst_addr_4), .wb_dst_data(wb_dst_data_4), .wb_dst_data_valid(wb_dst_data_valid_4));

endmodule

module sequential_accumulator_pipeline # (
    WB_VALID_WIDTH = `WB_VALID_WIDTH,
    VERTEX_BRAM_NUM_WIDTH = `VERTEX_BRAM_NUM_WIDTH,
    VERTEX_BRAM_AWIDTH = `VERTEX_BRAM_AWIDTH, VERTEX_BRAM_DWIDTH = `VERTEX_BRAM_DWIDTH,
    DST_ID_DWIDTH = `DST_ID_DWIDTH
    ) (
    input clk,
    input rst,
    input [DST_ID_DWIDTH - 1 : 0] front_dst_id,
    input [VERTEX_BRAM_DWIDTH - 1 : 0] front_src,
    input front_dst_data_valid,

    output reg [DST_ID_DWIDTH - 1 : 0] wb_dst_addr, 
    output reg [VERTEX_BRAM_DWIDTH - 1 : 0] wb_dst_data,
    output reg [WB_VALID_WIDTH - 1 : 0] wb_dst_data_valid);

    reg [DST_ID_DWIDTH - 1 : 0] now_dst_addr;
    reg [VERTEX_BRAM_DWIDTH - 1 : 0] now_dst_data;

    always @ (posedge clk) begin
        if (rst == 1'b1) begin
            wb_dst_addr <= 0;
            wb_dst_data <= 0;
        end
        else begin
            if (front_dst_data_valid == 1'b1) begin
                if (now_dst_addr != 0 && now_dst_addr != front_dst_id) begin
                    wb_dst_addr <= now_dst_addr;
                    wb_dst_data <= now_dst_data;
                end
                else begin
                    wb_dst_addr <= 0;
                    wb_dst_data <= 0;
                end
            end
            else begin
                wb_dst_addr <= 0;
                wb_dst_data <= 0;
            end
        end
    end

    generate
        genvar i;
        for (i = 0; i < WB_VALID_WIDTH; i = i + 1) begin: M16_BLOCK_1
            always @ (posedge clk) begin
                if (rst) begin
                    wb_dst_data_valid[i] <= 1'b0;
                end
                else begin
                    if (front_dst_data_valid) begin
                        if (now_dst_addr != 0 && now_dst_addr != front_dst_id) begin
                            wb_dst_data_valid[i] <= (now_dst_addr[VERTEX_BRAM_NUM_WIDTH - 1 : 2] == i);
                        end
                        else begin
                            wb_dst_data_valid[i] <= 1'b0;
                        end
                    end
                    else begin
                        wb_dst_data_valid[i] <= 1'b0;
                    end
                end
            end
        end
    endgenerate

    always @ (posedge clk) begin
        if (rst == 1'b1) begin
            now_dst_addr <= 0;
            now_dst_data <= 0;
        end
        else begin
            if (front_dst_data_valid == 1'b1) begin
                if (now_dst_addr != front_dst_id || now_dst_data > front_src) begin
                    now_dst_addr <= front_dst_id;
                    now_dst_data <= front_src;
                end
            end
        end
    end

endmodule
