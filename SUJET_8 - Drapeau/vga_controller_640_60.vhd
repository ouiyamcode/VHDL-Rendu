library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity vga_controller_640_60 is
    port (
        rst         : in std_logic;
        pixel_clk   : in std_logic;
        HS          : out std_logic;
        VS          : out std_logic;
        hcount      : out std_logic_vector(10 downto 0);
        vcount      : out std_logic_vector(10 downto 0);
        blank       : out std_logic
    );
end vga_controller_640_60;

architecture Behavioral of vga_controller_640_60 is
    constant HMAX  : std_logic_vector(10 downto 0) := "01100100000"; -- 800
    constant VMAX  : std_logic_vector(10 downto 0) := "01000001101"; -- 525
    constant HLINES: std_logic_vector(10 downto 0) := "01010000000"; -- 640
    constant HFP   : std_logic_vector(10 downto 0) := "01010001000"; -- 648
    constant HSP   : std_logic_vector(10 downto 0) := "01011101000"; -- 744
    constant VLINES: std_logic_vector(10 downto 0) := "00111100000"; -- 480
    constant VFP   : std_logic_vector(10 downto 0) := "00111100010"; -- 482
    constant VSP   : std_logic_vector(10 downto 0) := "00111100100"; -- 484
    constant SPP   : std_logic := '0';

    signal hcounter : std_logic_vector(10 downto 0) := (others => '0');
    signal vcounter : std_logic_vector(10 downto 0) := (others => '0');
    signal video_enable : std_logic;

begin
    hcount <= hcounter;
    vcount <= vcounter;

    blank <= not video_enable when rising_edge(pixel_clk);

    process(pixel_clk)
    begin
        if rising_edge(pixel_clk) then
            if rst = '1' then
                hcounter <= (others => '0');
            elsif hcounter = HMAX then
                hcounter <= (others => '0');
            else
                hcounter <= hcounter + 1;
            end if;
        end if;
    end process;

    process(pixel_clk)
    begin
        if rising_edge(pixel_clk) then
            if rst = '1' then
                vcounter <= (others => '0');
            elsif hcounter = HMAX then
                if vcounter = VMAX then
                    vcounter <= (others => '0');
                else
                    vcounter <= vcounter + 1;
                end if;
            end if;
        end if;
    end process;

    process(pixel_clk)
    begin
        if rising_edge(pixel_clk) then
            if hcounter >= HFP and hcounter < HSP then
                HS <= SPP;
            else
                HS <= not SPP;
            end if;
        end if;
    end process;

    process(pixel_clk)
    begin
        if rising_edge(pixel_clk) then
            if vcounter >= VFP and vcounter < VSP then
                VS <= SPP;
            else
                VS <= not SPP;
            end if;
        end if;
    end process;

    video_enable <= '1' when (hcounter < HLINES and vcounter < VLINES) else '0';

end Behavioral;
