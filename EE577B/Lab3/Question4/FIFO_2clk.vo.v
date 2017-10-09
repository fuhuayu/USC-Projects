module gray2bin_SIZE5_3 (
	gray, 
	bin);
   input [4:0] gray;
   output [4:0] bin;

   assign bin[4] = gray[4] ;

   XOR2X1 U1 (.Y(bin[2]), 
	.B(bin[3]), 
	.A(gray[2]));
   XOR2X1 U2 (.Y(bin[0]), 
	.B(bin[1]), 
	.A(gray[0]));
   FAX1 U3 (.YS(bin[1]), 
	.YC(), 
	.C(bin[3]), 
	.B(gray[1]), 
	.A(gray[2]));
   XOR2X1 U4 (.Y(bin[3]), 
	.B(gray[4]), 
	.A(gray[3]));
endmodule

module gray2bin_SIZE5_2 (
	gray, 
	bin);
   input [4:0] gray;
   output [4:0] bin;

   assign bin[4] = gray[4] ;

   XOR2X1 U1 (.Y(bin[2]), 
	.B(bin[3]), 
	.A(gray[2]));
   XOR2X1 U2 (.Y(bin[0]), 
	.B(bin[1]), 
	.A(gray[0]));
   FAX1 U3 (.YS(bin[1]), 
	.YC(), 
	.C(bin[3]), 
	.B(gray[1]), 
	.A(gray[2]));
   XOR2X1 U4 (.Y(bin[3]), 
	.B(gray[4]), 
	.A(gray[3]));
endmodule

module gray2bin_SIZE5_1 (
	gray, 
	bin);
   input [4:0] gray;
   output [4:0] bin;

   assign bin[4] = gray[4] ;

   XOR2X1 U1 (.Y(bin[2]), 
	.B(bin[3]), 
	.A(gray[2]));
   XOR2X1 U2 (.Y(bin[0]), 
	.B(bin[1]), 
	.A(gray[0]));
   FAX1 U3 (.YS(bin[1]), 
	.YC(), 
	.C(bin[3]), 
	.B(gray[1]), 
	.A(gray[2]));
   XOR2X1 U4 (.Y(bin[3]), 
	.B(gray[4]), 
	.A(gray[3]));
endmodule

module gray2bin_SIZE5_0 (
	gray, 
	bin);
   input [4:0] gray;
   output [4:0] bin;

   assign bin[4] = gray[4] ;

   XOR2X1 U1 (.Y(bin[2]), 
	.B(bin[3]), 
	.A(gray[2]));
   XOR2X1 U2 (.Y(bin[0]), 
	.B(bin[1]), 
	.A(gray[0]));
   FAX1 U3 (.YS(bin[1]), 
	.YC(), 
	.C(bin[3]), 
	.B(gray[1]), 
	.A(gray[2]));
   XOR2X1 U4 (.Y(bin[3]), 
	.B(gray[4]), 
	.A(gray[3]));
endmodule

module bin2gray_SIZE5_1 (
	bin, 
	gray);
   input [4:0] bin;
   output [4:0] gray;

   assign gray[4] = bin[4] ;

   XOR2X1 U1 (.Y(gray[3]), 
	.B(bin[3]), 
	.A(bin[4]));
   XOR2X1 U2 (.Y(gray[2]), 
	.B(bin[2]), 
	.A(bin[3]));
   XOR2X1 U3 (.Y(gray[1]), 
	.B(bin[1]), 
	.A(bin[2]));
   XOR2X1 U4 (.Y(gray[0]), 
	.B(bin[0]), 
	.A(bin[1]));
endmodule

module bin2gray_SIZE5_0 (
	bin, 
	gray);
   input [4:0] bin;
   output [4:0] gray;

   assign gray[4] = bin[4] ;

   XOR2X1 U1 (.Y(gray[3]), 
	.B(bin[3]), 
	.A(bin[4]));
   XOR2X1 U2 (.Y(gray[2]), 
	.B(bin[2]), 
	.A(bin[3]));
   XOR2X1 U3 (.Y(gray[1]), 
	.B(bin[1]), 
	.A(bin[2]));
   XOR2X1 U4 (.Y(gray[0]), 
	.B(bin[0]), 
	.A(bin[1]));
endmodule

