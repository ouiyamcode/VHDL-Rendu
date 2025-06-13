library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity ex6 is
    Port (
        clock_100Mhz : in STD_LOGIC;
        reset : in STD_LOGIC;
        Anode_Activate : out STD_LOGIC_VECTOR (3 downto 0);
        LED_out : out STD_LOGIC_VECTOR (6 downto 0)
    );
end ex6;
 
architecture Behavioral of ex6 is
    signal one_second_counter : STD_LOGIC_VECTOR (27 downto 0) := (others => '0');
    signal one_second_tick    : std_logic := '0';
    signal displayed_number   : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal LED_BCD            : STD_LOGIC_VECTOR (3 downto 0);
    signal refresh_counter    : STD_LOGIC_VECTOR (19 downto 0) := (others => '0');
    signal LED_activating_counter : std_logic_vector(1 downto 0);
begin
 
    -- BCD to 7-segment decoder
    process(LED_BCD)
    begin
        case LED_BCD is
            when "0000" => LED_out <= "0000001"; -- 0
            when "0001" => LED_out <= "1001111"; -- 1
            when "0010" => LED_out <= "0010010"; -- 2
            when "0011" => LED_out <= "0000110"; -- 3
            when "0100" => LED_out <= "1001100"; -- 4
            when "0101" => LED_out <= "0100100"; -- 5
            when "0110" => LED_out <= "0100000"; -- 6
            when "0111" => LED_out <= "0001111"; -- 7
            when "1000" => LED_out <= "0000000"; -- 8
            when "1001" => LED_out <= "0000100"; -- 9
            when others => LED_out <= "1111111"; -- défaut: tout éteint
        end case;
    end process;
 
    -- Refresh counter (pour multiplexage des afficheurs)
    process(clock_100Mhz, reset)
    begin
        if reset = '1' then
            refresh_counter <= (others => '0');
        elsif rising_edge(clock_100Mhz) then
            refresh_counter <= refresh_counter + 1;
        end if;
    end process;
 
    LED_activating_counter <= refresh_counter(19 downto 18);
 
    -- LED activation et sélection du chiffre à afficher
    process(LED_activating_counter)
    begin
        case LED_activating_counter is
            when "00" =>
                Anode_Activate <= "0111";
                LED_BCD <= displayed_number(15 downto 12);
            when "01" =>
                Anode_Activate <= "1011";
                LED_BCD <= displayed_number(11 downto 8);
            when "10" =>
                Anode_Activate <= "1101";
                LED_BCD <= displayed_number(7 downto 4);
            when "11" =>
                Anode_Activate <= "1110";
                LED_BCD <= displayed_number(3 downto 0);
            when others =>
                Anode_Activate <= "1111";
                LED_BCD <= "0000";
        end case;
    end process;
 
    -- Génération du tick toutes les secondes
    process(clock_100Mhz, reset)
    begin
        if reset = '1' then
            one_second_counter <= (others => '0');
            one_second_tick <= '0';
        elsif rising_edge(clock_100Mhz) then
            if one_second_counter = x"5F5E0FF" then -- 100 000 000 cycles -> 1 seconde
                one_second_counter <= (others => '0');
                one_second_tick <= '1';
            else
                one_second_counter <= one_second_counter + 1;
                one_second_tick <= '0';
            end if;
        end if;
    end process;
 
    -- Compteur affiché en BCD
    process(clock_100Mhz, reset)
    begin
        if reset = '1' then
            displayed_number <= (others => '0');
        elsif rising_edge(clock_100Mhz) then
            if one_second_tick = '1' then
                if displayed_number(3 downto 0) = "1001" then -- unités
                    displayed_number(3 downto 0) <= "0000";
                    if displayed_number(7 downto 4) = "1001" then -- dizaines
                        displayed_number(7 downto 4) <= "0000";
                        if displayed_number(11 downto 8) = "1001" then -- centaines
                            displayed_number(11 downto 8) <= "0000";
                            if displayed_number(15 downto 12) = "1001" then -- milliers
                                displayed_number(15 downto 12) <= "0000"; -- tout reset
                            else
                                displayed_number(15 downto 12) <= displayed_number(15 downto 12) + 1;
                            end if;
                        else
                            displayed_number(11 downto 8) <= displayed_number(11 downto 8) + 1;
                        end if;
                    else
                        displayed_number(7 downto 4) <= displayed_number(7 downto 4) + 1;
                    end if;
                else
                    displayed_number(3 downto 0) <= displayed_number(3 downto 0) + 1;
                end if;
            end if;
        end if;
    end process;
 
end Behavioral;