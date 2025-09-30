library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vga_config_640x480.all;

entity VGA is
	port (
	  clk, rst      : in  std_logic; --want 25MHz for 640 by 480 at 60 Hz, incoming 25MHz from rp2040
	  vga_en           : in  std_logic;
	  vsync, hsync  : out std_logic;
	  red             : out std_logic_vector(RED_BIT_CNT - 1 downto 0);
	  green           : out std_logic_vector(GREEN_BIT_CNT - 1 downto 0);
	  blue            : out std_logic_vector(BLUE_BIT_CNT - 1 downto 0)
	);
end VGA;

architecture structure of VGA is
	signal h_cnt         : std_logic_vector(H_BIT_CNT - 1 downto 0) := (others => '0');
	signal v_cnt         : std_logic_vector(V_BIT_CNT - 1 downto 0) := (others => '0');
	signal is_visible_s  : std_logic := '0';
begin
	--for testing, will implement tile based color entity
	process(is_visible_s)
	begin
		if(is_visible_s = '1') then
			po_red <= "000";
			po_green <= "000";
			po_blue <= "01";
		else
			po_red <= "000";
			po_green <= "000";
			po_blue <= "00";
		end if;
	end process;

	vga_sync_inst : entity work.vga_sync
		port map (
		clk => clk,
		rst => '0',

		--plan to implement on/off via microcontroller, for testing simply always leave enabled
		--pi_vga_en => pi_vga_en,
		vga_en => '1',

		vsync => vsync,
		hsync => hsync,
		hcnt => h_cnt, --todo integrate x,y pos of current pixel to determine color ^
		vcnt => v_cnt,
		is_visible => is_visible_s
	);

	is_visible <= is_visible_s;

end structure;