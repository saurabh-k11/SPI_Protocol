module SPI_Master (
    input wire clk,
    input wire reset,
    input wire [15:0] din,
    input wire miso,                 // input from slave
    output wire spi_cs_l,
    output wire spi_sclk,
    output wire mosi,
    output reg [15:0] dout,         // received data from slave
    output [4:0] counter
);

    reg [15:0] shift_reg;
    reg [4:0] count;
    reg cs_l;
    reg sclk;
    reg [2:0] state;
    reg mosi_bit;

    assign spi_cs_l = cs_l;
    assign spi_sclk = sclk;
    assign mosi = mosi_bit;
    assign counter = count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 16'b0;
            count <= 5'd16;
            cs_l <= 1'b1;
            sclk <= 1'b0;
            state <= 0;
            dout <= 0;
            mosi_bit <= 0;
        end else begin
            case (state)
                0: begin // Idle
                    sclk <= 1'b0;
                    cs_l <= 1'b1;
                    count <= 5'd16;
                    state <= 1;
                end
                1: begin // Load and assert CS
                    sclk <= 1'b0;
                    cs_l <= 1'b0;
                    shift_reg <= din;
                    mosi_bit <= din[15];
                    count <= count - 1;
                    dout <= 0;
                    state <= 2;
                end
                2: begin // Clock high
                    sclk <= 1'b1;
                    state <= 3;
                end
                3: begin // Clock low, shift and read MISO
                    sclk <= 1'b0;
                    shift_reg <= shift_reg << 1;
                    dout <= {dout[14:0], miso};
                    mosi_bit <= shift_reg[14];
                    if (count > 0) begin
                        count <= count - 1;
                        state <= 2;
                    end else begin
                        cs_l <= 1'b1;
                        state <= 0;
                    end
                end
            endcase
        end
    end
endmodule
