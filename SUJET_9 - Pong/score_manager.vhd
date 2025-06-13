library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity score_manager is
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        miss_left  : in  std_logic;
        miss_right : in  std_logic;
        score_l    : out std_logic_vector(3 downto 0);
        score_r    : out std_logic_vector(3 downto 0)
    );
end score_manager;

architecture Behavioral of score_manager is
    signal s_l : std_logic_vector(3 downto 0) := "0000";
    signal s_r : std_logic_vector(3 downto 0) := "0000";
begin

    process(clk, reset)
    begin
        if reset = '1' then
            s_l <= "0000";
            s_r <= "0000";
        elsif rising_edge(clk) then
            if miss_right = '1' then
                s_l <= s_l + 1; -- balle sortie à droite → joueur gauche marque
            elsif miss_left = '1' then
                s_r <= s_r + 1; -- balle sortie à gauche → joueur droit marque
            end if;
        end if;
    end process;

    score_l <= s_l;
    score_r <= s_r;
end Behavioral;
