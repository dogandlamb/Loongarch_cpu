// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top dcache_way1_Bank3_ram -prefix
//               dcache_way1_Bank3_ram_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module dcache_way1_Bank3_ram
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
  dcache_way1_Bank3_ram_blk_mem_gen_v8_4_7 U0
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
JA==
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
