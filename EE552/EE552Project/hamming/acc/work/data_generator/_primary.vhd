library verilog;
use verilog.vl_types.all;
entity data_generator is
    generic(
        W               : integer := 16
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of W : constant is 1;
end data_generator;
