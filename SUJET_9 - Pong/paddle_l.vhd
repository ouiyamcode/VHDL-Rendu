library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity paddle_l is
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        btn_up     : in  std_logic;
        btn_down   : in  std_logic;
        enable     : in  std_logic;
        paddle_y   : out std_logic_vector(9 downto 0)
    );
end paddle_l;

architecture Behavioral of paddle_l is
    signal pos_y : std_logic_vector(9 downto 0) := "0011110000"; -- ~240
    signal tick_counter : integer := 0;
    constant TICK_MAX : integer := 100000;

    constant PADDLE_HEIGHT : integer := 50;
    constant SCREEN_HEIGHT : integer := 480;
begin

    process(clk, reset)
    begin
        if reset = '1' then
            pos_y <= "0011110000";
            tick_counter <= 0;
        elsif rising_edge(clk) then
            if enable = '1' then
                if tick_counter = TICK_MAX then
                    tick_counter <= 0;

                    if btn_up = '1' and pos_y > 0 then
                        pos_y <= pos_y - 1;
                    elsif btn_down = '1' and pos_y < SCREEN_HEIGHT - PADDLE_HEIGHT then
                        pos_y <= pos_y + 1;
                    end if;

                else
                    tick_counter <= tick_counter + 1;
                end if;
            end if;
        end if;
    end process;

    paddle_y <= pos_y;
end Behavioral;
