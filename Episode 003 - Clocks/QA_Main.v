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
/*   Date: 18th January 2021                                               */
/*   Created By: Benjamin Rosser                                           */
/*                                                                         */
/*   This code is covered by Creative Commons CC-BY-NC-SA license          */
/*   (C) Copyright 2021 Benjamin Rosser                                    */
/*                                                                         */
/* ----------------------------------------------------------------------- */



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
	


  //-----------
	//Clock Input
	wire ClkAutoInput   = GPIO_0[0];
	wire ClkManualInput = ~KEY[0];



	//-----------------------
	//Clock Prescaler Counter
	reg[2:0] ClkPrescalerCounterReg = 3'b000;

	always @ (posedge ClkAutoInput)
	begin
    ClkPrescalerCounterReg <= ClkPrescalerCounterReg + 3'b001;
	end
	
	wire[3:0] ClkPrescalerCounter = {ClkPrescalerCounterReg[2:0], ClkAutoInput};

  //assign LEDR[3:0] = ClkPrescalerCounter;
	
	
	//------------------------
	//Clock Prescaler Selector (Barrel Shifter)
	reg[3:0] ClkPrescalerSelectorReg = 4'b0001;

	wire ClkPrescalerSelectFaster = ~KEY[2];
	wire ClkPrescalerSelectSlower = ~KEY[3];
	
	always @ (negedge RESET_N or posedge ClkAutoInput)
	begin
	
	  //Reset
	  if (~RESET_N)
		begin
		  ClkPrescalerSelectorReg = 4'b1000;
		end
		//Faster
		else if (ClkPrescalerSelectFaster)
		begin
		  ClkPrescalerSelectorReg <= {ClkPrescalerSelectorReg[0], ClkPrescalerSelectorReg[3:1]};
		end
		//Slower
		else if (ClkPrescalerSelectSlower)
		begin
		  ClkPrescalerSelectorReg <= {ClkPrescalerSelectorReg[2:0], ClkPrescalerSelectorReg[3]};
		end
	
	end

	//assign LEDR[3:0] = ClkPrescalerSelectorReg;

	
	//--------------
	//Clock Selector
	wire ClkPrescaled = ((ClkPrescalerCounter & ClkPrescalerSelectorReg) != 4'b0000);
	
	wire ClkSelect      = SW[0];

	wire ClkAuto        = ClkSelect & ClkPrescaled;
	wire ClkManual      = ~ClkSelect & ClkManualInput; 
	wire Clk            = ClkAuto | ClkManual;

	
	//------
	//Output 
	assign LEDR = {Clk, ClkSelect, 4'b0000, ClkPrescalerSelectorReg[3:0]};
	

endmodule 

