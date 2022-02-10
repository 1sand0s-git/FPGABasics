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
/*   Date: 10th February 2022                                              */
/*   Created By: Benjamin Rosser                                           */
/*                                                                         */
/*   This code is covered by Creative Commons CC-BY-NC-SA license          */
/*   (C) Copyright 2021 Benjamin Rosser                                    */
/*                                                                         */
/* ----------------------------------------------------------------------- */


//------------------
//QA_7Seg_ROM_Module
//Top Level Entity
//------------------
module QA_7Seg_ROM_Module (

  input [3:0] addrIn,
  output [6:0] dataOut
);

  //ROM Variable
  reg [6:0] rom[15:0]; // ( 2 ^ 4 ) - 1
  
  //Load ROM from file
  initial
  begin
    $readmemb("QA_7Seg_ROM.mem", rom);
  end
  
  assign dataOut = rom[addrIn];

endmodule


//----------------
//QA_7Seg_Module
//Top Level Entity
//----------------

module QA_7Seg_Module (

  input [2:0]   byteEnableIn,
  input [23:0]  byteDataIn,
  output [41:0] segmentsOut
);

  //Digit 0
	wire [6:0] seg0;
  QA_7Seg_ROM_Module QA_7Seg_0 (byteDataIn[3:0], seg0);
  
  //Digit 1
	wire [6:0] seg1;
  QA_7Seg_ROM_Module QA_7Seg_1 (byteDataIn[7:4], seg1);
  
  //Digit 2
	wire [6:0] seg2;
  QA_7Seg_ROM_Module QA_7Seg_2 (byteDataIn[11:8], seg2);
  
  //Digit 3
	wire [6:0] seg3;
  QA_7Seg_ROM_Module QA_7Seg_3 (byteDataIn[15:12], seg3);
  
  //Digit 4
	wire [6:0] seg4;
  QA_7Seg_ROM_Module QA_7Seg_4 (byteDataIn[19:16], seg4);
  
  //Digit 5
	wire [6:0] seg5;
  QA_7Seg_ROM_Module QA_7Seg_5 (byteDataIn[23:20], seg5);

  wire [13:0]  byte0Out = byteEnableIn[0] ? {seg1, seg0} : 14'h0000;
	wire [27:14] byte1Out = byteEnableIn[1] ? {seg3, seg2} : 14'h0000;
	wire [41:28] byte2Out = byteEnableIn[2] ? {seg5, seg4} : 14'h0000;
  
  assign segmentsOut = ~{byte2Out, byte1Out, byte0Out};
	
endmodule

