//PR apply.v
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
    WB_VALID_WIDTH = `WB_VALID_WIDTH, PIPE_NUM = 0,
    VERTEX_BRAM_NUM_WIDTH = `VERTEX_BRAM_NUM_WIDTH,
    VERTEX_BRAM_AWIDTH = `VERTEX_BRAM_AWIDTH, VERTEX_BRAM_DWIDTH = `VERTEX_BRAM_DWIDTH,
    DST_ID_DWIDTH = `DST_ID_DWIDTH
    ) (
    input clk,
    input rst,
    input [DST_ID_DWIDTH - 1 : 0] front_dst_id,
    input [VERTEX_BRAM_DWIDTH - 1 : 0] front_src,
    input front_dst_data_valid,

    output [DST_ID_DWIDTH - 1 : 0] wb_dst_addr, // 使用 DST_ID_DWIDTH 便于调试
    output [VERTEX_BRAM_DWIDTH - 1 : 0] wb_dst_data,
    output [WB_VALID_WIDTH - 1 : 0] wb_dst_data_valid);

    wire [DST_ID_DWIDTH - 1 : 0] wb_dst_addr_L1,wb_dst_addr_L2;
    wire [VERTEX_BRAM_DWIDTH - 1 : 0] wb_dst_data_L1,wb_dst_data_L2;
    wire [WB_VALID_WIDTH - 1 : 0] wb_dst_data_valid_L1,wb_dst_data_valid_L2;
    wire [VERTEX_BRAM_DWIDTH - 1 : 0] factor;

    sequential_accumulator_pipeline_acc M16_acc(
        .clk(clk),.rst(rst),
        .front_dst_id(front_dst_id),.front_src(front_src),.front_dst_data_valid(front_dst_data_valid),

        .wb_dst_addr(wb_dst_addr_L1),.wb_dst_data(wb_dst_data_L1),.wb_dst_data_valid(wb_dst_data_valid_L1));

    sequential_accumulator_pipeline_mul M16_mul(
        .clk(clk),.rst(rst),
        .front_wb_dst_addr(wb_dst_addr_L1),.front_wb_dst_data(wb_dst_data_L1),.front_wb_dst_data_valid(wb_dst_data_valid_L1),

        .wb_dst_addr(wb_dst_addr_L2),.wb_dst_data(wb_dst_data_L2),.factor(factor),.wb_dst_data_valid(wb_dst_data_valid_L2));
    sequential_accumulator_pipeline_add M16_add(
        .clk(clk),.rst(rst),
        .front_wb_dst_addr(wb_dst_addr_L2),.front_wb_dst_data(wb_dst_data_L2),.front_factor(factor),.front_wb_dst_data_valid(wb_dst_data_valid_L2),

        .wb_dst_addr(wb_dst_addr),.wb_dst_data(wb_dst_data),.wb_dst_data_valid(wb_dst_data_valid));  
endmodule


module sequential_accumulator_pipeline_acc #(parameter
    DST_ID_DWIDTH = `DST_ID_DWIDTH,VERTEX_BRAM_DWIDTH=`VERTEX_BRAM_DWIDTH,
    WB_VALID_WIDTH = `WB_VALID_WIDTH,FLOAT_ACC_DELAY = `FLOAT_ACC_DELAY,
    VERTEX_BRAM_NUM_WIDTH = `VERTEX_BRAM_NUM_WIDTH
    )(
    input clk,
    input rst,
    input [DST_ID_DWIDTH - 1 : 0] front_dst_id,
    input [VERTEX_BRAM_DWIDTH - 1 : 0] front_src,
    input front_dst_data_valid,        
    
    output reg [DST_ID_DWIDTH - 1 : 0] wb_dst_addr, // 使用 DST_ID_DWIDTH 便于调试
    output [VERTEX_BRAM_DWIDTH - 1 : 0] wb_dst_data,
    output reg [WB_VALID_WIDTH - 1 : 0] wb_dst_data_valid);

    reg [DST_ID_DWIDTH - 1 : 0] reg_dst_id;
    reg [VERTEX_BRAM_DWIDTH - 1 : 0] reg_src;
    reg reg_dst_data_valid;

    always @(posedge clk)begin
        if(rst)begin
            reg_dst_id <= 0;
            reg_src <= 0;
            reg_dst_data_valid <= 0;
        end
        else begin
           if(front_dst_data_valid)begin
               reg_dst_id <= front_dst_id;
               reg_src <= front_src;
               reg_dst_data_valid <= front_dst_data_valid;
           end 
        end
    end
    //for accumulator
    wire last_in = (front_dst_data_valid && reg_dst_data_valid && front_dst_id != reg_dst_id);
    wire valid_in = (front_dst_data_valid && reg_dst_data_valid);

    float_accumulator FAC(
        .aclk(clk),.aresetn(!rst),
        .s_axis_a_tdata(reg_src),.s_axis_a_tlast(last_in),.s_axis_a_tvalid(valid_in),

        .m_axis_result_tdata(wb_dst_data));
    
    // trans addr and valid for FLOAT_ACC_DELAY - 1 cycle
    wire [DST_ID_DWIDTH - 1 : 0] addr[0 : FLOAT_ACC_DELAY - 1];
    wire valid[0 : FLOAT_ACC_DELAY - 1];
    assign addr[0] = reg_dst_id;
    assign valid[0] = last_in;
    generate 
        genvar i;
        for(i = 0;i<FLOAT_ACC_DELAY - 1;i = i + 1)begin: M16_BLOCK_LATENCY
            sequential_accumulator_pipeline_trans #(
                .ADDR_WIDTH(DST_ID_DWIDTH),.VALID_WIDTH(1)
            ) trans(
                .clk(clk),.rst(rst),
                .front_addr(addr[i]),.front_valid(valid[i]),

                .addr(addr[i + 1]), .valid(valid[i + 1]));
        end
    endgenerate
    //set out addr
    always @(posedge clk)begin
        if(rst)begin
            wb_dst_addr <= 0;
        end
        else begin
            wb_dst_addr <= addr[FLOAT_ACC_DELAY - 1];
        end
    end
    //set out valid
    generate 
        for(i = 0;i<WB_VALID_WIDTH;i = i + 1)begin:M16_BLOCK_LATENCY_VALID
            always @(posedge clk)begin
                if(rst)begin
                    wb_dst_data_valid[i] <= 0;
                end
                else begin
                    if(valid[FLOAT_ACC_DELAY - 1])begin
                        wb_dst_data_valid[i] <= (addr[FLOAT_ACC_DELAY - 1][VERTEX_BRAM_NUM_WIDTH - 1 : 2] == i);
                    end
                    else begin
                        wb_dst_data_valid[i] <= 0;
                    end
                end
            end
        end
    endgenerate
