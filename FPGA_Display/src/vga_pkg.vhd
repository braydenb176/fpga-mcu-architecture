library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--timing values for 640x480 resolution at 60 FPS, using input clock of 25MHz
package vga_config_640x480 is

    constant H_BIT_CNT        : natural := 11;
    constant V_BIT_CNT        : natural := 11;

    --color bit counts, lose 1 bit of blue to fit color info in 1 byte for memory constraint reasons
    constant RED_BIT_CNT      : natural := 3;
    constant GREEN_BIT_CNT    : natural := 3;
    constant BLUE_BIT_CNT     : natural := 2;

    --horizontal pixel timings
    constant H_VISIBLE        : natural := 640;
    constant H_FRONT_PORCH    : natural := 16;
    constant H_SYNC_PULSE     : natural := 96;
    constant H_BACK_PORCH     : natural := 48;

    constant H_TOTAL          : natural := H_VISIBLE + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;
    constant H_SYNC_START     : natural := H_VISIBLE + H_FRONT_PORCH;
    constant H_SYNC_END       : natural := H_SYNC_START + H_SYNC_PULSE;

    --vertical pixel timings
    constant V_VISIBLE        : natural := 480;
    constant V_FRONT_PORCH    : natural := 10;
    constant V_SYNC_PULSE     : natural := 2;
    constant V_BACK_PORCH     : natural := 33;

    constant V_TOTAL          : natural := V_VISIBLE + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;
    constant V_SYNC_START     : natural := V_VISIBLE + V_FRONT_PORCH;
    constant V_SYNC_END       : natural := V_SYNC_START + V_SYNC_PULSE;

end package;