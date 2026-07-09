// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
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
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [7:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;

  wire [7:0]addra;
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
  wire [7:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "8" *) 
  (* C_ADDRB_WIDTH = "8" *) 
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
  (* C_INIT_FILE = "dcache_way0_Bank2_ram.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "256" *) 
  (* C_READ_DEPTH_B = "256" *) 
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
  (* C_WRITE_DEPTH_A = "256" *) 
  (* C_WRITE_DEPTH_B = "256" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_7 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
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
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[7:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[7:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19776)
`pragma protect data_block
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
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
