`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/30 15:08:37
// Design Name: 
// Module Name: pc_offset_adder
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


module pc_offset_adder(
    input [31:0]pc_out,//��Ϊ����0��
    input [31:0]imm,//��Ϊ�з���������Ϊ�����ʾ
    output [31:0]rlt
    );
    //������תָ��ƫ����Ĭ��instrָ��Ϊ4��һ�鴢�棬��˶�imm��Ҫ������λ
    wire [31:0]imm_tmp;
    assign imm_tmp={{2{imm[31]}},imm[31:2]};
    assign rlt=pc_out+imm_tmp;
endmodule
