alias f := format
alias l := lint
alias ll := librelane
alias kl := klayout
alias op := openroad

librelane:
  librelane --pdk ihp-sg13g2 config.yaml

klayout:
  librelane --pdk ihp-sg13g2 --last-run --flow openinklayout config.yaml

openroad:
  librelane --pdk ihp-sg13g2 --last-run --flow openinopenroad config.yaml

format:
  verible-verilog-format --column_limit=140 --indentation_spaces=2 --compact_indexing_and_selections=true \
  --port_declarations_alignment=align --port_declarations_indentation=indent --module_net_variable_alignment=align \
  --named_port_alignment=flush-left --named_port_indentation=indent --assignment_statement_alignment=align \
  --case_items_alignment=flush-left --inplace rtl/*.{sv,svh}

lint:
  verilator --lint-only --language 1800-2017 -Wall -Irtl -sv -DMY_DEFINE --top-module ecc_design rtl/ext_macros.svh rtl/typedefs.sv rtl/MRSC_decoder.sv \
  rtl/MRSC_encoder.sv rtl/TBEC_RSC_decoder.sv rtl/TBEC_RSC_encoder.sv rtl/ecc_design.sv
