library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity afficheur is
	port (
		clk : in STD_LOGIC;
		an  : out STD_LOGIC_VECTOR(3 downto 0);
		seg : out STD_LOGIC_VECTOR(6 downto 0)
	);
end afficheur;

architecture rtl of afficheur is
	signal clk_div : STD_LOGIC_VECTOR(19 downto 0) := (others => '0');
	signal sel : STD_LOGIC_VECTOR(1 downto 0);
	
begin
	process(clk)
	begin
		if(clk'event and clk = '1') then
			clk_div <= clk_div + 1;
		end if;
	end process;
	
	sel <= clk_div(19 downto 18);
	
	process(sel)
	begin
		case sel is 
			when "00" => an <= "1110";
			when "01" => an <= "1101"; 
			when "10" => an <= "1011"; 
			when "11" => an <= "0111"; 
			when others => an <= "1111"; 
		end case;
	end process;
	
	seg <= "0010010"; --chiffre 5
end rtl;
