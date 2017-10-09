
module gray2bin_SIZE5_3 ( gray, bin );
  input [4:0] gray;
  output [4:0] bin;

  assign bin[4] = gray[4];

  XOR2X1 U1 ( .A(gray[2]), .B(bin[3]), .Y(bin[2]) );
  XOR2X1 U2 ( .A(gray[0]), .B(bin[1]), .Y(bin[0]) );
  FAX1 U3 ( .A(gray[2]), .B(gray[1]), .C(bin[3]), .YC(), .YS(bin[1]) );
  XOR2X1 U4 ( .A(gray[3]), .B(gray[4]), .Y(bin[3]) );
endmodule


module gray2bin_SIZE5_2 ( gray, bin );
  input [4:0] gray;
  output [4:0] bin;

  assign bin[4] = gray[4];

  XOR2X1 U1 ( .A(gray[2]), .B(bin[3]), .Y(bin[2]) );
  XOR2X1 U2 ( .A(gray[0]), .B(bin[1]), .Y(bin[0]) );
  FAX1 U3 ( .A(gray[2]), .B(gray[1]), .C(bin[3]), .YC(), .YS(bin[1]) );
  XOR2X1 U4 ( .A(gray[3]), .B(gray[4]), .Y(bin[3]) );
endmodule


module gray2bin_SIZE5_1 ( gray, bin );
  input [4:0] gray;
  output [4:0] bin;

  assign bin[4] = gray[4];

  XOR2X1 U1 ( .A(gray[2]), .B(bin[3]), .Y(bin[2]) );
  XOR2X1 U2 ( .A(gray[0]), .B(bin[1]), .Y(bin[0]) );
  FAX1 U3 ( .A(gray[2]), .B(gray[1]), .C(bin[3]), .YC(), .YS(bin[1]) );
  XOR2X1 U4 ( .A(gray[3]), .B(gray[4]), .Y(bin[3]) );
endmodule


module gray2bin_SIZE5_0 ( gray, bin );
  input [4:0] gray;
  output [4:0] bin;

  assign bin[4] = gray[4];

  XOR2X1 U1 ( .A(gray[2]), .B(bin[3]), .Y(bin[2]) );
  XOR2X1 U2 ( .A(gray[0]), .B(bin[1]), .Y(bin[0]) );
  FAX1 U3 ( .A(gray[2]), .B(gray[1]), .C(bin[3]), .YC(), .YS(bin[1]) );
  XOR2X1 U4 ( .A(gray[3]), .B(gray[4]), .Y(bin[3]) );
endmodule


module bin2gray_SIZE5_1 ( bin, gray );
  input [4:0] bin;
  output [4:0] gray;

  assign gray[4] = bin[4];

  XOR2X1 U1 ( .A(bin[4]), .B(bin[3]), .Y(gray[3]) );
  XOR2X1 U2 ( .A(bin[3]), .B(bin[2]), .Y(gray[2]) );
  XOR2X1 U3 ( .A(bin[2]), .B(bin[1]), .Y(gray[1]) );
  XOR2X1 U4 ( .A(bin[1]), .B(bin[0]), .Y(gray[0]) );
endmodule


module bin2gray_SIZE5_0 ( bin, gray );
  input [4:0] bin;
  output [4:0] gray;

  assign gray[4] = bin[4];

  XOR2X1 U1 ( .A(bin[4]), .B(bin[3]), .Y(gray[3]) );
  XOR2X1 U2 ( .A(bin[3]), .B(bin[2]), .Y(gray[2]) );
  XOR2X1 U3 ( .A(bin[2]), .B(bin[1]), .Y(gray[1]) );
  XOR2X1 U4 ( .A(bin[1]), .B(bin[0]), .Y(gray[0]) );
endmodule


