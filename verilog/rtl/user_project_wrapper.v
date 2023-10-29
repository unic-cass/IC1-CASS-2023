// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */

module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Analog (direct connection to GPIO pad---use with caution)
    // Note that analog I/O is not available on the 7 lowest-numbered
    // GPIO pads, and so the analog_io indexing is offset from the
    // GPIO indexing by 7 (also upper 2 GPIOs do not have analog_io).
    inout [`MPRJ_IO_PADS-10:0] analog_io,

    // Independent clock (on independent integer divider)
    input   user_clock2,

    // User maskable interrupt signals
    output [2:0] user_irq
);

/*--------------------------------------*/
/* EGD TOP                              */
/*--------------------------------------*/

egd_top_wrapper egd_top_wrapper (
`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V power
	.vssd1(vssd1),	// User area 1 digital ground
`endif

    // Wishbone Slave ports
    .wb_clk_i(wb_clk_i),

    // LA Signals
    // Inputs to egd_top_wrapper
    .la_data_in_65(la_data_in[65]),
    .la_data_in_58_43(la_data_in[58:43]),
    .la_data_in_60_59(la_data_in[60:59]),
    // Outputs to egd_top_wrapper
    .la_data_out_23_16(la_data_out[23:16]),
    .la_data_out_26_24(la_data_out[26:24]),
    .la_data_out_30_27(la_data_out[30:27])
);


/*--------------------------------------*/
/* R4 Butterfly                         */
/*--------------------------------------*/

R4_butter R4_butter(
`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V power
	.vssd1(vssd1),	// User area 1 digital ground
`endif
    
    .xr0(la_data_in[11:8]),
    .xr1(la_data_in[15:12]),
    .xr2(la_data_in[19:16]),
    .xr3(la_data_in[23:20]),
    .xi0(la_data_in[27:24]),
    .xi1(la_data_in[31:28]),
    .xi2(la_data_in[35:32]),
    .xi3(la_data_in[39:36]),
    .c1(la_data_in[40]),
    .c2(la_data_in[41]),
    .c3(la_data_in[42]),
    .Xro(la_data_out[11:8]),
    .Xio(la_data_out[15:12]),
    .la_oenb(la_oenb[15:8])

);

/*--------------------------------------*/
/* ALU32                                */
/*--------------------------------------*/

wb_buttons_leds wb_buttons_leds(
`ifdef USE_POWER_PINS
    .vccd1(vccd1),
    .vssd1(vssd1),
`endif
    .clk(wb_clk_i),
    .reset(wb_rst_i),

    // wb interface
    .i_wb_cyc(wbs_cyc_i),       // wishbone transaction
    .i_wb_stb(wbs_stb_i),       // strobe - data valid and accepted as long as !o_wb_stall
    .i_wb_we(wbs_we_i),        // write enable
    .i_wb_addr(wbs_adr_i),      // address
    .i_wb_data(wbs_dat_i),      // incoming data
    .o_wb_ack(wbs_ack_o),       // request is completed 
    .o_wb_data(wbs_dat_o),      // output data

    // buttons
    .buttons(io_in[7]),
    .leds(io_out[13:10]),
    .led_enb(io_oeb[17:10])

    ); 

endmodule	// user_project_wrapper

`default_nettype wire
