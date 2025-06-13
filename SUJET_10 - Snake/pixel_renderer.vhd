library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pixel_renderer is
    Port (
        snake_on  : in  STD_LOGIC;
        wall_on   : in  STD_LOGIC;
        apple_on  : in  STD_LOGIC;
        video_on  : in  STD_LOGIC;
        game_over : in  STD_LOGIC;
        red       : out STD_LOGIC_VECTOR(3 downto 0);
        green     : out STD_LOGIC_VECTOR(3 downto 0);
        blue      : out STD_LOGIC_VECTOR(3 downto 0)
    );
end pixel_renderer;

architecture Behavioral of pixel_renderer is
begin
    process(snake_on, wall_on, apple_on, video_on, game_over)
    begin
        if video_on = '1' then
            if game_over = '1' then
                red   <= "1111";
                green <= "0000";
                blue  <= "0000";
            elsif snake_on = '1' then
                red   <= "0000";
                green <= "1111";
                blue  <= "0000";
            elsif apple_on = '1' then
                red   <= "1111";
                green <= "0000";
                blue  <= "0000";
            elsif wall_on = '1' then
                red   <= "1111";
                green <= "1111";
                blue  <= "1111";
            else
                red   <= "0000";
                green <= "0000";
                blue  <= "0000";
            end if;
        else
            red   <= "0000";
            green <= "0000";
            blue  <= "0000";
        end if;
    end process;
end Behavioral;
