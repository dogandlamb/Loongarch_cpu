// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Fri May  8 21:02:53 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top l2_way1_tag_ram -prefix
//               l2_way1_tag_ram_ l2_way0_tag_ram_sim_netlist.v
// Design      : l2_way0_tag_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "l2_way0_tag_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module l2_way1_tag_ram
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [3:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [8:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;

  wire [8:0]addra;
  wire clka;
  wire [31:0]dina;
  wire [31:0]douta;
  wire ena;
  wire [3:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [31:0]NLW_U0_doutb_UNCONNECTED;
  wire [8:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [8:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "9" *) 
  (* C_ADDRB_WIDTH = "9" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "8" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     3.53845 mW" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "l2_way0_tag_ram.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "512" *) 
  (* C_READ_DEPTH_B = "512" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "1" *) 
  (* C_USE_BYTE_WEB = "1" *) 
  (* C_USE_DEFAULT_DATA = "1" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "4" *) 
  (* C_WEB_WIDTH = "4" *) 
  (* C_WRITE_DEPTH_A = "512" *) 
  (* C_WRITE_DEPTH_B = "512" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  l2_way1_tag_ram_blk_mem_gen_v8_4_7 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[31:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[8:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[8:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web({1'b0,1'b0,1'b0,1'b0}));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2023.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
jLV29U0rrfMIZhYJzdoUrPoqB9eHQ5NXmWyCdqnN3Wgm+GU4C3zthrN1m4QGiaj0thPCIynZbX+0
7yjtkv+T5ByJ6NhiofAwWseGLvPXlYu6ERAPvi4SAYpF2VUqQHtPAbPmnPubGdDRgIEpeobF7hsz
rEcpEru1pyiScUriyuo=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
vsoizVrOONWw/DhjRLEYrtRmtji+Ok63CbpSg/l9VnoKAi8tAzqRbQ57atGB2N6IGGbKHkbK2Uzh
EHgWvYZeyt4hE+bpQX91vc9PNxfjQMGzPoFD3jCWk30EmEk+AND39eWx+DhJ8xhFuucoOQ2GwyAk
B+Mjs15naPE7DvlHel8hnD4dfSdYhGKp96oozu8JeBto8aHG6poOuYkxSwaut7NCI+mabCkMxtMp
RrydgmRuTvhRTbJMyx5CxFSZTRDrS5aU1vaRlnMiqKCI7g2KY9pemYaJsFeVodBuo6IyKGynyEhs
wr+VtUhQDtaVhMkwB95WwmMoDk9F2L5Au1I+TQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
W081dPMCWhKs5YlQD7n3zvf7+PTcnb8eFWxoVs8+zHLkxDMA1klITbsfztGYvJFce8Yao5XQLLqZ
oUE5Pq2arq+zwICFUcLjdMsmP1WmL82znHOPHm83zNwrxWMloHkySAqzFbgJeHa973uZqj0M8ydc
sYmzCYVlGVjt0QX0xqA=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Zpc3MmdLWaVOv+S4z2POuoyslYoAbWc+Npxq2UyQRtDwf566IId3uwAetolMAgfLo/G3ezuSOXMn
8NznS37h9XvmVrxA50SAux68P87WgkLtiUYqM3CMBKkxNlZ/TR8WzTuQyFdvzkOE9lp8HC7LXnk5
RDsnOM+su46FW7ysY01COslo9Xc7rhs6WFqx29+Xcqk8+ZMLSzaJfuwZdNmJFS3Q1vhlq3ZeYqMl
wMieB731KsPxjxp7VKNHpTbgFryC2isqc4ohBDOt52M/Bz4B/rIpFeHfZ7X3jWSiKtSuBsDN2NXf
EMjfAT248dlK7NxJ+NBNPhS5sLxTiGyQhta57A==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rPMYqnkKhJKV1wltOfDrKos9ZbucaoX3WGTuqsdLkGpcKObzslHBwlGrKtWV7bZYmS2SM+QuEMfa
CE+tCUdsSiprp+n5BuSQlJa6BJ8mlqccjoo/JLw2QEmUhyMXQ3TLGomGGoZdeTmMPXhUBAOyLPea
Ddc8mgtTN8Kpy117GOTXDKP+IKJqW01fLrPJpgEhFiJCbyElLgtCRWmI94gX+y4XNVS0Cd1YwNw6
4nHgnEdC7fXARDKcYO3VsWC/pdzPQgursXloNLrVYa6i2xr+8E1V0+nSWwNYQZP7XUIVqXKMU8Ea
bT4acXrRCF/5tJJ5B9JparYI0zxXSbaakn1dIw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2022_10", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
mfroTgL8g2pyIXQ/mGO9YHm19cd5mOlJ++qpusOYeVxGmkIhvF4aKx+AyIUz2yGGAeCtOzIasHty
pyqKgZhibSqxcpHgR0m6GOxXXOXJiHaK8NzxUzXeRJovcBI/WjtDhXeb1LRMI1J97jVBtJPJQH0Y
fGOD7jWvkvQwxnrZdyLp6kPWgSIcavHHDbO7iJv4gnyGp6W3/FCDo2RKWNLoW+SNjSdLZ6YRP8a+
ldaGU8TYvJ03KWlmik7repuN6AwxCjg2KeQ+x1sBAEXzROXomuSbvX3ZAo8UiIKAQY1SJumHLG3L
QI/S4Wbl1Hz6LDTsttMwP480gq6+tb6s1E4oWw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QJIabgm8dx/gVHbOQFwt8maOKVHFgkpZTPR6dzD8fqoGo9M9oGPTqBqchtPZWgv2UYFF2KEUSlV4
L3SDXBKrLs+NsAVTcICaEMiEi6j82zj/C1LsPkQfS8RLrg0ab8lbDMb5YqJ7lkHs3iM65x2iN1Mf
66cTgCbkAdl3rDpab75btpTQt5ZKiq5CSY3RZfyIW0uWbTGTELm6liuRKM9+K8BQwTU7A+FFFQBA
/9eJwQYzNNA/iwoYJ2WTPd6pBlzXriNLu9M+/2bYicNBSuH1PBR9v2ESrTB6k7EiV1zvBXV9NuG/
sFt4MumWMuSNwP2W38bQATxxW/l0IrmaXGOC/w==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
lhKf/Vgj6pHpme1ji4HVe36BU8pMkam/2I9lFeyOiBnIbzgdEGfLJBcEvkL33A7s0hxa6LFbHnkT
upgMpPjmIghBz3xUQ13vpiY152thFec6qvlcdg1r+GTmnBOSFl6g/OfZ3eFUhfsve6ZjQHpXnKFo
a55hN2+eP1EG9+VxGeM7XkHaeFhEIry52qtnmg072KEFIwRiGs2d/TJ4AqupuIdIiP1kTN9k+oqa
2ta1vdtqPY0dDHqrf+5YSd0CejkhQeCqg/bauLP3755SwdOPRgooG5ANT8hUpTiFMFXtU+GC9NSp
evJtMHUy1NbgMmhFHO+w3URLEdjSaBxZPD7YLdWkF65jY526tJzoek+BzEKoBaGfCaY7O1nHKXm+
89k3rPUy0Xo4/0nHpno+N/Db09heJPbnGsCwN/l+KnR6Lz8kvWziBjZe0ijOkKI+T12y3T1VeOtY
H/aqtNlQt1mhFwrbw6ezaAiDPVbCQXnly6b4tbb8+nFsxWOGIGAfLozB

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
PNsQ8uEcQYrl+GaDuBaq1tQ5br5aAdaqHnyrc0NVu/JnQUk53jaiLx8Oz5fNACvWelUUk2/C+P5I
b2rbU1bb/dC6TqC5J1N0yoMYRYw58u4Lrl8Kgqgt9Rlph5Qgzzfxp+oblXF/pO4mRyAXpZhpNkFT
0Ar9BUtPOTOtJ9/g53SRnZ6GjxzfeD+25J4fcXBNo2gCTgUkwiLSsJRwTB/cJmn+dZPwPdIOHEP9
TkfDK+OrbLYO3T+DFBTCMRNH2NB1J9sc5s+nPU8iYnjgPTo6HoGW+LIlCz6yNJMZzJzoeW708utc
0fJXkT7vLDVh7olvy3V9AAY8Do0YR1kiZlhVhQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
zAz8RnGHFebkJFAS+gjC+mXHW7m7We+JgSmIz15mS01u/4+9Ng0sJfkeXOClmVPTQ2Mp2Yuv6/6f
ehzUTcANilWsqLM6Q1FToCPNX/NTqodlcHirGM7b5R9yevouNT/aqH12nmbunBQmBHmehNutdCjG
r6Z7kZgeZ2ZE7MMOF0rTy1XHEPkqgMNTRoS8R/pPWPTW4/j+bn3aJj0Q/fTz4Gi3mbSUKWs2fREQ
UKiuolNJkN6DiDvhlVYHUyytXNJG44ikmBXehoQQRLapkYaxnQmMRT1ok9uY6pKoy71CtvJ3Mt2x
EQv1GU2i4qQyAOwa0mkEohWXduicU6tDz3zQwQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TK3eE9V+v1z2P1KjG4GrjhA1n3qDOpNzLGXdtjnjhF0QBFPSuhC+nmNqTPOb3p2a9r5KD0miY3Cd
+KpjH6Ao09E2/LD2Go4aLQh6vP+9BldlSKEwCGfx2NjBQrXWVH21lQR7IRjOvyTOclpd7SgtUJLw
dvebETyLiKr9C6RfnIBeptuCA3iJlXfwkh6I0JfzD5WBizQkotioZmmrXv5105pCXQ4Ta1WThFsA
2ll9dZeSjEDHUxxhfyfjryv9m4VL89ZDU/rGITsdptwB1BC1jLqmPDymY05lyECnjA6NIR5GGfI4
K2y2f4GfikKoN5r9IOvFzw963Wm82ZZPtXOKGg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19552)
`pragma protect data_block
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
VQ==
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
