library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity snake_body is
    Port (
        clk           : in  STD_LOGIC;
        reset         : in  STD_LOGIC;
        tick          : in  STD_LOGIC;
        move_enable   : in  STD_LOGIC;
        grow_now      : in  STD_LOGIC;
        head_x        : in  unsigned(5 downto 0);
        head_y        : in  unsigned(5 downto 0);
        pixel_x       : in  STD_LOGIC_VECTOR(9 downto 0);
        pixel_y       : in  STD_LOGIC_VECTOR(9 downto 0);
        snake_on      : out STD_LOGIC;
        self_collision: out STD_LOGIC
    );
end snake_body;

architecture Behavioral of snake_body is
    constant MAX_LENGTH : integer := 256;

    type position_array is array(0 to MAX_LENGTH - 1) of unsigned(5 downto 0);
    signal body_x, body_y : position_array;

    signal length         : integer range 1 to MAX_LENGTH := 8;
    signal tail_x, tail_y : unsigned(5 downto 0);
    signal grow_latched   : STD_LOGIC := '0';

    signal collision_flag : STD_LOGIC := '0';

begin

    -- Affichage du serpent (chaque segment = carré 16x16 pixels)
    process(pixel_x, pixel_y, body_x, body_y, length)
        variable px, py : unsigned(9 downto 0);
    begin
        px := unsigned(pixel_x);
        py := unsigned(pixel_y);
        snake_on <= '0';

        for i in 0 to MAX_LENGTH - 1 loop
            if i < length then
                if px >= body_x(i)*16 and px < (body_x(i)+1)*16 and
                   py >= body_y(i)*16 and py < (body_y(i)+1)*16 then
                    snake_on <= '1';
                end if;
            end if;
        end loop;
    end process;

    -- Déplacement + croissance + détection auto-collision
    process(clk)
        variable i : integer;
    begin
        if rising_edge(clk) then
            if reset = '1' then
                length        <= 8;
                grow_latched  <= '0';
                collision_flag <= '0';

                for i in 0 to MAX_LENGTH - 1 loop
                    body_x(i) <= (others => '0');
                    body_y(i) <= (others => '0');
                end loop;

            else
                -- si demande de croissance
                if grow_now = '1' then
                    grow_latched <= '1';
                end if;

                if tick = '1' and move_enable = '1' then

                    -- Sauver la position de queue
                    if length < MAX_LENGTH then
                        tail_x <= body_x(length - 1);
                        tail_y <= body_y(length - 1);
                    end if;

                    -- Décaler le corps
                    for i in MAX_LENGTH - 1 downto 1 loop
                        body_x(i) <= body_x(i - 1);
                        body_y(i) <= body_y(i - 1);
                    end loop;

                    -- Placer la tête
                    body_x(0) <= head_x;
                    body_y(0) <= head_y;

                    -- Croissance
                    if grow_latched = '1' and length < MAX_LENGTH then
                        body_x(length) <= tail_x;
                        body_y(length) <= tail_y;
                        length <= length + 1;
                        grow_latched <= '0';
                    end if;

                    -- Détection auto-collision
                    collision_flag <= '0';
                    for i in 1 to MAX_LENGTH - 1 loop
                        if i < length then
                            if body_x(i) = head_x and body_y(i) = head_y then
                                collision_flag <= '1';
                            end if;
                        end if;
                    end loop;

                end if;
            end if;
        end if;
    end process;

    self_collision <= collision_flag;

end Behavioral;
