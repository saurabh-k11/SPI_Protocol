module SPI_Slave (
    input wire sclk,
    input wire cs_l,
    input wire mosi,
    output wire miso
);

    reg [15:0] rx_shift = 0;
    reg [15:0] tx_shift = 16'hCAFE; // Example response
    reg [4:0] bit_count = 0;

    assign miso = tx_shift[15];

    always @(posedge sclk) begin
        if (!cs_l) begin
            rx_shift <= {rx_shift[14:0], mosi};
            tx_shift <= {tx_shift[14:0], 1'b0};
            bit_count <= bit_count + 1;
        end else begin
            bit_count <= 0;
            tx_shift <= 16'hCAFE;
        end
    end
endmodule
