// SSSP apply.c
#include "data_width.h"

void sequential_accumulator(int clk, int rst,
							int front_dst_id_1, int front_src_p_1, int front_dst_data_valid_1,
							int front_dst_id_2, int front_src_p_2, int front_dst_data_valid_2,
							int front_dst_id_3, int front_src_p_3, int front_dst_data_valid_3,
							int front_dst_id_4, int front_src_p_4, int front_dst_data_valid_4,

							int *wb_dst_addr_1, int *wb_dst_p_1, int *wb_dst_data_valid_1,
							int *wb_dst_addr_2, int *wb_dst_p_2, int *wb_dst_data_valid_2,
							int *wb_dst_addr_3, int *wb_dst_p_3, int *wb_dst_data_valid_3,
							int *wb_dst_addr_4, int *wb_dst_p_4, int *wb_dst_data_valid_4)
{
	/**Declaration**/
	void sequential_accumulator_vertex_single(	int pipe_i, int rst,
												int front_dst_id, int front_src_p, int front_dst_data_valid,

												int *wb_dst_addr, int *wb_dst_p, int *wb_dst_data_valid);

	/**Instantiation**/
	sequential_accumulator_vertex_single(	0, rst,
											front_dst_id_1, front_src_p_1, front_dst_data_valid_1,

											wb_dst_addr_1, wb_dst_p_1, wb_dst_data_valid_1);

	sequential_accumulator_vertex_single(	1, rst,
											front_dst_id_2, front_src_p_2, front_dst_data_valid_2,

											wb_dst_addr_2, wb_dst_p_2, wb_dst_data_valid_2);

	sequential_accumulator_vertex_single(	2, rst,
											front_dst_id_3, front_src_p_3, front_dst_data_valid_3,

											wb_dst_addr_3, wb_dst_p_3, wb_dst_data_valid_3);

	sequential_accumulator_vertex_single(	3, rst,
											front_dst_id_4, front_src_p_4, front_dst_data_valid_4,

											wb_dst_addr_4, wb_dst_p_4, wb_dst_data_valid_4);

}

/**Sub Function**/
void sequential_accumulator_vertex_single(	int pipe_i, int rst,
											int front_dst_id, int front_src_p, int front_dst_data_valid,

											int *wb_dst_addr, int *wb_dst_p, int *wb_dst_data_valid)
{
	static int now_dst_id[PIPE_NUM];
	static int now_dst_p[PIPE_NUM];
	static int DST_ID_ST[PIPE_NUM] = { DST_ID_ST_1, DST_ID_ST_2, DST_ID_ST_3, DST_ID_ST_4 };

	if (rst) {
		*wb_dst_addr = 0;
		*wb_dst_p = 0;
		*wb_dst_data_valid = 0;
	}
	else {
		if (front_dst_data_valid) {
			if ((now_dst_id[pipe_i] != front_dst_id) && (now_dst_id[pipe_i] != ROOT_ID)) {
				*wb_dst_addr = now_dst_id[pipe_i];
				*wb_dst_p = now_dst_p[pipe_i];
				*wb_dst_data_valid = 1;
			}
			else {
				*wb_dst_addr = 0;
				*wb_dst_p = 0;
				*wb_dst_data_valid = 0;
			}

			//for debug
			if ((now_dst_id[pipe_i] != front_dst_id) && (now_dst_id[pipe_i] == ROOT_ID)) {
				//if (*wb_dst_p != 0) cout << "might be error in sequential_accumulator with now_dst_p = " << now_dst_p[pipe_i] << " and pipe_i = " << pipe_i << endl;
				*wb_dst_data_valid = 1;
			}
		}
		else {
			*wb_dst_addr = 0;
			*wb_dst_p = 0;
			*wb_dst_data_valid = 0;
		}
	}

	if (rst) {
		now_dst_id[pipe_i] = DST_ID_ST[pipe_i];
		now_dst_p[pipe_i] = MAX_SRC_P;
	}
	else {
		if (front_dst_data_valid) {
			if (now_dst_id[pipe_i] == front_dst_id) {
				if (front_src_p < now_dst_p[pipe_i]) {
					now_dst_p[pipe_i] = front_src_p;
				}
			}
			else {
				now_dst_id[pipe_i] = front_dst_id;
				now_dst_p[pipe_i] = front_src_p;
			}
		}
	}
}