endmodule   

module sequential_accumulator_pipeline_trans #(parameter
    ADDR_WIDTH = 0, VALID_WIDTH = 0
    )(
    input clk,
    input rst,
    input [ADDR_WIDTH - 1 : 0] front_addr,
    input [VALID_WIDTH - 1 : 0]front_valid,
    
    output reg [ADDR_WIDTH - 1 : 0] addr,
    output reg [VALID_WIDTH - 1 : 0] valid);

    always @(posedge clk)begin
        if(rst)begin
            addr <= 0;
            valid <= 0;
        end
        else begin
            addr <= front_addr;
            valid <= front_valid;
        end
    end
endmodule

module sequential_accumulator_pipeline_mul #(parameter
    DST_ID_DWIDTH = `DST_ID_DWIDTH,VERTEX_BRAM_DWIDTH = `VERTEX_BRAM_DWIDTH,
    WB_VALID_WIDTH = `WB_VALID_WIDTH,FLOAT_MUL_DELAY = `FLOAT_MUL_DELAY
    )(
    input   clk,
    input   rst,
    input [DST_ID_DWIDTH - 1 : 0] front_wb_dst_addr, // 使用 DST_ID_DWIDTH 便于调试
    input [VERTEX_BRAM_DWIDTH - 1 : 0] front_wb_dst_data,
    input [WB_VALID_WIDTH - 1 : 0] front_wb_dst_data_valid,

    output [DST_ID_DWIDTH - 1 : 0] wb_dst_addr,
    output [VERTEX_BRAM_DWIDTH - 1 : 0] wb_dst_data,
    output [VERTEX_BRAM_DWIDTH - 1 : 0] factor,
    output [WB_VALID_WIDTH - 1 : 0] wb_dst_data_valid
    );
    float_mul FM1(
        .aclk(clk),
        .s_axis_a_tdata(front_wb_dst_data),.s_axis_a_tvalid(1'b1),
        .s_axis_b_tdata(32'h3f59999a),.s_axis_b_tvalid(1'b1),//乘以0.85

        .m_axis_result_tdata(wb_dst_data));
    float_mul FM2(
        .aclk(clk),
        .s_axis_a_tdata(32'h3f800000),.s_axis_a_tvalid(1'b1),
        .s_axis_b_tdata(32'h3e19999a),.s_axis_b_tvalid(1'b1),//1乘以0.15

        .m_axis_result_tdata(factor));
    
    wire [DST_ID_DWIDTH - 1 : 0] wb_dst_addr_buffer[0 : FLOAT_MUL_DELAY];
    wire [WB_VALID_WIDTH - 1 : 0] wb_dst_data_valid_buffer[0 : FLOAT_MUL_DELAY];
    assign wb_dst_addr_buffer[0] = front_wb_dst_addr;
    assign wb_dst_data_valid_buffer[0] = front_wb_dst_data_valid;
    assign wb_dst_addr = wb_dst_addr_buffer[FLOAT_MUL_DELAY];
    assign wb_dst_data_valid = wb_dst_data_valid_buffer[FLOAT_MUL_DELAY];


    generate
        genvar i;
        for( i = 0;i < FLOAT_MUL_DELAY;i = i + 1)begin :M16_BLOCK_MUL
            sequential_accumulator_pipeline_trans #(
                .ADDR_WIDTH(DST_ID_DWIDTH), .VALID_WIDTH(WB_VALID_WIDTH)
            )   trans(
                .clk(clk),.rst(rst),
                .front_addr(wb_dst_addr_buffer[i]),.front_valid(wb_dst_data_valid_buffer[i]),

                .addr(wb_dst_addr_buffer[i + 1]),.valid(wb_dst_data_valid_buffer[i + 1]));
        end
    endgenerate

