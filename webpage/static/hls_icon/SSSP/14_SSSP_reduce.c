// SSSP reduce.c
#include "data_width.h"

void parallel_accumulator(	int clk, int rst,
							int front_src_p[16], int front_acc_id[16], int front_src_p_valid,
							int front_dst_id_1, int front_src_p_mask_r_1, int front_dst_data_valid_1,
							int front_dst_id_2, int front_src_p_mask_r_2, int front_dst_data_valid_2,
							int front_dst_id_3, int front_src_p_mask_r_3, int front_dst_data_valid_3,
							int front_dst_id_4, int front_src_p_mask_r_4, int front_dst_data_valid_4,

							int *src_p, int *src_p_valid,
							int *dst_id_1, int *src_p_mask_r_1, int *dst_data_valid_1,
							int *dst_id_2, int *src_p_mask_r_2, int *dst_data_valid_2,
							int *dst_id_3, int *src_p_mask_r_3, int *dst_data_valid_3,
							int *dst_id_4, int *src_p_mask_r_4, int *dst_data_valid_4)
{
	/**Declaration**/
	void parallel_accumulator_edge(	int rst,
									int front_src_p[16], int front_acc_id[16], int front_src_p_valid,

									int *src_p, int *src_p_valid);

	void parallel_accumulator_vertex_single(int pipe_i, int rst,
											int front_dst_id, int front_src_p_mask_r, int front_dst_data_valid,

											int *dst_id, int *src_p_mask_r, int *dst_data_valid);

	/**Instantiation**/
	parallel_accumulator_edge(	rst,
								front_src_p, front_acc_id, front_src_p_valid,

								src_p, src_p_valid);

	parallel_accumulator_vertex_single(	0, rst,
										front_dst_id_1, front_src_p_mask_r_1, front_dst_data_valid_1,

										dst_id_1, src_p_mask_r_1, dst_data_valid_1);

	parallel_accumulator_vertex_single(	1, rst,
										front_dst_id_2, front_src_p_mask_r_2, front_dst_data_valid_2,

										dst_id_2, src_p_mask_r_2, dst_data_valid_2);

	parallel_accumulator_vertex_single(	2, rst,
										front_dst_id_3, front_src_p_mask_r_3, front_dst_data_valid_3,

										dst_id_3, src_p_mask_r_3, dst_data_valid_3);

	parallel_accumulator_vertex_single(	3, rst,
										front_dst_id_4, front_src_p_mask_r_4, front_dst_data_valid_4,

										dst_id_4, src_p_mask_r_4, dst_data_valid_4);
}

