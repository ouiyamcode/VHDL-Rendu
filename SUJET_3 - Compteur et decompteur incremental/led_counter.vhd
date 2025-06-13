library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity led_counter is
    port (
        CLK, RST, btnL, btnR : in std_logic;
        LED : out std_logic_vector(15 downto 0)
    );
end led_counter;

architecture rtl of led_counter is
    signal cnt : std_logic_vector(23 downto 0);
    signal LED_int : std_logic_vector(15 downto 0);
begin

    process (CLK, RST)
    begin
        if (RST = '1') then
            cnt <= (others => '0');
        elsif (CLK'event and CLK = '1') then
            cnt <= cnt + 1;
        end if;
    end process;

    process(cnt(23), RST, btnL, btnR)
    begin
        if (RST = '1') then
            LED_int <= "0000000000000000";
        elsif (cnt(23)'event and cnt(23) = '1') then
            if (btnL = '1') then 
                LED_int <= LED_int(14 downto 0) & '1';
            elsif (btnR = '1') then
                LED_int <= '0' & LED_int(15 downto 1);
            end if;
        end if;

        LED <= LED_int;
    end process;

end rtl;
