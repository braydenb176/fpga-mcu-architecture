library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vga_config_640x480.all;

entity vga_top_level is
    port (
        pi_clk, pi_rst      : in  std_logic; --want 25MHz for 640 by 480 at 60 Hz
        pi_vga_en           : in  std_logic;
        po_vsync, po_hsync  : out std_logic;
        po_is_visible       : out std_logic

        --not needed when using external sram
        -- po_red             : out std_logic_vector(RED_BIT_CNT - 1 downto 0);
        -- po_green           : out std_logic_vector(GREEN_BIT_CNT - 1 downto 0);
        -- po_blue            : out std_logic_vector(BLUE_BIT_CNT - 1 downto 0)
    );
end vga_top_level;

architecture structure of vga_top_level is

    signal clk_25MHz   : std_logic := '0';

    signal h_cnt       : std_logic_vector(H_BIT_CNT - 1 downto 0) := (others => '0');
    signal v_cnt       : std_logic_vector(V_BIT_CNT - 1 downto 0) := (others => '0');
    signal is_visible  : std_logic := '0';

begin

    --temp solution, will transition to pll
    clk_div_inst : entity work.clk_div
        generic map (
            g_DIV_FACTOR => 2 --50MHz / 2 = 25MHz
        )
        port map (
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            po_clk => clk_25MHz
        );

    vga_sync_inst : entity work.vga_sync
        port map (
            pi_clk => clk_25MHz,
            pi_rst => pi_rst,
            pi_vga_en => pi_vga_en,
            po_vsync => po_vsync,
            po_hsync => po_hsync,
            po_hcnt => h_cnt,
            po_vcnt => v_cnt,
            po_is_visible => is_visible
        );

    po_is_visible <= is_visible;

end structure;