/**Sub Function**/
void parallel_accumulator_edge(	int rst,
								int front_src_p[16], int front_acc_id[16], int front_src_p_valid,

								int *src_p, int *src_p_valid)
{
	static int src_p_1[16], src_p_2[16], src_p_3[16], src_p_4[16];//ÿһ������
	static int acc_id_1[16], acc_id_2[16], acc_id_3[16], acc_id_4[16];//ÿһ�ζ�Ӧ��id
	static int src_p_valid_1, src_p_valid_2, src_p_valid_3, src_p_valid_4;

	void parallel_accumulator_edge_reg(	int rst, int din, int idin,
										int &dout, int &idout);

	void parallel_accumulator_edge_adder(	int rst, int din_1, int idin_1, int din_2, int idin_2,
											int &dout, int &idout);
	//the 4th floor
	if (rst) {
		for (int i = 0; i < 16; ++i) src_p_4[i] = 0;
		src_p_valid_4 = 0;
	}
	else {
		parallel_accumulator_edge_reg(rst, src_p_3[0], acc_id_3[0], src_p_4[0], acc_id_4[0]);
		parallel_accumulator_edge_reg(rst, src_p_3[1], acc_id_3[1], src_p_4[1], acc_id_4[1]);
		parallel_accumulator_edge_reg(rst, src_p_3[2], acc_id_3[2], src_p_4[2], acc_id_4[2]);
		parallel_accumulator_edge_reg(rst, src_p_3[3], acc_id_3[3], src_p_4[3], acc_id_4[3]);
		parallel_accumulator_edge_reg(rst, src_p_3[4], acc_id_3[4], src_p_4[4], acc_id_4[4]);
		parallel_accumulator_edge_reg(rst, src_p_3[5], acc_id_3[5], src_p_4[5], acc_id_4[5]);
		parallel_accumulator_edge_reg(rst, src_p_3[6], acc_id_3[6], src_p_4[6], acc_id_4[6]);
		parallel_accumulator_edge_reg(rst, src_p_3[7], acc_id_3[7], src_p_4[7], acc_id_4[7]);
		parallel_accumulator_edge_adder(rst, src_p_3[7], acc_id_3[7], src_p_3[8], acc_id_3[8], src_p_4[8], acc_id_4[8]);
		parallel_accumulator_edge_adder(rst, src_p_3[7], acc_id_3[7], src_p_3[9], acc_id_3[9], src_p_4[9], acc_id_4[9]);
		parallel_accumulator_edge_adder(rst, src_p_3[7], acc_id_3[7], src_p_3[10], acc_id_3[10], src_p_4[10], acc_id_4[10]);
		parallel_accumulator_edge_adder(rst, src_p_3[7], acc_id_3[7], src_p_3[11], acc_id_3[11], src_p_4[11], acc_id_4[11]);
		parallel_accumulator_edge_adder(rst, src_p_3[7], acc_id_3[7], src_p_3[12], acc_id_3[12], src_p_4[12], acc_id_4[12]);
		parallel_accumulator_edge_adder(rst, src_p_3[7], acc_id_3[7], src_p_3[13], acc_id_3[13], src_p_4[13], acc_id_4[13]);
		parallel_accumulator_edge_adder(rst, src_p_3[7], acc_id_3[7], src_p_3[14], acc_id_3[14], src_p_4[14], acc_id_4[14]);
		parallel_accumulator_edge_adder(rst, src_p_3[7], acc_id_3[7], src_p_3[15], acc_id_3[15], src_p_4[15], acc_id_4[15]);
		src_p_valid_4 = src_p_valid_3;
	}

	//the 3rd floor
	if (rst) {
		for (int i = 0; i < 16; ++i) src_p_3[i] = 0;
		src_p_valid_3 = 0;
	}
	else {
		parallel_accumulator_edge_reg(rst, src_p_2[0], acc_id_2[0], src_p_3[0], acc_id_3[0]);
		parallel_accumulator_edge_reg(rst, src_p_2[1], acc_id_2[1], src_p_3[1], acc_id_3[1]);
		parallel_accumulator_edge_reg(rst, src_p_2[2], acc_id_2[2], src_p_3[2], acc_id_3[2]);
		parallel_accumulator_edge_reg(rst, src_p_2[3], acc_id_2[3], src_p_3[3], acc_id_3[3]);
		parallel_accumulator_edge_adder(rst, src_p_2[3], acc_id_2[3], src_p_2[4], acc_id_2[4], src_p_3[4], acc_id_3[4]);
		parallel_accumulator_edge_adder(rst, src_p_2[3], acc_id_2[3], src_p_2[5], acc_id_2[5], src_p_3[5], acc_id_3[5]);
		parallel_accumulator_edge_adder(rst, src_p_2[3], acc_id_2[3], src_p_2[6], acc_id_2[6], src_p_3[6], acc_id_3[6]);
		parallel_accumulator_edge_adder(rst, src_p_2[3], acc_id_2[3], src_p_2[7], acc_id_2[7], src_p_3[7], acc_id_3[7]);
		parallel_accumulator_edge_reg(rst, src_p_2[8], acc_id_2[8], src_p_3[8], acc_id_3[8]);
		parallel_accumulator_edge_reg(rst, src_p_2[9], acc_id_2[9], src_p_3[9], acc_id_3[9]);
		parallel_accumulator_edge_reg(rst, src_p_2[10], acc_id_2[10], src_p_3[10], acc_id_3[10]);
		parallel_accumulator_edge_reg(rst, src_p_2[11], acc_id_2[11], src_p_3[11], acc_id_3[11]);
		parallel_accumulator_edge_adder(rst, src_p_2[11], acc_id_2[11], src_p_2[12], acc_id_2[12], src_p_3[12], acc_id_3[12]);
		parallel_accumulator_edge_adder(rst, src_p_2[11], acc_id_2[11], src_p_2[13], acc_id_2[13], src_p_3[13], acc_id_3[13]);
		parallel_accumulator_edge_adder(rst, src_p_2[11], acc_id_2[11], src_p_2[14], acc_id_2[14], src_p_3[14], acc_id_3[14]);
		parallel_accumulator_edge_adder(rst, src_p_2[11], acc_id_2[11], src_p_2[15], acc_id_2[15], src_p_3[15], acc_id_3[15]);
		src_p_valid_3 = src_p_valid_2;
	}

	//the 2nd floor
	if (rst) {
		for (int i = 0; i < 16; ++i) src_p_2[i] = 0;
		src_p_valid_2 = 0;
	}
	else {
		parallel_accumulator_edge_reg(rst, src_p_1[0], acc_id_1[0], src_p_2[0], acc_id_2[0]);
		parallel_accumulator_edge_reg(rst, src_p_1[1], acc_id_1[1], src_p_2[1], acc_id_2[1]);
		parallel_accumulator_edge_adder(rst, src_p_1[1], acc_id_1[1], src_p_1[2], acc_id_1[2], src_p_2[2], acc_id_2[2]);
		parallel_accumulator_edge_adder(rst, src_p_1[1], acc_id_1[1], src_p_1[3], acc_id_1[3], src_p_2[3], acc_id_2[3]);
		parallel_accumulator_edge_reg(rst, src_p_1[4], acc_id_1[4], src_p_2[4], acc_id_2[4]);
		parallel_accumulator_edge_reg(rst, src_p_1[5], acc_id_1[5], src_p_2[5], acc_id_2[5]);
		parallel_accumulator_edge_adder(rst, src_p_1[5], acc_id_1[5], src_p_1[6], acc_id_1[6], src_p_2[6], acc_id_2[6]);
		parallel_accumulator_edge_adder(rst, src_p_1[5], acc_id_1[5], src_p_1[7], acc_id_1[7], src_p_2[7], acc_id_2[7]);
		parallel_accumulator_edge_reg(rst, src_p_1[8], acc_id_1[8], src_p_2[8], acc_id_2[8]);
		parallel_accumulator_edge_reg(rst, src_p_1[9], acc_id_1[9], src_p_2[9], acc_id_2[9]);
		parallel_accumulator_edge_adder(rst, src_p_1[9], acc_id_1[9], src_p_1[10], acc_id_1[10], src_p_2[10], acc_id_2[10]);
		parallel_accumulator_edge_adder(rst, src_p_1[9], acc_id_1[9], src_p_1[11], acc_id_1[11], src_p_2[11], acc_id_2[11]);
		parallel_accumulator_edge_reg(rst, src_p_1[12], acc_id_1[12], src_p_2[12], acc_id_2[12]);
		parallel_accumulator_edge_reg(rst, src_p_1[13], acc_id_1[13], src_p_2[13], acc_id_2[13]);
		parallel_accumulator_edge_adder(rst, src_p_1[13], acc_id_1[13], src_p_1[14], acc_id_1[14], src_p_2[14], acc_id_2[14]);
		parallel_accumulator_edge_adder(rst, src_p_1[13], acc_id_1[13], src_p_1[15], acc_id_1[15], src_p_2[15], acc_id_2[15]);
		src_p_valid_2 = src_p_valid_1;
	}

	//the 1st floor
	if (rst) {
		for (int i = 0; i < 16; ++i) src_p_1[i] = 0;
		src_p_valid_1 = 0;
	}
	else {
		parallel_accumulator_edge_reg(rst, front_src_p[0], front_acc_id[0], src_p_1[0], acc_id_1[0]);
		parallel_accumulator_edge_adder(rst, front_src_p[0], front_acc_id[0], front_src_p[1], front_acc_id[1], src_p_1[1], acc_id_1[1]);
		parallel_accumulator_edge_reg(rst, front_src_p[2], front_acc_id[2], src_p_1[2], acc_id_1[2]);
		parallel_accumulator_edge_adder(rst, front_src_p[2], front_acc_id[2], front_src_p[3], front_acc_id[3], src_p_1[3], acc_id_1[3]);
		parallel_accumulator_edge_reg(rst, front_src_p[4], front_acc_id[4], src_p_1[4], acc_id_1[4]);
		parallel_accumulator_edge_adder(rst, front_src_p[4], front_acc_id[4], front_src_p[5], front_acc_id[5], src_p_1[5], acc_id_1[5]);
		parallel_accumulator_edge_reg(rst, front_src_p[6], front_acc_id[6], src_p_1[6], acc_id_1[6]);
		parallel_accumulator_edge_adder(rst, front_src_p[6], front_acc_id[6], front_src_p[7], front_acc_id[7], src_p_1[7], acc_id_1[7]);
		parallel_accumulator_edge_reg(rst, front_src_p[8], front_acc_id[8], src_p_1[8], acc_id_1[8]);
		parallel_accumulator_edge_adder(rst, front_src_p[8], front_acc_id[8], front_src_p[9], front_acc_id[9], src_p_1[9], acc_id_1[9]);
		parallel_accumulator_edge_reg(rst, front_src_p[10], front_acc_id[10], src_p_1[10], acc_id_1[10]);
		parallel_accumulator_edge_adder(rst, front_src_p[10], front_acc_id[10], front_src_p[11], front_acc_id[11], src_p_1[11], acc_id_1[11]);
		parallel_accumulator_edge_reg(rst, front_src_p[12], front_acc_id[12], src_p_1[12], acc_id_1[12]);
		parallel_accumulator_edge_adder(rst, front_src_p[12], front_acc_id[12], front_src_p[13], front_acc_id[13], src_p_1[13], acc_id_1[13]);
		parallel_accumulator_edge_reg(rst, front_src_p[14], front_acc_id[14], src_p_1[14], acc_id_1[14]);
		parallel_accumulator_edge_adder(rst, front_src_p[14], front_acc_id[14], front_src_p[15], front_acc_id[15], src_p_1[15], acc_id_1[15]);
		src_p_valid_1 = front_src_p_valid;
	}

	for (int i = 0; i < 16; ++i) src_p[i] = src_p_4[i];
	*src_p_valid = src_p_valid_4;
}

