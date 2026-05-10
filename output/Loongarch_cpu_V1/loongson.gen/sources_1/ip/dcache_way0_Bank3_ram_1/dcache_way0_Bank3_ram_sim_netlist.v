// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top dcache_way0_Bank3_ram -prefix
//               dcache_way0_Bank3_ram_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module dcache_way0_Bank3_ram
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
  dcache_way0_Bank3_ram_blk_mem_gen_v8_4_7 U0
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
iw==
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
