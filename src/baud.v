module baud (
    input clk,
    input rst,
    output reg SCLK
);

reg [13:0] counter;

always@(posedge clk)
begin
    

        if(rst)
        begin
            SCLK <= 0;
            counter <= 0;
        end
        else if(counter == 10)
        begin
            SCLK <= ~SCLK;
            counter <= 0;
        end
        else
        begin
        counter <= counter + 1;
        end
end
    
    
endmodule
