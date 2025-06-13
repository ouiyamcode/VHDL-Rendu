library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity snake_head is
    Port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        tick     : in  STD_LOGIC;
        dir_x    : in  STD_LOGIC_VECTOR(1 downto 0);
        dir_y    : in  STD_LOGIC_VECTOR(1 downto 0);
        head_x   : out unsigned(5 downto 0);
        head_y   : out unsigned(5 downto 0);
        moved    : out STD_LOGIC
    );
end snake_head;

architecture Behavioral of snake_head is
    constant GRID_WIDTH  : integer := 40;
    constant GRID_HEIGHT : integer := 30;

    signal x, y   : unsigned(5 downto 0) := to_unsigned(5, 6);
    signal pause  : STD_LOGIC := '0';
begin

    process(clk)
        variable next_x, next_y : unsigned(5 downto 0);
        variable blocked        : boolean;
    begin
        if rising_edge(clk) then
            if reset = '1' then
                x <= to_unsigned(5, 6);
                y <= to_unsigned(5, 6);
                pause <= '0';
                moved <= '0';
            elsif tick = '1' then
                next_x := x;
                next_y := y;

                if dir_x = "01" then
                    next_x := x + 1;
                elsif dir_x = "11" then
                    next_x := x - 1;
                elsif dir_y = "10" then
                    next_y := y + 1;
                elsif dir_y = "00" then
                    next_y := y - 1;
                end if;

                blocked := (
                    next_x <= 0 or next_x >= to_unsigned(GRID_WIDTH - 1, 6) or
                    next_y <= 0 or next_y >= to_unsigned(GRID_HEIGHT - 1, 6)
                );

                if pause = '1' then
                    if not blocked then
                        pause <= '0';
                        x <= next_x;
                        y <= next_y;
                        moved <= '1';
                    else
                        moved <= '0';
                    end if;
                else
                    if blocked then
                        pause <= '1';
                        moved <= '0';
                    else
                        x <= next_x;
                        y <= next_y;
                        moved <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;

    head_x <= x;
    head_y <= y;
end Behavioral;