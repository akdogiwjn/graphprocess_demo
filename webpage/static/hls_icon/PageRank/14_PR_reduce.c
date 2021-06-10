//PR reduce.c
#include "accumulator.h"
void parallel_accumulator(int clk, int rst,
                          float front_src[16], int front_acc_id[16], int front_src_valid,
                          int front_dst_id_1, int front_src_mask_1, int front_dst_data_valid_1,
                          int front_dst_id_2, int front_src_mask_2, int front_dst_data_valid_2,
                          int front_dst_id_3, int front_src_mask_3, int front_dst_data_valid_3,
                          int front_dst_id_4, int front_src_mask_4, int front_dst_data_valid_4,

                          float src[16], int *src_valid,
                          int *dst_id_1, int *src_mask_1, int *dst_data_valid_1,
                          int *dst_id_2, int *src_mask_2, int *dst_data_valid_2,
                          int *dst_id_3, int *src_mask_3, int *dst_data_valid_3,
                          int *dst_id_4, int *src_mask_4, int *dst_data_valid_4)
{
    // In this pipeline, the task is accumulate updates of 16 edges and pass some vetex informations to the next pipeline.
    void parallel_accumulator_update(int clk, int rst,
                                     float front_src[16], int front_acc_id[16], int front_src_valid, 
                                     
                                     float src[16], int *src_valid);
    
    void parallel_accumulator_vertex_pipeline(int clk, int rst, int pipe_i,
                                              int front_dst_id, int front_src_mask, int front_dst_data_valid,
                                              
                                              int *dst_id, int *src_mask, int *dst_data_valid);
                                
    parallel_accumulator_update(clk, rst,
                                front_src, front_acc_id, front_src_valid,
                                
                                src, src_valid);

    parallel_accumulator_vertex_pipeline(clk, rst, 0,
                                         front_dst_id_1, front_src_mask_1, front_dst_data_valid_1,
                                         
                                         dst_id_1, src_mask_1, dst_data_valid_1);

    parallel_accumulator_vertex_pipeline(clk, rst, 1,
                                         front_dst_id_2, front_src_mask_2, front_dst_data_valid_2,
                                         
                                         dst_id_2, src_mask_2, dst_data_valid_2);

    parallel_accumulator_vertex_pipeline(clk, rst, 2,
                                         front_dst_id_3, front_src_mask_3, front_dst_data_valid_3,
                                         
                                         dst_id_3, src_mask_3, dst_data_valid_3);

    parallel_accumulator_vertex_pipeline(clk, rst, 3,
                                         front_dst_id_4, front_src_mask_4, front_dst_data_valid_4,
                                         
                                         dst_id_4, src_mask_4, dst_data_valid_4);
}

