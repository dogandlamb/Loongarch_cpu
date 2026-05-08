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
bQ==
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
