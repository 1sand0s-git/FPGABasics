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
/*   Filename: QA_RCC_Module.v                                             */
/*   Date: 24th January 2021                                               */
/*   Created By: Benjamin Rosser                                           */
/*                                                                         */
/*   This code is covered by Creative Commons CC-BY-NC-SA license          */
/*   (C) Copyright 2021 Benjamin Rosser                                    */
/*                                                                         */
/* ----------------------------------------------------------------------- */


module QA_RCC_Module (

  input nReset,
  
  input clkHSIn,
  input clkLSIn,
  input clkManual,
  
  input clkSpeedSelect,
  input clkManualSelect,
  
  output sysReset,
  output sysClock

);


  //Reset
  wire reset = ~nReset;
  assign sysReset = reset;

  //PLL
  wire clk1MHz;
  wire pllLocked;
  
  QA_HSPLL QA_PLL(
    clkHSIn, 
	 reset, 
	 clk1MHz, 
	 pllLocked
  );
  
  
  //Clock Select
  wire clkSel_Speed = clkSpeedSelect ? clk1MHz : clkLSIn;
  
  wire clkSel_Manual = clkManualSelect ? clkManual : clkSel_Speed;
  
  assign sysClock = clkSel_Manual;
  

endmodule
