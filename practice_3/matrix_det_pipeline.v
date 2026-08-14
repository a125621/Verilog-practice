module matrix_det_pipeline(
input clk,
input signed [3:0] a11,a12,a13,a21,a22,a23,a31,a32,a33,
input signed [3:0] b11,b12,b13,b21,b22,b23,b31,b32,b33,
output signed [31:0] out_ab_det
);
reg signed [31:0] p1_a11,p1_a12,p1_a13,p1_a21,p1_a22,p1_a23,p1_a31,p1_a32,p1_a33;
reg signed [31:0] p1_b11,p1_b12,p1_b13,p1_b21,p1_b22,p1_b23,p1_b31,p1_b32,p1_b33;
wire signed [31:0] ab11_1,ab11_2,ab11_3,ab12_1,ab12_2,ab12_3,ab13_1,ab13_2,ab13_3;
wire signed [31:0] ab21_1,ab21_2,ab21_3,ab22_1,ab22_2,ab22_3,ab23_1,ab23_2,ab23_3;
wire signed [31:0] ab31_1,ab31_2,ab31_3,ab32_1,ab32_2,ab32_3,ab33_1,ab33_2,ab33_3;
reg signed [31:0] p2_ab11_1,p2_ab11_2,p2_ab11_3,p2_ab12_1,p2_ab12_2,p2_ab12_3,p2_ab13_1,p2_ab13_2,p2_ab13_3;
reg signed [31:0] p2_ab21_1,p2_ab21_2,p2_ab21_3,p2_ab22_1,p2_ab22_2,p2_ab22_3,p2_ab23_1,p2_ab23_2,p2_ab23_3;
reg signed [31:0] p2_ab31_1,p2_ab31_2,p2_ab31_3,p2_ab32_1,p2_ab32_2,p2_ab32_3,p2_ab33_1,p2_ab33_2,p2_ab33_3;
wire signed [31:0] ab11,ab12,ab13,ab21,ab22,ab23,ab31,ab32,ab33;
reg signed [31:0] p3_ab11,p3_ab12,p3_ab13,p3_ab21,p3_ab22,p3_ab23,p3_ab31,p3_ab32,p3_ab33;
wire signed [31:0] ab11_m_ab22,ab12_m_ab23,ab13_m_ab21;
wire signed [31:0] ab11_m_ab23,ab12_m_ab21,ab13_m_ab22;
reg signed [31:0] p4_ab11_m_ab22,p4_ab12_m_ab23,p4_ab13_m_ab21,p4_ab11_m_ab23,p4_ab12_m_ab21,p4_ab13_m_ab22;
reg signed [31:0] p4_ab31, p4_ab32, p4_ab33;
wire signed [31:0] det_add1,det_add2,det_add3,det_sub1,det_sub2,det_sub3;
reg signed [31:0] p5_det_add1,p5_det_add2,p5_det_add3,p5_det_sub1,p5_det_sub2,p5_det_sub3;
always @(posedge clk)//pipeline1
begin
	p1_a11 <= a11;
	p1_a12 <= a12;
	p1_a13 <= a13;
	p1_a21 <= a21;
	p1_a22 <= a22;
	p1_a23 <= a23;
	p1_a31 <= a31;
	p1_a32 <= a32;
	p1_a33 <= a33;
	
	p1_b11 <= b11;
	p1_b12 <= b12;
	p1_b13 <= b13;
	p1_b21 <= b21;
	p1_b22 <= b22;
	p1_b23 <= b23;
	p1_b31 <= b31;
	p1_b32 <= b32;
	p1_b33 <= b33;
end


assign ab11_1 = p1_a11*p1_b11, ab11_2 = p1_a12*p1_b21, ab11_3 = p1_a13*p1_b31;
assign ab12_1 = p1_a11*p1_b12, ab12_2 = p1_a12*p1_b22, ab12_3 = p1_a13*p1_b32;
assign ab13_1 = p1_a11*p1_b13, ab13_2 = p1_a12*p1_b23, ab13_3 = p1_a13*p1_b33;

assign ab21_1 = p1_a21*p1_b11, ab21_2 = p1_a22*p1_b21, ab21_3 = p1_a23*p1_b31;
assign ab22_1 = p1_a21*p1_b12, ab22_2 = p1_a22*p1_b22, ab22_3 = p1_a23*p1_b32;
assign ab23_1 = p1_a21*p1_b13, ab23_2 = p1_a22*p1_b23, ab23_3 = p1_a23*p1_b33;

assign ab31_1 = p1_a31*p1_b11, ab31_2 = p1_a32*p1_b21, ab31_3 = p1_a33*p1_b31;
assign ab32_1 = p1_a31*p1_b12, ab32_2 = p1_a32*p1_b22, ab32_3 = p1_a33*p1_b32;
assign ab33_1 = p1_a31*p1_b13, ab33_2 = p1_a32*p1_b23, ab33_3 = p1_a33*p1_b33;


always @(posedge clk)//pipeline2
begin
	p2_ab11_1 <= ab11_1; p2_ab11_2 <= ab11_2; p2_ab11_3 <= ab11_3;
	p2_ab12_1 <= ab12_1; p2_ab12_2 <= ab12_2; p2_ab12_3 <= ab12_3;
	p2_ab13_1 <= ab13_1; p2_ab13_2 <= ab13_2; p2_ab13_3 <= ab13_3;
	
	p2_ab21_1 <= ab21_1; p2_ab21_2 <= ab21_2; p2_ab21_3 <= ab21_3;
	p2_ab22_1 <= ab22_1; p2_ab22_2 <= ab22_2; p2_ab22_3 <= ab22_3;
	p2_ab23_1 <= ab23_1; p2_ab23_2 <= ab23_2; p2_ab23_3 <= ab23_3;
	
	p2_ab31_1 <= ab31_1; p2_ab31_2 <= ab31_2; p2_ab31_3 <= ab31_3;
	p2_ab32_1 <= ab32_1; p2_ab32_2 <= ab32_2; p2_ab32_3 <= ab32_3;
	p2_ab33_1 <= ab33_1; p2_ab33_2 <= ab33_2; p2_ab33_3 <= ab33_3;
