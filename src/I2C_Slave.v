module I2C_Slave #(
    parameter MY_ADDR = 7'h50
) (
    input rst,
    input clk,
    inout SDA,
    input SCLK,
    input [7:0] tx_data,

    output reg [7:0] rx_data,
    output reg data_valid,
    output reg addr_match

);


reg [2:0] S;

parameter IDLE = 3'b000, START_DE = 3'b001 , ADDRESS = 3'b010 ,ACK_WAIT = 3'b011, ACK1 = 3'b100, DATA = 3'b101, ACK2 = 3'b110, STOP = 3'b111;

reg rw;
reg [7:0] tx_data_shift;

reg sda_en;
reg sda_out;

assign SDA = sda_en ? sda_out : 1'bz;

reg SDA_prev;
reg SCLK_prev;

wire START_CON = SCLK && SCLK_prev && ~SDA && SDA_prev;
wire STOP_CON = SCLK && SCLK_prev && SDA && ~SDA_prev;

wire rising_edge  =  SCLK & ~SCLK_prev;
wire falling_edge = ~SCLK &  SCLK_prev;

reg [2:0] bit_counter;

reg [7:0] shift_reg;

always@(posedge clk)
begin
    
    SDA_prev  <= SDA;
    SCLK_prev <= SCLK;
   
    if(rst)
    begin
        data_valid <= 0;
        addr_match <= 0;
        rx_data <= 0;
        S <= IDLE;
        bit_counter <= 0;
        shift_reg <= 0;
        SDA_prev <= 0;
        SCLK_prev <= 0;
        sda_en <= 0;
        sda_out <= 0;
        rw <= 0;
        tx_data_shift <= 8'd0;

    end
    else
    begin
        
        case(S)

        IDLE : begin
            addr_match <= 0;
            sda_en <= 0;
            data_valid <= 0;  
            if(START_CON)
            S <= START_DE;

            if(STOP_CON) 
             S <= IDLE;

        end

        START_DE : begin
            bit_counter <= 0;
            shift_reg <= 0;
            S <= ADDRESS;
        end

        ADDRESS : begin
            sda_en <= 0;

            if(rising_edge)
            begin
                shift_reg <= {shift_reg[6:0],SDA};
                bit_counter <= bit_counter + 1;

                if(bit_counter == 7)
                begin
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
            if(shift_reg[7:1] == MY_ADDR)
            begin
                addr_match <= 1;
                sda_en <= 1;
                sda_out <= 0;
                rw <= shift_reg[0];
                 tx_data_shift <= tx_data;
                bit_counter <= 0;
                S <= DATA;
            end
            else
            begin
                addr_match <= 0;
                sda_en <= 0;
                S <= IDLE;
            end
        end

        DATA : begin
            if(!rw && rising_edge)
            begin
                sda_en <= 0;
                
                rx_data <= {rx_data[6:0], SDA};
                bit_counter <= bit_counter + 1;
                
                
                if(bit_counter == 7)
                begin
                    bit_counter <= 0;
                    S <= ACK2;
                end


            end
            else if(rw && falling_edge)
            begin
                sda_en  <= 1;  
sda_out <= tx_data_shift[7];  
tx_data_shift <= {tx_data_shift[6:0], 1'b0};
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
                sda_en  <= 1;
                sda_out <= 0;  
                data_valid <= 1;
                S <= STOP;
            end
            else if(rw && rising_edge)
            begin
                sda_en <= 0;
                S <= STOP;
            end
        end


        STOP : begin
            if(STOP_CON)
begin
    S <= IDLE;

    sda_en <= 0;

    addr_match <= 0;

    data_valid <= 0;

    bit_counter <= 0;
end
        end

        endcase


    end 




end


endmodule

