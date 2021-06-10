// BFS apply.c
#include "accumulator.h"
#include <stdio.h>

void sequential_accumulator(int clk, int rst,
                            int front_dst_id_1, int front_src_1, int front_dst_data_valid_1,
                            int front_dst_id_2, int front_src_2, int front_dst_data_valid_2,
                            int front_dst_id_3, int front_src_3, int front_dst_data_valid_3,
                            int front_dst_id_4, int front_src_4, int front_dst_data_valid_4,

                            int *wb_dst_addr_1, int *wb_dst_data_1, int *wb_dst_data_valid_1,
                            int *wb_dst_addr_2, int *wb_dst_data_2, int *wb_dst_data_valid_2,
                            int *wb_dst_addr_3, int *wb_dst_data_3, int *wb_dst_data_valid_3,
                            int *wb_dst_addr_4, int *wb_dst_data_4, int *wb_dst_data_valid_4)
{
    void sequential_accumulator_pipeline(int clk, int rst, int pipe_num,
                                         int front_dst_id, int front_src, int front_dst_data_valid,
                                         
                                         int *wb_dst_addr, int *wb_dst_data, int *wb_dst_dst_data_valid);

    sequential_accumulator_pipeline(clk, rst, 0,
                                    front_dst_id_1, front_src_1, front_dst_data_valid_1,
                                    
                                    wb_dst_addr_1, wb_dst_data_1, wb_dst_data_valid_1);

    sequential_accumulator_pipeline(clk, rst, 1,
                                    front_dst_id_2, front_src_2, front_dst_data_valid_2,
                                    
                                    wb_dst_addr_2, wb_dst_data_2, wb_dst_data_valid_2);

    sequential_accumulator_pipeline(clk, rst, 2,
                                    front_dst_id_3, front_src_3, front_dst_data_valid_3,
                                    
                                    wb_dst_addr_3, wb_dst_data_3, wb_dst_data_valid_3);

    sequential_accumulator_pipeline(clk, rst, 3,
                                    front_dst_id_4, front_src_4, front_dst_data_valid_4,
                                    
                                    wb_dst_addr_4, wb_dst_data_4, wb_dst_data_valid_4);
}

void sequential_accumulator_pipeline(int clk, int rst, int pipe_num,
                                     int front_dst_id, int front_src, int front_dst_data_valid,
                                     
                                     int *wb_dst_addr, int *wb_dst_data, int *wb_dst_data_valid)
{
    static int now_dst_addr[PIPE_NUM], now_dst_data[PIPE_NUM];

    if (rst) {
        *wb_dst_addr = 0;
        *wb_dst_data = 0;
        *wb_dst_data_valid = 0;
    } else if (front_dst_data_valid) {
        if (now_dst_addr[pipe_num] != ROOT_ID) {
            if (now_dst_addr[pipe_num] != front_dst_id) {
                *wb_dst_addr = now_dst_addr[pipe_num];
                *wb_dst_data = now_dst_data[pipe_num];
                *wb_dst_data_valid = 1;
                now_dst_addr[pipe_num] = front_dst_id;
                now_dst_data[pipe_num] = front_src;
            } else {
                *wb_dst_addr = 0;
                *wb_dst_data = 0;
                *wb_dst_data_valid = 0;
                if (front_src < now_dst_data[pipe_num]) {
                    now_dst_data[pipe_num] = front_src;
                }
            }
        } else {
            *wb_dst_addr = 0;
            *wb_dst_data = 0;
            *wb_dst_data_valid = 0;
            now_dst_addr[pipe_num] = front_dst_id;
            now_dst_data[pipe_num] = front_src;
        }
    } else {
        *wb_dst_addr = 0;
        *wb_dst_data = 0;
        *wb_dst_data_valid = 0;
    }

}
