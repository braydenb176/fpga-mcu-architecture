library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity clk_div is
    generic (
        g_DIV_FACTOR    : integer := 2
    );
    port (
        pi_clk, pi_rst  : in  std_logic;
        po_clk          : out std_logic
    );
end clk_div;

architecture structure of clk_div is
    constant c_CNT_WIDTH : integer := integer(ceil(log2(real(g_DIV_FACTOR-1))));
begin

    p_clk_div : process(pi_clk, pi_rst)
        variable vr_cnt     : unsigned(c_CNT_WIDTH - 1 downto 0) := to_unsigned(g_DIV_FACTOR-1, c_CNT_WIDTH);
        variable v_clk_out  : std_logic := '0';
    begin
        if(pi_rst = '1') then
            vr_cnt := to_unsigned(g_DIV_FACTOR-1, c_CNT_WIDTH);
            v_clk_out := '0';
        elsif(rising_edge(pi_clk)) then
            if(vr_cnt = 1) then
                v_clk_out := not v_clk_out;
                vr_cnt := to_unsigned(g_DIV_FACTOR-1, c_CNT_WIDTH);
            else
                vr_cnt := vr_cnt - 1;
            end if;
        end if;
        po_clk <= v_clk_out;
    end process;

end structure;