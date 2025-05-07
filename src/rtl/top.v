`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/20 20:56:27
// Design Name: 
// Module Name: top
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


module top(
	input clk,
	input rst,
	output [31:0]read_data,//datamemory�Ķ���������
	output [31:0]rlt_outM,//alu��������
	output mem_writeM,//��������datamemoryдʹ��
	output [31:0]instr//ִ�е�ָ��
    );
	//wire mem_write;//��������datamemoryдʹ��
	wire mem_readM;//��������datamemory��ʹ��
	wire [31:0]pc;//pc��ǰִ�е�ָ���ַ
	//wire [31:0]instr;//ִ�е�ָ��
	wire [31:0]B_out;//�Ĵ����Ѷ���������
	//wire branch;
   	//wire [31:0]aluout;//alu��������
   	//wire [31:0]read_data;//datamemory�Ķ���������
   	wire inst_ce;//ָ��Ĵ����Ķ������ź�
   	wire [2:0]functM;//EX_MEM�Ĵ��������ld����funct
   	wire [31:0]data_buff;
   	wire cache_hit;//cache�������ź�
   	//ʱ�ӷ�Ƶ
   	
   	//wire clk_out;//�����ʱ�ӷ�Ƶ�ź�
   	//ʵ����ģ��
   	//clk_div(.rst(rst),.clk(clk),.clk_out(clk_out));
	riscv riscv(.clk(clk),.rst(rst),.instr(instr),.pc(pc),.mem_writeM(mem_writeM),.mem_readM(mem_readM),.rlt_outM(rlt_outM),.B_out(B_out),.read_data(read_data),.inst_ce(inst_ce),.functM(functM)
	           ,.cache_hit(cache_hit)
	           );
	//blk_mem_gen_2 instr_mem(.clka(clk),.ena(inst_ce),.addra(pc),.douta(instr));//ָ��Ĵ���
	instr_memory instr_mem(.clka(clk),.ena(inst_ce),.addra(pc),.douta(instr));//ָ��Ĵ���
	//dcache dcache();
	//blk_mem_gen_2 data_mem(.clka(clk),.ena(mem_readM),.wea(mem_writeM),.addra(rlt_outM),.dina(B_out),.douta(read_data));//dmem����
	d_cache d_cache(.rst(rst),.clka(clk),.wea(mem_writeM),.ena(mem_readM),.addra(rlt_outM),.dina(B_out),.douta(read_data),.ohit(cache_hit));
	//data_memory data_memory(.clka(clk),.wea(mem_writeM),.ena(mem_readM),.addra(rlt_outM),.dina(B_out),.functM(functM),.douta(read_data));
endmodule
