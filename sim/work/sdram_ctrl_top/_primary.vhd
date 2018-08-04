library verilog;
use verilog.vl_types.all;
entity sdram_ctrl_top is
    port(
        sclk            : in     vl_logic;
        snrst           : in     vl_logic;
        Dq              : out    vl_logic_vector(15 downto 0);
        Addr            : out    vl_logic_vector(12 downto 0);
        Ba              : out    vl_logic_vector(1 downto 0);
        Clk             : out    vl_logic;
        Cke             : out    vl_logic;
        Cs_n            : out    vl_logic;
        Ras_n           : out    vl_logic;
        Cas_n           : out    vl_logic;
        We_n            : out    vl_logic;
        Dqm             : out    vl_logic_vector(1 downto 0)
    );
end sdram_ctrl_top;