end


assign ab11 = p2_ab11_1 + p2_ab11_2 + p2_ab11_3;
assign ab12 = p2_ab12_1 + p2_ab12_2 + p2_ab12_3;
assign ab13 = p2_ab13_1 + p2_ab13_2 + p2_ab13_3;
assign ab21 = p2_ab21_1 + p2_ab21_2 + p2_ab21_3;
assign ab22 = p2_ab22_1 + p2_ab22_2 + p2_ab22_3;
assign ab23 = p2_ab23_1 + p2_ab23_2 + p2_ab23_3;
assign ab31 = p2_ab31_1 + p2_ab31_2 + p2_ab31_3;
assign ab32 = p2_ab32_1 + p2_ab32_2 + p2_ab32_3;
assign ab33 = p2_ab33_1 + p2_ab33_2 + p2_ab33_3;

always @(posedge clk)//pipeline3
begin
	p3_ab11 <= ab11; p3_ab12 <= ab12; p3_ab13 <= ab13;
	p3_ab21 <= ab21; p3_ab22 <= ab22; p3_ab23 <= ab23;
	p3_ab31 <= ab31; p3_ab32 <= ab32; p3_ab33 <= ab33;
end

assign ab11_m_ab22 = p3_ab11 * p3_ab22;
assign ab12_m_ab23 = p3_ab12 * p3_ab23;
assign ab13_m_ab21 = p3_ab13 * p3_ab21;

assign ab13_m_ab22 = p3_ab13 * p3_ab22;
assign ab12_m_ab21 = p3_ab12 * p3_ab21;
assign ab11_m_ab23 = p3_ab11 * p3_ab23;

always @(posedge clk)//pipeline4
begin
	p4_ab11_m_ab22 <= ab11_m_ab22; p4_ab12_m_ab23 <= ab12_m_ab23; p4_ab13_m_ab21 <= ab13_m_ab21;
	p4_ab13_m_ab22 <= ab13_m_ab22; p4_ab12_m_ab21 <= ab12_m_ab21; p4_ab11_m_ab23 <= ab11_m_ab23;
	p4_ab31 <= p3_ab31; p4_ab32 <= p3_ab32; p4_ab33 <= p3_ab33;
end

assign det_add1 = p4_ab11_m_ab22 * p4_ab33;
assign det_add2 = p4_ab12_m_ab23 * p4_ab31;
assign det_add3 = p4_ab13_m_ab21 * p4_ab32;

assign det_sub1 = p4_ab13_m_ab22 * p4_ab31;
assign det_sub2 = p4_ab12_m_ab21 * p4_ab33;
assign det_sub3 = p4_ab11_m_ab23 * p4_ab32;

always @(posedge clk)
begin
	p5_det_add1 <= det_add1;
	p5_det_add2 <= det_add2;
	p5_det_add3 <= det_add3;
	p5_det_sub1 <= det_sub1;
	p5_det_sub2 <= det_sub2;
	p5_det_sub3 <= det_sub3;
end

assign out_ab_det = p5_det_add1 + p5_det_add2 + p5_det_add3 
					- p5_det_sub1 - p5_det_sub2 - p5_det_sub3;
				
endmodule

module matrix_det_pipeline_test;
reg clk;
reg signed [3:0] a11,a12,a13,a21,a22,a23,a31,a32,a33;
reg signed [3:0] b11,b12,b13,b21,b22,b23,b31,b32,b33;
wire signed [31:0] out_ab_det;

matrix_det_pipeline T1(
.clk(clk),
.a11(a11),
.a12(a12),
.a13(a13),
.a21(a21),
.a22(a22),
.a23(a23),
.a31(a31),
.a32(a32),
.a33(a33),
.b11(b11),
.b12(b12),
.b13(b13),
.b21(b21),
.b22(b22),
.b23(b23),
.b31(b31),
.b32(b32),
.b33(b33),
.out_ab_det(out_ab_det)
);

always #5 clk = ~clk;

initial begin
	clk = 0;
	
	a11	= 4'b0010;	
	a12	= 4'b1100;   
	a13	= 4'b0101;   
	a21	= 4'b1001;   
	a22	= 4'b0111;   
	a23	= 4'b0110;    
	a31 = 4'b1000;
	a32 = 4'b0101;
	a33 = 4'b0101;
	
	b11 = 4'b0100;
	b12 = 4'b1011;
	b13 = 4'b0111;
	b21 = 4'b1111;
	b22 = 4'b0100;
	b23 = 4'b0011;
	b31 = 4'b0100;
	b32 = 4'b0011;
	b33 = 4'b1000;	   #45
	a11	= 4'b1101;	
	a12	= 4'b0010;   
	a13	= 4'b1110;   
	a21	= 4'b0100;   
	a22	= 4'b1011;   
	a23	= 4'b0111;    
	a31 = 4'b1110;
	a32 = 4'b0010;
	a33 = 4'b0110;
	
	b11 = 4'b1000;
	b12 = 4'b0101;
	b13 = 4'b0101;
	b21 = 4'b0111;
	b22 = 4'b0010;
	b23 = 4'b0111;
	b31 = 4'b1010;
	b32 = 4'b0101;
	b33 = 4'b0100;   
	   
	#100;
	$stop;
end
endmodule
