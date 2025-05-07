`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/11 15:58:27
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
    input clk,
    input rst,
    input hazard,//ð�տ����ź�
    input hazard_ld,
    input IF_flash,//ˢ���ź�
    input [31:0]instr,//ָ��Ĵ�����ָ��
    input [31:0]pc,//pc�������ĵ�ַ
    input jump,
    input [31:0]addr1,
    output reg jump_D,
    output reg [31:0]pc_out,//pc���
    output reg [31:0]instr_out,//instr���
    output reg hazard_D,
    output reg hazard_ld_D,
    output reg [31:0]addr1_D,
    output reg IF_flash_D
    );
    always@(posedge clk)begin
        hazard_D<=hazard;
        hazard_ld_D<=hazard_ld;
        addr1_D<=addr1;
        IF_flash_D<=IF_flash;
        if(rst)begin
            pc_out<=32'b0;
            instr_out<=32'b0;
            jump_D<=1'b0;
        end
        else if(IF_flash)begin  
            pc_out<=pc;
            instr_out<=32'b0;
            jump_D<=jump;
        end
        else if(hazard||hazard_ld)begin
            pc_out<=pc;
            instr_out<=instr_out;
            jump_D<=jump;
        end
        else begin
            pc_out<=pc;
            instr_out<=instr;
            jump_D<=jump;
        end
    end
endmodule
