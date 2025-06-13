library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_interface is
    Port (
        clk           : in  std_logic;
        video_on      : in  std_logic;
        pixel_x       : in  std_logic_vector(9 downto 0);
        pixel_y       : in  std_logic_vector(9 downto 0);
        ball_x        : in  std_logic_vector(9 downto 0);
        ball_y        : in  std_logic_vector(9 downto 0);
        paddle_l_y    : in  std_logic_vector(9 downto 0);
        paddle_r_y    : in  std_logic_vector(9 downto 0);
        score_l       : in  std_logic_vector(3 downto 0);
        score_r       : in  std_logic_vector(3 downto 0);
        victory_left  : in  std_logic;
        victory_right : in  std_logic;
        vga_red       : out std_logic_vector(3 downto 0);
        vga_green     : out std_logic_vector(3 downto 0);
        vga_blue      : out std_logic_vector(3 downto 0)
    );
end vga_interface;

architecture Behavioral of vga_interface is

    constant BALL_SIZE     : integer := 8;
    constant PADDLE_WIDTH  : integer := 10;
    constant PADDLE_HEIGHT : integer := 50;
    constant SCREEN_WIDTH  : integer := 640;

    signal pixel_on_ball     : std_logic;
    signal pixel_on_paddleL  : std_logic;
    signal pixel_on_paddleR  : std_logic;
    signal score_pixel_r     : std_logic;
    signal score_pixel_l     : std_logic;

begin

    -- Balle
    pixel_on_ball <= '1' when 
        (unsigned(pixel_x) >= unsigned(ball_x) and unsigned(pixel_x) < unsigned(ball_x) + BALL_SIZE) and
        (unsigned(pixel_y) >= unsigned(ball_y) and unsigned(pixel_y) < unsigned(ball_y) + BALL_SIZE)
        else '0';

    -- Raquette gauche
    pixel_on_paddleL <= '1' when 
        (unsigned(pixel_x) >= 20 and unsigned(pixel_x) < 20 + PADDLE_WIDTH) and
        (unsigned(pixel_y) >= unsigned(paddle_l_y) and unsigned(pixel_y) < unsigned(paddle_l_y) + PADDLE_HEIGHT)
        else '0';

    -- Raquette droite
    pixel_on_paddleR <= '1' when 
        (unsigned(pixel_x) >= SCREEN_WIDTH - 20 - PADDLE_WIDTH and unsigned(pixel_x) < SCREEN_WIDTH - 20) and
        (unsigned(pixel_y) >= unsigned(paddle_r_y) and unsigned(pixel_y) < unsigned(paddle_r_y) + PADDLE_HEIGHT)
        else '0';

    -- Score du joueur de droite (rouge)
    score_pixel_r <= '1' when (
        (unsigned(pixel_y) >= 10 and unsigned(pixel_y) < 18) and
        (unsigned(pixel_x) >= 630 - to_integer(unsigned(score_r)) * 8 and unsigned(pixel_x) < 630)
    ) else '0';

    -- Score du joueur de gauche (bleu)
    score_pixel_l <= '1' when (
        (unsigned(pixel_y) >= 10 and unsigned(pixel_y) < 18) and
        (unsigned(pixel_x) >= 10 and unsigned(pixel_x) < 10 + to_integer(unsigned(score_l)) * 8)
    ) else '0';

    -- Affichage des couleurs, priorité à la victoire
    vga_red <= "1111" when video_on = '1' and victory_right = '1' else
               "1111" when video_on = '1' and (score_pixel_r = '1' or pixel_on_ball = '1') else
               "0000";

    vga_blue <= "1111" when video_on = '1' and victory_left = '1' else
                "1111" when video_on = '1' and score_pixel_l = '1' else
                "0000";

    vga_green <= "1111" when video_on = '1' and (pixel_on_paddleL = '1' or pixel_on_paddleR = '1') else
                 "0000";

end Behavioral;
