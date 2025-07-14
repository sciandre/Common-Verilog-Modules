module key_debounce(
	input wire clk, //50MHz
	input wire rst,
	input wire key,
	output reg key_xd
);

parameter DELAY = 20'd1_000_000;
reg [19:0] cnt_delay;
reg key_reg;
reg key_buf;

//key_buf、key_reg
always @(posedge clk or negedge rst)begin
	if(!rst)
	begin
		key_reg <= 1'b1;
		key_buf <= 1'b1;
	end
	else
	begin
		key_reg <= key;
	    key_buf <= key_reg;
	end
end
	
//cnt_delay
always @(posedge clk or negedge rst)begin
	if(!rst)
		cnt_delay <= DELAY;
	else if(key_reg == key_buf)
	begin
		if(cnt_delay == 20'd0)
			cnt_delay <= cnt_delay;
		else	
			cnt_delay <= cnt_delay - 20'd1;
	end
	else
		cnt_delay <= DELAY;
end 

always @(posedge clk or negedge rst)begin
	if(!rst)
		key_xd <= 1'b1;
	else if(cnt_delay == 20'd1)
		key_xd <= key_buf;
	else
		key_xd <= key_xd;
end

endmodule