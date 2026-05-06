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
jAWW//oxTi72PC2rbbbMsY7LPfuZ02ekqmRsP0AQv3LCltZVsZa+Cr8pBqeYHBHVLdAJKZ3F6XWW
UzR6qCWCxkOzy5hvv7p0vlAbwAl101Hbx3FWFVDv7DrZm60CYKiksOKb/Y1XQ8SJkrmFfCIXRedc
U8qTbHjYLrpqBkMtPcf067LhK6GKKILAXibqg/bOrgqJ9aLPnGzs9tE20R2vdfeq8C3y1sfEe+mz
07uoBSTYqHJ4nWhHQeEBz3UYt25ogawEhTu8rXm2vgvMqp3YnGAmI4r9wmwPxN1TAT0wKTwEgtDu
PDBSWPfIkzw7Ig721lkyfCTupu9EUmBiDWaukkhbYkK9cKRPD4UfLTVJZrsTaWbCnQ4Gyn3DKjEE
oLwHyv1sxZtoNLHOjFCYH2VX1Nb//JB4Fe0KLimXgcHiGvgFX6O6gxdmR3QL4+hzJ6yyaiyUpVlU
oxmTF79goXLij82cC0uw3x5pU5wFY0WlTSbaLAMeuHwwdnOCGaAW/iHN0OcRxOKmw63WozNsWvDo
gzctpstpP2kjqoSO3S0Un2Qz34z/YaN9oVEYeGHRf+fjI7yCBdv16yX96lJTU5Cj+DKQY3fuN6tm
kaKaVdpUKVlR4m2k7Gu6n32tBrXQDyjAKXXL1eFQPuI2aPzQTzCdYhiJQCm1t7Mnzjk+AwQ7l7lm
RwQt/XUbWX2I9RM/33/4cuL2iUw+uVtRjFZJXxl5xFSACvbpneuF6YFv3ckN3LBNMt3Mq54SzFGw
105+QJfqF0jTzQb5UaXU3no4Nt8GERHDWLjHTgfoXbwaXnl4lgDadlXYh+eCPI+2Pqy6d/ER7GoE
lpUBKSoVD+lwXrcwazdB+bftnPZ/vvgTK/BHHi5Fptgs2oewYTcAUGUEwtB9+F0j7WC0m38FXt0+
r6JLzWUkbVP8wIuXiCMP1Cx37pZl1jpyGUTDuorav8KhY9M5Jzs5MlBQYK3yl7mwmhvjsLVtEiO6
juRRWbi5cOo4ol+ww45UJvgL8JtsjDebkm5t8rnN+bk6Pkl5qQ3kExPu/A0PeLUU+QABbFcXJrbP
qWLtsP2+h1fJyyHLnWj5MW6E35p6pqxInZbfsXSL5gBo3+KRjtiVpuQAMIZlvkV0VBm0WPc5QxLU
lnpu0VdqoyN6bzK/hhfAats69EE+RChxHI+/YSUbUiHS0vJ+H6og2ABykoSuTcxPopnCwNKy8l/E
NjgbJxWCwiIDogtVGFqcimjoMGGeVtTEDGQzSIOH/hz5KUACWWVU4ZDVvhhVabvmE+F48MlE7cR3
3eBv2Z4oeuDpcTsMr/PGECs6LnsdmepVgevh3GKHBYw3bGjyIy41SfAa7C6knoX10IlD/1WuPV5C
0hVWnG3vpXEwLDZkc51k2iQa0qf/Vm60ZcQlB+7WeBJq0KE9cLfwRHWrS31p9nv/HrG/fdcSpheZ
hKKjs9SJtmoVX1j4KyOW3zQ9A+g9Vs55Ut5ksiV+lPTr/C1yhAHjl9sgQnVSeM3b0aUmOVTiixvf
MosrNODnHugczFcPg0psvESxgs5eLlfvp2mVamLP3oL9mI2jXRzIASzMP9RL0LOrOIYlmBaB61Qr
z1vk3zSdk6zQJJIQyC0nePXuynIX91qQGAsLa/1TyDsCyPHf6nBDXoRamUHCqfdBUuLFIKPDXbk4
j84mnBzWs2DfClyAqA+pxvUNpPCBwsvXzRHcpWoDjR/lmOwoplkkUw29modeBAkP198iO0TVTJ65
omRstLMvctNSqu1l0i4ITI7KKrIonOIp+NfxJEYnHlobcVe9cd4CtITSpwdwxcOuU0pQG5+bem6n
eLG9jorneHXfE+l/8DlI0msHeSHe0BcioK7KX80va8WJFe/ToI8xTK8Db87wi0tPcQRL8t/8gqBB
1Z/apQCsz5zpByPLtKvAdyXFb4skX/kAGI3TC705QvxaqhS5F/UJFkEsspswEX1xuY9XW+MW7q6c
CJLo4IrXDFZlTK4vYgtyioYAb+Q6MYl7AGHIRO15i4zpfdIlKZ9CJY4IRQiA77ca3Idn704kJn7K
TWKifhK6phSJy+lK7G6GKryQ7zOhPtxSNX8/C2OU7ADb6tfsf5dhFpK1eJcZ5bLxxiU83/oQkyzd
YIwDLNtG46q+zvpo8MM7hunz2XWpi4Gs+lxtke8JwBxJwJB4SC0opRcObMzjLsWeG3aWc9vGtsx1
ekBmhM7It8PyeDpg7x4R03YsApxdnjQjKEFeI+NZO5c/cJ8NtvGeC1lo9ygMbFeZM5vOGrBpC/uI
TA2UFnqXVDGqGRHdDOEe9g6nLKcjr/QejrWOdbHTsPEUZXWh2qUKl+9J7UgUO9sKNs4hMq9gRTC/
vibu1adPFnIHGVmV8IMZeENGo3gTeErfsen6cltdhfmt024VJtHiDp0N8eTalaRrxSnZn8z5JA3y
eMBWyN7dPiIi74lUbYNxFxJMfNwUtCo0RItlWtgsVFJmRhyW75WuEFN7xIzozs2ylP2CKvbHOEuF
+LfWMq+2T7WBJsmES/eC4WMe0MGBmMcQrPlIALkNtZ4OmdbDDhSRwkg8zrysJQHoeC7YPznPl2Qt
PtLWP/8BIvsZClbs/0xEt7mw57/GXsT0QFOe9QtO5PTm091UjGN8k2BXUJR5V2U/UKsRhHkPseUu
Syt9liXdeBk2TcCINeKSnwtbwHWJn+zBO8BwdRWRHNqMCRTozqfNyEIjp1OViCEXEKS1UWBd188v
o0wHOgIq9pkfcWDUsC5qOIc6KWebxzSufT4rJKXi+TKsutswTxGv0dH6I6zhY05Qv6mYM7U0pQAU
HFqnzCqZnRkpyC1Aixn6e7r2l+r2UbaRu7f9Mjt1krOP3KtMZNp7Yg8Fer4MyySMQvwsxP8fzW+z
B0wYOZ85ljgmIx1HKEb3gm/esLHct1/9D8ouUVraEMfnz6pAgf5vqHsihki2aUC6z1eAVOh/yBOZ
U3HjICnh+5+GJwfBP0jcNzE/kYhLXAc+Foa/XncU8c10FxEAgL5y+y/kfXtuRLcpbQYBX8uHMkJp
NI2URRK3RCRdMht4/7HcCrZ17ilm5gHrhfZzTo7dicaXuwCtgztY3ZBSOelkNTXbgLHmop3AX+JK
aDSvgcFuFlVvv4KRgMO8ksuFZiYMiSlxSF/a/kvKIjqCJwW0hko8S6ogM2yje4OdFE59EYZz+yE1
f0mI+jWDIA3FfY9qInWj+lHI9zQdbV5L1uEWT2YgpbB4w69v2hnYGNaOzCvawwOkBN3IXPgHewJr
hItkhJr6OjuvCfFDUEfVLCsjNbq+sc8pyfjBpcqnOHB6EDo/lK+Hr40w+rBLgB6wZ9Agock2daP4
GiSCeLi5PGMpCaHK2EkLHuemQfQGkuNbF9bb8iNP9KRTaSVATNQ9F7/xNRQ2oCwgYKFo6sgWMxki
cFsHd+BkYB1IN1I1hKaJyau55M31NEOFDmfL4+ZBrIOaeRtJBxdDYHMaOvETYJ4x3GYkHujkNcB5
YNN/OXJ06P0DdG7TsiKeG6JkUy+cqeM3eLg+eaRqDjq4A70GWJpDCjJhQG8JV8Yl/6ERpJzDUI0Q
GhiAUSAgNu0utNIsoYWox8Ca4kMSUVk5rBTsZL/THobb73HPYhc4Wxbvebmb6w3q44I31egZnANL
0swdbC2QQdy5JIx6pF81e82/zVMo661P/Q9g2jxLZDyKXhy3DLlUmxCpMSblT6VFLwnDKaOCVd2t
NNbB1GsFULkkwq72BCZ7fODknKZOH2l66chK0L4P1oCnau0NMn8vO80/91FXj+LlsR8PtLPLD9gw
uTnHHvIMfP0tJur3HnKmTYGskJqcab+0pMq8JAAGvxRL/s3fNxuSDs8Ay7ksfX9Wx1v3Tbq5POOk
UcYaEazUe+RlrOsUSx03Kqbb8uJCHd1UkrRBscgiqOKX229gb+FjsOMnROKBmyQj/6rD2zV2ItX2
ZO1rNQq+VzHpL3ODBw9VJfCK3IkW+SU2jEQT/rbnMsxC7b/8zBpg5UAtaztwh/cANgW09S2a2RAs
obPz7CXqKLXDS873cd2QudYz4Jk/mK49K5PQrzVo1v8eTqaVw9J+CdPqajeFT9qszi3qpemsKn+f
zRw6LTOnf/VZ4uM+1D+3NzYUEzgXKngE8G7sOFX+bkvIcJ1yjaiJlttxgTaWk4rt7X3xAS3J6Jg6
fvndkKUUKCV9+I5cVdfTIJSDzan8qEzc1JB8pybrUAKLnMJ2x/2mXX1T6435WFox/BdlYV4F3Aq+
MZGqon1RMBdgtTMcIJl+7fezpXVZhPIT0h2k0b0s4uvYZv4KkTx0vdF7u+O/ENSrGPtB3St2c8kN
+cBEqY0o7Eq+ZUQWudxdbOBUs0WeqN2dCXK790eeseq8HWDRnOy/yTbmAsFmOQSoq5QEbS3eaXeP
L9pThlOKaf+DYsXr/1AKkt3PTakCMImmx7Q+kTRtmzxpE9Hw0MwrCuJ6MCalQ6HEuvurJoOdR/7F
kE/Pp2/H6kQ7T4jkGPm2Xb57RE94Geet4OwFXXZX74I3x55SGJQqt5EsdJoP98q87/2DGbFWOMxy
2zx/GFuAFdIdIh3Upx/gwY3yf48J0QtZVBeeqkm7tZJiT97LgyWXKIb9KyPLhXGazTILuRFHSP/b
J+T2min6tM2LnsAyCW2LRFwSnbMROTjL23cdZ0eFOybohlUYJFopFoCn9gG0vDGAst5S4bYaADev
D6fw1k6xm9CnVysmBZD98W7aN4XGW6yQ80jlCgYfY7IaekocJrGM7zrjRXqDK0IqG5CYf9VntT74
5rTTqaKi5Zvk0lVmn9/tNMuPlofFKsxvs+SRztAqKhmwfGN0KzhnOBHCzvZJqrXwLQJ2a2AU+t9S
V1YxczcJAnjt6XtRaKcPecyvB9Srqm84JNo8xqyM4AkqQmJAlgVnQgq6RfJU623fH/lrA5ZajIpw
rHSlHEYXf/Qkj5PmGVXXhS+c3ecNFkmazWZjFOQFdAAIvQ0Ot8Q6sMlLIdVPu6h5WAcoElrnjwZH
r2KaSFLr2X8sZTauns8DQnkJJLoeRKC8dbp/np1TOdnIfyrLK+XILrBxLgtte7jHaZkfbaX1Afuv
K2JyNMIUcvVLaJUBMNUSjySMV6XvjiFZ+bsmGklX1S2mJOc7Amou4IEdqCOLaL5KX8CbfgHHABFa
9WmtCt013w1JPOHdvaxbSVUKDAg/SuQwMgHnSuvL7gxZRIoVmwZ+QNdYXbd5IQzjB++eVM12gjHA
k0KQReIEOrqRmXetu4v19kN5BE4JngoSiBLzIi4+KGTk0AsvF0xRMRewzwe6OKw8K8FnzfS+1PI0
Sh8wrcQyp7vWnU98TJjrngoaBL+ETZk2qggb5xVrqKPITDHYcnghOdJ1mGtei531ShGR8Yv/cR4R
3HJHF4vPrlXdFm92Lph78WEe14Xa9QRwEovjSQnVAGh+Bf4EEsypFKBDHE5wpCnDvcD6Ypbs1bt+
o6/R63QnQNe5ezqvEK81nwkqBfPuRAdmV+4AZAo3gyrtXHVnBUcZQexDsHLGaGCpnP1Lsr7XvLp0
eJMh3AtGq/6+GSBeKXBo0lYI/hzY4be36AowAmLk/LIMeQC1CmYptRnnInD79BS3KTjSG5NUYAXe
USXgXnZPJedPW/apqYo1gaZemn/Y3E3/CNNiUqZaiUpaS+z16sEJzEgQI9EPQrqgaQDNYNI56pDS
yrVrVlxJ471de3xVf4Y9gbbW8OotNsQiYnBTN3rkEOADCG0VfuvqOCKm04jVFQyzw/iECUdSQvD/
axtc9eFozQbmmTBYBFAWBKASvu1lbmt/oWJ5gMSfm5gz16xiNDVph7mdHpLkli8l3a2fBTuv19PA
PCddzbd7THGAOpZDl1FwmzhWhEFYgH8Elfi8CSipu99yRj6iYpd4JYAsn9SBOsTN0PnB1W/JByjI
gbcmAlSpH4xxydnL1K21wgNYj0fr+prSi+ktBzpLODkw8KxMgshUBahAwfqDDZ1CGpzE7TPl10tJ
vVCdtHoKsbzU0HSL2fMJN++f6gJ4iOMU8vTenIfEXDoBTiYqV01UONAwLrP0YjW2Z6jEzKdLzblc
GnjuZB6TLVFuHvrjPFbTyYtoBRCexo/XZiMPoPU6C7koYg7Cqgh35zjDBgyV/664EVsFF6SKciMq
0WGg0VZ4ocxr7MdWNjj7l2Z43OMkg32+YWO0DZyHqZNHpDmL52WbypDQ5pTHWlTENYlRMc0Ru4Oc
mY7auDeK3wJybOhk1ZRwSXftUOku2vK888f3CkwcIlHyBG8iATeKN9EYxWXmPnuHqnNIZVoCjrUE
Aq1Qto5hez2dIasNUSxryH5XzasMKuNmgrfF/6NKwoHRjjAMvPp1s+5Ee0p35/Arm7ZT0HuSReCU
qQWMs+3YOxTqb0XLGyIwJuMGXbXmOpFoi0fOm4CfLnzgjPYdF3hnVmt1MAteDlv0x9RYrNDUQQab
NpESDGg66id+xxUsZvP2yi3Y1SkePq4a5CMbiAg7mwtp0ZXxwKGA20ybALLv+vfqGOEeUNfDXF92
y7YVgKiV7AaGgUJ+u49W/uGE3mLMcsgi5pYxvTpPKGLH5EtcWnbgExjbVHHLySKSPMUuNFk+zDiB
C/qM1iTmr0apDNBXGj9mIlLxr7+3HVowTnhFh2TD3rDgoCaTc/2lpWEEr93C3sMSmaVXqohkwvTb
hmX5UQUE8003hHsfcQIvQKnzwNSyRGgkacXf/DpFts9MpqjYhiRGvdmcllPpVxx+viWKhr3Ggdi3
70SNYUN2iLtqmka04UUE07OnpncZ4gu6fMGWMIo+Qe4NCRH7ojM7jm9IJ4LBUvek6iYHQquS9NF7
uZRmh0MIbl8AMuB3MMdmaZbZI7IenXLpFTsVWPJ1vPTYwClqKjyykUSbsIP6vnRFUHeiwtRliKMC
VVlUS7N5+JVEcA5UE9ZLOHyw3AIr/EL/wTklRLa5fjvUUgryfUW6URCTLBpfF3o8X4gr+RNbd0z8
wPC9XMthBuHMwtIN3S3OW8sqOiAFyZgDdBU6VFpH3VQcMdwM6RSNN16dxCkvZC0rkT52qmpIcUMt
0ubh1vJSynCmjvnxdiSIWzztI46ftTDdr+dbywaU/kSEvdYruC6v0LiryXymikmwcq/QWXzgIhGf
82wwtb3gdMXaGAlW8j85vc7yoH/F9x5gvCa5K1mVOagInS3AK0NatGIzqsV3a/JLOzI5shrMUy4P
FjW2Q+SPamMOtCDnCRYEoJvs8z2U8DNmKPPjiCpxt45hq+P/qW2jkpww80qrtoRh2U3KZf9cnm6D
aD/XiESSF606wm+qiM4Ev8nQRxEabIvlCL434gCiazUgnGk2klORrlytBS+ngOtUwvXaKnkcbxY8
euAnRh+5v3AYhBbXFS9z1pW7FktVFMQdqR9qX5m0X+UaNY3dmkgzVhk81HC/AgitaBSrvdyObggE
/4T92NYLCC09IuC5fXJAJmGvOOE4gZkOtCbG/Po3LH0mNBwpcdCwtBhsXBbxJk9Zun2FpncbX6uK
e1pAN+zDQOXUshBuWUD9GJl4fcA38xZ2aBpi1W18jK16svYykwPt3BT6Dv3fBo6p9FJIRtmuv9rl
8i1jZKE07fXWatQDKklmQAowfRd1XYOMbmB8PLmUgbs0d4vOXYE3O7QiqLBDOYFk5Jp2dfx6jbsd
rNj92mFJVqJQ+dt8nfJBYgNZ2wT+CnzMp5WqLNJqwrvusnRT5T1l6odU32/LeaLzkjsJ8pQDqYlC
3n7YAGebWXkYdyupsoSV1HFi+3gtW83QlQ/ve33az3WuyvguU+9zqe8aunxLVbOQZa+oTK2juqHy
Mxh9H6TzLsOq/B4eARBlzdtKx6SWLCNJllI+Cifx4IDz50PXwVfuSIIViNoAzQFFaEAwqn3fPERF
wLlitONCq9zha1t/QbEiAuI/p1Z54/tSzP8xMtecFdeguIgyxNyHuXT1yNRF813C9TTS6qXBWis3
PiyCk1i6OFV0VeBkx0kz5p2KTn9hcPirrkK59fDH0o8BZPFTkMPvpSUGoCjhoYKFwDZ88exU2lwf
dbTRkfRfQHIDPgmqzVanWXMH9f69nNeN8A8WeIWRzn4YUltmCz+ve2GXkj3Zz3wVrGxLEj0q5VwY
rJNlGNYLA/JJ4jJ11g0qCRB5q90uaaaLDBuzHtU8iEsC9ZxeK7cR9nV9nlktoWzCZgBn8tKo86dM
+sD+kw4yuX36daRFeXQN/HXhEfCkEKs+nQCzOxOoZPsgz7Ilp+gRlaliRYl/sixYl6SuKPLOE2Gr
gkp4lJ2aJL6qI8w7X+KPBzYixn+qqlBgCxavhMR9Fpf5bh0jHFw2uImWfFLPrsZWAXGhvf70U7lc
Q8dHPBXElEm6p2AqItXINhCn3sDGJznea+jRdL7skN9yim1kCFjHhVKYJCLdZ4i5aYqz3ka2zZ1S
JIzu7JaRxQxVf0RrqrrNhAte6b/NQU+S0uiIWh7gsgbeoi7YAOaHd9QG6q+YpZjtgMtHcfJOnjN0
6oVFXCuye9bw0Czt/hrT7cJE1I2TkXvAfRkMu8bOv3asawNSqovYo2IpWYaBUTqkk67pikMeGLMo
Sg8967bD4MO0ZeEfMPM4UyInLHSQb2xu6lOe1/hm1yeqfeP4wxVabY0ICAiSEW1mbwebV98b3DF0
gmJdVIilYqwHLeD6Ef20+truIfXH8tfn5Pqtq1qSt2LFNkUWT2WY6W3QpvENzbr5mzYseWZBPENg
S8nkee/11LKHcWrRUEnEVi2KlNzOv1JR6ZNDEl/W6bAnXWPRJY52n7Uc4zs1bTYVR0VUt27EmoMs
n0TNV/N5Y9HRBs7iK1IBrm+kvgwJz3G+CNwxp0dBGp8gkgCsPRTGf2p0Eb0Q8a3t8bbWaXkyo1bW
a+eyraGhHzNw3SQrwk6x/UuBkwHC+isVbVoFYuNNdO2qdO1xv/lRk+a9DHV0VVgng9eFrFFOJoqf
Z4+Cl6xUIBtNEvV09yawhiv6qg37Xsty7ECXx01PCKP/94wuzcF9mlEZiuTZGPvcGaapxtOIPW/W
uE/FIgyT6kCikncbyex+F9o/ncBYt1b9S/LuqtsDqNsPzwqrTVc2Pwl2NS8VLYIo2/OUaDIXPvqR
dvyDB/55fKIbEfUDpyEp7inL+nTq3GmWAnsRkGd1cknm43xs+Z+fJ2op/kUH43qX+SSdFQaq7mP+
GuinLSCH0wFoS+gmC1ixCWZwd2EPWLriueguuvTAJj8P/dqlQ7D+cojD61uptK4eW3u6NrJrJykj
fras/4Sx7T+wb4GHYA9bFV32puYiObax5ZCk4Of53+/NOgvVvwSqTrjJgbQSyaM4yDFqEDOBAs5q
3K/QdNxwNOjFW5uksKNvwXywqpgFRj+d5i66m1QWZPFABkgM68wsBsBNdoU3NWdPm+3pF/uKXNuc
yooEOEDO/ZeyiChkR7zljopiVdSTLxx2XENcndUjqHhS3mqTcCjvkrWBThhqOodCnkNpaQae9ztE
HMaLMw3+NNEo9suC7qttM/YWp4DoYpvBewEyhqXFmqjfmUo/oPgnwFnippZR1yGH2/fbmy4il7hu
lsLuzqURs7O+Hm7xK1t0T9aXjOjxh/PYaCN/o1Imd0UdWdrsJ46RSEjjAA4xy3l6j/dyXwCtVHR0
pZT8SIDwFaoJgHarSizKbpltAi3rucVzmyP+3sqrncMNgc6drfN/nUpG58BxO/VfY6C5kJbUrEhn
PnA+TSWENjTyQ+m5jX/getVaLdp4uCUc2mr1iPEsoES12JJAhZTp+ZW4b+HUFdShAACb9EwF942g
h4wABPTG/SmQYp8uNn/xpk2QaJog+ULQAMucndMaq/excBBiVmdaY6P/IVqjOhygWORcIxK/qeGz
sChC3MfuqvDnwrszJLRwzuUtLX85Ei2xg/LkNidaIH8H3+FS1fv6Ws45TgzSTEi27tF6PJBM5PDe
QEIBn3OHTCijoDLoygATGqIeRRuVrFxRsNqZP5tpsOmk/sPD+ttFUBSQV8KDi6N+/MxuDQKNyBBI
mviXM7xhgKnsddD++eRmXj9FkTSYhgui94oxHDB/Ew7x65BsvJgVwg/oYhSZsAmq+O5+4WF3Gp7D
hqwaRjEanHAPj8ubS5y+9a54qgb8odHpaX0+F7n1HWcJ8FXFhssGSmA2dcctBCjNRvttCgonZgcZ
GIZ8llhpi6ucuYznmz43EUzJaubSvLXbb5u8d39OA30uKxR276HNZgCl+fZAmPoIy2aSZIB6HYaN
wlhlCBusx1rojzc9gRAlHvJAqbZPnj+PPdYggSqZIgSscq4cKEi5abG7QOdFzdg0NyPgwdd+DnLg
chvmB27l7ZN3x9IpsLA3iPKbhIjA4/QCgdWGheCmVcTJvMgnpqLCPvn0KtsSuLCqISOBtY1Gyk5/
8MBeAojmIFekDCFKJqcfyy2leLoPiwAfrqY1onQy6jpwBdmZJJtRv8BwoLXxTRfXouD+08oeD2id
6SXWXX+ftWAtMa7z/lwrDC/kvgvxcl1WUPbsywmAzMa/lM6zsVbnX7nryqgjenZf1/Un58qSt9c5
Kmn/zI7IyJnORuAle62slLzfDt+eCzQlc3tdrXxCxzr3b04hUxk3+Dh9MIz8X4CSKITqlGvPaZim
5iPsiCig9Xvc0lG27EZ//GqH/3mQZDXUfM4KxpjUZjnwKd1STHMs3+JLpzeIgrTxstbV9JdXBEYn
yrv9uIqa3UC9NDZAMjdaQKZesLCtG5UWQjcj3G7UORID/P6L9KSGgYzRBTvp7akQ4RBPIXG71gFK
QEh8Rw2iaSC8ictUyKZWgjbSx+qiGE93gW7D+p3MsUBsMqEZh/xDCIYVBbFkKp9d6T4Si3pf1t32
tbWAhbCW3xEMFkgRa76AxYD7GgspQ5RaCkfiIMdUPn7kEH9TRJJjkYHDg80voceEDFK8FDlc7Gg+
VxV0txVzIRscAeZE26VbPBBWWyM2zbPBuBNduo6jwSwQApsNmnbCyyqUsvbvM2YzIrMPg4g6LHPM
W2lZ+9IQKVyTqOpp1YgslPtm7F7BCzlawkbkBmwDMX7/dMZY5TyhdNY+HzrVQWFn5GeMn5+3t3Yb
DROP9CF6StXrFFqQnFzEZB9mH7RCd3KOyLSRH0GJwKQWeN91sDxyGnDm1tuD4i9faUSkpvhrL63a
tXOQfzL7rLzVyVsVu+v8+erMhJ8kP/FTwoAo30+swRr8h5v5+DD5QmQQhf80WR9i6vd+CO3GK5Uf
Rk/O3BVH6WfywOZBbR/99zFp8DWl0rpBcItZ3aFuWWg7rEehzt/k5K0BdHC0gTI0vv4SvJ3CP/qE
bO+0Tnnq/90B+J8JHfcmUhFpIJM9rabSFrgTIV3EcEi0i+U/Mzsyn9p8Rd4bokEQONhLYWBNSccX
smLIcMIKshmv3HX2UEDS1qPv1RfXcRKyYHmerlvEj5QUmGNkvafRK8+tdphNYIwqYY5p6o1vGbJl
5XXTjHC68tY2K/L5O0tjtI8KbEJppgDnHtpTFtC7BpVSiQMW6cKoruc5S4M5T+zmvZk2RadA9zdY
DTs5kpn/X3RnrZFvdmEH/8M//NTYlIOScaUKfdfydCkUSha/vm8WzoVT1dyOd8O13g9ffts5jeRg
71Sj+kakCBsKdwoY/z99Koaev5ts6tIq2BMVVkYbghMh6e/SHsLUzWQJAjW/v3afwu0gzwnm7tO0
gdfq6R7f1NOHeZVjMK1/RsRX32olQqhS/azVogGPklFjzp/WME/HBHmTC0py4b+5mdEqWwqQhQxr
L/KNAY2HmiM1vtyyTKu7v3MxlDX8bUFJFY0nHCnb8iQqwx6p9YU33NmT9wyDnaFscUde8wYPu2+x
1Ji8SY3KG/at3J+8bJXiWnDxtn75hEw//kR+Kx3SRL8QRv9+p2nZODUXRQP/x4ZQO9nx1hBA44gl
wTbpbdmH+bGnm/DN7EIb/5wu3ETxFYkrpHRQE2OKjXRm2zoRMXS+UtAUI9yEio8gV9sLrhHFMCTU
wkk1q06s+pqNbUyVtUq9OkpOzNhtfFsY1o9wey/eV/MZIeVgymQ3B3vzn4LJp2p8pMq2CdmVTS45
+Tb/zQT+THWo6wjsCsHOonm56Nu+forLvOZzWeWZzhDqKnn9zoLSNoywO+CGV5wCcvLxlloRutfG
qMQueilU7NHB+DPN9NHAkkLNY5Uz4rfRaQ3p7/5u0GAPAn9ddbJzE7Axz+MfgTxgDVYaRy5nNMoM
kuTikY06CYjCnk4+n3EEyIhspzMcO4PuJCaU4g4OjFTwMjOms4BAo2uWVwJqfqt2gQjv9i1aji1i
R5QVVvf0x+cdEbUQQ6Hr+v3Fxubh3arG003+dXL2enkh9Q2d7lqGtiIk/8udb02JcZ8n8knHeubG
3e5FEzdP4P8Vc5rty7bwWyEJYodLKss/6MHb7bHhiiTawFz5WvokRAsCQx/W0GcedyBH+1RFgnhs
bGYyuroJggkR0+WIuOeLUWs8yeylN/e0tFzDxYAnMXQ3IpzM1BY0n6XGWx2EKtVtlGCgN7TmlaS1
3LIFHda64Kl54bEDhuX4uArI35fOOoF0AqMhMG/j7YNyR9B2BVFXBF42N+vbOi6ZpPs3RnD+bhYY
zpKjQGaD/iEJ0rkCGHf8Y45M7Pu3kKeAWzla0WNCvOg4V4+oz6JXijp2gnpPCvSo53ch6gjtBFbq
O6f7kTDeKmpMF0VnaqW9/qtt5tu0/sFBbSaSv0fZuIQv8gup3RKFyEcpd9JhqhoDmdsGeyQxFbnC
unKZdhx/3t4MS34xsKfms2nLVPj6pz85Agf9G7RU1DjxCPU9XZ0AVK0sF36vM7e95ispNOUuVr31
ESHw+frvjT+qJMf69XaY98eC16MSlT5JsI9+Ju3/188ifZsJ81eFsh9vd3ZengGYYqXNFDy2RZDF
PMt6+KCNGm+JPK/AdFEJxwPEGj/lx5JSnbeLOIAtYHN8I1rHxCZAc9Soml1V05BMJnNF+DX9FFv8
O8szzQWBmTpJhBwhaKrQls0/JYnL7So53T+nwDCdlCcB/IzmLkOqE8Jztnjrt1Ndd+Hi4P/YjmTu
nqnFeLzVM6mub7eKsK//xgyUxI34FkpA9Rnf4yFzRQxunuP66rfhILzU5AoZgMLZ86OL/TD//q3/
2pWOOSlJ25tv64zinARR6u/APw+t7Ddo4DMIiGYDuC41P1Qp2vkiUhV17b+8lplBZuNFzmst/ShX
hSuhebX6YpO4X7T31v2eyDTVpm5e9PtgNS+xGrYbX0bb1dKW2aKydRbB7fQWm6yCkQ73lPJ/mQHJ
zvGVT14bo33aZo4jxFvbqXNu7+743ar7a1HTB1DTWs8/8kluMn1qobDdLuwo1MT+hIEp1wBIU2Q+
RZbNL5RkiZRffEWzsXlt4FiZHImYV9K2h/QxcvwrdzeieLpC3phviLp/nLSxpBYIxlNBoCLaTXvH
Ry1UyEHbka+ZGX1oqhuoNLWBKXSI0v4mjaMzmZjrXs5Pwq0gt1bhPnN3ZJQt3rgH13C6nUTRG0aF
AUXPSKYFQi6wU8pGRT+pJ93q4JtW3jhKJLXkYoOYRpNwLUJnTbk9KyiyNlXevM8bP3j2EVDX1cvI
UxjVMMso0UjSDHwrCEQGWhIlgvQZ4fseTMgynIxrWfPT1PF8XZUldIrAGHQdEajH9G+L7iMaouRL
5vkhn2hqQa7cZY9WDRev5LD9KdavW4Z8OptK62nDMGSh2KHZ2odjFdyEn+4gsJujKvJym21cbKbe
3IydRWcktX0TYrJS1FDgN20u466cHZmnQm0TcPMIT4UgHYixPMHiGiCxp46DRkvsK4cSTFpX4WAQ
Av+zvmQHEz+E4iGAUjpxpLh8tJ+6cwynuOeP9b1a1Op9hdWFB4vw5o7e6Kf7wW2ZnkJnIY8Zgf/I
MbmwaK5a4E48CHMFl6eulifgiQDRwGbVcJhvFsqm5Ogvy/IPMNQ+ecaPpCtWS6UB5lKiiP6qRcgX
Y+L7PvICwnPinCC71Em1P+MbtGXjL+4Ud7pTyqisEsX15vV4IUu9izWWsHdCD4YQ4KTM980vjm3r
FcX8MB+xluGLZVVH0WeqaRl2spyJkUFOO/y9+VGjL2elGMYhY+GRBSIM/1V6sXEWgk+F0otxVrCy
XV3RU9vbyotxkdhvWFjqtLElC2dPvYnWR6IMkyGehg9YyyRXGvTEeRA1Egr81ZjOr0wgXheAUhmt
YpUCCTidwZz5wAjhmcJx8dbVOu7XDVXwLBfJ4ysbsapfvIWC+hixGnA7Vamzaepp4MLOyGPyhUA3
H3COGbUa6sV2hUeYKT0pKec7xn+NrWT6A9bzhHGqIxG68AAIMZK8DJg2ZVgEeff+OER/yh/AavVK
GD6XlHvNjDD/kFHuOI0Wa843Q0kvSV7s3wAdSAy/qdKQvrF61E+1Jh/MSGCmQCFS18wF0ne1sSS1
G5OOmuyRtc3QunGLqKzKdXtx+yzyrqpnpQsv6Vj9qVdu6SAxj4oZSpLsWbfzKvkZwl0H+W0+Rvat
wie2/Wcc+snDYAg3c73c/yzjQhrUd62djtHrHV5TDh7ZaVGppJENaZSA/IT2KfKEP7Qw7VQjxaNJ
u+FmrIJUqwJEfZc+MweA+LLRnSgDlagi4QzqHWzktrrVp0SpZEFW+/dKg76XqAm43Ab3uQCwCurt
VRvpXB1Wc99lI15/Ul4jUNAxddEGC4Da3O0noNaRpKYynOiN8nJIuNPTxDlTHLzQyifmnKwZiF+I
b+RhG2YLD4u+LC+sY+smPxtwbD4xFyNkgeDKJ9uOSSx/kWC7past7NXn1YN5k3J2lqjySv+cP3Nx
pmOPG43KeRgWSKMQxXhoIb87T7/+/KhUC3YuIQTHih42l7xCdYpxlhTapMtk1CIviIihkQ76gKYC
wes6NPTPlozYFHBydr392atjKK0WfVfkQ/oSQjkoHpYSVVIG9Mj6GmodqF7kwmkj/EL3panLPGtx
NdUxDIN9PxDzwIA9D/AEg35AmHHx1O57cp7w/NAPssITcCmHGJkMNexumk21qs5xu3svcZTcqbhb
PTRot38E+23n50/EKz97WnMVRX2K5HRJJuw4I4yCJxcE/TWGU4cI+Vp2BiCMDLy2M98PQl+Wgvvz
kQbhV0KmURBy4/yVwng2JpaiOtjSPMQmLZBw3aTZRx2AClDie0DTYbXIJvXti3fEPoIVyVUkgiXe
WFvmC9uRW9Ags8ztrpc1NsfgGy9kL3QNK94YEewmHtfDQHOfMYdkb2Ongh0XWfyZbjRHF++F8swz
OZ8FciI4P10vi3lNXwYlCGZs2jDhP4sevRdI/BcrKtcT69gFFOpxdlxIa9g/HnovgYswAZFtoxvj
4XP7RKBbU8rh5e5QGSKkLPCl8yGEH9bdwIM1vyQkmL4/Et3OIUVTnqgWhr3WEtnYeiNRoQR+SKDX
mjVe3QHyJaQoNoBn/wGQ1E3J7IDmE5JbD9auMppQnIi68E6cMvIxxpF2akp3vs4uAFVnKf6o8JCr
jf0N2O/A/JPpmXwOgTnAVKZQL+YxHRZo1ZnJGK8YPJLktTj5e1cSBlGkgRJjBTX0w360u+tFLvOb
LAR7Rv9T+R1twtG4w9Rv74OXHLZO939wK9f5kbfuxyQVzlR5CK7uYpYqwkUrLiplCLV4hUypFDUR
mz8Y1+hxW+PZdj+ibGlkQnCqvfWrnqsAaJaPSbIIojgEA8RoWqroIKfpB8uUYeFaXVjpFIoZ2sc+
oad8Mob/enW4s2/uWaHwpOD+LW+t3LCvAsX7Lx4JKtEO8aH9QXON1VW5k6uVXjY91Xh3nq7bghQk
fyOmsEk5fl3wb64EVipVmrfErwuw0T+f7G9cVF53lv8dk7ZdL364hQgbhMxJzsgg9K3UMMQr2a5T
1dbxFPtio3vbuXo36gPk+P5gayUnC42W3Eu/hsLKQKh08LiaH0wVlAFEOc4oD3z4JMSAmXD+k9fW
FwyVUnltrCaJayeDziKeeFKXezyasQKijfJTRE/RcUzwXvYVQMS9gRHWGqHDiS2ajHt7bqsNPmHY
XGd8J0j7wyiYJZsRLoTwpI+39ZMw9Z/SWeDuvrby1xDJtw3pAcmdMq3FvETucS+jbHWYDxkyrF/q
qqDoNg0t87fwQcAKWUZ2AEx6ae73RSVZkKLwpWde++E1Qoeq+RjQr3NcDdx4h24cK05cIaEgsgcL
hp+zoPaYkylMrOhVI4EoIYfLlaE8NMmxSCNV9S42jDdp7NqYYgo03jid9ED3cfIof4PI8idYgMVg
zHxiG/oL+YW5NzU7K/XG69LeUgw4tEj/RGyEleVUS9zQVquFFzpIgxDYqqjKy5OaznbXc5yCj32y
YVStIwNg/YhvrRtJYBjFsDpkCdvmq6eEi8Dvj0jISDP1x0uram856sHQQIT29x4duNKspNgw8dgO
bEymkvku5dHL7qSIRAGa0bIjxtsl/eRbWCalirQ2YgULQFKY0qlyRnpv7cw+Xz/COW6RiiQxPKQv
RNPyuBbyBdvH8sHMUO1Nb2jeMfBx+P+W1h3s4z1PrtYbargnDn0uHTdkh9B7aezxUDfcNtJsSQKO
GD5ZExmz0NtN+WwL5EqCTQ9ostEgUt1bB6+SJKcJtJT5paY5uk1TJceO6ly3+4Kve5u1LPgS9+a2
MjifmWi7z46rWEtyFpnOwvkdHMOukfZ8t+l1sQtj4Lt3oFotyJZZaak9KT5ItzeDd13UsR12d+7n
O6xjwoAnZiKgkP+66ZlQUMGY2ZUvIfW9ghvHEywCiiJIrAnnMpq/yh+6fDjyJK7NF6HcvupvYtmZ
d8flBqzL0QMAGRhpMO6diPcGuVVn3hkc7NdEtf9zZsT+ebEh5y1bg7UI2/roetde+lPQMg+vUFiQ
IQ3DlP1SIPNm4J9YL5tI7kljSs7NP1knUPVeFIJcdn4zNwPWWpLHEZUVXDnyidc2fRA3P5xmwemX
2Qep/SsdlY/+zhy6xWkiXVaf/qbIeIYoAqwe34NFvf7slA7Es/cZJXVpydNnvEQSXJ38e8Abznzy
lLbnKtn9CIQQyPs9OU/27zQxdCHwv9PQYXTZFVT7ebb5Bgqq2okCfLK0oFYasW99MebdxWmzW4gy
ryGflvMUwEmM8Ot3b3ul9grJA4KtEAgCGthDSufKepYZuV97R6oZifql6cKU76sRJiTcKRGSO1gy
wCnxrtR9C7LLnXFMtezWoKw3XGSlG/UMQAIEe3xXJR9F3mzel9DoWnmRxEF/rcCvSAFa7+cpkVua
2YI31O9LewBxQhiqEzARmTe7J9fNu40kRl1aNCtsgnnfmTcL6Y8mt5qK1rs3jzp3EXhFRIhIBqil
10X+MdtApyN4vtjHfkT0tYGwpYyEm2PHIMvirVtQfxobHm3NoplKnWfCaQZt8g2Q/fh3UQklYzOA
hrq1kPmaML1K9PvSeJB3NKVotWSNNHxq8Aq1p2vX5d78N2onzrzbBF09eEsn5xy7rv9smV+1HyV7
SZQH/C+kQgKaSALd1C2cgevIgx2b+XOeW70lzKYpWX7ohWAPAMgRVKrBOcVOJVRRZnPVGjz843JV
HJGlI/KwGF5LCX7yb/QRjADHoLqAWptWd4/sGGmfNnjQe3QmuFdQy9Brr5wBYf65o16MWDaJThU0
NN0EZXfgUdiUExT3J/e51kMycs4CGwcSCslHRggWtTpfaysoNa1o9lipMDOazWt6gvMGEEl5foNZ
l/WYpERtUzIe6y3xT2ImwW/PPFjBP/oy1dakswlG/jZCXXPEDh7HZ7VgIipdDaHnTnOYpkLi1dyt
eglpBIm+pSG9qdmd/omuU6DxoUwLpipW/OdGnRjgJ4SS8dQESljJ0LOvo87WNNZqXvRAHoW/AcxW
R3ZPXi8Fz1gbfG2ZCR80yHw3iGKz5J9sp6/L6I/HN7Zss88zVbMYJX8VrDFYY246GptGzF3oLyK6
JrVbDzjJfq0xKPfyJm6EfPdB5SxQMRX9gEa5dxIvQfm163XSl0BjZjwBPyg2QTTh5qTJrrfMycbW
X2bOATwx6UH0s3S8akBIBkChp2qKhhoFA6Xqjtw5c++GvuboGv064y963m+SvDPJKYrUwA1zaM0x
np+EIDpmfEMeJVhClJX0giSOoyZggqx5aOjnXg2xtb4GSoMhBkfOj2bCo4rP1JDRPRRjQAvPG3Qr
fVah6QURH5jBURinmyArzgomVzKBMUiS3G+B6bejtwpUrztnDmJuROS1npDu31cB1ctRS5/WJHT/
spd1UXgHY4iOitdHV4MZPjTC6QT/NdUqTqnyqfnVrH3AGeeZQxm7V+BfJI27dmTlWta3WFcsMtjH
K8bknB9JOzXgP+l1JE7gaMApXCjEz/NrxU6hHf3mEgbJ5RGRM18a8xFcFz8qTuT8VbhU5A/Mv96A
mKQRhOluTRUI0dAnqKXPq+IwQ4Hgb8IV+h3A1ryKHhLOl4pZ2wNAbPAcrNj56sAeSlF46/mb99nx
UpqIaqyyzfOwtRqm2sTl2b+mQugP3ycevkPC3ZevFU9wXywJMI4DQh4G1yB39uzBH2V84rkBX/Yn
NNF9sxKddSPVyjxOjRSx7fErZBBUaXWH6fMr524n1RzDbDsvKmFyWF1wGj6dBqwa9KOMojfXvxEQ
+rO04fxmzyx5tbAs0pVBa0eHseQB5gfF14zr5OqDXxi0F4yDSWTDqiO6D/yHDTm37srsebVI48eA
ggSPb+4V+6S7vFPAZZcuyma74IZszJi01x71qv81EQVEDCMY7CWOq936iQphWrgg0ZO7Eh0ZN9b5
YJEAyDbxeOO8zKSOJMOu4/KA5w+WBvX2XoSHsqgrDr3uM79OzdC801bIj78rEmwR+RH5TVKgB+8D
Pfrvi+UichJJmBjp4xc57dY0lGYdIlrG1DJi9aUFqMmBLPtGjtXmJaGxISb12t8rk/54uhWV0tZH
lk+Lwca7pv/854Q1cSOwI7MwdpR1Z3spxhs7zb9bqGg72TDtp8c6SU5riMNTkRk/MvfPbOQk/6c/
qNaXn7KQpmOlmv8bNvGtk0+R5BDvwFtW3G4H5XbRGATotjEHDkOfqiGofrBKNPByTfpp67ZobLPs
XOMYzf+0IzaH22dGnx5xvVwSac+jSH/bnBUSoX3Btr0zM8ZAkclUpwdGa0B8uWpBKdEQpUHVjLK5
m/MTEqkW6AD4XRNO7aGFAMFeDH3JMPPjcGG6eCp6Uf/bTXRezjXDITn/Gosy7gLJocG9CPf1/AXl
kduO0BYHAm40vkhkHagxkEUaqkOEPhydnr2y+GyFLAxem47vl6z0rlTuJ7e9t31dIvAYg+7BiIs2
Y1OwoCi82w5DfuThhcIrhVnt00rvyt8c8jioBh55I6G2l1Zx0VxL/fhLwCfICM7jncrtSvXJUrpv
WGG50ZiAOP4ZUTB/bM4Ir3luvCzpEuU0yppdjjdhQSOH0eIVo+wJDGgPWShb4th9XqQNMZXoTEJV
i6i0xBv+pM7KYK9XCe2d3no0GU+n0g+BS3djWfOmceIkXYqmro27P9fr38NNsor+15rtGKSX7b3T
NxIlBsrfg9s6QSuveeSXkoeCcFPjlM+8OMrOX10vw2OYaDFIMvPkIOrK9YJ2/OhzygPIigsNF3Er
0gqvWTp1NL44shY/sqrDHk64+ylyFVOwf36KTi14HpayrJbalEROGjN8jmuvHh4X0KRk5uE82NCe
nKBGWd67ad2+h0AlfOPFscuot2ilvspXHDazoKsg9PzeqAzIVmpKm24LEwTG3P084fYtvjJp3FR5
mgnsM4SAWpDPLTYQ3p6xb+Ih8CR2dQwCfrQ8aVlSfJNVVCfcbopH7GsJu4p0WNUJsW7oOld0QtPT
treP+Caht8Cgki2EriX36wR7846PGWFO8S9lVTbhY/unX2xYoQTWbmFmO+Pi/Xf0Mv0kHsXdqzPT
Cf3zORdsxsuzy2gDzW6/8mJ1dCV9GWe1WLkql9GIGyNZqWN86qn6IxeDiF+aNbONHtRERiE8eKHU
/TsbMkbaUtKkS44TfvGYFrTK2q4Wkq6NQV43hMjoXEQUWgVYIeNND9+a7vu4nd2eLCCXbmfmB7hm
dJvj8LAx2Kfp057VC2shenXNzzoJwLj7SIZfCiOeoPX+bVkiyMQdaxM5n9R7EeVTBBvIY84gXN2r
94qhLxJpQloSAJtuoP1zAxunwvI2czphtBZ/4Y9Z30+hi5BFnafHrvI7NtjZND6Tpt61X5UpUY1s
Zc6x599WvoaS0oIwjc2YV+io/TXhZHbUPzmSAY8RvlaXIqjD0a+vG1oVTIWaJFNwwhkRRzyha9cS
ujFb/4xUdvgpQf8SL4SXFQ+bKQMFFYjY9BGvbbqNbwqS1zUX17axT24O8ur5l6/jmtcmmHjZgNxq
hrh/xI+qtwKupvU673a6GoAAxl10hnrp1Q9ViESusMr1d3+TBbU6sh9X3Jvu5Vd1DOMj81wEbY9k
28uzXTiSZcTEMNXablZebs0ce1GOKt+BvrTSylBR2aR45UTEkSOGpC4Q/S6jbRGc1nZ7CGibSeC/
3csIDNOLsXXCO8g/UKCXz7yvfM0P6UhxUpv3LjZv/zIXLkmmF6p5JWkcgdJETgI2TXWaOW2OEUJ1
GvHv1SJjXs2FTCxOdNBXBYXcXwIMWymuoQADnB+c1Rsy3BnfkWFjKX3L5+X/LMiUT9SBHU5n+Gih
KKxajpySAHmjt6vgHyCDcjGDXoF0rG35HP3ZjuFczSQjKeJOsnRBzB3BuPH7qeoIEwkoKQa5awKD
XVKTQH4QXF93sVKrfrDXJo3vcBZIEz8ck2KmAqAoZoTkMV1RNt8hYtMvYFJ2JVymkY8qYhN3fhNf
jsDneNp6ggq8D5TelljLjiXPAtsOGbsf0TsyLtz6EJpoTLfzmf9kJqy8rEjdpKy9ra/tJQ3ZVhB4
7E0Wt4ANmTkz78sTsgMiI5Yb6mNhJLHg8iG5wY2rSyh13TMEAg8u1hWxrxFJAYnr8fpKmYAxgo3/
k2i+eeoAbEIOrzucO/GjdrqNc9lM4N5O10TedPlgpFthhN9/LGUPsFz3sd+7Qo9TrtUWZo1jSXxa
CGeqdMYqym1f4pd/9Wd2ypIFw3sg4h74L0IqhQz59jITDO7IL2v0EaK/wSjbf2yD86Bnzs2YyksX
Pvrhcdoc5XmrDMCnNHw0swDUh3guwkb/RarW9miyRtHg24ID8MrCkKnF8Tqqe5Jmrqi+8vZ/NtXn
IinXLnlSLDje9HCr6y3IRPX6n77v5gkmV52Tc1Mf5OjjOWQIa4XRBRzlC9O+nogMoIL/aCGJ0ezn
5sQRjWOuOg3EYtpUc7l8ceOpWvbK2IBZTsyuuxHbGtsXA/h6hViRa57MHC2r6FtwqOyV7H1itZPj
YAhfQp9jgA7O/MHsk2Ex9a9shB0DKzSVP55VBp5gp7F8EsDgJuuUSyWYNOwQyr59nDOfMgfYN5CQ
Y+K8BUpYyd6HGdCoQgWhVNLKJYWxmrWGK87SsZ+zIWaBBwNI7qo9YpL5Osaecim+3v0RXuhCmcbq
MOxtud6qC40Hs81X2Zvb8LVtZxLNxBCxOHpnAxfjhda8qxyres8tZY+aF6l4B+cLGrEaLsJld06D
YO6704ESKxbZg1zNvEdKMEpaAdOvOgdpBVppd9dpOZlVC5jqLVaytRbhNHvV0pOLvxA+w0HakM6i
JvWyKYmICYF0TmgFHOj1JQbbPCQzoVh6xv6Ko/9tJnxTp5a/l9+zrWxHHx3OpZwfRgTRegZY/79L
Wzv9e+lSWd6CSO6dIIznJtV9Zh3DmJkL5EJ3Fk+upSxWU2SS8B4Pq1tPSLjMqLqbTNiUbYO6r3la
Pv82EXAp82lPZCF1HoUAbQPB2Ket7f1GkhB4v2alRWV9CxGgD3/czAGS0gIB0v6PO/rkHYq8dnvr
8r5C1h/X/nMLrjCJEpt8ukUpZVyvimmvd49bcJgnxZP4I8jci7l4oZNZIBU/n9XGNAQJwdxiRJRn
CgVQcWPx+krsgW1vj/WmSnOdIsU4iGebvGUVc37+ypbF+BEaZ2oZDe+hgSY4FqmsT1ARuAdobTje
imSDi90FuRjULToODTb0TqSvY11GCrCm+VvJBGFP7LFQWgU7ZDi+op14Y5MGXvzO9fECZ1CvhRAn
0RwW/yRMrJmlOml89SK9KxwvJN2ocImgJofAp+RcVBKSr6PyQaF7RsWUOlXOnyOU11W7BQzAO3SZ
DxUvmUbOkz4p9CgoISyvf69Zorfq+37+8CcCeEBIFPAqJeNWvLMfzKDpYt4OunEKb+lrdeSGV7Qr
aP+iC+ypgAYyB0FDZAMK1ZD5bz5p5cxeyz0VVzG+ciezrHSE3zucMXhLMA6E8wvW2wL+NrV2QQAl
EsybX9QA2QyyPylpuC/eZZGRmHqj/vSN7H9/z2A/4ZcmiUypP6FLGUewnLvlmb3H6EHNptEHLhk6
XLoKQsQqP3q2nJz98sP+SishUR1dwwfAOipxtJGaDi9VMXYjIbTmHilAUKqJpOBQlCLW2EqPmHg+
H2q4rqWzZ4GnCaPlIM0QiBkee44lxc8HzckQghhppd6JsntVaGSdareEVgUirHieoGyLiN1lE6fg
sst7xWwEdQI4IS2ncjo/Ul6CrDuKEC3r9s33EuNAsKM2QtEl0lH02oxUxnAjE05AJNPPf2fildSe
Dqoz2F+ulGa7/3m92Eyml5NNYtasqL+BXk7wvm+1SMtB4utKr2bJ0pqCK2tnbFJf9T1mWSbJnkSV
9ppC3ESrKlznk9J8SpTfF9/5jeWjq31/NwjJ/sET3jnpj9FjIXPlmK5zVrKqZpnO48/N2cFM4f+l
4lo36WtWpdopoyJTKrqA2qh0UrOedn/MwGn8GJwP2SjFt/78TudscFmRy8ndxRn61SnTyI92aQyF
TI3UBCZIInotD+Lb1n4hiEk7K0OY6On/WcTbSnzF+0qWg8ppQ2uW5LDNoZEJBCwMlODgVvvWrrKm
S8G3YAaTkGxJa+OzJn6QrE7EyN5OyNszkImT81RRwkRqUviWKH/OXqZEQ4nkIxAapcnGLCX9NnUK
zSyx8FP631GKtBuZTorODYZplqXsCRylRHK880Q/zLGrscwNuz2GZah9I79ilFEO09XLfutGM1gk
T7rF/Qeshs7fLj5U1GY76prAIsNBgFLkwNRfLaPwOaiZwZz6C7gf1Bcu5d/BAFjULsQOXzpLH7Fw
QqkO59pEiYqUYTKMfILZJrLZQjbfbclkrltoSLqCrxVwp7tsvP1agnUjdRiC87/OYM8nZahPJ0Wu
j6H32YG1BfIHHlB0Oz9Jw92UJAr9KSZRxyzmUlEXaVAOL+HDmti9UlNj0qfPi4AYFpC7zTd8f8vr
Kz2z5dmFY+6ihNE28HELVdKbU57kYYsQjnXArvHFeQ7nwv8Z5pyw4oELQFcKzAB/00vLoNEVBh6G
V4cS0IB5V1q0sxhQhENxxg1z00FhtBFpsbIwBv5aMRFAmWNKR3QNtcOiq2ZWaxVj5/4Q8I4w4nTO
9carUowFbeBZNbKCoGpejqH4kRweqGLZXGWpfKwk/RpwjNttW/eF4Tgz2DRDsyfY8Qbi89f0Z8OG
9p6ICD42bgWmQqTyYe3tTprMLV4w/wJThJlY0eM+rzf5S/Nlz6JdijYREzfA8YodwmnEs9k9NpaI
3qHzzN4GOWw5A4nv9AY5W4GcLT0iLUXnVCMD/f1ZaBcBvnsXyWt2l7pnx+qzBqM+yyCyasGeXCs1
3+57ExR/eXPJr/hAPfnSnwkxPy1/j72t1oNhWmbAT5gPyv7mRWYv7EeVJmqe6H+t811yRR9CF/2/
S3YBzoTVO0gHbHOSG659Kawu1Bd1FAJDjyfa+E1LatUu4/FKAWXlUXPDMee1GUJfSL6B22JSDA8T
WT9RF7fEEs/ZQ2TYum3sJyJz8ATb8EuBjHr4xrbxSo7KI5egHZyJygTHdhkqRnoPpog3pEFjML62
51OFTl8YicOm9rtvg37BCNAEVLyAwEKSd3ccDd2ZgMHIh1PxQDUPkAHdv5hxv2wEVQ1YWLmJUY1r
ILAdR23UGFxK5ugqU53ovN4vnkbA3oIoxBkYJ0JNUbz1E2Bjl07PRxHNyky+DZ60eEThbSFwehep
YEXl/2qFtHkJ22UGD/4Vp6se91aTvogtKt9IKDFIYWU+mMCwbxeaSPiJ4tDGvJyYJuT8OnuabQ+/
VrK2M80giO8m5YydQ+vJ80cixWqEr+VId1oacuTImofJH9RanJ3ZL01WjR2rM6MyBBXeGLBZ/0J1
vOspolQXdPTQp3NXacCcrRV6rCkrD07ThQQl6ogKcyVYUNyjbPJg+xek+f8i4Rk7S2rtoK4kcI91
c13rwYByZQ/R2xTtpvKot7j2GCkyW5uJwyCRr5V7b8K9qYISrVVkD9PLlGIe8NYTlD51AeW3+eQV
RvwDgaW0fgOaDqKSXRc22xrpsetk4Vg/l3fPU2qaRthGCiCJgqdXSDHuxUFg2pn0m92kg/r2lMDi
wy2tI9B77vhMbzYfwhRHe323XaoZS7pJEF3UVyu2QHu4K73V9+RtLEDZK+VX5Wua2z5/BhE7kkF2
B5w09v3Wu+7e8bfFRG6T1k+7gdkrBWlSJvkmZaLl+u/38FAShbIRfpe8zjXEEZwDAmYBDDbZadY7
hjHkYl2nzPzZlAgZry0pLuHY8YIz27tbA6AFLuvDQ6aIgmLNWhCItzfNd4QZbPaEB80XG2vrKj/d
fjm+fWiXv+duLw//8e8ry8KM6cCZm66qbO+inY6FoPL8vCsr4HpATQW3TZ7rQ3grKNAT0XGuLd9B
jgrMPFvV0L8La9lgfPzymhnZexpJjq6R0EQjEXYrZVl+BZHaSO+BiQ9cHw+auVCpzKoVgjpfh5kd
UmIUy76F07kt2G0bnukXacliIo+XHdt8UOrkBiegiuaR999vyojSPenT+ATxH1RTNolWJLNGjj4m
+EmiOAhsEtuBk7hsCE4KkkCEePE3U9cOqfl67/D7LlNBqEJFcknV0peTmmb3MMJLlXpMlZYDZ0W1
qVaodkje1UIEq48IgPRiwElvyLNHVq/+NVpzusAA1xv2+YBx7LhTdNskTiuonj8HeLs/D6/8KCek
FvyZuPh/UGgFMMN60aSw1fjgzfOUHxIkH9tXSGHfDQEjYx3AwjEhCbok8JNEUSOv5iVQ7e6MIx4e
BBED9myXbOUSPhUvEyPPTsCqk5XTwiH1y/OFk6WnbABiIknudJc//wZNzdmQsNYSO4yjc9feDCvC
EhlxdJVDPi0U6RQlgtJOYbk5LuuUUn5a25zcZ73RuVYloWtvC3Ti6nlAHnK+a0b4JSdDnytNgdvK
0Hy+0xzlmhStEVDMV+sfoaqsmZXV8BYf3bX1P/yL+Qu5sHNrqDbhy70aW3FOcEev/UWREjJEfVMN
lysKvasE4rQKzUa9uk1M1rfW08CGTkIdkxBkRlXM2WjuVRMIdKSunxOzui7JVXmrZyYtPYGV0yUL
ReXbogaQx0z1i0AIECu8GlRW5rmPLtOICo1bwB6cBvQAQ0NYJ5/fq+T4yq1r5UiRv9os+bdrVv5z
9eB3Tp1qG+NvUPWXnV/4MSKkK3lDQteJ55GfRyX33jwoRXijCaNk7I6JOgQD98hHQc0VgPbGUTrm
PnJfrbrlDfjRXyadsepbOLhJplEjZ0ikiTcj4VDjqBxeeQFxXJuNQnFFOswrVpw+Z1EVsoePfzyi
hXX+frxHLrnYZyX6eHWFppzXsTg7L6C7fVKSdkNpmvwHv43stcBo6lNq8T5cLoL7ZuN90r32QxGf
5BsDpDP6L5DdD7JioGz+z52sxIVFNNLvKvS03hocqMOtXlxATwLOZWoTpGO0/BDsqyxY/A058qXD
e/F6PZhEgbgK5SvSnAR+oOZvXvn28wBbodKg9XoBxol+3Y4cbToLoHHgY5NksCqd4oZbZ+D97PKl
eYEQcMmcJx+WyE8e9WHBpmxSvJk+LvipWxS+d0RALUff0grdj37fvYA1PMYcP3hEa034hx0MdY8N
5vUC2APpD9G9ZDHVFiay6pvQZKUeUDup6yYCpu/pUqq0IDlOFsC6rfj3ClWILMTdQyUs1gQWymAc
/w==
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
