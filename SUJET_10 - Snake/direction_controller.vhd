library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity direction_controller is
    Port (
        clk    : in  STD_LOGIC;
        reset  : in  STD_LOGIC;
        btnU   : in  STD_LOGIC;
        btnD   : in  STD_LOGIC;
        btnL   : in  STD_LOGIC;
        btnR   : in  STD_LOGIC;
        dir_x  : out STD_LOGIC_VECTOR(1 downto 0);
        dir_y  : out STD_LOGIC_VECTOR(1 downto 0)
    );
end direction_controller;

architecture Behavioral of direction_controller is
    signal current_dir_x : STD_LOGIC_VECTOR(1 downto 0) := "01"; -- droite
    signal current_dir_y : STD_LOGIC_VECTOR(1 downto 0) := "00"; -- aucun mouvement vertical
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                current_dir_x <= "01"; -- droite
                current_dir_y <= "00";
            else
                -- Haut (y--)
                if btnU = '1' and not (current_dir_y = "10" and current_dir_x = "00") then
                    current_dir_x <= "00";
                    current_dir_y <= "00";
                -- Bas (y++)
                elsif btnD = '1' and not (current_dir_y = "00" and current_dir_x = "00") then
                    current_dir_x <= "00";
                    current_dir_y <= "10";
                -- Gauche (x--)
                elsif btnL = '1' and not (current_dir_x = "01" and current_dir_y = "00") then
                    current_dir_x <= "11";
                    current_dir_y <= "00";
                -- Droite (x++)
                elsif btnR = '1' and not (current_dir_x = "11" and current_dir_y = "00") then
                    current_dir_x <= "01";
                    current_dir_y <= "00";
                end if;
            end if;
        end if;
    end process;

    dir_x <= current_dir_x;
    dir_y <= current_dir_y;
end Behavioral;
