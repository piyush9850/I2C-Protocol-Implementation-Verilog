module I2C_master (
        input rst,
        input clk,
        input enable,
        input [7:0] data_in,
        input [6:0] slave_addr,
        input rw,

        inout SDA,

        output SCLK,
        output reg busy,
        output reg ack_error,
        output reg [7:0] data_out
);


wire SCLK;
baud one (.clk(clk), .rst(rst), .SCLK(SCLK));

reg [2:0] S;

parameter IDLE = 3'b000, START = 3'b001, ADDRESS = 3'b010,ACK_WAIT = 3'b011, ACK1 = 3'b100, DATA = 3'b101, ACK2 = 3'b110, STOP = 3'b111;




reg sda_en;
reg sda_out;
reg SCLK_d;


reg [7:0] shift_reg;
reg [2:0] bit_counter;

assign SDA = sda_en ? sda_out : 1'bz;


// detech SCL edge 
wire rising_edge  =  SCLK & ~SCLK_d;
wire falling_edge = ~SCLK &  SCLK_d;


always@(posedge clk)
begin
    
    busy <= (S != IDLE);

    SCLK_d <= SCLK;

    if(rst)
    begin
        S <= IDLE;
       
        ack_error <= 0;
        data_out <= 0;
        sda_en <= 0;
        sda_out <= 0;
        shift_reg <= 8'd0;
        SCLK_d <= 1'b0;
        bit_counter <= 0;
        busy <= 0;
    end
    else 
    begin
        
        case(S)
        
        IDLE : begin
            ack_error <= 0;

            if(enable)
            S <= START;

        end

        START : begin
            
            sda_en <= 1;
            sda_out <= 0;
            if(rising_edge)
            begin
                
            shift_reg <= {slave_addr[6:0],rw};
            bit_counter <= 0;

            S <= ADDRESS;
        end
        end

        ADDRESS : begin
            if(sda_en && falling_edge)
            begin
            sda_out <= shift_reg[7];
            shift_reg <= {shift_reg[6:0],1'b0};
            bit_counter <= bit_counter + 1;

            

            if(bit_counter == 3'd7)
            begin
               bit_counter <= 0;
               S <= ACK_WAIT; 
            end
            end
        end

        ACK_WAIT : begin
            sda_en <= 0;
            if(falling_edge)
            S <= ACK1;

        end

        ACK1 : begin
            sda_en <= 0;
            if(rising_edge)
            begin
                case(SDA)
                
                    0 :begin
                        shift_reg <= data_in;
                        bit_counter <= 0;
                     S <= DATA;
                    end
                    1 : begin
                     ack_error <= 1;
                    S <= STOP;
                    end


                endcase
            end 

        end

        DATA : begin
            
            if(!rw && falling_edge)
            begin
                sda_en <= 1;
                
                sda_out <= shift_reg[7];
                shift_reg <= {shift_reg[6:0],1'b0};
                bit_counter <= bit_counter + 1;
                
                
                if(bit_counter == 7)
                begin
                    bit_counter <= 0;
                    S <= ACK2;
                end


            end
            else if(rw && rising_edge)
            begin
                sda_en <= 0;
                data_out <= {data_out[6:0], SDA};
                bit_counter <= bit_counter + 1;

                
                if(bit_counter == 7)
                begin
                    bit_counter <= 0;
                    S <= ACK2;
                end

            end

        end     

        ACK2 : begin
            
            if(!rw && rising_edge)
            begin
                sda_en <= 0;
                if(SDA == 0)
                S <= STOP;
                else
                begin
                ack_error <= 1;
                S <= STOP;
                end
            end
            else if(rw && rising_edge)
            begin
                S <= STOP;
            end

        end 

        STOP : begin
            sda_en<=1;
            sda_out<=0;

            if(rising_edge)
            begin

                sda_out <= 1;
                S <= IDLE;
            end
            
        end  

        endcase

    end


end




endmodule

