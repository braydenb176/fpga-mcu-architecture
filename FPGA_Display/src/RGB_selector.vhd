library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Possible to switch out package used when using another resolution.
use work.vga_config_640x480.all;

entity RGB_selector is
    port (
        clk, rst   : in std_logic;
        h_cnt      : in std_logic_vector(H_BIT_CNT - 1 downto 0);
        v_cnt      : in std_logic_vector(H_BIT_CNT - 1 downto 0);
        is_visible : in std_logic;


        --restart, start bit
        --control bits to move plane

        red        : out std_logic_vector(RED_BIT_CNT - 1 downto 0);
	    green      : out std_logic_vector(GREEN_BIT_CNT - 1 downto 0);
	    blue       : out std_logic_vector(BLUE_BIT_CNT - 1 downto 0)
    );
end RGB_selector;

architecture structure of RGB_selector is

    --80 by 80 tiles for colors/sprites
    signal tile_x : integer range 0 to (640 / 80) - 1;
    signal tile_y : integer range 0 to (480 / 80) - 1;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                tile_x <= 0;
                tile_y <= 0;
            else
                -- Convert h_cnt and v_cnt to integer
                tile_x <= to_integer(unsigned(h_cnt)) / 80;
                tile_y <= to_integer(unsigned(v_cnt)) / 80;
            end if;
        end if;
    end process;

    

end structure;