library verilog;
use verilog.vl_types.all;
entity middle_finder is
    port(
        A               : in     vl_logic_vector(3 downto 0);
        B               : in     vl_logic_vector(3 downto 0);
        C               : in     vl_logic_vector(3 downto 0);
        MIDDLE          : out    vl_logic_vector(3 downto 0)
    );
end middle_finder;
