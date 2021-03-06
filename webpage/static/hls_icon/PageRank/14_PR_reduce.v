//PR reduce.v
`timescale 1ns / 1ps

`include "data_width.vh"

module parallel_accumulator #(parameter
    VERTEX_BRAM_DWIDTH = `VERTEX_BRAM_DWIDTH,
    EDGE_PIPE_NUM = `EDGE_PIPE_NUM,
    TOT_ACC_ID_WIDTH = `TOT_ACC_ID_WIDTH,
    DST_ID_DWIDTH = `DST_ID_DWIDTH, MASK_WIDTH = `MASK_WIDTH,
    FLOAT_ADD_DELAY = `FLOAT_ADD_DELAY
    ) (
        input                               clk,
        input                               rst,
        input [VERTEX_BRAM_DWIDTH * EDGE_PIPE_NUM - 1 : 0]          front_src,
        input [TOT_ACC_ID_WIDTH - 1 : 0]    front_acc_id,
        input                               front_src_valid,
        input [DST_ID_DWIDTH - 1 : 0]       front_dst_id_1,
        input [DST_ID_DWIDTH - 1 : 0]       front_dst_id_2,
        input [DST_ID_DWIDTH - 1 : 0]       front_dst_id_3,
        input [DST_ID_DWIDTH - 1 : 0]       front_dst_id_4,
        input [MASK_WIDTH - 1 : 0]          front_src_mask_1,
        input [MASK_WIDTH - 1 : 0]          front_src_mask_2,
        input [MASK_WIDTH - 1 : 0]          front_src_mask_3,
        input [MASK_WIDTH - 1 : 0]          front_src_mask_4,
        input                               front_dst_data_valid_1,
        input                               front_dst_data_valid_2,
        input                               front_dst_data_valid_3,
        input                               front_dst_data_valid_4,

        output [VERTEX_BRAM_DWIDTH * EDGE_PIPE_NUM - 1 : 0]         src,
        output                              src_valid,
        output [DST_ID_DWIDTH - 1 : 0]      dst_id_1,
        output [DST_ID_DWIDTH - 1 : 0]      dst_id_2,
        output [DST_ID_DWIDTH - 1 : 0]      dst_id_3,
        output [DST_ID_DWIDTH - 1 : 0]      dst_id_4,
        output [MASK_WIDTH - 1 : 0]         src_mask_1,
        output [MASK_WIDTH - 1 : 0]         src_mask_2,
        output [MASK_WIDTH - 1 : 0]         src_mask_3,
        output [MASK_WIDTH - 1 : 0]         src_mask_4,
        output                              dst_data_valid_1,
        output                              dst_data_valid_2,
        output                              dst_data_valid_3,
        output                              dst_data_valid_4);

    wire src_valid_buffer[0 : FLOAT_ADD_DELAY];
    wire [DST_ID_DWIDTH - 1 : 0] dst_id_1_buffer[0 : FLOAT_ADD_DELAY];
    wire [DST_ID_DWIDTH - 1 : 0] dst_id_2_buffer[0 : FLOAT_ADD_DELAY];
    wire [DST_ID_DWIDTH - 1 : 0] dst_id_3_buffer[0 : FLOAT_ADD_DELAY];
    wire [DST_ID_DWIDTH - 1 : 0] dst_id_4_buffer[0 : FLOAT_ADD_DELAY];
    wire [MASK_WIDTH - 1 : 0] src_mask_1_buffer[0 : FLOAT_ADD_DELAY];
    wire [MASK_WIDTH - 1 : 0] src_mask_2_buffer[0 : FLOAT_ADD_DELAY];
    wire [MASK_WIDTH - 1 : 0] src_mask_3_buffer[0 : FLOAT_ADD_DELAY];
    wire [MASK_WIDTH - 1 : 0] src_mask_4_buffer[0 : FLOAT_ADD_DELAY];
    wire dst_data_valid_1_buffer[0 : FLOAT_ADD_DELAY];
    wire dst_data_valid_2_buffer[0 : FLOAT_ADD_DELAY];
    wire dst_data_valid_3_buffer[0 : FLOAT_ADD_DELAY];
    wire dst_data_valid_4_buffer[0 : FLOAT_ADD_DELAY];

    assign src_valid_buffer[0] = front_src_valid;
    assign dst_id_1_buffer[0] = front_dst_id_1;
    assign dst_id_2_buffer[0] = front_dst_id_2;
    assign dst_id_3_buffer[0] = front_dst_id_3;
    assign dst_id_4_buffer[0] = front_dst_id_4;
    assign src_mask_1_buffer[0] = front_src_mask_1;
    assign src_mask_2_buffer[0] = front_src_mask_2;
    assign src_mask_3_buffer[0] = front_src_mask_3;
    assign src_mask_4_buffer[0] = front_src_mask_4;
    assign dst_data_valid_1_buffer[0] = front_dst_data_valid_1;
    assign dst_data_valid_2_buffer[0] = front_dst_data_valid_2;
    assign dst_data_valid_3_buffer[0] = front_dst_data_valid_3;
    assign dst_data_valid_4_buffer[0] = front_dst_data_valid_4;

    assign src_valid = src_valid_buffer[FLOAT_ADD_DELAY];
    assign dst_id_1 = dst_id_1_buffer[FLOAT_ADD_DELAY];
    assign dst_id_2 = dst_id_2_buffer[FLOAT_ADD_DELAY];
    assign dst_id_3 = dst_id_3_buffer[FLOAT_ADD_DELAY];
    assign dst_id_4 = dst_id_4_buffer[FLOAT_ADD_DELAY];
    assign src_mask_1 = src_mask_1_buffer[FLOAT_ADD_DELAY];
    assign src_mask_2 = src_mask_2_buffer[FLOAT_ADD_DELAY];
    assign src_mask_3 = src_mask_3_buffer[FLOAT_ADD_DELAY];
    assign src_mask_4 = src_mask_4_buffer[FLOAT_ADD_DELAY];
    assign dst_data_valid_1 = dst_data_valid_1_buffer[FLOAT_ADD_DELAY];
    assign dst_data_valid_2 = dst_data_valid_2_buffer[FLOAT_ADD_DELAY];
    assign dst_data_valid_3 = dst_data_valid_3_buffer[FLOAT_ADD_DELAY];
    assign dst_data_valid_4 = dst_data_valid_4_buffer[FLOAT_ADD_DELAY];

    parallel_accumulator_edge E0
        (.clk(clk), .rst(rst),
         .front_src(front_src), .front_acc_id(front_acc_id),

         .src(src));

    generate
        genvar i;
        for(i = 0;i<FLOAT_ADD_DELAY;i = i + 1) begin : M14_BLOCK_LATENCY
            parallel_accumulator_valid_trasfer T0 (
                .clk(clk),.rst(rst),
                .front_src_valid(src_valid_buffer[i]),

                .src_valid(src_valid_buffer[i + 1]));

            parallel_accumulator_vertex_pipeline P0 
                (.clk(clk), .rst(rst),
                .front_dst_id(dst_id_1_buffer[i]), .front_src_mask(src_mask_1_buffer[i]), .front_dst_data_valid(dst_data_valid_1_buffer[i]),

                .dst_id(dst_id_1_buffer[i + 1]), .src_mask(src_mask_1_buffer[i + 1]), .dst_data_valid(dst_data_valid_1_buffer[i + 1]));

            parallel_accumulator_vertex_pipeline P1 
                (.clk(clk), .rst(rst),
                .front_dst_id(dst_id_2_buffer[i]), .front_src_mask(src_mask_2_buffer[i]), .front_dst_data_valid(dst_data_valid_2_buffer[i]),

                .dst_id(dst_id_2_buffer[i + 1]), .src_mask(src_mask_2_buffer[i + 1]), .dst_data_valid(dst_data_valid_2_buffer[i + 1]));

            parallel_accumulator_vertex_pipeline P2 
                (.clk(clk), .rst(rst),
                .front_dst_id(dst_id_3_buffer[i]), .front_src_mask(src_mask_3_buffer[i]), .front_dst_data_valid(dst_data_valid_3_buffer[i]),

                .dst_id(dst_id_3_buffer[i + 1]), .src_mask(src_mask_3_buffer[i + 1]), .dst_data_valid(dst_data_valid_3_buffer[i + 1]));

            parallel_accumulator_vertex_pipeline P3 
                (.clk(clk), .rst(rst),
                .front_dst_id(dst_id_4_buffer[i]), .front_src_mask(src_mask_4_buffer[i]), .front_dst_data_valid(dst_data_valid_4_buffer[i]),

                .dst_id(dst_id_4_buffer[i + 1]), .src_mask(src_mask_4_buffer[i + 1]), .dst_data_valid(dst_data_valid_4_buffer[i + 1]));
        end
    endgenerate
