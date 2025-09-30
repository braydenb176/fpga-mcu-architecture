library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.vga_config_640x480.all;

entity VGA_tb is
end entity;

architecture tb of VGA_tb is

    signal clk        : std_logic := '0';
    signal rst        : std_logic := '0';
    signal vga_en     : std_logic := '0';

    signal vsync      : std_logic := '0';
    signal hsync      : std_logic := '0';
    signal is_visible : std_logic := '0';

    signal red        : std_logic_vector(RED_BIT_CNT - 1 downto 0) := (others => '0');
    signal green      : std_logic_vector(GREEN_BIT_CNT - 1 downto 0) := (others => '0');
    signal blue       : std_logic_vector(BLUE_BIT_CNT - 1 downto 0) := (others => '0');

    signal clk_en     : std_logic := '1';
    constant CLK_PERIOD : time := 10 ns;

    signal clk_half   : std_logic := '0';

begin

    clk <= not clk and clk_en after (CLK_PERIOD / 2);

    DUT : entity work.VGA
        port map (
            pi_clk        => clk,
            pi_rst        => rst,
            pi_vga_en     => vga_en,
            po_vsync      => vsync,
            po_hsync      => hsync,
            po_is_visible => is_visible,
            po_red        => red,
            po_green      => green,
            po_blue       => blue
        );

    clk_div_inst : entity work.clk_div
        generic map (
            g_DIV_FACTOR => 2 --50MHz / 2 = 25MHz
        )
        port map (
            pi_clk => clk,
            pi_rst => rst,
            po_clk => clk_half
        );
    
    process
        variable clk_cnt : integer := 0;
    begin
        vga_en <= not vga_en;

        for i in 0 to V_VISIBLE-1 loop
            for i in 0 to H_VISIBLE-1 loop
                wait until rising_edge(clk_half);
                assert vsync = '1' and hsync = '1' and is_visible = '1' report "Incorrect visible values." severity warning;
                clk_cnt := clk_cnt + 1;
            end loop;

            --assert clk_cnt = 640 report "visible clk count incorrect : " & integer'image(clk_cnt);

            for i in 0 to H_FRONT_PORCH-1 loop
                wait until rising_edge(clk_half);
                assert vsync = '1' and hsync = '1' and is_visible = '0' report "Incorrect h front porch values." severity warning;
                clk_cnt := clk_cnt + 1;
            end loop;

            for i in 0 to H_SYNC_PULSE-1 loop
                wait until rising_edge(clk_half);
                assert vsync = '1' and hsync = '0' and is_visible = '0' report "Incorrect hsync pulse values." severity warning;
                clk_cnt := clk_cnt + 1;
            end loop;

            for i in 0 to H_BACK_PORCH-1 loop
                wait until rising_edge(clk_half);
                assert vsync = '1' and hsync = '1' and is_visible = '0' report "Incorrect h back porch values." severity warning;
                clk_cnt := clk_cnt + 1;
            end loop;
        end loop;  

        -- report "Clk cycles total is " & integer'image(clk_cnt);
        -- clk_en <= '0';
        -- wait;

        
        for i in 0 to V_FRONT_PORCH-1 loop
            for i in 0 to H_VISIBLE-1 loop
                wait until rising_edge(clk_half);
                assert vsync = '1' and hsync = '1' and is_visible = '0' report "Incorrect visible values within h visible - v front porch." severity warning;
                clk_cnt := clk_cnt + 1;
            end loop;

            for i in 0 to H_FRONT_PORCH-1 loop
                wait until rising_edge(clk_half);
                assert vsync = '1' and hsync = '1' and is_visible = '0' report "Incorrect h front porch values - v front porch." severity warning;
                clk_cnt := clk_cnt + 1;
            end loop;

            for i in 0 to H_SYNC_PULSE-1 loop
                wait until rising_edge(clk_half);
                assert vsync = '1' and hsync = '0' and is_visible = '0' report "Incorrect hsync pulse values - v front porch" severity warning;
                clk_cnt := clk_cnt + 1;
            end loop;

            for i in 0 to H_BACK_PORCH-1 loop
                wait until rising_edge(clk_half);
                assert vsync = '1' and hsync = '1' and is_visible = '0' report "Incorrect h back porch values - v front porch" severity warning;
                clk_cnt := clk_cnt + 1;
            end loop;
        end loop;  

        for i in 0 to V_SYNC_PULSE-1 loop
            for i in 0 to H_VISIBLE-1 loop
                wait until rising_edge(clk_half);
                assert vsync = '0' and hsync = '1' and is_visible = '0' report "Incorrect h visible values - v sync pulse" severity warning;
                clk_cnt := clk_cnt + 1;
            end loop;

            for i in 0 to H_FRONT_PORCH-1 loop
                wait until rising_edge(clk_half);
                assert vsync = '0' and hsync = '1' and is_visible = '0' report "Incorrect h front porch values - v sync pulse" severity warning;
                clk_cnt := clk_cnt + 1;
            end loop;

            for i in 0 to H_SYNC_PULSE-1 loop
                wait until rising_edge(clk_half);
                assert vsync = '0' and hsync = '0' and is_visible = '0' report "Incorrect hsync pulse values - v sync pulse" severity warning;
                clk_cnt := clk_cnt + 1;
            end loop;

            for i in 0 to H_BACK_PORCH-1 loop
                wait until rising_edge(clk_half);
                assert vsync = '0' and hsync = '1' and is_visible = '0' report "Incorrect h back porch values - v sync pulse" severity warning;
                clk_cnt := clk_cnt + 1;
            end loop;
        end loop;  

        for i in 0 to V_BACK_PORCH-1 loop
            for i in 0 to H_VISIBLE-1 loop
                wait until rising_edge(clk_half);
                assert vsync = '1' and hsync = '1' and is_visible = '0' report "Incorrect visible values - v back porch" severity warning;
                clk_cnt := clk_cnt + 1;
            end loop;

            for i in 0 to H_FRONT_PORCH-1 loop
                wait until rising_edge(clk_half);
                assert vsync = '1' and hsync = '1' and is_visible = '0' report "Incorrect h front porch values - v back porch" severity warning;
                clk_cnt := clk_cnt + 1;
            end loop;

            for i in 0 to H_SYNC_PULSE-1 loop
                wait until rising_edge(clk_half);
                assert vsync = '1' and hsync = '0' and is_visible = '0' report "Incorrect hsync pulse values - v back porch" severity warning;
                clk_cnt := clk_cnt + 1;
            end loop;

            for i in 0 to H_BACK_PORCH-1 loop
                wait until rising_edge(clk_half);
                assert vsync = '1' and hsync = '1' and is_visible = '0' report "Incorrect h back porch values - v back porch" severity warning;
                clk_cnt := clk_cnt + 1;
            end loop;
        end loop;  

        report "Simulation finished." severity note;
        clk_en <= '0';
        wait;
    end process;

end architecture;