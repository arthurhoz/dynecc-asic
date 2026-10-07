`include "ext_macros.svh"

module TBEC_RSC_decoder (
  input  logic [31:0] data_in,
  output logic [15:0] data_out,
  output logic [ 2:0] flag
);
  logic [ 3:0] signal[3:0];
  logic [15:0] red;
  logic [ 1:0] linsin[3:0];
  logic [ 3:0] SP;
  logic [ 3:0] SDi;

  always_comb begin
    logic [2:0] sumSL;
    logic [1:0] sumSP, sumSDi;
    logic [1:0] quad1, quad2;

    signal[3] = {data_in[31], data_in[27], data_in[23], data_in[19]};
    signal[2] = {data_in[30], data_in[26], data_in[22], data_in[18]};
    signal[1] = {data_in[29], data_in[25], data_in[21], data_in[17]};
    signal[0] = {data_in[28], data_in[24], data_in[20], data_in[16]};

    red = data_in[15:0];

    linsin[3][1] = signal[3][3] ^ signal[3][1] ^ red[7];
    linsin[3][0] = signal[3][2] ^ signal[3][0] ^ red[6];
    linsin[2][1] = signal[2][3] ^ signal[2][1] ^ red[5];
    linsin[2][0] = signal[2][2] ^ signal[2][0] ^ red[4];
    linsin[1][1] = signal[1][3] ^ signal[1][1] ^ red[3];
    linsin[1][0] = signal[1][2] ^ signal[1][0] ^ red[2];
    linsin[0][1] = signal[0][3] ^ signal[0][1] ^ red[1];
    linsin[0][0] = signal[0][2] ^ signal[0][0] ^ red[0];

    SP[3] = signal[3][3] ^ signal[3][2] ^ signal[2][3] ^ signal[2][2] ^ red[11];
    SP[2] = signal[1][3] ^ signal[1][2] ^ signal[0][3] ^ signal[0][2] ^ red[9];
    SP[1] = signal[3][1] ^ signal[3][0] ^ signal[2][1] ^ signal[2][0] ^ red[8];
    SP[0] = signal[1][1] ^ signal[1][0] ^ signal[0][1] ^ signal[0][0] ^ red[10];
    sumSP = `EXT2(SP[0]) + `EXT2(SP[1]) + `EXT2(SP[2]) + `EXT2(SP[3]);

    SDi[3] = signal[3][3] ^ signal[2][2] ^ signal[1][3] ^ signal[0][2] ^ red[15];
    SDi[2] = signal[3][2] ^ signal[2][3] ^ signal[1][2] ^ signal[0][3] ^ red[13];
    SDi[1] = signal[3][1] ^ signal[2][0] ^ signal[1][1] ^ signal[0][0] ^ red[12];
    SDi[0] = signal[3][0] ^ signal[2][1] ^ signal[1][0] ^ signal[0][1] ^ red[14];
    sumSDi = `EXT2(SDi[0]) + `EXT2(SDi[1]) + `EXT2(SDi[2]) + `EXT2(SDi[3]);
    sumSL =
    `EXT3(linsin[2][1])
    +
    `EXT3(linsin[2][0])
    +
    `EXT3(linsin[1][1])
    +
    `EXT3(linsin[1][0])
    +
    `EXT3(linsin[0][1])
    +
    `EXT3(linsin[0][0])
    +
    `EXT3(linsin[3][1])
    +
    `EXT3(linsin[3][0]);

    if (((SP != '0 && SDi != '0) || sumSL > 1) && !(sumSDi == '0 && sumSP == 'd1 && sumSL >= 'd2)) begin
      quad1 = `EXT2(SP[3]) + `EXT2(SP[2]) + `EXT2(SDi[3]) + `EXT2(SDi[2]);
      quad2 = `EXT2(SP[1]) + `EXT2(SP[0]) + `EXT2(SDi[1]) + `EXT2(SDi[0]);

      if (quad1 > quad2) begin
        flag = 3'b100;

        for (int i = 0; i < 4; i++) begin
          if (linsin[i] != '0) signal[i][3:2] ^= linsin[i];
        end
      end else if (quad1 < quad2) begin
        flag = 3'b010;

        for (int i = 0; i < 4; i++) begin
          if (linsin[i] != '0) signal[i][1:0] ^= linsin[i];
        end
      end else if ({SP[3], SP[2], SDi[3], SDi[2]} != '0) begin
        flag = 3'b001;

        for (int i = 0; i < 4; i++) begin
          if (linsin[i] != '0) signal[i][2:1] ^= {linsin[i][0], linsin[i][1]};
        end
      end else begin
        flag = '0;
      end
    end else begin
      quad1 = '0;
      quad2 = '0;
      flag  = '0;
    end
  end

  assign data_out = {signal[3], signal[2], signal[1], signal[0]};
endmodule
