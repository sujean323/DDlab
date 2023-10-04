module multiplier(clk, rst, A, B, Y);
input	 clk;
input	 rst;
input	 [3:0]A;
input  [2:0]B;
output [7:0]Y;

reg [3:0] r1,r2,r3;
reg [7:0] P;

assign Y = P; 

always@(posedge clk or negedge rst)
begin  
	if(!rst)
	begin
		r1 <= 0;
		r2 <= 0;
		r3 <= 0;
		P <= 0;
	end
	else begin
		r1[0] <= A[0] & B[0];
		r1[1] <= A[1] & B[0];
		r1[2] <= A[2] & B[0];
		r1[3] <= A[3] & B[0];
		r2[0] <= A[0] & B[1];
		r2[1] <= A[1] & B[1];
		r2[2] <= A[2] & B[1];
		r2[3] <= A[3] & B[1];
		r3[0] <= A[0] & B[2];
		r3[1] <= A[1] & B[2];
		r3[2] <= A[2] & B[2];
		r3[3] <= A[3] & B[2];
		P <= {3'b000, r1} + {2'b00, r2, 1'b0} +{1'b0, r3, 3'b000};
	end
end


endmodule 