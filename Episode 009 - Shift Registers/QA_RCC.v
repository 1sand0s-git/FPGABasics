/* ----------------------------------------------------------------------- */
/*                                                                         */
/*   Quartz Arc                                                            */
/*                                                                         */
/*   FPGA Basics Code                                                      */
/*                                                                         */
/*   Terasic DE0-CV                                                        */
/*                                                                         */
/*   System: Core                                                          */
/*   Role: Reset and Clock Control                                         */
/*   Filename: QA_RCC.v                                                    */
/*   Date: 10th February 2022                                              */
/*   Created By: Benjamin Rosser                                           */
/*                                                                         */
/*   This code is covered by Creative Commons CC-BY-NC-SA license          */
/*   (C) Copyright 2021 Benjamin Rosser                                    */
/*                                                                         */
/* ----------------------------------------------------------------------- */


//---------------------
//QA_RCC
//Reset & Clock Control
//---------------------
module QA_RCC_Module (

  input nResetIn,
	
	input clkAutoIn,
	input clkManualIn,
	
	input clkSelectIn,
	
	output sysResetOut,
	
	output sysClkOut

);

  assign sysResetOut = ~nResetIn;

	assign sysClkOut = clkSelectIn ? clkAutoIn : clkManualIn;

endmodule
