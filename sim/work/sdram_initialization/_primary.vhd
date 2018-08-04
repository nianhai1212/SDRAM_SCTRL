library verilog;
use verilog.vl_types.all;
entity sdram_initialization is
    port(
        sclk            : in     vl_logic;
        snrst           : in     vl_logic;
        cke             : out    vl_logic;
        cmd             : out    vl_logic_vector(3 downto 0);
        mod_config      : out    vl_logic_vector(12 downto 0);
        init_done       : out    vl_logic
    );
end sdram_initialization;
