// BFS process.c
#include "accumulator.h"

void edge_process(int clk, int rst,
                  int front_src_p[16], int front_src_p_mask[16], int front_tot_acc_id[16], int front_src_p_valid,
                  int front_dst_id_1, int front_src_p_mask_r_1, int front_dst_data_valid_1,
                  int front_dst_id_2, int front_src_p_mask_r_2, int front_dst_data_valid_2,
                  int front_dst_id_3, int front_src_p_mask_r_3, int front_dst_data_valid_3,
                  int front_dst_id_4, int front_src_p_mask_r_4, int front_dst_data_valid_4,
                  
                  int *src_p, int *tot_acc_id, int *src_p_valid,
                  int *dst_id_1, int *src_p_mask_r_1, int *dst_data_valid_1,
                  int *dst_id_2, int *src_p_mask_r_2, int *dst_data_valid_2,
                  int *dst_id_3, int *src_p_mask_r_3, int *dst_data_valid_3,
                  int *dst_id_4, int *src_p_mask_r_4, int *dst_data_valid_4)
{
    void edge_process_edge(int clk, int rst,
                           int front_src_p[16], int front_src_p_mask[16], int front_tot_acc_id[16], int front_src_p_valid,
                           
                           int *src_p, int *tot_acc_id, int *src_p_valid);

    void edge_process_vertex_single(int clk, int rst,
                                    int front_dst_id, int front_src_p_mask_r, int front_dst_data_valid,
                                    
                                    int *dst_id, int *src_p_mask_r, int *dst_data_valid);

    edge_process_edge(clk, rst,
                      front_src_p, front_src_p_mask, front_tot_acc_id, front_src_p_valid,
                      
                      src_p, tot_acc_id, src_p_valid);

    edge_process_vertex_single(clk, rst,
                               front_dst_id_1, front_src_p_mask_r_1, front_dst_data_valid_1,
                               
                               dst_id_1, src_p_mask_r_1, dst_data_valid_1);

    edge_process_vertex_single(clk, rst,
                               front_dst_id_2, front_src_p_mask_r_2, front_dst_data_valid_2,
                               
                               dst_id_2, src_p_mask_r_2, dst_data_valid_2);

    edge_process_vertex_single(clk, rst,
                               front_dst_id_3, front_src_p_mask_r_3, front_dst_data_valid_3,
                               
                               dst_id_3, src_p_mask_r_3, dst_data_valid_3);

    edge_process_vertex_single(clk, rst,
                               front_dst_id_4, front_src_p_mask_r_4, front_dst_data_valid_4,
                               
                               dst_id_4, src_p_mask_r_4, dst_data_valid_4);
}

void edge_process_edge(int clk, int rst,
                       int front_src_p[16], int front_src_p_mask[16], int front_tot_acc_id[16], int front_src_p_valid,
                       
                       int *src_p, int *tot_acc_id, int *src_p_valid)
{
    if (rst) {
        for (int i = 0; i < 16; i ++) src_p[i] = MAX_SRC_P;
        for (int i = 0; i < 16; i ++) tot_acc_id[i] = 16;
        *src_p_valid = 0;
    } else {
        if (front_src_p_valid) {
            for (int i = 0; i < 16; i ++) {
                if (front_src_p_mask[i] && front_src_p[i] != MAX_SRC_P) {
                    src_p[i] = front_src_p[i] + 1;
                } else {
                    src_p[i] = MAX_SRC_P;
                }
            }
            for (int i = 0; i < 16; i ++) tot_acc_id[i] = front_tot_acc_id[i];
            *src_p_valid = 1;
        } else {
            for (int i = 0; i < 16; i ++) src_p[i] = MAX_SRC_P;
            for (int i = 0; i < 16; i ++) tot_acc_id[i] = 16;
            *src_p_valid = 0;
        }
    }
}

void edge_process_vertex_single(int clk, int rst,
                                int front_dst_id, int front_src_p_mask_r, int front_dst_data_valid,
                                
                                int *dst_id, int *src_p_mask_r, int *dst_data_valid)
{
    if (rst) {
        *dst_id = 0;
        *src_p_mask_r = 0;
        *dst_data_valid = 0;
    } else {
        if (front_dst_data_valid) {
            *dst_id = front_dst_id;
            *src_p_mask_r = front_src_p_mask_r;
            *dst_data_valid = front_dst_data_valid;
        } else {
            *dst_id = 0;
            *src_p_mask_r = 0;
            *dst_data_valid = 0;
        }
    }
}
