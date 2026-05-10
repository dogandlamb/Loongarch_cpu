// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Fri May  8 21:02:55 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               e:/Loongarch_cpu/output/vivado_cpu_origin/myCPU/IP/l2_way0_tag_ram/l2_way0_tag_ram_sim_netlist.v
// Design      : l2_way0_tag_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "l2_way0_tag_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19840)
`pragma protect data_block
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
bqAk+w==
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
