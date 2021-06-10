//PR process.v
`timescale 1ns / 1ps

`include "data_width.vh"

module edge_process #(parameter
    EDGE_PIPE_NUM = `EDGE_PIPE_NUM,
    VERTEX_BRAM_DWIDTH = `VERTEX_BRAM_DWIDTH,
    MASK_WIDTH = `MASK_WIDTH,
    TOT_EDGE_MASK_WIDTH = `TOT_EDGE_MASK_WIDTH, TOT_ACC_ID_WIDTH = `TOT_ACC_ID_WIDTH,
    DST_ID_DWIDTH = `DST_ID_DWIDTH, VERTEX_BRAM_DEGREE_DWIDTH = `VERTEX_BRAM_DEGREE_DWIDTH,
    FLOAT_DIV_DELAY = `FLOAT_DIV_DELAY
    ) (
        input clk,
        input rst,
        input [VERTEX_BRAM_DWIDTH * EDGE_PIPE_NUM - 1 : 0] front_src_p,
        input [VERTEX_BRAM_DEGREE_DWIDTH * EDGE_PIPE_NUM - 1 : 0] front_degree,
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

    wire [TOT_ACC_ID_WIDTH - 1 : 0] acc_id_buffer[0 : FLOAT_DIV_DELAY];
    wire src_p_valid_buffer[0 : FLOAT_DIV_DELAY];
    wire [DST_ID_DWIDTH - 1 : 0] dst_id_1_buffer[0 : FLOAT_DIV_DELAY];
    wire [DST_ID_DWIDTH - 1 : 0] dst_id_2_buffer[0 : FLOAT_DIV_DELAY];
    wire [DST_ID_DWIDTH - 1 : 0] dst_id_3_buffer[0 : FLOAT_DIV_DELAY];
    wire [DST_ID_DWIDTH - 1 : 0] dst_id_4_buffer[0 : FLOAT_DIV_DELAY];
    wire [MASK_WIDTH - 1 : 0] src_p_mask_r_1_buffer[0 : FLOAT_DIV_DELAY];
    wire [MASK_WIDTH - 1 : 0] src_p_mask_r_2_buffer[0 : FLOAT_DIV_DELAY];
    wire [MASK_WIDTH - 1 : 0] src_p_mask_r_3_buffer[0 : FLOAT_DIV_DELAY];
    wire [MASK_WIDTH - 1 : 0] src_p_mask_r_4_buffer[0 : FLOAT_DIV_DELAY];
    wire dst_data_valid_1_buffer[0 : FLOAT_DIV_DELAY];
    wire dst_data_valid_2_buffer[0 : FLOAT_DIV_DELAY];
    wire dst_data_valid_3_buffer[0 : FLOAT_DIV_DELAY];
    wire dst_data_valid_4_buffer[0 : FLOAT_DIV_DELAY];

    assign acc_id_buffer[0] = front_tot_acc_id;
    assign src_p_valid_buffer[0] = front_src_p_valid;
    assign dst_id_1_buffer[0] = front_dst_id_1;
    assign dst_id_2_buffer[0] = front_dst_id_2;
    assign dst_id_3_buffer[0] = front_dst_id_3;
    assign dst_id_4_buffer[0] = front_dst_id_4;
    assign src_p_mask_r_1_buffer[0] = front_src_p_mask_r_1;
    assign src_p_mask_r_2_buffer[0] = front_src_p_mask_r_2;
    assign src_p_mask_r_3_buffer[0] = front_src_p_mask_r_3;
    assign src_p_mask_r_4_buffer[0] = front_src_p_mask_r_4;
    assign dst_data_valid_1_buffer[0] = front_dst_data_valid_1;
    assign dst_data_valid_2_buffer[0] = front_dst_data_valid_2;
    assign dst_data_valid_3_buffer[0] = front_dst_data_valid_3;
    assign dst_data_valid_4_buffer[0] = front_dst_data_valid_4;

    assign tot_acc_id = acc_id_buffer[FLOAT_DIV_DELAY];
    assign src_p_valid = src_p_valid_buffer[FLOAT_DIV_DELAY];
    assign dst_id_1 = dst_id_1_buffer[FLOAT_DIV_DELAY];
    assign dst_id_2 = dst_id_2_buffer[FLOAT_DIV_DELAY];
    assign dst_id_3 = dst_id_3_buffer[FLOAT_DIV_DELAY];
    assign dst_id_4 = dst_id_4_buffer[FLOAT_DIV_DELAY];
    assign src_p_mask_r_1 = src_p_mask_r_1_buffer[FLOAT_DIV_DELAY];
    assign src_p_mask_r_2 = src_p_mask_r_2_buffer[FLOAT_DIV_DELAY];
    assign src_p_mask_r_3 = src_p_mask_r_3_buffer[FLOAT_DIV_DELAY];
    assign src_p_mask_r_4 = src_p_mask_r_4_buffer[FLOAT_DIV_DELAY];
    assign dst_data_valid_1 = dst_data_valid_1_buffer[FLOAT_DIV_DELAY];
    assign dst_data_valid_2 = dst_data_valid_2_buffer[FLOAT_DIV_DELAY];
    assign dst_data_valid_3 = dst_data_valid_3_buffer[FLOAT_DIV_DELAY];
    assign dst_data_valid_4 = dst_data_valid_4_buffer[FLOAT_DIV_DELAY];


    edge_process_edge_lateny E1 (
        .clk(clk), .rst(rst),
        .front_src_p(front_src_p), .front_degree(front_degree),.front_src_p_mask(front_src_p_mask),

        .src_p(src_p));

    generate
        genvar i;
        for(i = 0;i<FLOAT_DIV_DELAY;i = i + 1)begin:BLOCK_M13
            edge_process_acc_id_latency A1 (
                .clk(clk),.rst(rst),
                .front_tot_acc_id(acc_id_buffer[i]),.front_src_p_valid(src_p_valid_buffer[i]),

                .tot_acc_id(acc_id_buffer[i + 1]), .src_p_valid(src_p_valid_buffer[i + 1]));

            edge_process_vertex_single_lateny V1 (
                .clk(clk), .rst(rst),
                .front_dst_id(dst_id_1_buffer[i]), .front_src_p_mask_r(src_p_mask_r_1_buffer[i]), .front_dst_data_valid(dst_data_valid_1_buffer[i]),

                .dst_id(dst_id_1_buffer[i + 1]), .src_p_mask_r(src_p_mask_r_1_buffer[i + 1]), .dst_data_valid(dst_data_valid_1_buffer[i + 1]));

            edge_process_vertex_single_lateny V2 (
                .clk(clk), .rst(rst),
                .front_dst_id(dst_id_2_buffer[i]), .front_src_p_mask_r(src_p_mask_r_2_buffer[i]), .front_dst_data_valid(dst_data_valid_2_buffer[i]),

                .dst_id(dst_id_2_buffer[i + 1]), .src_p_mask_r(src_p_mask_r_2_buffer[i + 1]), .dst_data_valid(dst_data_valid_2_buffer[i + 1]));

            edge_process_vertex_single_lateny V3 (
                .clk(clk), .rst(rst),
                .front_dst_id(dst_id_3_buffer[i]), .front_src_p_mask_r(src_p_mask_r_3_buffer[i]), .front_dst_data_valid(dst_data_valid_3_buffer[i]),

                .dst_id(dst_id_3_buffer[i + 1]), .src_p_mask_r(src_p_mask_r_3_buffer[i + 1]), .dst_data_valid(dst_data_valid_3_buffer[i + 1]));

            edge_process_vertex_single_lateny V4 (
                .clk(clk), .rst(rst),
                .front_dst_id(dst_id_4_buffer[i]), .front_src_p_mask_r(src_p_mask_r_4_buffer[i]), .front_dst_data_valid(dst_data_valid_4_buffer[i]),

                .dst_id(dst_id_4_buffer[i + 1]), .src_p_mask_r(src_p_mask_r_4_buffer[i + 1]), .dst_data_valid(dst_data_valid_4_buffer[i + 1]));
        end
    endgenerate
endmodule


//假设浮点运算为1个时钟周期
module edge_process_edge_lateny #(parameter
    EDGE_PIPE_NUM = `EDGE_PIPE_NUM,
    VERTEX_BRAM_DWIDTH = `VERTEX_BRAM_DWIDTH,
    TOT_EDGE_MASK_WIDTH = `TOT_EDGE_MASK_WIDTH, TOT_ACC_ID_WIDTH = `TOT_ACC_ID_WIDTH,
    //MAX_SRC_P = `MAX_SRC_P, 
    VERTEX_BRAM_DEGREE_DWIDTH = `VERTEX_BRAM_DEGREE_DWIDTH
    ) (
        input clk,
        input rst,
        input [VERTEX_BRAM_DWIDTH * EDGE_PIPE_NUM - 1 : 0] front_src_p,
        input [VERTEX_BRAM_DEGREE_DWIDTH * EDGE_PIPE_NUM - 1 : 0] front_degree,
        input [TOT_EDGE_MASK_WIDTH - 1 : 0] front_src_p_mask,


        output [VERTEX_BRAM_DWIDTH * EDGE_PIPE_NUM - 1 : 0] src_p);

    generate
        genvar i;
        for( i = 0; i< EDGE_PIPE_NUM; i = i + 1)begin:BLOCK_DIV
            float_div FD1(
                .aclk(clk),.aresetn(!rst),
                .s_axis_a_tdata(front_src_p[VERTEX_BRAM_DWIDTH * (i + 1) - 1 : VERTEX_BRAM_DWIDTH * i]),.s_axis_a_tvalid(front_src_p_mask[i]),
                .s_axis_b_tdata(front_degree[VERTEX_BRAM_DEGREE_DWIDTH * (i + 1) - 1 : VERTEX_BRAM_DEGREE_DWIDTH * i]),.s_axis_b_tvalid(front_src_p_mask[i]),
                .m_axis_result_tdata(src_p[VERTEX_BRAM_DWIDTH * (i + 1) - 1 : VERTEX_BRAM_DWIDTH * i]));
        end
    endgenerate
endmodule

module edge_process_vertex_single_lateny #(parameter
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

module edge_process_acc_id_latency #(
    TOT_ACC_ID_WIDTH = `TOT_ACC_ID_WIDTH
    )(
    input clk,
    input rst,
    input [TOT_ACC_ID_WIDTH - 1 : 0] front_tot_acc_id,
    input front_src_p_valid,

    output reg [TOT_ACC_ID_WIDTH - 1 : 0] tot_acc_id,
    output reg src_p_valid);

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