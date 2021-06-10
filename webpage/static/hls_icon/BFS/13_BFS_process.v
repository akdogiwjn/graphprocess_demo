// BFS process.v
`timescale 1ns / 1ps

`include "data_width.vh"

module edge_process #(parameter
    EDGE_PIPE_NUM = `EDGE_PIPE_NUM,
    VERTEX_BRAM_DWIDTH = `VERTEX_BRAM_DWIDTH,
    MASK_WIDTH = `MASK_WIDTH,
    TOT_EDGE_MASK_WIDTH = `TOT_EDGE_MASK_WIDTH, TOT_ACC_ID_WIDTH = `TOT_ACC_ID_WIDTH,
    DST_ID_DWIDTH = `DST_ID_DWIDTH
    ) (
        input clk,
        input rst,
        input [VERTEX_BRAM_DWIDTH * EDGE_PIPE_NUM - 1 : 0] front_src_p,
        input front_src_p_valid,
        input [TOT_EDGE_MASK_WIDTH - 1 : 0] front_src_p_mask,
        input [TOT_ACC_ID_WIDTH - 1 : 0] front_tot_acc_id,
        input [DST_ID_DWIDTH - 1 : 0] front_dst_id_1,
        input [DST_ID_DWIDTH - 1 : 0] front_dst_id_2,
        input [DST_ID_DWIDTH - 1 : 0] front_dst_id_3,
        input [DST_ID_DWIDTH - 1 : 0] front_dst_id_4,
        input [MASK_WIDTH - 1 : 0] front_src_p_mask_r_1,
        input [MASK_WIDTH - 1 : 0] front_src_p_mask_r_2,
        input [MASK_WIDTH - 1 : 0] front_src_p_mask_r_3,
        input [MASK_WIDTH - 1 : 0] front_src_p_mask_r_4,
        input front_dst_data_valid_1,
        input front_dst_data_valid_2,
        input front_dst_data_valid_3,
        input front_dst_data_valid_4,

        output [VERTEX_BRAM_DWIDTH * EDGE_PIPE_NUM - 1 : 0] src_p,
        output [TOT_ACC_ID_WIDTH - 1 : 0] tot_acc_id,
        output src_p_valid,
        output [DST_ID_DWIDTH - 1 : 0] dst_id_1,
        output [DST_ID_DWIDTH - 1 : 0] dst_id_2,
        output [DST_ID_DWIDTH - 1 : 0] dst_id_3,
        output [DST_ID_DWIDTH - 1 : 0] dst_id_4,
        output [MASK_WIDTH - 1 : 0] src_p_mask_r_1,
        output [MASK_WIDTH - 1 : 0] src_p_mask_r_2,
        output [MASK_WIDTH - 1 : 0] src_p_mask_r_3,
        output [MASK_WIDTH - 1 : 0] src_p_mask_r_4,
        output dst_data_valid_1,
        output dst_data_valid_2,
        output dst_data_valid_3,
        output dst_data_valid_4);

    edge_process_edge E1 (
        .clk(clk), .rst(rst),
        .front_src_p(front_src_p), .front_src_p_mask(front_src_p_mask), .front_tot_acc_id(front_tot_acc_id), .front_src_p_valid(front_src_p_valid),

        .src_p(src_p), .tot_acc_id(tot_acc_id), .src_p_valid(src_p_valid));

    edge_process_vertex_single V1 (
        .clk(clk), .rst(rst),
        .front_dst_id(front_dst_id_1), .front_src_p_mask_r(front_src_p_mask_r_1), .front_dst_data_valid(front_dst_data_valid_1),

        .dst_id(dst_id_1), .src_p_mask_r(src_p_mask_r_1), .dst_data_valid(dst_data_valid_1));

    edge_process_vertex_single V2 (
        .clk(clk), .rst(rst),
        .front_dst_id(front_dst_id_2), .front_src_p_mask_r(front_src_p_mask_r_2), .front_dst_data_valid(front_dst_data_valid_2),

        .dst_id(dst_id_2), .src_p_mask_r(src_p_mask_r_2), .dst_data_valid(dst_data_valid_2));

    edge_process_vertex_single V3 (
        .clk(clk), .rst(rst),
        .front_dst_id(front_dst_id_3), .front_src_p_mask_r(front_src_p_mask_r_3), .front_dst_data_valid(front_dst_data_valid_3),

        .dst_id(dst_id_3), .src_p_mask_r(src_p_mask_r_3), .dst_data_valid(dst_data_valid_3));

    edge_process_vertex_single V4 (
        .clk(clk), .rst(rst),
        .front_dst_id(front_dst_id_4), .front_src_p_mask_r(front_src_p_mask_r_4), .front_dst_data_valid(front_dst_data_valid_4),

        .dst_id(dst_id_4), .src_p_mask_r(src_p_mask_r_4), .dst_data_valid(dst_data_valid_4));

