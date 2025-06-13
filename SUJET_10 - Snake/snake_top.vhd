library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity snake_top is
    Port (
        clk       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        btnU      : in  STD_LOGIC;
        btnD      : in  STD_LOGIC;
        btnL      : in  STD_LOGIC;
        btnR      : in  STD_LOGIC;
        hsync     : out STD_LOGIC;
        vsync     : out STD_LOGIC;
        led       : out STD_LOGIC_VECTOR(0 downto 0);
        vga_red   : out STD_LOGIC_VECTOR(3 downto 0);
        vga_green : out STD_LOGIC_VECTOR(3 downto 0);
        vga_blue  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end snake_top;

architecture Behavioral of snake_top is

    signal clk25           : STD_LOGIC;
    signal pixel_x         : STD_LOGIC_VECTOR(9 downto 0);
    signal pixel_y         : STD_LOGIC_VECTOR(9 downto 0);
    signal video_on        : STD_LOGIC;

    signal snake_on        : STD_LOGIC;
    signal apple_on        : STD_LOGIC;
    signal wall_on         : STD_LOGIC;
    signal red, green, blue: STD_LOGIC_VECTOR(3 downto 0);

    signal grow_now_dbg    : STD_LOGIC;
    signal ate_apple_raw   : STD_LOGIC;
    signal ate_apple_sync  : STD_LOGIC;
    signal ate_apple_d1    : STD_LOGIC := '0';

    signal dir_x, dir_y    : STD_LOGIC_VECTOR(1 downto 0);
    signal head_x, head_y  : unsigned(5 downto 0);

    signal hit_wall        : STD_LOGIC;
    signal self_collision  : STD_LOGIC;
    signal game_over       : STD_LOGIC;

begin

    -- Clock divider for 25 MHz
    clkdiv_inst : entity work.clk_divider
        port map(clk => clk, clk_out => clk25);

    -- VGA controller
    vga_inst : entity work.vga_controller
        port map(
            clk      => clk25,
            reset    => reset,
            hsync    => hsync,
            vsync    => vsync,
            video_on => video_on,
            pixel_x  => pixel_x,
            pixel_y  => pixel_y
        );

    -- Direction controller
    dir_ctrl : entity work.direction_controller
        port map(
            clk   => clk,
            reset => reset,
            btnU  => btnU,
            btnD  => btnD,
            btnL  => btnL,
            btnR  => btnR,
            dir_x => dir_x,
            dir_y => dir_y
        );

    -- Synchroniser ate_apple
    process(clk)
    begin
        if rising_edge(clk) then
            ate_apple_d1   <= ate_apple_raw;
            ate_apple_sync <= ate_apple_d1;
        end if;
    end process;

    -- Snake logic
    snake_inst : entity work.snake_logic
        port map(
            clk            => clk,
            reset          => reset,
            pixel_x        => pixel_x,
            pixel_y        => pixel_y,
            dir_x          => dir_x,
            dir_y          => dir_y,
            snake_on       => snake_on,
            wall_on        => wall_on,
            head_x         => head_x,
            head_y         => head_y,
            grow_now       => grow_now_dbg,
            ate_apple      => ate_apple_sync,
            hit_wall       => hit_wall,
            self_collision => self_collision
        );

    -- Apple logic
    apple_inst : entity work.apple_generator
        port map (
            clk        => clk,
            reset      => reset,
            head_x     => head_x,
            head_y     => head_y,
            pixel_x    => pixel_x,
            pixel_y    => pixel_y,
            apple_on   => apple_on,
            ate_apple  => ate_apple_raw,
            apple_x    => open,
            apple_y    => open
        );

    -- Game over detection
    game_over <= hit_wall or self_collision;

    -- Pixel rendering
    renderer : entity work.pixel_renderer
        port map(
            snake_on  => snake_on,
            wall_on   => wall_on,
            apple_on  => apple_on,
            video_on  => video_on,
            game_over => game_over,
            red       => red,
            green     => green,
            blue      => blue
        );

    -- VGA output
    vga_red   <= red;
    vga_green <= green;
    vga_blue  <= blue;

    -- Debug LED
    led(0) <= grow_now_dbg;

end Behavioral;
