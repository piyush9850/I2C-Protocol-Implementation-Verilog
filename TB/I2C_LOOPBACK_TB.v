`timescale 1ns/1ps

module I2C_LOOPBACK_TB;

reg clk;
reg rst;
reg enable;

reg [7:0] master_data;
reg [6:0] slave_addr;
reg rw;

reg [7:0] slave_tx_data;

wire SDA;
pullup(SDA);
wire SCLK;

// Master outputs
wire busy;
wire ack_error;
wire [7:0] master_data_out;

// Slave outputs
wire [7:0] slave_rx_data;
wire data_valid;
wire addr_match;





I2C_master master (

    .rst(rst),
    .clk(clk),
    .enable(enable),

    .data_in(master_data),
    .slave_addr(slave_addr),
    .rw(rw),

    .SDA(SDA),
    .SCLK(SCLK),

    .busy(busy),
    .ack_error(ack_error),
    .data_out(master_data_out)

);




I2C_Slave #(

    .MY_ADDR(7'h50)

) slave (

    .rst(rst),
    .clk(clk),

    .SDA(SDA),
    .SCLK(SCLK),

    .tx_data(slave_tx_data),

    .rx_data(slave_rx_data),
    .data_valid(data_valid),
    .addr_match(addr_match)

);

always #5 clk = ~clk;




initial
begin
 
clk = 0;

    $dumpfile("i2c_loopback.vcd");
    $dumpvars(0,I2C_LOOPBACK_TB);

    $monitor(
    "T=%0t  StateM=%0d Busy=%b AckErr=%b AddrMatch=%b DataValid=%b MasterRX=%h SlaveRX=%h SDA=%b",
    $time,
    master.S,
    busy,
    ack_error,
    addr_match,
    data_valid,
    master_data_out,
    slave_rx_data,
    SDA
    );

end




initial
begin

    clk = 0;
    rst = 1;
    enable = 0;

    master_data = 8'hA5;
    slave_tx_data = 8'hF1;

    slave_addr = 7'h50;

    rw = 0;          // WRITE

    #30;
    rst = 0;

    #30;
    enable = 1;

    #10;
    enable = 0;

    wait(busy==0);

#100;


    rw = 1;

    #100;

    enable = 1;

    #10;

    enable = 0;

   wait(busy==0);

#100;

    
    $display("Master Received = %h",master_data_out);
    $display("Slave Received  = %h",slave_rx_data);
    

    $finish;

end

endmodule


