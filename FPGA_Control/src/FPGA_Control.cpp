#include <stdio.h>
#include <algorithm>

#include "pico/stdlib.h"
#include "hardware/pio.h"
#include "vga_clk_gen.pio.h"

#include "../lib/LIS3DH.h"



//both in Hz
#define default_sys_clk 125e6
#define vga_target_freq 25e6

//pio
#define fpga_clk_pin 7 //pin 5 on rp2040 feather board

//gpio
#define direction_bit0 12
#define direction_bit1 11
#define direction_bit2 10

#define x_cmp_l 150
#define y_cmp_l 150

#define x_cmp_h 250
#define y_cmp_h 250

using namespace std;

static inline void vga_clk_gen_init(PIO pio, uint sm, uint offset, uint pin, float clk_div) {
    pio_sm_config c = vga_clk_gen_program_get_default_config(offset);
    sm_config_set_set_pins(&c, pin, 1);
    sm_config_set_clkdiv(&c, clk_div);
    pio_gpio_init(pio, pin);
    pio_sm_set_consecutive_pindirs(pio, sm, pin, 1, true);
    pio_sm_init(pio, sm, offset, &c);
    pio_sm_set_enabled(pio, sm, true);
}

void initialize_clk(){
    PIO pio = pio0;
    uint offset = pio_add_program(pio, &vga_clk_gen_program);
    uint sm = pio_claim_unused_sm(pio, true);

    const float fpga_clk_div = (default_sys_clk / (vga_target_freq * 2));

    vga_clk_gen_init(pio, sm, offset, fpga_clk_pin, fpga_clk_div);
}

void init_GPIO(){
    gpio_init(direction_bit0);
    gpio_set_dir(direction_bit0, GPIO_OUT);
    gpio_put(direction_bit0, 0);

    gpio_init(direction_bit1);
    gpio_set_dir(direction_bit1, GPIO_OUT);
    gpio_put(direction_bit1, 0);

    gpio_init(direction_bit2);
    gpio_set_dir(direction_bit2, GPIO_OUT);
    gpio_put(direction_bit2, 0);

    gpio_init(13);       // Initialize the LED pin
    gpio_set_dir(13, GPIO_OUT);
    gpio_put(13, 0);
}

typedef enum {
    none,
    left,
    right,
    up,
    down
}tilt_state;


int main() {
    init_GPIO();
    initialize_clk();

    LIS3DH lis3dh;
    lis3dh.init();

    while(1){
        lis3dh.update();
        float fX = (lis3dh.getX() + 2.0f);
        float fY = (lis3dh.getY() + 2.0f);
        int currX = (int)(fX * 100.0);
        int currY = (int)(fY * 100.0);

        currX = max(0, min(currX, 400));
        currY = max(0, min(currY, 400));

        tilt_state state = none;
        if(currX >= x_cmp_l && currX <= x_cmp_h && currY >= y_cmp_l && currY <= y_cmp_h){ //not moving
            state = none;
        }else if(currX > x_cmp_h){
            state = left;
        }else if(currX < x_cmp_l){
            state = right;
        }else if(currY > y_cmp_h){
            state = up;
        }else if(currY < y_cmp_l){
            state = down;
        }

        gpio_put(direction_bit0, (state >> 0) & 1);
        gpio_put(direction_bit1, (state >> 1) & 1);
        gpio_put(direction_bit2, (state >> 2) & 1);

        sleep_ms(100);
    }
}