library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Possible to switch out package used when using another resolution.
use work.vga_config_640x480.all;

entity vga_sync is
    port (
        clk, rst, pi_vga_en  : in  std_logic; --use 25MHz for 680 by 480 at 60 Hz
        vsync, hsync         : out std_logic;
        hcnt                    : out std_logic_vector(H_BIT_CNT - 1 downto 0);
        vcnt                    : out std_logic_vector(V_BIT_CNT - 1 downto 0);
        is_visible              : out std_logic
    );
end vga_sync;

architecture structure of vga_sync is
    signal h_cnt : natural range 0 to H_TOTAL - 1 := 0;
    signal v_cnt : natural range 0 to V_TOTAL - 1 := 0;
begin

    process(clk, rst, vga_en)
    begin
        if(rst = '1') then
            h_cnt <= 0;
            v_cnt <= 0;
        elsif(rising_edge(clk) and vga_en = '1') then
            if(h_cnt = H_TOTAL - 1) then
                h_cnt <= 0;
                if(v_cnt = V_TOTAL - 1) then
                    v_cnt <= 0;
                else
                    v_cnt <= v_cnt + 1;
                end if;
            else
                h_cnt <= h_cnt + 1;
            end if;
        end if;
    end process;

    process(h_cnt, v_cnt)
    begin
        if(h_cnt >= H_VISIBLE or v_cnt >= V_VISIBLE) then
            is_visible <= '0';
        else
            is_visible <= '1';
        end if;

        if(h_cnt >= H_SYNC_START and h_cnt < H_SYNC_END) then
            hsync <= '0';
        else 
            hsync <= '1';
        end if;

        if(v_cnt >= V_SYNC_START and v_cnt < V_SYNC_END) then
            vsync <= '0';
        else 
            vsync <= '1';
        end if;  
    end process;

    hcnt <= std_logic_vector(to_unsigned(h_cnt, H_BIT_CNT));
    vcnt <= std_logic_vector(to_unsigned(v_cnt, V_BIT_CNT));

end structure;