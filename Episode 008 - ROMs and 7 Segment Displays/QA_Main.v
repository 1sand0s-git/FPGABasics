/* ----------------------------------------------------------------------- */
/*                                                                         */
/*   Quartz Arc                                                            */
/*                                                                         */
/*   FPGA Basics Code                                                      */
/*                                                                         */
/*   Terasic DE0-CV                                                        */
/*                                                                         */
/*   System: Core                                                          */
/*   Role: Top Level                                                       */
/*   Filename: QA_Main.v                                                   */
/*   Date: 22nd January 2021                                               */
/*   Created By: Benjamin Rosser                                           */
/*                                                                         */
/*   This code is covered by Creative Commons CC-BY-NC-SA license          */
/*   (C) Copyright 2021 Benjamin Rosser                                    */
/*                                                                         */
/* ----------------------------------------------------------------------- */


//----------------
//QA_Main
//Top Level Entity
//----------------
module QA_Main (

	input              RESET_N,

	input              CLOCK_50,
	input              CLOCK2_50,
	input              CLOCK3_50,
	inout              CLOCK4_50,

	inout       [35:0] GPIO_0,
	inout       [35:0] GPIO_1,

	input       [3:0]  KEY,

	output      [9:0]  LEDR,

	input       [9:0]  SW,

	output      [6:0]  HEX0,
	output      [6:0]  HEX1,
	output      [6:0]  HEX2,
	output      [6:0]  HEX3,
	output      [6:0]  HEX4,
	output      [6:0]  HEX5,

	inout              PS2_CLK,
	inout              PS2_CLK2,
	inout              PS2_DAT,
	inout              PS2_DAT2,

	output      [3:0]  VGA_B,
	output      [3:0]  VGA_G,
	output             VGA_HS,
	output      [3:0]  VGA_R,
	output             VGA_VS,

	output             SD_CLK,
	inout              SD_CMD,
	inout       [3:0]  SD_DATA,

	output      [12:0] DRAM_ADDR,
	output      [1:0]  DRAM_BA,
	output             DRAM_CAS_N,
	output             DRAM_CKE,
	output             DRAM_CLK,
	output             DRAM_CS_N,
	inout       [15:0] DRAM_DQ,
	output             DRAM_LDQM,
	output             DRAM_RAS_N,
	output             DRAM_UDQM,
	output             DRAM_WE_N

);

  //Byte Data
	
  reg [7:0] byte0 = 8'h00;
	reg [7:0] byte1 = 8'h00;
	reg [7:0] byte2 = 8'h00;
	
	wire [7:0] byteInput = SW[7:0];
	
	wire clk = ~KEY[0];
	wire loadByte0 = ~KEY[1];
	wire loadByte1 = ~KEY[2];
	wire loadByte2 = ~KEY[3];

  wire segOnOff = SW[9];
	
	always @ (negedge RESET_N or posedge clk)
	begin
	  
		if (!RESET_N)
		begin
		  byte0 <= 8'h00;
			byte1 <= 8'h00;
			byte2 <= 8'h00;
		end
		else if (loadByte0)
		begin
		  byte0 <= byteInput;
		end
		else if (loadByte1)
		begin
		  byte1 <= byteInput;
		end
		else if (loadByte2)
		begin
		  byte2 <= byteInput;
		end
		
	end
	
	
	//7 Seg Displays
	wire [2:0]   segEnable = {segOnOff, segOnOff, segOnOff};
	wire [23:0]  segData   = {byte2, byte1, byte0};
	wire [41:0]  segOutput;
	
	QA_7Seg_Module QA_7Seg (
    segEnable,
	  segData,
	  segOutput	
	);
	
  assign HEX0 = segOutput[6:0];
	assign HEX1 = segOutput[13:7];
	assign HEX2 = segOutput[20:14];
	assign HEX3 = segOutput[27:21];
	assign HEX4 = segOutput[34:28];
	assign HEX5 = segOutput[41:35];
	
	assign LEDR[7:0] = byteInput;
	
	
endmodule














