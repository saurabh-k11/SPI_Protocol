module SPI_Bidirectional_tb;

    reg clk = 0;
    reg reset = 1;
    reg [15:0] din;
    wire miso, mosi, sclk, cs_l;
    wire [15:0] dout;
    wire [4:0] counter;

    // Instantiate Master
    SPI_Master master (
        .clk(clk),
        .reset(reset),
        .din(din),
        .miso(miso),
        .mosi(mosi),
        .spi_sclk(sclk),
        .spi_cs_l(cs_l),
        .dout(dout),
        .counter(counter)
    );

    // Instantiate Slave
    SPI_Slave slave (
        .sclk(sclk),
        .cs_l(cs_l),
        .mosi(mosi),
        .miso(miso)
    );

    // Clock generator
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        $dumpfile("spi_bidirectional.vcd");
        $dumpvars(0, SPI_Bidirectional_tb);

        #10 reset = 0;
        #10 din = 16'hA55A;

        // Wait for full transmission
        #350;

        $display("Received from slave: 0x%h", dout);

        #20 din = 16'h1234;
        #350;
        $display("Received from slave: 0x%h", dout);

        #100 $finish;
    end

endmodule
