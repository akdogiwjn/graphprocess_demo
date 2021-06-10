//PR apply.c
#include "accumulator.h"
#include <stdio.h>

void sequential_accumulator(int clk, int rst,
                            int front_dst_id_1, float front_src_1, int front_dst_data_valid_1,
                            int front_dst_id_2, float front_src_2, int front_dst_data_valid_2,
                            int front_dst_id_3, float front_src_3, int front_dst_data_valid_3,
                            int front_dst_id_4, float front_src_4, int front_dst_data_valid_4,

                            int *wb_dst_addr_1, float *wb_dst_data_1, int *wb_dst_data_valid_1,
                            int *wb_dst_addr_2, float *wb_dst_data_2, int *wb_dst_data_valid_2,
                            int *wb_dst_addr_3, float *wb_dst_data_3, int *wb_dst_data_valid_3,
                            int *wb_dst_addr_4, float *wb_dst_data_4, int *wb_dst_data_valid_4)
{
    void sequential_accumulator_pipeline(int clk, int rst, int pipe_num,
                                         int front_dst_id, float front_src, int front_dst_data_valid,
                                         
                                         int *wb_dst_addr, float *wb_dst_data, int *wb_dst_dst_data_valid);

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
    static FILE *debug = fopen(".\\debug\\debug.txt","w+");
    if(*wb_dst_data_valid_1){
        fprintf(debug, "%d %d %f\n",clk,*wb_dst_addr_1,*wb_dst_data_1);
    }
}

void sequential_accumulator_pipeline(int clk, int rst, int pipe_num,
                                     int front_dst_id, float front_src, int front_dst_data_valid,
                                     
                                     int *wb_dst_addr, float *wb_dst_data, int *wb_dst_data_valid)
{
    // keep results and write back at the next time.

    //float 累加器
    void sequential_accumulator_pipeline_accumulator (  int clk, int rst, int pipe_num,
                                                        float A_in, int last_in, int valid_in,
                                                        
                                                        float *Result, int *last_out,int *valid_out);
    void sequential_accumulator_pipeline_adder (int clk,
                                                float add_a, int valid_a, float add_b, int valid_b,
                                                
                                                float *result, int *valid_r);
    void sequential_accumulator_pipeline_mul (  int clk,
                                                float add_a, int valid_a, float add_b, int valid_b,
                                                
                                                float *result, int *valid_r);                                            

    //level1
    static int level1_wb_dst_addr[PIPE_NUM],level1_wb_dst_data_valid[PIPE_NUM];
    static float level1_wb_dst_data[PIPE_NUM];
    static int dst_id_buffer[PIPE_NUM];
    static float src_buffer[PIPE_NUM];
    static int dst_data_valid_buffer[PIPE_NUM];
    static int current_dst_addr[PIPE_NUM];
    int last_in = (front_dst_data_valid && dst_data_valid_buffer[pipe_num] && (front_dst_id != dst_id_buffer[pipe_num]));
    int valid_in = (front_dst_data_valid && dst_data_valid_buffer[pipe_num]);
    int valid_out,last_out;
    //level2
    static int level2_wb_dst_addr[PIPE_NUM],level2_wb_dst_data_valid[PIPE_NUM];
    static float level2_add_A[PIPE_NUM],level2_add_B[PIPE_NUM];
    int valid_2_1,valid_2_2;
    //level3
    int valid_3;




    //floor3
    if(rst){
        *wb_dst_addr = 0;
        *wb_dst_data_valid = 0;
    }else
    {
        *wb_dst_addr = level2_wb_dst_addr[pipe_num];
        *wb_dst_data_valid = level2_wb_dst_data_valid[pipe_num];
    }
    sequential_accumulator_pipeline_adder(  clk,
                                            level2_add_A[pipe_num],1,level2_add_B[pipe_num],1,
                                            
                                            wb_dst_data,&valid_3);
    
    //floor2
    if(rst){
        level2_wb_dst_addr[pipe_num] = 0;
        level2_wb_dst_data_valid[pipe_num] = 0;
    }else
    {
        level2_wb_dst_addr[pipe_num] = level1_wb_dst_addr[pipe_num];
        level2_wb_dst_data_valid[pipe_num] = level1_wb_dst_data_valid[pipe_num];
    }
    sequential_accumulator_pipeline_mul(clk,
                                        level1_wb_dst_data[pipe_num], 1, 0.85, 1,
                                        
                                        &level2_add_A[pipe_num],&valid_2_1);
    sequential_accumulator_pipeline_mul(clk,
                                        1.0, 1, 0.15, 1,
                                        
                                        &level2_add_B[pipe_num],&valid_2_2);

    //floor 1
    sequential_accumulator_pipeline_accumulator(clk,rst,pipe_num,
                                                src_buffer[pipe_num], last_in, valid_in,
                                                
                                                &level1_wb_dst_data[pipe_num],&last_out,&valid_out);
    level1_wb_dst_data_valid[pipe_num] = last_out && valid_out;

    if(rst){
        level1_wb_dst_addr[pipe_num] = 0;
    }else
    {
        if(last_in){
            level1_wb_dst_addr[pipe_num] = dst_id_buffer[pipe_num];
        }
    }
    
    if(rst){
        dst_id_buffer[pipe_num] = pipe_num;
        src_buffer[pipe_num] = 0;
        dst_data_valid_buffer[pipe_num] = 0;
    }else
    {
        if(front_dst_data_valid){
            dst_id_buffer[pipe_num] = front_dst_id;
            src_buffer[pipe_num] = front_src;
            dst_data_valid_buffer[pipe_num] = front_dst_data_valid;
        }
    }
    /*
    for (int i = 0; i < PIPE_NUM; i ++) {
        printf("pipeline %d: %d %d ", i, now_dst_addr[i], now_dst_data[i]);
    }
    printf("\n");
    */
}
void sequential_accumulator_pipeline_accumulator (  int clk, int rst, int pipe_num,
                                                    float A_in, int last_in, int valid_in,
                                                        
                                                    float *Result, int *last_out,int *valid_out)
{
    static float accumulator[PIPE_NUM];
    if(rst){
        *valid_out = 0;
    }else
    {
        *valid_out = valid_in;
    }

    *last_out = last_in;

    if(last_in){
        *Result = accumulator[pipe_num] + A_in;
    }

    if(rst){
        accumulator[pipe_num] = 0;
    }else
    {
        if(valid_in){
            if(last_in){
                accumulator[pipe_num] = 0;
            }
            else
            {
                accumulator[pipe_num] = accumulator[pipe_num] + A_in;
            }
        }
    }
}
void sequential_accumulator_pipeline_adder (int clk,
                                            float add_a, int valid_a, float add_b, int valid_b,
                                            
                                            float *result, int *valid_r)
{
    *result = add_a + add_b;
    *valid_r = (valid_a && valid_b);
}
void sequential_accumulator_pipeline_mul (  int clk,
                                            float add_a, int valid_a, float add_b, int valid_b,
                                            
                                            float *result, int *valid_r)
{
    *result = add_a * add_b;
    *valid_r = (valid_a && valid_b);
}