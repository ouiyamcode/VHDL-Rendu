library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clk_divider is
    Port (
        clk      : in  STD_LOGIC;   -- horloge 100 MHz (BASYS3)
        clk_out  : out STD_LOGIC    -- horloge 25 MHz pour VGA
    );
end clk_divider;

architecture Behavioral of clk_divider is
    signal count : STD_LOGIC_VECTOR(1 downto 0) := "00"; -- 2-bit counter
begin
    process(clk)
    begin
        if rising_edge(clk) then
            count <= count + 1;
        end if;
    end process;

    clk_out <= count(1); -- division par 4 : 100MHz / 4 = 25 MHz
end Behavioral;
