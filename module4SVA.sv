module module4SVA (
input i_clk, 
input [2:0] wishbone_st,
input i_wb_ack, 
input extra_write_r 
);

import FSMProperties::*;

// states recreated
localparam [3:0] WB_IDLE            = 3'd0,
                 WB_BURST1          = 3'd1,
                 WB_BURST2          = 3'd2,
                 WB_BURST3          = 3'd3,
                 WB_WAIT_ACK        = 3'd4;

int timeOutVal = 1000;

/*place your properties here*/
//assert group 1
assert property(FSMValidTransition(i_clk, wishbone_st == WB_IDLE, 1, ((wishbone_st == WB_BURST1) || (wishbone_st == WB_IDLE) || (wishbone_st == WB_WAIT_ACK)));
assert property(FSMValidTransition(i_clk, wishbone_st == WB_BURST1, i_wb_ack, wishbone_st == WB_BURST2));
assert property(FSMValidTransition(i_clk, wishbone_st == WB_BURST2, i_wb_ack, wishbone_st == WB_BURST3));
assert property(FSMValidTransition(i_clk, wishbone_st == WB_BURST3, i_wb_ack, wishbone_st == WB_WAIT_ACK));
assert property(FSMValidTransition(i_clk, wishbone_st == WB_WAIT_ACK, extra_write_r || !i_wb_ack, wishbone_st == WB_WAIT_ACK));
assert property(FSMValidTransition(i_clk, wishbone_st == WB_WAIT_ACK, !extra_write_r && i_wb_ack, wishbone_st == WB_IDLE));
//assert group 2, FSMOutputValid does not need to be checked
//assert group 3, FSMTimeOut
assert property(FSMTimeOut(i_clk, WB_IDLE, timeOutVal));
assert property(FSMTimeOut(i_clk, WB_BURST1, timeOutVal));
assert property(FSMTimeOut(i_clk, WB_BURST2, timeOutVal));
assert property(FSMTimeOut(i_clk, WB_BURST3, timeOutVal));
assert property(FSMTimeOut(i_clk, WB_WAIT_ACK, timeOutVal));


endmodule

module Wrapper 

bind a25_wishbone module4SVA(.*);

endmodule