module FIFO_2clk (
	rclk, 
	wclk, 
	reset, 
	put, 
	get, 
	data_in, 
	empty_bar, 
	full_bar, 
	data_out);
   input rclk;
   input wclk;
   input reset;
   input put;
   input get;
   input [7:0] data_in;
   output empty_bar;
   output full_bar;
   output [7:0] data_out;

   // Internal wires
   wire FE_PHN261_mem_36_;
   wire FE_PHN260_mem_96_;
   wire FE_PHN259_mem_73_;
   wire FE_PHN258_mem_20_;
   wire FE_PHN257_mem_67_;
   wire FE_PHN256_mem_49_;
   wire FE_PHN255_mem_117_;
   wire FE_PHN254_mem_68_;
   wire FE_PHN253_mem_61_;
   wire FE_PHN252_mem_69_;
   wire FE_PHN251_mem_23_;
   wire FE_PHN250_mem_83_;
   wire FE_PHN249_mem_84_;
   wire FE_PHN248_mem_95_;
   wire FE_PHN247_mem_101_;
   wire FE_PHN246_mem_58_;
   wire FE_PHN245_mem_93_;
   wire FE_PHN244_mem_108_;
   wire FE_PHN243_mem_111_;
   wire FE_PHN242_mem_11_;
   wire FE_PHN241_mem_51_;
   wire FE_PHN240_mem_75_;
   wire FE_PHN239_mem_3_;
   wire FE_PHN238_mem_52_;
   wire FE_PHN237_mem_4_;
   wire FE_PHN236_mem_124_;
   wire FE_PHN235_mem_12_;
   wire FE_PHN234_mem_100_;
   wire FE_PHN233_mem_104_;
   wire FE_PHN232_mem_85_;
   wire FE_PHN231_mem_107_;
   wire FE_PHN230_mem_97_;
   wire FE_PHN229_mem_60_;
   wire FE_PHN228_mem_123_;
   wire FE_PHN227_mem_125_;
   wire FE_PHN226_mem_28_;
   wire FE_PHN225_mem_99_;
   wire FE_PHN224_mem_91_;
   wire FE_PHN223_mem_72_;
   wire FE_PHN222_mem_62_;
   wire FE_PHN221_mem_113_;
   wire FE_PHN220_mem_15_;
   wire FE_PHN219_mem_87_;
   wire FE_PHN218_mem_34_;
   wire FE_PHN217_mem_118_;
   wire FE_PHN216_mem_120_;
   wire FE_PHN215_mem_30_;
   wire FE_PHN214_mem_121_;
   wire FE_PHN213_mem_86_;
   wire FE_PHN212_mem_64_;
   wire FE_PHN211_mem_126_;
   wire FE_PHN210_mem_42_;
   wire FE_PHN209_mem_13_;
   wire FE_PHN208_mem_38_;
   wire FE_PHN207_mem_54_;
   wire FE_PHN206_mem_127_;
   wire FE_PHN205_mem_43_;
   wire FE_PHN204_mem_50_;
   wire FE_PHN203_mem_40_;
   wire FE_PHN202_mem_6_;
   wire FE_PHN201_mem_56_;
   wire FE_PHN200_mem_98_;
   wire FE_PHN199_mem_80_;
   wire FE_PHN198_mem_122_;
   wire FE_PHN197_mem_25_;
   wire FE_PHN196_mem_46_;
   wire FE_PHN195_mem_29_;
   wire FE_PHN194_mem_21_;
   wire FE_PHN193_mem_18_;
   wire FE_PHN192_mem_16_;
   wire FE_PHN191_mem_7_;
   wire FE_PHN190_mem_90_;
   wire FE_PHN189_mem_45_;
   wire FE_PHN188_mem_119_;
   wire FE_PHN187_mem_26_;
   wire FE_PHN186_mem_19_;
   wire FE_PHN185_mem_5_;
   wire FE_PHN184_mem_32_;
   wire FE_PHN183_mem_48_;
   wire FE_PHN182_mem_14_;
   wire FE_PHN181_mem_112_;
   wire FE_PHN180_mem_82_;
   wire FE_PHN179_mem_31_;
   wire FE_PHN178_mem_24_;
   wire FE_PHN177_mem_94_;
   wire FE_PHN176_mem_63_;
   wire FE_PHN175_mem_10_;
   wire FE_PHN174_mem_37_;
   wire FE_PHN173_mem_106_;
   wire FE_PHN172_mem_88_;
   wire FE_PHN171_mem_44_;
   wire FE_PHN170_mem_22_;
   wire FE_PHN169_mem_59_;
   wire FE_PHN168_mem_0_;
   wire FE_PHN167_mem_66_;
   wire FE_PHN166_mem_35_;
   wire FE_PHN165_mem_74_;
   wire FE_PHN164_mem_8_;
   wire FE_PHN163_mem_27_;
   wire FE_PHN162_n537;
   wire FE_PHN161_mem_94_;
   wire FE_PHN160_mem_10_;
   wire FE_PHN159_mem_26_;
   wire FE_PHN158_mem_119_;
   wire FE_PHN157_mem_25_;
   wire FE_PHN156_mem_126_;
   wire FE_PHN155_mem_112_;
   wire FE_PHN154_mem_120_;
   wire FE_PHN153_mem_21_;
   wire FE_PHN152_mem_86_;
   wire FE_PHN151_mem_73_;
   wire FE_PHN150_mem_74_;
   wire FE_PHN149_mem_106_;
   wire FE_PHN148_mem_9_;
   wire FE_PHN147_mem_2_;
   wire FE_PHN146_mem_7_;
   wire FE_PHN145_mem_104_;
   wire FE_PHN144_mem_66_;
   wire FE_PHN143_mem_59_;
   wire FE_PHN142_mem_118_;
   wire FE_PHN141_mem_48_;
   wire FE_PHN140_mem_89_;
   wire FE_PHN139_mem_103_;
   wire FE_PHN138_mem_97_;
   wire FE_PHN137_mem_45_;
   wire FE_PHN136_mem_22_;
   wire FE_PHN135_mem_81_;
   wire FE_PHN134_mem_33_;
   wire FE_PHN133_mem_13_;
   wire FE_PHN132_mem_29_;
   wire FE_PHN131_mem_127_;
   wire FE_PHN130_mem_18_;
   wire FE_PHN129_mem_43_;
   wire FE_PHN128_mem_87_;
   wire FE_PHN127_mem_63_;
   wire FE_PHN126_mem_88_;
   wire FE_PHN125_mem_57_;
   wire FE_PHN124_mem_96_;
   wire FE_PHN123_mem_56_;
   wire FE_PHN122_mem_46_;
   wire FE_PHN121_mem_15_;
   wire FE_PHN120_mem_90_;
   wire FE_PHN119_mem_37_;
   wire FE_PHN118_mem_71_;
   wire FE_PHN117_mem_65_;
   wire FE_PHN116_mem_54_;
   wire FE_PHN115_mem_50_;
   wire FE_PHN114_mem_58_;
   wire FE_PHN113_mem_31_;
   wire FE_PHN112_mem_0_;
   wire FE_PHN111_mem_64_;
   wire FE_PHN110_mem_6_;
   wire FE_PHN109_mem_19_;
   wire FE_PHN108_mem_72_;
   wire FE_PHN107_mem_27_;
   wire FE_PHN106_mem_39_;
   wire FE_PHN105_mem_80_;
   wire FE_PHN104_mem_62_;
   wire FE_PHN103_mem_122_;
   wire FE_PHN102_mem_30_;
   wire FE_PHN101_mem_105_;
   wire FE_PHN100_mem_32_;
   wire FE_PHN99_mem_34_;
   wire FE_PHN98_mem_79_;
   wire FE_PHN97_mem_16_;
   wire FE_PHN96_mem_8_;
   wire FE_PHN95_mem_47_;
   wire FE_PHN94_mem_98_;
   wire FE_PHN93_mem_5_;
   wire FE_PHN92_mem_40_;
   wire FE_PHN91_mem_38_;
   wire FE_PHN90_mem_95_;
   wire FE_PHN89_mem_113_;
   wire FE_PHN88_mem_41_;
   wire FE_PHN87_mem_121_;
   wire FE_PHN86_mem_82_;
   wire FE_PHN85_mem_35_;
   wire FE_PHN84_mem_42_;
   wire FE_PHN83_mem_114_;
   wire FE_PHN82_mem_14_;
   wire FE_PHN81_mem_17_;
   wire FE_PHN80_mem_24_;
   wire FE_PHN79_mem_111_;
   wire FE_PHN78_mem_1_;
   wire FE_PHN77_mem_49_;
   wire FE_PHN76_n46;
   wire FE_PHN75_n46;
   wire FE_PHN74_n46;
   wire FE_PHN73_n49;
   wire FE_PHN72_n46;
   wire FE_PHN71_n49;
   wire FE_PHN70_n46;
   wire FE_PHN69_n48;
   wire FE_PHN68_n47;
   wire FE_PHN67_n49;
   wire FE_PHN66_n46;
   wire FE_PHN65_n50;
   wire FE_PHN64_n48;
   wire FE_PHN63_n47;
   wire FE_PHN62_n49;
   wire FE_PHN61_n46;
   wire FE_PHN60_n50;
   wire FE_PHN59_n48;
   wire FE_PHN58_n47;
   wire FE_PHN57_n49;
   wire FE_PHN56_n46;
   wire FE_PHN55_n50;
   wire FE_PHN54_n48;
   wire FE_PHN53_n47;
   wire FE_PHN52_n327;
   wire FE_PHN51_n47;
   wire FE_PHN50_n331;
   wire FE_PHN49_n327;
   wire FE_PHN48_n330;
   wire FE_PHN47_n50;
   wire FE_PHN46_n48;
   wire FE_PHN45_n47;
   wire FE_PHN44_n331;
   wire FE_PHN43_n327;
   wire FE_PHN42_n330;
   wire FE_PHN41_n333;
   wire FE_PHN40_n50;
   wire FE_PHN39_n48;
   wire FE_PHN38_n49;
   wire FE_PHN37_n47;
   wire FE_PHN36_n46;
   wire FE_PHN35_n331;
   wire FE_PHN34_n327;
   wire FE_PHN33_n333;
   wire FE_PHN32_n330;
   wire FE_PHN31_wr_ptr_0_;
   wire FE_PHN30_n50;
   wire FE_PHN29_n48;
   wire FE_PHN28_n46;
   wire FE_PHN27_n47;
   wire FE_PHN26_n49;
   wire FE_PHN25_n47;
   wire FE_PHN24_n50;
   wire FE_PHN23_n48;
   wire FE_PHN22_n46;
   wire FE_PHN21_n49;
   wire FE_PHN20_n330;
   wire FE_PHN19_n327;
   wire FE_PHN18_n331;
   wire FE_PHN17_n333;
   wire FE_PHN16_wr_ptr_4_;
   wire FE_PHN15_n332;
   wire FE_PHN14_n56;
   wire FE_PHN13_n48;
   wire FE_PHN12_n50;
   wire FE_PHN11_n47;
   wire FE_PHN10_n49;
   wire FE_PHN9_n46;
   wire FE_PHN8_n330;
   wire FE_PHN7_wr_ptr_4_;
   wire FE_PHN6_wr_ptr_2_;
   wire FE_PHN5_n332;
   wire FE_PHN4_n327;
   wire FE_PHN3_n333;
   wire FE_PHN2_wr_ptr_0_;
   wire FE_PHN1_n331;
   wire FE_PHN0_n56;
   wire rclk__L2_N0;
   wire rclk__L1_N0;
   wire wclk__L2_N1;
   wire wclk__L2_N0;
   wire wclk__L1_N0;
   wire n14;
   wire n15;
   wire n16;
   wire n17;
   wire rd_ptr_bin_4_;
   wire FULL;
   wire n20;
   wire n21;
   wire n46;
   wire n47;
   wire n48;
   wire n49;
   wire n50;
   wire n51;
   wire n52;
   wire n53;
   wire n54;
   wire n55;
   wire n56;
   wire EMPTY;
   wire n85;
   wire n86;
   wire n87;
   wire n88;
   wire n89;
   wire n90;
   wire n91;
   wire n92;
   wire n93;
   wire n94;
   wire n95;
   wire n96;
   wire n97;
   wire n98;
   wire n99;
   wire n100;
   wire n101;
   wire n102;
   wire n103;
   wire n172;
   wire n173;
   wire n174;
   wire n175;
   wire n176;
   wire n177;
   wire n178;
   wire n179;
   wire n180;
   wire n181;
   wire n182;
   wire n183;
   wire n184;
   wire n185;
   wire n186;
   wire n187;
   wire n188;
   wire n189;
   wire n190;
   wire n191;
   wire n192;
   wire n193;
   wire n194;
   wire n195;
   wire n196;
   wire n197;
   wire n198;
   wire n199;
   wire n200;
   wire n201;
   wire n202;
   wire n203;
   wire n204;
   wire n205;
   wire n206;
   wire n207;
   wire n208;
   wire n209;
   wire n210;
   wire n211;
   wire n212;
   wire n213;
   wire n214;
   wire n215;
   wire n216;
   wire n217;
   wire n218;
   wire n219;
   wire n220;
   wire n221;
   wire n222;
   wire n223;
   wire n224;
   wire n225;
   wire n226;
   wire n227;
   wire n228;
   wire n229;
   wire n230;
   wire n231;
   wire n232;
   wire n233;
   wire n234;
   wire n235;
   wire n236;
   wire n237;
   wire n238;
   wire n239;
   wire n240;
   wire n241;
   wire n242;
   wire n243;
   wire n244;
   wire n245;
   wire n246;
   wire n247;
   wire n248;
   wire n249;
   wire n250;
   wire n251;
   wire n252;
   wire n253;
   wire n254;
   wire n255;
   wire n256;
   wire n257;
   wire n258;
   wire n259;
   wire n260;
   wire n261;
   wire n262;
   wire n263;
   wire n264;
   wire n265;
   wire n266;
   wire n267;
   wire n268;
   wire n269;
   wire n270;
   wire n271;
   wire n272;
   wire n273;
   wire n274;
   wire n275;
   wire n276;
   wire n277;
   wire n278;
   wire n279;
   wire n280;
   wire n281;
   wire n282;
   wire n283;
   wire n284;
   wire n285;
   wire n286;
   wire n287;
   wire n288;
   wire n289;
   wire n290;
   wire n291;
   wire n292;
   wire n293;
   wire n294;
   wire n295;
   wire n296;
   wire n297;
   wire n298;
   wire n299;
   wire n300;
   wire n301;
   wire n302;
   wire n303;
   wire n304;
   wire n305;
   wire n306;
   wire n307;
   wire n308;
   wire n309;
   wire n310;
   wire n311;
   wire n312;
   wire n313;
   wire n314;
   wire n315;
   wire n316;
   wire n317;
   wire n318;
   wire n319;
   wire n320;
   wire n321;
   wire n322;
   wire n323;
   wire n324;
   wire n325;
   wire n326;
   wire n327;
   wire n328;
   wire n329;
   wire n330;
   wire n331;
   wire n332;
   wire n333;
   wire n334;
   wire n335;
   wire n336;
   wire n337;
   wire n338;
   wire n339;
   wire n340;
   wire n341;
   wire n342;
   wire n343;
   wire n344;
   wire n345;
   wire n346;
   wire n347;
   wire n348;
   wire n349;
   wire n350;
   wire n351;
   wire n352;
   wire n353;
   wire n354;
   wire n355;
   wire n356;
   wire n357;
   wire n358;
   wire n359;
   wire n360;
   wire n361;
   wire n362;
   wire n363;
   wire n364;
   wire n365;
   wire n366;
   wire n367;
   wire n368;
   wire n369;
   wire n370;
   wire n371;
   wire n372;
   wire n373;
   wire n374;
   wire n375;
   wire n376;
   wire n377;
   wire n378;
   wire n379;
   wire n380;
   wire n381;
   wire n382;
   wire n383;
   wire n384;
   wire n385;
   wire n386;
   wire n387;
   wire n388;
   wire n389;
   wire n390;
   wire n391;
   wire n392;
   wire n393;
   wire n394;
   wire n395;
   wire n396;
   wire n397;
   wire n398;
   wire n399;
   wire n400;
   wire n401;
   wire n402;
   wire n403;
   wire n404;
   wire n405;
   wire n406;
   wire n407;
   wire n408;
   wire n409;
   wire n410;
   wire n411;
   wire n412;
   wire n413;
   wire n414;
   wire n415;
   wire n416;
   wire n417;
   wire n418;
   wire n419;
   wire n420;
   wire n421;
   wire n422;
   wire n423;
   wire n424;
   wire n425;
   wire n426;
   wire n427;
   wire n428;
   wire n429;
   wire n430;
   wire n431;
   wire n432;
   wire n433;
   wire n434;
   wire n435;
   wire n436;
   wire n437;
   wire n438;
   wire n439;
   wire n440;
   wire n441;
   wire n442;
   wire n443;
   wire n444;
   wire n445;
   wire n446;
   wire n447;
   wire n448;
   wire n449;
   wire n450;
   wire n451;
   wire n452;
   wire n453;
   wire n454;
   wire n455;
   wire n456;
   wire n457;
   wire n458;
   wire n459;
   wire n460;
   wire n461;
   wire n462;
   wire n463;
   wire n464;
   wire n465;
   wire n466;
   wire n467;
   wire n468;
   wire n469;
   wire n470;
   wire n471;
   wire n472;
   wire n473;
   wire n474;
   wire n475;
   wire n476;
   wire n477;
   wire n478;
   wire n479;
   wire n480;
   wire n481;
   wire n482;
   wire n483;
   wire n484;
   wire n485;
   wire n486;
   wire n487;
   wire n488;
   wire n489;
   wire n490;
   wire n491;
   wire n492;
   wire add_55_carry_4_;
   wire n498;
   wire n499;
   wire n500;
   wire n501;
   wire n502;
   wire n503;
   wire n504;
   wire n505;
   wire n506;
   wire n507;
   wire n508;
   wire n509;
   wire n510;
   wire n511;
   wire n512;
   wire n513;
   wire n514;
   wire n515;
   wire n516;
   wire n517;
   wire n518;
   wire n519;
   wire n520;
   wire n521;
   wire n522;
   wire n523;
   wire n524;
   wire n525;
   wire n526;
   wire n527;
   wire n528;
   wire n529;
   wire n530;
   wire n531;
   wire n532;
   wire n533;
   wire n534;
   wire n535;
   wire n536;
   wire n537;
   wire n538;
   wire n539;
   wire n540;
   wire n541;
   wire n542;
   wire n543;
   wire n544;
   wire n545;
   wire n546;
   wire n547;
   wire n548;
   wire n549;
   wire n550;
   wire n551;
   wire n552;
   wire n553;
   wire n554;
   wire n555;
   wire n556;
   wire n557;
   wire n558;
   wire n559;
   wire n560;
   wire n561;
   wire n562;
   wire n563;
   wire n564;
   wire n565;
   wire n566;
   wire n567;
   wire n568;
   wire n569;
   wire n570;
   wire n571;
   wire n572;
   wire n573;
   wire n574;
   wire n575;
   wire n576;
   wire n577;
   wire n578;
   wire n579;
   wire n580;
   wire n581;
   wire n582;
   wire n583;
   wire n584;
   wire n585;
   wire n586;
   wire n587;
   wire n588;
   wire n589;
   wire n590;
   wire n591;
   wire n592;
   wire n593;
   wire n594;
   wire n595;
   wire n596;
   wire n597;
   wire n598;
   wire n599;
   wire n600;
   wire n601;
   wire n602;
   wire n603;
   wire n604;
   wire n605;
   wire n606;
   wire n607;
   wire n608;
   wire n609;
   wire n610;
   wire n611;
   wire n612;
   wire n613;
   wire n614;
   wire n615;
   wire n616;
   wire n617;
   wire n618;
   wire n619;
   wire n620;
   wire n621;
   wire n622;
   wire n623;
   wire n624;
   wire n628;
   wire n629;
   wire n630;
   wire n631;
   wire n632;
   wire n633;
   wire n634;
   wire n635;
   wire n636;
   wire n637;
   wire n638;
   wire n639;
   wire n640;
   wire n641;
   wire n642;
   wire n643;
   wire n644;
   wire n645;
   wire n646;
   wire n647;
   wire n648;
   wire n649;
   wire n650;
   wire n651;
   wire n652;
   wire n653;
   wire n654;
   wire n655;
   wire n656;
   wire n657;
   wire n658;
   wire n659;
   wire n660;
   wire n661;
   wire n662;
   wire n663;
   wire n664;
   wire n665;
   wire n666;
   wire n667;
   wire n668;
   wire n669;
   wire n670;
   wire n671;
   wire n672;
   wire n673;
   wire n674;
   wire n675;
   wire n676;
   wire n677;
   wire n678;
   wire n679;
   wire n680;
   wire n681;
   wire n682;
   wire n683;
   wire n684;
   wire n685;
   wire n686;
   wire n687;
   wire n688;
   wire n689;
   wire n690;
   wire n691;
   wire n692;
   wire n693;
   wire n694;
   wire n695;
   wire n696;
   wire n697;
   wire n698;
   wire n699;
   wire n700;
   wire n701;
   wire n702;
   wire n703;
   wire n704;
   wire n705;
   wire n706;
   wire n707;
   wire n708;
   wire n709;
   wire n710;
   wire n711;
   wire n712;
   wire n713;
   wire n714;
   wire n715;
   wire n716;
   wire n717;
   wire n718;
   wire n719;
   wire n720;
   wire n721;
   wire n722;
   wire n723;
   wire n724;
   wire n725;
   wire n726;
   wire n727;
   wire n728;
   wire n729;
   wire n730;
   wire n731;
   wire n732;
   wire n733;
   wire n734;
   wire n735;
   wire n736;
   wire n737;
   wire n738;
   wire n739;
   wire n740;
   wire n741;
   wire n742;
   wire n743;
   wire n744;
   wire n745;
   wire n746;
   wire n747;
   wire n748;
   wire n749;
   wire n750;
   wire n751;
   wire n752;
   wire n753;
   wire n754;
   wire n755;
   wire n756;
   wire n757;
   wire n758;
   wire n759;
   wire n760;
   wire n761;
   wire n762;
   wire n763;
   wire n764;
   wire n765;
   wire n766;
   wire n767;
   wire n768;
   wire n769;
   wire n770;
   wire n771;
   wire n772;
   wire n773;
   wire n774;
   wire n775;
   wire n776;
   wire n777;
   wire n778;
   wire n779;
   wire n780;
   wire n781;
   wire n782;
   wire n788;
   wire n789;
   wire n790;
   wire n791;
   wire n792;
   wire n793;
   wire n794;
   wire n795;
   wire n796;
   wire n797;
   wire n798;
   wire n799;
   wire n800;
   wire n801;
   wire n802;
   wire n803;
   wire n804;
   wire n805;
   wire n806;
   wire n807;
   wire n808;
   wire n809;
   wire n810;
   wire n811;
   wire n813;
   wire n814;
   wire n816;
   wire n817;
   wire n818;
   wire n819;
   wire [4:0] rd_ptr_ss;
   wire [4:0] rd_ptr_ss_bin;
   wire [4:0] wr_ptr_ss;
   wire [4:0] wr_ptr_ss_bin;
   wire [4:0] rd_ptr;
   wire [4:0] wr_ptr;
   wire [4:0] wr_ptr_bin;
   wire [4:0] wr_ptr_bin_p1;
   wire [4:1] rd_ptr_bin_p1;
   wire [4:0] wr_ptr_p1;
   wire [4:0] rd_ptr_p1;
   wire [4:0] diff;
   wire [4:0] rd_ptr_s;
   wire [127:0] mem;
   wire [4:0] wr_ptr_s;
   wire [4:1] sub_38_carry;
   wire [4:2] add_35_carry;
   wire [4:2] add_34_carry;

   BUFX2 FE_PHC261_mem_36_ (.Y(FE_PHN261_mem_36_), 
	.A(mem[36]));
   BUFX2 FE_PHC260_mem_96_ (.Y(FE_PHN260_mem_96_), 
	.A(FE_PHN124_mem_96_));
   BUFX2 FE_PHC259_mem_73_ (.Y(FE_PHN259_mem_73_), 
	.A(FE_PHN151_mem_73_));
   BUFX2 FE_PHC258_mem_20_ (.Y(FE_PHN258_mem_20_), 
	.A(mem[20]));
   BUFX2 FE_PHC257_mem_67_ (.Y(FE_PHN257_mem_67_), 
	.A(mem[67]));
   BUFX2 FE_PHC256_mem_49_ (.Y(FE_PHN256_mem_49_), 
	.A(FE_PHN77_mem_49_));
   BUFX2 FE_PHC255_mem_117_ (.Y(FE_PHN255_mem_117_), 
	.A(mem[117]));
   BUFX2 FE_PHC254_mem_68_ (.Y(FE_PHN254_mem_68_), 
	.A(mem[68]));
   BUFX2 FE_PHC253_mem_61_ (.Y(FE_PHN253_mem_61_), 
	.A(mem[61]));
   BUFX2 FE_PHC252_mem_69_ (.Y(FE_PHN252_mem_69_), 
	.A(mem[69]));
   BUFX2 FE_PHC251_mem_23_ (.Y(FE_PHN251_mem_23_), 
	.A(mem[23]));
   BUFX2 FE_PHC250_mem_83_ (.Y(FE_PHN250_mem_83_), 
	.A(mem[83]));
   BUFX2 FE_PHC249_mem_84_ (.Y(FE_PHN249_mem_84_), 
	.A(mem[84]));
   BUFX2 FE_PHC248_mem_95_ (.Y(FE_PHN248_mem_95_), 
	.A(FE_PHN90_mem_95_));
   BUFX2 FE_PHC247_mem_101_ (.Y(FE_PHN247_mem_101_), 
	.A(mem[101]));
   BUFX2 FE_PHC246_mem_58_ (.Y(FE_PHN246_mem_58_), 
	.A(mem[58]));
   BUFX2 FE_PHC245_mem_93_ (.Y(FE_PHN245_mem_93_), 
	.A(mem[93]));
   BUFX2 FE_PHC244_mem_108_ (.Y(FE_PHN244_mem_108_), 
	.A(mem[108]));
   BUFX2 FE_PHC243_mem_111_ (.Y(FE_PHN243_mem_111_), 
	.A(mem[111]));
   BUFX2 FE_PHC242_mem_11_ (.Y(FE_PHN242_mem_11_), 
	.A(mem[11]));
   BUFX2 FE_PHC241_mem_51_ (.Y(FE_PHN241_mem_51_), 
	.A(mem[51]));
   BUFX2 FE_PHC240_mem_75_ (.Y(FE_PHN240_mem_75_), 
	.A(mem[75]));
   BUFX2 FE_PHC239_mem_3_ (.Y(FE_PHN239_mem_3_), 
	.A(mem[3]));
   BUFX2 FE_PHC238_mem_52_ (.Y(FE_PHN238_mem_52_), 
	.A(mem[52]));
   BUFX2 FE_PHC237_mem_4_ (.Y(FE_PHN237_mem_4_), 
	.A(mem[4]));
   BUFX2 FE_PHC236_mem_124_ (.Y(FE_PHN236_mem_124_), 
	.A(mem[124]));
   BUFX2 FE_PHC235_mem_12_ (.Y(FE_PHN235_mem_12_), 
	.A(mem[12]));
   BUFX2 FE_PHC234_mem_100_ (.Y(FE_PHN234_mem_100_), 
	.A(mem[100]));
   BUFX2 FE_PHC233_mem_104_ (.Y(FE_PHN233_mem_104_), 
	.A(FE_PHN145_mem_104_));
   BUFX2 FE_PHC232_mem_85_ (.Y(FE_PHN232_mem_85_), 
	.A(mem[85]));
   BUFX2 FE_PHC231_mem_107_ (.Y(FE_PHN231_mem_107_), 
	.A(mem[107]));
   BUFX2 FE_PHC230_mem_97_ (.Y(FE_PHN230_mem_97_), 
	.A(FE_PHN138_mem_97_));
   BUFX2 FE_PHC229_mem_60_ (.Y(FE_PHN229_mem_60_), 
	.A(mem[60]));
   BUFX2 FE_PHC228_mem_123_ (.Y(FE_PHN228_mem_123_), 
	.A(mem[123]));
   BUFX2 FE_PHC227_mem_125_ (.Y(FE_PHN227_mem_125_), 
	.A(mem[125]));
   BUFX2 FE_PHC226_mem_28_ (.Y(FE_PHN226_mem_28_), 
	.A(mem[28]));
   BUFX2 FE_PHC225_mem_99_ (.Y(FE_PHN225_mem_99_), 
	.A(mem[99]));
   BUFX2 FE_PHC224_mem_91_ (.Y(FE_PHN224_mem_91_), 
	.A(mem[91]));
   BUFX2 FE_PHC223_mem_72_ (.Y(FE_PHN223_mem_72_), 
	.A(FE_PHN108_mem_72_));
   BUFX2 FE_PHC222_mem_62_ (.Y(FE_PHN222_mem_62_), 
	.A(FE_PHN104_mem_62_));
   BUFX2 FE_PHC221_mem_113_ (.Y(FE_PHN221_mem_113_), 
	.A(FE_PHN89_mem_113_));
   BUFX2 FE_PHC220_mem_15_ (.Y(FE_PHN220_mem_15_), 
	.A(mem[15]));
   BUFX2 FE_PHC219_mem_87_ (.Y(FE_PHN219_mem_87_), 
	.A(FE_PHN128_mem_87_));
   BUFX2 FE_PHC218_mem_34_ (.Y(FE_PHN218_mem_34_), 
	.A(FE_PHN99_mem_34_));
   BUFX2 FE_PHC217_mem_118_ (.Y(FE_PHN217_mem_118_), 
	.A(FE_PHN142_mem_118_));
   BUFX2 FE_PHC216_mem_120_ (.Y(FE_PHN216_mem_120_), 
	.A(FE_PHN154_mem_120_));
   BUFX2 FE_PHC215_mem_30_ (.Y(FE_PHN215_mem_30_), 
	.A(FE_PHN102_mem_30_));
   BUFX2 FE_PHC214_mem_121_ (.Y(FE_PHN214_mem_121_), 
	.A(FE_PHN87_mem_121_));
   BUFX2 FE_PHC213_mem_86_ (.Y(FE_PHN213_mem_86_), 
	.A(FE_PHN152_mem_86_));
   BUFX2 FE_PHC212_mem_64_ (.Y(FE_PHN212_mem_64_), 
	.A(mem[64]));
   BUFX2 FE_PHC211_mem_126_ (.Y(FE_PHN211_mem_126_), 
	.A(FE_PHN156_mem_126_));
   BUFX2 FE_PHC210_mem_42_ (.Y(FE_PHN210_mem_42_), 
	.A(FE_PHN84_mem_42_));
   BUFX2 FE_PHC209_mem_13_ (.Y(FE_PHN209_mem_13_), 
	.A(FE_PHN133_mem_13_));
   BUFX2 FE_PHC208_mem_38_ (.Y(FE_PHN208_mem_38_), 
	.A(mem[38]));
   BUFX2 FE_PHC207_mem_54_ (.Y(FE_PHN207_mem_54_), 
	.A(FE_PHN116_mem_54_));
   BUFX2 FE_PHC206_mem_127_ (.Y(FE_PHN206_mem_127_), 
	.A(FE_PHN131_mem_127_));
   BUFX2 FE_PHC205_mem_43_ (.Y(FE_PHN205_mem_43_), 
	.A(mem[43]));
   BUFX2 FE_PHC204_mem_50_ (.Y(FE_PHN204_mem_50_), 
	.A(mem[50]));
   BUFX2 FE_PHC203_mem_40_ (.Y(FE_PHN203_mem_40_), 
	.A(FE_PHN92_mem_40_));
   BUFX2 FE_PHC202_mem_6_ (.Y(FE_PHN202_mem_6_), 
	.A(FE_PHN110_mem_6_));
   BUFX2 FE_PHC201_mem_56_ (.Y(FE_PHN201_mem_56_), 
	.A(mem[56]));
   BUFX2 FE_PHC200_mem_98_ (.Y(FE_PHN200_mem_98_), 
	.A(FE_PHN94_mem_98_));
   BUFX2 FE_PHC199_mem_80_ (.Y(FE_PHN199_mem_80_), 
	.A(FE_PHN105_mem_80_));
   BUFX2 FE_PHC198_mem_122_ (.Y(FE_PHN198_mem_122_), 
	.A(FE_PHN103_mem_122_));
   BUFX2 FE_PHC197_mem_25_ (.Y(FE_PHN197_mem_25_), 
	.A(FE_PHN157_mem_25_));
   BUFX2 FE_PHC196_mem_46_ (.Y(FE_PHN196_mem_46_), 
	.A(FE_PHN122_mem_46_));
   BUFX2 FE_PHC195_mem_29_ (.Y(FE_PHN195_mem_29_), 
	.A(mem[29]));
   BUFX2 FE_PHC194_mem_21_ (.Y(FE_PHN194_mem_21_), 
	.A(FE_PHN153_mem_21_));
   BUFX2 FE_PHC193_mem_18_ (.Y(FE_PHN193_mem_18_), 
	.A(mem[18]));
   BUFX2 FE_PHC192_mem_16_ (.Y(FE_PHN192_mem_16_), 
	.A(FE_PHN97_mem_16_));
   BUFX2 FE_PHC191_mem_7_ (.Y(FE_PHN191_mem_7_), 
	.A(FE_PHN146_mem_7_));
   BUFX2 FE_PHC190_mem_90_ (.Y(FE_PHN190_mem_90_), 
	.A(FE_PHN120_mem_90_));
   BUFX2 FE_PHC189_mem_45_ (.Y(FE_PHN189_mem_45_), 
	.A(mem[45]));
   BUFX2 FE_PHC188_mem_119_ (.Y(FE_PHN188_mem_119_), 
	.A(FE_PHN158_mem_119_));
   BUFX2 FE_PHC187_mem_26_ (.Y(FE_PHN187_mem_26_), 
	.A(mem[26]));
   BUFX2 FE_PHC186_mem_19_ (.Y(FE_PHN186_mem_19_), 
	.A(FE_PHN109_mem_19_));
   BUFX2 FE_PHC185_mem_5_ (.Y(FE_PHN185_mem_5_), 
	.A(FE_PHN93_mem_5_));
   BUFX2 FE_PHC184_mem_32_ (.Y(FE_PHN184_mem_32_), 
	.A(FE_PHN100_mem_32_));
   BUFX2 FE_PHC183_mem_48_ (.Y(FE_PHN183_mem_48_), 
	.A(FE_PHN141_mem_48_));
   BUFX2 FE_PHC182_mem_14_ (.Y(FE_PHN182_mem_14_), 
	.A(FE_PHN82_mem_14_));
   BUFX2 FE_PHC181_mem_112_ (.Y(FE_PHN181_mem_112_), 
	.A(FE_PHN155_mem_112_));
   BUFX2 FE_PHC180_mem_82_ (.Y(FE_PHN180_mem_82_), 
	.A(FE_PHN86_mem_82_));
   BUFX2 FE_PHC179_mem_31_ (.Y(FE_PHN179_mem_31_), 
	.A(mem[31]));
   BUFX2 FE_PHC178_mem_24_ (.Y(FE_PHN178_mem_24_), 
	.A(mem[24]));
   BUFX2 FE_PHC177_mem_94_ (.Y(FE_PHN177_mem_94_), 
	.A(FE_PHN161_mem_94_));
   BUFX2 FE_PHC176_mem_63_ (.Y(FE_PHN176_mem_63_), 
	.A(mem[63]));
   BUFX2 FE_PHC175_mem_10_ (.Y(FE_PHN175_mem_10_), 
	.A(mem[10]));
   BUFX2 FE_PHC174_mem_37_ (.Y(FE_PHN174_mem_37_), 
	.A(mem[37]));
   BUFX2 FE_PHC173_mem_106_ (.Y(FE_PHN173_mem_106_), 
	.A(FE_PHN149_mem_106_));
   BUFX2 FE_PHC172_mem_88_ (.Y(FE_PHN172_mem_88_), 
	.A(mem[88]));
   BUFX2 FE_PHC171_mem_44_ (.Y(FE_PHN171_mem_44_), 
	.A(mem[44]));
   BUFX2 FE_PHC170_mem_22_ (.Y(FE_PHN170_mem_22_), 
	.A(FE_PHN136_mem_22_));
   BUFX2 FE_PHC169_mem_59_ (.Y(FE_PHN169_mem_59_), 
	.A(mem[59]));
   BUFX2 FE_PHC168_mem_0_ (.Y(FE_PHN168_mem_0_), 
	.A(FE_PHN112_mem_0_));
   BUFX2 FE_PHC167_mem_66_ (.Y(FE_PHN167_mem_66_), 
	.A(FE_PHN144_mem_66_));
   BUFX2 FE_PHC166_mem_35_ (.Y(FE_PHN166_mem_35_), 
	.A(mem[35]));
   BUFX2 FE_PHC165_mem_74_ (.Y(FE_PHN165_mem_74_), 
	.A(mem[74]));
   BUFX2 FE_PHC164_mem_8_ (.Y(FE_PHN164_mem_8_), 
	.A(FE_PHN96_mem_8_));
   BUFX2 FE_PHC163_mem_27_ (.Y(FE_PHN163_mem_27_), 
	.A(mem[27]));
   BUFX2 FE_PHC162_n537 (.Y(FE_PHN162_n537), 
	.A(n537));
   BUFX2 FE_PHC161_mem_94_ (.Y(FE_PHN161_mem_94_), 
	.A(mem[94]));
   BUFX2 FE_PHC160_mem_10_ (.Y(FE_PHN160_mem_10_), 
	.A(FE_PHN175_mem_10_));
   BUFX2 FE_PHC159_mem_26_ (.Y(FE_PHN159_mem_26_), 
	.A(FE_PHN187_mem_26_));
   BUFX2 FE_PHC158_mem_119_ (.Y(FE_PHN158_mem_119_), 
	.A(mem[119]));
   BUFX2 FE_PHC157_mem_25_ (.Y(FE_PHN157_mem_25_), 
	.A(mem[25]));
   BUFX2 FE_PHC156_mem_126_ (.Y(FE_PHN156_mem_126_), 
	.A(mem[126]));
   BUFX2 FE_PHC155_mem_112_ (.Y(FE_PHN155_mem_112_), 
	.A(mem[112]));
   BUFX2 FE_PHC154_mem_120_ (.Y(FE_PHN154_mem_120_), 
	.A(mem[120]));
   BUFX2 FE_PHC153_mem_21_ (.Y(FE_PHN153_mem_21_), 
	.A(mem[21]));
   BUFX2 FE_PHC152_mem_86_ (.Y(FE_PHN152_mem_86_), 
	.A(mem[86]));
   BUFX2 FE_PHC151_mem_73_ (.Y(FE_PHN151_mem_73_), 
	.A(mem[73]));
   BUFX2 FE_PHC150_mem_74_ (.Y(FE_PHN150_mem_74_), 
	.A(FE_PHN165_mem_74_));
   BUFX2 FE_PHC149_mem_106_ (.Y(FE_PHN149_mem_106_), 
	.A(mem[106]));
   BUFX2 FE_PHC148_mem_9_ (.Y(FE_PHN148_mem_9_), 
	.A(mem[9]));
   BUFX2 FE_PHC147_mem_2_ (.Y(FE_PHN147_mem_2_), 
	.A(mem[2]));
   BUFX2 FE_PHC146_mem_7_ (.Y(FE_PHN146_mem_7_), 
	.A(mem[7]));
   BUFX2 FE_PHC145_mem_104_ (.Y(FE_PHN145_mem_104_), 
	.A(mem[104]));
   BUFX2 FE_PHC144_mem_66_ (.Y(FE_PHN144_mem_66_), 
	.A(mem[66]));
   BUFX2 FE_PHC143_mem_59_ (.Y(FE_PHN143_mem_59_), 
	.A(FE_PHN169_mem_59_));
   BUFX2 FE_PHC142_mem_118_ (.Y(FE_PHN142_mem_118_), 
	.A(mem[118]));
   BUFX2 FE_PHC141_mem_48_ (.Y(FE_PHN141_mem_48_), 
	.A(mem[48]));
   BUFX2 FE_PHC140_mem_89_ (.Y(FE_PHN140_mem_89_), 
	.A(mem[89]));
   BUFX2 FE_PHC139_mem_103_ (.Y(FE_PHN139_mem_103_), 
	.A(mem[103]));
   BUFX2 FE_PHC138_mem_97_ (.Y(FE_PHN138_mem_97_), 
	.A(mem[97]));
   BUFX2 FE_PHC137_mem_45_ (.Y(FE_PHN137_mem_45_), 
	.A(FE_PHN189_mem_45_));
   BUFX2 FE_PHC136_mem_22_ (.Y(FE_PHN136_mem_22_), 
	.A(mem[22]));
   BUFX2 FE_PHC135_mem_81_ (.Y(FE_PHN135_mem_81_), 
	.A(mem[81]));
   BUFX2 FE_PHC134_mem_33_ (.Y(FE_PHN134_mem_33_), 
	.A(mem[33]));
   BUFX2 FE_PHC133_mem_13_ (.Y(FE_PHN133_mem_13_), 
	.A(mem[13]));
   BUFX2 FE_PHC132_mem_29_ (.Y(FE_PHN132_mem_29_), 
	.A(FE_PHN195_mem_29_));
   BUFX2 FE_PHC131_mem_127_ (.Y(FE_PHN131_mem_127_), 
	.A(mem[127]));
   BUFX2 FE_PHC130_mem_18_ (.Y(FE_PHN130_mem_18_), 
	.A(FE_PHN193_mem_18_));
   BUFX2 FE_PHC129_mem_43_ (.Y(FE_PHN129_mem_43_), 
	.A(FE_PHN205_mem_43_));
   BUFX2 FE_PHC128_mem_87_ (.Y(FE_PHN128_mem_87_), 
	.A(mem[87]));
   BUFX2 FE_PHC127_mem_63_ (.Y(FE_PHN127_mem_63_), 
	.A(FE_PHN176_mem_63_));
   BUFX2 FE_PHC126_mem_88_ (.Y(FE_PHN126_mem_88_), 
	.A(FE_PHN172_mem_88_));
   BUFX2 FE_PHC125_mem_57_ (.Y(FE_PHN125_mem_57_), 
	.A(mem[57]));
   BUFX2 FE_PHC124_mem_96_ (.Y(FE_PHN124_mem_96_), 
	.A(mem[96]));
   BUFX2 FE_PHC123_mem_56_ (.Y(FE_PHN123_mem_56_), 
	.A(FE_PHN201_mem_56_));
   BUFX2 FE_PHC122_mem_46_ (.Y(FE_PHN122_mem_46_), 
	.A(mem[46]));
   BUFX2 FE_PHC121_mem_15_ (.Y(FE_PHN121_mem_15_), 
	.A(FE_PHN220_mem_15_));
   BUFX2 FE_PHC120_mem_90_ (.Y(FE_PHN120_mem_90_), 
	.A(mem[90]));
   BUFX2 FE_PHC119_mem_37_ (.Y(FE_PHN119_mem_37_), 
	.A(FE_PHN174_mem_37_));
   BUFX2 FE_PHC118_mem_71_ (.Y(FE_PHN118_mem_71_), 
	.A(mem[71]));
   BUFX2 FE_PHC117_mem_65_ (.Y(FE_PHN117_mem_65_), 
	.A(mem[65]));
   BUFX2 FE_PHC116_mem_54_ (.Y(FE_PHN116_mem_54_), 
	.A(mem[54]));
   BUFX2 FE_PHC115_mem_50_ (.Y(FE_PHN115_mem_50_), 
	.A(FE_PHN204_mem_50_));
   BUFX2 FE_PHC114_mem_58_ (.Y(FE_PHN114_mem_58_), 
	.A(FE_PHN246_mem_58_));
   BUFX2 FE_PHC113_mem_31_ (.Y(FE_PHN113_mem_31_), 
	.A(FE_PHN179_mem_31_));
   BUFX2 FE_PHC112_mem_0_ (.Y(FE_PHN112_mem_0_), 
	.A(mem[0]));
   BUFX2 FE_PHC111_mem_64_ (.Y(FE_PHN111_mem_64_), 
	.A(FE_PHN212_mem_64_));
   BUFX2 FE_PHC110_mem_6_ (.Y(FE_PHN110_mem_6_), 
	.A(mem[6]));
   BUFX2 FE_PHC109_mem_19_ (.Y(FE_PHN109_mem_19_), 
	.A(mem[19]));
   BUFX2 FE_PHC108_mem_72_ (.Y(FE_PHN108_mem_72_), 
	.A(mem[72]));
   BUFX2 FE_PHC107_mem_27_ (.Y(FE_PHN107_mem_27_), 
	.A(FE_PHN163_mem_27_));
   BUFX2 FE_PHC106_mem_39_ (.Y(FE_PHN106_mem_39_), 
	.A(mem[39]));
   BUFX2 FE_PHC105_mem_80_ (.Y(FE_PHN105_mem_80_), 
	.A(mem[80]));
   BUFX2 FE_PHC104_mem_62_ (.Y(FE_PHN104_mem_62_), 
	.A(mem[62]));
   BUFX2 FE_PHC103_mem_122_ (.Y(FE_PHN103_mem_122_), 
	.A(mem[122]));
   BUFX2 FE_PHC102_mem_30_ (.Y(FE_PHN102_mem_30_), 
	.A(mem[30]));
   BUFX2 FE_PHC101_mem_105_ (.Y(FE_PHN101_mem_105_), 
	.A(mem[105]));
   BUFX2 FE_PHC100_mem_32_ (.Y(FE_PHN100_mem_32_), 
	.A(mem[32]));
   BUFX2 FE_PHC99_mem_34_ (.Y(FE_PHN99_mem_34_), 
	.A(mem[34]));
   BUFX2 FE_PHC98_mem_79_ (.Y(FE_PHN98_mem_79_), 
	.A(mem[79]));
   BUFX2 FE_PHC97_mem_16_ (.Y(FE_PHN97_mem_16_), 
	.A(mem[16]));
   BUFX2 FE_PHC96_mem_8_ (.Y(FE_PHN96_mem_8_), 
	.A(mem[8]));
   BUFX2 FE_PHC95_mem_47_ (.Y(FE_PHN95_mem_47_), 
	.A(mem[47]));
   BUFX2 FE_PHC94_mem_98_ (.Y(FE_PHN94_mem_98_), 
	.A(mem[98]));
   BUFX2 FE_PHC93_mem_5_ (.Y(FE_PHN93_mem_5_), 
	.A(mem[5]));
   BUFX2 FE_PHC92_mem_40_ (.Y(FE_PHN92_mem_40_), 
	.A(mem[40]));
   BUFX2 FE_PHC91_mem_38_ (.Y(FE_PHN91_mem_38_), 
	.A(FE_PHN208_mem_38_));
   BUFX2 FE_PHC90_mem_95_ (.Y(FE_PHN90_mem_95_), 
	.A(mem[95]));
   BUFX2 FE_PHC89_mem_113_ (.Y(FE_PHN89_mem_113_), 
	.A(mem[113]));
   BUFX2 FE_PHC88_mem_41_ (.Y(FE_PHN88_mem_41_), 
	.A(mem[41]));
   BUFX2 FE_PHC87_mem_121_ (.Y(FE_PHN87_mem_121_), 
	.A(mem[121]));
   BUFX2 FE_PHC86_mem_82_ (.Y(FE_PHN86_mem_82_), 
	.A(mem[82]));
   BUFX2 FE_PHC85_mem_35_ (.Y(FE_PHN85_mem_35_), 
	.A(FE_PHN166_mem_35_));
   BUFX2 FE_PHC84_mem_42_ (.Y(FE_PHN84_mem_42_), 
	.A(mem[42]));
   BUFX2 FE_PHC83_mem_114_ (.Y(FE_PHN83_mem_114_), 
	.A(mem[114]));
   BUFX2 FE_PHC82_mem_14_ (.Y(FE_PHN82_mem_14_), 
	.A(mem[14]));
   BUFX2 FE_PHC81_mem_17_ (.Y(FE_PHN81_mem_17_), 
	.A(mem[17]));
   BUFX2 FE_PHC80_mem_24_ (.Y(FE_PHN80_mem_24_), 
	.A(FE_PHN178_mem_24_));
   BUFX2 FE_PHC79_mem_111_ (.Y(FE_PHN79_mem_111_), 
	.A(FE_PHN243_mem_111_));
   BUFX2 FE_PHC78_mem_1_ (.Y(FE_PHN78_mem_1_), 
	.A(mem[1]));
   BUFX2 FE_PHC77_mem_49_ (.Y(FE_PHN77_mem_49_), 
	.A(mem[49]));
   CLKBUF1 FE_PHC76_n46 (.Y(FE_PHN76_n46), 
	.A(n46));
   CLKBUF1 FE_PHC75_n46 (.Y(FE_PHN75_n46), 
	.A(FE_PHN76_n46));
   CLKBUF1 FE_PHC74_n46 (.Y(FE_PHN74_n46), 
	.A(FE_PHN75_n46));
   BUFX2 FE_PHC73_n49 (.Y(FE_PHN73_n49), 
	.A(FE_PHN62_n49));
   CLKBUF1 FE_PHC72_n46 (.Y(FE_PHN72_n46), 
	.A(FE_PHN74_n46));
   CLKBUF1 FE_PHC71_n49 (.Y(FE_PHN71_n49), 
	.A(FE_PHN73_n49));
   CLKBUF1 FE_PHC70_n46 (.Y(FE_PHN70_n46), 
	.A(FE_PHN72_n46));
   BUFX2 FE_PHC69_n48 (.Y(FE_PHN69_n48), 
	.A(FE_PHN64_n48));
   BUFX2 FE_PHC68_n47 (.Y(FE_PHN68_n47), 
	.A(FE_PHN58_n47));
   CLKBUF1 FE_PHC67_n49 (.Y(FE_PHN67_n49), 
	.A(FE_PHN71_n49));
   CLKBUF1 FE_PHC66_n46 (.Y(FE_PHN66_n46), 
	.A(FE_PHN70_n46));
   BUFX2 FE_PHC65_n50 (.Y(FE_PHN65_n50), 
	.A(FE_PHN55_n50));
   BUFX2 FE_PHC64_n48 (.Y(FE_PHN64_n48), 
	.A(FE_PHN59_n48));
   CLKBUF1 FE_PHC63_n47 (.Y(FE_PHN63_n47), 
	.A(FE_PHN68_n47));
   BUFX2 FE_PHC62_n49 (.Y(FE_PHN62_n49), 
	.A(FE_PHN21_n49));
   CLKBUF1 FE_PHC61_n46 (.Y(FE_PHN61_n46), 
	.A(FE_PHN66_n46));
   BUFX2 FE_PHC60_n50 (.Y(FE_PHN60_n50), 
	.A(FE_PHN12_n50));
   BUFX2 FE_PHC59_n48 (.Y(FE_PHN59_n48), 
	.A(FE_PHN29_n48));
   BUFX2 FE_PHC58_n47 (.Y(FE_PHN58_n47), 
	.A(n47));
   BUFX2 FE_PHC57_n49 (.Y(FE_PHN57_n49), 
	.A(FE_PHN67_n49));
   CLKBUF1 FE_PHC56_n46 (.Y(FE_PHN56_n46), 
	.A(FE_PHN61_n46));
   BUFX2 FE_PHC55_n50 (.Y(FE_PHN55_n50), 
	.A(FE_PHN60_n50));
   BUFX2 FE_PHC54_n48 (.Y(FE_PHN54_n48), 
	.A(FE_PHN69_n48));
   BUFX2 FE_PHC53_n47 (.Y(FE_PHN53_n47), 
	.A(FE_PHN63_n47));
   BUFX2 FE_PHC52_n327 (.Y(FE_PHN52_n327), 
	.A(FE_PHN49_n327));
   CLKBUF2 FE_PHC51_n47 (.Y(n47), 
	.A(FE_PHN51_n47));
   BUFX2 FE_PHC50_n331 (.Y(FE_PHN50_n331), 
	.A(FE_PHN1_n331));
   BUFX2 FE_PHC49_n327 (.Y(FE_PHN49_n327), 
	.A(FE_PHN4_n327));
   BUFX2 FE_PHC48_n330 (.Y(FE_PHN48_n330), 
	.A(FE_PHN20_n330));
   BUFX2 FE_PHC47_n50 (.Y(FE_PHN47_n50), 
	.A(FE_PHN65_n50));
   CLKBUF3 FE_PHC46_n48 (.Y(FE_PHN46_n48), 
	.A(n48));
   CLKBUF3 FE_PHC45_n47 (.Y(FE_PHN45_n47), 
	.A(FE_PHN53_n47));
   BUFX2 FE_PHC44_n331 (.Y(FE_PHN44_n331), 
	.A(FE_PHN50_n331));
   BUFX2 FE_PHC43_n327 (.Y(FE_PHN43_n327), 
	.A(FE_PHN52_n327));
   BUFX2 FE_PHC42_n330 (.Y(FE_PHN42_n330), 
	.A(FE_PHN48_n330));
   CLKBUF2 FE_PHC41_n333 (.Y(FE_PHN41_n333), 
	.A(FE_PHN3_n333));
   CLKBUF3 FE_PHC40_n50 (.Y(FE_PHN40_n50), 
	.A(FE_PHN47_n50));
   CLKBUF2 FE_PHC39_n48 (.Y(FE_PHN39_n48), 
	.A(FE_PHN46_n48));
   CLKBUF3 FE_PHC38_n49 (.Y(FE_PHN38_n49), 
	.A(n49));
   CLKBUF2 FE_PHC37_n47 (.Y(FE_PHN37_n47), 
	.A(FE_PHN45_n47));
   CLKBUF3 FE_PHC36_n46 (.Y(FE_PHN36_n46), 
	.A(FE_PHN56_n46));
   CLKBUF3 FE_PHC35_n331 (.Y(FE_PHN35_n331), 
	.A(FE_PHN44_n331));
   CLKBUF3 FE_PHC34_n327 (.Y(FE_PHN34_n327), 
	.A(FE_PHN43_n327));
   BUFX2 FE_PHC33_n333 (.Y(FE_PHN33_n333), 
	.A(FE_PHN41_n333));
   CLKBUF2 FE_PHC32_n330 (.Y(FE_PHN32_n330), 
	.A(FE_PHN42_n330));
   CLKBUF3 FE_PHC31_wr_ptr_0_ (.Y(FE_PHN31_wr_ptr_0_), 
	.A(FE_PHN2_wr_ptr_0_));
   CLKBUF3 FE_PHC30_n50 (.Y(FE_PHN30_n50), 
	.A(FE_PHN40_n50));
   CLKBUF3 FE_PHC29_n48 (.Y(FE_PHN29_n48), 
	.A(FE_PHN39_n48));
   CLKBUF1 FE_PHC28_n46 (.Y(FE_PHN28_n46), 
	.A(FE_PHN36_n46));
   CLKBUF3 FE_PHC27_n47 (.Y(FE_PHN27_n47), 
	.A(FE_PHN37_n47));
   CLKBUF3 FE_PHC26_n49 (.Y(FE_PHN26_n49), 
	.A(FE_PHN38_n49));
   CLKBUF2 FE_PHC25_n47 (.Y(FE_PHN25_n47), 
	.A(FE_PHN27_n47));
   CLKBUF3 FE_PHC24_n50 (.Y(FE_PHN24_n50), 
	.A(FE_PHN30_n50));
   CLKBUF3 FE_PHC23_n48 (.Y(FE_PHN23_n48), 
	.A(FE_PHN54_n48));
   CLKBUF3 FE_PHC22_n46 (.Y(FE_PHN22_n46), 
	.A(FE_PHN28_n46));
   CLKBUF3 FE_PHC21_n49 (.Y(FE_PHN21_n49), 
	.A(FE_PHN26_n49));
   CLKBUF3 FE_PHC20_n330 (.Y(FE_PHN20_n330), 
	.A(FE_PHN8_n330));
   CLKBUF3 FE_PHC19_n327 (.Y(FE_PHN19_n327), 
	.A(FE_PHN34_n327));
   CLKBUF3 FE_PHC18_n331 (.Y(FE_PHN18_n331), 
	.A(FE_PHN35_n331));
   CLKBUF3 FE_PHC17_n333 (.Y(FE_PHN17_n333), 
	.A(FE_PHN33_n333));
   BUFX2 FE_PHC16_wr_ptr_4_ (.Y(FE_PHN16_wr_ptr_4_), 
	.A(wr_ptr_bin[4]));
   CLKBUF3 FE_PHC15_n332 (.Y(FE_PHN15_n332), 
	.A(FE_PHN5_n332));
   CLKBUF2 FE_PHC14_n56 (.Y(FE_PHN14_n56), 
	.A(FE_PHN0_n56));
   CLKBUF2 FE_PHC13_n48 (.Y(FE_PHN13_n48), 
	.A(FE_PHN23_n48));
   CLKBUF3 FE_PHC12_n50 (.Y(FE_PHN12_n50), 
	.A(n50));
   CLKBUF3 FE_PHC11_n47 (.Y(FE_PHN11_n47), 
	.A(FE_PHN25_n47));
   CLKBUF3 FE_PHC10_n49 (.Y(FE_PHN10_n49), 
	.A(FE_PHN57_n49));
   CLKBUF3 FE_PHC9_n46 (.Y(FE_PHN9_n46), 
	.A(FE_PHN22_n46));
   CLKBUF3 FE_PHC8_n330 (.Y(FE_PHN8_n330), 
	.A(n330));
   BUFX2 FE_PHC7_wr_ptr_4_ (.Y(FE_PHN7_wr_ptr_4_), 
	.A(wr_ptr[4]));
   BUFX2 FE_PHC6_wr_ptr_2_ (.Y(FE_PHN6_wr_ptr_2_), 
	.A(wr_ptr[2]));
   CLKBUF3 FE_PHC5_n332 (.Y(FE_PHN5_n332), 
	.A(n332));
   CLKBUF3 FE_PHC4_n327 (.Y(FE_PHN4_n327), 
	.A(n327));
   CLKBUF3 FE_PHC3_n333 (.Y(FE_PHN3_n333), 
	.A(n333));
   BUFX2 FE_PHC2_wr_ptr_0_ (.Y(FE_PHN2_wr_ptr_0_), 
	.A(wr_ptr[0]));
   CLKBUF3 FE_PHC1_n331 (.Y(FE_PHN1_n331), 
	.A(n331));
   CLKBUF3 FE_PHC0_n56 (.Y(FE_PHN0_n56), 
	.A(n56));
   INVX8 rclk__L2_I0 (.Y(rclk__L2_N0), 
	.A(rclk__L1_N0));
   INVX8 rclk__L1_I0 (.Y(rclk__L1_N0), 
	.A(rclk));
   INVX8 wclk__L2_I1 (.Y(wclk__L2_N1), 
	.A(wclk__L1_N0));
   INVX8 wclk__L2_I0 (.Y(wclk__L2_N0), 
	.A(wclk__L1_N0));
   INVX8 wclk__L1_I0 (.Y(wclk__L1_N0), 
	.A(wclk));
   DFFPOSX1 rd_ptr_reg_0_ (.Q(rd_ptr[0]), 
	.D(n492), 
	.CLK(rclk__L2_N0));
   DFFPOSX1 rd_ptr_s_reg_0_ (.Q(rd_ptr_s[0]), 
	.D(n633), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 rd_ptr_ss_reg_0_ (.Q(rd_ptr_ss[0]), 
	.D(n51), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 FULL_reg (.Q(FULL), 
	.D(n614), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 wr_ptr_reg_4_ (.Q(wr_ptr[4]), 
	.D(n797), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_7__7_ (.Q(mem[63]), 
	.D(n424), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_7__6_ (.Q(mem[62]), 
	.D(n425), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_7__5_ (.Q(mem[61]), 
	.D(n426), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_7__4_ (.Q(mem[60]), 
	.D(n427), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_7__3_ (.Q(mem[59]), 
	.D(n428), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_7__2_ (.Q(mem[58]), 
	.D(n429), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_7__1_ (.Q(mem[57]), 
	.D(n430), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_7__0_ (.Q(mem[56]), 
	.D(n431), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_5__7_ (.Q(mem[47]), 
	.D(n440), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_5__6_ (.Q(mem[46]), 
	.D(n441), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_5__5_ (.Q(mem[45]), 
	.D(n442), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_5__4_ (.Q(mem[44]), 
	.D(n443), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_5__3_ (.Q(mem[43]), 
	.D(n444), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_5__2_ (.Q(mem[42]), 
	.D(n445), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_5__1_ (.Q(mem[41]), 
	.D(n446), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_5__0_ (.Q(mem[40]), 
	.D(n447), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_3__7_ (.Q(mem[31]), 
	.D(n456), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_3__6_ (.Q(mem[30]), 
	.D(n457), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_3__5_ (.Q(mem[29]), 
	.D(n458), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_3__4_ (.Q(mem[28]), 
	.D(n459), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_3__3_ (.Q(mem[27]), 
	.D(n460), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_3__2_ (.Q(mem[26]), 
	.D(n461), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_3__1_ (.Q(mem[25]), 
	.D(n462), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_3__0_ (.Q(mem[24]), 
	.D(n463), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_1__7_ (.Q(mem[15]), 
	.D(n472), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_1__6_ (.Q(mem[14]), 
	.D(n473), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_1__5_ (.Q(mem[13]), 
	.D(n474), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_1__4_ (.Q(mem[12]), 
	.D(n475), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_1__3_ (.Q(mem[11]), 
	.D(n476), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_1__2_ (.Q(mem[10]), 
	.D(n477), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_1__1_ (.Q(mem[9]), 
	.D(n478), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_1__0_ (.Q(mem[8]), 
	.D(n479), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_6__7_ (.Q(mem[55]), 
	.D(n432), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_6__6_ (.Q(mem[54]), 
	.D(n433), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_6__5_ (.Q(mem[53]), 
	.D(n434), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_6__4_ (.Q(mem[52]), 
	.D(n435), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_6__3_ (.Q(mem[51]), 
	.D(n436), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_6__2_ (.Q(mem[50]), 
	.D(n437), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_6__1_ (.Q(mem[49]), 
	.D(n438), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_6__0_ (.Q(mem[48]), 
	.D(n439), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_4__7_ (.Q(mem[39]), 
	.D(n448), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_4__6_ (.Q(mem[38]), 
	.D(n449), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_4__5_ (.Q(mem[37]), 
	.D(n450), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_4__4_ (.Q(mem[36]), 
	.D(n451), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_4__3_ (.Q(mem[35]), 
	.D(n452), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_4__2_ (.Q(mem[34]), 
	.D(n453), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_4__1_ (.Q(mem[33]), 
	.D(n454), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_4__0_ (.Q(mem[32]), 
	.D(n455), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_2__7_ (.Q(mem[23]), 
	.D(n464), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_2__6_ (.Q(mem[22]), 
	.D(n465), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_2__5_ (.Q(mem[21]), 
	.D(n466), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_2__4_ (.Q(mem[20]), 
	.D(n467), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_2__3_ (.Q(mem[19]), 
	.D(n468), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_2__2_ (.Q(mem[18]), 
	.D(n469), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_2__1_ (.Q(mem[17]), 
	.D(n470), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_2__0_ (.Q(mem[16]), 
	.D(n471), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_0__7_ (.Q(mem[7]), 
	.D(n480), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_0__6_ (.Q(mem[6]), 
	.D(n481), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_0__5_ (.Q(mem[5]), 
	.D(n482), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_0__4_ (.Q(mem[4]), 
	.D(n483), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_0__3_ (.Q(mem[3]), 
	.D(n484), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_0__2_ (.Q(mem[2]), 
	.D(n485), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_0__1_ (.Q(mem[1]), 
	.D(n486), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_0__0_ (.Q(mem[0]), 
	.D(n487), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_15__7_ (.Q(mem[127]), 
	.D(n360), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_15__6_ (.Q(mem[126]), 
	.D(n361), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_15__5_ (.Q(mem[125]), 
	.D(n362), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_15__4_ (.Q(mem[124]), 
	.D(n363), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_15__3_ (.Q(mem[123]), 
	.D(n364), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_15__2_ (.Q(mem[122]), 
	.D(n365), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_15__1_ (.Q(mem[121]), 
	.D(n366), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_15__0_ (.Q(mem[120]), 
	.D(n367), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_13__7_ (.Q(mem[111]), 
	.D(n376), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_13__6_ (.Q(mem[110]), 
	.D(n377), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_13__5_ (.Q(mem[109]), 
	.D(n378), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_13__4_ (.Q(mem[108]), 
	.D(n379), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_13__3_ (.Q(mem[107]), 
	.D(n380), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_13__2_ (.Q(mem[106]), 
	.D(n381), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_13__1_ (.Q(mem[105]), 
	.D(n382), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_13__0_ (.Q(mem[104]), 
	.D(n383), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_11__7_ (.Q(mem[95]), 
	.D(n392), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_11__6_ (.Q(mem[94]), 
	.D(n393), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_11__5_ (.Q(mem[93]), 
	.D(n394), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_11__4_ (.Q(mem[92]), 
	.D(n395), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_11__3_ (.Q(mem[91]), 
	.D(n396), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_11__2_ (.Q(mem[90]), 
	.D(n397), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_11__1_ (.Q(mem[89]), 
	.D(n398), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_11__0_ (.Q(mem[88]), 
	.D(n399), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_9__7_ (.Q(mem[79]), 
	.D(n408), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_9__6_ (.Q(mem[78]), 
	.D(n409), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_9__5_ (.Q(mem[77]), 
	.D(n410), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_9__4_ (.Q(mem[76]), 
	.D(n411), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_9__3_ (.Q(mem[75]), 
	.D(n412), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_9__2_ (.Q(mem[74]), 
	.D(n413), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_9__1_ (.Q(mem[73]), 
	.D(n414), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_9__0_ (.Q(mem[72]), 
	.D(n415), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_14__7_ (.Q(mem[119]), 
	.D(n368), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_14__6_ (.Q(mem[118]), 
	.D(n369), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_14__5_ (.Q(mem[117]), 
	.D(n370), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_14__4_ (.Q(mem[116]), 
	.D(n371), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_14__3_ (.Q(mem[115]), 
	.D(n372), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_14__2_ (.Q(mem[114]), 
	.D(n373), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_14__1_ (.Q(mem[113]), 
	.D(n374), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_14__0_ (.Q(mem[112]), 
	.D(n375), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_12__7_ (.Q(mem[103]), 
	.D(n384), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_12__6_ (.Q(mem[102]), 
	.D(n385), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_12__5_ (.Q(mem[101]), 
	.D(n386), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_12__4_ (.Q(mem[100]), 
	.D(n387), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_12__3_ (.Q(mem[99]), 
	.D(n388), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_12__2_ (.Q(mem[98]), 
	.D(n389), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_12__1_ (.Q(mem[97]), 
	.D(n390), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_12__0_ (.Q(mem[96]), 
	.D(n391), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_10__7_ (.Q(mem[87]), 
	.D(n400), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_10__6_ (.Q(mem[86]), 
	.D(n401), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_10__5_ (.Q(mem[85]), 
	.D(n402), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_10__4_ (.Q(mem[84]), 
	.D(n403), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_10__3_ (.Q(mem[83]), 
	.D(n404), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_10__2_ (.Q(mem[82]), 
	.D(n405), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_10__1_ (.Q(mem[81]), 
	.D(n406), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_10__0_ (.Q(mem[80]), 
	.D(n407), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_8__7_ (.Q(mem[71]), 
	.D(n416), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_8__6_ (.Q(mem[70]), 
	.D(n417), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_8__5_ (.Q(mem[69]), 
	.D(n418), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 mem_reg_8__4_ (.Q(mem[68]), 
	.D(n419), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_8__3_ (.Q(mem[67]), 
	.D(n420), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_8__2_ (.Q(mem[66]), 
	.D(n421), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_8__1_ (.Q(mem[65]), 
	.D(n422), 
	.CLK(wclk__L2_N0));
   DFFPOSX1 mem_reg_8__0_ (.Q(mem[64]), 
	.D(n423), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 wr_ptr_reg_0_ (.Q(wr_ptr[0]), 
	.D(n798), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 wr_ptr_s_reg_0_ (.Q(wr_ptr_s[0]), 
	.D(n85), 
	.CLK(rclk__L2_N0));
   DFFPOSX1 wr_ptr_ss_reg_0_ (.Q(wr_ptr_ss[0]), 
	.D(n90), 
	.CLK(rclk__L2_N0));
   DFFPOSX1 wr_ptr_reg_1_ (.Q(wr_ptr[1]), 
	.D(n799), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 wr_ptr_s_reg_1_ (.Q(wr_ptr_s[1]), 
	.D(n86), 
	.CLK(rclk__L2_N0));
   DFFPOSX1 wr_ptr_ss_reg_1_ (.Q(wr_ptr_ss[1]), 
	.D(n91), 
	.CLK(rclk__L2_N0));
   DFFPOSX1 wr_ptr_reg_2_ (.Q(wr_ptr[2]), 
	.D(n800), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 wr_ptr_s_reg_2_ (.Q(wr_ptr_s[2]), 
	.D(n87), 
	.CLK(rclk__L2_N0));
   DFFPOSX1 wr_ptr_ss_reg_2_ (.Q(wr_ptr_ss[2]), 
	.D(n92), 
	.CLK(rclk__L2_N0));
   DFFPOSX1 wr_ptr_reg_3_ (.Q(wr_ptr[3]), 
	.D(n801), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 wr_ptr_s_reg_3_ (.Q(wr_ptr_s[3]), 
	.D(n88), 
	.CLK(rclk__L2_N0));
   DFFPOSX1 wr_ptr_ss_reg_3_ (.Q(wr_ptr_ss[3]), 
	.D(n93), 
	.CLK(rclk__L2_N0));
   DFFPOSX1 wr_ptr_s_reg_4_ (.Q(wr_ptr_s[4]), 
	.D(n89), 
	.CLK(rclk__L2_N0));
   DFFPOSX1 wr_ptr_ss_reg_4_ (.Q(wr_ptr_ss[4]), 
	.D(n94), 
	.CLK(rclk__L2_N0));
   DFFPOSX1 EMPTY_reg (.Q(EMPTY), 
	.D(n95), 
	.CLK(rclk__L2_N0));
   DFFPOSX1 rd_ptr_reg_4_ (.Q(rd_ptr[4]), 
	.D(n491), 
	.CLK(rclk__L2_N0));
   DFFPOSX1 rd_ptr_reg_1_ (.Q(rd_ptr[1]), 
	.D(n490), 
	.CLK(rclk__L2_N0));
   DFFPOSX1 rd_ptr_s_reg_1_ (.Q(rd_ptr_s[1]), 
	.D(n634), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 rd_ptr_ss_reg_1_ (.Q(rd_ptr_ss[1]), 
	.D(n52), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 rd_ptr_reg_2_ (.Q(rd_ptr[2]), 
	.D(n489), 
	.CLK(rclk__L2_N0));
   DFFPOSX1 rd_ptr_s_reg_2_ (.Q(rd_ptr_s[2]), 
	.D(n635), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 rd_ptr_ss_reg_2_ (.Q(rd_ptr_ss[2]), 
	.D(n53), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 rd_ptr_reg_3_ (.Q(rd_ptr[3]), 
	.D(n488), 
	.CLK(rclk__L2_N0));
   DFFPOSX1 rd_ptr_s_reg_3_ (.Q(rd_ptr_s[3]), 
	.D(n636), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 rd_ptr_ss_reg_3_ (.Q(rd_ptr_ss[3]), 
	.D(n54), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 rd_ptr_s_reg_4_ (.Q(rd_ptr_s[4]), 
	.D(n637), 
	.CLK(wclk__L2_N1));
   DFFPOSX1 rd_ptr_ss_reg_4_ (.Q(rd_ptr_ss[4]), 
	.D(n55), 
	.CLK(wclk__L2_N1));
   OAI21X1 U64 (.Y(n360), 
	.C(n638), 
	.B(n803), 
	.A(n172));
   OAI21X1 U66 (.Y(n361), 
	.C(n616), 
	.B(n804), 
	.A(n172));
   OAI21X1 U68 (.Y(n362), 
	.C(n605), 
	.B(n805), 
	.A(n172));
   OAI21X1 U70 (.Y(n363), 
	.C(n596), 
	.B(n806), 
	.A(n172));
   OAI21X1 U72 (.Y(n364), 
	.C(n587), 
	.B(n807), 
	.A(n172));
   OAI21X1 U74 (.Y(n365), 
	.C(n579), 
	.B(n808), 
	.A(n172));
   OAI21X1 U76 (.Y(n366), 
	.C(n570), 
	.B(n809), 
	.A(n172));
   OAI21X1 U78 (.Y(n367), 
	.C(n562), 
	.B(n810), 
	.A(n172));
   OAI21X1 U81 (.Y(n368), 
	.C(n591), 
	.B(n183), 
	.A(n803));
   OAI21X1 U83 (.Y(n369), 
	.C(n583), 
	.B(n183), 
	.A(n804));
   OAI21X1 U85 (.Y(n370), 
	.C(n574), 
	.B(n183), 
	.A(n805));
   OAI21X1 U87 (.Y(n371), 
	.C(n566), 
	.B(n183), 
	.A(n806));
   OAI21X1 U89 (.Y(n372), 
	.C(n642), 
	.B(n183), 
	.A(n807));
   OAI21X1 U91 (.Y(n373), 
	.C(n620), 
	.B(n183), 
	.A(n808));
   OAI21X1 U93 (.Y(n374), 
	.C(n609), 
	.B(n183), 
	.A(n809));
   OAI21X1 U95 (.Y(n375), 
	.C(n600), 
	.B(n183), 
	.A(n810));
   OAI21X1 U98 (.Y(n376), 
	.C(n617), 
	.B(n193), 
	.A(n803));
   OAI21X1 U100 (.Y(n377), 
	.C(n639), 
	.B(n193), 
	.A(n804));
   OAI21X1 U102 (.Y(n378), 
	.C(n597), 
	.B(n193), 
	.A(n805));
   OAI21X1 U104 (.Y(n379), 
	.C(n606), 
	.B(n193), 
	.A(n806));
   OAI21X1 U106 (.Y(n380), 
	.C(n580), 
	.B(n193), 
	.A(n807));
   OAI21X1 U108 (.Y(n381), 
	.C(n588), 
	.B(n193), 
	.A(n808));
   OAI21X1 U110 (.Y(n382), 
	.C(n563), 
	.B(n193), 
	.A(n809));
   OAI21X1 U112 (.Y(n383), 
	.C(n571), 
	.B(n193), 
	.A(n810));
   OAI21X1 U115 (.Y(n384), 
	.C(n584), 
	.B(n203), 
	.A(n803));
   OAI21X1 U117 (.Y(n385), 
	.C(n592), 
	.B(n203), 
	.A(n804));
   OAI21X1 U119 (.Y(n386), 
	.C(n567), 
	.B(n203), 
	.A(n805));
   OAI21X1 U121 (.Y(n387), 
	.C(n575), 
	.B(n203), 
	.A(n806));
   OAI21X1 U123 (.Y(n388), 
	.C(n621), 
	.B(n203), 
	.A(n807));
   OAI21X1 U125 (.Y(n389), 
	.C(n643), 
	.B(n203), 
	.A(n808));
   OAI21X1 U127 (.Y(n390), 
	.C(n601), 
	.B(n203), 
	.A(n809));
   OAI21X1 U129 (.Y(n391), 
	.C(n610), 
	.B(n203), 
	.A(n810));
   OAI21X1 U132 (.Y(n392), 
	.C(n607), 
	.B(n212), 
	.A(n803));
   OAI21X1 U134 (.Y(n393), 
	.C(n598), 
	.B(n212), 
	.A(n804));
   OAI21X1 U136 (.Y(n394), 
	.C(n640), 
	.B(n212), 
	.A(n805));
   OAI21X1 U138 (.Y(n395), 
	.C(n618), 
	.B(n212), 
	.A(n806));
   OAI21X1 U140 (.Y(n396), 
	.C(n572), 
	.B(n212), 
	.A(n807));
   OAI21X1 U142 (.Y(n397), 
	.C(n564), 
	.B(n212), 
	.A(n808));
   OAI21X1 U144 (.Y(n398), 
	.C(n589), 
	.B(n212), 
	.A(n809));
   OAI21X1 U146 (.Y(n399), 
	.C(n581), 
	.B(n212), 
	.A(n810));
   OAI21X1 U149 (.Y(n400), 
	.C(n576), 
	.B(n222), 
	.A(n803));
   OAI21X1 U151 (.Y(n401), 
	.C(n568), 
	.B(n222), 
	.A(n804));
   OAI21X1 U153 (.Y(n402), 
	.C(n593), 
	.B(n222), 
	.A(n805));
   OAI21X1 U155 (.Y(n403), 
	.C(n585), 
	.B(n222), 
	.A(n806));
   OAI21X1 U157 (.Y(n404), 
	.C(n611), 
	.B(n222), 
	.A(n807));
   OAI21X1 U159 (.Y(n405), 
	.C(n602), 
	.B(n222), 
	.A(n808));
   OAI21X1 U161 (.Y(n406), 
	.C(n644), 
	.B(n222), 
	.A(n809));
   OAI21X1 U163 (.Y(n407), 
	.C(n622), 
	.B(n222), 
	.A(n810));
   OAI21X1 U166 (.Y(n408), 
	.C(n599), 
	.B(n231), 
	.A(n803));
   OAI21X1 U168 (.Y(n409), 
	.C(n608), 
	.B(n231), 
	.A(n804));
   OAI21X1 U170 (.Y(n410), 
	.C(n619), 
	.B(n231), 
	.A(n805));
   OAI21X1 U172 (.Y(n411), 
	.C(n641), 
	.B(n231), 
	.A(n806));
   OAI21X1 U174 (.Y(n412), 
	.C(n565), 
	.B(n231), 
	.A(n807));
   OAI21X1 U176 (.Y(n413), 
	.C(n573), 
	.B(n231), 
	.A(n808));
   OAI21X1 U178 (.Y(n414), 
	.C(n582), 
	.B(n231), 
	.A(n809));
   OAI21X1 U180 (.Y(n415), 
	.C(n590), 
	.B(n231), 
	.A(n810));
   OAI21X1 U183 (.Y(n416), 
	.C(n569), 
	.B(n242), 
	.A(n803));
   OAI21X1 U185 (.Y(n417), 
	.C(n577), 
	.B(n242), 
	.A(n804));
   OAI21X1 U187 (.Y(n418), 
	.C(n586), 
	.B(n242), 
	.A(n805));
   OAI21X1 U189 (.Y(n419), 
	.C(n594), 
	.B(n242), 
	.A(n806));
   OAI21X1 U191 (.Y(n420), 
	.C(n603), 
	.B(n242), 
	.A(n807));
   OAI21X1 U193 (.Y(n421), 
	.C(n612), 
	.B(n242), 
	.A(n808));
   OAI21X1 U195 (.Y(n422), 
	.C(n623), 
	.B(n242), 
	.A(n809));
   OAI21X1 U197 (.Y(n423), 
	.C(n645), 
	.B(n242), 
	.A(n810));
   OAI21X1 U200 (.Y(n424), 
	.C(n554), 
	.B(n252), 
	.A(n803));
   OAI21X1 U202 (.Y(n425), 
	.C(n553), 
	.B(n252), 
	.A(n804));
   OAI21X1 U204 (.Y(n426), 
	.C(n552), 
	.B(n252), 
	.A(n805));
   OAI21X1 U206 (.Y(n427), 
	.C(n551), 
	.B(n252), 
	.A(n806));
   OAI21X1 U208 (.Y(n428), 
	.C(n550), 
	.B(n252), 
	.A(n807));
   OAI21X1 U210 (.Y(n429), 
	.C(n549), 
	.B(n252), 
	.A(n808));
   OAI21X1 U212 (.Y(n430), 
	.C(n548), 
	.B(n252), 
	.A(n809));
   OAI21X1 U214 (.Y(n431), 
	.C(n547), 
	.B(n252), 
	.A(n810));
   OAI21X1 U217 (.Y(n432), 
	.C(n546), 
	.B(n262), 
	.A(n803));
   OAI21X1 U219 (.Y(n433), 
	.C(n545), 
	.B(n262), 
	.A(n804));
   OAI21X1 U221 (.Y(n434), 
	.C(n544), 
	.B(n262), 
	.A(n805));
   OAI21X1 U223 (.Y(n435), 
	.C(n543), 
	.B(n262), 
	.A(n806));
   OAI21X1 U225 (.Y(n436), 
	.C(n558), 
	.B(n262), 
	.A(n807));
   OAI21X1 U227 (.Y(n437), 
	.C(n542), 
	.B(n262), 
	.A(n808));
   OAI21X1 U229 (.Y(n438), 
	.C(n541), 
	.B(n262), 
	.A(n809));
   OAI21X1 U231 (.Y(n439), 
	.C(n540), 
	.B(n262), 
	.A(n810));
   OAI21X1 U234 (.Y(n440), 
	.C(n539), 
	.B(n272), 
	.A(n803));
   OAI21X1 U236 (.Y(n441), 
	.C(n555), 
	.B(n272), 
	.A(n804));
   OAI21X1 U238 (.Y(n442), 
	.C(n538), 
	.B(n272), 
	.A(n805));
   OAI21X1 U240 (.Y(n443), 
	.C(FE_PHN162_n537), 
	.B(n272), 
	.A(n806));
   OAI21X1 U242 (.Y(n444), 
	.C(n536), 
	.B(n272), 
	.A(n807));
   OAI21X1 U244 (.Y(n445), 
	.C(n535), 
	.B(n272), 
	.A(n808));
   OAI21X1 U246 (.Y(n446), 
	.C(n534), 
	.B(n272), 
	.A(n809));
   OAI21X1 U248 (.Y(n447), 
	.C(n533), 
	.B(n272), 
	.A(n810));
   OAI21X1 U251 (.Y(n448), 
	.C(n532), 
	.B(n281), 
	.A(n803));
   OAI21X1 U253 (.Y(n449), 
	.C(n531), 
	.B(n281), 
	.A(n804));
   OAI21X1 U255 (.Y(n450), 
	.C(n530), 
	.B(n281), 
	.A(n805));
   OAI21X1 U257 (.Y(n451), 
	.C(n529), 
	.B(n281), 
	.A(n806));
   OAI21X1 U259 (.Y(n452), 
	.C(n528), 
	.B(n281), 
	.A(n807));
   OAI21X1 U261 (.Y(n453), 
	.C(n559), 
	.B(n281), 
	.A(n808));
   OAI21X1 U263 (.Y(n454), 
	.C(n527), 
	.B(n281), 
	.A(n809));
   OAI21X1 U265 (.Y(n455), 
	.C(n526), 
	.B(n281), 
	.A(n810));
   OAI21X1 U268 (.Y(n456), 
	.C(n525), 
	.B(n290), 
	.A(n803));
   OAI21X1 U270 (.Y(n457), 
	.C(n524), 
	.B(n290), 
	.A(n804));
   OAI21X1 U272 (.Y(n458), 
	.C(n556), 
	.B(n290), 
	.A(n805));
   OAI21X1 U274 (.Y(n459), 
	.C(n523), 
	.B(n290), 
	.A(n806));
   OAI21X1 U276 (.Y(n460), 
	.C(n522), 
	.B(n290), 
	.A(n807));
   OAI21X1 U278 (.Y(n461), 
	.C(n521), 
	.B(n290), 
	.A(n808));
   OAI21X1 U280 (.Y(n462), 
	.C(n520), 
	.B(n290), 
	.A(n809));
   OAI21X1 U282 (.Y(n463), 
	.C(n519), 
	.B(n290), 
	.A(n810));
   OAI21X1 U285 (.Y(n464), 
	.C(n518), 
	.B(n299), 
	.A(n803));
   OAI21X1 U287 (.Y(n465), 
	.C(n517), 
	.B(n299), 
	.A(n804));
   OAI21X1 U289 (.Y(n466), 
	.C(n516), 
	.B(n299), 
	.A(n805));
   OAI21X1 U291 (.Y(n467), 
	.C(n515), 
	.B(n299), 
	.A(n806));
   OAI21X1 U293 (.Y(n468), 
	.C(n514), 
	.B(n299), 
	.A(n807));
   OAI21X1 U295 (.Y(n469), 
	.C(n513), 
	.B(n299), 
	.A(n808));
   OAI21X1 U297 (.Y(n470), 
	.C(n560), 
	.B(n299), 
	.A(n809));
   OAI21X1 U299 (.Y(n471), 
	.C(n512), 
	.B(n299), 
	.A(n810));
   OAI21X1 U303 (.Y(n472), 
	.C(n511), 
	.B(n308), 
	.A(n803));
   OAI21X1 U305 (.Y(n473), 
	.C(n510), 
	.B(n308), 
	.A(n804));
   OAI21X1 U307 (.Y(n474), 
	.C(n509), 
	.B(n308), 
	.A(n805));
   OAI21X1 U309 (.Y(n475), 
	.C(n557), 
	.B(n308), 
	.A(n806));
   OAI21X1 U311 (.Y(n476), 
	.C(n508), 
	.B(n308), 
	.A(n807));
   OAI21X1 U313 (.Y(n477), 
	.C(n507), 
	.B(n308), 
	.A(n808));
   OAI21X1 U315 (.Y(n478), 
	.C(n506), 
	.B(n308), 
	.A(n809));
   OAI21X1 U317 (.Y(n479), 
	.C(n505), 
	.B(n308), 
	.A(n810));
   OAI21X1 U320 (.Y(n480), 
	.C(n504), 
	.B(n318), 
	.A(n803));
   OAI21X1 U322 (.Y(n481), 
	.C(n503), 
	.B(n318), 
	.A(n804));
   OAI21X1 U324 (.Y(n482), 
	.C(n502), 
	.B(n318), 
	.A(n805));
   OAI21X1 U326 (.Y(n483), 
	.C(n501), 
	.B(n318), 
	.A(n806));
   OAI21X1 U328 (.Y(n484), 
	.C(n500), 
	.B(n318), 
	.A(n807));
   OAI21X1 U330 (.Y(n485), 
	.C(n499), 
	.B(n318), 
	.A(n808));
   OAI21X1 U332 (.Y(n486), 
	.C(n498), 
	.B(n318), 
	.A(n809));
   OAI21X1 U334 (.Y(n487), 
	.C(n561), 
	.B(n318), 
	.A(n810));
   AOI22X1 U338 (.Y(n327), 
	.D(n329), 
	.C(wr_ptr[3]), 
	.B(n648), 
	.A(wr_ptr_p1[3]));
   AOI22X1 U339 (.Y(n330), 
	.D(n329), 
	.C(FE_PHN6_wr_ptr_2_), 
	.B(n648), 
	.A(wr_ptr_p1[2]));
   AOI22X1 U340 (.Y(n331), 
	.D(n329), 
	.C(wr_ptr[1]), 
	.B(n648), 
	.A(wr_ptr_p1[1]));
   AOI22X1 U341 (.Y(n332), 
	.D(n329), 
	.C(FE_PHN31_wr_ptr_0_), 
	.B(n648), 
	.A(wr_ptr_p1[0]));
   AOI22X1 U342 (.Y(n333), 
	.D(n329), 
	.C(FE_PHN7_wr_ptr_4_), 
	.B(n648), 
	.A(wr_ptr_p1[4]));
   OAI21X1 U344 (.Y(n488), 
	.C(n624), 
	.B(n819), 
	.A(n649));
   OAI21X1 U346 (.Y(n489), 
	.C(n613), 
	.B(n818), 
	.A(n649));
   OAI21X1 U348 (.Y(n490), 
	.C(n604), 
	.B(n817), 
	.A(n649));
   OAI21X1 U350 (.Y(n491), 
	.C(n595), 
	.B(n816), 
	.A(n649));
   OAI21X1 U352 (.Y(n492), 
	.C(n578), 
	.B(n811), 
	.A(n649));
   OAI21X1 U355 (.Y(n95), 
	.C(n344), 
	.B(n343), 
	.A(n342));
   AOI21X1 U356 (.Y(n344), 
	.C(reset), 
	.B(n346), 
	.A(n345));
   NOR3X1 U357 (.Y(n346), 
	.C(n348), 
	.B(n788), 
	.A(n347));
   XOR2X1 U358 (.Y(n348), 
	.B(rd_ptr[0]), 
	.A(wr_ptr_ss[0]));
   XOR2X1 U359 (.Y(n347), 
	.B(rd_ptr[2]), 
	.A(wr_ptr_ss[2]));
   NOR3X1 U360 (.Y(n345), 
	.C(n351), 
	.B(n350), 
	.A(n349));
   XOR2X1 U361 (.Y(n351), 
	.B(rd_ptr[3]), 
	.A(wr_ptr_ss[3]));
   XOR2X1 U362 (.Y(n350), 
	.B(rd_ptr[4]), 
	.A(wr_ptr_ss[4]));
   XOR2X1 U363 (.Y(n349), 
	.B(rd_ptr[1]), 
	.A(wr_ptr_ss[1]));
   NAND3X1 U364 (.Y(n343), 
	.C(n354), 
	.B(n353), 
	.A(n352));
   XNOR2X1 U365 (.Y(n354), 
	.B(rd_ptr_bin_p1[1]), 
	.A(wr_ptr_ss_bin[1]));
   XNOR2X1 U366 (.Y(n353), 
	.B(rd_ptr_bin_p1[4]), 
	.A(wr_ptr_ss_bin[4]));
   XNOR2X1 U367 (.Y(n352), 
	.B(rd_ptr_bin_p1[3]), 
	.A(wr_ptr_ss_bin[3]));
   NAND3X1 U368 (.Y(n342), 
	.C(n356), 
	.B(n788), 
	.A(n355));
   XNOR2X1 U369 (.Y(n356), 
	.B(rd_ptr_bin_p1[2]), 
	.A(wr_ptr_ss_bin[2]));
   XNOR2X1 U370 (.Y(n355), 
	.B(n789), 
	.A(wr_ptr_ss_bin[0]));
   OAI21X1 U372 (.Y(n358), 
	.C(n646), 
	.B(n21), 
	.A(n20));
   gray2bin_SIZE5_3 gb1 (.gray({ rd_ptr_ss[4],
		rd_ptr_ss[3],
		rd_ptr_ss[2],
		rd_ptr_ss[1],
		rd_ptr_ss[0] }), 
	.bin({ rd_ptr_ss_bin[4],
		rd_ptr_ss_bin[3],
		rd_ptr_ss_bin[2],
		rd_ptr_ss_bin[1],
		rd_ptr_ss_bin[0] }));
   gray2bin_SIZE5_2 gb2 (.gray({ wr_ptr_ss[4],
		wr_ptr_ss[3],
		wr_ptr_ss[2],
		wr_ptr_ss[1],
		wr_ptr_ss[0] }), 
	.bin({ wr_ptr_ss_bin[4],
		wr_ptr_ss_bin[3],
		wr_ptr_ss_bin[2],
		wr_ptr_ss_bin[1],
		wr_ptr_ss_bin[0] }));
   gray2bin_SIZE5_1 gb3 (.gray({ rd_ptr[4],
		rd_ptr[3],
		rd_ptr[2],
		rd_ptr[1],
		rd_ptr[0] }), 
	.bin({ rd_ptr_bin_4_,
		n17,
		n16,
		n15,
		n14 }));
   gray2bin_SIZE5_0 gb4 (.gray({ wr_ptr[4],
		wr_ptr[3],
		wr_ptr[2],
		wr_ptr[1],
		wr_ptr[0] }), 
	.bin({ wr_ptr_bin[4],
		wr_ptr_bin[3],
		wr_ptr_bin[2],
		wr_ptr_bin[1],
		wr_ptr_bin[0] }));
   bin2gray_SIZE5_1 bg1 (.bin({ wr_ptr_bin_p1[4],
		wr_ptr_bin_p1[3],
		wr_ptr_bin_p1[2],
		wr_ptr_bin_p1[1],
		wr_ptr_bin_p1[0] }), 
	.gray({ wr_ptr_p1[4],
		wr_ptr_p1[3],
		wr_ptr_p1[2],
		wr_ptr_p1[1],
		wr_ptr_p1[0] }));
   bin2gray_SIZE5_0 bg2 (.bin({ rd_ptr_bin_p1[4],
		rd_ptr_bin_p1[3],
		rd_ptr_bin_p1[2],
		rd_ptr_bin_p1[1],
		n789 }), 
	.gray({ rd_ptr_p1[4],
		rd_ptr_p1[3],
		rd_ptr_p1[2],
		rd_ptr_p1[1],
		rd_ptr_p1[0] }));
   HAX1 add_55_U1_1_4 (.YS(n20), 
	.YC(n21), 
	.B(n628), 
	.A(diff[4]));
   FAX1 sub_38_U2_1 (.YS(diff[1]), 
	.YC(sub_38_carry[2]), 
	.C(sub_38_carry[1]), 
	.B(n793), 
	.A(wr_ptr_bin[1]));
   FAX1 sub_38_U2_2 (.YS(diff[2]), 
	.YC(sub_38_carry[3]), 
	.C(sub_38_carry[2]), 
	.B(n792), 
	.A(wr_ptr_bin[2]));
   FAX1 sub_38_U2_3 (.YS(diff[3]), 
	.YC(sub_38_carry[4]), 
	.C(sub_38_carry[3]), 
	.B(n791), 
	.A(wr_ptr_bin[3]));
   FAX1 sub_38_U2_4 (.YS(diff[4]), 
	.YC(), 
	.C(sub_38_carry[4]), 
	.B(n790), 
	.A(wr_ptr_bin[4]));
   HAX1 add_35_U1_1_1 (.YS(rd_ptr_bin_p1[1]), 
	.YC(add_35_carry[2]), 
	.B(n778), 
	.A(n15));
   HAX1 add_35_U1_1_2 (.YS(rd_ptr_bin_p1[2]), 
	.YC(add_35_carry[3]), 
	.B(add_35_carry[2]), 
	.A(n16));
   HAX1 add_35_U1_1_3 (.YS(rd_ptr_bin_p1[3]), 
	.YC(add_35_carry[4]), 
	.B(add_35_carry[3]), 
	.A(n17));
   HAX1 add_34_U1_1_1 (.YS(wr_ptr_bin_p1[1]), 
	.YC(add_34_carry[2]), 
	.B(wr_ptr_bin[0]), 
	.A(wr_ptr_bin[1]));
   HAX1 add_34_U1_1_2 (.YS(wr_ptr_bin_p1[2]), 
	.YC(add_34_carry[3]), 
	.B(add_34_carry[2]), 
	.A(wr_ptr_bin[2]));
   HAX1 add_34_U1_1_3 (.YS(wr_ptr_bin_p1[3]), 
	.YC(add_34_carry[4]), 
	.B(add_34_carry[3]), 
	.A(wr_ptr_bin[3]));
   HAX1 add_34_U1_1_4 (.YS(wr_ptr_bin_p1[4]), 
	.YC(), 
	.B(add_34_carry[4]), 
	.A(FE_PHN16_wr_ptr_4_));
   AND2X1 U382 (.Y(n241), 
	.B(n646), 
	.A(wr_ptr_bin[3]));
   AND2X1 U383 (.Y(n317), 
	.B(n813), 
	.A(n646));
   OR2X1 U384 (.Y(n251), 
	.B(reset), 
	.A(n631));
   OR2X1 U385 (.Y(add_55_carry_4_), 
	.B(n630), 
	.A(n629));
   AND2X1 U386 (.Y(n650), 
	.B(n192), 
	.A(n647));
   AND2X1 U387 (.Y(n651), 
	.B(n192), 
	.A(n632));
   AND2X1 U388 (.Y(n653), 
	.B(n182), 
	.A(n647));
   AND2X1 U389 (.Y(n654), 
	.B(n182), 
	.A(n632));
   AND2X1 U390 (.Y(n656), 
	.B(n647), 
	.A(n271));
   AND2X1 U391 (.Y(n657), 
	.B(n632), 
	.A(n271));
   AND2X1 U392 (.Y(n659), 
	.B(n647), 
	.A(n261));
   AND2X1 U393 (.Y(n660), 
	.B(n632), 
	.A(n261));
   AND2X1 U394 (.Y(n56), 
	.B(n358), 
	.A(n615));
   AND2X1 U400 (.Y(n325), 
	.B(n318), 
	.A(FE_PHN78_mem_1_));
   INVX1 U401 (.Y(n498), 
	.A(n325));
   AND2X1 U402 (.Y(n324), 
	.B(n318), 
	.A(FE_PHN147_mem_2_));
   INVX1 U403 (.Y(n499), 
	.A(n324));
   AND2X1 U404 (.Y(n323), 
	.B(n318), 
	.A(FE_PHN239_mem_3_));
   INVX1 U405 (.Y(n500), 
	.A(n323));
   AND2X1 U406 (.Y(n322), 
	.B(n318), 
	.A(FE_PHN237_mem_4_));
   INVX1 U407 (.Y(n501), 
	.A(n322));
   AND2X1 U408 (.Y(n321), 
	.B(n318), 
	.A(FE_PHN185_mem_5_));
   INVX1 U409 (.Y(n502), 
	.A(n321));
   AND2X1 U410 (.Y(n320), 
	.B(n318), 
	.A(FE_PHN202_mem_6_));
   INVX1 U411 (.Y(n503), 
	.A(n320));
   AND2X1 U412 (.Y(n319), 
	.B(n318), 
	.A(FE_PHN191_mem_7_));
   INVX1 U413 (.Y(n504), 
	.A(n319));
   AND2X1 U414 (.Y(n316), 
	.B(n308), 
	.A(FE_PHN164_mem_8_));
   INVX1 U415 (.Y(n505), 
	.A(n316));
   AND2X1 U416 (.Y(n315), 
	.B(n308), 
	.A(FE_PHN148_mem_9_));
   INVX1 U417 (.Y(n506), 
	.A(n315));
   AND2X1 U418 (.Y(n314), 
	.B(n308), 
	.A(FE_PHN160_mem_10_));
   INVX1 U419 (.Y(n507), 
	.A(n314));
   AND2X1 U420 (.Y(n313), 
	.B(n308), 
	.A(FE_PHN242_mem_11_));
   INVX1 U421 (.Y(n508), 
	.A(n313));
   AND2X1 U422 (.Y(n311), 
	.B(n308), 
	.A(FE_PHN209_mem_13_));
   INVX1 U423 (.Y(n509), 
	.A(n311));
   AND2X1 U424 (.Y(n310), 
	.B(n308), 
	.A(FE_PHN182_mem_14_));
   INVX1 U425 (.Y(n510), 
	.A(n310));
   AND2X1 U426 (.Y(n309), 
	.B(n308), 
	.A(FE_PHN121_mem_15_));
   INVX1 U427 (.Y(n511), 
	.A(n309));
   AND2X1 U428 (.Y(n307), 
	.B(n299), 
	.A(FE_PHN192_mem_16_));
   INVX1 U429 (.Y(n512), 
	.A(n307));
   AND2X1 U430 (.Y(n305), 
	.B(n299), 
	.A(FE_PHN130_mem_18_));
   INVX1 U431 (.Y(n513), 
	.A(n305));
   AND2X1 U432 (.Y(n304), 
	.B(n299), 
	.A(FE_PHN186_mem_19_));
   INVX1 U433 (.Y(n514), 
	.A(n304));
   AND2X1 U434 (.Y(n303), 
	.B(n299), 
	.A(FE_PHN258_mem_20_));
   INVX1 U435 (.Y(n515), 
	.A(n303));
   AND2X1 U436 (.Y(n302), 
	.B(n299), 
	.A(FE_PHN194_mem_21_));
   INVX1 U437 (.Y(n516), 
	.A(n302));
   AND2X1 U438 (.Y(n301), 
	.B(n299), 
	.A(FE_PHN170_mem_22_));
   INVX1 U439 (.Y(n517), 
	.A(n301));
   AND2X1 U440 (.Y(n300), 
	.B(n299), 
	.A(FE_PHN251_mem_23_));
   INVX1 U441 (.Y(n518), 
	.A(n300));
   AND2X1 U442 (.Y(n298), 
	.B(n290), 
	.A(FE_PHN80_mem_24_));
   INVX1 U443 (.Y(n519), 
	.A(n298));
   AND2X1 U444 (.Y(n297), 
	.B(n290), 
	.A(FE_PHN197_mem_25_));
   INVX1 U445 (.Y(n520), 
	.A(n297));
   AND2X1 U446 (.Y(n296), 
	.B(n290), 
	.A(FE_PHN159_mem_26_));
   INVX1 U447 (.Y(n521), 
	.A(n296));
   AND2X1 U448 (.Y(n295), 
	.B(n290), 
	.A(FE_PHN107_mem_27_));
   INVX1 U449 (.Y(n522), 
	.A(n295));
   AND2X1 U450 (.Y(n294), 
	.B(n290), 
	.A(FE_PHN226_mem_28_));
   INVX1 U451 (.Y(n523), 
	.A(n294));
   AND2X1 U452 (.Y(n292), 
	.B(n290), 
	.A(FE_PHN215_mem_30_));
   INVX1 U453 (.Y(n524), 
	.A(n292));
   AND2X1 U454 (.Y(n291), 
	.B(n290), 
	.A(FE_PHN113_mem_31_));
   INVX1 U455 (.Y(n525), 
	.A(n291));
   AND2X1 U456 (.Y(n289), 
	.B(n281), 
	.A(FE_PHN184_mem_32_));
   INVX1 U457 (.Y(n526), 
	.A(n289));
   AND2X1 U458 (.Y(n288), 
	.B(n281), 
	.A(FE_PHN134_mem_33_));
   INVX1 U459 (.Y(n527), 
	.A(n288));
   AND2X1 U460 (.Y(n286), 
	.B(n281), 
	.A(FE_PHN85_mem_35_));
   INVX1 U461 (.Y(n528), 
	.A(n286));
   AND2X1 U462 (.Y(n285), 
	.B(n281), 
	.A(FE_PHN261_mem_36_));
   INVX1 U463 (.Y(n529), 
	.A(n285));
   AND2X1 U464 (.Y(n284), 
	.B(n281), 
	.A(FE_PHN119_mem_37_));
   INVX1 U465 (.Y(n530), 
	.A(n284));
   AND2X1 U466 (.Y(n283), 
	.B(n281), 
	.A(FE_PHN91_mem_38_));
   INVX1 U467 (.Y(n531), 
	.A(n283));
   AND2X1 U468 (.Y(n282), 
	.B(n281), 
	.A(FE_PHN106_mem_39_));
   INVX1 U469 (.Y(n532), 
	.A(n282));
   AND2X1 U470 (.Y(n280), 
	.B(n272), 
	.A(FE_PHN203_mem_40_));
   INVX1 U471 (.Y(n533), 
	.A(n280));
   AND2X1 U472 (.Y(n279), 
	.B(n272), 
	.A(FE_PHN88_mem_41_));
   INVX1 U473 (.Y(n534), 
	.A(n279));
   AND2X1 U474 (.Y(n278), 
	.B(n272), 
	.A(FE_PHN210_mem_42_));
   INVX1 U475 (.Y(n535), 
	.A(n278));
   AND2X1 U476 (.Y(n277), 
	.B(n272), 
	.A(FE_PHN129_mem_43_));
   INVX1 U477 (.Y(n536), 
	.A(n277));
   AND2X1 U478 (.Y(n276), 
	.B(n272), 
	.A(FE_PHN171_mem_44_));
   INVX1 U479 (.Y(n537), 
	.A(n276));
   AND2X1 U480 (.Y(n275), 
	.B(n272), 
	.A(FE_PHN137_mem_45_));
   INVX1 U481 (.Y(n538), 
	.A(n275));
   AND2X1 U482 (.Y(n273), 
	.B(n272), 
	.A(FE_PHN95_mem_47_));
   INVX1 U483 (.Y(n539), 
	.A(n273));
   AND2X1 U484 (.Y(n270), 
	.B(n262), 
	.A(FE_PHN183_mem_48_));
   INVX1 U485 (.Y(n540), 
	.A(n270));
   AND2X1 U486 (.Y(n269), 
	.B(n262), 
	.A(FE_PHN256_mem_49_));
   INVX1 U487 (.Y(n541), 
	.A(n269));
   AND2X1 U488 (.Y(n268), 
	.B(n262), 
	.A(FE_PHN115_mem_50_));
   INVX1 U489 (.Y(n542), 
	.A(n268));
   AND2X1 U490 (.Y(n266), 
	.B(n262), 
	.A(FE_PHN238_mem_52_));
   INVX1 U491 (.Y(n543), 
	.A(n266));
   AND2X1 U492 (.Y(n265), 
	.B(n262), 
	.A(mem[53]));
   INVX1 U493 (.Y(n544), 
	.A(n265));
   AND2X1 U494 (.Y(n264), 
	.B(n262), 
	.A(FE_PHN207_mem_54_));
   INVX1 U495 (.Y(n545), 
	.A(n264));
   AND2X1 U496 (.Y(n263), 
	.B(n262), 
	.A(mem[55]));
   INVX1 U497 (.Y(n546), 
	.A(n263));
   AND2X1 U498 (.Y(n260), 
	.B(n252), 
	.A(FE_PHN123_mem_56_));
   INVX1 U499 (.Y(n547), 
	.A(n260));
   AND2X1 U500 (.Y(n259), 
	.B(n252), 
	.A(FE_PHN125_mem_57_));
   INVX1 U501 (.Y(n548), 
	.A(n259));
   AND2X1 U502 (.Y(n258), 
	.B(n252), 
	.A(FE_PHN114_mem_58_));
   INVX1 U503 (.Y(n549), 
	.A(n258));
   AND2X1 U504 (.Y(n257), 
	.B(n252), 
	.A(FE_PHN143_mem_59_));
   INVX1 U505 (.Y(n550), 
	.A(n257));
   AND2X1 U506 (.Y(n256), 
	.B(n252), 
	.A(FE_PHN229_mem_60_));
   INVX1 U507 (.Y(n551), 
	.A(n256));
   AND2X1 U508 (.Y(n255), 
	.B(n252), 
	.A(FE_PHN253_mem_61_));
   INVX1 U509 (.Y(n552), 
	.A(n255));
   AND2X1 U510 (.Y(n254), 
	.B(n252), 
	.A(FE_PHN222_mem_62_));
   INVX1 U511 (.Y(n553), 
	.A(n254));
   AND2X1 U512 (.Y(n253), 
	.B(n252), 
	.A(FE_PHN127_mem_63_));
   INVX1 U513 (.Y(n554), 
	.A(n253));
   AND2X1 U514 (.Y(n274), 
	.B(n272), 
	.A(FE_PHN196_mem_46_));
   INVX1 U515 (.Y(n555), 
	.A(n274));
   AND2X1 U516 (.Y(n293), 
	.B(n290), 
	.A(FE_PHN132_mem_29_));
   INVX1 U517 (.Y(n556), 
	.A(n293));
   AND2X1 U518 (.Y(n312), 
	.B(n308), 
	.A(FE_PHN235_mem_12_));
   INVX1 U519 (.Y(n557), 
	.A(n312));
   AND2X1 U520 (.Y(n267), 
	.B(n262), 
	.A(FE_PHN241_mem_51_));
   INVX1 U521 (.Y(n558), 
	.A(n267));
   AND2X1 U522 (.Y(n287), 
	.B(n281), 
	.A(FE_PHN218_mem_34_));
   INVX1 U523 (.Y(n559), 
	.A(n287));
   AND2X1 U524 (.Y(n306), 
	.B(n299), 
	.A(FE_PHN81_mem_17_));
   INVX1 U525 (.Y(n560), 
	.A(n306));
   AND2X1 U526 (.Y(n326), 
	.B(n318), 
	.A(FE_PHN168_mem_0_));
   INVX1 U527 (.Y(n561), 
	.A(n326));
   AND2X1 U528 (.Y(n180), 
	.B(n172), 
	.A(FE_PHN216_mem_120_));
   INVX1 U529 (.Y(n562), 
	.A(n180));
   AND2X1 U530 (.Y(n200), 
	.B(n193), 
	.A(FE_PHN101_mem_105_));
   INVX1 U531 (.Y(n563), 
	.A(n200));
   AND2X1 U532 (.Y(n218), 
	.B(n212), 
	.A(FE_PHN190_mem_90_));
   INVX1 U533 (.Y(n564), 
	.A(n218));
   AND2X1 U534 (.Y(n236), 
	.B(n231), 
	.A(FE_PHN240_mem_75_));
   INVX1 U535 (.Y(n565), 
	.A(n236));
   AND2X1 U536 (.Y(n187), 
	.B(n183), 
	.A(mem[116]));
   INVX1 U537 (.Y(n566), 
	.A(n187));
   AND2X1 U538 (.Y(n206), 
	.B(n203), 
	.A(FE_PHN247_mem_101_));
   INVX1 U539 (.Y(n567), 
	.A(n206));
   AND2X1 U540 (.Y(n224), 
	.B(n222), 
	.A(FE_PHN213_mem_86_));
   INVX1 U541 (.Y(n568), 
	.A(n224));
   AND2X1 U542 (.Y(n243), 
	.B(n242), 
	.A(FE_PHN118_mem_71_));
   INVX1 U543 (.Y(n569), 
	.A(n243));
   AND2X1 U544 (.Y(n179), 
	.B(n172), 
	.A(FE_PHN214_mem_121_));
   INVX1 U545 (.Y(n570), 
	.A(n179));
   AND2X1 U546 (.Y(n201), 
	.B(n193), 
	.A(FE_PHN233_mem_104_));
   INVX1 U547 (.Y(n571), 
	.A(n201));
   AND2X1 U548 (.Y(n217), 
	.B(n212), 
	.A(FE_PHN224_mem_91_));
   INVX1 U549 (.Y(n572), 
	.A(n217));
   AND2X1 U550 (.Y(n237), 
	.B(n231), 
	.A(FE_PHN150_mem_74_));
   INVX1 U551 (.Y(n573), 
	.A(n237));
   AND2X1 U552 (.Y(n186), 
	.B(n183), 
	.A(FE_PHN255_mem_117_));
   INVX1 U553 (.Y(n574), 
	.A(n186));
   AND2X1 U554 (.Y(n207), 
	.B(n203), 
	.A(FE_PHN234_mem_100_));
   INVX1 U555 (.Y(n575), 
	.A(n207));
   AND2X1 U556 (.Y(n223), 
	.B(n222), 
	.A(FE_PHN219_mem_87_));
   INVX1 U557 (.Y(n576), 
	.A(n223));
   AND2X1 U558 (.Y(n244), 
	.B(n242), 
	.A(mem[70]));
   INVX1 U559 (.Y(n577), 
	.A(n244));
   AND2X1 U560 (.Y(n340), 
	.B(n336), 
	.A(rd_ptr_p1[0]));
   INVX1 U561 (.Y(n578), 
	.A(n340));
   AND2X1 U562 (.Y(n178), 
	.B(n172), 
	.A(FE_PHN198_mem_122_));
   INVX1 U563 (.Y(n579), 
	.A(n178));
   AND2X1 U564 (.Y(n198), 
	.B(n193), 
	.A(FE_PHN231_mem_107_));
   INVX1 U565 (.Y(n580), 
	.A(n198));
   AND2X1 U566 (.Y(n220), 
	.B(n212), 
	.A(FE_PHN126_mem_88_));
   INVX1 U567 (.Y(n581), 
	.A(n220));
   AND2X1 U568 (.Y(n238), 
	.B(n231), 
	.A(FE_PHN259_mem_73_));
   INVX1 U569 (.Y(n582), 
	.A(n238));
   AND2X1 U570 (.Y(n185), 
	.B(n183), 
	.A(FE_PHN217_mem_118_));
   INVX1 U571 (.Y(n583), 
	.A(n185));
   AND2X1 U572 (.Y(n204), 
	.B(n203), 
	.A(FE_PHN139_mem_103_));
   INVX1 U573 (.Y(n584), 
	.A(n204));
   AND2X1 U574 (.Y(n226), 
	.B(n222), 
	.A(FE_PHN249_mem_84_));
   INVX1 U575 (.Y(n585), 
	.A(n226));
   AND2X1 U576 (.Y(n245), 
	.B(n242), 
	.A(FE_PHN252_mem_69_));
   INVX1 U577 (.Y(n586), 
	.A(n245));
   AND2X1 U578 (.Y(n177), 
	.B(n172), 
	.A(FE_PHN228_mem_123_));
   INVX1 U579 (.Y(n587), 
	.A(n177));
   AND2X1 U580 (.Y(n199), 
	.B(n193), 
	.A(FE_PHN173_mem_106_));
   INVX1 U581 (.Y(n588), 
	.A(n199));
   AND2X1 U582 (.Y(n219), 
	.B(n212), 
	.A(FE_PHN140_mem_89_));
   INVX1 U583 (.Y(n589), 
	.A(n219));
   AND2X1 U584 (.Y(n239), 
	.B(n231), 
	.A(FE_PHN223_mem_72_));
   INVX1 U585 (.Y(n590), 
	.A(n239));
   AND2X1 U586 (.Y(n184), 
	.B(n183), 
	.A(FE_PHN188_mem_119_));
   INVX1 U587 (.Y(n591), 
	.A(n184));
   AND2X1 U588 (.Y(n205), 
	.B(n203), 
	.A(mem[102]));
   INVX1 U589 (.Y(n592), 
	.A(n205));
   AND2X1 U590 (.Y(n225), 
	.B(n222), 
	.A(FE_PHN232_mem_85_));
   INVX1 U591 (.Y(n593), 
	.A(n225));
   AND2X1 U592 (.Y(n246), 
	.B(n242), 
	.A(FE_PHN254_mem_68_));
   INVX1 U593 (.Y(n594), 
	.A(n246));
   AND2X1 U594 (.Y(n339), 
	.B(n336), 
	.A(rd_ptr_p1[4]));
   INVX1 U595 (.Y(n595), 
	.A(n339));
   AND2X1 U596 (.Y(n176), 
	.B(n172), 
	.A(FE_PHN236_mem_124_));
   INVX1 U597 (.Y(n596), 
	.A(n176));
   AND2X1 U598 (.Y(n196), 
	.B(n193), 
	.A(mem[109]));
   INVX1 U599 (.Y(n597), 
	.A(n196));
   AND2X1 U600 (.Y(n214), 
	.B(n212), 
	.A(FE_PHN177_mem_94_));
   INVX1 U601 (.Y(n598), 
	.A(n214));
   AND2X1 U602 (.Y(n232), 
	.B(n231), 
	.A(FE_PHN98_mem_79_));
   INVX1 U603 (.Y(n599), 
	.A(n232));
   AND2X1 U604 (.Y(n191), 
	.B(n183), 
	.A(FE_PHN181_mem_112_));
   INVX1 U605 (.Y(n600), 
	.A(n191));
   AND2X1 U606 (.Y(n210), 
	.B(n203), 
	.A(FE_PHN230_mem_97_));
   INVX1 U607 (.Y(n601), 
	.A(n210));
   AND2X1 U608 (.Y(n228), 
	.B(n222), 
	.A(FE_PHN180_mem_82_));
   INVX1 U609 (.Y(n602), 
	.A(n228));
   AND2X1 U610 (.Y(n247), 
	.B(n242), 
	.A(FE_PHN257_mem_67_));
   INVX1 U611 (.Y(n603), 
	.A(n247));
   AND2X1 U612 (.Y(n338), 
	.B(n336), 
	.A(rd_ptr_p1[1]));
   INVX1 U613 (.Y(n604), 
	.A(n338));
   AND2X1 U614 (.Y(n175), 
	.B(n172), 
	.A(FE_PHN227_mem_125_));
   INVX1 U615 (.Y(n605), 
	.A(n175));
   AND2X1 U616 (.Y(n197), 
	.B(n193), 
	.A(FE_PHN244_mem_108_));
   INVX1 U617 (.Y(n606), 
	.A(n197));
   AND2X1 U618 (.Y(n213), 
	.B(n212), 
	.A(FE_PHN248_mem_95_));
   INVX1 U619 (.Y(n607), 
	.A(n213));
   AND2X1 U620 (.Y(n233), 
	.B(n231), 
	.A(mem[78]));
   INVX1 U621 (.Y(n608), 
	.A(n233));
   AND2X1 U622 (.Y(n190), 
	.B(n183), 
	.A(FE_PHN221_mem_113_));
   INVX1 U623 (.Y(n609), 
	.A(n190));
   AND2X1 U624 (.Y(n211), 
	.B(n203), 
	.A(FE_PHN260_mem_96_));
   INVX1 U625 (.Y(n610), 
	.A(n211));
   AND2X1 U626 (.Y(n227), 
	.B(n222), 
	.A(FE_PHN250_mem_83_));
   INVX1 U627 (.Y(n611), 
	.A(n227));
   AND2X1 U628 (.Y(n248), 
	.B(n242), 
	.A(FE_PHN167_mem_66_));
   INVX1 U629 (.Y(n612), 
	.A(n248));
   AND2X1 U630 (.Y(n337), 
	.B(n336), 
	.A(rd_ptr_p1[2]));
   INVX1 U631 (.Y(n613), 
	.A(n337));
   INVX1 U632 (.Y(n614), 
	.A(FE_PHN14_n56));
   AND2X1 U633 (.Y(n357), 
	.B(n329), 
	.A(diff[4]));
   INVX1 U634 (.Y(n615), 
	.A(n357));
   AND2X1 U635 (.Y(n329), 
	.B(n631), 
	.A(n802));
   AND2X1 U636 (.Y(n174), 
	.B(n172), 
	.A(FE_PHN211_mem_126_));
   INVX1 U637 (.Y(n616), 
	.A(n174));
   AND2X1 U638 (.Y(n194), 
	.B(n193), 
	.A(FE_PHN79_mem_111_));
   INVX1 U639 (.Y(n617), 
	.A(n194));
   AND2X1 U640 (.Y(n216), 
	.B(n212), 
	.A(mem[92]));
   INVX1 U641 (.Y(n618), 
	.A(n216));
   AND2X1 U642 (.Y(n234), 
	.B(n231), 
	.A(mem[77]));
   INVX1 U643 (.Y(n619), 
	.A(n234));
   AND2X1 U644 (.Y(n189), 
	.B(n183), 
	.A(FE_PHN83_mem_114_));
   INVX1 U645 (.Y(n620), 
	.A(n189));
   AND2X1 U646 (.Y(n208), 
	.B(n203), 
	.A(FE_PHN225_mem_99_));
   INVX1 U647 (.Y(n621), 
	.A(n208));
   AND2X1 U648 (.Y(n230), 
	.B(n222), 
	.A(FE_PHN199_mem_80_));
   INVX1 U649 (.Y(n622), 
	.A(n230));
   AND2X1 U650 (.Y(n249), 
	.B(n242), 
	.A(FE_PHN117_mem_65_));
   INVX1 U651 (.Y(n623), 
	.A(n249));
   AND2X1 U652 (.Y(n335), 
	.B(n336), 
	.A(rd_ptr_p1[3]));
   INVX1 U653 (.Y(n624), 
	.A(n335));
   AND2X1 U654 (.Y(n336), 
	.B(n802), 
	.A(n649));
   INVX1 U658 (.Y(n628), 
	.A(add_55_carry_4_));
   AND2X1 U659 (.Y(n796), 
	.B(diff[0]), 
	.A(diff[1]));
   INVX1 U660 (.Y(n629), 
	.A(n796));
   AND2X1 U661 (.Y(n795), 
	.B(diff[2]), 
	.A(diff[3]));
   INVX1 U662 (.Y(n630), 
	.A(n795));
   AND2X1 U663 (.Y(n359), 
	.B(full_bar), 
	.A(put));
   INVX1 U664 (.Y(n631), 
	.A(n359));
   OR2X1 U665 (.Y(n221), 
	.B(wr_ptr_bin[2]), 
	.A(n814));
   INVX1 U666 (.Y(n632), 
	.A(n221));
   OR2X1 U667 (.Y(n46), 
	.B(n811), 
	.A(reset));
   INVX1 U668 (.Y(n633), 
	.A(FE_PHN9_n46));
   OR2X1 U669 (.Y(FE_PHN51_n47), 
	.B(n817), 
	.A(reset));
   INVX1 U670 (.Y(n634), 
	.A(FE_PHN11_n47));
   OR2X1 U671 (.Y(n48), 
	.B(n818), 
	.A(reset));
   INVX1 U672 (.Y(n635), 
	.A(FE_PHN13_n48));
   OR2X1 U673 (.Y(n49), 
	.B(n819), 
	.A(reset));
   INVX1 U674 (.Y(n636), 
	.A(FE_PHN10_n49));
   OR2X1 U675 (.Y(n50), 
	.B(n816), 
	.A(reset));
   INVX1 U676 (.Y(n637), 
	.A(FE_PHN24_n50));
   AND2X1 U677 (.Y(n173), 
	.B(n172), 
	.A(FE_PHN206_mem_127_));
   INVX1 U678 (.Y(n638), 
	.A(n173));
   AND2X1 U679 (.Y(n195), 
	.B(n193), 
	.A(mem[110]));
   INVX1 U680 (.Y(n639), 
	.A(n195));
   AND2X1 U681 (.Y(n215), 
	.B(n212), 
	.A(FE_PHN245_mem_93_));
   INVX1 U682 (.Y(n640), 
	.A(n215));
   AND2X1 U683 (.Y(n235), 
	.B(n231), 
	.A(mem[76]));
   INVX1 U684 (.Y(n641), 
	.A(n235));
   AND2X1 U685 (.Y(n188), 
	.B(n183), 
	.A(mem[115]));
   INVX1 U686 (.Y(n642), 
	.A(n188));
   AND2X1 U687 (.Y(n209), 
	.B(n203), 
	.A(FE_PHN200_mem_98_));
   INVX1 U688 (.Y(n643), 
	.A(n209));
   AND2X1 U689 (.Y(n229), 
	.B(n222), 
	.A(FE_PHN135_mem_81_));
   INVX1 U690 (.Y(n644), 
	.A(n229));
   AND2X1 U691 (.Y(n250), 
	.B(n242), 
	.A(FE_PHN111_mem_64_));
   INVX1 U692 (.Y(n645), 
	.A(n250));
   INVX1 U693 (.Y(n646), 
	.A(n251));
   OR2X1 U694 (.Y(n240), 
	.B(wr_ptr_bin[2]), 
	.A(wr_ptr_bin[1]));
   INVX1 U695 (.Y(n647), 
	.A(n240));
   OR2X1 U696 (.Y(n328), 
	.B(reset), 
	.A(n329));
   INVX1 U697 (.Y(n648), 
	.A(n328));
   AND2X1 U698 (.Y(n334), 
	.B(n341), 
	.A(n802));
   INVX1 U699 (.Y(n649), 
	.A(n334));
   AND2X2 U700 (.Y(data_out[7]), 
	.B(n788), 
	.A(n96));
   AND2X2 U701 (.Y(data_out[6]), 
	.B(n788), 
	.A(n97));
   AND2X2 U702 (.Y(data_out[5]), 
	.B(n788), 
	.A(n98));
   INVX1 U703 (.Y(n782), 
	.A(n789));
   INVX1 U704 (.Y(n781), 
	.A(n789));
   INVX1 U705 (.Y(n780), 
	.A(n789));
   INVX1 U706 (.Y(n779), 
	.A(n789));
   INVX1 U707 (.Y(n778), 
	.A(n789));
   INVX1 U708 (.Y(n242), 
	.A(n650));
   INVX1 U709 (.Y(n222), 
	.A(n651));
   AND2X1 U710 (.Y(n652), 
	.B(n192), 
	.A(n202));
   INVX1 U711 (.Y(n203), 
	.A(n652));
   INVX1 U712 (.Y(n231), 
	.A(n653));
   INVX1 U713 (.Y(n212), 
	.A(n654));
   AND2X1 U714 (.Y(n655), 
	.B(n182), 
	.A(n202));
   INVX1 U715 (.Y(n193), 
	.A(n655));
   INVX1 U716 (.Y(n318), 
	.A(n656));
   INVX1 U717 (.Y(n299), 
	.A(n657));
   AND2X1 U718 (.Y(n658), 
	.B(n202), 
	.A(n271));
   INVX1 U719 (.Y(n281), 
	.A(n658));
   INVX1 U720 (.Y(n308), 
	.A(n659));
   INVX1 U721 (.Y(n290), 
	.A(n660));
   AND2X1 U722 (.Y(n661), 
	.B(n202), 
	.A(n261));
   INVX1 U723 (.Y(n272), 
	.A(n661));
   AND2X1 U724 (.Y(n662), 
	.B(n181), 
	.A(n192));
   INVX1 U725 (.Y(n183), 
	.A(n662));
   AND2X1 U726 (.Y(n663), 
	.B(n181), 
	.A(n271));
   INVX1 U727 (.Y(n262), 
	.A(n663));
   AND2X1 U728 (.Y(n664), 
	.B(n181), 
	.A(n261));
   INVX1 U729 (.Y(n252), 
	.A(n664));
   AND2X1 U730 (.Y(n665), 
	.B(n182), 
	.A(n181));
   INVX1 U731 (.Y(n172), 
	.A(n665));
   AND2X1 U732 (.Y(n271), 
	.B(wr_ptr_bin_p1[0]), 
	.A(n317));
   AND2X1 U733 (.Y(n192), 
	.B(wr_ptr_bin_p1[0]), 
	.A(n241));
   INVX1 U736 (.Y(n791), 
	.A(rd_ptr_ss_bin[3]));
   INVX1 U737 (.Y(n793), 
	.A(rd_ptr_ss_bin[1]));
   AND2X1 U740 (.Y(n182), 
	.B(n241), 
	.A(wr_ptr_bin[0]));
   AND2X1 U741 (.Y(n261), 
	.B(wr_ptr_bin[0]), 
	.A(n317));
   INVX1 U742 (.Y(n813), 
	.A(wr_ptr_bin[3]));
   AND2X1 U744 (.Y(data_out[0]), 
	.B(n788), 
	.A(n103));
   AND2X1 U745 (.Y(data_out[1]), 
	.B(n788), 
	.A(n102));
   AND2X1 U746 (.Y(data_out[2]), 
	.B(n788), 
	.A(n101));
   AND2X1 U747 (.Y(data_out[3]), 
	.B(n788), 
	.A(n100));
   AND2X1 U748 (.Y(data_out[4]), 
	.B(n788), 
	.A(n99));
   INVX1 U749 (.Y(n814), 
	.A(wr_ptr_bin[1]));
   AND2X1 U750 (.Y(n202), 
	.B(n814), 
	.A(wr_ptr_bin[2]));
   AND2X1 U751 (.Y(n181), 
	.B(wr_ptr_bin[1]), 
	.A(wr_ptr_bin[2]));
   INVX1 U752 (.Y(n800), 
	.A(FE_PHN32_n330));
   INVX1 U753 (.Y(n799), 
	.A(FE_PHN18_n331));
   INVX1 U754 (.Y(n798), 
	.A(FE_PHN15_n332));
   INVX1 U755 (.Y(wr_ptr_bin_p1[0]), 
	.A(wr_ptr_bin[0]));
   INVX1 U756 (.Y(n797), 
	.A(FE_PHN17_n333));
   INVX1 U757 (.Y(n792), 
	.A(rd_ptr_ss_bin[2]));
   INVX1 U758 (.Y(n790), 
	.A(rd_ptr_ss_bin[4]));
   INVX1 U759 (.Y(n789), 
	.A(n14));
   INVX1 U760 (.Y(n801), 
	.A(FE_PHN19_n327));
   AND2X1 U761 (.Y(n89), 
	.B(wr_ptr[4]), 
	.A(n802));
   AND2X1 U762 (.Y(n87), 
	.B(wr_ptr[2]), 
	.A(n802));
   AND2X1 U763 (.Y(n86), 
	.B(wr_ptr[1]), 
	.A(n802));
   AND2X1 U764 (.Y(n88), 
	.B(wr_ptr[3]), 
	.A(n802));
   AND2X1 U765 (.Y(n85), 
	.B(wr_ptr[0]), 
	.A(n802));
   AND2X1 U766 (.Y(n55), 
	.B(n802), 
	.A(rd_ptr_s[4]));
   AND2X1 U767 (.Y(n54), 
	.B(n802), 
	.A(rd_ptr_s[3]));
   AND2X1 U768 (.Y(n53), 
	.B(n802), 
	.A(rd_ptr_s[2]));
   AND2X1 U769 (.Y(n52), 
	.B(n802), 
	.A(rd_ptr_s[1]));
   AND2X1 U770 (.Y(n94), 
	.B(n802), 
	.A(wr_ptr_s[4]));
   AND2X1 U771 (.Y(n93), 
	.B(n802), 
	.A(wr_ptr_s[3]));
   AND2X1 U772 (.Y(n92), 
	.B(n802), 
	.A(wr_ptr_s[2]));
   AND2X1 U773 (.Y(n91), 
	.B(n802), 
	.A(wr_ptr_s[1]));
   AND2X1 U774 (.Y(n90), 
	.B(n802), 
	.A(wr_ptr_s[0]));
   AND2X1 U775 (.Y(n51), 
	.B(n802), 
	.A(rd_ptr_s[0]));
   INVX1 U776 (.Y(n802), 
	.A(reset));
   INVX1 U777 (.Y(full_bar), 
	.A(FULL));
   INVX1 U778 (.Y(empty_bar), 
	.A(EMPTY));
   INVX1 U779 (.Y(n794), 
	.A(rd_ptr_ss_bin[0]));
   INVX1 U780 (.Y(n818), 
	.A(rd_ptr[2]));
   INVX1 U781 (.Y(n816), 
	.A(rd_ptr[4]));
   INVX1 U782 (.Y(n817), 
	.A(rd_ptr[1]));
   INVX1 U783 (.Y(n819), 
	.A(rd_ptr[3]));
   INVX1 U784 (.Y(n811), 
	.A(rd_ptr[0]));
   INVX1 U785 (.Y(n810), 
	.A(data_in[0]));
   INVX1 U786 (.Y(n809), 
	.A(data_in[1]));
   INVX1 U787 (.Y(n808), 
	.A(data_in[2]));
   INVX1 U788 (.Y(n807), 
	.A(data_in[3]));
   INVX1 U789 (.Y(n806), 
	.A(data_in[4]));
   INVX1 U790 (.Y(n805), 
	.A(data_in[5]));
   INVX1 U791 (.Y(n804), 
	.A(data_in[6]));
   INVX1 U792 (.Y(n803), 
	.A(data_in[7]));
   MUX2X1 U793 (.Y(n666), 
	.S(n15), 
	.B(n667), 
	.A(n668));
   MUX2X1 U794 (.Y(n669), 
	.S(n15), 
	.B(n670), 
	.A(n671));
   MUX2X1 U795 (.Y(n672), 
	.S(n15), 
	.B(n673), 
	.A(n674));
   MUX2X1 U796 (.Y(n675), 
	.S(n15), 
	.B(n676), 
	.A(n677));
   MUX2X1 U797 (.Y(n103), 
	.S(n17), 
	.B(n678), 
	.A(n679));
   MUX2X1 U798 (.Y(n680), 
	.S(n15), 
	.B(n681), 
	.A(n682));
   MUX2X1 U799 (.Y(n683), 
	.S(n15), 
	.B(n684), 
	.A(n685));
   MUX2X1 U800 (.Y(n686), 
	.S(n15), 
	.B(n687), 
	.A(n688));
   MUX2X1 U801 (.Y(n689), 
	.S(n15), 
	.B(n690), 
	.A(n691));
   MUX2X1 U802 (.Y(n102), 
	.S(n17), 
	.B(n692), 
	.A(n693));
   MUX2X1 U803 (.Y(n694), 
	.S(n15), 
	.B(n695), 
	.A(n696));
   MUX2X1 U804 (.Y(n697), 
	.S(n15), 
	.B(n698), 
	.A(n699));
   MUX2X1 U805 (.Y(n700), 
	.S(n15), 
	.B(n701), 
	.A(n702));
   MUX2X1 U806 (.Y(n703), 
	.S(n15), 
	.B(n704), 
	.A(n705));
   MUX2X1 U807 (.Y(n101), 
	.S(n17), 
	.B(n706), 
	.A(n707));
   MUX2X1 U808 (.Y(n708), 
	.S(n15), 
	.B(n709), 
	.A(n710));
   MUX2X1 U809 (.Y(n711), 
	.S(n15), 
	.B(n712), 
	.A(n713));
   MUX2X1 U810 (.Y(n714), 
	.S(n15), 
	.B(n715), 
	.A(n716));
   MUX2X1 U811 (.Y(n717), 
	.S(n15), 
	.B(n718), 
	.A(n719));
   MUX2X1 U812 (.Y(n100), 
	.S(n17), 
	.B(n720), 
	.A(n721));
   MUX2X1 U813 (.Y(n722), 
	.S(n15), 
	.B(n723), 
	.A(n724));
   MUX2X1 U814 (.Y(n725), 
	.S(n15), 
	.B(n726), 
	.A(n727));
   MUX2X1 U815 (.Y(n728), 
	.S(n15), 
	.B(n729), 
	.A(n730));
   MUX2X1 U816 (.Y(n731), 
	.S(n15), 
	.B(n732), 
	.A(n733));
   MUX2X1 U817 (.Y(n99), 
	.S(n17), 
	.B(n734), 
	.A(n735));
   MUX2X1 U818 (.Y(n736), 
	.S(n15), 
	.B(n737), 
	.A(n738));
   MUX2X1 U819 (.Y(n739), 
	.S(n15), 
	.B(n740), 
	.A(n741));
   MUX2X1 U820 (.Y(n742), 
	.S(n15), 
	.B(n743), 
	.A(n744));
   MUX2X1 U821 (.Y(n745), 
	.S(n15), 
	.B(n746), 
	.A(n747));
   MUX2X1 U822 (.Y(n98), 
	.S(n17), 
	.B(n748), 
	.A(n749));
   MUX2X1 U823 (.Y(n750), 
	.S(n15), 
	.B(n751), 
	.A(n752));
   MUX2X1 U824 (.Y(n753), 
	.S(n15), 
	.B(n754), 
	.A(n755));
   MUX2X1 U825 (.Y(n756), 
	.S(n15), 
	.B(n757), 
	.A(n758));
   MUX2X1 U826 (.Y(n759), 
	.S(n15), 
	.B(n760), 
	.A(n761));
   MUX2X1 U827 (.Y(n97), 
	.S(n17), 
	.B(n762), 
	.A(n763));
   MUX2X1 U828 (.Y(n764), 
	.S(n15), 
	.B(n765), 
	.A(n766));
   MUX2X1 U829 (.Y(n767), 
	.S(n15), 
	.B(n768), 
	.A(n769));
   MUX2X1 U830 (.Y(n770), 
	.S(n15), 
	.B(n771), 
	.A(n772));
   MUX2X1 U831 (.Y(n773), 
	.S(n15), 
	.B(n774), 
	.A(n775));
   MUX2X1 U832 (.Y(n96), 
	.S(n17), 
	.B(n776), 
	.A(n777));
   MUX2X1 U833 (.Y(n668), 
	.S(n782), 
	.B(mem[112]), 
	.A(mem[120]));
   MUX2X1 U834 (.Y(n667), 
	.S(n782), 
	.B(mem[96]), 
	.A(mem[104]));
   MUX2X1 U835 (.Y(n671), 
	.S(n782), 
	.B(mem[80]), 
	.A(mem[88]));
   MUX2X1 U836 (.Y(n670), 
	.S(n782), 
	.B(mem[64]), 
	.A(mem[72]));
   MUX2X1 U837 (.Y(n679), 
	.S(n16), 
	.B(n669), 
	.A(n666));
   MUX2X1 U838 (.Y(n674), 
	.S(n782), 
	.B(mem[48]), 
	.A(mem[56]));
   MUX2X1 U839 (.Y(n673), 
	.S(n782), 
	.B(mem[32]), 
	.A(mem[40]));
   MUX2X1 U840 (.Y(n677), 
	.S(n782), 
	.B(mem[16]), 
	.A(mem[24]));
   MUX2X1 U841 (.Y(n676), 
	.S(n782), 
	.B(mem[0]), 
	.A(mem[8]));
   MUX2X1 U842 (.Y(n678), 
	.S(n16), 
	.B(n675), 
	.A(n672));
   MUX2X1 U843 (.Y(n682), 
	.S(n782), 
	.B(mem[113]), 
	.A(mem[121]));
   MUX2X1 U844 (.Y(n681), 
	.S(n782), 
	.B(mem[97]), 
	.A(mem[105]));
   MUX2X1 U845 (.Y(n685), 
	.S(n782), 
	.B(mem[81]), 
	.A(mem[89]));
   MUX2X1 U846 (.Y(n684), 
	.S(n782), 
	.B(mem[65]), 
	.A(mem[73]));
   MUX2X1 U847 (.Y(n693), 
	.S(n16), 
	.B(n683), 
	.A(n680));
   MUX2X1 U848 (.Y(n688), 
	.S(n781), 
	.B(mem[49]), 
	.A(mem[57]));
   MUX2X1 U849 (.Y(n687), 
	.S(n781), 
	.B(mem[33]), 
	.A(mem[41]));
   MUX2X1 U850 (.Y(n691), 
	.S(n781), 
	.B(mem[17]), 
	.A(mem[25]));
   MUX2X1 U851 (.Y(n690), 
	.S(n781), 
	.B(mem[1]), 
	.A(mem[9]));
   MUX2X1 U852 (.Y(n692), 
	.S(n16), 
	.B(n689), 
	.A(n686));
   MUX2X1 U853 (.Y(n696), 
	.S(n781), 
	.B(mem[114]), 
	.A(mem[122]));
   MUX2X1 U854 (.Y(n695), 
	.S(n781), 
	.B(mem[98]), 
	.A(mem[106]));
   MUX2X1 U855 (.Y(n699), 
	.S(n781), 
	.B(mem[82]), 
	.A(mem[90]));
   MUX2X1 U856 (.Y(n698), 
	.S(n781), 
	.B(mem[66]), 
	.A(mem[74]));
   MUX2X1 U857 (.Y(n707), 
	.S(n16), 
	.B(n697), 
	.A(n694));
   MUX2X1 U858 (.Y(n702), 
	.S(n781), 
	.B(mem[50]), 
	.A(mem[58]));
   MUX2X1 U859 (.Y(n701), 
	.S(n781), 
	.B(mem[34]), 
	.A(mem[42]));
   MUX2X1 U860 (.Y(n705), 
	.S(n781), 
	.B(mem[18]), 
	.A(mem[26]));
   MUX2X1 U861 (.Y(n704), 
	.S(n781), 
	.B(mem[2]), 
	.A(mem[10]));
   MUX2X1 U862 (.Y(n706), 
	.S(n16), 
	.B(n703), 
	.A(n700));
   MUX2X1 U863 (.Y(n710), 
	.S(n780), 
	.B(mem[115]), 
	.A(mem[123]));
   MUX2X1 U864 (.Y(n709), 
	.S(n780), 
	.B(mem[99]), 
	.A(mem[107]));
   MUX2X1 U865 (.Y(n713), 
	.S(n780), 
	.B(mem[83]), 
	.A(mem[91]));
   MUX2X1 U866 (.Y(n712), 
	.S(n780), 
	.B(mem[67]), 
	.A(mem[75]));
   MUX2X1 U867 (.Y(n721), 
	.S(n16), 
	.B(n711), 
	.A(n708));
   MUX2X1 U868 (.Y(n716), 
	.S(n780), 
	.B(mem[51]), 
	.A(mem[59]));
   MUX2X1 U869 (.Y(n715), 
	.S(n780), 
	.B(mem[35]), 
	.A(mem[43]));
   MUX2X1 U870 (.Y(n719), 
	.S(n780), 
	.B(mem[19]), 
	.A(mem[27]));
   MUX2X1 U871 (.Y(n718), 
	.S(n780), 
	.B(mem[3]), 
	.A(mem[11]));
   MUX2X1 U872 (.Y(n720), 
	.S(n16), 
	.B(n717), 
	.A(n714));
   MUX2X1 U873 (.Y(n724), 
	.S(n780), 
	.B(mem[116]), 
	.A(mem[124]));
   MUX2X1 U874 (.Y(n723), 
	.S(n780), 
	.B(mem[100]), 
	.A(mem[108]));
   MUX2X1 U875 (.Y(n727), 
	.S(n780), 
	.B(mem[84]), 
	.A(mem[92]));
   MUX2X1 U876 (.Y(n726), 
	.S(n780), 
	.B(mem[68]), 
	.A(mem[76]));
   MUX2X1 U877 (.Y(n735), 
	.S(n16), 
	.B(n725), 
	.A(n722));
   MUX2X1 U878 (.Y(n730), 
	.S(n779), 
	.B(mem[52]), 
	.A(mem[60]));
   MUX2X1 U879 (.Y(n729), 
	.S(n779), 
	.B(mem[36]), 
	.A(mem[44]));
   MUX2X1 U880 (.Y(n733), 
	.S(n779), 
	.B(mem[20]), 
	.A(mem[28]));
   MUX2X1 U881 (.Y(n732), 
	.S(n779), 
	.B(mem[4]), 
	.A(mem[12]));
   MUX2X1 U882 (.Y(n734), 
	.S(n16), 
	.B(n731), 
	.A(n728));
   MUX2X1 U883 (.Y(n738), 
	.S(n779), 
	.B(mem[117]), 
	.A(mem[125]));
   MUX2X1 U884 (.Y(n737), 
	.S(n779), 
	.B(mem[101]), 
	.A(mem[109]));
   MUX2X1 U885 (.Y(n741), 
	.S(n779), 
	.B(mem[85]), 
	.A(mem[93]));
   MUX2X1 U886 (.Y(n740), 
	.S(n779), 
	.B(mem[69]), 
	.A(mem[77]));
   MUX2X1 U887 (.Y(n749), 
	.S(n16), 
	.B(n739), 
	.A(n736));
   MUX2X1 U888 (.Y(n744), 
	.S(n779), 
	.B(mem[53]), 
	.A(mem[61]));
   MUX2X1 U889 (.Y(n743), 
	.S(n779), 
	.B(mem[37]), 
	.A(mem[45]));
   MUX2X1 U890 (.Y(n747), 
	.S(n779), 
	.B(mem[21]), 
	.A(mem[29]));
   MUX2X1 U891 (.Y(n746), 
	.S(n779), 
	.B(mem[5]), 
	.A(mem[13]));
   MUX2X1 U892 (.Y(n748), 
	.S(n16), 
	.B(n745), 
	.A(n742));
   MUX2X1 U893 (.Y(n752), 
	.S(n778), 
	.B(mem[118]), 
	.A(mem[126]));
   MUX2X1 U894 (.Y(n751), 
	.S(n778), 
	.B(mem[102]), 
	.A(mem[110]));
   MUX2X1 U895 (.Y(n755), 
	.S(n778), 
	.B(mem[86]), 
	.A(mem[94]));
   MUX2X1 U896 (.Y(n754), 
	.S(n778), 
	.B(mem[70]), 
	.A(mem[78]));
   MUX2X1 U897 (.Y(n763), 
	.S(n16), 
	.B(n753), 
	.A(n750));
   MUX2X1 U898 (.Y(n758), 
	.S(n778), 
	.B(mem[54]), 
	.A(mem[62]));
   MUX2X1 U899 (.Y(n757), 
	.S(n778), 
	.B(mem[38]), 
	.A(mem[46]));
   MUX2X1 U900 (.Y(n761), 
	.S(n778), 
	.B(mem[22]), 
	.A(mem[30]));
   MUX2X1 U901 (.Y(n760), 
	.S(n778), 
	.B(mem[6]), 
	.A(mem[14]));
   MUX2X1 U902 (.Y(n762), 
	.S(n16), 
	.B(n759), 
	.A(n756));
   MUX2X1 U903 (.Y(n766), 
	.S(n778), 
	.B(mem[119]), 
	.A(mem[127]));
   MUX2X1 U904 (.Y(n765), 
	.S(n778), 
	.B(mem[103]), 
	.A(mem[111]));
   MUX2X1 U905 (.Y(n769), 
	.S(n778), 
	.B(mem[87]), 
	.A(mem[95]));
   MUX2X1 U906 (.Y(n768), 
	.S(n778), 
	.B(mem[71]), 
	.A(mem[79]));
   MUX2X1 U907 (.Y(n777), 
	.S(n16), 
	.B(n767), 
	.A(n764));
   MUX2X1 U908 (.Y(n772), 
	.S(n779), 
	.B(mem[55]), 
	.A(mem[63]));
   MUX2X1 U909 (.Y(n771), 
	.S(n782), 
	.B(mem[39]), 
	.A(mem[47]));
   MUX2X1 U910 (.Y(n775), 
	.S(n780), 
	.B(mem[23]), 
	.A(mem[31]));
   MUX2X1 U911 (.Y(n774), 
	.S(n781), 
	.B(mem[7]), 
	.A(mem[15]));
   MUX2X1 U912 (.Y(n776), 
	.S(n16), 
	.B(n773), 
	.A(n770));
   AND2X2 U913 (.Y(n788), 
	.B(empty_bar), 
	.A(get));
   INVX1 U914 (.Y(n341), 
	.A(n788));
   OR2X1 U915 (.Y(sub_38_carry[1]), 
	.B(wr_ptr_bin[0]), 
	.A(n794));
   XNOR2X1 U916 (.Y(diff[0]), 
	.B(n794), 
	.A(wr_ptr_bin[0]));
   XOR2X1 U917 (.Y(rd_ptr_bin_p1[4]), 
	.B(rd_ptr_bin_4_), 
	.A(add_35_carry[4]));
endmodule

