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
/*   Date: 24th January 2021                                               */
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

  //-----
  //7SEGS
	assign HEX0 = 7'h7F;
	assign HEX1 = 7'h7F;
	assign HEX2 = 7'h7F;
	assign HEX3 = 7'h7F;
	assign HEX4 = 7'h7F;
	assign HEX5 = 7'h7F;

	
	//----------
	//RCC Module
	wire sysReset;
	wire sysClk;

   wire sysClkSpeedSelect = SW[1];
	wire sysClkManualSelect = SW[0];
	
	QA_RCC_Module QA_RCC(
	  RESET_N,
	  CLOCK_50,
	  GPIO_0[0],
	  ~KEY[0],
	  sysClkSpeedSelect,
	  sysClkManualSelect,
	  sysReset,
	  sysClk
	);
	

	//------------
	//Test Counter
	reg [7:0] counterReg = 8'h00;
	
	always @ (posedge sysReset or posedge sysClk)
	begin
	
	  if (sysReset)
	  begin
	    counterReg <= 8'h00;
	  end
	  else
	  begin
	    counterReg <= counterReg + 8'h01;
	  end
	
	end
	
	
	//------
	//Output
	assign LEDR[0] = sysClk;
	
	assign LEDR[9:2] = counterReg;
	
	
endmodule
