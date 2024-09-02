module baudrate #(
parameter BAUD = 150000
)(
    input clk_in,
    input enable,
    output clk_out,
    output half_clk_out,
    output quarter_clk_out
);



//assumes a 12MHz input clock
//-- Constant division of 16MHz to get needed baud rates
//rates primarily for DSHOT
`define B600000 20
`define B300000 40 
`define B150000 80
//rates primarily for UART
`define B115200 104 
`define B57600  208
`define B38400  313
`define B19200  625
`define B9600   1250
`define B4800   2500
`define B2400   5000
`define B1200   10000
`define B600    20000
`define B300    40000
//Useful rates for PWM output
`define B255000 47
`define B1000   12000
`define B50     240000
//5Hz rate for easy visualization/testing
`define B5      2400000


//lookup table for baud values
localparam BAUDRATE = (BAUD==600000) ? `B600000 : //-- OK
                      (BAUD==300000) ? `B300000 : //-- OK
                      (BAUD==255000) ? `B255000 : //-- OK
                      (BAUD==150000) ? `B150000 : //-- OK
                      (BAUD==115200) ? `B115200 : //-- OK
                      (BAUD==57600)  ? `B57600  : //-- OK
                      (BAUD==38400)  ? `B38400  : //-- Ok
                      (BAUD==19200)  ? `B19200  : //-- OK
                      (BAUD==9600)   ? `B9600   : //-- OK
                      (BAUD==4800)   ? `B4800   : //-- OK 
                      (BAUD==2400)   ? `B2400   : //-- OK
                      (BAUD==1200)   ? `B1200   : //-- OK
                      (BAUD==1000)    ? `B1000    : //-- OK
                      (BAUD==600)    ? `B600    : //-- OK
                      (BAUD==300)    ? `B300    : //-- OK
                      (BAUD==50)      ? `B50    : //-- OK
                      (BAUD==5)      ? `B5    : //-- OK
                      `B115200 ;  //-- Default to 115200 if invalid rate specified




//-- calculate the size needed to store divisor
localparam N = $clog2(BAUDRATE);

//-- calculate sub-cycle points of baudrate
localparam BAUD2 = (BAUDRATE >> 1);
localparam BAUD4 = (BAUDRATE >> 2);


//-- System counter, to wait for a time of
//-- a quarter of a bit (BAUD4)

//-- NOTE: could have N-2 bits in principle
/*reg [N-1: 0] div2counter = 0;

always @(posedge clk)

  //-- Contar
  if (ena) begin
    //-- Solo cuenta hasta BAUD2, luego  
    //-- se queda en ese valor hasta que
    //-- ena se desactiva
    if (div2counter < BAUD4) 
      div2counter <= div2counter + 1;
  end else
    div2counter <= 0;
*/
//-- Enable main baud generator
//-- when this first counter ends
//wire ena2 = (div2counter == BAUD4);


//------ Main frequency generator

//-- Contador para implementar el divisor
//-- Es un contador modulo BAUDRATE
reg [N-1:0] divcounter = 0;

//-- reset signal
wire reset;

//-- check for reset otherwise update clock each cycle
always @(posedge clk_in)
  if (reset)
    divcounter <= 0;
  else
    divcounter <= divcounter + 1;

wire ov;
assign ov = (divcounter == BAUDRATE-1);

wire half_cycle;
assign half_cycle = (divcounter > BAUD2);

wire quarter_cycle;
assign quarter_cycle = (((divcounter > BAUD4) && (!half_cycle))
                        ||(divcounter>BAUD2+BAUD4));

//-- Comparator that resets the counter when the limit is reached
assign reset = ov | (enable == 0);

//-- Clk_out is a single cycle pulse, 
//-- while half_clk_out and quarter_clk_out transition
//-- on rising and falling edges
assign clk_out = ov;
assign half_clk_out = half_cycle;
assign quarter_clk_out = quarter_cycle;

endmodule