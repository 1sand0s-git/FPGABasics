/* ----------------------------------------------------------------------- */
/*                                                                         */
/*   Quartz Arc                                                            */
/*                                                                         */
/*   FPGA Basics Code                                                      */
/*                                                                         */
/*   Terasic DE0-CV                                                        */
/*                                                                         */
/*   System: Core                                                          */
/*   Role: 7 Segment Display Driver                                        */
/*   Filename: QA_ShiftReg.v                                               */
/*   Date: 10th February 2022                                              */
/*   Created By: Benjamin Rosser                                           */
/*                                                                         */
/*   This code is covered by Creative Commons CC-BY-NC-SA license          */
/*   (C) Copyright 2021 Benjamin Rosser                                    */
/*                                                                         */
/* ----------------------------------------------------------------------- */


//-----------------------
//QA_ShiftRegister_Module
//Shift Register Module
//-----------------------
module QA_ShiftRegister_Module (

  input         resetIn,
	input         clkIn,
	
	input         serialIn,
	
	input [7:0]   parallelIn,
	input         parallelLoad,
	input         parallelStore,
	
	output        serialOut,
	
	output [7:0]  parallelOut

);


  reg [7:0] shiftReg;
	reg       serialOutReg;
	
	always @ (posedge clkIn)
	begin
	
	  if (resetIn)
		begin
		  shiftReg <= 8'h00;
			serialOutReg <= 1'b0;
		end
		else if (parallelLoad)
		begin
		  shiftReg <= parallelIn;
		end
		else if (!parallelStore)
		begin
		  serialOutReg <= shiftReg[7];
			shiftReg <= {shiftReg[6:0], serialIn};
		end
		
	end
	
	assign serialOut = serialOutReg;
	assign parallelOut = shiftReg;


endmodule

