// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue Jun  9 20:30:04 2026
// Host        : admin running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/h546d/Desktop/chiplab_for_Vivado/IP/myCPU/IP/l2_way1_tag_ram/l2_way1_tag_ram_sim_netlist.v
// Design      : l2_way1_tag_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "l2_way1_tag_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19840)
`pragma protect data_block
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
abklBw==
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