// prefix sum
void parallel_accumulator_update(int clk, int rst,
                                 float front_src[16], int front_acc_id[16], int front_src_valid,
                                 
                                 float src[16], int *src_valid)
{
    // four register groups for four levels of prefix network
    static float src_level_1[16], src_level_2[16], src_level_3[16], src_level_4[16];
    static int acc_id_level_1[16], src_level_1_valid;
    static int acc_id_level_2[16], src_level_2_valid;
    static int acc_id_level_3[16], src_level_3_valid;
    static int acc_id_level_4[16], src_level_4_valid;

    void parallel_accumulator_update_reg(int clk, int rst,
                                         float din, int idin,
                                         
                                         float &dout, int &idout);

    void parallel_accumulator_update_adder(int clk, int rst,
                                           float din_1, int idin_1, float din_2, int idin_2,
                                           
                                           float &dout, int &idout);

    // level 4
    if (rst) {
        for (int i = 0; i < 16; i ++) src_level_4[i] = 0;
        src_level_4_valid = 0;
    } else {
        parallel_accumulator_update_reg(clk, rst, src_level_3[0], acc_id_level_3[0], src_level_4[0], acc_id_level_4[0]);
        parallel_accumulator_update_reg(clk, rst, src_level_3[1], acc_id_level_3[1], src_level_4[1], acc_id_level_4[1]);
        parallel_accumulator_update_reg(clk, rst, src_level_3[2], acc_id_level_3[2], src_level_4[2], acc_id_level_4[2]);
        parallel_accumulator_update_reg(clk, rst, src_level_3[3], acc_id_level_3[3], src_level_4[3], acc_id_level_4[3]);
        parallel_accumulator_update_reg(clk, rst, src_level_3[4], acc_id_level_3[4], src_level_4[4], acc_id_level_4[4]);
        parallel_accumulator_update_reg(clk, rst, src_level_3[5], acc_id_level_3[5], src_level_4[5], acc_id_level_4[5]);
        parallel_accumulator_update_reg(clk, rst, src_level_3[6], acc_id_level_3[6], src_level_4[6], acc_id_level_4[6]);
        parallel_accumulator_update_reg(clk, rst, src_level_3[7], acc_id_level_3[7], src_level_4[7], acc_id_level_4[7]);

        parallel_accumulator_update_adder(clk, rst, src_level_3[7], acc_id_level_3[7], src_level_3[8], acc_id_level_3[8], src_level_4[8], acc_id_level_4[8]);
        parallel_accumulator_update_adder(clk, rst, src_level_3[7], acc_id_level_3[7], src_level_3[9], acc_id_level_3[9], src_level_4[9], acc_id_level_4[9]);
        parallel_accumulator_update_adder(clk, rst, src_level_3[7], acc_id_level_3[7], src_level_3[10], acc_id_level_3[10], src_level_4[10], acc_id_level_4[10]);
        parallel_accumulator_update_adder(clk, rst, src_level_3[7], acc_id_level_3[7], src_level_3[11], acc_id_level_3[11], src_level_4[11], acc_id_level_4[11]);
        parallel_accumulator_update_adder(clk, rst, src_level_3[7], acc_id_level_3[7], src_level_3[12], acc_id_level_3[12], src_level_4[12], acc_id_level_4[12]);
        parallel_accumulator_update_adder(clk, rst, src_level_3[7], acc_id_level_3[7], src_level_3[13], acc_id_level_3[13], src_level_4[13], acc_id_level_4[13]);
        parallel_accumulator_update_adder(clk, rst, src_level_3[7], acc_id_level_3[7], src_level_3[14], acc_id_level_3[14], src_level_4[14], acc_id_level_4[14]);
        parallel_accumulator_update_adder(clk, rst, src_level_3[7], acc_id_level_3[7], src_level_3[15], acc_id_level_3[15], src_level_4[15], acc_id_level_4[15]);

        src_level_4_valid = src_level_3_valid;
    }

    // level 3
    if (rst) {
        for (int i = 0; i < 16; i ++) src_level_3[i] = 0;
        src_level_3_valid = 0;
    } else {
        parallel_accumulator_update_reg(clk, rst, src_level_2[0], acc_id_level_2[0], src_level_3[0], acc_id_level_3[0]);
        parallel_accumulator_update_reg(clk, rst, src_level_2[1], acc_id_level_2[1], src_level_3[1], acc_id_level_3[1]);
        parallel_accumulator_update_reg(clk, rst, src_level_2[2], acc_id_level_2[2], src_level_3[2], acc_id_level_3[2]);
        parallel_accumulator_update_reg(clk, rst, src_level_2[3], acc_id_level_2[3], src_level_3[3], acc_id_level_3[3]);

        parallel_accumulator_update_adder(clk, rst, src_level_2[3], acc_id_level_2[3], src_level_2[4], acc_id_level_2[4], src_level_3[4], acc_id_level_3[4]);
        parallel_accumulator_update_adder(clk, rst, src_level_2[3], acc_id_level_2[3], src_level_2[5], acc_id_level_2[5], src_level_3[5], acc_id_level_3[5]);
        parallel_accumulator_update_adder(clk, rst, src_level_2[3], acc_id_level_2[3], src_level_2[6], acc_id_level_2[6], src_level_3[6], acc_id_level_3[6]);
        parallel_accumulator_update_adder(clk, rst, src_level_2[3], acc_id_level_2[3], src_level_2[7], acc_id_level_2[7], src_level_3[7], acc_id_level_3[7]);

        parallel_accumulator_update_reg(clk, rst, src_level_2[8], acc_id_level_2[8], src_level_3[8], acc_id_level_3[8]);
        parallel_accumulator_update_reg(clk, rst, src_level_2[9], acc_id_level_2[9], src_level_3[9], acc_id_level_3[9]);
        parallel_accumulator_update_reg(clk, rst, src_level_2[10], acc_id_level_2[10], src_level_3[10], acc_id_level_3[10]);
        parallel_accumulator_update_reg(clk, rst, src_level_2[11], acc_id_level_2[11], src_level_3[11], acc_id_level_3[11]);

        parallel_accumulator_update_adder(clk, rst, src_level_2[11], acc_id_level_2[11], src_level_2[12], acc_id_level_2[12], src_level_3[12], acc_id_level_3[12]);
        parallel_accumulator_update_adder(clk, rst, src_level_2[11], acc_id_level_2[11], src_level_2[13], acc_id_level_2[13], src_level_3[13], acc_id_level_3[13]);
        parallel_accumulator_update_adder(clk, rst, src_level_2[11], acc_id_level_2[11], src_level_2[14], acc_id_level_2[14], src_level_3[14], acc_id_level_3[14]);
        parallel_accumulator_update_adder(clk, rst, src_level_2[11], acc_id_level_2[11], src_level_2[15], acc_id_level_2[15], src_level_3[15], acc_id_level_3[15]);

        src_level_3_valid = src_level_2_valid;
    }

    // level 2
    if (rst) {
        for (int i = 0; i < 16; i ++) src_level_2[i] = 0;
        src_level_2_valid = 0;
    } else {
        parallel_accumulator_update_reg(clk, rst, src_level_1[0], acc_id_level_1[0], src_level_2[0], acc_id_level_2[0]);
        parallel_accumulator_update_reg(clk, rst, src_level_1[1], acc_id_level_1[1], src_level_2[1], acc_id_level_2[1]);

        parallel_accumulator_update_adder(clk, rst, src_level_1[1], acc_id_level_1[1], src_level_1[2], acc_id_level_1[2], src_level_2[2], acc_id_level_2[2]);
        parallel_accumulator_update_adder(clk, rst, src_level_1[1], acc_id_level_1[1], src_level_1[3], acc_id_level_1[3], src_level_2[3], acc_id_level_2[3]);

        parallel_accumulator_update_reg(clk, rst, src_level_1[4], acc_id_level_1[4], src_level_2[4], acc_id_level_2[4]);
        parallel_accumulator_update_reg(clk, rst, src_level_1[5], acc_id_level_1[5], src_level_2[5], acc_id_level_2[5]);

        parallel_accumulator_update_adder(clk, rst, src_level_1[5], acc_id_level_1[5], src_level_1[6], acc_id_level_1[6], src_level_2[6], acc_id_level_2[6]);
        parallel_accumulator_update_adder(clk, rst, src_level_1[5], acc_id_level_1[5], src_level_1[7], acc_id_level_1[7], src_level_2[7], acc_id_level_2[7]);

        parallel_accumulator_update_reg(clk, rst, src_level_1[8], acc_id_level_1[8], src_level_2[8], acc_id_level_2[8]);
        parallel_accumulator_update_reg(clk, rst, src_level_1[9], acc_id_level_1[9], src_level_2[9], acc_id_level_2[9]);

        parallel_accumulator_update_adder(clk, rst, src_level_1[9], acc_id_level_1[9], src_level_1[10], acc_id_level_1[10], src_level_2[10], acc_id_level_2[10]);
        parallel_accumulator_update_adder(clk, rst, src_level_1[9], acc_id_level_1[9], src_level_1[11], acc_id_level_1[11], src_level_2[11], acc_id_level_2[11]);

        parallel_accumulator_update_reg(clk, rst, src_level_1[12], acc_id_level_1[12], src_level_2[12], acc_id_level_2[12]);
        parallel_accumulator_update_reg(clk, rst, src_level_1[13], acc_id_level_1[13], src_level_2[13], acc_id_level_2[13]);

        parallel_accumulator_update_adder(clk, rst, src_level_1[13], acc_id_level_1[13], src_level_1[14], acc_id_level_1[14], src_level_2[14], acc_id_level_2[14]);
        parallel_accumulator_update_adder(clk, rst, src_level_1[13], acc_id_level_1[13], src_level_1[15], acc_id_level_1[15], src_level_2[15], acc_id_level_2[15]);

        src_level_2_valid = src_level_1_valid;
    }

    // level 1
    if (rst) {
        for (int i = 0; i < 16; i ++) src_level_1[i] = 0;
        src_level_1_valid = 0;
    } else {
        parallel_accumulator_update_reg(clk, rst, front_src[0], front_acc_id[0], src_level_1[0], acc_id_level_1[0]);

        parallel_accumulator_update_adder(clk, rst, front_src[0], front_acc_id[0], front_src[1], front_acc_id[1], src_level_1[1], acc_id_level_1[1]);

        parallel_accumulator_update_reg(clk, rst, front_src[2], front_acc_id[2], src_level_1[2], acc_id_level_1[2]);

        parallel_accumulator_update_adder(clk, rst, front_src[2], front_acc_id[2], front_src[3], front_acc_id[3], src_level_1[3], acc_id_level_1[3]);

        parallel_accumulator_update_reg(clk, rst, front_src[4], front_acc_id[4], src_level_1[4], acc_id_level_1[4]);

        parallel_accumulator_update_adder(clk, rst, front_src[4], front_acc_id[4], front_src[5], front_acc_id[5], src_level_1[5], acc_id_level_1[5]);

        parallel_accumulator_update_reg(clk, rst, front_src[6], front_acc_id[6], src_level_1[6], acc_id_level_1[6]);

        parallel_accumulator_update_adder(clk, rst, front_src[6], front_acc_id[6], front_src[7], front_acc_id[7], src_level_1[7], acc_id_level_1[7]);

        parallel_accumulator_update_reg(clk, rst, front_src[8], front_acc_id[8], src_level_1[8], acc_id_level_1[8]);

        parallel_accumulator_update_adder(clk, rst, front_src[8], front_acc_id[8], front_src[9], front_acc_id[9], src_level_1[9], acc_id_level_1[9]);

        parallel_accumulator_update_reg(clk, rst, front_src[10], front_acc_id[10], src_level_1[10], acc_id_level_1[10]);

        parallel_accumulator_update_adder(clk, rst, front_src[10], front_acc_id[10], front_src[11], front_acc_id[11], src_level_1[11], acc_id_level_1[11]);

        parallel_accumulator_update_reg(clk, rst, front_src[12], front_acc_id[12], src_level_1[12], acc_id_level_1[12]);

        parallel_accumulator_update_adder(clk, rst, front_src[12], front_acc_id[12], front_src[13], front_acc_id[13], src_level_1[13], acc_id_level_1[13]);

        parallel_accumulator_update_reg(clk, rst, front_src[14], front_acc_id[14], src_level_1[14], acc_id_level_1[14]);

        parallel_accumulator_update_adder(clk, rst, front_src[14], front_acc_id[14], front_src[15], front_acc_id[15], src_level_1[15], acc_id_level_1[15]);

        src_level_1_valid = front_src_valid;
    }

    // connect to output
    for (int i = 0; i < 16; i ++) src[i] = src_level_4[i];
    *src_valid = src_level_4_valid;
}

