## Horloge
set_property PACKAGE_PIN W5 [get_ports CLK]
set_property IOSTANDARD LVCMOS33 [get_ports CLK]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports CLK]

## Bouton reset
set_property PACKAGE_PIN U18 [get_ports RST]
set_property IOSTANDARD LVCMOS33 [get_ports RST]

## VGA Rouge
set_property PACKAGE_PIN G19 [get_ports {vgaRed[0]}]
set_property PACKAGE_PIN H19 [get_ports {vgaRed[1]}]
set_property PACKAGE_PIN J19 [get_ports {vgaRed[2]}]
set_property PACKAGE_PIN N19 [get_ports {vgaRed[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgaRed[*]}]

## VGA Vert
set_property PACKAGE_PIN J17 [get_ports {vgaGreen[0]}]
set_property PACKAGE_PIN H17 [get_ports {vgaGreen[1]}]
set_property PACKAGE_PIN G17 [get_ports {vgaGreen[2]}]
set_property PACKAGE_PIN D17 [get_ports {vgaGreen[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgaGreen[*]}]

## VGA Bleu
set_property PACKAGE_PIN N18 [get_ports {vgaBlue[0]}]
set_property PACKAGE_PIN L18 [get_ports {vgaBlue[1]}]
set_property PACKAGE_PIN K18 [get_ports {vgaBlue[2]}]
set_property PACKAGE_PIN J18 [get_ports {vgaBlue[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgaBlue[*]}]

## VGA Sync
set_property PACKAGE_PIN P19 [get_ports Hsync]
set_property PACKAGE_PIN R19 [get_ports Vsync]
set_property IOSTANDARD LVCMOS33 [get_ports Hsync]
set_property IOSTANDARD LVCMOS33 [get_ports Vsync]
