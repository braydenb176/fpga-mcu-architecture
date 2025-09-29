#include <stdio.h>
#include "pico/stdlib.h"

#include "hardware/pio.h"
#include "vga_clk_gen.pio.h"

//both in Hz
#define default_sys_clk 125e6
#define vga_target_freq 25e6

#define fpga_clk_pin 7 //pin 5 on rp2040 feather board


static inline void vga_clk_gen_init(PIO pio, uint sm, uint offset, uint pin, float clk_div) {
    pio_sm_config c = vga_clk_gen_program_get_default_config(offset);
    sm_config_set_set_pins(&c, pin, 1);
    sm_config_set_clkdiv(&c, clk_div);
    pio_gpio_init(pio, pin);
    pio_sm_set_consecutive_pindirs(pio, sm, pin, 1, true);
    pio_sm_init(pio, sm, offset, &c);
    pio_sm_set_enabled(pio, sm, true);
}


int main() {
    PIO pio = pio0;
    uint offset = pio_add_program(pio, &vga_clk_gen_program);
    uint sm = pio_claim_unused_sm(pio, true);

    const float fpga_clk_div = (default_sys_clk / (vga_target_freq * 2));

    vga_clk_gen_init(pio, sm, offset, fpga_clk_pin, fpga_clk_div);

    while (true) {
        tight_loop_contents();
    }

}