void parallel_accumulator_update_reg(int clk, int rst,
                                     float din, int idin,
                                     
                                     float &dout, int &idout)
{
    if (rst) {
        dout = 0;
        idout = 0;
    } else {
        dout = din;
        idout = idin;
    }
}

// choose the minimum value from update
void parallel_accumulator_update_adder(int clk, int rst,
                                       float din_1, int idin_1, float din_2, int idin_2,
                                       
                                       float &dout, int &idout)
{   
    void parallel_accumulator_update_adder_float (  int clk,
                                                    float A, int valid_a,
                                                    float B, int valid_b,
                                                    
                                                    float *Result, int *valid_r);
    /*
    if (rst) {
        dout = 0;
        //idout = 0;
    } else if (idin_1 == idin_2 && din_1 < din_2) {
        dout = din_1;
        ///idout = idin_1;
    } else {
        dout = din_2;
        //idout = idin_2;
    }*/
    if(rst){
        idout = 0;
    }else
    {
        idout = idin_2;
    }

    float tmp_a;
    int valid_r;
    if(idin_1 == idin_2)
        tmp_a = din_1;
    else
        tmp_a =  0;
    parallel_accumulator_update_adder_float(clk,
                                            tmp_a, 1,
                                            din_2, 1,
                                            
                                            &dout,&valid_r);
}
void parallel_accumulator_update_adder_float (  int clk,
                                                float A, int valid_a,
                                                float B, int valid_b,
                                                
                                                float *Result, int *valid_r)
{
    *Result = A + B;
    *valid_r = (valid_a && valid_b);
}


