module MRSC_encoder (
  input  logic [15:0] data_in,
  output logic [31:0] data_out
);
  logic [3:0] signal[3:0];
  logic       Di    [3:0];
  logic       P     [3:0];
  logic [1:0] Cb    [3:0];

  always_comb begin
    signal[3] = data_in[15:12];
    signal[2] = data_in[11:8];
    signal[1] = data_in[7:4];
    signal[0] = data_in[3:0];

    for (int i = 0; i < 4; i++) Cb[i] = {signal[i][3] ^ signal[i][1], signal[i][2] ^ signal[i][0]};

    P[3] = signal[3][3] ^ signal[2][3] ^ signal[1][3] ^ signal[0][3];
    P[2] = signal[3][2] ^ signal[2][2] ^ signal[1][2] ^ signal[0][2];
    P[1] = signal[3][1] ^ signal[2][1] ^ signal[1][1] ^ signal[0][1];
    P[0] = signal[3][0] ^ signal[2][0] ^ signal[1][0] ^ signal[0][0];

    Di[3] = signal[3][3] ^ signal[2][2] ^ signal[1][3] ^ signal[0][2];
    Di[2] = signal[3][2] ^ signal[2][3] ^ signal[1][2] ^ signal[0][3];
    Di[1] = signal[3][1] ^ signal[2][0] ^ signal[1][1] ^ signal[0][0];
    Di[0] = signal[3][0] ^ signal[2][1] ^ signal[1][0] ^ signal[0][1];
  end

  assign data_out = {
    signal[3][3],
    signal[2][3],
    signal[1][3],
    signal[0][3],
    signal[3][2],
    signal[2][2],
    signal[1][2],
    signal[0][2],
    signal[3][1],
    signal[2][1],
    signal[1][1],
    signal[0][1],
    signal[3][0],
    signal[2][0],
    signal[1][0],
    signal[0][0],
    Di[3],
    Di[0],
    Di[2],
    Di[1],
    P[3],
    P[0],
    P[2],
    P[1],
    Cb[3][1:0],
    Cb[2][1:0],
    Cb[1][1:0],
    Cb[0][1:0]
  };
endmodule
