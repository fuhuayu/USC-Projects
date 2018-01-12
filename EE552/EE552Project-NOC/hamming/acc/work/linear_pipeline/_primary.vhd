library verilog;
use verilog.vl_types.all;
entity linear_pipeline is
    generic(
        NUMBER_OF_BUF   : integer := 6
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NUMBER_OF_BUF : constant is 1;
end linear_pipeline;
