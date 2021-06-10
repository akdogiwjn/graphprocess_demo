module rd_src_p_shuffle_1_edge_single_single #(parameter
	FLAG = 4'b0000, 
	LOC_Y_ST_1 = 4'b0000, LOC_Y_ST_2 = 4'b0001, LOC_Y_ST_3 = 4'b0010, LOC_Y_ST_4 = 4'b0011,
	SRC_ID_DWIDTH = `SRC_ID_DWIDTH, SRC_P_AWIDTH = `SRC_P_AWIDTH,
	LOC_X_WIDTH = `LOC_X_WIDTH, LOC_Y_WIDTH = `LOC_Y_WIDTH,
	BUFFER_SIZE = `PIPE_BUFFER_SIZE, BUFFER_PTR_WIDTH = `PIPE_BUFFER_PTR_WIDTH, AM_LEVEL = `PIPE_AM_LEVEL
	)(
	input 								clk,
	input 								rst,
	input [4 * SRC_ID_DWIDTH - 1 : 0] 	front_rd_src_p_addr,
	input 								front_rd_src_p_valid,
	input								back_stage_edge_full,
	
	output 								buffer_empty,
	output 								buffer_full,
	output reg [SRC_P_AWIDTH - 1 : 0] 	rd_src_p_addr,
	output reg [LOC_X_WIDTH - 1 : 0] 	reorder_loc_x,
	output reg [LOC_Y_WIDTH - 1 : 0] 	reorder_loc_y,
	output reg 							rd_src_p_valid
	);
	
	reg [SRC_ID_DWIDTH - 1 : 0]		src_p_addr_buffer [0 : BUFFER_SIZE - 1];
	reg [LOC_X_WIDTH - 1 : 0] 		loc_x_buffer [0 : BUFFER_SIZE - 1];
	reg [LOC_Y_WIDTH - 1 : 0] 		loc_y_buffer [0 : BUFFER_SIZE - 1];
	reg [BUFFER_PTR_WIDTH : 0]		wr_cntr, wr_cntr_1, wr_cntr_2, wr_cntr_3, rd_cntr;
	reg [BUFFER_PTR_WIDTH : 0]		reorder_wr_cntr;
	
	wire [BUFFER_PTR_WIDTH : 0]		ptr_gap = (wr_cntr - rd_cntr);
	wire [BUFFER_PTR_WIDTH - 1 : 0]	write_ptr, write_ptr_1, write_ptr_2, write_ptr_3, read_ptr;
	wire [BUFFER_PTR_WIDTH - 1 : 0] reorder_write_ptr;
	
	assign buffer_empty = ((wr_cntr == rd_cntr) || rst);
	assign buffer_full = ((ptr_gap >= AM_LEVEL) || rst);
	
	assign write_ptr = wr_cntr[BUFFER_PTR_WIDTH - 1 : 0];
	assign write_ptr_1 = wr_cntr_1[BUFFER_PTR_WIDTH - 1 : 0];
	assign write_ptr_2 = wr_cntr_2[BUFFER_PTR_WIDTH - 1 : 0];
	assign write_ptr_3 = wr_cntr_3[BUFFER_PTR_WIDTH - 1 : 0];
	assign read_ptr = rd_cntr[BUFFER_PTR_WIDTH - 1 : 0];
	assign reorder_write_ptr = reorder_wr_cntr[BUFFER_PTR_WIDTH - 1 : 0];
	
	wire flag1 = (front_rd_src_p_addr[3 : 0] == FLAG);
	wire flag2 = (front_rd_src_p_addr[SRC_ID_DWIDTH + 4 - 1 : SRC_ID_DWIDTH] == FLAG);
	wire flag3 = (front_rd_src_p_addr[2 * SRC_ID_DWIDTH + 4 - 1 : 2 * SRC_ID_DWIDTH] == FLAG);
	wire flag4 = (front_rd_src_p_addr[3 * SRC_ID_DWIDTH + 4 - 1 : 3 * SRC_ID_DWIDTH] == FLAG);
	wire front_rd_src_p_addr_1 = front_rd_src_p_addr[SRC_ID_DWIDTH - 1 : SRC_ID_DWIDTH - SRC_P_AWIDTH];
	wire front_rd_src_p_addr_2 = front_rd_src_p_addr[2 * SRC_ID_DWIDTH - 1 : SRC_ID_DWIDTH + SRC_ID_DWIDTH - SRC_P_AWIDTH];
	wire front_rd_src_p_addr_3 = front_rd_src_p_addr[3 * SRC_ID_DWIDTH - 1 : 2 * SRC_ID_DWIDTH + SRC_ID_DWIDTH - SRC_P_AWIDTH];
	wire front_rd_src_p_addr_4 = front_rd_src_p_addr[4 * SRC_ID_DWIDTH - 1 : 3 * SRC_ID_DWIDTH + SRC_ID_DWIDTH - SRC_P_AWIDTH];
	
	always @ (posedge clk) begin
		if (rst) begin
			wr_cntr <= 0;
			wr_cntr_1 <= 1;
			wr_cntr_2 <= 2;
			wr_cntr_3 <= 3;
			reorder_wr_cntr <= 0;
		end
		else begin
			if (front_rd_src_p_valid) begin
				reorder_wr_cntr <= reorder_wr_cntr + 1;

				//源点数据访问带来大量乱序访存，通过内存划分和相应缓冲区避免流水停滞。
				<font color="#FF0000">case ({flag1, flag2, flag3, flag4})</font> //根据访存请求MOD N的结果存入对应缓冲区
					<font color="#FF0000">4'b0001: begin
						src_p_addr_buffer[write_ptr] <= front_rd_src_p_addr_4;</font>
						loc_x_buffer[write_ptr] <= reorder_write_ptr;
						loc_y_buffer[write_ptr] <= LOC_Y_ST_4;
						
						wr_cntr <= wr_cntr + 1;
						wr_cntr_1 <= wr_cntr_1 + 1;
						wr_cntr_2 <= wr_cntr_2 + 1;
						wr_cntr_3 <= wr_cntr_3 + 1;
					end
					<font color="#FF0000">4'b0010: begin
						src_p_addr_buffer[write_ptr] <= front_rd_src_p_addr_3;</font>
						loc_x_buffer[write_ptr] <= reorder_write_ptr;
						loc_y_buffer[write_ptr] <= LOC_Y_ST_3;
						
						wr_cntr <= wr_cntr + 1;
						wr_cntr_1 <= wr_cntr_1 + 1;
						wr_cntr_2 <= wr_cntr_2 + 1;
						wr_cntr_3 <= wr_cntr_3 + 1;
					end
					…
					<font color="#FF0000">4'b1111: begin
						src_p_addr_buffer[write_ptr] <= front_rd_src_p_addr_1;
						src_p_addr_buffer[write_ptr_1] <= front_rd_src_p_addr_2;
						src_p_addr_buffer[write_ptr_2] <= front_rd_src_p_addr_3;
						src_p_addr_buffer[write_ptr_3] <= front_rd_src_p_addr_4;</font>
						loc_x_buffer[write_ptr] <= reorder_write_ptr;
						loc_x_buffer[write_ptr_1] <= reorder_write_ptr;
						loc_x_buffer[write_ptr_2] <= reorder_write_ptr;
						loc_x_buffer[write_ptr_3] <= reorder_write_ptr;
						loc_y_buffer[write_ptr] <= LOC_Y_ST_1;
						loc_y_buffer[write_ptr_1] <= LOC_Y_ST_2;
						loc_y_buffer[write_ptr_2] <= LOC_Y_ST_3;
						loc_y_buffer[write_ptr_3] <= LOC_Y_ST_4;
						
						wr_cntr <= wr_cntr + 4;
						wr_cntr_1 <= wr_cntr_1 + 4;
						wr_cntr_2 <= wr_cntr_2 + 4;
						wr_cntr_3 <= wr_cntr_3 + 4;
					end
				endcase
			end
		end
	end
	
	always @ (posedge clk) begin
		if (rst) begin
			rd_src_p_addr <= 0;
			reorder_loc_x <= 0;
			reorder_loc_y <= 0;
			rd_src_p_valid <= 0;
			
			rd_cntr <= 0;
		end
		else begin
			if (!(buffer_empty || back_stage_edge_full)) begin
				rd_src_p_addr <= src_p_addr_buffer[read_ptr];
				reorder_loc_x <= loc_x_buffer[read_ptr];
				reorder_loc_y <= loc_y_buffer[read_ptr];
				rd_src_p_valid <= 1;
			end
			else begin
				rd_src_p_addr <= 0;
				reorder_loc_x <= 0;
				reorder_loc_y <= 0;
				rd_src_p_valid <= 0;
			end
		end
	end

endmodule



module rd_src_p_bram_bram #(parameter
	SRC_P_AWIDTH = `SRC_P_AWIDTH, SRC_P_TOT_AWIDTH = `SRC_P_TOT_AWIDTH, 
	SRC_P_DWIDTH = `SRC_P_DWIDTH, SRC_P_TOT_DWIDTH = `SRC_P_TOT_DWIDTH,
	LOC_X_TOT_WIDTH = `LOC_X_TOT_WIDTH, LOC_Y_TOT_WIDTH = `LOC_Y_TOT_WIDTH,
	EDGE_PIPE_NUM = `EDGE_PIPE_NUM
	)(
	input								clk,
	input 								rst,
	input [SRC_P_TOT_AWIDTH - 1 : 0]	front_rd_src_p_addr,
	input [LOC_X_TOT_WIDTH - 1 : 0]		front_reorder_loc_x,
	input [LOC_Y_TOT_WIDTH - 1 : 0] 	front_reorder_loc_y,
	input [EDGE_PIPE_NUM - 1 : 0]		front_rd_src_p_valid,
	//input 								back_stage_edge_full,
	input [SRC_P_AWIDTH - 1 : 0]		wb_dst_addr_1,
	input [SRC_P_AWIDTH - 1 : 0]		wb_dst_addr_2,
	input [SRC_P_AWIDTH - 1 : 0]		wb_dst_addr_3,
	input [SRC_P_AWIDTH - 1 : 0]		wb_dst_addr_4,
	input [SRC_P_DWIDTH - 1 : 0]		wb_dst_p_1,
	input [SRC_P_DWIDTH - 1 : 0]		wb_dst_p_2,
	input [SRC_P_DWIDTH - 1 : 0]		wb_dst_p_3,
	input [SRC_P_DWIDTH - 1 : 0]		wb_dst_p_4,
	input [4 - 1 : 0]					wb_dst_data_valid_1,
	input [4 - 1 : 0]					wb_dst_data_valid_2,
	input [4 - 1 : 0]					wb_dst_data_valid_3,
	input [4 - 1 : 0]					wb_dst_data_valid_4,
	
	//output 									buffer_empty,
	//output 									buffer_full,
	output [SRC_P_TOT_DWIDTH - 1 : 0] 	src_p,
	output [LOC_X_TOT_WIDTH - 1 : 0] 	reorder_loc_x,
	output [LOC_Y_TOT_WIDTH - 1 : 0] 	reorder_loc_y,
	output [EDGE_PIPE_NUM - 1 : 0]		rd_src_p_valid
	);
	
	<font color="#FF0000">vertex_bram BM1</font>   //对访存请求进行处理
		(.clka(clk), .clkb(clk),
		.addra(wb_dst_addr_1), .dina(wb_dst_p_1), .wea(wb_dst_data_valid_1[0] && !rst),
		<font color="#FF0000">.addrb(front_rd_src_p_addr[SRC_P_AWIDTH - 1 : 0]),</font>
		
		.doutb(src_p[SRC_P_DWIDTH - 1 : 0])
		);
	
	<font color="#FF0000">vertex_bram BM2</font>
		(.clka(clk), .clkb(clk),
		.addra(wb_dst_addr_2), .dina(wb_dst_p_2), .wea(wb_dst_data_valid_2[0] && !rst),
		<font color="#FF0000">.addrb(front_rd_src_p_addr[2 * SRC_P_AWIDTH - 1 : SRC_P_AWIDTH]),</font>
		
		.doutb(src_p[2 * SRC_P_DWIDTH - 1 : SRC_P_DWIDTH])
		);
		
	…
		
	<font color="#FF0000">vertex_bram BM16</font>
		(.clka(clk), .clkb(clk),
		.addra(wb_dst_addr_4), .dina(wb_dst_p_4), .wea(wb_dst_data_valid_4[3] && !rst),
		<font color="#FF0000">.addrb(front_rd_src_p_addr[16 * SRC_P_AWIDTH - 1: 15 * SRC_P_AWIDTH]),</font>
		
		.doutb(src_p[16 * SRC_P_DWIDTH - 1 : 15 * SRC_P_DWIDTH])
		);
	
	tot_loc_x_fifo M1
	   (.clk(clk), .srst(rst), 
	   .din(front_reorder_loc_x), .wr_en(1'b1), .rd_en(1'b1), 
	   
	   .dout(reorder_loc_x)
	   );
	
	tot_loc_y_fifo M2
	   (.clk(clk), .srst(rst), 
	   .din(front_reorder_loc_y), .wr_en(1'b1), .rd_en(1'b1), 
	   
	   .dout(reorder_loc_y)
	   );
	
	valid_fifo_16bits M3
		(.clk(clk), .srst(rst), 
		.din(front_rd_src_p_valid), .wr_en(1'b1), .rd_en(1'b1), 
		
		.dout(rd_src_p_valid)
		);
		
endmodule
