`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/13 20:25:17
// Design Name: 
// Module Name: main_control
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

module main_control(
    input [6:0]opcode,//7λ������
    input [3:0]funct,//ָ������
    output reg [1:0]aluop,//ALU����ָ��
    output reg [2:0]immset,//����������ָ��
    output reg reg_write,//�Ĵ�����дʹ��
    output reg ALUsrc,//ALU����������
    output reg mem_write,//���ݼĴ���дʹ��
    output reg [1:0]reg_src,//�Ĵ���д�����ݿ���
    output reg mem_read,//���ݼĴ�����ʹ��
    output reg branch//��ָ֧�����
   // output reg [3:0]func3,//ldָ������
    //output reg [2:0]funct_b
    //output reg [1:0]rd_src//�ж�jal,jalr,auipc��Ӧ��rd��Դ
    );
    always@(*)begin
        case(opcode[6:2])
            5'b01100:begin//r
                aluop<=2'b10;
                reg_write<=1'b1;
                mem_write<=1'b0;
                reg_src<=2'b0;
                mem_read<=1'b0;
                branch<=1'b0;
                immset<=3'b000;
                ALUsrc<=1'b0;
                //func3<=funct;
                //rd_src<=2'b00;
            end
            5'b00100:begin//i
                aluop<=2'b10;
                reg_write<=1'b1;
                mem_write<=1'b0;
                reg_src<=2'b0;
                mem_read<=1'b0;
                branch<=1'b0;
                //immset<=3'b000;
                ALUsrc<=1'b1;
                if(funct==4'b0001)begin//slli
                    immset<=3'b110;
                end
                else if(funct==4'b0101)begin//srli
                    immset<=3'b110;
                end
                else if(funct==4'b1101)begin//srai
                    immset<=3'b110;
                end
                else begin
                    immset<=3'b001;
                end
                //func3<=funct;
                //rd_src<=2'b00;
            end
            5'b00000:begin//ld
                if(opcode==7'b0)begin//nop
                    aluop<=2'b00;
                    reg_write<=1'b0;
                    mem_write<=1'b0;
                    reg_src<=2'b0;
                    mem_read<=1'b0;
                    branch<=1'b0;
                    immset<=3'b000;
                    ALUsrc<=1'b0;
                    //func3<=funct;
                    //rd_src<=2'b00;
                end
                else begin//ld
                    aluop<=2'b00;
                    reg_write<=1'b1;
                    mem_write<=1'b0;
                    reg_src<=2'b01;
                    mem_read<=1'b1;
                    branch<=1'b0;
                    immset<=3'b000;
                    ALUsrc<=1'b1;
                    //func3<=funct;
                    //rd_src<=2'b00;
                end
            end
            5'b01000:begin//sd
                aluop<=2'b00;
                reg_write<=1'b0;
                mem_write<=1'b1;
                reg_src<=2'b00;
                mem_read<=1'b0;
                branch<=1'b0;
                immset<=3'b010;
                ALUsrc<=1'b1;
                //func3<=funct;
                //rd_src<=2'b00;
            end
            5'b11000:begin//bָ��
                aluop<=2'b01;
                reg_write<=1'b0;
                mem_write<=1'b0;
                reg_src<=2'b00;
                mem_read<=1'b0;
                branch<=1'b1;
                immset<=3'b011;
                ALUsrc<=1'b0;
                //func3<=funct;
                //rd_src<=2'b00;
            end
            5'b11011:begin//jal
                aluop<=2'bxx;
                reg_write<=1'b1;
                mem_write<=1'b0;
                reg_src<=2'b11;
                mem_read<=1'b0;
                branch<=1'b1;
                immset<=3'b101;
                ALUsrc<=1'bx;
                //func3<=funct;
                //rd_src<=2'b10;
            end
            5'b11001:begin//jalr
                aluop<=2'bxx;
                reg_write<=1'b1;
                mem_write<=1'b0;
                reg_src<=2'b11;
                mem_read<=1'b0;
                branch<=1'b1;
                immset<=3'b111;
                ALUsrc<=1'bx;
                //func3<=funct;
                //rd_src<=2'b10;
            end
            5'b00101:begin//auipc
                aluop<=2'bxx;
                reg_write<=1'b1;
                mem_write<=1'b0;
                reg_src<=2'b10;
                mem_read<=1'b0;
                branch<=1'b0;
                immset<=3'b100;
                ALUsrc<=1'bx;
                //func3<=funct;
                //rd_src<=2'b11;
            end
            5'b01101:begin//lui
                aluop<=2'b11;
                reg_write<=1'b1;
                mem_write<=1'b0;
                reg_src<=2'b00;
                mem_read<=1'b0;
                branch<=1'b0;
                immset<=3'b100;
                ALUsrc<=1'b1;
                //func3<=funct;
                //rd_src<=2'b00;
            end
            default:begin
                aluop<=2'b00;
                reg_write<=1'b0;
                mem_write<=1'b0;
                reg_src<=2'b0;
                mem_read<=1'b0;
                branch<=1'b0;
                immset<=3'b000;
                ALUsrc<=1'b0;
                //func3<=funct;
                //rd_src<=2'b00;
            end
        endcase
    end
endmodule