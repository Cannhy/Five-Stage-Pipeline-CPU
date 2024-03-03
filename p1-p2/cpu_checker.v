`timescale 1ns / 1ps
module cpu_checker(
    input clk,
    input reset,
    input [7:0] char,
	 input [15:0] freq,
    output [1:0] format_type,
    output  reg [3:0] error_code
    );
    reg [3:0] status = 4'd0;
	 reg [2:0] d_count = 3'd0;
	 reg [3:0] h_count = 4'd0;
	 reg [1:0] out = 2'b00;
	 reg [15:0] time_ = 0;
	 reg [31:0] pc = 0;
	 reg [31:0] addr = 0;
	 reg [15:0] grf = 0;
	 reg [3:0] error1=0;
	 reg [3:0] error2=0;
	 reg [3:0] error3=0;
	 reg [15:0] freq_right;
	 reg [3:0] error4=0;
	 reg format_type;
	 integer i ;
	 wire [1:0] char_type;
	     assign char_type = (char >= "0" && char <= "9")? 2'b01 :
				                    (char >= "a" && char <= "f")? 2'b10 : 2'b00;
    always @(posedge clk) begin
	    freq_right <= (freq>>1);
	   if(reset == 1'b1)begin
	     status <= 4'd0;
		  d_count <= 3'd0;
		  h_count <= 4'd0;
		  out <= 2'b0;
		end
	   else begin
		case(status)
		 4'd0 : begin
		     d_count <= 3'd0;
			  h_count <= 4'd0;
			  out <= 2'b0;
			  time_ <= 0;
	        pc <= 0;
	        addr <= 0;
	        grf <= 0;
		     if(char == "^") status <= 4'd1;
			  else status <= 4'd0;
		 end
		 4'd1 : begin
		     if(char_type == 2'b01 && (d_count <= 3'd2))begin
			   status <= 4'd1;
			   d_count <= d_count + 3'd1;
				time_ <= ((time_ << 4) - (time_ << 2) - (time_ << 1) + (char - "0"));
			  end
			  else if(char_type == 2'b01 && d_count == 3'd3)begin
			   status <= 4'd2;
				d_count <= 0;
				time_ <= ((time_ << 4) - (time_ << 2) - (time_ << 1) + (char - "0"));
			  end
			  else if(char == "@" && d_count != 3'd0) begin
			  status <= 4'd3;
			  end
			  else if(char == "^") begin
			  status <= 4'd1;
			  d_count <= 3'd0;
			  h_count <= 4'd0;
			  out <= 2'b0;
			  			  time_ <= 0;
	        pc <= 0;
	        addr <= 0;
	        grf <= 0;
			  end
			  else status <= 4'd0;
		 end
		 4'd2 : begin
		     if(char == "@" ) begin 
			  status <= 4'd3;
			  end
			  else if(char == "^") begin
			  status <= 4'd1;
			  d_count <= 0;
			  h_count <= 0;
			  out <= 2'b0;
			  			  time_ <= 0;
	        pc <= 0;
	        addr <= 0;
	        grf <= 0;
			  end
			  else status <= 4'd0;
		 end
		 4'd3 : begin
		     d_count <= 3'd0;
		     if(char_type != 2'b00 && h_count < 4'd7)begin
			  status <= 4'd3;
			  h_count <= h_count + 1;
			    if(char_type == 2'b01) pc <= ((pc << 4) + (char - "0")) ;
			    else pc <= ((pc << 4) + (char - "a") + 10) ;
			  end
			  else if(char_type != 2'b00 && h_count == 4'd7)begin
			  status <= 4'd4;
			  h_count <= 0;
			    if(char_type == 2'b01) pc <= ((pc << 4) + (char - "0")) ;
			    else pc <= ((pc << 4) + (char - "a") + 10) ;
			  end
			  else if(char == "^") begin
			  status <= 4'd1;
			  d_count <= 0;
			  h_count <= 0;
			  out <= 2'b0;
			  			  time_ <= 0;
	        pc <= 0;
	        addr <= 0;
	        grf <= 0;
			  end
			  else status <= 4'd0;
		  end
		  4'd4 : begin
		     if(char == ":")begin
			  status <= 4'd5;
			  end
			 else if(char == "^") begin
			  status <= 4'd1;
			  d_count <= 0;
			  h_count <= 0;
			  out <= 2'b0;
			  			  time_ = 0;
	        pc <= 0;
	        addr <= 0;
	        grf <= 0;
			  end
			  else status <= 4'd0;
		  end
		  4'd5 : begin
		     if(char == " ") status <= 4'd5;
			  else if(char == "$") begin
			  status <= 4'd6; 
			   out <= 2'b01;
				i <= 0;
			  end
			  else if(char == 8'd42) begin
			  status <= 4'd7; 
			  out <= 2'b10;
			  end
			  else if(char == "^") begin
			  status <= 4'd1;
			  d_count <= 0;
			  h_count <= 0;
			  out <= 2'b0;
			  			  time_ <= 0;
	        pc <= 0;
	        addr <= 0;
	        grf <= 0;
			  end
			  else status <= 4'd0;
		  end
		  4'd6: begin
		     if(char_type == 2'b01 && d_count < 3'd3)begin
			   status <= 4'd6;
			   d_count <= d_count + 3'b1;
				grf <= ((grf << 4) - (grf << 2) - (grf << 1) + (char - "0"));
			  end
			  else if(char_type == 2'b01 && d_count == 3'd3)begin
			   status <= 4'd8;
				d_count <= 0;
				grf <= ((grf << 4) - (grf << 2) - (grf << 1) + (char - "0"));
			  end
			  else if(char_type == 2'b01 && d_count > 3'b11)begin
			   status <= 4'd0;
				grf <= ((grf << 4) - (grf << 2) - (grf << 1) + (char - "0"));
			  end
			  else if(char == " " && d_count != 3'd0) begin
			  status <= 4'd8;
			  end
			  else if(char == "<" && d_count != 3'd0) status <= 4'd9;
			 else if(char == "^") begin
			  status <= 4'd1;
			  d_count <= 0;
			  h_count <= 0;
			  out <= 2'b0;
			  time_ <= 0;
	        pc <= 0;
	        addr <= 0;
	        grf <= 0;
			  end
			  else status <= 4'd0;
		  end
		  4'd7 : begin
		     if(char_type != 2'b00 && h_count < 4'd7)begin
			  status <= 4'd7;
			  h_count <= h_count + 1;
			    if(char_type == 2'b01) addr <= ((addr << 4) + (char - "0")) ;
			    else addr <= ((addr << 4) + (char - "a") + 10) ;
			  end
			  else if(char_type != 2'b00 && h_count == 4'd7)begin
			  status <= 4'd8;
			  h_count <= 0;
			    if(char_type == 2'b01) addr <= ((addr << 4) + (char - "0")) ;
			    else addr <= ((addr << 4) + (char - "a") + 10) ;
			  end
			else if(char == "^") begin
			  status <= 4'd1;
			  d_count <= 0;
			  h_count <= 0;
			  out <= 2'b0;
			  			  time_ <= 0;
	        pc <= 0;
	        addr <= 0;
	        grf <= 0;
			  end
			  else status <= 4'd0;
		  end
		  4'd8 : begin
		     if(char == " ") status <= 4'd8;
			  else if(char == "<") status <= 4'd9;
			  else if(char == "^") begin
			  status <= 4'd1;
			  d_count <= 0;
			  h_count <= 0;
			  out <= 2'b0;
			  			  time_ <= 0;
	        pc <= 0;
	        addr <= 0;
	        grf <= 0;
			  end
			  else status <= 4'd0;
		  end
		  4'd9: begin
		     if(char == "=") status <= 4'd10;
			  else if(char == "^") begin
			  status <= 4'd1;
			  d_count <= 0;
			  h_count <= 0;
			  out <= 2'b0;
			  			  time_ <= 0;
	        pc <= 0;
	        addr <= 0;
	        grf <= 0;
			  end
			  else status <= 4'd0;
		  end
		  4'd10 : begin
		     if(char == " ") status <= 4'd10;
			  else if(char_type != 2'b00)begin
			  status <= 4'd11;
			  h_count <= h_count + 1;
			  end
			 else if(char == "^") begin
			  status <= 4'd1;
			  d_count <= 0;
			  h_count <= 0;
			  out <= 2'b0;
			  			  time_ = 0;
	        pc <= 0;
	        addr <= 0;
	        grf <= 0;
			  end
			  else status <= 4'd0;
		  end
		  4'd11 : begin
		     if(char_type != 2'b00 && h_count < 4'd7)begin
			  status <= 4'd11;
			  h_count <= h_count + 1;
			  end
			  else if(char_type != 2'b00 && h_count == 4'd7)begin
			  status <= 4'd12;
			  h_count <= 0;
			  end
			  else if(char == "^") begin
			  status <= 4'd1;
			  d_count <= 0;
			  h_count <= 0;
			  out <= 2'b0;
			  			  time_ <= 0;
	        pc <= 0;
	        addr <= 0;
	        grf <= 0;
			  end
			  else status <= 4'd0;
		  end
		  4'd12 : begin
		     if(char == "#") status <= 4'd13;
			  else if(char == "^") begin
			  status <= 4'd1;
			  d_count <= 0;
			  h_count <= 0;
			  out <= 2'b0;
			  			  time_ <= 0;
	        pc <= 0;
	        addr <= 0;
	        grf <= 0;
			  end
			  else status <= 4'd0;
		end
		  4'd13 : begin
		     if(char == "^")begin
			  status <= 4'd1;
			  d_count <= 0;
			  h_count <= 0;
			  out <= 2'b0;
			  			  time_ <= 0;
	        pc <= 0;
	        addr <= 0;
	        grf <= 0;
			  end
			  else status <= 4'd0;
		  end
		  endcase
		  if((time_ &(freq_right - 1)) == 0) error1 <= 4'b0000;
		  else error1 <= 4'b0001;
		  if((pc >= 32'h0000_3000 && pc <= 32'h0000_4fff) && (pc == ((pc >> 2) << 2)))begin
		     error2 <= 4'b0000;
		  end
		  else error2 <= 4'b0010;
		  if(out == 2'b10)begin
		    if((addr >= 32'h0000_0000 && addr <= 32'h0000_2fff) && (addr == ((addr >> 2) << 2)))begin
		       error3 <= 4'b0000;
		    end
		    else error3 <= 4'b0100;
		  end
		  else error3 <= 4'b0000;
		  if(out == 2'b01) begin
		    if(grf >= 0 && grf <= 31)begin
		    error4 <= 4'b0000;
		    end
		    else error4 <= 4'b1000;
		  end
		  else error4 <= 4'b0000;
	 end
        assign format_type = (status == 4'd13 && out == 2'b01)? 2'b01 :
		                       (status == 4'd13 && out == 2'b10)? 2'b10 : 2'b00;
		  assign error_code = (status != 4'd13)? 4'b0000 : 
		                       (error1 + error2 + error3 + error4);
									  
end
endmodule