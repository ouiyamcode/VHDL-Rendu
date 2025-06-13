library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pong_top is
    Port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        btnU      : in  std_logic;
        btnD      : in  std_logic;
        btnL      : in  std_logic;
        btnR      : in  std_logic;
        hsync     : out std_logic;
        vsync     : out std_logic;
        vga_red   : out std_logic_vector(3 downto 0);
        vga_green : out std_logic_vector(3 downto 0);
        vga_blue  : out std_logic_vector(3 downto 0)
    );
end pong_top;

architecture Behavioral of pong_top is

    -- VGA
    signal pixel_x, pixel_y : std_logic_vector(9 downto 0);
    signal video_on         : std_logic;
    signal clk_25           : std_logic;

    -- Objets
    signal ball_x, ball_y         : std_logic_vector(9 downto 0);
    signal paddle_l_y, paddle_r_y : std_logic_vector(9 downto 0);

    -- Score
    signal score_l, score_r : std_logic_vector(3 downto 0);

    -- Points
    signal miss_left, miss_right : std_logic;

    -- Victoire
    signal victory_left, victory_right : std_logic;
    signal game_active : std_logic;

begin

    -- Horloge VGA
    clk_div_inst : entity work.clk_divider
        port map (
            clk     => clk,
            clk_out => clk_25
        );

    -- Contrôleur VGA
    vga_ctrl_inst : entity work.vga_controller
        port map (
            clk       => clk_25,
            reset     => reset,
            hsync     => hsync,
            vsync     => vsync,
            video_on  => video_on,
            pixel_x   => pixel_x,
            pixel_y   => pixel_y
        );

    -- Détection de victoire (score = 10)
    victory_left  <= '1' when score_l = "1010" else '0';
    victory_right <= '1' when score_r = "1010" else '0';
    game_active   <= not (victory_left or victory_right);

    -- Raquette gauche
    paddle_l_inst : entity work.paddle_l
        port map (
            clk       => clk,
            reset     => reset,
            btn_up    => btnU,
            btn_down  => btnD,
            enable    => game_active,
            paddle_y  => paddle_l_y
        );

    -- Raquette droite
    paddle_r_inst : entity work.paddle_r
        port map (
            clk       => clk,
            reset     => reset,
            btn_up    => btnL,
            btn_down  => btnR,
            enable    => game_active,
            paddle_y  => paddle_r_y
        );

    -- Balle
    ball_engine_inst : entity work.ball_engine
        port map (
            clk         => clk,
            reset       => reset,
            enable      => game_active,
            paddle_l_y  => paddle_l_y,
            paddle_r_y  => paddle_r_y,
            miss_left   => miss_left,
            miss_right  => miss_right,
            ball_x      => ball_x,
            ball_y      => ball_y
        );

    -- Score
    score_manager_inst : entity work.score_manager
        port map (
            clk         => clk,
            reset       => reset,
            miss_left   => miss_left,
            miss_right  => miss_right,
            score_l     => score_l,
            score_r     => score_r
        );

    -- Affichage
    vga_interface_inst : entity work.vga_interface
        port map (
            clk           => clk_25,
            video_on      => video_on,
            pixel_x       => pixel_x,
            pixel_y       => pixel_y,
            ball_x        => ball_x,
            ball_y        => ball_y,
            paddle_l_y    => paddle_l_y,
            paddle_r_y    => paddle_r_y,
            score_l       => score_l,
            score_r       => score_r,
            victory_left  => victory_left,
            victory_right => victory_right,
            vga_red       => vga_red,
            vga_green     => vga_green,
            vga_blue      => vga_blue
        );

end Behavioral;
