module seven_seg(clk, seg_number, seg_data);
	input clk;
	input [3:0] seg_number;
	output reg [7:0] seg_data;

	always @(posedge clk) begin
		case (seg_number)
			4'd0:seg_data <= 8'b1100_0000;
			4'd1:seg_data <= 8'b1111_1001;
			4'd2:seg_data <= 8'b1010_0100;
			4'd3:seg_data <= 8'b1011_0000;
			4'd4:seg_data <= 8'b1001_1001;
			4'd5:seg_data <= 8'b1001_0010;
			4'd6:seg_data <= 8'b1000_0010;
			4'd7:seg_data <= 8'b1101_1000;
			4'd8:seg_data <= 8'b1000_0000;
			4'd9:seg_data <= 8'b1001_0000;
			4'd10:seg_data <= 8'b1111_1111;
			4'd11:seg_data <= 8'b1010_0011; //o
			4'd12:seg_data <= 8'b1000_1100; //P
			4'd13:seg_data <= 8'b1000_0110; //E
			4'd14:seg_data <= 8'b1010_1011; //n
			4'd15:seg_data <= 8'b1111_1111;
			default: seg_data <= seg_data;
		endcase
	end
	
endmodule
module lab07(
	input  CLOCK_50,
	input  [1:0] KEY,
	input  [9:0] SW,
	output [9:0] LEDR,
	output [7:0] HEX0,
	output [7:0] HEX1,
	output [7:0] HEX2,
	output [7:0] HEX3,
	output [7:0] HEX4,
	output [7:0] HEX5
);

	//		declaration 
	wire press;
	wire rst;
	wire [8:0] bright;
	reg  [3:0] state;
	reg  [3:0] nstate;
	reg  [3:0] counter;
	reg  [4:0] num[0:5];
	reg  [3:0] brightness;
	//		end of declaration
	
	//		assignment 		//dont touch
	assign bright = SW[9:1];
	assign clk = CLOCK_50;
	assign {rst, press} = KEY;
	//		end of assignment
	
	//		sample
	//assign LEDR[0] = state[0] & state[1];
	//
	
	
	
	always @(posedge clk_1hz or negedge rst) begin
		if (!rst)
			state <= 0;
		else
			state <= nstate;
	end
	
	always @(negedge press or negedge rst) begin
		if (!rst)
			nstate <= 0;
		else begin
			case (state)
				4'h0: nstate <= (SW[0]) ? 4'h1 : 4'h0;
				4'h1: nstate <= (SW[0]) ? 4'h1 : 4'h2;
				4'h2: nstate <= (SW[0]) ? 4'h3 : 4'h0;
				4'h3: nstate <= (SW[0]) ? 4'h1 : 4'h4;
				4'h4: nstate <= (SW[0]) ? 4'h5 : 4'h0;
				4'h5: nstate <= (SW[0]) ? 4'h1 : 4'h6;
				4'h6: nstate <= (SW[0]) ? 4'h5 : 4'h7;
				4'h7: nstate <= (SW[0]) ? 4'h1 : 4'h0;
				default: nstate <= nstate;
			endcase
		end
	end
	
	always @(posedge clk or negedge rst) begin
		if (!rst)
			counter <= 0;
		else if (counter == 9)
			counter <= 0;
		else
			counter <= counter + 1;
	end
	
	always @(posedge clk) begin
		if (SW[9]) brightness <= 1;
		else if (SW[8]) brightness <= 2;
		else if (SW[7]) brightness <= 3;
		else if (SW[6]) brightness <= 4;
		else if (SW[5]) brightness <= 5;
		else if (SW[4]) brightness <= 6;
		else if (SW[3]) brightness <= 7;
		else if (SW[2]) brightness <= 8;
		else if (SW[1]) brightness <= 9;
		else brightness <= 10;
		
	end

	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			num[0] <= 0;
			num[1] <= 10;
			num[2] <= 10;
			num[3] <= 10;
			num[4] <= 10;
			num[5] <= 10;
		end else if (counter <= brightness) begin //brightness
			num[0] <= state;
			if (state == 7) begin
				num[5] <= 11;
				num[4] <= 12;
				num[3] <= 13;
				num[2] <= 14;
			end else begin
				num[5] <= 10;
				num[4] <= 10;
				num[3] <= 10;
				num[2] <= 10;
			end
			
		end else begin 
			num[0] <= 10;
			num[1] <= 10;
			num[2] <= 10;
			num[3] <= 10;
			num[4] <= 10;
			num[5] <= 10;
		end
	end
	
	//		clock divider				//	dont touch
	div_clk		xc0(.clk(clk), .rst(rst), .clk_1hz(clk_1hz));
		
	//		seven segment decoder	//	dont touch
	seven_seg 	xs0(.clk(clk), .seg_number(num[0]), .seg_data(HEX0));
	seven_seg 	xs1(.clk(clk), .seg_number(num[1]), .seg_data(HEX1));
	seven_seg 	xs2(.clk(clk), .seg_number(num[2]), .seg_data(HEX2));
	seven_seg 	xs3(.clk(clk), .seg_number(num[3]), .seg_data(HEX3));
	seven_seg 	xs4(.clk(clk), .seg_number(num[4]), .seg_data(HEX4));
	seven_seg 	xs5(.clk(clk), .seg_number(num[5]), .seg_data(HEX5));
	
endmodule
