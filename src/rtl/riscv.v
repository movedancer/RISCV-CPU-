`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 10:58:03
// Design Name: 
// Module Name: mips
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


module riscv(
	input clk,
	input rst,
	input [31:0]instr,//ָ����������ָ��
	input cache_hit,
	output wire [31:0]pc,//pc����������ָ��Ĵ����ĵ�ַ
	output wire mem_writeM,//datamemory��дʹ��
	output wire mem_readM,//datamemory�Ķ�ʹ��
	output wire [31:0]rlt_outM,//alu�����
	output wire [31:0]B_out,//�Ĵ����ѵ��������
	output wire inst_ce,//ָ��Ĵ����Ķ������ź�
	//output wire branch,
	input [31:0]read_data,//datamemory��read_data���ص�����
	output wire [2:0]functM//ID/EX����EX/MEM��functM
    );
    wire [1:0]pcsrc;//ѡ��pc+4����pc+offset
    wire ALUsrc;//ѡ��alu��num2��Դ
    wire reg_src;//�Ĵ����ѵĶ���ѡ�����
    wire reg_write;//�������ļĴ�����д�ź�
    wire zero;//alu��zero����ź�
	wire [2:0]immset;//������ָ��
	wire [3:0]alucontrol;//alu�����ź�
    wire branch;//��ָ֧�����
    //wire clk_out;//�����ʱ�ӷ�Ƶ�ź�
    wire cmp;//readdata1��readdata2�ıȽ�
    wire [4:0]rd_out;//ID_EX��rd���������ð���ж�
    wire hazard;//ð�ռ��ģ��Ŀ����ź�
    wire [31:0]instr_out;//IF_ID�Ĵ��������ָ��
    wire mem_readE;//main_control�Ĵ���д�����ݿ���
    wire [1:0]forwarda;
    wire [1:0]forwardb;
    wire IF_flash;
    wire [9:0]control_sign;
    wire [4:0]rs1_out;
    wire [4:0]rs2_out;
    wire [4:0]rd_outM;
    wire [4:0]rd_outW;
    wire reg_writeM;
    wire reg_writeW;
    wire mem_read;
	wire mem_write;
    wire [2:0]immsetE;
    wire [2:0]funct_b;
    wire [2:0]funct;//controller������ldָ���funct
    //wire [2:0]functE;//controller����ID_EX��functE
    wire forwardc;
    wire mem_writeE;
    wire ALUsrcE;
    wire jump_D;
    wire btb_en;
    wire hazard_ld;
    //wire read_data;
    //ʵ����ģ��
    //clk_div clk_div(.rst(rst),.clk(clk),.clk_out(clk_out));
    controller controller(.instr(instr_out),.zero(zero),.pcsrc(pcsrc),.immset(immset),.IF_flash(IF_flash),.mem_write(mem_write),.mem_read(mem_read),.cmp(cmp),.control_sign(control_sign),.branch(branch)
                        ,.functld(funct),.funct_b(funct_b),.jump(jump_D),.btb_en(btb_en)
                        );
    
    datapath datapath(.clk(clk),.rst(rst),.instr(instr),.immset(immset),.pcsrc(pcsrc),.control_sign(control_sign),.read_data(read_data),.forwarda(forwarda),.forwardb(forwardb),.instr_out(instr_out)
                      ,.inst_ce(inst_ce),.zero(zero),.pc(pc),.cmp(cmp),.hazard(hazard),.IF_flash(IF_flash),.rd_out(rd_out),.rd_outM(rd_outM),.rd_outW(rd_outW),.reg_writeM(reg_writeM)
                      ,.reg_writeW(reg_writeW),.rs1_out(rs1_out),.rs2_out(rs2_out),.mem_readE(mem_readE),.rlt_outM(rlt_outM),.B_out(B_out),.mem_writeM(mem_writeM),.mem_readM(mem_readM)
                      ,.funct(funct),.functM(functM),.funct_b(funct_b),.immsetE(immsetE),.mem_writeE(mem_writeE),.forwardc(forwardc),.ALUsrcE(ALUsrcE)
                      ,.btb_en(btb_en),.jump_D(jump_D),.hazard_ld(hazard_ld)
                      );
                      
    Hazard_detecting h1(.clk(clk),.cmp(cmp),.rd_out(rd_out),.instr_out(instr_out),.mem_readE(mem_readE),.hazard(hazard),.funct_b(funct_b),.branch(branch)
                        ,.cache_hit(cache_hit),.hazard_ld(hazard_ld),.mem_readM(mem_readM),.rd_outM(rd_outM)
                        );
    Foward_detecting f1(.rs1_out(rs1_out),.rs2_out(rs2_out),.rd_outM(rd_outM),.rd_outW(rd_outW),.reg_writeM(reg_writeM),.reg_writeW(reg_writeW),.forwarda(forwarda),.forwardb(forwardb),.immsetE(immsetE)
                        ,.mem_writeE(mem_writeE),.forwardc(forwardc),.ALUsrcE(ALUsrcE)
                        );
endmodule
