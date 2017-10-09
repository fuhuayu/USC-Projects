library verilog;
use verilog.vl_types.all;
entity e1of2_16 is
    generic(
        M               : integer := 16;
        N               : integer := 2;
        W               : vl_notype
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of M : constant is 1;
    attribute mti_svvh_generic_type of N : constant is 1;
    attribute mti_svvh_generic_type of W : constant is 3;
end e1of2_16;
