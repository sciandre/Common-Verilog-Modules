`timescale 1ns / 1ps
module breathing_light_tb();
reg  clk;
reg  rst;
wire led;

wire [6:0] cnt_2us;
wire [9:0] cnt_us ;
wire [9:0] cnt_ms ;
wire       cnt_2s ;

assign cnt_2us = breathing_light_cg.cnt_2us;
assign cnt_us  = breathing_light_cg.cnt_us ;
assign cnt_ms  = breathing_light_cg.cnt_ms ;
assign cnt_2s  = breathing_light_cg.cnt_2s ;

initial begin
	rst = 1'b0;
	clk = 1'b0;
	
	#5
	rst = 1'b1;
	
	#2000000000
	$finish;
end

always #5 clk = ~clk;

breathing_light breathing_light_cg(
	.clk(clk),
	.rst(rst),
	.led(led)
);

endmodule