module traffic_light(
    input clk,
    input rst,
    output reg [3:0] sec1,
    output reg [3:0] sec2,
    output reg [2:0] led1,
    output reg [2:0] led2
);

    reg [2:0] cnt1, cnt2;
    reg cnt1_rst, cnt2_rst;
    reg [3:0] ps, ns;
    reg [(8*6-1):0] state; //8是因为一个word是bits
    reg [(8*1-1):0] led1_state, led2_state;

    parameter IDLE =   3'd0,
              LED2_G = 3'd1,
              LED2_Y = 3'd2,
              LED1_G = 3'd3,
              LED1_Y = 3'd4;
//设定参数
    parameter N = 3'b111,
              R = 3'b100,
              Y = 3'b010,
              G = 3'b001;
//设定状态
    always @(*) begin
        case (ps)
            3'd0: state = "IDLE";
            3'd1: state = "LED2 G";
            3'd2: state = "LED2 Y";
            3'd3: state = "LED1 G";
            3'd4: state = "LED1 Y";
        endcase
    end
//将状态与灯号连接
    always @(*) begin
        case (led1)
            3'b111: led1_state = "N";
            3'b100: led1_state = "R";
            3'b010: led1_state = "Y";
            3'b001: led1_state = "G";
        endcase
        case (led2)
            3'b111: led2_state = "N";
            3'b100: led2_state = "R";
            3'b010: led2_state = "Y";
            3'b001: led2_state = "G";
        endcase
    end

    always @(posedge clk) begin
        if (rst) 
            ps <= IDLE;
        else
            ps <= ns;
    end

    always @(posedge clk) begin
        if (rst || cnt1_rst) begin
            cnt1 <= 4'd0;
            cnt1_rst <= 1'b1;
        end
        else
            cnt1 <= cnt1 + 1'b1;
    end

    always @(posedge clk) begin
        if (rst || cnt2_rst) begin
            cnt2 <= 4'd0;
            cnt2_rst <= 1'b1;
        end
        else
            cnt2 <= cnt2 + 1'b1;
    end

    always @(*) begin
        case (ps)
            IDLE: begin
                led1 = 3'b111;
                led2 = 3'b111;
                sec1 = 4'd15;
                sec2 = 4'd15;
                ns = LED2_G;
            end
            LED2_G: begin
                cnt1_rst = 1'b0;
                cnt2_rst = 1'b0;
                led1 = 3'b100;
                led2 = 3'b001;
                sec1 = 4'd8 - cnt1;
                sec2 = 4'd6 - cnt2;
                if (sec2 == 4'd1) begin
                    cnt2_rst = 1'b1;
                    ns = LED2_Y;
                end
            end
            LED2_Y: begin
                cnt2_rst = 1'b0;
                led1 = 3'b100;
                led2 = 3'b010;
                sec1 = 4'd8 - cnt1;
                sec2 = 4'd2 - cnt2;
                if (sec2 == 4'd1) begin
                    cnt1_rst = 1'b1;
                    cnt2_rst = 1'b1;
                    ns = LED1_G;
                end
            end
            LED1_G: begin
                cnt1_rst = 1'b0;
                cnt2_rst = 1'b0;
                led1 = 3'b001;
                led2 = 3'b100;
                sec1 = 4'd11 - cnt1;
                sec2 = 4'd13 - cnt2;
                if (sec1 == 4'd1) begin
                    cnt1_rst = 1'b1;
                    ns = LED1_Y;
                end
            end
            LED1_Y: begin
                cnt1_rst = 1'b0;
                led1 = 3'b010;
                led2 = 3'b100;
                sec1 = 4'd2 - cnt1;
                sec2 = 4'd13 - cnt2;
                if (sec1 == 4'd1) begin
                    cnt1_rst = 1'b1;
                    cnt2_rst = 1'b1;
                    ns = LED2_G;
                end
            end
        endcase
    end
endmodule

module traffic_light_test;
    reg clk;
    reg rst;
    wire [3:0] sec1;
    wire [3:0] sec2;
    wire [2:0] led1;
    wire [2:0] led2;

    traffic_light T1(
        .clk(clk),
        .rst(rst),
        .sec1(sec1),
        .sec2(sec2),
        .led1(led1),
        .led2(led2)
    );

    always #5 clk = ~clk;
    
    initial begin
        rst = 1'b1; clk = 1'b0;
        #10
        rst = 1'b0;
        #450
        $stop;
    end
endmodule