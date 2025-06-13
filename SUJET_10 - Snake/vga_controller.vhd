library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga_controller is
    Port (
        clk       : in  STD_LOGIC;  -- pixel clock 25 MHz
        reset     : in  STD_LOGIC;
        hsync     : out STD_LOGIC;
        vsync     : out STD_LOGIC;
        pixel_x   : out STD_LOGIC_VECTOR(9 downto 0);
        pixel_y   : out STD_LOGIC_VECTOR(9 downto 0);
        video_on  : out STD_LOGIC
    );
end vga_controller;

architecture Behavioral of vga_controller is

    -- Constants based on 640x480 @ 60Hz timing
    constant HMAX   : integer := 800;
    constant VMAX   : integer := 525;
    constant HLINES : integer := 640;
    constant HFP    : integer := 648;
    constant HSP    : integer := 744;
    constant VLINES : integer := 480;
    constant VFP    : integer := 482;
    constant VSP    : integer := 484;

    constant SPP : std_logic := '0'; -- Sync pulse polarity

    signal hcounter : integer range 0 to HMAX := 0;
    signal vcounter : integer range 0 to VMAX := 0;
    signal video_en : std_logic;

begin

    -- Counters
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                hcounter <= 0;
            elsif hcounter = HMAX then
                hcounter <= 0;
            else
                hcounter <= hcounter + 1;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                vcounter <= 0;
            elsif hcounter = HMAX then
                if vcounter = VMAX then
                    vcounter <= 0;
                else
                    vcounter <= vcounter + 1;
                end if;
            end if;
        end if;
    end process;

    -- HSYNC
    process(clk)
    begin
        if rising_edge(clk) then
            if hcounter >= HFP and hcounter < HSP then
                hsync <= SPP;
            else
                hsync <= not SPP;
            end if;
        end if;
    end process;

    -- VSYNC
    process(clk)
    begin
        if rising_edge(clk) then
            if vcounter >= VFP and vcounter < VSP then
                vsync <= SPP;
            else
                vsync <= not SPP;
            end if;
        end if;
    end process;

    -- Video ON (visible area)
    video_en <= '1' when (hcounter < HLINES and vcounter < VLINES) else '0';

    -- Output pixel coordinates
    pixel_x <= conv_std_logic_vector(hcounter, 10);
    pixel_y <= conv_std_logic_vector(vcounter, 10);
    video_on <= video_en;

end Behavioral;
