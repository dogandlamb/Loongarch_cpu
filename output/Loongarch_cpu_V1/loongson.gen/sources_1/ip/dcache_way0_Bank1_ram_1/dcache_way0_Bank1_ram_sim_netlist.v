// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top dcache_way0_Bank1_ram -prefix
//               dcache_way0_Bank1_ram_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module dcache_way0_Bank1_ram
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
  dcache_way0_Bank1_ram_blk_mem_gen_v8_4_7 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19552)
`pragma protect data_block
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
kA==
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
