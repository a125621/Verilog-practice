module parking_space(
input clk,
input rst,
input car,
output reg [15:0] min
);

reg [15:0] cnt;
reg enc_pos,enc_neg;
reg cnt_rst;
reg [1:0] ps,ns;
reg [(8*8-1):0] state;
reg load;
reg s_sig_pos,d_sig_pos;
reg s_sig_neg,d_sig_neg;

parameter	IDLE		= 2'd0,
			WAIT_POS	= 2'd1,
			WAIT_NEG	= 2'd2;
			
always @(*)
begin
	case (ps)
	2'd0: state = "IDLE";
	2'd1: state = "WAIT_POS";
	2'd2: state = "WAIT_NEG";
	endcase
end
	

//posetive edge detector
always @(posedge clk)
begin
	if (rst)
	begin
		s_sig_pos 	<= 1'b1;
		d_sig_pos 	<= 1'b1;
		enc_pos		<= 1'b1;
	end
	else
	begin
		{d_sig_pos, s_sig_pos} <= {s_sig_pos, car};
		enc_pos <= s_sig_pos & ~d_sig_pos;
	end
end

//negetive edge detector
always @(posedge clk)
begin
	if (rst)
	begin
		s_sig_neg 	<= 1'b0;
		d_sig_neg 	<= 1'b0;
		enc_neg		<= 1'b0;
	end
	else
	begin
		{d_sig_neg, s_sig_neg} <= {s_sig_neg, car};
		enc_neg <= d_sig_neg & ~s_sig_neg;
	end
end

always @(posedge clk)
begin
	if (rst || cnt_rst)
		cnt <= 16'd0;
	else
		cnt <= cnt + 1'b1;
end

always @(posedge clk)
begin
	if (rst)
		ps <= IDLE;
	else
		ps <= ns;
end

always @(*)
begin
	case (ps)
	IDLE: 	ns = WAIT_POS;
	
	WAIT_POS:
	begin
		cnt_rst = 1'b0;
		load 	= 1'b0;
		if (enc_pos)
		begin
			ns = WAIT_NEG;
			cnt_rst = 1'b1;
		end
		else
			ns = WAIT_POS;
	end
	WAIT_NEG:
	begin
		cnt_rst = 1'b0;
		if (enc_neg)
		begin
			ns = WAIT_POS;
			load = 1'b1;
		end
		else
			ns = WAIT_NEG;
	end
	endcase
end

always @(posedge clk)
begin
	if(rst)
		min <= 16'd0;
	else if (load)
		min <= cnt;
	else
		min <= min;
end
endmodule

module parking_space_test;
reg clk;
reg rst;
reg car;
wire [15:0] min;

parking_space T1(
.clk(clk),
.rst(rst),
.car(car),
.min(min)
);

always #5 clk = ~clk;
initial begin
		clk = 1'b0; rst = 1'b1; car = 1'b0;
#10		rst = 1'b0;
#50		car = 1'b1;
#50		car = 1'b0;
#100	car = 1'b1;
#150	car = 1'b0;
#350	car = 1'b1;
#400	car = 1'b0;
#250	car = 1'b1;
#350	car = 1'b0;
#200	$stop;
end
endmodule