endmodule

module sequential_accumulator_pipeline_add #(parameter
    DST_ID_DWIDTH = `DST_ID_DWIDTH,VERTEX_BRAM_DWIDTH = `VERTEX_BRAM_DWIDTH,
    WB_VALID_WIDTH = `WB_VALID_WIDTH,FLOAT_ADD_DELAY = `FLOAT_ADD_DELAY
    )(
    input   clk,
    input   rst,
    input [DST_ID_DWIDTH - 1 : 0] front_wb_dst_addr, // 使用 DST_ID_DWIDTH 便于调试
    input [VERTEX_BRAM_DWIDTH - 1 : 0] front_wb_dst_data,
    input [VERTEX_BRAM_DWIDTH - 1 : 0] front_factor,
    input [WB_VALID_WIDTH - 1 : 0] front_wb_dst_data_valid,

    output [DST_ID_DWIDTH - 1 : 0] wb_dst_addr,
    output [VERTEX_BRAM_DWIDTH - 1 : 0] wb_dst_data,
    output [WB_VALID_WIDTH - 1 : 0] wb_dst_data_valid
    );
    float_add FA (
        .aclk(clk),
        .s_axis_a_tdata(front_wb_dst_data),.s_axis_a_tvalid(1'b1),
        .s_axis_b_tdata(front_factor),.s_axis_b_tvalid(1'b1),

        .m_axis_result_tdata(wb_dst_data));
    
    wire [DST_ID_DWIDTH - 1 : 0] wb_dst_addr_buffer[0 : FLOAT_ADD_DELAY];
    wire [WB_VALID_WIDTH - 1 : 0] wb_dst_data_valid_buffer[0 : FLOAT_ADD_DELAY];
    assign wb_dst_addr_buffer[0] = front_wb_dst_addr;
    assign wb_dst_data_valid_buffer[0] = front_wb_dst_data_valid;
    assign wb_dst_addr = wb_dst_addr_buffer[FLOAT_ADD_DELAY];
    assign wb_dst_data_valid = wb_dst_data_valid_buffer[FLOAT_ADD_DELAY];


    generate
        genvar i;
        for( i = 0;i < FLOAT_ADD_DELAY;i = i + 1)begin :M16_BLOCK_MUL
            sequential_accumulator_pipeline_trans #(
                .ADDR_WIDTH(DST_ID_DWIDTH), .VALID_WIDTH(WB_VALID_WIDTH)
            )   trans(
                .clk(clk),.rst(rst),
                .front_addr(wb_dst_addr_buffer[i]),.front_valid(wb_dst_data_valid_buffer[i]),

                .addr(wb_dst_addr_buffer[i + 1]),.valid(wb_dst_data_valid_buffer[i + 1]));
        end
    endgenerate
endmodule