endmodule

module edge_process_edge #(parameter
    EDGE_PIPE_NUM = `EDGE_PIPE_NUM,
    VERTEX_BRAM_DWIDTH = `VERTEX_BRAM_DWIDTH,
    TOT_EDGE_MASK_WIDTH = `TOT_EDGE_MASK_WIDTH, TOT_ACC_ID_WIDTH = `TOT_ACC_ID_WIDTH,
    MAX_SRC_P = `MAX_SRC_P
    ) (
        input clk,
        input rst,
        input [VERTEX_BRAM_DWIDTH * EDGE_PIPE_NUM - 1 : 0] front_src_p,
        input [TOT_EDGE_MASK_WIDTH - 1 : 0] front_src_p_mask,
        input [TOT_ACC_ID_WIDTH - 1 : 0] front_tot_acc_id,
        input front_src_p_valid,

        output reg [VERTEX_BRAM_DWIDTH * EDGE_PIPE_NUM - 1 : 0] src_p,
        output reg [TOT_ACC_ID_WIDTH - 1 : 0] tot_acc_id,
        output reg src_p_valid);

    generate
        genvar i;
        for (i = 0; i < EDGE_PIPE_NUM; i = i + 1) begin : M13_BLOCK
            always @ (posedge clk) begin
                if (rst) begin
                    src_p[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH] <= 0;
                end
                else begin
                    if (front_src_p_valid) begin
                        if (front_src_p_mask[i] && front_src_p[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH] != MAX_SRC_P) begin
                            src_p[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH] <= front_src_p[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH] + 1;
                        end
                        else begin
                            src_p[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH] <= MAX_SRC_P;
                        end
                    end
                end
            end
        end
    endgenerate

    always @ (posedge clk) begin
        if (rst) begin
            tot_acc_id <= {TOT_ACC_ID_WIDTH{1'b1}};
            src_p_valid <= 1'b0;
        end
        else begin
            if (front_src_p_valid) begin
                tot_acc_id <= front_tot_acc_id;
                src_p_valid <= 1'b1;
            end
            else begin
                tot_acc_id <= {TOT_ACC_ID_WIDTH{1'b1}};
                src_p_valid <= 1'b0;
            end
        end
    end

endmodule

module edge_process_vertex_single #(parameter
    DST_ID_DWIDTH = `DST_ID_DWIDTH, MASK_WIDTH = `MASK_WIDTH
    ) (
        input clk,
        input rst,
        input [DST_ID_DWIDTH - 1 : 0] front_dst_id,
        input [MASK_WIDTH - 1 : 0] front_src_p_mask_r,
        input front_dst_data_valid,

        output reg [DST_ID_DWIDTH - 1 : 0] dst_id,
        output reg [MASK_WIDTH - 1 : 0] src_p_mask_r,
        output reg dst_data_valid);

    always @ (posedge clk) begin
        if (rst) begin
            dst_id <= 0;
            src_p_mask_r <= 0;
            dst_data_valid <= 0;
        end
        else begin
            if (front_dst_data_valid) begin
                dst_id <= front_dst_id;
                src_p_mask_r <= front_src_p_mask_r;
                dst_data_valid <= front_dst_data_valid;
            end
            else begin
                dst_id <= 0;
                src_p_mask_r <= 0;
                dst_data_valid <= 1'b0;
            end
        end
    end

endmodule