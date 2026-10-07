module ecc_design (
  input  logic [15:0] data_in_left,
  input  logic        chip_sel,
  input  logic [ 2:0] sel,
  input  logic [15:0] data_in_right_up,
  input  logic [15:0] data_in_right_down,
  output logic [15:0] data_out_right_up,
  output logic [15:0] data_out_right_down,
  output logic [15:0] data_out_left,
  output logic [ 2:0] flag,
  output logic [ 1:0] chip_sel_out
);
  import typedefs::*;

  logic [15:0] tbec_rsc_decoder_output, mrsc_decoder_output;
  logic [31:0] tbec_rsc_encoder_output, mrsc_encoder_output;

  TBEC_RSC_encoder tbec_rsc_encoder (
    .data_in(data_in_left),
    .data_out(tbec_rsc_encoder_output)
  );
  TBEC_RSC_decoder tbec_rsc_decoder (
    .data_in({data_in_right_up, data_in_right_down}),
    .data_out(tbec_rsc_decoder_output),
    .flag(flag)
  );

  MRSC_encoder mrsc_encoder (
    .data_in(data_in_left),
    .data_out(mrsc_encoder_output)
  );
  MRSC_decoder mrsc_decoder (
    .data_in({data_in_right_up, data_in_right_down}),
    .data_out(mrsc_decoder_output)
  );

  always_comb begin
    data_out_right_up   = '0;
    data_out_right_down = '0;
    data_out_left       = '0;
    chip_sel_out        = 2'b11;

    case (sel)
      BYPASS_UP: begin
        data_out_right_up = data_in_left;
        data_out_left     = data_in_right_up;
        chip_sel_out      = {chip_sel, ~chip_sel};
      end
      BYPASS_DOWN: begin
        data_out_right_down = data_in_left;
        data_out_left       = data_in_right_down;
        chip_sel_out        = {~chip_sel, chip_sel};
      end
      TBEC_RSC: begin
        data_out_right_up   = tbec_rsc_encoder_output[31:16];
        data_out_right_down = tbec_rsc_encoder_output[15:0];
        data_out_left       = tbec_rsc_decoder_output;
        chip_sel_out        = {chip_sel, chip_sel};
      end
      MRSC: begin
        data_out_right_up   = mrsc_encoder_output[31:16];
        data_out_right_down = mrsc_encoder_output[15:0];
        data_out_left       = mrsc_decoder_output;
        chip_sel_out        = {chip_sel, chip_sel};
      end
      default: begin
        data_out_right_up = data_in_left;
        data_out_left     = data_in_right_up;
        chip_sel_out      = 2'b11;
      end
    endcase
  end
endmodule
