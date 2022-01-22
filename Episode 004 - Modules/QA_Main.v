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
/*   Date: 23rd January 2021                                               */
/*   Created By: Benjamin Rosser                                           */
/*                                                                         */
/*   This code is covered by Creative Commons CC-BY-NC-SA license          */
/*   (C) Copyright 2021 Benjamin Rosser                                    */
/*                                                                         */
/* ----------------------------------------------------------------------- */


//--------------
//QA_7Seg_Module
module QA_7Seg_Module (
  output [6:0] SegOut
);

  assign SegOut = 7'h7F;

endmodule


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

   //-----
   //7SEGS
   wire [7:0] SegOut;
  
   QA_7Seg_Module QA_7Seg(SegOut);
  
	assign HEX0 = SegOut;
	assign HEX1 = SegOut;
	assign HEX2 = SegOut;
	assign HEX3 = SegOut;
	assign HEX4 = SegOut;
	assign HEX5 = SegOut;
	
	
	//
	wire clkManualIn = ~KEY[0];
	wire clkAutoIn   = GPIO_0[0];
	wire clkSelect   = SW[0];
	
	wire sysReset;
	wire sysClk;
	
	QA_RCC_Module QA_RCC(RESET_N, clkManualIn, clkAutoIn, clkSelect, sysReset, sysClk);
	
	//assign LEDR[0] = sysClk;
	//assign LEDR[1] = clkSelect;
	//assign LEDR[2] = sysReset;
	
	assign LEDR[2:0] = {sysReset, clkSelect, sysClk};
	
	
endmodule


