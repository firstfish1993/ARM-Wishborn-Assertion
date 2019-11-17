module test(clk, rst_n, o_wb_adr, o_wb_dat, i_wb_dat, o_wb_cyc, o_wb_stb, o_wb_we, i_wb_ack);
	input clk, rst_n, o_wb_cyc, o_wb_stb, o_wb_we, i_wb_ack;
	input [31:0] o_wb_adr, i_wb_dat, o_wb_dat;	

	logic [31:0] signal;
	logic [31:0] o_wb, i_wb;

	property o_wb_known(o_wb);
		 @(posedge clk) disable iff(!rst_n) $rose(o_wb_cyc & o_wb_stb & o_wb_we) |-> (!($isunknown(o_wb)) throughout (o_wb_cyc == 1)); 
	endproperty

	property i_wb_known(i_wb);
		@(posedge clk) disable iff(!rst_n) $rose(o_wb_cyc & i_wb_ack & !o_wb_we) |-> (!($isunknown(i_wb)) throughout (i_wb_ack == 1));
	endproperty

	property write;
		@(posedge clk) disable iff(!rst_n) $rose(o_wb_stb & o_wb_cyc & o_wb_we) |-> ##[1:$] (i_wb_ack[*1]);
		//(checking every clk cycle, wrong)@(posedge clk) disable iff(!rst_n) $rose(o_wb_stb & o_wb_cyc & o_wb_we) ##[1:$] (i_wb_ack[*1]);
	endproperty

	property read;
		@(posedge clk) disable iff(!rst_n) $rose(o_wb_stb & o_wb_cyc & !o_wb_we) |-> ##[1:$] (i_wb_ack[*1]);
	endproperty

	//assert layer
	assert property(o_wb_known(o_wb_adr));
	assert property(o_wb_known(o_wb_dat));
	assert property(i_wb_known(i_wb_dat));
	assert property(write);
	assert property(read);
endmodule
