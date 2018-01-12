library verilog;
use verilog.vl_types.all;
entity cosim_checker is
    generic(
        W               : integer := 16
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of W : constant is 1;
end cosim_checker;
