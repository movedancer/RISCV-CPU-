`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/20 22:55:51
// Design Name: 
// Module Name: datapath
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

//
module datapath(
    input clk,
    //input clk_out,//pc��ʱ���ź�
    input rst,
    input hazard,//ð�ռ��ģ���ð���ź�
    input IF_flash,//���ݳ�ˢ�ź�
    input [31:0]instr,//ָ��Ĵ��������ָ��
    input [2:0]immset,//������������������ָ�����
    input [1:0]pcsrc,//ѡ��pc+4����pc+offset
    //input ALUsrc,//ѡ��alu��num2��Դ
    //input reg_src,//�Ĵ����ѵĶ���ѡ�����
    //input reg_write,//�������ļĴ�����д�ź�
    input [9:0]control_sign,//main_control�Ŀ����ź����л�֮����
    //input [3:0]alucontrol,//alu�Ŀ����ź�
    input [31:0]read_data,//datamemory����������
    input [1:0]forwarda,//����ID_EX��A������ALU�ĵ�һ������
    input [1:0]forwardb,//����ID_EX��B������ALU�ĵڶ�������
    output inst_ce,//ָ��Ĵ����Ķ������ź�
    output zero,//alu��zero����ź�
    output [31:0]pc,//pc��ǰִ�е�ָ���ַ
    output cmp,//readdata1��readdata2�ıȽ�
    output [31:0]instr_out,//IF_ID��IR���
    output [4:0]rd_out,//ID_EX��rd���������ð���ж�
    output [4:0]rs1_out,//ID_EX�Ķ�ȡ�Ĵ������еĵ�һ����ַ
    output [4:0]rs2_out,//ID_EX�Ķ�ȡ�Ĵ������еĵڶ�����ַ
    output mem_readE,//main_control�Ĵ���д�����ݿ���
    output [4:0]rd_outM,//EX_MEM��д�ؼĴ����ѵ�ַ
    output [4:0]rd_outW,//MEM_WB��д�ؼĴ����ѵ�ַ
    output [31:0]rlt_outM,//EX_MEM����alu�ļ�����
    output [31:0]B_out,//EX_MEM����ID_EX��B������
    output mem_writeM,//EX_MEM��data�Ĵ���дʹ��
    output mem_readM,//EX_MEM��data�Ĵ�����ʹ��
    output reg_writeM,//EX_MEM�ļĴ�����дʹ��
    output reg_writeW,//MEM_WB�ļĴ�����дʹ��
    
    output btb_en,
    output jump_D,
    
    input [2:0]funct,
    output [2:0]functM,
    input [2:0]funct_b,
    output [2:0]immsetE,
    input forwardc,
    output mem_writeE,
    output ALUsrcE,
    input hazard_ld
    );
    wire [2:0]functE;
    //wire [31:0]pc;//pc��ǰִ�е�ָ���ַ
    wire [31:0]addr1;//pc+4
    wire [31:0]addr2;//pc+offset
    wire [31:0]addr3;//��ַmux2_1����������뵽pc
    wire [31:0]data;//��������չ���
    wire [31:0]sl_data;//slģ���������
    wire [31:0]num2;//alusrc��ѡһģ�����
    wire [31:0]rd1;//�Ĵ��������������1
    wire [31:0]rd2;//�Ĵ��������������2
    wire [31:0]data_back;//���ݷ���ѡ����ѡ���wb����
    wire [31:0]pc_out;//IF_ID�����pc
    wire reg_writeE;//main_control�ļĴ���дʹ��
    wire [1:0]reg_srcE;//main_control�Ĵ���д�����ݿ���
    //wire mem_readE;//main_control�Ĵ���д�����ݿ���
    //wire mem_writeE;//main_control���ݼĴ���дʹ��
    wire branchE;//main_control��ָ֧�����
    wire [3:0]alucontrolE;//ALU����ָ��
    //wire ALUsrcE;//ALU����������
    wire [9:0]control_sign_m;//����ѡ���Ĵ���ID_EX�����ź�
    wire [31:0]A;
    wire [31:0]B;
    wire [31:0]imm_out;
    //wire [4:0]rd_out;
    //wire reg_writeM;
    wire [1:0]reg_srcM;
    //wire mem_readM;
    //wire mem_writeM;
    wire branchM;
    //wire reg_writeW;
    wire [1:0]reg_srcW;
    wire [31:0]lwd;//�������ݼĴ�������������
    wire [31:0]rlt_outW;
    wire [31:0]mux3a;//A����·ѡ�������
    wire [31:0]mux3b;//B����·ѡ�������
    wire [31:0]aluout;//alu�����
    wire [31:0]pc_offset;//jalr��pcƫ�Ƶ�ַ
    //wire [2:0]funct_b;//bָ���ǰ������
    wire [31:0]pc_4;
    wire [31:0]pc_imm;
    wire [31:0]pc_4E;
    wire [31:0]pc_immE;
    wire [31:0]pc_4M;
    wire [31:0]pc_immM;
    wire [31:0]pc_4W;
    wire [31:0]pc_immW;
    //wire [2:0]immsetE;
    wire [31:0]B_fw;//ǰ��sd���B_out
    wire [2:0]funct_b_E;
    wire [31:0]pc_pre;
    wire jump;
    wire hazard_D;
    wire [31:0]addr1_D;
    wire [31:0]read_data_p;
    wire hazard_ld_D;
    wire [31:0]pc_4_D;
    wire IF_flash_D;
    //wire [31:0]read_data_M;
    //ʵ����ģ��
    new_pc new_pc(.clk(clk),.rst(rst),.addr(addr3),.inst_ce(inst_ce),.pc(pc),.hazard(hazard),.hazard_ld(hazard_ld));
    regfile regfile(.clk(clk),.we3(reg_writeW),.ra1(instr_out[19:15]),.ra2(instr_out[24:20]),.wa3(rd_outW),.wd3(data_back),.rd1(rd1),.rd2(rd2));
    imm_gen imm_gen(.imm(instr_out),.immset(immset),.data(data));
    ALU alu(.num1(mux3a),.num2(mux3b),.alucontrol(alucontrolE),.zero(zero),.rlt(aluout));
    sl2 sl1(.data(data),.sl_data(sl_data));
    adder adder1(.a(pc),.b(32'h1),.y(addr1));//pc�������ļӷ���pc+4
    //adder adder6(.a(pc_out),.b(32'h1),.y(pc_ID_4));//pc_ID+4,����Ԥ��ʧ�ܳ���ѡ��
    pc_offset_adder adder2(.pc_out(pc_out),.imm(sl_data),.rlt(addr2));//ƫ�Ƶ�ַ�����pc+offset
    pc_offset_adder adder3(.pc_out(rd1),.imm(data),.rlt(pc_offset));//jalrָ���ƫ�Ƶ�ַrs1+imm
    pc_offset_adder adder5(.pc_out(pc_out),.imm(data),.rlt(pc_imm));//auipc����pc+imm
    //adder adder2(.a(pc_out),.b(sl_data),.y(addr2));//ƫ�Ƶ�ַ�����
    //adder adder3(.a(pc_out),.b(data),.y(pc_offset));//jalrָ���ƫ�Ƶ�ַ
    adder adder4(.a(pc_out),.b(32'h1),.y(pc_4));//jal/jalr����pc+4
    //adder adder5(.a(pc_out),.b(rd1),.y(pc_imm));//auipc����pc+imm
    //adder_off adder2(.a(pc_out),.b(sl_data),.y(addr2));//ƫ�Ƶ�ַ�����
    //mux2_1 m1(.addr1(addr1),.addr2(addr2),.opt(pcsrc),.addr3(addr3));//pc��ַѡ����
    //mux4_1 m1(.addr1(addr1),.addr2(addr2),.addr3(pc_offset),.pcsrc(pcsrc),.addr5(addr3));//pc��ַѡ����
    new_pc_mux4_1 m1(.pcsrc(pcsrc),.pc_pre(pc_pre),.pc_4(addr1),.pc_offset(addr2),.pc_offset_j(pc_offset),.btb_en(btb_en),.pc(addr3),.IF_flash(IF_flash)
                    ,.pc_4_D(pc_4),.IF_flash_D(IF_flash_D)
                    );//pc��ַѡ����
    btb_pre btb_pre(.pc(pc),.pc_out(pc_out),.pc_offset_j(pc_offset),.pc_offset(addr2),.pc_4(addr1),.pcsrc(pcsrc),.IF_flash(IF_flash),.jump(jump),.btb_en(btb_en),.pc_pre(pc_pre),.hazard_D(hazard_D),.hazard_ld_D(hazard_ld_D)
                    ,.IF_flash_D(IF_flash_D)
                    );
    mux2_1 m2(.addr1(B),.addr2(imm_out),.opt(ALUsrcE),.addr3(num2));//alu������Դ��һ����ѡһѡ����
    //mux2_1 m3(.addr2(lwd),.addr1(rlt_outW),.opt(reg_srcW),.addr3(data_back));//datamemory��aluout��д��ѡ��
    mux4_1 m3(.addr1(rlt_outW),.addr2(lwd),.addr3(pc_immW),.addr4(pc_4W),.pcsrc(reg_srcW),.addr5(data_back));//datamemory��aluout��д��ѡ��
    mux2_1_control m4(.a(control_sign),.b(10'b0),.op(hazard),.c(control_sign_m));//���ڲ���տ����źŵĶ�ѡһѡ����
    compare compare(.rd1(rd1),.rd2(rd2),.cmp(cmp),.funct_b(funct_b));//�ȽϼĴ�����ȡ�����ݽ�������ð���ж�
    mux3_1 m5(.a(A),.b(rlt_outM),.c(data_back),.op(forwarda),.d(mux3a));//A����·ѡ����
    mux3_1 m6(.a(num2),.b(rlt_outM),.c(data_back),.op(forwardb),.d(mux3b));//B����·ѡ����
    mux2_1 m7(.addr1(B),.addr2(rlt_outM),.opt(forwardc),.addr3(B_fw));
    //data_memory data_memory(.dina(read_data),.functM(functM),.douta(read_data_M));
    data_process data_process(.dina(read_data),.functM(functM),.douta(read_data_p));
    //ʵ�����Ĵ���
    IF_ID IF_ID(.clk(clk),.rst(rst),.hazard(hazard),.IF_flash(IF_flash),.instr(instr),.pc(pc),.pc_out(pc_out),.instr_out(instr_out),.jump(jump),.jump_D(jump_D),.hazard_D(hazard_D),.addr1(addr1),.addr1_D(addr1_D)
                ,.hazard_ld(hazard_ld),.hazard_ld_D(hazard_ld_D),.IF_flash_D(IF_flash_D)
                );
    ID_EX ID_EX(.clk(clk),.rst(rst),.control_sign(control_sign_m),.rd1(rd1),.rd2(rd2),.imm(data),.rd(instr_out[11:7]),.rs1(instr_out[19:15]),.rs2(instr_out[24:20]),.reg_writeE(reg_writeE),.reg_srcE(reg_srcE)
                ,.mem_readE(mem_readE),.mem_writeE(mem_writeE),.alucontrolE(alucontrolE),.ALUsrcE(ALUsrcE),.A(A),.B(B),.imm_out(imm_out),.rs1_out(rs1_out),.rs2_out(rs2_out),.rd_out(rd_out)
                ,.funct(funct),.functE(functE),.pc_4(pc_4),.pc_imm(pc_imm),.pc_4E(pc_4E),.pc_immE(pc_immE),.immset(immset),.immsetE(immsetE),.funct_b(funct_b),.funct_b_E(funct_b_E),.hazard(hazard)
                ,.hazard_ld(hazard_ld)
                );
    EX_MEM EX_MEM(.clk(clk),.rst(rst),.reg_writeE(reg_writeE),.reg_srcE(reg_srcE),.mem_readE(mem_readE),.mem_writeE(mem_writeE),.rlt(aluout),.B(B_fw),.rd_out(rd_out),.reg_writeM(reg_writeM)
                ,.reg_srcM(reg_srcM),.mem_readM(mem_readM),.mem_writeM(mem_writeM),.rlt_outM(rlt_outM),.B_out(B_out),.rd_outM(rd_outM)
                ,.functE(functE),.functM(functM),.pc_4E(pc_4E),.pc_immE(pc_immE),.pc_4M(pc_4M),.pc_immM(pc_immM)
                ,.hazard_ld(hazard_ld)
                );
    MEM_WB MEM_WB(.clk(clk),.rst(rst),.reg_writeM(reg_writeM),.reg_srcM(reg_srcM),.read_data(read_data_p),.rlt_outM(rlt_outM),.rd_outM(rd_outM),.reg_writeW(reg_writeW),.reg_srcW(reg_srcW),.lwd(lwd)
                ,.rd_outW(rd_outW),.rlt_outW(rlt_outW),.pc_4M(pc_4M),.pc_immM(pc_immM),.pc_4W(pc_4W),.pc_immW(pc_immW)
                ,.hazard_ld(hazard_ld)
                );
    
endmodule
