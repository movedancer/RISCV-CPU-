`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/13 19:50:57
// Design Name: 
// Module Name: controller
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


module controller(
    input [31:0]instr,//ָ���
    input zero,//ALU��zero����
    input cmp,//readdata1��readdata2�ıȽ�
    output wire [1:0]pcsrc,//��ַѡ��������
    output wire [2:0]immset,//����������ָ��
    //output wire reg_write,//�Ĵ�����дʹ��
    output wire mem_write,//datamemory���ݼĴ���дʹ��
    //output wire reg_src,//�Ĵ���д�����ݿ���
    output wire mem_read,//datamemoty���ݼĴ�����ʹ��
    output wire branch,//��ָ֧�����?
    //output wire [3:0]alucontrol,//�����alu�����ź�
    output wire IF_flash,//��ˢָ��
    //output wire ALUsrc//ALU����������
    output wire [9:0]control_sign,//����ID_EX�Ŀ����ź�
    output reg [2:0]functld,
    output reg [2:0]funct_b,
    input btb_en,//��֧Ԥ��ʹ��
    input jump
    //input cache_miss,//cache�������ź�
    //output wire hazard_ld//cachemissʱ����
    );
    //wire branch;//��ָ֧�����?
    wire [3:0]alucontrol;//�����alu�����ź�
    wire reg_write;//�Ĵ�����дʹ��
    wire [1:0]reg_src;//�Ĵ���д�����ݿ���
    wire ALUsrc;//ALU����������
    wire [1:0]aluop;//alu����ָ��
    wire [6:0]opcode;//��λopcode
    reg [3:0]funct;//��λ������
    reg [1:0]jflag;//�ж��Ƿ�Ϊ��������ת
    assign opcode=instr[6:0];
    //assign hazard_ld=(cache_miss&&opcode==7'b000_0011)?1'b1:1'b0;
    always@(*)begin
        case(opcode)//���opcode
            7'b110_1111:begin//jal
                functld<=3'b0;
                funct<=4'b0;
                funct_b<=3'b010;
                jflag<=2'b10;
            end
            7'b110_0111:begin//jalr
                funct<={instr[30],instr[14:12]};
                functld<=3'b0;
                funct_b<=3'b010;
                jflag<=2'b01;
            end
            7'b001_0111:begin//auipc
                funct<={instr[30],instr[14:12]};
                functld<=3'b0;
                funct_b<=3'b0;
                jflag<=2'b0;
            end
            7'b011_0011:begin//r
                if(instr[14:12]==3'b010)begin
                    funct<={instr[25],instr[14:12]};
                end else begin
                    funct<={instr[30],instr[14:12]};
                end
                functld<=3'b0;
                funct_b<=3'b0;
                jflag<=2'b0;
            end
            7'b001_0011:begin//i
                if(instr[14:12]==3'b101)begin
                    funct<={instr[30],instr[14:12]};
                end
                else begin
                    funct<={1'b0,instr[14:12]};
                end
                functld<=3'b0;
                funct_b<=3'b0;
                jflag<=2'b0;
            end
            7'b000_0011:begin//ld
                funct<={1'b0,instr[14:12]};
                functld<=instr[14:12];
                funct_b<=3'b0;
                jflag<=2'b0;
            end
            7'b010_0011:begin//sd
                funct<=4'b0000;
                functld<=3'b0;
                funct_b<=3'b0;
                jflag<=2'b0;
            end
            7'b110_0011:begin//b
                funct<={instr[30],instr[14:12]};
                functld<=3'b0;
                funct_b<=instr[14:12];
                jflag<=2'b0;
            end
            default:begin
                funct<={1'b0,instr[14:12]};
                functld<=3'b0;
                funct_b<=3'b0;
                jflag<=2'b0;
            end
        endcase
//        //ʵ��ָ���ˢ�ж�?
//        if(pcsrc!=2'b00)begin
//           IF_flash=1'b1;
//        end
//        else begin
//            IF_flash=1'b0;
//        end

//        if(branch&&(cmp^jflag[1]))begin
//            pcsrc<=2'b01;
//        end else if(branch&&jflag[0])begin
//            pcsrc<=2'b10;
//        end else begin
//            pcsrc<=2'b00;
//        end
    end
    assign pcsrc=(branch&&(cmp^jflag[1]))? 2'b01:((branch&&jflag[0])?2'b10 :2'b00 );
    //����alu_control,main_control,ָ����תѡ��ģ��
    main_control main_control(.opcode(opcode),.aluop(aluop),.immset(immset)
                                ,.reg_write(reg_write),.ALUsrc(ALUsrc)
                                ,.mem_write(mem_write),.reg_src(reg_src)
                                ,.mem_read(mem_read),.branch(branch),.funct(funct));
    alu_control alu_control(.funct(funct),.aluop(aluop),.alucontrol(alucontrol));
    //���������ź�ʵ��
    assign control_sign={reg_write,reg_src,mem_read,mem_write,alucontrol,ALUsrc};
    //assign IF_flash=(pcsrc==2'b00)?1'b0:1'b1;
    assign IF_flash=((((~jump)&&(~pcsrc[1])&&pcsrc[0])||((~jump)&&(~pcsrc[0])&&pcsrc[1])||
                        (jump&&(~pcsrc[1])&&(~pcsrc[0])))&&(branch))?1'b1:1'b0;
endmodule