module FIFO_2clk ( rclk, wclk, reset, put, get, data_in, empty_bar, full_bar, 
        data_out );
  input [7:0] data_in;
  output [7:0] data_out;
  input rclk, wclk, reset, put, get;
  output empty_bar, full_bar;
  wire   n14, n15, n16, n17, rd_ptr_bin_4_, FULL, n20, n21, n46, n47, n48, n49,
         n50, n51, n52, n53, n54, n55, n56, EMPTY, n85, n86, n87, n88, n89,
         n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102,
         n103, n172, n173, n174, n175, n176, n177, n178, n179, n180, n181,
         n182, n183, n184, n185, n186, n187, n188, n189, n190, n191, n192,
         n193, n194, n195, n196, n197, n198, n199, n200, n201, n202, n203,
         n204, n205, n206, n207, n208, n209, n210, n211, n212, n213, n214,
         n215, n216, n217, n218, n219, n220, n221, n222, n223, n224, n225,
         n226, n227, n228, n229, n230, n231, n232, n233, n234, n235, n236,
         n237, n238, n239, n240, n241, n242, n243, n244, n245, n246, n247,
         n248, n249, n250, n251, n252, n253, n254, n255, n256, n257, n258,
         n259, n260, n261, n262, n263, n264, n265, n266, n267, n268, n269,
         n270, n271, n272, n273, n274, n275, n276, n277, n278, n279, n280,
         n281, n282, n283, n284, n285, n286, n287, n288, n289, n290, n291,
         n292, n293, n294, n295, n296, n297, n298, n299, n300, n301, n302,
         n303, n304, n305, n306, n307, n308, n309, n310, n311, n312, n313,
         n314, n315, n316, n317, n318, n319, n320, n321, n322, n323, n324,
         n325, n326, n327, n328, n329, n330, n331, n332, n333, n334, n335,
         n336, n337, n338, n339, n340, n341, n342, n343, n344, n345, n346,
         n347, n348, n349, n350, n351, n352, n353, n354, n355, n356, n357,
         n358, n359, n360, n361, n362, n363, n364, n365, n366, n367, n368,
         n369, n370, n371, n372, n373, n374, n375, n376, n377, n378, n379,
         n380, n381, n382, n383, n384, n385, n386, n387, n388, n389, n390,
         n391, n392, n393, n394, n395, n396, n397, n398, n399, n400, n401,
         n402, n403, n404, n405, n406, n407, n408, n409, n410, n411, n412,
         n413, n414, n415, n416, n417, n418, n419, n420, n421, n422, n423,
         n424, n425, n426, n427, n428, n429, n430, n431, n432, n433, n434,
         n435, n436, n437, n438, n439, n440, n441, n442, n443, n444, n445,
         n446, n447, n448, n449, n450, n451, n452, n453, n454, n455, n456,
         n457, n458, n459, n460, n461, n462, n463, n464, n465, n466, n467,
         n468, n469, n470, n471, n472, n473, n474, n475, n476, n477, n478,
         n479, n480, n481, n482, n483, n484, n485, n486, n487, n488, n489,
         n490, n491, n492, add_55_carry_4_, n493, n494, n495, n496, n497, n498,
         n499, n500, n501, n502, n503, n504, n505, n506, n507, n508, n509,
         n510, n511, n512, n513, n514, n515, n516, n517, n518, n519, n520,
         n521, n522, n523, n524, n525, n526, n527, n528, n529, n530, n531,
         n532, n533, n534, n535, n536, n537, n538, n539, n540, n541, n542,
         n543, n544, n545, n546, n547, n548, n549, n550, n551, n552, n553,
         n554, n555, n556, n557, n558, n559, n560, n561, n562, n563, n564,
         n565, n566, n567, n568, n569, n570, n571, n572, n573, n574, n575,
         n576, n577, n578, n579, n580, n581, n582, n583, n584, n585, n586,
         n587, n588, n589, n590, n591, n592, n593, n594, n595, n596, n597,
         n598, n599, n600, n601, n602, n603, n604, n605, n606, n607, n608,
         n609, n610, n611, n612, n613, n614, n615, n616, n617, n618, n619,
         n620, n621, n622, n623, n624, n625, n626, n627, n628, n629, n630,
         n631, n632, n633, n634, n635, n636, n637, n638, n639, n640, n641,
         n642, n643, n644, n645, n646, n647, n648, n649, n650, n651, n652,
         n653, n654, n655, n656, n657, n658, n659, n660, n661, n662, n663,
         n664, n665, n666, n667, n668, n669, n670, n671, n672, n673, n674,
         n675, n676, n677, n678, n679, n680, n681, n682, n683, n684, n685,
         n686, n687, n688, n689, n690, n691, n692, n693, n694, n695, n696,
         n697, n698, n699, n700, n701, n702, n703, n704, n705, n706, n707,
         n708, n709, n710, n711, n712, n713, n714, n715, n716, n717, n718,
         n719, n720, n721, n722, n723, n724, n725, n726, n727, n728, n729,
         n730, n731, n732, n733, n734, n735, n736, n737, n738, n739, n740,
         n741, n742, n743, n744, n745, n746, n747, n748, n749, n750, n751,
         n752, n753, n754, n755, n756, n757, n758, n759, n760, n761, n762,
         n763, n764, n765, n766, n767, n768, n769, n770, n771, n772, n773,
         n774, n775, n776, n777, n778, n779, n780, n781, n782, n783, n784,
         n785, n786, n787, n788, n789, n790, n791, n792, n793, n794, n795,
         n796, n797, n798, n799, n800, n801, n802, n803, n804, n805, n806,
         n807, n808, n809, n810, n811, n813, n814, n816, n817, n818, n819;
  wire   [4:0] rd_ptr_ss;
  wire   [4:0] rd_ptr_ss_bin;
  wire   [4:0] wr_ptr_ss;
  wire   [4:0] wr_ptr_ss_bin;
  wire   [4:0] rd_ptr;
  wire   [4:0] wr_ptr;
  wire   [4:0] wr_ptr_bin;
  wire   [4:0] wr_ptr_bin_p1;
  wire   [4:1] rd_ptr_bin_p1;
  wire   [4:0] wr_ptr_p1;
  wire   [4:0] rd_ptr_p1;
  wire   [4:0] diff;
  wire   [4:0] rd_ptr_s;
  wire   [127:0] mem;
  wire   [4:0] wr_ptr_s;
  wire   [4:1] sub_38_carry;
  wire   [4:2] add_35_carry;
  wire   [4:2] add_34_carry;

  DFFPOSX1 rd_ptr_reg_0_ ( .D(n492), .CLK(rclk), .Q(rd_ptr[0]) );
  DFFPOSX1 rd_ptr_s_reg_0_ ( .D(n633), .CLK(wclk), .Q(rd_ptr_s[0]) );
  DFFPOSX1 rd_ptr_ss_reg_0_ ( .D(n51), .CLK(wclk), .Q(rd_ptr_ss[0]) );
  DFFPOSX1 FULL_reg ( .D(n614), .CLK(wclk), .Q(FULL) );
  DFFPOSX1 wr_ptr_reg_4_ ( .D(n797), .CLK(wclk), .Q(wr_ptr[4]) );
  DFFPOSX1 mem_reg_7__7_ ( .D(n424), .CLK(wclk), .Q(mem[63]) );
  DFFPOSX1 mem_reg_7__6_ ( .D(n425), .CLK(wclk), .Q(mem[62]) );
  DFFPOSX1 mem_reg_7__5_ ( .D(n426), .CLK(wclk), .Q(mem[61]) );
  DFFPOSX1 mem_reg_7__4_ ( .D(n427), .CLK(wclk), .Q(mem[60]) );
  DFFPOSX1 mem_reg_7__3_ ( .D(n428), .CLK(wclk), .Q(mem[59]) );
  DFFPOSX1 mem_reg_7__2_ ( .D(n429), .CLK(wclk), .Q(mem[58]) );
  DFFPOSX1 mem_reg_7__1_ ( .D(n430), .CLK(wclk), .Q(mem[57]) );
  DFFPOSX1 mem_reg_7__0_ ( .D(n431), .CLK(wclk), .Q(mem[56]) );
  DFFPOSX1 mem_reg_5__7_ ( .D(n440), .CLK(wclk), .Q(mem[47]) );
  DFFPOSX1 mem_reg_5__6_ ( .D(n441), .CLK(wclk), .Q(mem[46]) );
  DFFPOSX1 mem_reg_5__5_ ( .D(n442), .CLK(wclk), .Q(mem[45]) );
  DFFPOSX1 mem_reg_5__4_ ( .D(n443), .CLK(wclk), .Q(mem[44]) );
  DFFPOSX1 mem_reg_5__3_ ( .D(n444), .CLK(wclk), .Q(mem[43]) );
  DFFPOSX1 mem_reg_5__2_ ( .D(n445), .CLK(wclk), .Q(mem[42]) );
  DFFPOSX1 mem_reg_5__1_ ( .D(n446), .CLK(wclk), .Q(mem[41]) );
  DFFPOSX1 mem_reg_5__0_ ( .D(n447), .CLK(wclk), .Q(mem[40]) );
  DFFPOSX1 mem_reg_3__7_ ( .D(n456), .CLK(wclk), .Q(mem[31]) );
  DFFPOSX1 mem_reg_3__6_ ( .D(n457), .CLK(wclk), .Q(mem[30]) );
  DFFPOSX1 mem_reg_3__5_ ( .D(n458), .CLK(wclk), .Q(mem[29]) );
  DFFPOSX1 mem_reg_3__4_ ( .D(n459), .CLK(wclk), .Q(mem[28]) );
  DFFPOSX1 mem_reg_3__3_ ( .D(n460), .CLK(wclk), .Q(mem[27]) );
  DFFPOSX1 mem_reg_3__2_ ( .D(n461), .CLK(wclk), .Q(mem[26]) );
  DFFPOSX1 mem_reg_3__1_ ( .D(n462), .CLK(wclk), .Q(mem[25]) );
  DFFPOSX1 mem_reg_3__0_ ( .D(n463), .CLK(wclk), .Q(mem[24]) );
  DFFPOSX1 mem_reg_1__7_ ( .D(n472), .CLK(wclk), .Q(mem[15]) );
  DFFPOSX1 mem_reg_1__6_ ( .D(n473), .CLK(wclk), .Q(mem[14]) );
  DFFPOSX1 mem_reg_1__5_ ( .D(n474), .CLK(wclk), .Q(mem[13]) );
  DFFPOSX1 mem_reg_1__4_ ( .D(n475), .CLK(wclk), .Q(mem[12]) );
  DFFPOSX1 mem_reg_1__3_ ( .D(n476), .CLK(wclk), .Q(mem[11]) );
  DFFPOSX1 mem_reg_1__2_ ( .D(n477), .CLK(wclk), .Q(mem[10]) );
  DFFPOSX1 mem_reg_1__1_ ( .D(n478), .CLK(wclk), .Q(mem[9]) );
  DFFPOSX1 mem_reg_1__0_ ( .D(n479), .CLK(wclk), .Q(mem[8]) );
  DFFPOSX1 mem_reg_6__7_ ( .D(n432), .CLK(wclk), .Q(mem[55]) );
  DFFPOSX1 mem_reg_6__6_ ( .D(n433), .CLK(wclk), .Q(mem[54]) );
  DFFPOSX1 mem_reg_6__5_ ( .D(n434), .CLK(wclk), .Q(mem[53]) );
  DFFPOSX1 mem_reg_6__4_ ( .D(n435), .CLK(wclk), .Q(mem[52]) );
  DFFPOSX1 mem_reg_6__3_ ( .D(n436), .CLK(wclk), .Q(mem[51]) );
  DFFPOSX1 mem_reg_6__2_ ( .D(n437), .CLK(wclk), .Q(mem[50]) );
  DFFPOSX1 mem_reg_6__1_ ( .D(n438), .CLK(wclk), .Q(mem[49]) );
  DFFPOSX1 mem_reg_6__0_ ( .D(n439), .CLK(wclk), .Q(mem[48]) );
  DFFPOSX1 mem_reg_4__7_ ( .D(n448), .CLK(wclk), .Q(mem[39]) );
  DFFPOSX1 mem_reg_4__6_ ( .D(n449), .CLK(wclk), .Q(mem[38]) );
  DFFPOSX1 mem_reg_4__5_ ( .D(n450), .CLK(wclk), .Q(mem[37]) );
  DFFPOSX1 mem_reg_4__4_ ( .D(n451), .CLK(wclk), .Q(mem[36]) );
  DFFPOSX1 mem_reg_4__3_ ( .D(n452), .CLK(wclk), .Q(mem[35]) );
  DFFPOSX1 mem_reg_4__2_ ( .D(n453), .CLK(wclk), .Q(mem[34]) );
  DFFPOSX1 mem_reg_4__1_ ( .D(n454), .CLK(wclk), .Q(mem[33]) );
  DFFPOSX1 mem_reg_4__0_ ( .D(n455), .CLK(wclk), .Q(mem[32]) );
  DFFPOSX1 mem_reg_2__7_ ( .D(n464), .CLK(wclk), .Q(mem[23]) );
  DFFPOSX1 mem_reg_2__6_ ( .D(n465), .CLK(wclk), .Q(mem[22]) );
  DFFPOSX1 mem_reg_2__5_ ( .D(n466), .CLK(wclk), .Q(mem[21]) );
  DFFPOSX1 mem_reg_2__4_ ( .D(n467), .CLK(wclk), .Q(mem[20]) );
  DFFPOSX1 mem_reg_2__3_ ( .D(n468), .CLK(wclk), .Q(mem[19]) );
  DFFPOSX1 mem_reg_2__2_ ( .D(n469), .CLK(wclk), .Q(mem[18]) );
  DFFPOSX1 mem_reg_2__1_ ( .D(n470), .CLK(wclk), .Q(mem[17]) );
  DFFPOSX1 mem_reg_2__0_ ( .D(n471), .CLK(wclk), .Q(mem[16]) );
  DFFPOSX1 mem_reg_0__7_ ( .D(n480), .CLK(wclk), .Q(mem[7]) );
  DFFPOSX1 mem_reg_0__6_ ( .D(n481), .CLK(wclk), .Q(mem[6]) );
  DFFPOSX1 mem_reg_0__5_ ( .D(n482), .CLK(wclk), .Q(mem[5]) );
  DFFPOSX1 mem_reg_0__4_ ( .D(n483), .CLK(wclk), .Q(mem[4]) );
  DFFPOSX1 mem_reg_0__3_ ( .D(n484), .CLK(wclk), .Q(mem[3]) );
  DFFPOSX1 mem_reg_0__2_ ( .D(n485), .CLK(wclk), .Q(mem[2]) );
  DFFPOSX1 mem_reg_0__1_ ( .D(n486), .CLK(wclk), .Q(mem[1]) );
  DFFPOSX1 mem_reg_0__0_ ( .D(n487), .CLK(wclk), .Q(mem[0]) );
  DFFPOSX1 mem_reg_15__7_ ( .D(n360), .CLK(wclk), .Q(mem[127]) );
  DFFPOSX1 mem_reg_15__6_ ( .D(n361), .CLK(wclk), .Q(mem[126]) );
  DFFPOSX1 mem_reg_15__5_ ( .D(n362), .CLK(wclk), .Q(mem[125]) );
  DFFPOSX1 mem_reg_15__4_ ( .D(n363), .CLK(wclk), .Q(mem[124]) );
  DFFPOSX1 mem_reg_15__3_ ( .D(n364), .CLK(wclk), .Q(mem[123]) );
  DFFPOSX1 mem_reg_15__2_ ( .D(n365), .CLK(wclk), .Q(mem[122]) );
  DFFPOSX1 mem_reg_15__1_ ( .D(n366), .CLK(wclk), .Q(mem[121]) );
  DFFPOSX1 mem_reg_15__0_ ( .D(n367), .CLK(wclk), .Q(mem[120]) );
  DFFPOSX1 mem_reg_13__7_ ( .D(n376), .CLK(wclk), .Q(mem[111]) );
  DFFPOSX1 mem_reg_13__6_ ( .D(n377), .CLK(wclk), .Q(mem[110]) );
  DFFPOSX1 mem_reg_13__5_ ( .D(n378), .CLK(wclk), .Q(mem[109]) );
  DFFPOSX1 mem_reg_13__4_ ( .D(n379), .CLK(wclk), .Q(mem[108]) );
  DFFPOSX1 mem_reg_13__3_ ( .D(n380), .CLK(wclk), .Q(mem[107]) );
  DFFPOSX1 mem_reg_13__2_ ( .D(n381), .CLK(wclk), .Q(mem[106]) );
  DFFPOSX1 mem_reg_13__1_ ( .D(n382), .CLK(wclk), .Q(mem[105]) );
  DFFPOSX1 mem_reg_13__0_ ( .D(n383), .CLK(wclk), .Q(mem[104]) );
  DFFPOSX1 mem_reg_11__7_ ( .D(n392), .CLK(wclk), .Q(mem[95]) );
  DFFPOSX1 mem_reg_11__6_ ( .D(n393), .CLK(wclk), .Q(mem[94]) );
  DFFPOSX1 mem_reg_11__5_ ( .D(n394), .CLK(wclk), .Q(mem[93]) );
  DFFPOSX1 mem_reg_11__4_ ( .D(n395), .CLK(wclk), .Q(mem[92]) );
  DFFPOSX1 mem_reg_11__3_ ( .D(n396), .CLK(wclk), .Q(mem[91]) );
  DFFPOSX1 mem_reg_11__2_ ( .D(n397), .CLK(wclk), .Q(mem[90]) );
  DFFPOSX1 mem_reg_11__1_ ( .D(n398), .CLK(wclk), .Q(mem[89]) );
  DFFPOSX1 mem_reg_11__0_ ( .D(n399), .CLK(wclk), .Q(mem[88]) );
  DFFPOSX1 mem_reg_9__7_ ( .D(n408), .CLK(wclk), .Q(mem[79]) );
  DFFPOSX1 mem_reg_9__6_ ( .D(n409), .CLK(wclk), .Q(mem[78]) );
  DFFPOSX1 mem_reg_9__5_ ( .D(n410), .CLK(wclk), .Q(mem[77]) );
  DFFPOSX1 mem_reg_9__4_ ( .D(n411), .CLK(wclk), .Q(mem[76]) );
  DFFPOSX1 mem_reg_9__3_ ( .D(n412), .CLK(wclk), .Q(mem[75]) );
  DFFPOSX1 mem_reg_9__2_ ( .D(n413), .CLK(wclk), .Q(mem[74]) );
  DFFPOSX1 mem_reg_9__1_ ( .D(n414), .CLK(wclk), .Q(mem[73]) );
  DFFPOSX1 mem_reg_9__0_ ( .D(n415), .CLK(wclk), .Q(mem[72]) );
  DFFPOSX1 mem_reg_14__7_ ( .D(n368), .CLK(wclk), .Q(mem[119]) );
  DFFPOSX1 mem_reg_14__6_ ( .D(n369), .CLK(wclk), .Q(mem[118]) );
  DFFPOSX1 mem_reg_14__5_ ( .D(n370), .CLK(wclk), .Q(mem[117]) );
  DFFPOSX1 mem_reg_14__4_ ( .D(n371), .CLK(wclk), .Q(mem[116]) );
  DFFPOSX1 mem_reg_14__3_ ( .D(n372), .CLK(wclk), .Q(mem[115]) );
  DFFPOSX1 mem_reg_14__2_ ( .D(n373), .CLK(wclk), .Q(mem[114]) );
  DFFPOSX1 mem_reg_14__1_ ( .D(n374), .CLK(wclk), .Q(mem[113]) );
  DFFPOSX1 mem_reg_14__0_ ( .D(n375), .CLK(wclk), .Q(mem[112]) );
  DFFPOSX1 mem_reg_12__7_ ( .D(n384), .CLK(wclk), .Q(mem[103]) );
  DFFPOSX1 mem_reg_12__6_ ( .D(n385), .CLK(wclk), .Q(mem[102]) );
  DFFPOSX1 mem_reg_12__5_ ( .D(n386), .CLK(wclk), .Q(mem[101]) );
  DFFPOSX1 mem_reg_12__4_ ( .D(n387), .CLK(wclk), .Q(mem[100]) );
  DFFPOSX1 mem_reg_12__3_ ( .D(n388), .CLK(wclk), .Q(mem[99]) );
  DFFPOSX1 mem_reg_12__2_ ( .D(n389), .CLK(wclk), .Q(mem[98]) );
  DFFPOSX1 mem_reg_12__1_ ( .D(n390), .CLK(wclk), .Q(mem[97]) );
  DFFPOSX1 mem_reg_12__0_ ( .D(n391), .CLK(wclk), .Q(mem[96]) );
  DFFPOSX1 mem_reg_10__7_ ( .D(n400), .CLK(wclk), .Q(mem[87]) );
  DFFPOSX1 mem_reg_10__6_ ( .D(n401), .CLK(wclk), .Q(mem[86]) );
  DFFPOSX1 mem_reg_10__5_ ( .D(n402), .CLK(wclk), .Q(mem[85]) );
  DFFPOSX1 mem_reg_10__4_ ( .D(n403), .CLK(wclk), .Q(mem[84]) );
  DFFPOSX1 mem_reg_10__3_ ( .D(n404), .CLK(wclk), .Q(mem[83]) );
  DFFPOSX1 mem_reg_10__2_ ( .D(n405), .CLK(wclk), .Q(mem[82]) );
  DFFPOSX1 mem_reg_10__1_ ( .D(n406), .CLK(wclk), .Q(mem[81]) );
  DFFPOSX1 mem_reg_10__0_ ( .D(n407), .CLK(wclk), .Q(mem[80]) );
  DFFPOSX1 mem_reg_8__7_ ( .D(n416), .CLK(wclk), .Q(mem[71]) );
  DFFPOSX1 mem_reg_8__6_ ( .D(n417), .CLK(wclk), .Q(mem[70]) );
  DFFPOSX1 mem_reg_8__5_ ( .D(n418), .CLK(wclk), .Q(mem[69]) );
  DFFPOSX1 mem_reg_8__4_ ( .D(n419), .CLK(wclk), .Q(mem[68]) );
  DFFPOSX1 mem_reg_8__3_ ( .D(n420), .CLK(wclk), .Q(mem[67]) );
  DFFPOSX1 mem_reg_8__2_ ( .D(n421), .CLK(wclk), .Q(mem[66]) );
  DFFPOSX1 mem_reg_8__1_ ( .D(n422), .CLK(wclk), .Q(mem[65]) );
  DFFPOSX1 mem_reg_8__0_ ( .D(n423), .CLK(wclk), .Q(mem[64]) );
  DFFPOSX1 wr_ptr_reg_0_ ( .D(n798), .CLK(wclk), .Q(wr_ptr[0]) );
  DFFPOSX1 wr_ptr_s_reg_0_ ( .D(n85), .CLK(rclk), .Q(wr_ptr_s[0]) );
  DFFPOSX1 wr_ptr_ss_reg_0_ ( .D(n90), .CLK(rclk), .Q(wr_ptr_ss[0]) );
  DFFPOSX1 wr_ptr_reg_1_ ( .D(n799), .CLK(wclk), .Q(wr_ptr[1]) );
  DFFPOSX1 wr_ptr_s_reg_1_ ( .D(n86), .CLK(rclk), .Q(wr_ptr_s[1]) );
  DFFPOSX1 wr_ptr_ss_reg_1_ ( .D(n91), .CLK(rclk), .Q(wr_ptr_ss[1]) );
  DFFPOSX1 wr_ptr_reg_2_ ( .D(n800), .CLK(wclk), .Q(wr_ptr[2]) );
  DFFPOSX1 wr_ptr_s_reg_2_ ( .D(n87), .CLK(rclk), .Q(wr_ptr_s[2]) );
  DFFPOSX1 wr_ptr_ss_reg_2_ ( .D(n92), .CLK(rclk), .Q(wr_ptr_ss[2]) );
  DFFPOSX1 wr_ptr_reg_3_ ( .D(n801), .CLK(wclk), .Q(wr_ptr[3]) );
  DFFPOSX1 wr_ptr_s_reg_3_ ( .D(n88), .CLK(rclk), .Q(wr_ptr_s[3]) );
  DFFPOSX1 wr_ptr_ss_reg_3_ ( .D(n93), .CLK(rclk), .Q(wr_ptr_ss[3]) );
  DFFPOSX1 wr_ptr_s_reg_4_ ( .D(n89), .CLK(rclk), .Q(wr_ptr_s[4]) );
  DFFPOSX1 wr_ptr_ss_reg_4_ ( .D(n94), .CLK(rclk), .Q(wr_ptr_ss[4]) );
  DFFPOSX1 EMPTY_reg ( .D(n95), .CLK(rclk), .Q(EMPTY) );
  DFFPOSX1 rd_ptr_reg_4_ ( .D(n491), .CLK(rclk), .Q(rd_ptr[4]) );
  DFFPOSX1 rd_ptr_reg_1_ ( .D(n490), .CLK(rclk), .Q(rd_ptr[1]) );
  DFFPOSX1 rd_ptr_s_reg_1_ ( .D(n634), .CLK(wclk), .Q(rd_ptr_s[1]) );
  DFFPOSX1 rd_ptr_ss_reg_1_ ( .D(n52), .CLK(wclk), .Q(rd_ptr_ss[1]) );
  DFFPOSX1 rd_ptr_reg_2_ ( .D(n489), .CLK(rclk), .Q(rd_ptr[2]) );
  DFFPOSX1 rd_ptr_s_reg_2_ ( .D(n635), .CLK(wclk), .Q(rd_ptr_s[2]) );
  DFFPOSX1 rd_ptr_ss_reg_2_ ( .D(n53), .CLK(wclk), .Q(rd_ptr_ss[2]) );
  DFFPOSX1 rd_ptr_reg_3_ ( .D(n488), .CLK(rclk), .Q(rd_ptr[3]) );
  DFFPOSX1 rd_ptr_s_reg_3_ ( .D(n636), .CLK(wclk), .Q(rd_ptr_s[3]) );
  DFFPOSX1 rd_ptr_ss_reg_3_ ( .D(n54), .CLK(wclk), .Q(rd_ptr_ss[3]) );
  DFFPOSX1 rd_ptr_s_reg_4_ ( .D(n637), .CLK(wclk), .Q(rd_ptr_s[4]) );
  DFFPOSX1 rd_ptr_ss_reg_4_ ( .D(n55), .CLK(wclk), .Q(rd_ptr_ss[4]) );
  OAI21X1 U64 ( .A(n172), .B(n803), .C(n638), .Y(n360) );
  OAI21X1 U66 ( .A(n172), .B(n804), .C(n616), .Y(n361) );
  OAI21X1 U68 ( .A(n172), .B(n805), .C(n605), .Y(n362) );
  OAI21X1 U70 ( .A(n172), .B(n806), .C(n596), .Y(n363) );
  OAI21X1 U72 ( .A(n172), .B(n807), .C(n587), .Y(n364) );
  OAI21X1 U74 ( .A(n172), .B(n808), .C(n579), .Y(n365) );
  OAI21X1 U76 ( .A(n172), .B(n809), .C(n570), .Y(n366) );
  OAI21X1 U78 ( .A(n172), .B(n810), .C(n562), .Y(n367) );
  OAI21X1 U81 ( .A(n803), .B(n183), .C(n591), .Y(n368) );
  OAI21X1 U83 ( .A(n804), .B(n183), .C(n583), .Y(n369) );
  OAI21X1 U85 ( .A(n805), .B(n183), .C(n574), .Y(n370) );
  OAI21X1 U87 ( .A(n806), .B(n183), .C(n566), .Y(n371) );
  OAI21X1 U89 ( .A(n807), .B(n183), .C(n642), .Y(n372) );
  OAI21X1 U91 ( .A(n808), .B(n183), .C(n620), .Y(n373) );
  OAI21X1 U93 ( .A(n809), .B(n183), .C(n609), .Y(n374) );
  OAI21X1 U95 ( .A(n810), .B(n183), .C(n600), .Y(n375) );
  OAI21X1 U98 ( .A(n803), .B(n193), .C(n617), .Y(n376) );
  OAI21X1 U100 ( .A(n804), .B(n193), .C(n639), .Y(n377) );
  OAI21X1 U102 ( .A(n805), .B(n193), .C(n597), .Y(n378) );
  OAI21X1 U104 ( .A(n806), .B(n193), .C(n606), .Y(n379) );
  OAI21X1 U106 ( .A(n807), .B(n193), .C(n580), .Y(n380) );
  OAI21X1 U108 ( .A(n808), .B(n193), .C(n588), .Y(n381) );
  OAI21X1 U110 ( .A(n809), .B(n193), .C(n563), .Y(n382) );
  OAI21X1 U112 ( .A(n810), .B(n193), .C(n571), .Y(n383) );
  OAI21X1 U115 ( .A(n803), .B(n203), .C(n584), .Y(n384) );
  OAI21X1 U117 ( .A(n804), .B(n203), .C(n592), .Y(n385) );
  OAI21X1 U119 ( .A(n805), .B(n203), .C(n567), .Y(n386) );
  OAI21X1 U121 ( .A(n806), .B(n203), .C(n575), .Y(n387) );
  OAI21X1 U123 ( .A(n807), .B(n203), .C(n621), .Y(n388) );
  OAI21X1 U125 ( .A(n808), .B(n203), .C(n643), .Y(n389) );
  OAI21X1 U127 ( .A(n809), .B(n203), .C(n601), .Y(n390) );
  OAI21X1 U129 ( .A(n810), .B(n203), .C(n610), .Y(n391) );
  OAI21X1 U132 ( .A(n803), .B(n212), .C(n607), .Y(n392) );
  OAI21X1 U134 ( .A(n804), .B(n212), .C(n598), .Y(n393) );
  OAI21X1 U136 ( .A(n805), .B(n212), .C(n640), .Y(n394) );
  OAI21X1 U138 ( .A(n806), .B(n212), .C(n618), .Y(n395) );
  OAI21X1 U140 ( .A(n807), .B(n212), .C(n572), .Y(n396) );
  OAI21X1 U142 ( .A(n808), .B(n212), .C(n564), .Y(n397) );
  OAI21X1 U144 ( .A(n809), .B(n212), .C(n589), .Y(n398) );
  OAI21X1 U146 ( .A(n810), .B(n212), .C(n581), .Y(n399) );
  OAI21X1 U149 ( .A(n803), .B(n222), .C(n576), .Y(n400) );
  OAI21X1 U151 ( .A(n804), .B(n222), .C(n568), .Y(n401) );
  OAI21X1 U153 ( .A(n805), .B(n222), .C(n593), .Y(n402) );
  OAI21X1 U155 ( .A(n806), .B(n222), .C(n585), .Y(n403) );
  OAI21X1 U157 ( .A(n807), .B(n222), .C(n611), .Y(n404) );
  OAI21X1 U159 ( .A(n808), .B(n222), .C(n602), .Y(n405) );
  OAI21X1 U161 ( .A(n809), .B(n222), .C(n644), .Y(n406) );
  OAI21X1 U163 ( .A(n810), .B(n222), .C(n622), .Y(n407) );
  OAI21X1 U166 ( .A(n803), .B(n231), .C(n599), .Y(n408) );
  OAI21X1 U168 ( .A(n804), .B(n231), .C(n608), .Y(n409) );
  OAI21X1 U170 ( .A(n805), .B(n231), .C(n619), .Y(n410) );
  OAI21X1 U172 ( .A(n806), .B(n231), .C(n641), .Y(n411) );
  OAI21X1 U174 ( .A(n807), .B(n231), .C(n565), .Y(n412) );
  OAI21X1 U176 ( .A(n808), .B(n231), .C(n573), .Y(n413) );
  OAI21X1 U178 ( .A(n809), .B(n231), .C(n582), .Y(n414) );
  OAI21X1 U180 ( .A(n810), .B(n231), .C(n590), .Y(n415) );
  OAI21X1 U183 ( .A(n803), .B(n242), .C(n569), .Y(n416) );
  OAI21X1 U185 ( .A(n804), .B(n242), .C(n577), .Y(n417) );
  OAI21X1 U187 ( .A(n805), .B(n242), .C(n586), .Y(n418) );
  OAI21X1 U189 ( .A(n806), .B(n242), .C(n594), .Y(n419) );
  OAI21X1 U191 ( .A(n807), .B(n242), .C(n603), .Y(n420) );
  OAI21X1 U193 ( .A(n808), .B(n242), .C(n612), .Y(n421) );
  OAI21X1 U195 ( .A(n809), .B(n242), .C(n623), .Y(n422) );
  OAI21X1 U197 ( .A(n810), .B(n242), .C(n645), .Y(n423) );
  OAI21X1 U200 ( .A(n803), .B(n252), .C(n554), .Y(n424) );
  OAI21X1 U202 ( .A(n804), .B(n252), .C(n553), .Y(n425) );
  OAI21X1 U204 ( .A(n805), .B(n252), .C(n552), .Y(n426) );
  OAI21X1 U206 ( .A(n806), .B(n252), .C(n551), .Y(n427) );
  OAI21X1 U208 ( .A(n807), .B(n252), .C(n550), .Y(n428) );
  OAI21X1 U210 ( .A(n808), .B(n252), .C(n549), .Y(n429) );
  OAI21X1 U212 ( .A(n809), .B(n252), .C(n548), .Y(n430) );
  OAI21X1 U214 ( .A(n810), .B(n252), .C(n547), .Y(n431) );
  OAI21X1 U217 ( .A(n803), .B(n262), .C(n546), .Y(n432) );
  OAI21X1 U219 ( .A(n804), .B(n262), .C(n545), .Y(n433) );
  OAI21X1 U221 ( .A(n805), .B(n262), .C(n544), .Y(n434) );
  OAI21X1 U223 ( .A(n806), .B(n262), .C(n543), .Y(n435) );
  OAI21X1 U225 ( .A(n807), .B(n262), .C(n558), .Y(n436) );
  OAI21X1 U227 ( .A(n808), .B(n262), .C(n542), .Y(n437) );
  OAI21X1 U229 ( .A(n809), .B(n262), .C(n541), .Y(n438) );
  OAI21X1 U231 ( .A(n810), .B(n262), .C(n540), .Y(n439) );
  OAI21X1 U234 ( .A(n803), .B(n272), .C(n539), .Y(n440) );
  OAI21X1 U236 ( .A(n804), .B(n272), .C(n555), .Y(n441) );
  OAI21X1 U238 ( .A(n805), .B(n272), .C(n538), .Y(n442) );
  OAI21X1 U240 ( .A(n806), .B(n272), .C(n537), .Y(n443) );
  OAI21X1 U242 ( .A(n807), .B(n272), .C(n536), .Y(n444) );
  OAI21X1 U244 ( .A(n808), .B(n272), .C(n535), .Y(n445) );
  OAI21X1 U246 ( .A(n809), .B(n272), .C(n534), .Y(n446) );
  OAI21X1 U248 ( .A(n810), .B(n272), .C(n533), .Y(n447) );
  OAI21X1 U251 ( .A(n803), .B(n281), .C(n532), .Y(n448) );
  OAI21X1 U253 ( .A(n804), .B(n281), .C(n531), .Y(n449) );
  OAI21X1 U255 ( .A(n805), .B(n281), .C(n530), .Y(n450) );
  OAI21X1 U257 ( .A(n806), .B(n281), .C(n529), .Y(n451) );
  OAI21X1 U259 ( .A(n807), .B(n281), .C(n528), .Y(n452) );
  OAI21X1 U261 ( .A(n808), .B(n281), .C(n559), .Y(n453) );
  OAI21X1 U263 ( .A(n809), .B(n281), .C(n527), .Y(n454) );
  OAI21X1 U265 ( .A(n810), .B(n281), .C(n526), .Y(n455) );
  OAI21X1 U268 ( .A(n803), .B(n290), .C(n525), .Y(n456) );
  OAI21X1 U270 ( .A(n804), .B(n290), .C(n524), .Y(n457) );
  OAI21X1 U272 ( .A(n805), .B(n290), .C(n556), .Y(n458) );
  OAI21X1 U274 ( .A(n806), .B(n290), .C(n523), .Y(n459) );
  OAI21X1 U276 ( .A(n807), .B(n290), .C(n522), .Y(n460) );
  OAI21X1 U278 ( .A(n808), .B(n290), .C(n521), .Y(n461) );
  OAI21X1 U280 ( .A(n809), .B(n290), .C(n520), .Y(n462) );
  OAI21X1 U282 ( .A(n810), .B(n290), .C(n519), .Y(n463) );
  OAI21X1 U285 ( .A(n803), .B(n299), .C(n518), .Y(n464) );
  OAI21X1 U287 ( .A(n804), .B(n299), .C(n517), .Y(n465) );
  OAI21X1 U289 ( .A(n805), .B(n299), .C(n516), .Y(n466) );
  OAI21X1 U291 ( .A(n806), .B(n299), .C(n515), .Y(n467) );
  OAI21X1 U293 ( .A(n807), .B(n299), .C(n514), .Y(n468) );
  OAI21X1 U295 ( .A(n808), .B(n299), .C(n513), .Y(n469) );
  OAI21X1 U297 ( .A(n809), .B(n299), .C(n560), .Y(n470) );
  OAI21X1 U299 ( .A(n810), .B(n299), .C(n512), .Y(n471) );
  OAI21X1 U303 ( .A(n803), .B(n308), .C(n511), .Y(n472) );
  OAI21X1 U305 ( .A(n804), .B(n308), .C(n510), .Y(n473) );
  OAI21X1 U307 ( .A(n805), .B(n308), .C(n509), .Y(n474) );
  OAI21X1 U309 ( .A(n806), .B(n308), .C(n557), .Y(n475) );
  OAI21X1 U311 ( .A(n807), .B(n308), .C(n508), .Y(n476) );
  OAI21X1 U313 ( .A(n808), .B(n308), .C(n507), .Y(n477) );
  OAI21X1 U315 ( .A(n809), .B(n308), .C(n506), .Y(n478) );
  OAI21X1 U317 ( .A(n810), .B(n308), .C(n505), .Y(n479) );
  OAI21X1 U320 ( .A(n803), .B(n318), .C(n504), .Y(n480) );
  OAI21X1 U322 ( .A(n804), .B(n318), .C(n503), .Y(n481) );
  OAI21X1 U324 ( .A(n805), .B(n318), .C(n502), .Y(n482) );
  OAI21X1 U326 ( .A(n806), .B(n318), .C(n501), .Y(n483) );
  OAI21X1 U328 ( .A(n807), .B(n318), .C(n500), .Y(n484) );
  OAI21X1 U330 ( .A(n808), .B(n318), .C(n499), .Y(n485) );
  OAI21X1 U332 ( .A(n809), .B(n318), .C(n498), .Y(n486) );
  OAI21X1 U334 ( .A(n810), .B(n318), .C(n561), .Y(n487) );
  AOI22X1 U338 ( .A(wr_ptr_p1[3]), .B(n648), .C(wr_ptr[3]), .D(n329), .Y(n327)
         );
  AOI22X1 U339 ( .A(wr_ptr_p1[2]), .B(n648), .C(wr_ptr[2]), .D(n329), .Y(n330)
         );
  AOI22X1 U340 ( .A(wr_ptr_p1[1]), .B(n648), .C(wr_ptr[1]), .D(n329), .Y(n331)
         );
  AOI22X1 U341 ( .A(wr_ptr_p1[0]), .B(n648), .C(wr_ptr[0]), .D(n329), .Y(n332)
         );
  AOI22X1 U342 ( .A(wr_ptr_p1[4]), .B(n648), .C(wr_ptr[4]), .D(n329), .Y(n333)
         );
  OAI21X1 U344 ( .A(n649), .B(n819), .C(n624), .Y(n488) );
  OAI21X1 U346 ( .A(n649), .B(n818), .C(n613), .Y(n489) );
  OAI21X1 U348 ( .A(n649), .B(n817), .C(n604), .Y(n490) );
  OAI21X1 U350 ( .A(n649), .B(n816), .C(n595), .Y(n491) );
  OAI21X1 U352 ( .A(n649), .B(n811), .C(n578), .Y(n492) );
  OAI21X1 U355 ( .A(n626), .B(n625), .C(n627), .Y(n95) );
  AOI21X1 U356 ( .A(n345), .B(n346), .C(reset), .Y(n344) );
  NOR3X1 U357 ( .A(n347), .B(n788), .C(n348), .Y(n346) );
  XOR2X1 U358 ( .A(wr_ptr_ss[0]), .B(rd_ptr[0]), .Y(n348) );
  XOR2X1 U359 ( .A(wr_ptr_ss[2]), .B(rd_ptr[2]), .Y(n347) );
  NOR3X1 U360 ( .A(n349), .B(n350), .C(n351), .Y(n345) );
  XOR2X1 U361 ( .A(wr_ptr_ss[3]), .B(rd_ptr[3]), .Y(n351) );
  XOR2X1 U362 ( .A(wr_ptr_ss[4]), .B(rd_ptr[4]), .Y(n350) );
  XOR2X1 U363 ( .A(wr_ptr_ss[1]), .B(rd_ptr[1]), .Y(n349) );
  NAND3X1 U364 ( .A(n352), .B(n353), .C(n354), .Y(n343) );
  XNOR2X1 U365 ( .A(wr_ptr_ss_bin[1]), .B(rd_ptr_bin_p1[1]), .Y(n354) );
  XNOR2X1 U366 ( .A(wr_ptr_ss_bin[4]), .B(rd_ptr_bin_p1[4]), .Y(n353) );
  XNOR2X1 U367 ( .A(wr_ptr_ss_bin[3]), .B(rd_ptr_bin_p1[3]), .Y(n352) );
  NAND3X1 U368 ( .A(n355), .B(n788), .C(n356), .Y(n342) );
  XNOR2X1 U369 ( .A(wr_ptr_ss_bin[2]), .B(rd_ptr_bin_p1[2]), .Y(n356) );
  XNOR2X1 U370 ( .A(wr_ptr_ss_bin[0]), .B(n789), .Y(n355) );
  OAI21X1 U372 ( .A(n20), .B(n21), .C(n646), .Y(n358) );
  gray2bin_SIZE5_3 gb1 ( .gray(rd_ptr_ss), .bin(rd_ptr_ss_bin) );
  gray2bin_SIZE5_2 gb2 ( .gray(wr_ptr_ss), .bin(wr_ptr_ss_bin) );
  gray2bin_SIZE5_1 gb3 ( .gray(rd_ptr), .bin({rd_ptr_bin_4_, n17, n16, n15, 
        n14}) );
  gray2bin_SIZE5_0 gb4 ( .gray(wr_ptr), .bin(wr_ptr_bin) );
  bin2gray_SIZE5_1 bg1 ( .bin(wr_ptr_bin_p1), .gray(wr_ptr_p1) );
  bin2gray_SIZE5_0 bg2 ( .bin({rd_ptr_bin_p1, n789}), .gray(rd_ptr_p1) );
  HAX1 add_55_U1_1_4 ( .A(diff[4]), .B(n628), .YC(n21), .YS(n20) );
  FAX1 sub_38_U2_1 ( .A(wr_ptr_bin[1]), .B(n793), .C(sub_38_carry[1]), .YC(
        sub_38_carry[2]), .YS(diff[1]) );
  FAX1 sub_38_U2_2 ( .A(wr_ptr_bin[2]), .B(n792), .C(sub_38_carry[2]), .YC(
        sub_38_carry[3]), .YS(diff[2]) );
  FAX1 sub_38_U2_3 ( .A(wr_ptr_bin[3]), .B(n791), .C(sub_38_carry[3]), .YC(
        sub_38_carry[4]), .YS(diff[3]) );
  FAX1 sub_38_U2_4 ( .A(wr_ptr_bin[4]), .B(n790), .C(sub_38_carry[4]), .YC(), 
        .YS(diff[4]) );
  HAX1 add_35_U1_1_1 ( .A(n15), .B(n778), .YC(add_35_carry[2]), .YS(
        rd_ptr_bin_p1[1]) );
  HAX1 add_35_U1_1_2 ( .A(n16), .B(add_35_carry[2]), .YC(add_35_carry[3]), 
        .YS(rd_ptr_bin_p1[2]) );
  HAX1 add_35_U1_1_3 ( .A(n17), .B(add_35_carry[3]), .YC(add_35_carry[4]), 
        .YS(rd_ptr_bin_p1[3]) );
  HAX1 add_34_U1_1_1 ( .A(wr_ptr_bin[1]), .B(wr_ptr_bin[0]), .YC(
        add_34_carry[2]), .YS(wr_ptr_bin_p1[1]) );
  HAX1 add_34_U1_1_2 ( .A(wr_ptr_bin[2]), .B(add_34_carry[2]), .YC(
        add_34_carry[3]), .YS(wr_ptr_bin_p1[2]) );
  HAX1 add_34_U1_1_3 ( .A(wr_ptr_bin[3]), .B(add_34_carry[3]), .YC(
        add_34_carry[4]), .YS(wr_ptr_bin_p1[3]) );
  HAX1 add_34_U1_1_4 ( .A(wr_ptr_bin[4]), .B(add_34_carry[4]), .YC(), .YS(
        wr_ptr_bin_p1[4]) );
  AND2X1 U382 ( .A(wr_ptr_bin[3]), .B(n646), .Y(n241) );
  AND2X1 U383 ( .A(n646), .B(n813), .Y(n317) );
  OR2X1 U384 ( .A(n631), .B(reset), .Y(n251) );
  OR2X1 U385 ( .A(n629), .B(n630), .Y(add_55_carry_4_) );
  AND2X1 U386 ( .A(n647), .B(n192), .Y(n650) );
  AND2X1 U387 ( .A(n632), .B(n192), .Y(n651) );
  AND2X1 U388 ( .A(n647), .B(n182), .Y(n653) );
  AND2X1 U389 ( .A(n632), .B(n182), .Y(n654) );
  AND2X1 U390 ( .A(n271), .B(n647), .Y(n656) );
  AND2X1 U391 ( .A(n271), .B(n632), .Y(n657) );
  AND2X1 U392 ( .A(n261), .B(n647), .Y(n659) );
  AND2X1 U393 ( .A(n261), .B(n632), .Y(n660) );
  AND2X1 U394 ( .A(n615), .B(n358), .Y(n56) );
  BUFX2 U395 ( .A(n333), .Y(n493) );
  BUFX2 U396 ( .A(n332), .Y(n494) );
  BUFX2 U397 ( .A(n331), .Y(n495) );
  BUFX2 U398 ( .A(n330), .Y(n496) );
  BUFX2 U399 ( .A(n327), .Y(n497) );
  AND2X1 U400 ( .A(mem[1]), .B(n318), .Y(n325) );
  INVX1 U401 ( .A(n325), .Y(n498) );
  AND2X1 U402 ( .A(mem[2]), .B(n318), .Y(n324) );
  INVX1 U403 ( .A(n324), .Y(n499) );
  AND2X1 U404 ( .A(mem[3]), .B(n318), .Y(n323) );
  INVX1 U405 ( .A(n323), .Y(n500) );
  AND2X1 U406 ( .A(mem[4]), .B(n318), .Y(n322) );
  INVX1 U407 ( .A(n322), .Y(n501) );
  AND2X1 U408 ( .A(mem[5]), .B(n318), .Y(n321) );
  INVX1 U409 ( .A(n321), .Y(n502) );
  AND2X1 U410 ( .A(mem[6]), .B(n318), .Y(n320) );
  INVX1 U411 ( .A(n320), .Y(n503) );
  AND2X1 U412 ( .A(mem[7]), .B(n318), .Y(n319) );
  INVX1 U413 ( .A(n319), .Y(n504) );
  AND2X1 U414 ( .A(mem[8]), .B(n308), .Y(n316) );
  INVX1 U415 ( .A(n316), .Y(n505) );
  AND2X1 U416 ( .A(mem[9]), .B(n308), .Y(n315) );
  INVX1 U417 ( .A(n315), .Y(n506) );
  AND2X1 U418 ( .A(mem[10]), .B(n308), .Y(n314) );
  INVX1 U419 ( .A(n314), .Y(n507) );
  AND2X1 U420 ( .A(mem[11]), .B(n308), .Y(n313) );
  INVX1 U421 ( .A(n313), .Y(n508) );
  AND2X1 U422 ( .A(mem[13]), .B(n308), .Y(n311) );
  INVX1 U423 ( .A(n311), .Y(n509) );
  AND2X1 U424 ( .A(mem[14]), .B(n308), .Y(n310) );
  INVX1 U425 ( .A(n310), .Y(n510) );
  AND2X1 U426 ( .A(mem[15]), .B(n308), .Y(n309) );
  INVX1 U427 ( .A(n309), .Y(n511) );
  AND2X1 U428 ( .A(mem[16]), .B(n299), .Y(n307) );
  INVX1 U429 ( .A(n307), .Y(n512) );
  AND2X1 U430 ( .A(mem[18]), .B(n299), .Y(n305) );
  INVX1 U431 ( .A(n305), .Y(n513) );
  AND2X1 U432 ( .A(mem[19]), .B(n299), .Y(n304) );
  INVX1 U433 ( .A(n304), .Y(n514) );
  AND2X1 U434 ( .A(mem[20]), .B(n299), .Y(n303) );
  INVX1 U435 ( .A(n303), .Y(n515) );
  AND2X1 U436 ( .A(mem[21]), .B(n299), .Y(n302) );
  INVX1 U437 ( .A(n302), .Y(n516) );
  AND2X1 U438 ( .A(mem[22]), .B(n299), .Y(n301) );
  INVX1 U439 ( .A(n301), .Y(n517) );
  AND2X1 U440 ( .A(mem[23]), .B(n299), .Y(n300) );
  INVX1 U441 ( .A(n300), .Y(n518) );
  AND2X1 U442 ( .A(mem[24]), .B(n290), .Y(n298) );
  INVX1 U443 ( .A(n298), .Y(n519) );
  AND2X1 U444 ( .A(mem[25]), .B(n290), .Y(n297) );
  INVX1 U445 ( .A(n297), .Y(n520) );
  AND2X1 U446 ( .A(mem[26]), .B(n290), .Y(n296) );
  INVX1 U447 ( .A(n296), .Y(n521) );
  AND2X1 U448 ( .A(mem[27]), .B(n290), .Y(n295) );
  INVX1 U449 ( .A(n295), .Y(n522) );
  AND2X1 U450 ( .A(mem[28]), .B(n290), .Y(n294) );
  INVX1 U451 ( .A(n294), .Y(n523) );
  AND2X1 U452 ( .A(mem[30]), .B(n290), .Y(n292) );
  INVX1 U453 ( .A(n292), .Y(n524) );
  AND2X1 U454 ( .A(mem[31]), .B(n290), .Y(n291) );
  INVX1 U455 ( .A(n291), .Y(n525) );
  AND2X1 U456 ( .A(mem[32]), .B(n281), .Y(n289) );
  INVX1 U457 ( .A(n289), .Y(n526) );
  AND2X1 U458 ( .A(mem[33]), .B(n281), .Y(n288) );
  INVX1 U459 ( .A(n288), .Y(n527) );
  AND2X1 U460 ( .A(mem[35]), .B(n281), .Y(n286) );
  INVX1 U461 ( .A(n286), .Y(n528) );
  AND2X1 U462 ( .A(mem[36]), .B(n281), .Y(n285) );
  INVX1 U463 ( .A(n285), .Y(n529) );
  AND2X1 U464 ( .A(mem[37]), .B(n281), .Y(n284) );
  INVX1 U465 ( .A(n284), .Y(n530) );
  AND2X1 U466 ( .A(mem[38]), .B(n281), .Y(n283) );
  INVX1 U467 ( .A(n283), .Y(n531) );
  AND2X1 U468 ( .A(mem[39]), .B(n281), .Y(n282) );
  INVX1 U469 ( .A(n282), .Y(n532) );
  AND2X1 U470 ( .A(mem[40]), .B(n272), .Y(n280) );
  INVX1 U471 ( .A(n280), .Y(n533) );
  AND2X1 U472 ( .A(mem[41]), .B(n272), .Y(n279) );
  INVX1 U473 ( .A(n279), .Y(n534) );
  AND2X1 U474 ( .A(mem[42]), .B(n272), .Y(n278) );
  INVX1 U475 ( .A(n278), .Y(n535) );
  AND2X1 U476 ( .A(mem[43]), .B(n272), .Y(n277) );
  INVX1 U477 ( .A(n277), .Y(n536) );
  AND2X1 U478 ( .A(mem[44]), .B(n272), .Y(n276) );
  INVX1 U479 ( .A(n276), .Y(n537) );
  AND2X1 U480 ( .A(mem[45]), .B(n272), .Y(n275) );
  INVX1 U481 ( .A(n275), .Y(n538) );
  AND2X1 U482 ( .A(mem[47]), .B(n272), .Y(n273) );
  INVX1 U483 ( .A(n273), .Y(n539) );
  AND2X1 U484 ( .A(mem[48]), .B(n262), .Y(n270) );
  INVX1 U485 ( .A(n270), .Y(n540) );
  AND2X1 U486 ( .A(mem[49]), .B(n262), .Y(n269) );
  INVX1 U487 ( .A(n269), .Y(n541) );
  AND2X1 U488 ( .A(mem[50]), .B(n262), .Y(n268) );
  INVX1 U489 ( .A(n268), .Y(n542) );
  AND2X1 U490 ( .A(mem[52]), .B(n262), .Y(n266) );
  INVX1 U491 ( .A(n266), .Y(n543) );
  AND2X1 U492 ( .A(mem[53]), .B(n262), .Y(n265) );
  INVX1 U493 ( .A(n265), .Y(n544) );
  AND2X1 U494 ( .A(mem[54]), .B(n262), .Y(n264) );
  INVX1 U495 ( .A(n264), .Y(n545) );
  AND2X1 U496 ( .A(mem[55]), .B(n262), .Y(n263) );
  INVX1 U497 ( .A(n263), .Y(n546) );
  AND2X1 U498 ( .A(mem[56]), .B(n252), .Y(n260) );
  INVX1 U499 ( .A(n260), .Y(n547) );
  AND2X1 U500 ( .A(mem[57]), .B(n252), .Y(n259) );
  INVX1 U501 ( .A(n259), .Y(n548) );
  AND2X1 U502 ( .A(mem[58]), .B(n252), .Y(n258) );
  INVX1 U503 ( .A(n258), .Y(n549) );
  AND2X1 U504 ( .A(mem[59]), .B(n252), .Y(n257) );
  INVX1 U505 ( .A(n257), .Y(n550) );
  AND2X1 U506 ( .A(mem[60]), .B(n252), .Y(n256) );
  INVX1 U507 ( .A(n256), .Y(n551) );
  AND2X1 U508 ( .A(mem[61]), .B(n252), .Y(n255) );
  INVX1 U509 ( .A(n255), .Y(n552) );
  AND2X1 U510 ( .A(mem[62]), .B(n252), .Y(n254) );
  INVX1 U511 ( .A(n254), .Y(n553) );
  AND2X1 U512 ( .A(mem[63]), .B(n252), .Y(n253) );
  INVX1 U513 ( .A(n253), .Y(n554) );
  AND2X1 U514 ( .A(mem[46]), .B(n272), .Y(n274) );
  INVX1 U515 ( .A(n274), .Y(n555) );
  AND2X1 U516 ( .A(mem[29]), .B(n290), .Y(n293) );
  INVX1 U517 ( .A(n293), .Y(n556) );
  AND2X1 U518 ( .A(mem[12]), .B(n308), .Y(n312) );
  INVX1 U519 ( .A(n312), .Y(n557) );
  AND2X1 U520 ( .A(mem[51]), .B(n262), .Y(n267) );
  INVX1 U521 ( .A(n267), .Y(n558) );
  AND2X1 U522 ( .A(mem[34]), .B(n281), .Y(n287) );
  INVX1 U523 ( .A(n287), .Y(n559) );
  AND2X1 U524 ( .A(mem[17]), .B(n299), .Y(n306) );
  INVX1 U525 ( .A(n306), .Y(n560) );
  AND2X1 U526 ( .A(mem[0]), .B(n318), .Y(n326) );
  INVX1 U527 ( .A(n326), .Y(n561) );
  AND2X1 U528 ( .A(mem[120]), .B(n172), .Y(n180) );
  INVX1 U529 ( .A(n180), .Y(n562) );
  AND2X1 U530 ( .A(mem[105]), .B(n193), .Y(n200) );
  INVX1 U531 ( .A(n200), .Y(n563) );
  AND2X1 U532 ( .A(mem[90]), .B(n212), .Y(n218) );
  INVX1 U533 ( .A(n218), .Y(n564) );
  AND2X1 U534 ( .A(mem[75]), .B(n231), .Y(n236) );
  INVX1 U535 ( .A(n236), .Y(n565) );
  AND2X1 U536 ( .A(mem[116]), .B(n183), .Y(n187) );
  INVX1 U537 ( .A(n187), .Y(n566) );
  AND2X1 U538 ( .A(mem[101]), .B(n203), .Y(n206) );
  INVX1 U539 ( .A(n206), .Y(n567) );
  AND2X1 U540 ( .A(mem[86]), .B(n222), .Y(n224) );
  INVX1 U541 ( .A(n224), .Y(n568) );
  AND2X1 U542 ( .A(mem[71]), .B(n242), .Y(n243) );
  INVX1 U543 ( .A(n243), .Y(n569) );
  AND2X1 U544 ( .A(mem[121]), .B(n172), .Y(n179) );
  INVX1 U545 ( .A(n179), .Y(n570) );
  AND2X1 U546 ( .A(mem[104]), .B(n193), .Y(n201) );
  INVX1 U547 ( .A(n201), .Y(n571) );
  AND2X1 U548 ( .A(mem[91]), .B(n212), .Y(n217) );
  INVX1 U549 ( .A(n217), .Y(n572) );
  AND2X1 U550 ( .A(mem[74]), .B(n231), .Y(n237) );
  INVX1 U551 ( .A(n237), .Y(n573) );
  AND2X1 U552 ( .A(mem[117]), .B(n183), .Y(n186) );
  INVX1 U553 ( .A(n186), .Y(n574) );
  AND2X1 U554 ( .A(mem[100]), .B(n203), .Y(n207) );
  INVX1 U555 ( .A(n207), .Y(n575) );
  AND2X1 U556 ( .A(mem[87]), .B(n222), .Y(n223) );
  INVX1 U557 ( .A(n223), .Y(n576) );
  AND2X1 U558 ( .A(mem[70]), .B(n242), .Y(n244) );
  INVX1 U559 ( .A(n244), .Y(n577) );
  AND2X1 U560 ( .A(rd_ptr_p1[0]), .B(n336), .Y(n340) );
  INVX1 U561 ( .A(n340), .Y(n578) );
  AND2X1 U562 ( .A(mem[122]), .B(n172), .Y(n178) );
  INVX1 U563 ( .A(n178), .Y(n579) );
  AND2X1 U564 ( .A(mem[107]), .B(n193), .Y(n198) );
  INVX1 U565 ( .A(n198), .Y(n580) );
  AND2X1 U566 ( .A(mem[88]), .B(n212), .Y(n220) );
  INVX1 U567 ( .A(n220), .Y(n581) );
  AND2X1 U568 ( .A(mem[73]), .B(n231), .Y(n238) );
  INVX1 U569 ( .A(n238), .Y(n582) );
  AND2X1 U570 ( .A(mem[118]), .B(n183), .Y(n185) );
  INVX1 U571 ( .A(n185), .Y(n583) );
  AND2X1 U572 ( .A(mem[103]), .B(n203), .Y(n204) );
  INVX1 U573 ( .A(n204), .Y(n584) );
  AND2X1 U574 ( .A(mem[84]), .B(n222), .Y(n226) );
  INVX1 U575 ( .A(n226), .Y(n585) );
  AND2X1 U576 ( .A(mem[69]), .B(n242), .Y(n245) );
  INVX1 U577 ( .A(n245), .Y(n586) );
  AND2X1 U578 ( .A(mem[123]), .B(n172), .Y(n177) );
  INVX1 U579 ( .A(n177), .Y(n587) );
  AND2X1 U580 ( .A(mem[106]), .B(n193), .Y(n199) );
  INVX1 U581 ( .A(n199), .Y(n588) );
  AND2X1 U582 ( .A(mem[89]), .B(n212), .Y(n219) );
  INVX1 U583 ( .A(n219), .Y(n589) );
  AND2X1 U584 ( .A(mem[72]), .B(n231), .Y(n239) );
  INVX1 U585 ( .A(n239), .Y(n590) );
  AND2X1 U586 ( .A(mem[119]), .B(n183), .Y(n184) );
  INVX1 U587 ( .A(n184), .Y(n591) );
  AND2X1 U588 ( .A(mem[102]), .B(n203), .Y(n205) );
  INVX1 U589 ( .A(n205), .Y(n592) );
  AND2X1 U590 ( .A(mem[85]), .B(n222), .Y(n225) );
  INVX1 U591 ( .A(n225), .Y(n593) );
  AND2X1 U592 ( .A(mem[68]), .B(n242), .Y(n246) );
  INVX1 U593 ( .A(n246), .Y(n594) );
  AND2X1 U594 ( .A(rd_ptr_p1[4]), .B(n336), .Y(n339) );
  INVX1 U595 ( .A(n339), .Y(n595) );
  AND2X1 U596 ( .A(mem[124]), .B(n172), .Y(n176) );
  INVX1 U597 ( .A(n176), .Y(n596) );
  AND2X1 U598 ( .A(mem[109]), .B(n193), .Y(n196) );
  INVX1 U599 ( .A(n196), .Y(n597) );
  AND2X1 U600 ( .A(mem[94]), .B(n212), .Y(n214) );
  INVX1 U601 ( .A(n214), .Y(n598) );
  AND2X1 U602 ( .A(mem[79]), .B(n231), .Y(n232) );
  INVX1 U603 ( .A(n232), .Y(n599) );
  AND2X1 U604 ( .A(mem[112]), .B(n183), .Y(n191) );
  INVX1 U605 ( .A(n191), .Y(n600) );
  AND2X1 U606 ( .A(mem[97]), .B(n203), .Y(n210) );
  INVX1 U607 ( .A(n210), .Y(n601) );
  AND2X1 U608 ( .A(mem[82]), .B(n222), .Y(n228) );
  INVX1 U609 ( .A(n228), .Y(n602) );
  AND2X1 U610 ( .A(mem[67]), .B(n242), .Y(n247) );
  INVX1 U611 ( .A(n247), .Y(n603) );
  AND2X1 U612 ( .A(rd_ptr_p1[1]), .B(n336), .Y(n338) );
  INVX1 U613 ( .A(n338), .Y(n604) );
  AND2X1 U614 ( .A(mem[125]), .B(n172), .Y(n175) );
  INVX1 U615 ( .A(n175), .Y(n605) );
  AND2X1 U616 ( .A(mem[108]), .B(n193), .Y(n197) );
  INVX1 U617 ( .A(n197), .Y(n606) );
  AND2X1 U618 ( .A(mem[95]), .B(n212), .Y(n213) );
  INVX1 U619 ( .A(n213), .Y(n607) );
  AND2X1 U620 ( .A(mem[78]), .B(n231), .Y(n233) );
  INVX1 U621 ( .A(n233), .Y(n608) );
  AND2X1 U622 ( .A(mem[113]), .B(n183), .Y(n190) );
  INVX1 U623 ( .A(n190), .Y(n609) );
  AND2X1 U624 ( .A(mem[96]), .B(n203), .Y(n211) );
  INVX1 U625 ( .A(n211), .Y(n610) );
  AND2X1 U626 ( .A(mem[83]), .B(n222), .Y(n227) );
  INVX1 U627 ( .A(n227), .Y(n611) );
  AND2X1 U628 ( .A(mem[66]), .B(n242), .Y(n248) );
  INVX1 U629 ( .A(n248), .Y(n612) );
  AND2X1 U630 ( .A(rd_ptr_p1[2]), .B(n336), .Y(n337) );
  INVX1 U631 ( .A(n337), .Y(n613) );
  INVX1 U632 ( .A(n56), .Y(n614) );
  AND2X1 U633 ( .A(diff[4]), .B(n329), .Y(n357) );
  INVX1 U634 ( .A(n357), .Y(n615) );
  AND2X1 U635 ( .A(n802), .B(n631), .Y(n329) );
  AND2X1 U636 ( .A(mem[126]), .B(n172), .Y(n174) );
  INVX1 U637 ( .A(n174), .Y(n616) );
  AND2X1 U638 ( .A(mem[111]), .B(n193), .Y(n194) );
  INVX1 U639 ( .A(n194), .Y(n617) );
  AND2X1 U640 ( .A(mem[92]), .B(n212), .Y(n216) );
  INVX1 U641 ( .A(n216), .Y(n618) );
  AND2X1 U642 ( .A(mem[77]), .B(n231), .Y(n234) );
  INVX1 U643 ( .A(n234), .Y(n619) );
  AND2X1 U644 ( .A(mem[114]), .B(n183), .Y(n189) );
  INVX1 U645 ( .A(n189), .Y(n620) );
  AND2X1 U646 ( .A(mem[99]), .B(n203), .Y(n208) );
  INVX1 U647 ( .A(n208), .Y(n621) );
  AND2X1 U648 ( .A(mem[80]), .B(n222), .Y(n230) );
  INVX1 U649 ( .A(n230), .Y(n622) );
  AND2X1 U650 ( .A(mem[65]), .B(n242), .Y(n249) );
  INVX1 U651 ( .A(n249), .Y(n623) );
  AND2X1 U652 ( .A(rd_ptr_p1[3]), .B(n336), .Y(n335) );
  INVX1 U653 ( .A(n335), .Y(n624) );
  AND2X1 U654 ( .A(n649), .B(n802), .Y(n336) );
  BUFX2 U655 ( .A(n343), .Y(n625) );
  BUFX2 U656 ( .A(n342), .Y(n626) );
  BUFX2 U657 ( .A(n344), .Y(n627) );
  INVX1 U658 ( .A(add_55_carry_4_), .Y(n628) );
  AND2X1 U659 ( .A(diff[1]), .B(diff[0]), .Y(n796) );
  INVX1 U660 ( .A(n796), .Y(n629) );
  AND2X1 U661 ( .A(diff[3]), .B(diff[2]), .Y(n795) );
  INVX1 U662 ( .A(n795), .Y(n630) );
  AND2X1 U663 ( .A(put), .B(full_bar), .Y(n359) );
  INVX1 U664 ( .A(n359), .Y(n631) );
  OR2X1 U665 ( .A(n814), .B(wr_ptr_bin[2]), .Y(n221) );
  INVX1 U666 ( .A(n221), .Y(n632) );
  OR2X1 U667 ( .A(reset), .B(n811), .Y(n46) );
  INVX1 U668 ( .A(n46), .Y(n633) );
  OR2X1 U669 ( .A(reset), .B(n817), .Y(n47) );
  INVX1 U670 ( .A(n47), .Y(n634) );
  OR2X1 U671 ( .A(reset), .B(n818), .Y(n48) );
  INVX1 U672 ( .A(n48), .Y(n635) );
  OR2X1 U673 ( .A(reset), .B(n819), .Y(n49) );
  INVX1 U674 ( .A(n49), .Y(n636) );
  OR2X1 U675 ( .A(reset), .B(n816), .Y(n50) );
  INVX1 U676 ( .A(n50), .Y(n637) );
  AND2X1 U677 ( .A(mem[127]), .B(n172), .Y(n173) );
  INVX1 U678 ( .A(n173), .Y(n638) );
  AND2X1 U679 ( .A(mem[110]), .B(n193), .Y(n195) );
  INVX1 U680 ( .A(n195), .Y(n639) );
  AND2X1 U681 ( .A(mem[93]), .B(n212), .Y(n215) );
  INVX1 U682 ( .A(n215), .Y(n640) );
  AND2X1 U683 ( .A(mem[76]), .B(n231), .Y(n235) );
  INVX1 U684 ( .A(n235), .Y(n641) );
  AND2X1 U685 ( .A(mem[115]), .B(n183), .Y(n188) );
  INVX1 U686 ( .A(n188), .Y(n642) );
  AND2X1 U687 ( .A(mem[98]), .B(n203), .Y(n209) );
  INVX1 U688 ( .A(n209), .Y(n643) );
  AND2X1 U689 ( .A(mem[81]), .B(n222), .Y(n229) );
  INVX1 U690 ( .A(n229), .Y(n644) );
  AND2X1 U691 ( .A(mem[64]), .B(n242), .Y(n250) );
  INVX1 U692 ( .A(n250), .Y(n645) );
  INVX1 U693 ( .A(n251), .Y(n646) );
  OR2X1 U694 ( .A(wr_ptr_bin[1]), .B(wr_ptr_bin[2]), .Y(n240) );
  INVX1 U695 ( .A(n240), .Y(n647) );
  OR2X1 U696 ( .A(n329), .B(reset), .Y(n328) );
  INVX1 U697 ( .A(n328), .Y(n648) );
  AND2X1 U698 ( .A(n802), .B(n341), .Y(n334) );
  INVX1 U699 ( .A(n334), .Y(n649) );
  AND2X2 U700 ( .A(n96), .B(n788), .Y(data_out[7]) );
  AND2X2 U701 ( .A(n97), .B(n788), .Y(data_out[6]) );
  AND2X2 U702 ( .A(n98), .B(n788), .Y(data_out[5]) );
  INVX1 U703 ( .A(n789), .Y(n782) );
  INVX1 U704 ( .A(n789), .Y(n781) );
  INVX1 U705 ( .A(n789), .Y(n780) );
  INVX1 U706 ( .A(n789), .Y(n779) );
  INVX1 U707 ( .A(n789), .Y(n778) );
  INVX1 U708 ( .A(n650), .Y(n242) );
  INVX1 U709 ( .A(n651), .Y(n222) );
  AND2X1 U710 ( .A(n202), .B(n192), .Y(n652) );
  INVX1 U711 ( .A(n652), .Y(n203) );
  INVX1 U712 ( .A(n653), .Y(n231) );
  INVX1 U713 ( .A(n654), .Y(n212) );
  AND2X1 U714 ( .A(n202), .B(n182), .Y(n655) );
  INVX1 U715 ( .A(n655), .Y(n193) );
  INVX1 U716 ( .A(n656), .Y(n318) );
  INVX1 U717 ( .A(n657), .Y(n299) );
  AND2X1 U718 ( .A(n271), .B(n202), .Y(n658) );
  INVX1 U719 ( .A(n658), .Y(n281) );
  INVX1 U720 ( .A(n659), .Y(n308) );
  INVX1 U721 ( .A(n660), .Y(n290) );
  AND2X1 U722 ( .A(n261), .B(n202), .Y(n661) );
  INVX1 U723 ( .A(n661), .Y(n272) );
  AND2X1 U724 ( .A(n192), .B(n181), .Y(n662) );
  INVX1 U725 ( .A(n662), .Y(n183) );
  AND2X1 U726 ( .A(n271), .B(n181), .Y(n663) );
  INVX1 U727 ( .A(n663), .Y(n262) );
  AND2X1 U728 ( .A(n261), .B(n181), .Y(n664) );
  INVX1 U729 ( .A(n664), .Y(n252) );
  AND2X1 U730 ( .A(n181), .B(n182), .Y(n665) );
  INVX1 U731 ( .A(n665), .Y(n172) );
  AND2X1 U732 ( .A(n317), .B(wr_ptr_bin_p1[0]), .Y(n271) );
  AND2X1 U733 ( .A(n241), .B(wr_ptr_bin_p1[0]), .Y(n192) );
  INVX1 U734 ( .A(n783), .Y(n785) );
  INVX1 U735 ( .A(n783), .Y(n784) );
  INVX1 U736 ( .A(rd_ptr_ss_bin[3]), .Y(n791) );
  INVX1 U737 ( .A(rd_ptr_ss_bin[1]), .Y(n793) );
  BUFX2 U738 ( .A(n16), .Y(n786) );
  BUFX2 U739 ( .A(n16), .Y(n787) );
  AND2X1 U740 ( .A(wr_ptr_bin[0]), .B(n241), .Y(n182) );
  AND2X1 U741 ( .A(n317), .B(wr_ptr_bin[0]), .Y(n261) );
  INVX1 U742 ( .A(wr_ptr_bin[3]), .Y(n813) );
  INVX1 U743 ( .A(n15), .Y(n783) );
  AND2X1 U744 ( .A(n103), .B(n788), .Y(data_out[0]) );
  AND2X1 U745 ( .A(n102), .B(n788), .Y(data_out[1]) );
  AND2X1 U746 ( .A(n101), .B(n788), .Y(data_out[2]) );
  AND2X1 U747 ( .A(n100), .B(n788), .Y(data_out[3]) );
  AND2X1 U748 ( .A(n99), .B(n788), .Y(data_out[4]) );
  INVX1 U749 ( .A(wr_ptr_bin[1]), .Y(n814) );
  AND2X1 U750 ( .A(wr_ptr_bin[2]), .B(n814), .Y(n202) );
  AND2X1 U751 ( .A(wr_ptr_bin[2]), .B(wr_ptr_bin[1]), .Y(n181) );
  INVX1 U752 ( .A(n496), .Y(n800) );
  INVX1 U753 ( .A(n495), .Y(n799) );
  INVX1 U754 ( .A(n494), .Y(n798) );
  INVX1 U755 ( .A(wr_ptr_bin[0]), .Y(wr_ptr_bin_p1[0]) );
  INVX1 U756 ( .A(n493), .Y(n797) );
  INVX1 U757 ( .A(rd_ptr_ss_bin[2]), .Y(n792) );
  INVX1 U758 ( .A(rd_ptr_ss_bin[4]), .Y(n790) );
  INVX1 U759 ( .A(n14), .Y(n789) );
  INVX1 U760 ( .A(n497), .Y(n801) );
  AND2X1 U761 ( .A(n802), .B(wr_ptr[4]), .Y(n89) );
  AND2X1 U762 ( .A(n802), .B(wr_ptr[2]), .Y(n87) );
  AND2X1 U763 ( .A(n802), .B(wr_ptr[1]), .Y(n86) );
  AND2X1 U764 ( .A(n802), .B(wr_ptr[3]), .Y(n88) );
  AND2X1 U765 ( .A(n802), .B(wr_ptr[0]), .Y(n85) );
  AND2X1 U766 ( .A(rd_ptr_s[4]), .B(n802), .Y(n55) );
  AND2X1 U767 ( .A(rd_ptr_s[3]), .B(n802), .Y(n54) );
  AND2X1 U768 ( .A(rd_ptr_s[2]), .B(n802), .Y(n53) );
  AND2X1 U769 ( .A(rd_ptr_s[1]), .B(n802), .Y(n52) );
  AND2X1 U770 ( .A(wr_ptr_s[4]), .B(n802), .Y(n94) );
  AND2X1 U771 ( .A(wr_ptr_s[3]), .B(n802), .Y(n93) );
  AND2X1 U772 ( .A(wr_ptr_s[2]), .B(n802), .Y(n92) );
  AND2X1 U773 ( .A(wr_ptr_s[1]), .B(n802), .Y(n91) );
  AND2X1 U774 ( .A(wr_ptr_s[0]), .B(n802), .Y(n90) );
  AND2X1 U775 ( .A(rd_ptr_s[0]), .B(n802), .Y(n51) );
  INVX1 U776 ( .A(reset), .Y(n802) );
  INVX1 U777 ( .A(FULL), .Y(full_bar) );
  INVX1 U778 ( .A(EMPTY), .Y(empty_bar) );
  INVX1 U779 ( .A(rd_ptr_ss_bin[0]), .Y(n794) );
  INVX1 U780 ( .A(rd_ptr[2]), .Y(n818) );
  INVX1 U781 ( .A(rd_ptr[4]), .Y(n816) );
  INVX1 U782 ( .A(rd_ptr[1]), .Y(n817) );
  INVX1 U783 ( .A(rd_ptr[3]), .Y(n819) );
  INVX1 U784 ( .A(rd_ptr[0]), .Y(n811) );
  INVX1 U785 ( .A(data_in[0]), .Y(n810) );
  INVX1 U786 ( .A(data_in[1]), .Y(n809) );
  INVX1 U787 ( .A(data_in[2]), .Y(n808) );
  INVX1 U788 ( .A(data_in[3]), .Y(n807) );
  INVX1 U789 ( .A(data_in[4]), .Y(n806) );
  INVX1 U790 ( .A(data_in[5]), .Y(n805) );
  INVX1 U791 ( .A(data_in[6]), .Y(n804) );
  INVX1 U792 ( .A(data_in[7]), .Y(n803) );
  MUX2X1 U793 ( .B(n667), .A(n668), .S(n785), .Y(n666) );
  MUX2X1 U794 ( .B(n670), .A(n671), .S(n785), .Y(n669) );
  MUX2X1 U795 ( .B(n673), .A(n674), .S(n785), .Y(n672) );
  MUX2X1 U796 ( .B(n676), .A(n677), .S(n785), .Y(n675) );
  MUX2X1 U797 ( .B(n678), .A(n679), .S(n17), .Y(n103) );
  MUX2X1 U798 ( .B(n681), .A(n682), .S(n785), .Y(n680) );
  MUX2X1 U799 ( .B(n684), .A(n685), .S(n785), .Y(n683) );
  MUX2X1 U800 ( .B(n687), .A(n688), .S(n785), .Y(n686) );
  MUX2X1 U801 ( .B(n690), .A(n691), .S(n785), .Y(n689) );
  MUX2X1 U802 ( .B(n692), .A(n693), .S(n17), .Y(n102) );
  MUX2X1 U803 ( .B(n695), .A(n696), .S(n785), .Y(n694) );
  MUX2X1 U804 ( .B(n698), .A(n699), .S(n785), .Y(n697) );
  MUX2X1 U805 ( .B(n701), .A(n702), .S(n785), .Y(n700) );
  MUX2X1 U806 ( .B(n704), .A(n705), .S(n785), .Y(n703) );
  MUX2X1 U807 ( .B(n706), .A(n707), .S(n17), .Y(n101) );
  MUX2X1 U808 ( .B(n709), .A(n710), .S(n784), .Y(n708) );
  MUX2X1 U809 ( .B(n712), .A(n713), .S(n784), .Y(n711) );
  MUX2X1 U810 ( .B(n715), .A(n716), .S(n784), .Y(n714) );
  MUX2X1 U811 ( .B(n718), .A(n719), .S(n784), .Y(n717) );
  MUX2X1 U812 ( .B(n720), .A(n721), .S(n17), .Y(n100) );
  MUX2X1 U813 ( .B(n723), .A(n724), .S(n784), .Y(n722) );
  MUX2X1 U814 ( .B(n726), .A(n727), .S(n784), .Y(n725) );
  MUX2X1 U815 ( .B(n729), .A(n730), .S(n784), .Y(n728) );
  MUX2X1 U816 ( .B(n732), .A(n733), .S(n784), .Y(n731) );
  MUX2X1 U817 ( .B(n734), .A(n735), .S(n17), .Y(n99) );
  MUX2X1 U818 ( .B(n737), .A(n738), .S(n784), .Y(n736) );
  MUX2X1 U819 ( .B(n740), .A(n741), .S(n784), .Y(n739) );
  MUX2X1 U820 ( .B(n743), .A(n744), .S(n784), .Y(n742) );
  MUX2X1 U821 ( .B(n746), .A(n747), .S(n784), .Y(n745) );
  MUX2X1 U822 ( .B(n748), .A(n749), .S(n17), .Y(n98) );
  MUX2X1 U823 ( .B(n751), .A(n752), .S(n15), .Y(n750) );
  MUX2X1 U824 ( .B(n754), .A(n755), .S(n15), .Y(n753) );
  MUX2X1 U825 ( .B(n757), .A(n758), .S(n15), .Y(n756) );
  MUX2X1 U826 ( .B(n760), .A(n761), .S(n15), .Y(n759) );
  MUX2X1 U827 ( .B(n762), .A(n763), .S(n17), .Y(n97) );
  MUX2X1 U828 ( .B(n765), .A(n766), .S(n15), .Y(n764) );
  MUX2X1 U829 ( .B(n768), .A(n769), .S(n785), .Y(n767) );
  MUX2X1 U830 ( .B(n771), .A(n772), .S(n15), .Y(n770) );
  MUX2X1 U831 ( .B(n774), .A(n775), .S(n15), .Y(n773) );
  MUX2X1 U832 ( .B(n776), .A(n777), .S(n17), .Y(n96) );
  MUX2X1 U833 ( .B(mem[112]), .A(mem[120]), .S(n782), .Y(n668) );
  MUX2X1 U834 ( .B(mem[96]), .A(mem[104]), .S(n782), .Y(n667) );
  MUX2X1 U835 ( .B(mem[80]), .A(mem[88]), .S(n782), .Y(n671) );
  MUX2X1 U836 ( .B(mem[64]), .A(mem[72]), .S(n782), .Y(n670) );
  MUX2X1 U837 ( .B(n669), .A(n666), .S(n786), .Y(n679) );
  MUX2X1 U838 ( .B(mem[48]), .A(mem[56]), .S(n782), .Y(n674) );
  MUX2X1 U839 ( .B(mem[32]), .A(mem[40]), .S(n782), .Y(n673) );
  MUX2X1 U840 ( .B(mem[16]), .A(mem[24]), .S(n782), .Y(n677) );
  MUX2X1 U841 ( .B(mem[0]), .A(mem[8]), .S(n782), .Y(n676) );
  MUX2X1 U842 ( .B(n675), .A(n672), .S(n786), .Y(n678) );
  MUX2X1 U843 ( .B(mem[113]), .A(mem[121]), .S(n782), .Y(n682) );
  MUX2X1 U844 ( .B(mem[97]), .A(mem[105]), .S(n782), .Y(n681) );
  MUX2X1 U845 ( .B(mem[81]), .A(mem[89]), .S(n782), .Y(n685) );
  MUX2X1 U846 ( .B(mem[65]), .A(mem[73]), .S(n782), .Y(n684) );
  MUX2X1 U847 ( .B(n683), .A(n680), .S(n786), .Y(n693) );
  MUX2X1 U848 ( .B(mem[49]), .A(mem[57]), .S(n781), .Y(n688) );
  MUX2X1 U849 ( .B(mem[33]), .A(mem[41]), .S(n781), .Y(n687) );
  MUX2X1 U850 ( .B(mem[17]), .A(mem[25]), .S(n781), .Y(n691) );
  MUX2X1 U851 ( .B(mem[1]), .A(mem[9]), .S(n781), .Y(n690) );
  MUX2X1 U852 ( .B(n689), .A(n686), .S(n786), .Y(n692) );
  MUX2X1 U853 ( .B(mem[114]), .A(mem[122]), .S(n781), .Y(n696) );
  MUX2X1 U854 ( .B(mem[98]), .A(mem[106]), .S(n781), .Y(n695) );
  MUX2X1 U855 ( .B(mem[82]), .A(mem[90]), .S(n781), .Y(n699) );
  MUX2X1 U856 ( .B(mem[66]), .A(mem[74]), .S(n781), .Y(n698) );
  MUX2X1 U857 ( .B(n697), .A(n694), .S(n786), .Y(n707) );
  MUX2X1 U858 ( .B(mem[50]), .A(mem[58]), .S(n781), .Y(n702) );
  MUX2X1 U859 ( .B(mem[34]), .A(mem[42]), .S(n781), .Y(n701) );
  MUX2X1 U860 ( .B(mem[18]), .A(mem[26]), .S(n781), .Y(n705) );
  MUX2X1 U861 ( .B(mem[2]), .A(mem[10]), .S(n781), .Y(n704) );
  MUX2X1 U862 ( .B(n703), .A(n700), .S(n786), .Y(n706) );
  MUX2X1 U863 ( .B(mem[115]), .A(mem[123]), .S(n780), .Y(n710) );
  MUX2X1 U864 ( .B(mem[99]), .A(mem[107]), .S(n780), .Y(n709) );
  MUX2X1 U865 ( .B(mem[83]), .A(mem[91]), .S(n780), .Y(n713) );
  MUX2X1 U866 ( .B(mem[67]), .A(mem[75]), .S(n780), .Y(n712) );
  MUX2X1 U867 ( .B(n711), .A(n708), .S(n786), .Y(n721) );
  MUX2X1 U868 ( .B(mem[51]), .A(mem[59]), .S(n780), .Y(n716) );
  MUX2X1 U869 ( .B(mem[35]), .A(mem[43]), .S(n780), .Y(n715) );
  MUX2X1 U870 ( .B(mem[19]), .A(mem[27]), .S(n780), .Y(n719) );
  MUX2X1 U871 ( .B(mem[3]), .A(mem[11]), .S(n780), .Y(n718) );
  MUX2X1 U872 ( .B(n717), .A(n714), .S(n786), .Y(n720) );
  MUX2X1 U873 ( .B(mem[116]), .A(mem[124]), .S(n780), .Y(n724) );
  MUX2X1 U874 ( .B(mem[100]), .A(mem[108]), .S(n780), .Y(n723) );
  MUX2X1 U875 ( .B(mem[84]), .A(mem[92]), .S(n780), .Y(n727) );
  MUX2X1 U876 ( .B(mem[68]), .A(mem[76]), .S(n780), .Y(n726) );
  MUX2X1 U877 ( .B(n725), .A(n722), .S(n787), .Y(n735) );
  MUX2X1 U878 ( .B(mem[52]), .A(mem[60]), .S(n779), .Y(n730) );
  MUX2X1 U879 ( .B(mem[36]), .A(mem[44]), .S(n779), .Y(n729) );
  MUX2X1 U880 ( .B(mem[20]), .A(mem[28]), .S(n779), .Y(n733) );
  MUX2X1 U881 ( .B(mem[4]), .A(mem[12]), .S(n779), .Y(n732) );
  MUX2X1 U882 ( .B(n731), .A(n728), .S(n787), .Y(n734) );
  MUX2X1 U883 ( .B(mem[117]), .A(mem[125]), .S(n779), .Y(n738) );
  MUX2X1 U884 ( .B(mem[101]), .A(mem[109]), .S(n779), .Y(n737) );
  MUX2X1 U885 ( .B(mem[85]), .A(mem[93]), .S(n779), .Y(n741) );
  MUX2X1 U886 ( .B(mem[69]), .A(mem[77]), .S(n779), .Y(n740) );
  MUX2X1 U887 ( .B(n739), .A(n736), .S(n787), .Y(n749) );
  MUX2X1 U888 ( .B(mem[53]), .A(mem[61]), .S(n779), .Y(n744) );
  MUX2X1 U889 ( .B(mem[37]), .A(mem[45]), .S(n779), .Y(n743) );
  MUX2X1 U890 ( .B(mem[21]), .A(mem[29]), .S(n779), .Y(n747) );
  MUX2X1 U891 ( .B(mem[5]), .A(mem[13]), .S(n779), .Y(n746) );
  MUX2X1 U892 ( .B(n745), .A(n742), .S(n787), .Y(n748) );
  MUX2X1 U893 ( .B(mem[118]), .A(mem[126]), .S(n778), .Y(n752) );
  MUX2X1 U894 ( .B(mem[102]), .A(mem[110]), .S(n778), .Y(n751) );
  MUX2X1 U895 ( .B(mem[86]), .A(mem[94]), .S(n778), .Y(n755) );
  MUX2X1 U896 ( .B(mem[70]), .A(mem[78]), .S(n778), .Y(n754) );
  MUX2X1 U897 ( .B(n753), .A(n750), .S(n787), .Y(n763) );
  MUX2X1 U898 ( .B(mem[54]), .A(mem[62]), .S(n778), .Y(n758) );
  MUX2X1 U899 ( .B(mem[38]), .A(mem[46]), .S(n778), .Y(n757) );
  MUX2X1 U900 ( .B(mem[22]), .A(mem[30]), .S(n778), .Y(n761) );
  MUX2X1 U901 ( .B(mem[6]), .A(mem[14]), .S(n778), .Y(n760) );
  MUX2X1 U902 ( .B(n759), .A(n756), .S(n787), .Y(n762) );
  MUX2X1 U903 ( .B(mem[119]), .A(mem[127]), .S(n778), .Y(n766) );
  MUX2X1 U904 ( .B(mem[103]), .A(mem[111]), .S(n778), .Y(n765) );
  MUX2X1 U905 ( .B(mem[87]), .A(mem[95]), .S(n778), .Y(n769) );
  MUX2X1 U906 ( .B(mem[71]), .A(mem[79]), .S(n778), .Y(n768) );
  MUX2X1 U907 ( .B(n767), .A(n764), .S(n787), .Y(n777) );
  MUX2X1 U908 ( .B(mem[55]), .A(mem[63]), .S(n779), .Y(n772) );
  MUX2X1 U909 ( .B(mem[39]), .A(mem[47]), .S(n782), .Y(n771) );
  MUX2X1 U910 ( .B(mem[23]), .A(mem[31]), .S(n780), .Y(n775) );
  MUX2X1 U911 ( .B(mem[7]), .A(mem[15]), .S(n781), .Y(n774) );
  MUX2X1 U912 ( .B(n773), .A(n770), .S(n787), .Y(n776) );
  AND2X2 U913 ( .A(get), .B(empty_bar), .Y(n788) );
  INVX1 U914 ( .A(n788), .Y(n341) );
  OR2X1 U915 ( .A(n794), .B(wr_ptr_bin[0]), .Y(sub_38_carry[1]) );
  XNOR2X1 U916 ( .A(wr_ptr_bin[0]), .B(n794), .Y(diff[0]) );
  XOR2X1 U917 ( .A(add_35_carry[4]), .B(rd_ptr_bin_4_), .Y(rd_ptr_bin_p1[4])
         );
endmodule

