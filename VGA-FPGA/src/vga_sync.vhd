library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Possible to switch out package used when using another resolution.
use work.vga_config_640x480.all;

entity vga_sync is
    port (
        pi_clk, pi_rst, pi_vga_en  : in  std_logic; --use 25MHz for 680 by 480 at 60 Hz
        po_vsync, po_hsync         : out std_logic;
        po_hcnt                    : out std_logic_vector(H_BIT_CNT - 1 downto 0);
        po_vcnt                    : out std_logic_vector(V_BIT_CNT - 1 downto 0);
        po_is_visible              : out std_logic
    );
end vga_sync;

architecture structure of vga_sync is
    signal h_cnt : natural range 0 to H_TOTAL - 1 := 0;
    signal v_cnt : natural range 0 to V_TOTAL - 1 := 0;
begin

    process(pi_clk, pi_rst, pi_vga_en)
    begin
        if(pi_rst = '1') then
            h_cnt <= 0;
            v_cnt <= 0;
        elsif(rising_edge(pi_clk) and pi_vga_en = '1') then
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
            po_is_visible <= '0';
        else
            po_is_visible <= '1';
        end if;

        if(h_cnt >= H_SYNC_START and h_cnt < H_SYNC_END) then
            po_hsync <= '0';
        else 
            po_hsync <= '1';
        end if;

        if(v_cnt >= V_SYNC_START and v_cnt < V_SYNC_END) then
            po_vsync <= '0';
        else 
            po_vsync <= '1';
        end if;  
    end process;

    po_hcnt <= std_logic_vector(to_unsigned(h_cnt, H_BIT_CNT));
    po_vcnt <= std_logic_vector(to_unsigned(v_cnt, V_BIT_CNT));

end structure;