`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/04 10:34:45
// Design Name: 
// Module Name: btb_pre
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


module btb_pre(
    input [31:0]pc,//IF�׶ε�pc����Ԥ��
    input [31:0]pc_out,//ID�׶�ָ���pc,���ڱ���
    input [31:0]pc_offset_j,//ID�׶�jalr�����ƫ�Ƶ�ַ�����ڱ���
    input [31:0]pc_offset,//bָ��ƫ�Ƶ�ַ�����ڱ���
    input [31:0]pc_4,//pc+4
    input [1:0]pcsrc,//�ж�ID�׶�ָ���Ƿ���ת
    input IF_flash,//�ж��Ƿ�Ԥ����ȷ
    output reg jump,//Ԥ��ָ���Ƿ���ת
    output reg btb_en,//�Ƿ�Ԥ��ʹ��
    output reg [31:0]pc_pre,//Ԥ���32λ��ַ
    input hazard_D,
    input hazard_ld_D,
    input IF_flash_D
    );
    reg IF_flash_buff;
    reg [31:0] btb_rf[127:0];//btb��ת�����ڲ���pc
    reg [1:0] btb_flag[127:0];//btb״̬�����ھ�����ת״̬
    reg flag1,flag2,flag3;
    wire [1:0]pcsrc_buff;
    reg [31:0]pc_buff;//���浱ǰ�׶�pc
    wire [31:0]btb_rf_buff;
    wire [1:0]btb_flag_buff;
    integer i;
    assign pcsrc_buff=pcsrc;
    initial begin
        for(i=7'b0;i<=11'b11111_11;i=i+1)begin
            btb_rf[i]<=32'b11111111_11111111_11111111_11111111;
            btb_flag[i]<=2'b11;
        end
    end
    always@(pc)begin
        //δ����
        if(~btb_rf[pc]==32'b0)begin
            pc_pre<=32'b0;
            btb_en<=1'b0;
            jump<=1'b0;
        end
        //���� 
        else begin
            btb_en<=1'b1;
            if(btb_flag[pc][1])begin
                pc_pre<=btb_rf[pc];
                jump<=1'b1;
            end else begin
                pc_pre<=pc+32'b1;
                jump<=1'b0;
            end
        end
    end
//    assign btb_rf_buff=(~btb_rf[pc_out]==32'b0&&(!hazard_D)&&(!hazard_ld_D))?((pcsrc==2'b00)?pc_buff
//                            :((pcsrc==2'b01)?pc_offset
//                            :((pcsrc==2'b10)?pc_offset_j
//                            :pc_buff)))
//                            :(((~btb_rf[pc_out]!=32'b0))?((IF_flash==1'b0)?btb_rf[pc_out]
//                            :((pcsrc==2'b00)?pc_buff
//                            :((pcsrc==2'b01)?pc_offset
//                            :((pcsrc==2'b10)?pc_offset_j
//                            :pc_buff))))
//                            :((pcsrc==2'b00)?pc_buff
//                            :((pcsrc==2'b01)?pc_offset
//                            :((pcsrc==2'b10)?pc_offset_j
//                            :pc_buff)))
//                            );
//    assign btb_flag_buff=(~btb_rf[pc_out]==32'b0&&(!hazard_D)&&(!hazard_ld_D))?((pcsrc==2'b00)?2'b00
//                            :((pcsrc==2'b01)?2'b11
//                            :((pcsrc==2'b10)?2'b11
//                            :2'b11)))
//                            :((~btb_rf[pc_out]!=32'b0)?((IF_flash==1'b0)?((pcsrc==2'b00)?((btb_flag[pc_out]==2'b00)?2'b00
//                            :btb_flag[pc_out]-2'b01)
//                            :((btb_flag[pc_out]==2'b11)?2'b11
//                            :btb_flag[pc_out]+2'b01))
//                            :((pcsrc==2'b00)?((btb_flag[pc_out]==2'b00)?2'b00
//                            :btb_flag[pc_out]-2'b01)
//                            :((btb_flag[pc_out]==2'b11)?2'b11
//                            :btb_flag[pc_out]+2'b01)))
//                            :((pcsrc==2'b01)?2'b11
//                            :((pcsrc==2'b10)?2'b11
//                            :2'b11))
//                            );
//    always@(*)begin
//        btb_rf[pc_out]<=btb_rf_buff;
//        btb_flag[pc_out]<=btb_flag_buff;
//    end
    //assign pcsrc_buff=pcsrc;
    //reg [1:0]pcsrc_buff1;
    always@(*)begin
        //pcsrc_buff=pcsrc;
        //IF_flash_buff=IF_flash;
        pc_buff=pc;
        //��ʷ���޴�pc
        //װ��btb��
        if(!IF_flash_D)begin
        if(~btb_rf[pc_out]==32'b0&&(!hazard_D)&&(!hazard_ld_D))begin
            flag1=hazard_D;
            //pcsrc_buff1=pcsrc_buff;
            case(pcsrc)
                2'b00:begin
                    btb_rf[pc_out]<=pc_buff;
                    btb_flag[pc_out]<=2'b00;
                end
                2'b01:begin
                    flag3=1'b1;
                    btb_rf[pc_out]<=pc_offset;
                    btb_flag[pc_out]<=2'b11;
                end
                2'b10:begin
                    btb_rf[pc_out]<=pc_offset_j;
                    btb_flag[pc_out]<=2'b11;
                end
                default:begin
                    btb_rf[pc_out]<=pc_buff;
                    btb_flag[pc_out]<=2'b11;
                end
            endcase
        end
        //��ʷ����pc
        //����״̬
        else if(~btb_rf[pc_out]!=32'b0)begin
            flag2<=1'b1;
            if(IF_flash==1'b0)begin//Ԥ����ȷ
                if(pcsrc==2'b00)begin//ָ���ת������״̬��
                    if(btb_flag[pc_out]==2'b00)begin
                        btb_flag[pc_out]<=btb_flag[pc_out];
                    end else begin
                        btb_flag[pc_out]<=btb_flag[pc_out]-2'b01;
                    end
                end else begin//ָ����ת������״̬��
                    if(btb_flag[pc_out]==2'b11)begin
                        btb_flag[pc_out]<=btb_flag[pc_out];
                    end else begin
                        btb_flag[pc_out]<=btb_flag[pc_out]+2'b01;
                    end
                end
            end else begin//Ԥ�����,����btb��

                case(pcsrc)
                    2'b00:begin
                        btb_rf[pc_out]<=pc_buff;
                        if(btb_flag[pc_out]==2'b00)begin
                            btb_flag[pc_out]<=btb_flag[pc_out];
                        end else begin
                            btb_flag[pc_out]<=btb_flag[pc_out]-2'b01;
                        end
                    end
                    2'b01:begin
                        btb_rf[pc_out]<=pc_offset;
                        if(btb_flag[pc_out]==2'b11)begin
                            btb_flag[pc_out]<=btb_flag[pc_out];
                        end else begin
                            btb_flag[pc_out]<=btb_flag[pc_out]+2'b01;
                        end
                    end
                    2'b10:begin
                        btb_rf[pc_out]<=pc_offset_j;
                        if(btb_flag[pc_out]==2'b11)begin
                            btb_flag[pc_out]<=btb_flag[pc_out];
                        end else begin
                            btb_flag[pc_out]<=btb_flag[pc_out]+2'b01;
                        end
                    end
                    default:begin
                        btb_rf[pc_out]<=pc_buff;
                        btb_flag[pc_out]<=btb_flag[pc_out];
                    end
                endcase
                
            end
        end
        end else begin
            btb_rf[pc_out]<=btb_rf[pc_out];
            btb_flag[pc_out]<=btb_flag[pc_out];
        end
    end
endmodule
