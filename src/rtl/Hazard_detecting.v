`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/11 20:14:21
// Design Name: 
// Module Name: Hazard_detecting
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Hazard_detecting(
    input clk,
    input cmp,
    input cache_hit,//cache�Ƿ�����
    input [4:0]rd_out,//ID_EX��rd
    input [4:0]rd_outM,//EEX/MEM��rd
    input [31:0]instr_out,//IF_ID��ָ��
    input mem_readE,//ID_EX�Ķ�ʹ��,�ж��Ƿ�Ϊldָ��
    input mem_readM,//EX/MEM�Ķ�ʹ�ܣ��ж��Ƿ�Ϊldָ��
    input [2:0]funct_b,
    input branch,
    output wire hazard,//hit�����ld-useð���ź�
    output wire hazard_ld//miss�����ld-useð���ź�
    );
    assign hazard=(mem_readE&&((rd_out==instr_out[19:15])||(rd_out==instr_out[24:20])))?1'b1:1'b0;
    assign hazard_ld=(!cache_hit)?((mem_readM&&((rd_outM==instr_out[19:15])||(rd_outM==instr_out[24:20])))?1'b1
                        :((!cache_hit&&mem_readM)?1'b1:1'b0)):1'b0;
//    always@(*)begin
//        //if(cache_hit)begin//���У�һ��cycleȡ���ݣ�������Բ���
//        //����ld-use�ж���EX�׶�ִ�У�����Ҫ��ǰ��֪cache�Ƿ�����
//            if(mem_readE&&((rd_out==instr_out[19:15])||(rd_out==instr_out[24:20])))begin//����ð��
//                hazard<=1'b1;
//            end else begin//��ð��
//                hazard<=1'b0;
//            end
//        //end
//        if(!cache_hit)begin//δ���У�������ˮ��
//            if(mem_readE&&((rd_out==instr_out[19:15])||(rd_out==instr_out[24:20])))begin//����firstð�գ���������nop
//                hazard_ld<=2'b1;
//            end
//            else if(mem_readM&&((rd_outM==instr_out[19:15])||(rd_outM==instr_out[24:20])))begin//����secondð�գ�����һ��nop,����EX�׶μ���ǰ���н׶��ź�
//                hazard_ld<=2'b1;                
//            end else begin//��ð��
//                hazard_ld<=2'b0;
//            end
//        end
//    end
endmodule
