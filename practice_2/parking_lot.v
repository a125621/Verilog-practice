module parking_lot(
input rst,
input clk,
input car_in,
input car_out,
input [1:0] car_sel,
output reg [7:0] price
);
reg car_in_neg,car_out_pos;
reg in_past,in_now,out_past,out_now;
reg space1,space2,space3,space4;
reg [5:0] time1,time2,time3,time4;
reg [5:0] mux_out;
reg car1,car2,car3,car4;
reg [1:0] sel_rate1,sel_rate2,sel_rate3,sel_rate4;
reg rst_cnt1 = 1'b0;
reg rst_cnt2 = 1'b0;
reg rst_cnt3 = 1'b0;
reg rst_cnt4 = 1'b0;
reg [1:0] ps,ns;
reg load_data = 1'b0;
reg [5:0] data,price_time;
reg [1:0] price_sel;
reg [(8*4-1):0] state;

parameter 	IDLE = 2'd0,
			STAY = 2'd1,
			IN	 = 2'd2,
			OUT	 = 2'd3;

always @(*)
begin
	case(ps)
	2'd0: state = "IDLE";
	2'd1: state = "STAY";
	2'd2: state = "IN";
	2'd3: state = "OUT";
	endcase
end

always @(posedge clk) //car_in_neg
begin
	if (rst)
	begin
		in_past		<= 1'b0;
		in_now		<= 1'b0;
		car_in_neg 	<= 1'b0;
	end
	else
	begin
		{in_past, in_now} <= {in_now, car_in};
		car_in_neg <= in_past & ~in_now;
	end
end

always @(posedge clk) //car_out_pos
begin
	if (rst)
	begin
		out_past	<= 1'b1;
		out_now		<= 1'b1;
		car_out_pos <= 1'b0;
	end
	else
	begin
		{out_past, out_now} <= {out_now, car_out};
		car_out_pos <= out_now & ~out_past;
	end
end

always @(posedge clk)
begin
	if (rst)
		ps <= 2'd0;
	else
		ps <= ns;
end

