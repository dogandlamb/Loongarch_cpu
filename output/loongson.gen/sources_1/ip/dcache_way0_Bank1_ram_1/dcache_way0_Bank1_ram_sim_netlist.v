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
VA==
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
