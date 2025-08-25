# SPI_Protocol

It is a Serial Communication protocol used for onboard short range communication.

It has 4 wires : 

output wire : SCLK(serial clock) , CS_l(active low chip select line) , MOSI(master out slave in)

input wire : MISO(master in slave out)


<img width="1920" height="1080" alt="Screenshot 2025-08-25 172455" src="https://github.com/user-attachments/assets/ab2da63e-f833-431e-af36-f8607bce9778" />

Here is the waveform generated for functional verification using the tb_spi.v file of SPI module.