endmodule

module parallel_accumulator_edge #(
    EDGE_PIPE_NUM = `EDGE_PIPE_NUM,
    VERTEX_BRAM_DWIDTH = `VERTEX_BRAM_DWIDTH,
    TOT_ACC_ID_WIDTH = `TOT_ACC_ID_WIDTH,
    ACC_ID_WIDTH = `ACC_ID_WIDTH, MASK_WIDTH = `MASK_WIDTH
) (
    input           clk,
    input           rst,
    input [VERTEX_BRAM_DWIDTH * EDGE_PIPE_NUM - 1 : 0]   front_src,
    input [TOT_ACC_ID_WIDTH - 1 : 0]   front_acc_id,

    output [VERTEX_BRAM_DWIDTH * EDGE_PIPE_NUM - 1 : 0]  src);

    wire [VERTEX_BRAM_DWIDTH * EDGE_PIPE_NUM - 1 : 0] src_level_1, src_level_2, src_level_3, src_level_4;
    wire [TOT_ACC_ID_WIDTH - 1 : 0] acc_id_level_1, acc_id_level_2, acc_id_level_3, acc_id_level_4;

    assign src = src_level_4;

    // level 4

    generate
        genvar i;
        for (i = 0; i < EDGE_PIPE_NUM / 2; i = i + 1) begin: M14_BLOCK_1
            parallel_accumulator_update_reg L4_R (
                .clk(clk), .rst(rst),
                .din(src_level_3[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idin(acc_id_level_3[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]),

                .dout(src_level_4[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idout(acc_id_level_4[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]));
        end
    endgenerate

    generate
        for (i = EDGE_PIPE_NUM / 2; i < EDGE_PIPE_NUM; i = i + 1) begin: M14_BLOCK_2
            parallel_accumulator_update_addr L4_A (
                .clk(clk), .rst(rst),
                .din_1(src_level_3[(EDGE_PIPE_NUM / 2) * VERTEX_BRAM_DWIDTH - 1 : (EDGE_PIPE_NUM / 2 - 1) * VERTEX_BRAM_DWIDTH]), .idin_1(acc_id_level_3[(EDGE_PIPE_NUM / 2) * ACC_ID_WIDTH - 1 : (EDGE_PIPE_NUM / 2 - 1) * ACC_ID_WIDTH]),
                .din_2(src_level_3[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idin_2(acc_id_level_3[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]),

                .dout(src_level_4[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idout(acc_id_level_4[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]));
        end
    endgenerate

    // level 3
    generate
        for (i = 0; i < EDGE_PIPE_NUM / 4; i = i + 1) begin: M14_BLOCK_3
            parallel_accumulator_update_reg L3_R (
                .clk(clk), .rst(rst),
                .din(src_level_2[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idin(acc_id_level_2[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]),

                .dout(src_level_3[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idout(acc_id_level_3[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]));
        end
        for (i = EDGE_PIPE_NUM / 2; i < EDGE_PIPE_NUM * 3 / 4; i = i + 1) begin: M14_BLOCK_4
            parallel_accumulator_update_reg L3_R (
                .clk(clk), .rst(rst),
                .din(src_level_2[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idin(acc_id_level_2[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]),

                .dout(src_level_3[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idout(acc_id_level_3[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]));
        end
    endgenerate

    generate
        for (i = EDGE_PIPE_NUM / 4; i < EDGE_PIPE_NUM / 2; i = i + 1) begin: M14_BLOCK_5
            parallel_accumulator_update_addr L3_A (
                .clk(clk), .rst(rst),
                .din_1(src_level_2[(EDGE_PIPE_NUM / 4) * VERTEX_BRAM_DWIDTH - 1 : (EDGE_PIPE_NUM / 4 - 1) * VERTEX_BRAM_DWIDTH]), .idin_1(acc_id_level_2[(EDGE_PIPE_NUM / 4) * ACC_ID_WIDTH - 1 : (EDGE_PIPE_NUM / 4 - 1) * ACC_ID_WIDTH]),
                .din_2(src_level_2[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idin_2(acc_id_level_2[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]),

                .dout(src_level_3[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idout(acc_id_level_3[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]));
        end
        for (i = EDGE_PIPE_NUM * 3 / 4; i < EDGE_PIPE_NUM; i = i + 1) begin: M14_BLOCK_6
            parallel_accumulator_update_addr L3_A (
                .clk(clk), .rst(rst),
                .din_1(src_level_2[(EDGE_PIPE_NUM * 3 / 4) * VERTEX_BRAM_DWIDTH - 1 : (EDGE_PIPE_NUM * 3 / 4 - 1) * VERTEX_BRAM_DWIDTH]), .idin_1(acc_id_level_2[(EDGE_PIPE_NUM * 3 / 4) * ACC_ID_WIDTH - 1 : (EDGE_PIPE_NUM * 3 / 4 - 1) * ACC_ID_WIDTH]),
                .din_2(src_level_2[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idin_2(acc_id_level_2[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]),

                .dout(src_level_3[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idout(acc_id_level_3[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]));
        end
    endgenerate

    // level 2
    generate
        for (i = 0; i < EDGE_PIPE_NUM; i = i + 4) begin: M14_BLOCK_7
            parallel_accumulator_update_reg L2_R (
                .clk(clk), .rst(rst),
                .din(src_level_1[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idin(acc_id_level_1[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]),

                .dout(src_level_2[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idout(acc_id_level_2[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]));
        end
        for (i = 1; i < EDGE_PIPE_NUM; i = i + 4) begin: M14_BLOCK_8
            parallel_accumulator_update_reg L2_R (
                .clk(clk), .rst(rst),
                .din(src_level_1[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idin(acc_id_level_1[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]),

                .dout(src_level_2[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idout(acc_id_level_2[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]));
        end
    endgenerate

    generate
        for (i = 2; i < EDGE_PIPE_NUM; i = i + 4) begin: M14_BLOCK_9
            parallel_accumulator_update_addr L2_A (
                .clk(clk), .rst(rst),
                .din_1(src_level_1[i * VERTEX_BRAM_DWIDTH - 1 : (i - 1) * VERTEX_BRAM_DWIDTH]), .idin_1(acc_id_level_1[i * ACC_ID_WIDTH - 1 : (i - 1) * ACC_ID_WIDTH]),
                .din_2(src_level_1[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idin_2(acc_id_level_1[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]),

                .dout(src_level_2[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idout(acc_id_level_2[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]));
        end
        for (i = 3; i < EDGE_PIPE_NUM; i = i + 4) begin: M14_BLOCK_10
            parallel_accumulator_update_addr L2_A (
                .clk(clk), .rst(rst),
                .din_1(src_level_1[(i - 1) * VERTEX_BRAM_DWIDTH - 1 : (i - 2) * VERTEX_BRAM_DWIDTH]), .idin_1(acc_id_level_1[(i - 1) * ACC_ID_WIDTH - 1 : (i - 2) * ACC_ID_WIDTH]),
                .din_2(src_level_1[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idin_2(acc_id_level_1[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]),

                .dout(src_level_2[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idout(acc_id_level_2[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]));
        end
    endgenerate

    // level 1

    generate
        for (i = 0; i < EDGE_PIPE_NUM; i = i + 2) begin: M14_BLOCK_11
            parallel_accumulator_update_reg L1_R (
                .clk(clk), .rst(rst),
                .din(front_src[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idin(front_acc_id[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]),

                .dout(src_level_1[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idout(acc_id_level_1[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]));
        end
    endgenerate

    generate
        for (i = 1; i < EDGE_PIPE_NUM; i = i + 2) begin: M14_BLOCK_12
            parallel_accumulator_update_addr L2_A (
                .clk(clk), .rst(rst),
                .din_1(front_src[i * VERTEX_BRAM_DWIDTH - 1 : (i - 1) * VERTEX_BRAM_DWIDTH]), .idin_1(front_acc_id[i * ACC_ID_WIDTH - 1 : (i - 1) * ACC_ID_WIDTH]),
                .din_2(front_src[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idin_2(front_acc_id[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]),

                .dout(src_level_1[(i + 1) * VERTEX_BRAM_DWIDTH - 1 : i * VERTEX_BRAM_DWIDTH]), .idout(acc_id_level_1[(i + 1) * ACC_ID_WIDTH - 1 : i * ACC_ID_WIDTH]));
        end
    endgenerate

endmodule


//???reg ??? addr ??????????????????latency
module parallel_accumulator_update_reg #(parameter
    VERTEX_BRAM_DWIDTH = `VERTEX_BRAM_DWIDTH,
    ACC_ID_WIDTH = `ACC_ID_WIDTH,FLOAT_ADD_DELAY=`FLOAT_ADD_DELAY
    ) (
    input clk,
    input rst,
    input [VERTEX_BRAM_DWIDTH - 1 : 0] din,
    input [ACC_ID_WIDTH - 1 : 0] idin,

    output [VERTEX_BRAM_DWIDTH - 1 : 0] dout,
    output [ACC_ID_WIDTH - 1 : 0] idout);

    wire [ACC_ID_WIDTH - 1 : 0] idout_buffer[0 : FLOAT_ADD_DELAY];
    wire [VERTEX_BRAM_DWIDTH - 1 : 0] dout_buffer[0 : FLOAT_ADD_DELAY];
    assign idout_buffer[0] = idin;
    assign dout_buffer[0] = din;
    assign idout = idout_buffer[FLOAT_ADD_DELAY];
    assign dout = dout_buffer[FLOAT_ADD_DELAY];

    generate 
        genvar i;
        for(i = 0;i< FLOAT_ADD_DELAY; i = i + 1)begin : M14_REG_BLOCK
            parallel_accumulator_data_transfer #(.DATA_WIDTH(ACC_ID_WIDTH)) idout_trans_0(
                .clk(clk),.rst(rst),
                .front_data(idout_buffer[i]),

                .data(idout_buffer[i + 1]));
            parallel_accumulator_data_transfer #(.DATA_WIDTH(VERTEX_BRAM_DWIDTH)) dout_trans_0(
                .clk(clk),.rst(rst),
                .front_data(dout_buffer[i]),

                .data(dout_buffer[i + 1]));
        end
    endgenerate
