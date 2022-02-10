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
/*   Date: 10th February 2022                                              */
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


  //---------------------
  //---------------------
  //Reset & Clock Control

	wire clkAutoIn   = GPIO_0[0];
	wire clkManualIn = ~KEY[0];
	wire clkSelectIn = SW[0];
	
	wire sysReset;
	wire sysClk;
	
	QA_RCC_Module QA_RCC (
	  
		RESET_N,
		clkAutoIn,
		clkManualIn,
		clkSelectIn,
		sysReset,
		sysClk
	);
	
	
	//--------------
	//--------------
	//Shift Register
	
	wire       serialIn = ~KEY[1];
	wire [7:0] parallelIn = SW[9:2];
	wire       serialOut;
	wire [7:0] parallelOut;
	
	wire       parallelLoad = ~KEY[2];
	wire       parallelStore = ~KEY[3];
	
	QA_ShiftRegister_Module QA_ShiftRegister (
	  sysReset,
		sysClk,
		
		serialIn,
		parallelIn,
		parallelLoad,
		parallelStore,
		serialOut,
		parallelOut
	);
	
	
	//-------------
	//-------------
	//Data Register
	
	reg [7:0] dataReg = 8'h00;
	
	always @ (posedge sysClk)
	begin
	
	  if (sysReset)
		begin
		  dataReg <= 8'h00;
		end
		else if (parallelStore)
		begin
		  dataReg <= parallelOut;
		end
	
	end
	
	
	//----
	//----
	//LEDS

	assign LEDR = {serialOut, parallelOut, serialIn};
	
	
	//-------------
	//-------------
	//7Seg Displays

	wire [2:0] segEnable = 3'b111;
	
  wire [7:0] segByte0 = dataReg;
	wire [7:0] segByte1 = parallelOut;
	wire [7:0] segByte2 = parallelIn;
	wire [23:0] segData = {segByte2, segByte1, segByte0};
	
	wire [41:0] segOutput;
	
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
	

endmodule
