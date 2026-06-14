// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue Jun  9 20:30:03 2026
// Host        : admin running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top l2_way0_tag_ram -prefix
//               l2_way0_tag_ram_ l2_way1_tag_ram_sim_netlist.v
// Design      : l2_way1_tag_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "l2_way1_tag_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module l2_way0_tag_ram
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
  (* C_INIT_FILE = "l2_way1_tag_ram.mem" *) 
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
  l2_way0_tag_ram_blk_mem_gen_v8_4_7 U0
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
QQ==
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
