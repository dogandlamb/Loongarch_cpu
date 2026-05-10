// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Fri May  8 21:02:53 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ l2_way0_tag_ram_sim_netlist.v
// Design      : l2_way0_tag_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "l2_way0_tag_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_7 U0
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
vOAGjVIhghWyz4pAIurHacMmIcDI/Ks/ToZ2WSV2iSWkXUh4pvnlc/c1riUtfdIvw44o9GYJlwsm
dPli9WBNhMlaAgvg/DO/3saeRQTGC33CR8qkmkGzswxzIOXjbfeHe8DYC6LbhS9D8yEfo5IseIlf
8fxlIVwrmalbGcWgZ8YDl6RgJMTDKP4vhDt//+rwWR28Y7fnnsL6UoPL240g1d+Auo0z/A3GyCR9
Qn2fLtqvrH2ZZ7FS11+9B9Gx5F7VZUIbfqiF06XWYUhSOftXfJomMyDjQGz/rdxQ7d0Hu423mBSx
WCRYJhMbCgkD7DtuSMSTlnxAkd2jT4fpEb5kJl2y4I6GNwItx/JMUIjZQzN5qLvGr5FO6rq2Aylg
qKpzPrlAMmWX01IODGYJJyfgFtv2ofD2BaZSvd+k6xrjYgsK4jrpTbDiTIT3jy89QokC5mhLKTIE
k0YiN3FZWSs75qvzRP2HTkK/cLXD/LhQO0GQ53UNhFLUew/rpcUZsXYZ5xV//8hozWk8rn0J7lQz
B0y2dV6NkQAyF98eSHv16bPpVAo8mEoqXZYFB1HHD8rdL5/eUAcxfOysHH9hw4FiLUVF0wLoBviV
hAI7+olVcTJ8VUX1QMCV0As9UojkGCpNZwZ7q7uGa4jMa7I7Uk2ptoUdCyv0KzefZ6ldyqnDGv4m
1VgI3+TZewWSpXQBAKDrp8p6CvjFHmVRtKJ2q3bFhJCGNTKWmS23ACVsfWkoM0xu7j3iGwS+Jjl7
J0EVlXcs+tHtdQNwqpPmuRXmhFOJ5HxOpnirjaUoIZZAjlZeAqiSNdRs4Yfhl/NSndEwVh31OiV7
KKqfO3PFMuJ7ld+Za4/lKa+GX1GdibbzyjuB+PyztlSkvO/pkI8mBHWGzzjFgrAltvElUufHl8Aj
oh+wQdtXkvRCm6Pi+yLAMnZtDXTAPnZl03T3N/QQ3EEBHGAlP3RuYg231zsSI42OEif2o3Usf31q
ddgT/NM4i/zRF0RC9yieKYcwhptiJ+ZBUxyZaFdBDNhLd1WjnFb8oSlmHXihmxIDYEfaZ3nKKbUJ
hksmDHnAlJ2eRfS/M6aGlZwFek9m33n5UU7kjphtxagevci4VJYZHFIdJd/Qyaw/b1ZFee43Bmkj
rYwZTTjnwbM62BQoRX/ujU3mPuwaWVHcxHIOkq6K//m9UTTxsmjxho4L7HRR3V77JkCIOa0AbFrA
UCVV7wuSD9iIPxwn215mesPTPS8QqW/f8vnfhG6yw6NA0cQom/2pkDPOYZsZ2iQT07q5R+adyHi6
hT7UNl5Vf5qCpTmCPzg9YiQmfXD6AZMu1NatDGYNiWf3A4FsYfy0mPARoDVgQ5BNhOZ8kkbPkhJb
cSofdZ0090jsjdnh0dULu4C/1HNMpnfYEmmk5Zwzk94ZCn/wwtRFVllALPlDFFw9TRGD7hzIUQl6
IWGn5fOSq2jQGrLBaDNXjc0mnic0yLmOYG4lpkg5bXodudF1mnt7APC68FaU66cak2YpHZpy2Kpl
wBAjDkGn1O3VZd7cC/dT3hZ0pHY55bEvMMyhbtC469yLkd4O315bU2y4GEchARJ8CfPr/To5N3/P
o7Vx8zK5Pv8MRd2ww6ofE34tXhbCeuodMP875jHsvYq4TBhyiisf+0vtP6FXHDpJHhBKgqkEoRgN
GHSu8Uteg6iugHz/Qk5dSKafBmE5rPn4/4nFzYZPChM2E1dKStadCiAwVlDRYtJva+eQRBDEkFw+
NdUFwd+5iq+4uOHI3vGdQZkr+YZe5T/df0up8yZiPEQcdynKpNbwTJy0VHt96uiDg7HBS0w6Fi6Q
kL01zb5b0TgSWxvWqPgtytNfmO94fMAEj7yFP4uvXFpKt8aOYg3+P56Hj61ek5DIDOLMGbhBqYLY
h8t9ms7NFPT0nDIRFRWCIFBlKzk+P35ceKVSu2qkOK6U/A70rmo8oE3yDWqnpfpyaVK0n7ykIgea
wrndMGJ9G+qLFxjXjelL0ZdtzGxmbk1Qsrz7BpF736kLtC29uy0Sdhd7HV/J+AEFUYzB/HJK7PNn
kcbiVj/pnSENqaRXWC5cKfd46MuqhhlN9hW5d083xUeN/sYr7DrKhm/0bzb77qAvy8SlbX4NE+4E
6eJcAwspXYY69RUVhhBgudx0PU9rjS1pxliftdnJ8izYJH+N8/u88E9aHhMiShkd2khxDl/7Iq9/
k2bojeGJRBP8b/H1zA08WEAi3ugGrolhI7qx4dhXQOCcfR5J+Y+KMcjyepwbX2p3evhaTvdPUnWW
med8sa7a4UByW3C75lHwdvJV1V9vUDCcQu7PRqRQMUyeS6uKGI1jmH/p5ObADqN2gMQPRDIKu9x+
iWnKqd8RcnV9oGCa2pCXHCkkbYPc2pXcQHElujp00f083LOvqnAZ5EqI/KCPephztcRgjFXfZrXM
IabsHd5qcpzmO2KO4R7lv0vkNwY/DD3P28SUJwVCo7EbJ7HJ9u0jjIc3C1Rvf0anlPocJrBQj1zV
499U5FzOXsiPbUJ5dOl1A7w1E4a+06id+C50ihTX6SuqMVrEsSEKlxBNovUzxlCrHpQBX0Pez4bU
17XLAYIWoBtT9mCz66/YDgotD980llrTFV5eu6Kc3LzTC5vy156KiK6C0pxlE7hX5cdpeAJGoo5+
rIalJKExkNo9Aoz2K5Mrs39z8jWRbjQOpREfqOlkYdd0YybOw5Om8izYGRmG0DT1kj3CTDdCTuBx
yKZfaA5KERFHvsOeUGEY1nkBBazTVr8HeBoPzZ5ieCvSebJD1/KVqItL4oRgt16wJbCvWuj/D29L
7iKDUP1KPzgm7jK8hNzG4Od8CH/9J5Eeqhno0zAdvVIm85VIteQDybOz1aqAaj9CUckLdjqvIH38
aN+IHFSibKMBXIKeZdY7m8CJp8PHSZH78eReGscRDVo8jJPEXzS9ivty3hbiaFWUH4W0M5p9dNPi
eAzve/eDKGnIVHTrMjQiaAd35fkdT0yfjraUG6Y7NXQ71UrByLogCfK/nrK4NcxEPetZFA8WqtvE
aN1YoXFMM8LoS/KJmFdiSrkdyjZ4pyyrq0pAqIfRnNh7kxUJJPQuD6mTmziF5ubd5bCWQJVgF6Hi
5yJTqO1d8XTbacj+r3BUXhVWEZDCORyKeEPWrhQ3EBY74Row9Hwz3omPbowHqyRCGph+CSjWwFBx
l9QROyERPWJv8dZYUsk8utmR3w5ew8O4OjQ3ZoUrGFvdXoigkC934paZsSjg32KjIhrhGd4p0vot
OfAPZAOviyNg4YBodKNTqD/VpTpUZ6mqCRRkoe8Xu/EQMrZm1pJLXeAmhM9otyQptjAn/b8ROmO9
akV6C4DOoGvCtSACQZXNhLLlID1v9zrN5T1M05kZcwwcFFVjGb2CRJ0/1iunA+s9eUzouV4iVTg0
n0gDi8GlJWhjQPf5qgtiKJhCxIvblnKvVfNUg+dnNYMD8dGUK0VDDMdbJFqDWhP3ZWBw2KIJjgG6
tyj6/H3rkt8/WxAxlcUiuRDKS5kmJjxQq20cOcwpjHE+0lmy/4hy4Ta6x1RKg9GQ8ja5d6bAmk3g
RshYCu+Ax9oMQMbSaa/nVM3W9/PvKH+zn2vlPrD3WEFChAaNrguwc6D6TACdi/fi5k/RNUASqbKo
8wf/9OZJJ/LzMXQhORxvgiEKQGTwtSsYA/ZuA3BbJBrAWlKg2hVURJqrE643zmnlpDyXrxJpO8Mp
rjTL7/kPXmfLR+ZRvQRLbyYKuoG0WRtCVg6+bdZYdhdP7TgR4S0WbN9Vz1SB/c4UD5EU6Vbl0hD3
gepwIxNdF+a284Id0djvaQK8NX5chvxdRV4tg0L+AjTRuhqTHEH/Z3aN+QGTy85bNqMZEdoUQ272
aMbkaitnNTEkuIQA6SdfxkVttDc8l4q36YGXC3VLxOfYYygY2Q0CHt52bRKAtZ/nEv6KSKe4WkuO
u7fQgNWJj/NO2KCGTAnXYYxdj0u3NzECbl9lWoyFDH6thb4qSeS4f/M7PJWW+HMBdurAUt4sibzA
sGlXqgGLwu96bSGeymuucjXGn/WqKenahJddtYPIIDuX/K1uwHRG4RRRYU+A9swqkvd62rNDhPqJ
Phkg+udQnvXbKazzsWNuKfpZqVPJz66J04PnENcobBG2oXUMUyGwRYzIbXalcdn8zYiLoe4qINU3
8vlUgbg2sPqL+LcPs0G1KhrF4WtoMTFwffhqYu7orajufJ1EEcbxhwJRadBmxcnk6BFMorVOrPf5
5tR73ter20ygRoWqKHhZGhoIt3At9p+rvndbT9GEGn27rqHvYgl4WOQop1tbbXwdXdBlOWx5NNpC
0o+jMyBvM9b7Xw/6dqatDHsyZ1RPkj+8LLbvvFJPlnoJ9uiMHOm9bkp+2pMcePf9dEAfEnrQImhx
zaXp7lRCH74F+iDUrGp7OHjfk8U8OVl34REj80pceB1D9WWa3JbikTa4uQY/ePfWYcPNpIXn+pvE
/Y0sjur7cFxSPkLCd0xX2CAyL35LBX1XZdzQYI2iuz6hNUZEfYBUFNvdfTcP9sRbakrPTyHZ/r4C
+BMtB+kj5hjAGCZwLcAJgKSJ0EqjGbY3/GXGmJHG+NsC2akKUjsAh5TbPzDH0meJeZDTtazioRRl
5WC8+hQlMygANwiKhr9IXkoaFc4CxuIpM3uPJ8FlWq861yoxwp9banH3wG2xUFFwi1GMiVLN5BJz
85AqFHLYNrm4FxVbkoEfECSNYUWY234v/CoScpSGOSgEqW6UqDpw0l30CWk9cH9IIhP3/RELYFpU
omlhgpraERAAop0f7jSMBipg6hmvKXQXxtlNIVH/wA24C99obGt8VtLW55Xlomfw09k+bp+FxhTm
AbpiO3rDshFAXhsMtjEtnBe2c3stgXEkrxa7JtNqqwEQGUg57TSTBlBBUFmZk7i2TBk0XuQyPsfO
MzG8O4NXH+A6oDlOTFMeZFhv8WpfMaVnqnrsc/cThchKpGjF4QvSwPQWe4eWYhWYPXnSYB8eDyKq
8WOh2ny96fIqHiiZVSUOid3cyc4ZRMOFzYHcHsID6HOlBkBu63DrWhwUStyNv4maQmiux47NDLUZ
ct6x1951iw91UXdNBjESiIEi34HttglSCZLefpT2ugvRa9dgkwkDvUnrmdq1aHVHFMSp3oAR8uVl
YZT5V4q9PShhbIJRIHjgdhGAYXFT1CT0H6dZ76PTaS2y9i7sDGvUogeRAs+Tu5fKCWcLDP/uemY6
MqpV6WYjGGdutwwsvFoB21Tb+b/u9+6l4ME8WGp4/yCP2CU4jJcgZLkXsOKesgMSX+qvLDZRXWrf
SAJWdHIYIuDCYwhREVRu1Erac1rokesJePnht1flNPnd5qfl/mWzzwi7DKVXEOqNS+hnIcAsiBHH
lJAbLTwaFkuukG5p5w5jNiCPIK2+wy5GCfNia/O03kXqWEejGBUA4y5PSHeTEfiRqXSShFBhJOzZ
eyn8ch9lr0TmHf9JBrLqmUxef9pkQTez+V5IB2GW74RPk5IQnpX0YoyH6uHfdzVHkhWuC/nvPIRC
lE+UfTJmiOYqCcnsZn+YGmZULucHas5rCcEWx57TDZO4ivjXKw6yoC0WvwAYb+HZJzUnPHkeG7On
7E7X+O3SU56tN5X2zcUAX8zRY2/G7nABQQxjRYg4zPt7MnooOLX3QlsP/ZIzUDww6Kyl73GihvdL
9HXJkVZ5q5fKY23IY7lqjNdvTdOphGptooWzJR41PcDNXJRSkaBsd2m5ZW3T+2i33aBE3dKugHWQ
r5AweG5j07eRMyJn57Nu2eJVnAxGM6+Vdr455SXUraXJQKVEJcXkYf97t66WOJcRAu2Wx+nzkAYz
8hZKlXgFiciHImfe7qm+aH4TCFGIGObbd2FkypiaNYAxojn7WJ/ierwsqBIHH0lLMRuYgr167Lrn
VPTiAMY634eDAgoBzeP8/mNazZKMTZVqKY02b/vqLfLmk9wPLlsB5rkBSaXjKq4oFrGXQNBwKjJ4
vvAGKO9F6+tiDqcn8j7uMympkktDsEgxEDWuw9UZNCtf1iZJdQaWFeyNB1hmkMp/lU7xgnBJKkWY
iEfTjxJVT1lxko68oYY5nwCDEleUenRT/6LzjtnajP1ppY2dMBVKqSnCSQr9Ppj8wcMy+0W5BB5r
mhvFKYEcc+RVt2wJShMpChUqiMOW84TDbXrpRZ6jAxmQASOkVMJPAZyumIBUS4f3YOzffAG00WOP
ym3Bd2PZLfuUgAazm7AO5vSE70CZoNIX0qAlAwR0yvfbc74tJVEEeILyOot0h2B658cxRl7F7Htx
AFIRNTR6YEDtMEguRkKzwblkA9/Ah9a8aK+WTSmAOv5jgRVMq57fEzHZg38BFDT+r2XjWBR+VLi4
6vE11F1oDVSvh7a4/6LIEJHZPzQgoZag8DQB37NoL8p3SxpKDtsYskb58ReR3VZO79H9T5+4Ieaj
FPyCM+Yxbb3pP0Jc7CxBWLCCtuNweKOdYz6C8ZDfstfRnwBdwveVDPUDSe37B/J9KeD3vQ17HiYL
idlpFJnyGxOHWozrGAbFAuVh5cSjVILwHfDV0ZFvprLt19qaMuJOfV/xFWISVbOAByZc2rozmrl8
ZT4NR02rXXCMP/+MGXBX1iYqSRtmqzv+h30AdQUV8bloAASRVe9qH35aQGpfQ8Ux+IhTlz9P7s5/
O+eGNwWKqmXtORmHWJbgsOM6MSgzJ2n0KI0EY7hhnQCnhPeYrvtHCerSsXsZKI0CtknEWzKrd4Qy
2otbjXr4y2dRqjrWZtEEo1mxMuKXhSztWY23iIywIQDNTlf9jgL8k8xDGzEJNcF2Zh1tg5Kj+hxV
WfdBoLf3l5PetpfJfYmm68FAh1hrOsXAVMshrI89ss/Nfu13YMTH/Gux3WB5qae6GHbVQ+Ryqxp9
i5B3F/mYcCgr4Ry3pNqzcHVsmsrUm9gyC4CgzSSNKem/wRUp7QtdasNW2Vb9oF5nSU7HcVLE4pNJ
6/xRnhiOetVbbr+05PAinGlZ7OPpCr9ArtmK76SNuNhgJ/ecEkcrVbfK0Qf17IJopSXToNHOU5Ug
hgvcR35+NwIoAH+w9/pguuFk1LmZA/ax7irVV7aLRR3ypmYZrcSTeyYO8GBOuj3BMU4D+vwdsU2Z
qOao5AB19D4ikPTayqZm2n7MPA6+GQ7fttxAycW2l/dO0e1QRUh14ASv3SPlUsD2yKixukZW9dq3
2NyFlniPFnY6RylB9yzTk8b5U/bRFNR5YnaYyDioQst/p/TnUVijo3bFEwKoGAwV9AEqkVsWSBXc
1usAQqsQO0r+m+V7udEtDsKxS0DzVLMH5r58gLmDibb6piwWQYdlCpon9PLwaZGIIRrbHvTMPjW9
8TSp1ziMMMIZl9uZPLNt5I1AxZLXD5jkckNb1mi6lvpCy5TD+rpBd6w3YzpPe1b1ohPGW7lvSvlY
voFl1CRH4iWPHLQFZ/2eFU9PIWU/ryhMDOW2dJpzRAgDM74g62WDlBZPHP3EA6wawD3hRfzlVlfB
QSGY8zkkqCaXyrUQ7on3WgiVxkqKbdsdVHHNNWq9hJt5I7w5Z0UZDM9XN8c3d33L3I6/O0HUbwuh
C0jhBJj1qG3faRQhXqxl1/pPug9hEQH1Vn1GJmGPgzS9FKOodKRssgvzI19rQvBQ2o4KhS0hbtQv
2b+NNGU2DQeMIeYSy9Z8HYcobaW0oUq74u3zboekvRli4wmWtiZjh/LswAJkD3kpHLh9uktShbkm
RZNFKl7DXwwPPXgmqrhn8x1gw1B+sFndKZbBN194gvIgMALppQQ7A7OVJsLWAg/1SKjMYioPa5yr
h3izyxzYw0ErJw0eytlmfiGv8i+cSMQAD+juHvJUbo08jh9yabylTzW/hemyQtixg2/Wy0s46Sh3
5liTpIAw0Hl24V1/t3VvR5YrthA27Wy+yHFRUpFk4WWseoe0P19t+I5FHsYh7ozs+50wbTE6hK9I
nMIGnm1PPfTPBxZrYjJYCQQO2zS7Hpav3D4P7xyPlRrm/ih11BoSRwWf4lXncvY9D3+9eV3iwFL+
jav0iINq4++lLQcDLKWpjctLYFGyklif/XUOnLCTtDLYnMTdJ/FWqv0QulTEafcUekFByo7nBVUk
mXFv/YTKkU0526IC6KejoykpKspvi6qNl+Ug+9Oh8vveYWnUVMRKh1c/c6+iEE3cElMZ/hWLwt3A
XL7e1H7LH3ohTaaOvn+L/5cQTeWgSbdiajIpl/xm3frcRNqu6l/DFuslg9gzBIab1XEe89bZYAMG
qiapzRL+mTHlMhJuORmzt1Vb0gE2Y4Zm8NImvArrcORJ2MOznn8X7ruiryx9jX/elunP3PoLXeAz
VKss+rzzBm5JqXOqu5+hUtnFDgnChqWnSmtCGQzEgINtfD4zWsor2A/FuR0DyXoMfsELAMt8Dj9F
A9LGczmR040A7kkILXH8NL1U/h8Xb+ZzgR+04YRC1rjJR37P/mer+SfxIzNDuIskrMJ5ujXNgxME
oS3XUqWwOquQHpt7GiX8ptFMAiSJNxWW4maKl/2shHJj4L/lVml7BUltVVCoxxSnGtXgVvHUcfjX
AdGn3yMxJW0KeJh+/6lpfW08JpY6iiKTI2rcdAHXZCqoP67M74Pg4F8tUj6nD2qoUbFetEwO/mPU
kSx7/qyNbBnQhR++BU3dUlqIxvR3Zw/ObBM+AuS04uXBA8SgHmu302pyUv7kJ92kTalYlg27g1iB
jNhfm0lQ598ddOHBIZavqg11JPtx12W+ymI2LV1OLxCDLbJs0d1HYYklvHiSwq50E7QmT0YQnOY6
kvkI7O6s0lHXKwNjr3MUx1fSDafreOpIq/VXa/aGT+az4PWdvu5knE/fKMvX7Aa261F80ZfSaTxt
ct6W1SLDRKx8fHLisS8HWVACq++q7QM4AG24z9FZ6sBlXAUJ3bmcTY91FlP3fIafpmeEl64iY70K
PdnazfhpMWbEOc7fUGte/d2mjC4itkEWMLpPNK8i0DmZSTpx7yil23bDYsydErttFhfQlwRS0mif
mcHA2cyTWZnwGBMC98vRVoB7EiFAyfLpILRMBpK1UssNP+IgGUrdONrN8G/9jK94VBqtAByBcuFq
lrgdKK442z3SMy6LAJRpdfaX6nwq3gKp0KsEsAYMWH9Qq/3m6MIByNIJvPJJ1dy6JKvjRHJwwr2R
gpktP2CS7qlyXqf38S9WryQGyhaau7M0ZQAEP/fapQjGhieK/z6pEfyukjHPzte7CsAZ5+UuZphn
Q95nwrD9FqNlsbCkj7bxnM7vpsUbSuGOE/zKd3MgjAb4vYZgogROjpOxoFbWRKb3GN1n5bh0Dn2F
tC2mEynQA3qnQcMyXbJQ79YDYM9JUgforfw/fOdq/MJV3J6zNESDGaaOg/Rwwd8ETRlZyU6VVbxf
OfNhV0azd5PRpegGW0lMomNttMtsW/gr4nvXL3pETXbldr+aM8h0W57luYpkDxrZxirI3o8CY9xp
3ub52GlKqxXC7zoBDv9Zixgx7h7Tk5H4cy8Z+GjYeR7i0uNSzrehIGWNwzGPZGhInkfNt2APZbij
MLSUTdqxxxjUW6oiEg9VBEHvUvLxjXh7rAMZ2bymll7zx5xdgQPAxZNkOU4d/5GeDfQ5n2WQVahR
ZD2hifDTthFXxhKeDgY/sIMI2yWKz5yKLdwzwHR86bW3Dy1uA3sQHOdrD7u7m0abWem/1fe9Fe69
HOvlW5lZzrSi9oHCCQAvQC8t06up/2LNxf+8Xttr+Q9Sz5iQR8GLOyAsFCMNJVFVRNgxjzI3oohi
PSIZ/BPOBeNGbvUKsnRWee7R4bwWY1U5HoAvAX4DtIwzvzeMfxDthip0kgW8EbP5YmSo9rNsX9hi
uPI1bseEkHyl051pZDpZKD1AqyY/U0Z59imDMIUMyY2DuxqLe2/z5EihozAsygo7L9WSKRDDZWaC
C79BGQUsYz0D8GnC2WX6B7KqVvxeIN/IUtdmFU7u4ZsXouCHHvO63H+4rdiqD7v9X35MnRJDsSGQ
f5ZBnYXaBXvhfKp5kMHPJMjmbpAaDnwrdmS6liYDhSI2z3VpguB6xG4O6i2daAkeO0DAIF0SyMLY
9yI4Ki1Z2/SH02jogBcyYMs9x3CAlsVk7hYA2ggckrQeTNCrpskcr3xY8YnUiCmuv8ZTxd7vzcyE
QdJB0CdKiTZOIzB28z1CBRCJ1MEIuo569tseTunQIp3f2EHLtfiBx108WTsc4HISpp+XhJgBUk1E
MDTOiOGk+grGZrdPWifr5P8b7y9++qxZ4fxunrKN/R2jiT6Hg9g36K07fklgiMIUbshxE5Vw6es5
O7xY2j7opL04JdOR46HPy87SeQlli48SzUsq+YJzNzfyI5Si2Rj8eRnqxeYIzKSBj0XdouNyPSQX
Ju9qvStxafx0BP+PtbKwsCR9pKzVnvEMlF7s7Gi6ub1KY+FK0I6AO8iPVvFM9rObULpxJW+XWHXM
LwkfDq9+1+h0GlX391+verfpOoq5PVIDzjfoz5MNBfBTeQBb79si5pMj4JyelOd4UW09qB7meJf3
J2N7BeitskrQkIsDhsjINYSlKaM12oXFsqgt2za3Nwfwbay7TwhrHwA9GzSOdxqAbmTeyxmZEpod
+rjHeisXECsC+e/C0LC4XxnVd3S8dJmljQs+Y5EHocNlovNn0ZK3MMFQn1yPRnHadEyFm1puxQhl
16zrjspPyVe7UEnfAEHrDrd/0eWgRVBb+UMVlbSofVUxPDTw8vZzn2LARP/p+nITWDKGSAi11dj2
KacDDoMZTD8XWRO4o1kFoeXlFoRH7R0U4z8gnk7/QqI7lLZ7uO2z8d++E9bx8+8tENNGXS701zK/
eNmXvnup1s7kifJcTavnf2P2vBba74oqei4iYdnFcq5hj9YjLGNO/Vlg7luQY4eHwtDy2uQKgZF4
Km12YsMIWjdP501Sn4VPk5IymvknmxZx+8ofDS+NQizrRSZTOGQcQN4iREWXXXvELjGSFMm/7EwS
4GLiWXrYj304Z4WUPOQm+6Lcc95MzJTT+xZxeTXEVvqocAop5eksFBduNxrd/ZyocF41c2SiZhor
VPlFs/dbS7xztR1b3DHWW+OddbP+NQpDRBYwPP1XdV8f8/vO4QFp0ZDJONfqh6lTaqpsqd4CpZCO
5l8SaHYePjn6i06iPy765phkiCxYgE/eRHvATNpwYWIV82iu/toUfMhUm2ZQzac3MOsOh8LBUbIM
AOJyKwRA43lt9ag1Y7VLCrcBRc/tQKpSkGTaWw/B98NeKeQMlj51BCZm+t3S+n1JqRR2Al0INfhn
FGLHy7XI3cJO1rvqpgqgv00ElCbPuHL3G+8uDD+/zBA1w7JN0OHYxdjagYY1TDPywnaswRyu8MG4
9/cbJQ4/5jGJ6PUfOenv1s1AY0bSXfL6abBvrB//G3Yqo9qRShf1VSXAlY72JC5YvCUxn3XZORF4
XlpXj4G+JfttWduAu1W4R2a4M91ah9uVoUNX97yncrUQG35VIMcYSXY3QSUwIehCHSiGcd4jyPC+
h/YIYWXZgDDYfBtX8lXp4BQc+cx6LJAqJGRQU9A88CywrvBFvR1WIdwzjJwzgQgI46yDwK8BqvhG
5yrG6Xjg5K+s8bPrprDs/MtA+pdTJ4uOiGWvqIJGolLcCeA1eQv3hoaPnea0F25S926X7YL4Wll/
YEFpH9/cEd05HexpWamHYv1MyvRdeUU8FFyKkCtPZqe+NDArHeSAVIRzuK+HGN3Ag/3UxK5BZ4Bc
gwPgHfZRP7xNUzcqvFKpFhknxD7epHvGKLqP2682XEgiTdrpePCAqOgzt214vQ1mWY29CxXoLPg+
fVdWkZfc+tMGz5I1OANr5xYasoFtOP/UVqgH6sgQRmlcZU/623WR1Lk4BanJfYv+/dOR4TOGa02f
ElTm2UCdwBpWQukJ4MVi3YJ/mut6sBUjU+rYJmkqW9v+t2v2euxoOrJCLIkBmZpydBuENOdLeuxr
lrurcxjCZWjbbdk6p9HHHXCx39aWkJZ0pzAv4slvt9WSL4VQObxjjs0RH2XXuWGjo1HGCrNpoPee
WdisSiLi605Vls0Zvm+hVLpaoA6GaXcL+DJQJjrUQ6UIn1AIDVUdJew6etjKzSgDXxVwhnaBt8E1
QA/LBiJfvh2X1rzq+unFvPw/GRkM/wiCJ9pXEx/cHoSZQBl5dMa9SGy9BFsRZPB/RvdD/jSbJJ7y
2gCX+7xeE5wgNRYJrVb0jvuXnXsy/6kL1MBqUJpFKQnuOCJ1he48bgcbVLE88rKHHMvMRbjIoXTd
Dvi1S/9OTOojvZBfyPb2ok1p3RdC9i3MgixW+25hJLwd2dJjXDOlIltBHAy60SJg/Cd/O0+/zF/8
fWXa1NzVJad6I+osjwF2YXVTBxPOzB22J+lcpLvUPrMVL84WoOtvB/uCEHFfCyC0mdleZDvB8to7
+0aA3mKo5pvSxL13rJtdeLFq6+mezOKnnuVOJeG/To28wyGXSCicB+tDH5DmmZsuZ98B+dPIHQgk
H+6CF6r5P8J7k7qXqpffy0Y/8DwcmRVFeCyf5bRraYF6suiNeBh9/6ENUGrECEYkJaVtLh71B1+4
HJEbl0zR+k7VeXOUeVzCgKioYii4gYgLCFgb1xXRxbtQlLIO0j27RmE88DL9RAviNG0L6Yp++ZOe
mqyWUiCwHkiHTvoxxG2dR3Vol+vRd9OqGL9gT497O3TosGvsR/QWD/h8WIlN0nf6SQ0AxdAGFeLY
ohKzHEMXKkOs4esF2plo08S8yVRR+isGbE+xGO88o9pjDbWu/0jaDhuRbZhHD+oWz0RCDeJGSOgk
lrsC08ynbQlwbdUaB+FuhpY3tf2AP/0nOGq0TU0+kf0rV64lRS4FzbPTzpvvGRYbCpX1Eep7zEwu
jOBXml5T0aRk47aY/HbS+flm80u8OVBTh+J15ad7ARcTlQgScW9Gsv6lOPldx6PXwyz7OqEN0ht1
kwUXJRS6hmnjPQcpDTJwDyNrBNA10sOQ0yavbZPe2jDvKzgL6XM0+/VidlDnQ4F2szF1/tnba0bM
zK/xftUnjpGfuwb2nGoHn0uBWFRQk06a9szERCXp+sUCf8lDYahU1TqPH9nE2g/fDgjsL9lR/vy2
TGKpK6H4w3YwBwguWFb4ob5ANwSbQ6SZ7EpOpBJF+BYBA5366Ag8O2HMcqIxLD4AIWVEkNE2bzMB
Q3n7kRKya5qfBocxZIsX2qRCB8eAd5EFfWfTXv/BR2K9psSlaPrtDnlxcaMx5CbeTWBa4TxZuWy7
pHynEgpc7zFyo1W5WbszQbtKr4oYdWdX6fHlkG4GNxYShBGN5VqjxYnfLdP1OB2yVR8r8jXIsaiY
6HBorOdS+7P7kQiRI05/YHEnwBQB7lBjWUko6iXB6SiVlOkzuDgBVn2sOza5Lie99/kXlGGKmHN6
Xlle8vu6+YBC5rjsiyBU9audz8tWd9w6ihh+QPAKaO2Xt6jS93AUG0S10a8XuywN2r8V0zLA8IrZ
8GDDj/xH5z3oSG5hr/NhvhE3mIwkVENVi85rBw1WvILZOz1um7cqJ3UhtWt2q2yB2q2PkkmWVQ9p
tx7/du+aKilhRyX2JF4tYvGiF0VjF5rJcRgdEwHtK6iCbCGy9HcxTohrYW9+oPwTND8dnann9bns
FEfS/mSjKP8iNyn6MaSSirRh2tH0OzlieFfVlCAViGUaAv7Q0iXfquuadcHJHizwMm4TKsV/j1oe
tLWcb9WeflBAytorp9IfJnKdajN1M2pxceCoQFbJIPk8PtvZnfGM70sO6THNMkCsbOnaeWvdKuBz
96LhgJc7ncuNIgjE4ODwNwgZYy8QNJo1eTNQJBPNA65Dg6wVTAebK+DGoMkGi8wWkVuB8dYWFGUj
zfdFaaAqybyYqMzaZZYPFnfODATfFToTTM7hoqEEBpcxyl1UKNkp10dECM0birExfcTYeoOousKi
mnMHQdK/Jkydrf7VvxVU6fkhp6iJEcLfybzqoTKVU2crJuXHeP3hRyT+pzQtoNi4gmRY87ayJPEA
r0Id6y2Q6E+vR0iKjnxAaEu6djeTpJZ1Dko4s4IPwWWig7VwPTSPimflTv35CW+2ko2B0WzpAjZx
lpXmMhCKBDAzzM7jYb2fz+ju+KZPmLix/8P7liGFxcNsxoghtrltq9eCNG6D+MmaYmnAsZYuRBDv
AWAX38u7mYeFsfny8D8shEA5sXErVuoql/c01kFHyxbqDk1H+0/8n+n7/raNPMgh4lCy3HHlwIVN
6qGhiUq2u8MFdH2f4ZPejPh2IINTI9r6uI+gPlTY7bmnIhnX1RqdJbVY9NnGON8GfLrtiT/Z7hJc
VJHRXtcXpDpFpq8l2f89aIAungXdisK8mSOn3lru3pnyBMbTCvBaCUzfYqWiBFdaWUz7LyCpi5SH
ZZPng6kYVY5G4mbcc5vB9EvkSYZbVXjanhYvJhJXTn0gO6oernHUwpR9IQVfaHBoITkijmlv3oru
S8BlxGB9mVtMtCpOS+eURDZiNR5VQfNPi0o5s9qXgRKCJDZ+IDFsQXbsEFX7+B4Ms3JGyAwhPlmt
Vy6UPG/FSzN3zlIemZw2/zK/TeiMi8nNpcUyCQlcLkiHtZJrJJfzWgvGPdf9sPybB4Xs0EhtaLIX
juPde9zbgnDUBJ4ec0GeDE8otNd/rNI9pN1VgfOQQtKOCrjfiIg42mhpO5IfjXIcxGn5pwpJyUpB
x1IrELW88J+bT24B1uqBFHdF5kG+ugi3iPLJBNPTQRNuwfYxm1pKDg0h97tb8HVNNg16eqtPMkPD
zxvkLFX4/2T8wT4n4bJ/VRo+ZuhF5VyOulO6WAsIt/VgqnAsDQ8CDzJbs7cnHHf/lRXc38+Mhxu2
jquR+wvz2hoCO9CBaHSx5+6/+kYwI6BRVEh4+80hhitWcJQqm9d09RlvvGYJXdNWG2Hr2TEQLbyJ
ciQaPZ+U2IzThMGyY37ki1pHCkLIzxzE7XMK3krUTad05pu3pVVXc8GmfhWwWeN8fMTHNym+2vLp
cCORUtE3s8dPBuOVrFCgo8XfLzJ/qaSgu0j/E25cd+/+axA69MCWMJAmLeqywjQpOROIxOg+N48z
DiWEROFLW64ymIL5QPRaFunaW8D60/JjP/YKQ2jTG5/+g0T7fYlt61NoDLGgrbX/4OGY6f0dNSgr
vr/4su7olN/IerFH2TXg6VryvTCEflkZFabL+1rA6k7v4usnu/Dqpj8vP8SmBQHOLm37uCLHHWzT
hj5pkZQ8DmgVtN1umcV89BuvjOBLVGBDgt2DSVviDPH9neJreDGqrPTtFKy6cTojuBAIy5Y0mPkU
numD8XYJcG2JvV7leDdC4uIfagrUGkwAjYOOOQg6C52eNCCbk71FiDsknATlhtEjtSYN5fRUxEJA
kVB7DkqpCHdxK1cn3VomAO2ccBZEYZVBjfyHzfOuuYMAmHWcAaFP4KmXD8UMI67Lg9S3WcUD2EfF
lPcCqUPa3EEAuOI7RswbN7irxv4cmp7Ki2YnCq48ocETaLmUyqoMKAIqA0rwRBhfsSm2Sw/OaIi5
GlggvBG/xdNosfJGTAd8g8UAIbECIX5MHIOZz9yqmvgyPBzEUuQMYK9ih592t7hi0uHWNyOxn1bM
68cTsN9IYkyDnn3lamjXgXBM5bV4LSavx2f677LUAZy8Z20zfaVjqrdHuOaGO8DCVRzjf0AXXGtl
oD2l2RHWAJ2FQstrPTzzhcjd4H/VxbhdoAmIYZFPqUhSzkaTD+zNfT0KIHWunHbrGXVttvBq/aP2
Cgq1Hqc+XB/xWadaBkOdzhXX6WYSWztIf8n0iuoNwl+iLxIeS0JFQCRKmxXLKcOASBMIDgArGcCq
3Tgbwja819MVXCIo5yNKyEwfA6NiwaYpHNiOGQ7Dww0cj4D9PXlTERo9n3SLDg8w6fwVhjfFmUod
GB0hOfnrlhu13rMMfSrV93TzFZftJcWrw1RC43WLUhd5F5tSs4D/YsVVZucc/A+swjAXrKNN+ykA
4Dd0P25FGavyGDQbI9fSYsTHKPndW7oHD9M5TbBwHMj6F/4KuJsHGSABCpO+C8BycsBMQrwZbwSy
UTvW7xq5EHXi1UUPeFCa3Pe6lDydtnlWY4M5m9EXqMVcb7gUyreCVg3iYSiNNiaFjYhWkikpRkWF
tKvJDnBnojVolF0/fd8pmLzQSLWKYR2RhnGnbmHlWPNpyLQSYnABdIcqggO/emcqU4S/Warq4FN/
7yT8Pk+TY9xMwKdpUCt0WFm6B0FQ7I/Pa0pOXQYt737ftJUImdAv/VCbAbvg8KrjE6dpgjXqzmZC
YCTl8gSiV5qdxx1B9DxcJW/lNHsPLFLWO43P7JAXBtv207Pw1WDGjEs8hmDydn7S+tDBvUcD03V8
4WIOd6wJxIinidjNZxePyXMPkf6orO6ZJJcD3P/ptUN5lvk1DGoLUADIeyKgD7DNkhRaCeJwYWs0
Sk5G2ZCXHDpT2ICotnAKNfc3mUOs0k0zUoc+d4pFXsN+my0U0cISdlLRneScRhs+mtPo+tjk/Nzn
ZyTOcL9e1ML7LFAe9v8KFEinqRs/hMxiFEFQhM+HAPyqDNqlHkH0LQrxeMZgC1LXrFvPoQwYhWDb
R+RHtha18G/6hC9sXl/FZvz2NGk73c+L8ugT77aVLza25sREXBcX8gfYW/ASTLqnx60b4L0lIUmg
b5p9m4LZfwgX7drycZcXfoRRj2kVh/U0L7FvVzHjtWC2lhWkIWhWcri8P7920kSPjpxCsfiIq+6F
WucAnb7zTtjOo1IkRHZnz6/Lk9epwgqjNNCaJye5quVjr3aKM/ChpeKZRAIytJPlELWXIg6ZRzNA
PBmSjGHTxVFx2Jrft3ZugW5sEKKMEb40HGAmQpVigEzVF0lfHxJkTzoR6Jz8DKMNYX9PEVS2xrgI
eXqWiSld1qHuQM4XiqHWbBDz1Y2VsNPX3vyDxf7opkb2Czb4gzmFh4V+kUkNw4+ck4EqsRfjQeP6
vciTTFPqu+Ro/rIl8SfEd/Rv3orhPLpx7c1rwyBzEk673d5ZH5Ej9ZVRb6mugR+4m6wm3ZiNYWBF
qdQ15MUp8GT+5pUvzKnS+ngsskF25JYRP6OoOUEvxpTcMPlQ7EnOj+6VX6qm+rJKmEhFbC0LhmTC
cD9OuQiQvSr9Y2Jl+id/4+0GUaRgGIs0dOQ4w+5PjyQNXAQh6EfigqMFuS4c6WA6E83gzGxGaFuk
YKqqEAVpHQXwzOoopDYU1o4vuHf7wIkxZ7MatjS4uzy991GHLkslapdcDLrjke4ke4hAusDcLI9S
pIF9N2inu9QYzaFLWx8aJDb4dVXAtd8zkU6szz1Om+xuT1vCRoIBH3H8iDDrFO2EEetB5PXqcd5F
l2KC3ICOlIMy1jv+Oq9XTT2ng3P8slTrciK6LvxH6Gpu2E8Va4e8lwYb90NoNftEMHRdpGwYdZaO
F3DA92gZBJ5EqBRZkU2FPYx54WU4OqBvV4uaMycXoat8xEk4Za4bpX2IQihK2x+VDSuSk1WYHZUs
U14bP/w57qmU/xvGK3HgpGmFTO33XQwIbmEB9S2sRKZfi3NZK3IZ9iZOf1Mnlud7QBMc0lEdOhhX
r/tGzYoxKbs59/ZXcWrPqFFUE3t6smE67yw89juIU5PkMjX6Sza5Tyftn3oFb53SVKvJjf2maMG1
8HdbxqwemAOHzZrIucwLVbQw562FXN7P5f4KDKcR8pC/UDw71czelRy2hrhiZS8cn05I5sCOmiyn
OhZKmMdQZlLFgb6j1sIA/smKd/+FcbC3aoFcqlkQt3OxGeLtBKToKMPyfbfX+HNOrVrQ6cy7e9SS
MM8v3Qewg3qlvwVaYMMEz7CHn8n18bg1C1UsdHXSiEC/xwbKKB09fq06zksRnNXs0qzzxFixds57
zbfXZ7GqmvEIqjUqiQSOFSnSU4R6WCnVautbv+irJU/8CDPyXDCjXbLTKL1kY3BKTkpEtyLFtno3
t0Hd+jzVMbAuPLav9amajvySvrjW40/6d0QKaSIk81LQwjQ4cSQLCAJ8x3UWPCMLp8iAPb/PUK84
RCqPXvOLD/3ADGvP13M1UO4tWkLtZTKy4sj1iOCzTCMhbqZHaaCxucqLVAfBhp5sPyiErt3LbTXw
79wpSTB3UYzzYFGcRyap0pn0JI+v49tVp1vPnD/HS3iNHHVPzju8l2MvyJ4sW6dA2FgI986/CjMF
Dumh4tkDgnIGBYb5QCVMSMTyjO1vZZcnJs9RuUQOZVYm50676Z619eUZbQhCC86L+5PRpnJaC4+I
hYw3mbwNqzGH/bzfc8QP7OzZecemi1v6CtPra/a/P5APUyg+wlRI5ltNeJ4sVoIUzjk3VTcGBMbL
dnxj5EFjK43IzHq/WdogFAqcD0CT9NSK8fC/JYkCc1tbg3ndW/b1fiS9dv54p2dJ0YFo3bHNfX86
3l8+ti5w3ymC4KdopsnnwYE/ranvg7JSH9VtKVqUrStF5wtFYmEWkgFu32y6QMr9MW8sjNEyey9d
4zS1Kh40a9hVDx8MZrjTTgF4ENE3behSiAiawqn1XeJ/Sfacb7Eb5NOvMI9vZ/AkKfDX7iSEZ1RH
UZjdFwdAnOzgOXPOEx9Gyk7/KSvMCGMmtfUhI9OQznJKRB/e4P790yBZYYLnW6fXaB2/EEhVnCw+
DEsOlVykIS3gTB1TRzwQqBW99CIJK2BHpxe05UME0tTG1JWp51GD3AumTxBD6r3/HE8GJSGisYh0
HThBLY6x59auIT0XUPVVaqH76JoUWM1JiXnrJ5QIkQyyubTrhAgu7QLIVPC5qtP9qJSERuq4ZVC3
HvhkiHt4Ziv0i0Mvm2RXsDyoslhzUBPVsgytdfUrqCnONr8oL+L/P44QkHmvyNat7G/d2bW+WmlJ
JAGR9U58Mjv2BdrnRcX+UNK6IgKcVD+39O0gRplgRtDtAHqgaFjH39sajrgDzLY472IQwwhBPrQf
f7+2G8U+1hUQEPADfWDq8cZ/EdXr2xdozBKOMAa1A39zfjMVF7wltyZpoPbVKOFNAwcDam5AmHjT
SxYBqXiqOPqNUStpMnJrheRjUVyFg7GDh/IcrWCFHvhZ3HjNP2enjTeng3Ub5V9aV/TAz7yrtJ15
tSy6GvhMFWVDerFP3Hyss4RYmbYHOANf8jyMhW1qcuobmqQ8x9G+jzp/9na8+zOZkc1JQDARuXKq
kbdkooOfEa3bnYWyn93xxOgu5xikiNl3Rk5TScGJmyAHmOi6QWvU1/D9SopG5wawXJEly68G1+Yk
bbvXcr2hhPUPT2vfuLfXfBnIdAlyouJcHKF7Kv470GuW+3PAwpNJ8i6q46nMt9QiOpKHA+JQVgwz
09OURYLHUBQPCWLpaU4cVPYsZYQxQGxJL6p+WLkO1kP/ATnwSBUZhU37KnVsktobqu/XUy0jbqVP
ar6wF0bKQRty1+PFiejJSnZZ7/8Y2t/HLHf5aDH8LTkgOoAfr7Oiuhi+41rXUsTHK396X17IY0di
RrICF7VZNN7+6ycATf/wYFgi6uZbeeTfvCGMrdRqvV91fQ5vSOQm8Z+O/RPuPTD4cze3M7Nfqdby
xtVenxgEVwvUZRQ0Qd7NDHuYsjwv/VMCuTJxEB8DllfIB0kRfcMbNEbIDgOHtcTCJI5mfOL/P/P+
EihP551aWerFpi4OMaG3tJ3rcMQ09dUdgqAKJDpfxv0zu4r89z7woBkcPj8SPW3+eCaPAMHJ6Uhr
EBu1s/hqsmbzGAFD16nnTR6vVWnTFQEpKm5gtHY1jWcE1LN5aVKqtZoPNsIevnoGr9UMHTOOdw65
tjOXmww0JS75dHIcviMveEQVm+u0OzPRR7ScllBZ+SEVGwLuohjmjdGuzVKe/KK465Z/QoAYxA4p
nfzh6KSrc+B3Tt0pQfRz3yBmIc+n59mSRyRnzOBowzdfxu6NbIwR56uRjhBlTp6IbGEfLLDbMuod
Vs6vNOwhN5XXSrS+2MTTIcOx9sMr86UDPV/PwAku9XtGZiPg50kiTPAsHibXJlYcnKplhZrrtGBx
XRaB5Q/VTTKiZbfGju+C78cmAtYat746kOgnXkmUAomuydprg/zX6lnh1/+gBFBHzx6G3dTbNAlO
lYiQxvEmZkbjAcQe3ZVQeqf+ScP+j6U2acC8FOd2W+Ps8f4UaKllKIg4KAphs1e8fau9YV6FoLop
/KjNkpg3hOobXfpJd6xQi/ljabqtzgoTDtfk4Zw3Xyb9hPcywzOs1AgHCvS+9TUtW3Clnfpnfi54
DhOftW585EThbeP/uY2kNoy0IQX9NgQ3tQ7Ie2QPD5Blj0XDoDwRuqElTgHi/P8s16zZ7W9tyOF4
PTNmz9USheDJ0JZgEuun9c7wt3uPwG3M4QLejPIngZQaZzleiBRcjoUTx4emYMAyscpMyBjfr6gE
3SAE0aw3mcIfKS2Cy0Nf+4Fsb6S5uXfmzQLNmrfbGkqCGolq4PKd5HSMkOqfb/C/ahR2Opi/QeTt
IEa4Ve24wovk9Logfr3HM1lez0AqlYsRjaVCbuvbhJiPlVP1zhMOyXOkoh5YIJ4afMB/pUzFnshb
1VJ7TXZdnY3ujcQtuY2OJ5W6oYh6sHLGg91jx2JRQlJVo+pggtKXt3T8Ouea1VDAM+icNzBLF71M
BplAKy/S+DVBCbmdQs7TOo1ieAcS+akXlXYkVlJKlRmrgfvF/CUVNcZMyULVX1VTDxN97Nomcf4f
1cFRVI3KZ/x9T3Qehk1Bwpw8vGrWSG9ViGwasmq7ZssYtfrH8RnfiWmzDZQ3oHCWrme1coyBsTtF
9I8oVXb1UCIqPTD1AycKyrk78BHs2acXc/0bXJk3lqmgsUSclW9qPepRay+572JWdWqU6VmOnhZw
SREbA8EJqhdCrX5wyspY7Tfj2x5anu7hK1H4FkxhhySQV2aipe19dxE522w3y0q8H0ThE5RuwOqW
FzuoZC6IL9kxWIGOxxLJjnJOLFCdiQpccIqECax3sdj9EN1dz5fmcpT3+FeHt5TMH8svpD7Tkxlr
FyHZIGMLEDVrkNuZw5fWKnzm/0Bx8D39Gy3/e4AsrV5HjVoJCo2l46+HU31RQPAglkh6YKBBNfOC
Gt3L0KuPtyK6/RJeTlMum7RpH7DfJ9kw0SMiA/n11evpx2KEYSQqRY3YUPUbKhr4m/gVdErCax87
stLJ2dKT4UZidvoMl67Ksg1ngBRraMVxdiPsULWdqWEDYRJekrjRGTPOwkxYTcEuLDffvf1/84lG
CJmSW4rMzuLvO2cFdMCoVg318C8DXV71qQzHRJAbWCMDUJGWrmT/pJGiY0oO9jv8GF64SeN8XXB/
BjlhCCHBc4XJwqjDXg6bFN1DK/PI8jyg+/f1KQL6GNDWKLXc66vsABsPAa9nGH87RPufq4+gX64r
arMz4Uj5OXo7ECGh04LTuagpWI0r9tQRGDRzjRWuu7dFfKfXiRD+6BftKISJEW2w6iRg8BMhE+6h
nYm3UIs3E+CWMbi3pgBGzgw0PhhEB9ULltgk8OuabIsw0iCQ6kETDKBkO+sJVJsMj0U7RdEfmWP7
Q8OfWuRfS73nUl8X+HecPbeT9dB3Jpb3Dl0DOoGEVw+LerF+T+Zgz88Nw5nDjUMQTTFMUrO/+Eoe
QUq1/upmVupVuwD6nTcoAWqdIxyF5F0+4o1XinsxBPFWZEAueWbOs6bwr0j8/ZARDPoS0FRLF8Nk
Lw2nU7malT+4k5r9aB6RcJD1VYdpNclHsWstA7inW+Vx6AUwlDVJ9WCRbNwawHP0YShPBGHn03uH
43/chU1HwF/Sbd4cmKTbJWPsvk049e1JtWb9Mhp1+1c3iaocxwrhg7gJOVAUW3iIL4gGYJtXA+Ql
6t5MZbdKX9r9OLoE4Fv+Lm9mhnv6Aqmj4ug5BJJxgcJOm7IdleaXTASFHWx7KV2tHEAWssG8xLqQ
Duif4kn2mL6AjvgBih2gmzLtRXZoXpXYFfUSsJH9THa17AWz337W/4UoUGgO/7ZZl0OfFZJ2sn53
92u3TtZe0kvNZNCdPA73zlTOP2IupKQLPHCzg5aszNgdG2dQBBcCa+U+PAWAlrHjfrA3TSfSPUyc
m9QzoIz4x2oz4dsvNOQ9LdrTBlTQuS0ZqSTR5GX9PW6be9uofB4UgfzE0ODYR4HF9bNmcIjuo1ZU
FN21nmxs4eCQkCvsU16FbNDrljvwgryqd4pjjXS9f/IGMCz261SGsDCXJE2lakU34UT/X86QLr/d
y/1gdYVBGRUyY0I3Ue6SlK0E95ALM+2DxpU5g94cbBXFzU/JhjZ+qV8frLsSpNmpZIGuAvF3T7YC
MATYA/gHpIElf114XDPvctddTJWPzr5CaNXRC53qjY64Zs48PhvyOyeCUTOtVZu7HhQw1/3jim78
Chr12I2M9yr0o4hlZeX83RNiLP8VZnlKNra6aAbHaNzX+NFLcyD6/gDjtFBUDPZFrkqeIDf7PIlQ
4nZCiZtnU5FXh7b6i9pGElvBnbhFp43SXH5TgBXcfqIbVAeK0TVclXBDnSXcGnWg3cWmk9jC/Tqz
bcScGf+6DXAaW1D3F22G5oVE8AFuZR5hAZrS7iuex/2i+4f/BlWyI9Xdcm1ya5nbrwUyoGF6Gge9
dkeHrXrUiLTfHGGymexEBQRVIODn6Oh57ptRDHjFziWXahfSrQDEvzeZlsPbs7MiR/AGtWexpMRA
TVjbiqZQMS/hpTVRxWTLTuLJW/v/o67tWqeUsUwSGamd/7TfjSSA2tsviUaTPT1jsbUpsbitmpNq
tBCAIyN5JOLRSph/LXLkE/Auja4TLLeHs7nOsQPskVArDG06/sw6tZRg+ESbTEQCs/dP4oJMKOiR
n0PUuVz1XILWNmYdkh16e3QsQMn9zHuUXxnykq5ajDkftJbxZaKgTx7JDVrbMaCoA8GsR0gj/8Sa
YdMefHryGZU9QgXjFS6qb3YXzcj4AIuzkeIS5gPZMcOiH/ukFzT0wIeIwIrvngjEixVwReEn91tZ
9Cx2moOSgjD5ChCpc0W3WGaj+1pk6t03TFndea+nSu9UEy0kagAr8FqcaCkPlHwGi+l+mfxsWY4g
cs0cBVpxWrUU1X+occvu4A6+Dl5xRQrgXk2cWBUANnMp2zVe9bCc2N6/papaSS0A2dI2oBx9+MHA
BvPPfA8JWaP3CORXG7xdI5KK/Gqg5NISaQUz2zuVCF+v1jh/IbMIewZBs8eATrtHGULZ74X1DyVg
NfSOCLTr4fhTYQHgG8ZrdrnXOvQpxR7uFz7pszZwo0RpEbN83+JxVEywvpTiw7WAO1OpltqWMEsp
6t69JZjCZhQULmWsjjdgY+eQr1H5gG1F/ronhIAMj8j6qhRdRwgIb7dD5JzMRPRzPf4q8gAisO2a
9TulJYfh4J1FJmcXyMMkX2gz5ZOzKvNTMFcbQbHbb1euXDABLr6pNjZQ3FwvhdlGw7pPqROunyb3
mEvIzsFp2Gwuv9iv3avBhRagZaw1Y2aZuPQFkj+/jqJZWSNfui8e2lbsYyWXlIurtjbHswH45SS1
izaDGznXRzieEmlOaL4dpfo870jTQ5mTSFsHRgSci1/Que1QNm8LETfMfJZSimTvxTixKH2TLkWx
f/nOZeJR4N1lPD29uupTyCYQpqysWsLnqCM4MEyLDXyPM1TZ1sUI4wGDTN6j2pK4bOOEH4DY4ZRX
WnrAfl+0Vtu9Sx+cq6rv88aklv+RdjcvxDu5Cw9USdT8y9vgeO+CxlcBfFWheCboVFwc+FkSuCsD
NsC5LjtxBRqkMtKsKytU7mM9ia9Ctuy55GIyaUDMOV5I96m2CoajTGelWlslnVBMIHK3m8yBM/Y9
vHuu+5T7xUTuM2a/OKlGGWn4ojJjZRPigegddffPEsO4IBhuiGzDB0KfcDmMaCWfl5jnfF+mkxDO
Cp7DQoyt6UW1CRFju9qIXh8MkU6KzrG88Ypowy0VXA3oFHl7d6VSOrqdEqrRO3fR5wsXiTX5F0j4
QkDmgkfD8LGV8O71Hxw6vXrLXko74vjF8E1a+qYkSq/xI2hrQAYyXHvJsOlVHUxejR+0pwu5kTux
TjUfplxmh2/o8Sn3Nz0brHfeyqiIf92oN22x9mH64uZoWfuTuc42aVr/ChLKf6JZ9s4jdaQZSnWN
KLaov14jlM2gZKcMWgA96XkEmatoaLYFigOdHeC56/VGpjvNGLfeQEHC4FyOj34VCwnf4w5MvFx8
7ktuGisZmufoLLQWUSWRldqEZi3q/tNd00mLZCURA0AunSOluU48Q2dQlX8zu7AIxmCo/kPWOBy0
KMrM48+DOsyavg/dZ+b2JI7cck+ejiu2HtRe45p4H4SFg7AExLoSEw6oIBLw61nEG0Tey6UEvKRz
oyCS0raEoq7LbttMC64zTX2r4dgObaNT/X681OcZZ+OaHetrFqkJSPk8HZn03vDuUlqXhXPmzp1m
2+gRyEMm+tzeUVfdzF2D3NWXdUvIAg5I+PP7/W1TBzNQUAXSmtNFsldbAhkAgB+Q+bb0I67c6qhc
d1dprtrW9J7pHQGMBmMApJptWk8OxFbwPsFGw9Sj87MIoEq/G7u1YXqrT5lZrJ547r35lxfNL9W8
scdGIb1djm2Uga6ssEV0Qp6CdoK4FGWDpQ/diOiUUxCi9ZQe8lce+dEDV/+UqMttzX5RraV7V0F9
RiiBywAJngKj3n2DnTF5NngvbyswBzte24VlJA4tKKgD6n3Tidy9grpDwZOiuGLOlrGiSzpVHuR5
LAx3LEZR7dz4oI8nGDMmwLWWwA9wfRaBTJFwt7oLByRs+a7TmkvPyqp5Yk5tVOBsfsOHT1o62Uri
dJKx1uEzLKYaIsK1zivyjxxogkGcv5bd2nCYgPnZwHctnH1SVfTEC+SafsFWb+BRyMO88+5M+VH1
sFA0OOjUqseYuxvi9hpjqhwobwY7IZum2WT50kgXplHx+vSJ576A5XrTimaF713fko4nPyMecYtP
D9mvfcup7rZuFOFjVqWGPlIqcbk0VCPHRj4eaKGlI8dqCTzgM10QONco0v69VgjysqNWjWtvGLu0
dVKlBzrvEbIk+PLW9866Cak7wTy+ANNOKWEe6FM/G9Z6p0zNMMbogetYKEIqLDMoJXbAAeY6wsZv
O0kvcnAd3cs3lrnPL7cdR3QKRU3+1rrbP1XNc2egMzfztym4hy+4hGwRp0zMIFVXjOd/Nm75Xf8n
lRIwNRRWElLZxI1ThbFwCsWlGXIKkoKVXb4mkSmNDGaQYNPxRr851vTB1rR0AJArh2c+iWc2Kfex
Ahay3Ra4dXKWjieFmQ/Xi91fnvH6zQEjEa+mEgg7PZn7ELhedW1Ts2PhSvJ+/VAnlzQJ/ukjfRJ/
mFfs+I9SQRjiNnf0cuarfKuKzrxRdiQ3QHQpMEncuhoJyQM8dYNxplOjnmoqekgCHgq6PKXAqYwo
RTBSgSauBqokMeIhEiXGFQkcaCevFHc6ZtnkvwKrJXGM7V8bUWFoblbGNbDlJaFoZjfgF9GPjcdQ
nNyqjtcONNZGL4cLUWLrH4DZUqkk5JLKMPPBCCdf5Fu+mGzibAlmhi0oKHvxu974UK1Yb+lL7UeX
NJOGj5oQOsV11v+XMXGFDP1PrcddYIAdk8n/BKSGURI6N+tDv5CaY0rLuOUyb3DhVkf9xm7V6EEN
lTPo3uAuhLZgnu7pPUi066igkhGoGyITPUEBEYTu702FuzNb6wj93a68kvl/Cvq76DcBIIZ7nMAp
JnkYwLVuXqB5Rd+horgdq5OGy8/BPdAF/L3VO5dk92te8Y1idvNt74gykOGEdvjS2eoHJ7io3Egp
RZEeV5PcSW+vA9/eoFUkr825riG4bu3WakIuxnBOMn9o7XBFaw2l2ggWn1wMkQ4KUzdrZVZq/5Ok
LWZqQohYqfB079aCQqsJstU1XCHtx8Wt4W7OF5/hgSYTeWeH8Wt8tJfB1GlPGf+Mh05nYCd4hRdf
VFp9m09mWa8xAdCfC+R8jmw4NVtnQ+N/yOemTufR6/DQlHcwfDRuXjeNz75Uo8Fx8zOJD1HsAroW
Xcohp62iREyRxWB0yjzpOu3I20nB1oubLiL4lljuv6orYrUF014J6KDD1QiQu/DdOULbSjWb5u4N
o/W/b9lPvVtzcwwQfDyKqEGWlnB7fuHedrOeBOI8VGXg8acW7i0mApTwexrAiFDm6DB7g7kgPdOT
oLuaZhSwmlrslgSjf8KI1QZ/Fd2fInaPQyBebesFAZfaInEZ7NudhcRczbfii78k57QGNOyUEgT8
4d71D/eiQ4iZ329QsXNYQUwT076oiDImnLPyGr0z1ybtpYCcPtJfmvsLE4iPV+h0ZHKxjEqIltdG
myKXfXqD/2CQQrrIW/TZAR6bXOUgA1btpeWS9O9D+WbGiQSmMrJTgOTOP7YOWFwhGv8ygjwo4BWM
1hdM5A==
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
