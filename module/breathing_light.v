module breathing_light(
	input wire clk,
	input wire rst,
	output reg led
);

//50MHz的晶振，从0计数到99就是2us
parameter CNT_2US = 7'd99;

reg [6:0] cnt_2us; //对时钟进行计数，计数到刚好为2us时跳转回0
reg [9:0] cnt_us ; //每2us计数一次（即cnt_2us到达最大值时计一次数），计数到1000
reg [9:0] cnt_ms ; //每2ms计数一次，计数到1000
reg       cnt_2s ; //每2s跳转一次，用来标志渐亮或渐灭

wire first_part; //每一份2ms先出来的占比电平,后占比电平对其取反即可

//first_part
assign first_part = (cnt_2s)? 1'b0: 1'b1;

//cnt_2us
always @(posedge clk or negedge rst)begin
	if(!rst)
		cnt_2us <= 7'd0;
	else 
	begin
		if(cnt_2us < CNT_2US)
			cnt_2us <= cnt_2us + 7'd1;
		else 
			cnt_2us <= 7'd0;
	end
end

//cnt_us
always @(posedge clk or negedge rst)begin
	if(!rst)
		cnt_us <= 10'd0;
	else 
	begin
		if(cnt_2us == CNT_2US)
		begin 
			if(cnt_us < 10'd999)
				cnt_us <= cnt_us + 10'd1;
			else
				cnt_us <= 10'd0;
		end
		else 
			cnt_us <= cnt_us;
			
	end
end

//cnt_ms
always @(posedge clk or negedge rst)begin
	if(!rst)
		cnt_ms <= 10'd0;
	else 
	begin
		if((cnt_2us == CNT_2US) && (cnt_us == 10'd999))
		begin 
			if(cnt_ms < 10'd999)
				cnt_ms <= cnt_ms + 10'd1;
			else
				cnt_ms <= 10'd0;
		end
		else 
			cnt_ms <= cnt_ms;
	end
end

//cnt_2s
always @(posedge clk or negedge rst)begin
	if(!rst)
		cnt_2s <= 1'b0;
	else if((cnt_2us == CNT_2US)&& 
			(cnt_us  == 10'd999)&& 
			(cnt_ms  == 10'd999))
		cnt_2s <= ~cnt_2s;
	else
		cnt_2s <= cnt_2s;
end

//led
always @(posedge clk or negedge rst)begin
	if(!rst)
		led <= 1'b0;
	else if(cnt_us < cnt_ms)
		led <= first_part;
	else
		led <= ~first_part;
end

endmodule