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
cQ==
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