void parallel_accumulator_edge_reg(	int rst, int din, int idin,
									
									int &dout, int &idout)
{
	if (rst) {
		dout = 0;
		idout = 0;
	}
	else {
		dout = din;
		idout = idin;
	}
}

void parallel_accumulator_edge_adder(	int rst, int din_1, int idin_1, int din_2, int idin_2,
			
										int &dout, int &idout)
{
	if (rst) {
		dout = 0;
		idout = 0;
	}
	else {
		if (idin_1 == idin_2 && din_1 < din_2) {
			dout = din_1;
			idout = idin_1;
		}
		else {
			dout = din_2;
			idout = idin_2;
		}
	}
}

void parallel_accumulator_vertex_single(int pipe_i, int rst,
										int front_dst_id, int front_src_p_mask_r, int front_dst_data_valid,

										int *dst_id, int *src_p_mask_r, int *dst_data_valid)
{
	static int dst_id_1[PIPE_NUM], dst_id_2[PIPE_NUM], dst_id_3[PIPE_NUM], dst_id_4[PIPE_NUM];
	static int src_p_mask_r_1[PIPE_NUM], src_p_mask_r_2[PIPE_NUM], src_p_mask_r_3[PIPE_NUM], src_p_mask_r_4[PIPE_NUM];
	static int dst_data_valid_1[PIPE_NUM], dst_data_valid_2[PIPE_NUM], dst_data_valid_3[PIPE_NUM], dst_data_valid_4[PIPE_NUM];

	//the 4th floor
	if (rst) {
		dst_id_4[pipe_i] = 0;
		src_p_mask_r_4[pipe_i] = 0;
		dst_data_valid_4[pipe_i] = 0;
	}
	else {
		dst_id_4[pipe_i] = dst_id_3[pipe_i];
		src_p_mask_r_4[pipe_i] = src_p_mask_r_3[pipe_i];
		dst_data_valid_4[pipe_i] = dst_data_valid_3[pipe_i];
	}

	//the 3rd floor
	if (rst) {
		dst_id_3[pipe_i] = 0;
		src_p_mask_r_3[pipe_i] = 0;
		dst_data_valid_3[pipe_i] = 0;
	}
	else {
		dst_id_3[pipe_i] = dst_id_2[pipe_i];
		src_p_mask_r_3[pipe_i] = src_p_mask_r_2[pipe_i];
		dst_data_valid_3[pipe_i] = dst_data_valid_2[pipe_i];
	}

	//the 2nd floor
	if (rst) {
		dst_id_2[pipe_i] = 0;
		src_p_mask_r_2[pipe_i] = 0;
		dst_data_valid_2[pipe_i] = 0;
	}
	else {
		dst_id_2[pipe_i] = dst_id_1[pipe_i];
		src_p_mask_r_2[pipe_i] = src_p_mask_r_1[pipe_i];
		dst_data_valid_2[pipe_i] = dst_data_valid_1[pipe_i];
	}

	//the 1st floor
	if (rst) {
		dst_id_1[pipe_i] = 0;
		src_p_mask_r_1[pipe_i] = 0;
		dst_data_valid_1[pipe_i] = 0;
	}
	else {
		dst_id_1[pipe_i] = front_dst_id;
		src_p_mask_r_1[pipe_i] = front_src_p_mask_r;
		dst_data_valid_1[pipe_i] = front_dst_data_valid;
	}

	*dst_id = dst_id_4[pipe_i];
	*src_p_mask_r = src_p_mask_r_4[pipe_i];
	*dst_data_valid = dst_data_valid_4[pipe_i];
}
