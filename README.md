# fpga-mcu-architecture
Project to integrate a MAX10 FPGA with a RP2040. FPGA handles graphics, while the RP2040 microcontroller provides the required clock frequency for the VGA via PIO and sends control signals to the FPGA display mechanism.

Initial setup of VGA to be 640 x 480 at 25 MHz clock speed. Plan to implement tiled design of display to solve issues with memory constraints. 