// four levels correspond to prefix sum network
void parallel_accumulator_vertex_pipeline(int clk, int rst, int pipe_num,
                                          int front_dst_id, int front_src_mask, int front_dst_data_valid,
                                          
                                          int *dst_id, int *src_mask, int *dst_data_valid)
{
    static int dst_id_level_1[PIPE_NUM], src_mask_level_1[PIPE_NUM], dst_data_valid_level_1[PIPE_NUM];
    static int dst_id_level_2[PIPE_NUM], src_mask_level_2[PIPE_NUM], dst_data_valid_level_2[PIPE_NUM];
    static int dst_id_level_3[PIPE_NUM], src_mask_level_3[PIPE_NUM], dst_data_valid_level_3[PIPE_NUM];
    static int dst_id_level_4[PIPE_NUM], src_mask_level_4[PIPE_NUM], dst_data_valid_level_4[PIPE_NUM];

    // level 4
    if (rst) {
        dst_id_level_4[pipe_num] = 0;
        src_mask_level_4[pipe_num] = 0;
        dst_data_valid_level_4[pipe_num] = 0;
    } else {
        dst_id_level_4[pipe_num] = dst_id_level_3[pipe_num];
        src_mask_level_4[pipe_num] = src_mask_level_3[pipe_num];
        dst_data_valid_level_4[pipe_num] = dst_data_valid_level_3[pipe_num];
    }

    // level 3
    if (rst) {
        dst_id_level_3[pipe_num] = 0;
        src_mask_level_3[pipe_num] = 0;
        dst_data_valid_level_3[pipe_num] = 0;
    } else {
        dst_id_level_3[pipe_num] = dst_id_level_2[pipe_num];
        src_mask_level_3[pipe_num] = src_mask_level_2[pipe_num];
        dst_data_valid_level_3[pipe_num] = dst_data_valid_level_2[pipe_num];
    }

    // level 2
    if (rst) {
        dst_id_level_2[pipe_num] = 0;
        src_mask_level_2[pipe_num] = 0;
        dst_data_valid_level_2[pipe_num] = 0;
    } else {
        dst_id_level_2[pipe_num] = dst_id_level_1[pipe_num];
        src_mask_level_2[pipe_num] = src_mask_level_1[pipe_num];
        dst_data_valid_level_2[pipe_num] = dst_data_valid_level_1[pipe_num];
    }

    // level 1
    if (rst) {
        dst_id_level_1[pipe_num] = 0;
        src_mask_level_1[pipe_num] = 0;
        dst_data_valid_level_1[pipe_num] = 0;
    } else {
        dst_id_level_1[pipe_num] = front_dst_id;
        src_mask_level_1[pipe_num] = front_src_mask;
        dst_data_valid_level_1[pipe_num] = front_dst_data_valid;
    }

    *dst_id = dst_id_level_4[pipe_num];
    *src_mask = src_mask_level_4[pipe_num];
    *dst_data_valid = dst_data_valid_level_4[pipe_num];
}