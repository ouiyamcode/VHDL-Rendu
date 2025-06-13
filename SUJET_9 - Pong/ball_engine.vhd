library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ball_engine is
    Port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        enable      : in  std_logic;
        paddle_l_y  : in  std_logic_vector(9 downto 0);
        paddle_r_y  : in  std_logic_vector(9 downto 0);
        miss_left   : out std_logic;
        miss_right  : out std_logic;
        ball_x      : out std_logic_vector(9 downto 0);
        ball_y      : out std_logic_vector(9 downto 0)
    );
end ball_engine;

architecture Behavioral of ball_engine is

    constant BALL_SIZE       : integer := 8;
    constant SCREEN_WIDTH    : integer := 640;
    constant SCREEN_HEIGHT   : integer := 480;
    constant PADDLE_HEIGHT   : integer := 50;
    constant PADDLE_WIDTH    : integer := 10;
    constant PADDLE_MARGIN   : integer := 20;

    signal pos_x, pos_y : unsigned(9 downto 0) := to_unsigned(320, 10);
    signal dir_x, dir_y : std_logic := '1';
    
    signal miss_l_int, miss_r_int : std_logic := '0';

    signal tick_counter : integer := 0;
    constant TICK_MAX : integer := 600000;

    constant PADDLE_L_X : integer := PADDLE_MARGIN;
    constant PADDLE_R_X : integer := SCREEN_WIDTH - PADDLE_MARGIN - PADDLE_WIDTH;

begin

    process(clk, reset)
    begin
        if reset = '1' then
            pos_x <= to_unsigned(320, 10);
            pos_y <= to_unsigned(240, 10);
            dir_x <= '1';
            dir_y <= '1';
            tick_counter <= 0;
            miss_l_int <= '0';
            miss_r_int <= '0';

        elsif rising_edge(clk) then
            miss_l_int <= '0';
            miss_r_int <= '0';

            if enable = '1' then
                if tick_counter = TICK_MAX then
                    tick_counter <= 0;

                    -- Mouvement vertical
                    if dir_y = '1' then
                        if pos_y < SCREEN_HEIGHT - BALL_SIZE - 1 then
                            pos_y <= pos_y + 1;
                        else
                            dir_y <= '0';
                        end if;
                    else
                        if pos_y > 0 then
                            pos_y <= pos_y - 1;
                        else
                            dir_y <= '1';
                        end if;
                    end if;

                    -- Mouvement horizontal
                    if dir_x = '1' then
                        if pos_x + BALL_SIZE < SCREEN_WIDTH - 1 then
                            if pos_x + BALL_SIZE = to_unsigned(PADDLE_R_X, 10) and
                               pos_y >= unsigned(paddle_r_y) and
                               pos_y <= unsigned(paddle_r_y) + PADDLE_HEIGHT then
                                dir_x <= '0'; -- rebond
                            else
                                pos_x <= pos_x + 1;
                            end if;
                        else
                            miss_r_int <= '1'; -- balle sortie à droite
                            pos_x <= to_unsigned(320, 10);
                            pos_y <= to_unsigned(240, 10);
                            dir_x <= '0';
                        end if;

                    else
                        if pos_x > 0 then
                            if pos_x = to_unsigned(PADDLE_L_X + PADDLE_WIDTH, 10) and
                               pos_y >= unsigned(paddle_l_y) and
                               pos_y <= unsigned(paddle_l_y) + PADDLE_HEIGHT then
                                dir_x <= '1'; -- rebond
                            else
                                pos_x <= pos_x - 1;
                            end if;
                        else
                            miss_l_int <= '1'; -- balle sortie à gauche
                            pos_x <= to_unsigned(320, 10);
                            pos_y <= to_unsigned(240, 10);
                            dir_x <= '1';
                        end if;
                    end if;
                else
                    tick_counter <= tick_counter + 1;
                end if;
            end if; -- enable
        end if;
    end process;

    ball_x <= std_logic_vector(pos_x);
    ball_y <= std_logic_vector(pos_y);
    miss_left  <= miss_l_int;
    miss_right <= miss_r_int;

end Behavioral;
