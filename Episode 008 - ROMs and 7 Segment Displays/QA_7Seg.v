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
/*   Filename: QA_7Seg.v                                                   */
/*   Date: 22nd January 2021                                               */
/*   Created By: Benjamin Rosser                                           */
/*                                                                         */
/*   This code is covered by Creative Commons CC-BY-NC-SA license          */
/*   (C) Copyright 2021 Benjamin Rosser                                    */
/*                                                                         */
/* ----------------------------------------------------------------------- */


//------------------
//QA_7Seg_ROM_Module
//------------------
module QA_7Seg_ROM_Module (
  input [3:0] addr,
	output [6:0] data
);

  //ROM Variable
  reg [6:0] rom[2**4-1:0];
	
	//Load ROM from file
	initial
	begin
	  $readmemb("QA_7Seg.mem", rom);
	end
	
	assign data = rom[addr];

endmodule


//--------------
//QA_7Seg_Module
//--------------
module QA_7Seg_Module (
  input [3:0] enableIn,
	input [23:0] dataIn,
	output [41:0] segmentsOut
);

  //Digit 0
	wire [6:0] seg0;
	QA_7Seg_ROM_Module QA_7Seg_0 (dataIn[3:0], seg0);

  //Digit 1
	wire [6:0] seg1;
	QA_7Seg_ROM_Module QA_7Seg_1 (dataIn[7:4], seg1);

  //Digit 2
	wire [6:0] seg2;
	QA_7Seg_ROM_Module QA_7Seg_2 (dataIn[11:8], seg2);

  //Digit 0
	wire [6:0] seg3;
	QA_7Seg_ROM_Module QA_7Seg_3 (dataIn[15:12], seg3);

  //Digit 4
	wire [6:0] seg4;
	QA_7Seg_ROM_Module QA_7Seg_4 (dataIn[19:16], seg4);

  //Digit 5
	wire [6:0] seg5;
	QA_7Seg_ROM_Module QA_7Seg_5 (dataIn[23:20], seg5);
	
	
	//Output
	wire [13:0]  byte0Out = enableIn[0] ? {seg1, seg0} : 14'h0000;
	wire [13:0]  byte1Out = enableIn[1] ? {seg3, seg2} : 14'h0000;
	wire [13:0]  byte2Out = enableIn[2] ? {seg5, seg4} : 14'h0000;
	
	assign segmentsOut = ~{byte2Out, byte1Out, byte0Out};


endmodule











