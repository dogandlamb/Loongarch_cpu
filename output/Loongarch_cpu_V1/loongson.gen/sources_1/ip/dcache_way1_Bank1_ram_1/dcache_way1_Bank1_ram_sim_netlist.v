// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top dcache_way1_Bank1_ram -prefix
//               dcache_way1_Bank1_ram_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module dcache_way1_Bank1_ram
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
  dcache_way1_Bank1_ram_blk_mem_gen_v8_4_7 U0
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
KA==
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
