-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Fri May 21 20:39:20 2021
-- Host        : AN-GUANGYAN running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ uart_bmpg_0_stub.vhdl
-- Design      : uart_bmpg_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tfgg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  Port ( 
    upg_clk_i : in STD_LOGIC;
    upg_rst_i : in STD_LOGIC;
    upg_clk_o : out STD_LOGIC;
    upg_wen_o : out STD_LOGIC;
    upg_adr_o : out STD_LOGIC_VECTOR ( 14 downto 0 );
    upg_dat_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    upg_done_o : out STD_LOGIC;
    upg_rx_i : in STD_LOGIC;
    upg_tx_o : out STD_LOGIC
  );

end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture stub of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "upg_clk_i,upg_rst_i,upg_clk_o,upg_wen_o,upg_adr_o[14:0],upg_dat_o[31:0],upg_done_o,upg_rx_i,upg_tx_o";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "upg,Vivado 2020.2";
begin
end;
