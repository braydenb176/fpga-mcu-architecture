# fpga-mcu-architecture
Project to integrate two Max 10 FPGAs with an ATXMega128A1U microcontroller. Aims to implement video capability through VGA, as well as additional sensor functionality. Navigates clock domain crossing.

First steps to implement 160x200 frame by using a IS61LV256AL-10TLI SRAM to store pixel data. Store pixel RGB data in a single byte, with red and green being 3 bits and blue being 2 bits.
