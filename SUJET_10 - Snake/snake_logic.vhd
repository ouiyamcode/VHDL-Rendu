library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity snake_logic is
    Port (
        clk        : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        pixel_x    : in  STD_LOGIC_VECTOR(9 downto 0);
        pixel_y    : in  STD_LOGIC_VECTOR(9 downto 0);
        dir_x      : in  STD_LOGIC_VECTOR(1 downto 0);
        dir_y      : in  STD_LOGIC_VECTOR(1 downto 0);
        snake_on   : out STD_LOGIC;
        wall_on    : out STD_LOGIC;
        head_x     : out unsigned(5 downto 0);
        head_y     : out unsigned(5 downto 0);
        grow_now   : out STD_LOGIC;
        ate_apple  : in  STD_LOGIC;
        hit_wall   : out STD_LOGIC;
        self_collision : out STD_LOGIC
    );
end snake_logic;

architecture Structural of snake_logic is
    constant GRID_WIDTH  : integer := 40;
    constant GRID_HEIGHT : integer := 30;

    signal head_x_i, head_y_i : unsigned(5 downto 0);
    signal tick               : STD_LOGIC := '0';
    signal clk_div            : integer := 0;
    signal move_enable        : STD_LOGIC;
    signal ate_prev           : STD_LOGIC := '0';
    signal grow_now_i         : STD_LOGIC := '0';
    signal hit_wall_i         : STD_LOGIC := '0';
    signal self_col           : STD_LOGIC := '0';
begin

    -- Clock divider (~10Hz)
    process(clk)
    begin
        if rising_edge(clk) then
            if clk_div = 10_000_000 then
                clk_div <= 0;
                tick <= '1';
            else
                clk_div <= clk_div + 1;
                tick <= '0';
            end if;
        end if;
    end process;

    -- Detect grow pulse
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                ate_prev <= '0';
                grow_now_i <= '0';
            else
                if ate_apple = '1' and ate_prev = '0' then
                    grow_now_i <= '1';
                else
                    grow_now_i <= '0';
                end if;
                ate_prev <= ate_apple;
            end if;
        end if;
    end process;

    grow_now <= grow_now_i;

    -- Head movement
    snake_head_inst : entity work.snake_head
        port map (
            clk      => clk,
            reset    => reset,
            tick     => tick,
            dir_x    => dir_x,
            dir_y    => dir_y,
            head_x   => head_x_i,
            head_y   => head_y_i,
            moved    => move_enable
        );

    -- Body movement & self collision
    snake_body_inst : entity work.snake_body
        port map (
            clk            => clk,
            reset          => reset,
            tick           => tick,
            move_enable    => move_enable,
            grow_now       => grow_now_i,
            head_x         => head_x_i,
            head_y         => head_y_i,
            pixel_x        => pixel_x,
            pixel_y        => pixel_y,
            snake_on       => snake_on,
            self_collision => self_col
        );

    -- Wall pixel rendering
    wall_on <= '1' when (
        unsigned(pixel_x(9 downto 4)) = 0 or
        unsigned(pixel_x(9 downto 4)) = to_unsigned(GRID_WIDTH - 1, 6) or
        unsigned(pixel_y(9 downto 4)) = 0 or
        unsigned(pixel_y(9 downto 4)) = to_unsigned(GRID_HEIGHT - 1, 6)
    ) else '0';

    -- Wall collision by head
    hit_wall_i <= '1' when (
        head_x_i = 0 or head_x_i = GRID_WIDTH - 1 or
        head_y_i = 0 or head_y_i = GRID_HEIGHT - 1
    ) else '0';

    hit_wall <= hit_wall_i;
    self_collision <= self_col;

    head_x <= head_x_i;
    head_y <= head_y_i;

end Structural;
