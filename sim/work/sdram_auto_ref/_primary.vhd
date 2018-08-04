library verilog;
use verilog.vl_types.all;
entity sdram_auto_ref is
    port(
        sclk            : in     vl_logic;
        snrst           : in     vl_logic;
        initial_done    : in     vl_logic;
        aref_en         : in     vl_logic;
        aref_req        : out    vl_logic;
        ref_done        : out    vl_logic;
        aref_cmd        : out    vl_logic_vector(3 downto 0);
        sdram_addr      : out    vl_logic_vector(12 downto 0)
    );
end sdram_auto_ref;
