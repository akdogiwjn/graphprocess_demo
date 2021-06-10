module Get_Dst_Id() begin
	<font color="#0070C0">//generate active vertices</font>
	…
end

module Rd_Edge_Off() begin
	<font color="#0070C0">//read edge offsets of each active vertex from DRAM</font>
	…
end

module Rd_Edge_Info() begin
	<font color="#0070C0">//read edges of each active vertex from DRAM</font>
	…
end

module Edge_Info_Preprocess() begin
	<font color="#0070C0">//generate data for accumulator</font>
	…
end

module Rd_Src_P() begin
	<font color="#0070C0">//read properties of neighboring vertices from BRAM</font>
	…
end

module Edge_Process() begin
	<font color="#0070C0">//process vertex and edge data</font>
	…
end

module Parallel_Accumulator() begin
	<font color="#0070C0">//parallel accumulation based on prefix-sum</font>
	const PIPE_NUM = 32, LEVEL_NUM = log2(PIPE_NUM);
	reg Update[LEVEL_NUM + 1][PIPE_NUM];

	<font color="#FF0000">for (k = 1; k < =LEVEL_NUM; k ++) begin
	// 当前层白色格与上一层格子的连接关系
		for (i = 0; i < PIPE_NUM; i += pow(2, k)) begin
			for (j = 0; j < pow(2, k - 1); j ++) begin
				Parallel_Accumulator_Transfer(Update[k - 1][i + j], Update[k][i + j]);
			end
		end
	// 当前层灰色格与上一层格子的连接关系
		for (i = pow(2, k - 1); i < PIPE_NUM; i += pow(2, k)) begin
			for (j = 0; j < pow(2, k – 1); j ++) begin
				Parallel_Accumulator_Adder(Update[k - 1][i - 1], Update[k - 1][i + j]. Update[k][i + j]);
			end
		end
	end</font>
end

module Parallel_Accumulator_Transfer() begin
	Dout.Value = Din.Value;
	Dout.ID = Dout.ID;
end

module Parallel_Accumulator_Adder() begin
	if (Din1.ID == Din2.ID) begin
		Dout.Value = Din1.Value <font color="#FF0000">⊕</font> Din2.Value;
		Dout.ID = Din2.ID;
	end
	else begin
		Dout.Value = Din2.Value;
		Dout.ID = Din2.ID;
	end
end

module Multiplexer() begin
	<font color="#0070C0">//select accumulated data</font>
	const PIPE_NUM = 32, LEVEL_NUM = log2(PIPE_NUM);
	
	for (i = 0; i < PIPE_NUM; i ++ ) begin
	<font color="#FF0000">// 多路选择器
		Dout[i] = Update[LEVEL_NUM][Edge_Offset[i].R % PIPE_NUM];</font>
		Dout_Valid[i] = Edge_Offset_Valid[i];
	end
end

module Sequential_Accumulator() begin
	<font color="#0070C0">//sequential accumulation based on updating locality</font>
	const PIPE_NUM = 32, LEVEL_NUM = log2(PIPE_NUM);
	reg Cached_Data[PIPE_NUM];
	
	for (i = 0; i < PIPE_NUM; i ++) begin
		if (Cached_Data[i].ID == Din[i].ID) begin
			Dout[i] = 0;
			Dout_Valid[i] = FALSE;
			Cached_Data[i].Value = Cached_Data[i].Value ⊕ Din[i].Value;
		end
		else begin
			Dout[i] = Cache_Data[i];
			Dout_Valid[i] = TRUE;
			Cache_Data[i] = Din[i];
		end
	end
end

