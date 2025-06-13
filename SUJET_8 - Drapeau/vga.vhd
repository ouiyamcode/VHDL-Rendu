library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga is
    port (
        CLK : in std_logic;
        RST : in std_logic;
        vgaRed : out std_logic_vector (3 downto 0);
        vgaGreen : out std_logic_vector (3 downto 0);
        vgaBlue : out std_logic_vector (3 downto 0);
        Hsync : out std_logic;
        Vsync : out std_logic
    );
end vga;

architecture behavior of vga is

    component vga_controller_640_60
        port (
            rst : in std_logic;
            pixel_clk : in std_logic;
            HS : out std_logic;
            VS : out std_logic;
            hcount : out std_logic_vector(10 downto 0);
            vcount : out std_logic_vector(10 downto 0);
            blank : out std_logic
        );
    end component;

    signal hcount : std_logic_vector (10 downto 0);
    signal vcount : std_logic_vector(10 downto 0);
    signal blank : std_logic;
    signal pixel_clk : std_logic_vector(1 downto 0);

begin

    I0 : vga_controller_640_60 port map (
        rst => RST,
        pixel_clk => pixel_clk(1),
        HS => Hsync,
        VS => Vsync,
        hcount => hcount,
        vcount => vcount,
        blank => blank
    );

    process (CLK, RST)
    begin
        if (RST = '1') then
            pixel_clk <= (others => '0');
        elsif (rising_edge(CLK)) then
            pixel_clk <= pixel_clk + '1';
        end if;
    end process;

    process (blank, hcount)
    begin
        if (blank = '0') then
            if (hcount < 640/3) then
                vgaRed <= "0000";
                vgaGreen <= "0000";
                vgaBlue <= "1111";
            elsif (hcount < (640*2)/3) then
                vgaRed <= "1111";
                vgaGreen <= "1111";
                vgaBlue <= "1111";
            else
                vgaRed <= "1111";
                vgaGreen <= "0000";
                vgaBlue <= "0000";
            end if;
        else
            vgaRed <= (others => '0');
            vgaGreen <= (others => '0');
            vgaBlue <= (others => '0');
        end if;
    end process;

end behavior;