endmodule

module parallel_accumulator_update_addr #(parameter
    VERTEX_BRAM_DWIDTH = `VERTEX_BRAM_DWIDTH,
    ACC_ID_WIDTH = `ACC_ID_WIDTH, FLOAT_ADD_DELAY = `FLOAT_ADD_DELAY
    ) (
    input clk,
    input rst,
    input [VERTEX_BRAM_DWIDTH - 1 : 0] din_1,
    input [ACC_ID_WIDTH - 1 : 0] idin_1,
    input [VERTEX_BRAM_DWIDTH - 1 : 0] din_2,
    input [ACC_ID_WIDTH - 1 : 0] idin_2,

    output [VERTEX_BRAM_DWIDTH - 1 : 0] dout,
    output [ACC_ID_WIDTH - 1 : 0] idout);
    /*
    always @ (posedge clk) begin
        if (rst) begin
            dout <= 0;
            idout <= 0;
        end
        else begin
            if (idin_1 == idin_2 && din_1 < din_2) begin
                dout <= din_1;
                idout <= idin_1;
            end
            else begin
                dout <= din_2;
                idout <= idin_2;
            end
        end
    end*/
    wire [ACC_ID_WIDTH - 1 : 0] idout_buffer[0 : FLOAT_ADD_DELAY];
    assign idout_buffer[0] = idin_2;
    assign idout = idout_buffer[FLOAT_ADD_DELAY];

    generate 
        genvar i;
        for(i = 0;i< FLOAT_ADD_DELAY; i = i + 1)begin : M14_ADD_BLOCK
            parallel_accumulator_data_transfer #(.DATA_WIDTH(ACC_ID_WIDTH)) idout_trans(
                .clk(clk),.rst(rst),
                .front_data(idout_buffer[i]),

                .data(idout_buffer[i + 1]));
        end
    endgenerate

    //add option
    wire [VERTEX_BRAM_DWIDTH - 1 : 0] tmp_a;
    assign tmp_a = (idin_1 == idin_2)? din_1 : 0;
    float_add FA(
        .aclk(clk),
        .s_axis_a_tdata(tmp_a),.s_axis_a_tvalid(1'b1),
        .s_axis_b_tdata(din_2),.s_axis_b_tvalid(1'b1),

        .m_axis_result_tdata(dout)
    );

endmodule

module parallel_accumulator_vertex_pipeline #(parameter
    DST_ID_DWIDTH = `DST_ID_DWIDTH,
    MASK_WIDTH = `MASK_WIDTH
    ) (
    input clk,
    input rst,
    input [DST_ID_DWIDTH - 1 : 0] front_dst_id,
    input [MASK_WIDTH - 1 : 0] front_src_mask,
    input front_dst_data_valid,

    output [DST_ID_DWIDTH - 1 : 0] dst_id,
    output [MASK_WIDTH - 1 : 0] src_mask,
    output dst_data_valid);

    reg [DST_ID_DWIDTH - 1 : 0] dst_id_level_1, dst_id_level_2, dst_id_level_3, dst_id_level_4;
    reg [MASK_WIDTH - 1 : 0] src_mask_level_1, src_mask_level_2, src_mask_level_3, src_mask_level_4;
    reg dst_data_valid_level_1, dst_data_valid_level_2, dst_data_valid_level_3, dst_data_valid_level_4;

    always @ (posedge clk) begin
        if (rst) begin
            dst_id_level_1 <= 0;
            dst_id_level_2 <= 0;
            dst_id_level_3 <= 0;
            dst_id_level_4 <= 0;
            src_mask_level_1 <= 0;
            src_mask_level_2 <= 0;
            src_mask_level_3 <= 0;
            src_mask_level_4 <= 0;
            dst_data_valid_level_1 <= 0;
            dst_data_valid_level_2 <= 0;
            dst_data_valid_level_3 <= 0;
            dst_data_valid_level_4 <= 0;
        end
        else begin
            dst_id_level_4 <= dst_id_level_3;
            dst_id_level_3 <= dst_id_level_2;
            dst_id_level_2 <= dst_id_level_1;
            dst_id_level_1 <= front_dst_id;
            src_mask_level_4 <= src_mask_level_3;
            src_mask_level_3 <= src_mask_level_2;
            src_mask_level_2 <= src_mask_level_1;
            src_mask_level_1 <= front_src_mask;
            dst_data_valid_level_4 <= dst_data_valid_level_3;
            dst_data_valid_level_3 <= dst_data_valid_level_2;
            dst_data_valid_level_2 <= dst_data_valid_level_1;
            dst_data_valid_level_1 <= front_dst_data_valid;
        end
    end

    assign dst_id = dst_id_level_4;
    assign src_mask = src_mask_level_4;
    assign dst_data_valid = dst_data_valid_level_4;

endmodule

module parallel_accumulator_data_transfer #(parameter
    DATA_WIDTH = 1
    )(
    input clk,
    input rst,
    input [DATA_WIDTH - 1 : 0] front_data,

    output reg [DATA_WIDTH - 1 : 0] data
    );
    always @(posedge clk)begin
        if(rst)begin
            data <= {DATA_WIDTH{1'b0}};
        end
        else begin
            data <= front_data;
        end
    end
endmodule

module parallel_accumulator_valid_trasfer (
    input   clk,
    input   rst,

    input   front_src_valid,
    output  src_valid);

    reg src_level_1_valid, src_level_2_valid, src_level_3_valid, src_level_4_valid;

    always @ (posedge clk) begin
        if (rst == 1'b1) begin
            src_level_1_valid <= 1'b0;
            src_level_2_valid <= 1'b0;
            src_level_3_valid <= 1'b0;
            src_level_4_valid <= 1'b0;
        end
        else begin
            src_level_4_valid <= src_level_3_valid;
            src_level_3_valid <= src_level_2_valid;
            src_level_2_valid <= src_level_1_valid;
            src_level_1_valid <= front_src_valid;
        end
    end
    assign src_valid = src_level_4_valid;
endmodule