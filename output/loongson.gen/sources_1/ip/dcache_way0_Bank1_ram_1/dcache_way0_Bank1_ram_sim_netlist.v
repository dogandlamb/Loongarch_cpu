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
Ng==
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
