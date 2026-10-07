`ifndef EXT_MACROS_SVH
`define EXT_MACROS_SVH

`define EXT(value, WIDTH) {{(WIDTH - 1){1'b0}}, value}
`define EXT2(value) `EXT(value, 2)
`define EXT3(value) `EXT(value, 3)

`endif