always @(*)
begin
	case (ps)
	IDLE: ns = STAY;
	
	STAY:
	begin
		load_data 	= 1'b0;
		rst_cnt1	= 1'b0;
		rst_cnt2	= 1'b0;
		rst_cnt3	= 1'b0;
		rst_cnt4	= 1'b0;
		car1		= 1'b0;
		car2		= 1'b0;
		car3		= 1'b0;
		car4		= 1'b0;
		if (car_out_pos == 1'b1)
			ns = OUT;
		else if (car_in_neg == 1'b1)
			ns = IN;
		else
			ns = STAY;
	end
	IN:
	begin
		if (space1 == 1'b0)
		begin
			car1 = 1'b1;
			rst_cnt1 = 1'b0;
		end
		else if (space2 == 1'b0)
		begin
			car2 = 1'b1;
			rst_cnt2 = 1'b0;
		end
		else if (space3 == 1'b0)
		begin
			car3 = 1'b1;
			rst_cnt3 = 1'b0;
		end
		else if (space4 == 1'b0)
		begin
			car4 = 1'b1;
			rst_cnt4 = 1'b0;
		end
		ns = STAY;
	end
	OUT:
	begin
		load_data = 1'b1;
		case (car_sel)
		2'd0: rst_cnt1 = 1'b1;
		2'd1: rst_cnt2 = 1'b1;
		2'd2: rst_cnt3 = 1'b1;
		2'd3: rst_cnt4 = 1'b1;
		endcase
		ns = STAY;
	end
	endcase
end

always @(posedge clk) //cnt1
begin
	if (rst || rst_cnt1 || car1)
		time1 <= 6'd0;
	else 
		time1 <= time1 + 1'b1;
		
	if (rst || rst_cnt1)
		space1 <= 1'b0;
	else if (car1 == 1'b1)
		space1 <= 1'b1;
	else
		space1 <= space1;
	sel_rate1 <= time1[5:4];
end
always @(posedge clk) //cnt2
begin
	if (rst || rst_cnt2 || car2)
		time2 <= 6'd0;
	else 
		time2 <= time2 + 1'b1;
		
	if (rst || rst_cnt2)
		space2 <= 1'b0;
	else if (car2 == 1'b1)
		space2 <= 1'b1;
	else
		space2 <= space2;
	sel_rate2 <= time2[5:4];
end
always @(posedge clk) //cnt3
begin
	if (rst || rst_cnt3 || car3)
		time3 <= 6'd0;
	else 
		time3 <= time3 + 1'b1;
		
	if (rst || rst_cnt3)
		space3 <= 1'b0;
	else if (car3 == 1'b1)
		space3 <= 1'b1;
	else
		space3 <= space3;
	sel_rate3 <= time3[5:4];
end
always @(posedge clk) //cnt4
begin
	if (rst || rst_cnt4 || car4)
		time4 <= 6'd0;
	else 
		time4 <= time4 + 1'b1;
		
	if (rst || rst_cnt4)
		space4 <= 1'b0;
	else if (car4 == 1'b1)
		space4 <= 1'b1;
	else
		space4 <= space4;
	sel_rate4 <= time4[5:4];
end

always @(*) //mux4*1
begin
	case (car_sel)
	2'd0: mux_out = time1;
	2'd1: mux_out = time2;
	2'd2: mux_out = time3;
	2'd3: mux_out = time4;
	endcase
end

always @(posedge clk) //diff data
begin
	if (rst)
		data <= 6'd0;
	else if (load_data)
		data <= mux_out;
	else
		data <= data;
end

always @(*) //price calculate
begin
	price_time = data;
	price_sel  = data[5:4];
	case (price_sel)
	2'b00: price = price_time;
	2'b01: price = 5'd16 + (price_time[3:0] << 1);
	2'b10: price = 5'd16 + 6'd32 + (price_time[3:0] << 2);
	2'b11: price = 5'd16 + 6'd32 + 7'd64 + (price_time[3:0] << 3);
	endcase
end
endmodule

module parking_lot_test;
reg rst;
reg clk;
reg car_in;
reg car_out;
reg [1:0] car_sel;
wire [7:0] price;

parking_lot T1(
.rst(rst),
.clk(clk),
.car_in(car_in),
.car_out(car_out),
.car_sel(car_sel),
.price(price)
);

always #5 clk = ~clk;

initial begin 
		rst = 1'b1; clk = 1'b0; car_sel = 1'b0; car_in = 1'b0; car_out = 1'b0;
#10		rst = 1'b0;
#50		car_in = 1'b1; //one car in (choose space1)
#50		car_in = 1'b0;
#50		car_in = 1'b1; //one car in (choose space2)
#50		car_in = 1'b0;
#50		car_in = 1'b1; //one car in (choose space3)
#50		car_in = 1'b0;
#50		car_in = 1'b1; //one car in (choose space4)
#50		car_in = 1'b0;
#50		car_in = 1'b1; //one car in (parking lot full, do nothing)
#50		car_in = 1'b0;
#50		car_sel = 2'd1; car_out = 1'b1; //space2 car out
#50		car_out = 1'b0;
#50		car_sel = 2'd0; car_out = 1'b1; //space1 car out
#50		car_out = 1'b0;
#20		car_sel = 2'd3; car_out = 1'b1; //space4 car out
#50		car_out = 1'b0;
#20		car_in = 1'b1; //one car in (choose space1)
#30		car_in = 1'b0;
#50		car_sel = 2'd2; car_out = 1'b1; //space3 car out
#30		car_out = 1'b0;
#20		car_in = 1'b1; //one car in (choose space2)
#30		car_in = 1'b0;
#20		car_in = 1'b1; //one car in (choose space3)
#30		car_in = 1'b0;
#50		car_sel = 2'd1; car_out = 1'b1; //space2 car out
#30		car_out = 1'b0;
#20		car_in = 1'b1; //one car in (choose space2)
#30		car_in = 1'b0;
#100	$stop;
end
endmodule
