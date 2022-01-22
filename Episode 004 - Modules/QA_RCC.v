/* ----------------------------------------------------------------------- */
/*                                                                         */
/*   Quartz Arc                                                            */
/*                                                                         */
/*   FPGA Basics Code                                                      */
/*                                                                         */
/*   Terasic DE0-CV                                                        */
/*                                                                         */
/*   System: Core                                                          */
/*   Role: Reset & Clock Control                                           */
/*   Filename: QA_RCC.v                                                    */
/*   Date: 23rd January 2021                                               */
/*   Created By: Benjamin Rosser                                           */
/*                                                                         */
/*   This code is covered by Creative Commons CC-BY-NC-SA license          */
/*   (C) Copyright 2021 Benjamin Rosser                                    */
/*                                                                         */
/* ----------------------------------------------------------------------- */


//----------------------------
//QA_RCC_Module
//Reset & Clock Control Module
//----------------------------
module QA_RCC_Module (

  input nResetIn,
  
  input clkManualIn,
  input clkAutoIn,
  
  input clkSelectIn,
  
  output sysReset,
  output sysClock

);


  assign sysReset = ~nResetIn;
  
  assign sysClock = clkSelectIn ? clkManualIn : clkAutoIn;


endmodule
