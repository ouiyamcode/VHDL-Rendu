library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity apple_generator is
    Port (
        clk        : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        head_x     : in  unsigned(5 downto 0);
        head_y     : in  unsigned(5 downto 0);
        pixel_x    : in  STD_LOGIC_VECTOR(9 downto 0);
        pixel_y    : in  STD_LOGIC_VECTOR(9 downto 0);
        apple_on   : out STD_LOGIC;
        ate_apple  : out STD_LOGIC;
        apple_x    : out unsigned(5 downto 0);
        apple_y    : out unsigned(5 downto 0)
    );
end apple_generator;

architecture Behavioral of apple_generator is
    constant GRID_WIDTH  : integer := 40;
    constant GRID_HEIGHT : integer := 30;

    signal a_x, a_y : unsigned(5 downto 0) := to_unsigned(10, 6);
    signal grid_x, grid_y : unsigned(5 downto 0);
    signal lfsr_x, lfsr_y : std_logic_vector(5 downto 0) := "101011";
begin

    -- Conversion pixel -> grille
    grid_x <= unsigned(pixel_x(9 downto 4));
    grid_y <= unsigned(pixel_y(9 downto 4));

    -- Affichage de la pomme (VGA)
    apple_on <= '1' when (grid_x = a_x and grid_y = a_y) else '0';

    -- Position actuelle de la pomme
    apple_x <= a_x;
    apple_y <= a_y;

    -- Détection de la prise de pomme
    ate_apple <= '1' when (head_x = a_x and head_y = a_y) else '0';

    -- Génération pseudo-aléatoire de la prochaine position
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                a_x <= to_unsigned(10, 6);
                a_y <= to_unsigned(10, 6);
                lfsr_x <= "101011";
                lfsr_y <= "110001";
            elsif (head_x = a_x and head_y = a_y) then
                -- Mise à jour du LFSR (Linear Feedback Shift Register)
                lfsr_x <= lfsr_x(4 downto 0) & (lfsr_x(5) xor lfsr_x(3));
                lfsr_y <= lfsr_y(4 downto 0) & (lfsr_y(5) xor lfsr_y(4));

                -- Nouvelles coordonnées, entre 1 et (GRID_X-2)/(GRID_Y-2)
                a_x <= to_unsigned((to_integer(unsigned(lfsr_x)) mod (GRID_WIDTH - 2)) + 1, 6);
                a_y <= to_unsigned((to_integer(unsigned(lfsr_y)) mod (GRID_HEIGHT - 2)) + 1, 6);
            end if;
        end if;
    end process;

end Behavioral;
