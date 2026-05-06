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
ug==
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
