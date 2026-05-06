// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:18 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               e:/Loongarch_cpu/output/loongson.gen/sources_1/ip/dcache_way0_Bank2_ram_1/dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module dcache_way0_Bank2_ram
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
  dcache_way0_Bank2_ram_blk_mem_gen_v8_4_7 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19840)
`pragma protect data_block
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
maHD5A==
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
