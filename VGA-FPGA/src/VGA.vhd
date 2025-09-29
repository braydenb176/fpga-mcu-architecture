library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vga_config_640x480.all;

entity VGA is
	port (
	  pi_clk, pi_rst      : in  std_logic; --want 25MHz for 640 by 480 at 60 Hz, incoming 25MHz from rp2040
	  pi_vga_en           : in  std_logic;
	  po_vsync, po_hsync  : out std_logic;
	  po_red             : out std_logic_vector(RED_BIT_CNT - 1 downto 0);
	  po_green           : out std_logic_vector(GREEN_BIT_CNT - 1 downto 0);
	  po_blue            : out std_logic_vector(BLUE_BIT_CNT - 1 downto 0)
	);
end VGA;

architecture structure of VGA is
	signal h_cnt       : std_logic_vector(H_BIT_CNT - 1 downto 0) := (others => '0');
	signal v_cnt       : std_logic_vector(V_BIT_CNT - 1 downto 0) := (others => '0');
	signal is_visible  : std_logic := '0';
begin
	--for testing, will implement tile based color entity
	process(is_visible)
	begin
		if(is_visible = '1') then
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
		pi_clk => pi_clk,
		pi_rst => '0',

		--plan to implement on/off via microcontroller, for testing simply always leave enabled
		--pi_vga_en => pi_vga_en,
		pi_vga_en => '1',

		po_vsync => po_vsync,
		po_hsync => po_hsync,
		po_hcnt => h_cnt, --todo integrate x,y pos of current pixel to determine color ^
		po_vcnt => v_cnt,
		po_is_visible => is_visible
	);

	po_is_visible <= is_visible;

end structure;