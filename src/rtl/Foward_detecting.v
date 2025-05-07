`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/11 20:14:53
// Design Name: 
// Module Name: Foward_detecting
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


module Foward_detecting(
    input [4:0]rs1_out,//ID_EX�ļĴ���������1
    input [4:0]rs2_out,//ID_EX�ļĴ���������2
    input [4:0]rd_outM,//EX_MEM��д��Ĵ�����ַ
    input [4:0]rd_outW,//MEM_WB��д��Ĵ�����ַ
    input reg_writeM,//EX_MEM�ļĴ�����дʹ��
    input reg_writeW,//MEM_WB�ļĴ�����дʹ��
    input [2:0]immsetE,//���sd����������ֹǰ�ƴ���
    input mem_writeE,//�ж�sd������ǰ��
    input ALUsrcE,//�ж�i��ָ���ǰ��
    output wire [1:0]forwarda,//����ID_EX��A������ALU�ĵ�һ������
    output wire [1:0]forwardb,//����ID_EX��B������ALU�ĵڶ�������
    output wire forwardc//����B_out��sd����ǰ��
    );
    reg f0,f1,f2,f3,f4;
    always@(*)begin
        f0=reg_writeM&&(rd_outM!=0)&&(rd_outM==rs1_out);
        f1=reg_writeW&&(rd_outW!=0)&&(rd_outW==rs1_out);
        f2=reg_writeM&&(rd_outM!=0)&&(rd_outM==rs2_out)&&(ALUsrcE==1'b0);
        f3=reg_writeW&&(rd_outW!=0)&&(rd_outW==rs2_out)&&(ALUsrcE==1'b0);
        f4=reg_writeM&&mem_writeE&&(rd_outM==rs2_out)&&(rd_outM!=0);
    end
    assign forwarda=((f0&f1)!=1'b1)?{f1,f0}:{1'b0,f0};
    assign forwardb=((f2&f3)!=1'b1)?{f3,f2}:{1'b0,f2};
    assign forwardc=f4;
endmodule
