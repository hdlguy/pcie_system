library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity top is
port (
    pcie_7x_mgt_rxn : in    STD_LOGIC;
    pcie_7x_mgt_rxp : in    STD_LOGIC;
    pcie_7x_mgt_txn : out   STD_LOGIC;
    pcie_7x_mgt_txp : out   STD_LOGIC;
    pcie_perstn     : in    STD_LOGIC;
    pcie_refclk_N   : in    STD_LOGIC;
    pcie_refclk_P   : in    STD_LOGIC;
    --
    cpu_reset       : in    std_logic;
    --
    led             : out   std_logic_vector(7 downto 0));
end top;

architecture STRUCTURE of top is

    signal slv_read0 : STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_read1 : STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_read2 : STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_read3 : STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_read4 : STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_read5 : STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_read6 : STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_read7 : STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_read8 : STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_read9 : STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_read10 : STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_read11 : STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_read12 : STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_read13 : STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_read14 : STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_read15 : STD_LOGIC_VECTOR ( 31 downto 0 );
    --
    signal slv_reg0 :  STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_reg1 :  STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_reg2 :  STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_reg3 :  STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_reg4 :  STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_reg5 :  STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_reg6 :  STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_reg7 :  STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_reg8 :  STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_reg9 :  STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_reg10:  STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_reg11:  STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_reg12:  STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_reg13:  STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_reg14:  STD_LOGIC_VECTOR ( 31 downto 0 );
    signal slv_reg15:  STD_LOGIC_VECTOR ( 31 downto 0 );
    --
    signal clk26, clk : std_logic;
    signal axi_clk, axi_reset_n  :  std_logic;
    --
    signal led_flash_count : std_logic_vector(26 downto 0);
    --
begin
    --
    -- map the register file.
    -- reg 0
    slv_read0 <= X"BEEFCAFE"; -- Just something to read.
    -- reg 1
    slv_read1 <= X"00010001"; -- Version/Revision number
    -- reg 2
    slv_read2(31 downto 6) <= slv_reg2(31 downto 6);
    slv_read2( 4 downto 0) <= slv_reg2(4 downto 0);
    -- reg 3
    slv_read3 <= slv_reg3;
    -- reg 4
    slv_read4 <= slv_reg4;
    -- reg 5
    slv_read5(31 downto 1) <= slv_reg5(31 downto 1);
    -- reg 6
    slv_read6(31 downto 8) <= slv_reg6(31 downto 8);
    -- reg 7
    slv_read7 <= slv_reg7;
    led(5 downto 0) <= slv_reg7(5 downto 0);
    -- reg 8
    slv_read8  <= slv_reg8;
    -- unused registers.
    slv_read9  <= (others=>'0');
    slv_read10 <= (others=>'0');
    slv_read11 <= (others=>'0');
    slv_read12 <= (others=>'0');
    slv_read13 <= (others=>'0');
    slv_read14 <= (others=>'0');
    slv_read15 <= (others=>'0');


    system_i: entity work. system
    port map (
        axi_clk => axi_clk,
        axi_reset_n(0) => axi_reset_n,
        cpu_reset => cpu_reset,
        pcie_7x_mgt_rxn => pcie_7x_mgt_rxn,
        pcie_7x_mgt_rxp => pcie_7x_mgt_rxp,
        pcie_7x_mgt_txn => pcie_7x_mgt_txn,
        pcie_7x_mgt_txp => pcie_7x_mgt_txp,
        pcie_perst => pcie_perst,
        pcie_perstn => pcie_perstn,
        pcie_refclk_N => pcie_refclk_N,
        pcie_refclk_P => pcie_refclk_P,
        slv_read0 => slv_read0,
        slv_read1 => slv_read1,
        slv_read10 => slv_read10,
        slv_read11 => slv_read11,
        slv_read12 => slv_read12,
        slv_read13 => slv_read13,
        slv_read14 => slv_read14,
        slv_read15 => slv_read15,
        slv_read2 => slv_read2,
        slv_read3 => slv_read3,
        slv_read4 => slv_read4,
        slv_read5 => slv_read5,
        slv_read6 => slv_read6,
        slv_read7 => slv_read7,
        slv_read8 => slv_read8,
        slv_read9 => slv_read9,
        slv_reg0 => slv_reg0,
        slv_reg1 => slv_reg1,
        slv_reg10 => slv_reg10,
        slv_reg11 => slv_reg11,
        slv_reg12 => slv_reg12,
        slv_reg13 => slv_reg13,
        slv_reg14 => slv_reg14,
        slv_reg15 => slv_reg15,
        slv_reg2 => slv_reg2,
        slv_reg3 => slv_reg3,
        slv_reg4 => slv_reg4,
        slv_reg5 => slv_reg5,
        slv_reg6 => slv_reg6,
        slv_reg7 => slv_reg7,
        slv_reg8 => slv_reg8,
        slv_reg9 => slv_reg9);

    led_flash_proc:process
    begin
        wait until rising_edge(clk);
        led_flash_count <= std_logic_vector(unsigned(led_flash_count)+1);
        led(7) <= led_flash_count(led_flash_count'left);
    end process;


end STRUCTURE;
