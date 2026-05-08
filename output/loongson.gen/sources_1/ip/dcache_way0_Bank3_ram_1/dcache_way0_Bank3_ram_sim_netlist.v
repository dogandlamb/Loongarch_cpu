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
vQD5FS9WujEuWI52LsnkBLD0ftcxhVop2N1jYMFi397hayS92uJNhJvwaLrHU4DYMjgDmlxkKvnR
xk+UwHpqYP6pxtYfy31iH3juqv1Wfo5RfUE3pNyQYv6wDjJcbWAo8L9qgs0g2RIHHJobliRZDvJl
nJzQ6KG+uxSQ/Biu7kmoxDSIUSzDoXjjnSSDHNElSb8IZtpHJJUUcAUXupM2q32uWoxbrUhi3ZTl
2S8hPGw2yrc79/41byB4BiF6hsGi4smoIxXgGtnwqPDuVx1Lzg3zkCd3GLj/0QJudHvycRbZp/sq
r9STXLl+V7jFDjKkT3W0WSrJ+ByNbGQikVXYvE5/MxxJ52r9F1UbPpWTKWkMpVcWz2a5q39QmT8m
o34+oMOsWnkQYxQrhwGz7V7xhiCbipI19HRWwfiVeM43vRbRh2Bkrcm0H+9DxRppMwHH1+NHHAzJ
uwGCYFMXmP2wZAaZP/f+smWmcY6YGvJ35aJOl/YI/l7+uVHYwGLICMA/9Lrd36croGvrfUZwSSDJ
EsiCyL43pz9IqYGRfdF8Fo6dc7y92ZiwYVx5uSjhQEQMnw1wdv6ogQvdpVQNthWAY6hRMEppH6w8
06jGiyRVFIvVHddYvpp7U6rW28YbLmyn3fiDdZTVqZBKZJJE4QyjDes2aWuwBUDXJdof018Q1+uk
MP3KVTTlpJ0uywSwGYmIIOEbkE1T2BvLHQ7JiO8RZOaTInHX8NuEYMJYUBNNPpTpnUqGHOPbR0He
SQHnp7rcIkD5sCu5SIPS2xjDMiPzezKgzJurkQ3xQXYb9W9UqUhGGnHAqjrLgVkaYAnClIl2FRfZ
PMScJgFxurIEBdggIQ2gZ9P6Dlfu3cvPDEDs7wvWwYHInZ9TeD4msnSo6J5lqCcTxcdUyrgJrpvx
zHDa3pQzrAxD7yaQwkWfYlKiMtV7kiSrHLMgRngX5IPHWr1vy4b/qHd17f/M/0H26EoMz18a3Lrs
wAenyHpPdQRrH3gowbzLNO6w9ldUiLkVgWzNgfPdJELzKPG02eVVEJEQLmn6KqGnrom4I71jwK3t
5i3+01z++Bs4UAEtvuavLJ5s7u0V6Hk7NCGLnmnL9sP3Ys60oP1kjch9OThjf2lRV4353DbrFz79
bHFd5sk7Qy36Dju2BvvQTN1KrUjXVPtzb92shtWAGK2Md+IGseVMLopUWsRpSaaasiMfqilq2yG0
/n+iF2rgYJzbKAGVUROH5RQLh8ZHIZM4CPmzfA8wDRNMk2ZBtVZWtq00nlfKO1kVoniOsrcGrahq
2d/Ob6UArYi4tNLjeHx8wpS7cHv9OeF0ELpwqI8jCGDIBMIfkUdkq45jH+yuKzvv2RdbgeIQal8F
FHgE4eZVbvaoeNQiToJNfxxmdZqknRnj4YKFbygjNWbBQ+4r3Nuquq7oQOeU+dTysUnQLPs7Kkby
3ouVXgVfd21398uBhURsAF8wzs49pSmvYCK9Oo+kkY2/I0+4ttDup6OCVMn4uWeKuNQIoOoOYoY4
87AxQ5FvN09jCGVOCI22xJV8jGL2lTlFSzBy3UCL2zMTuev+PdlUwONDElZNOdaeoBA754tRUQ7m
ysoKXDn8HRpkVIUeoKRwRAB46S8pcUwInOBM6mr7AFKi7jCSAqnkVeTw+C9gviiDBdehqOxPfIr3
nZ+5sWHsWg5NNyyxWvnbkoqiokDS4UVclBSR/2NwEyvkMDnQ7ErMl0UhGSn2RpkfldoWEep+txWk
+jAxpJRxmmaK8PtcdtLI3VVNj6O6CRQfduAvMuxbOfWB19rNnt3bSNsTAF/nTq4vsRxRnTaANMRQ
nr8KEWjtCL/46vuAix4FKH4EyTkzq3CmPJW/zQxqIPBu5z6ijh8HOO6l5Wap6AIg6F9lpQXhHq6r
Uo4qsjnlAzEYapNt5G1bvoycDGpHLO5ccMts+1IJgEOIc8F6O8RQ2m/2WTAOtDloJbhn5ud+H/ur
tk1itFRYqLeCzhP3knL78XabJsgMdN0IdojJAVXpIDrk8nMFvkX1d3bRqfRDDNRy2fOjg22jEYT3
6qz4dRgEOVbAd1rIWIN03wnxsrIFir7qkrNb5r9vogwggNJLXQUakglfSQPu1Rjjwdcycw2IgoI3
lq7tv626Hh9/ouCpv23+rregHu0xl82j59DAScqN7Ma0konJ8J2R7Q63sgP474PrYsTd8sMRN/MW
6nGyYD+q2OUf2PhGyzkYjAOq7yrHx9xD5yu2hncORqLFzzK7sE/7bdfmHmNqcLCxitklvasf3rAV
ZzFD84OwdAeBu2yKe1osoDGfWgfkgMb0ICA0q8LefQCeEX8bKfQLiyPKwz5Rr56kUzSygAXVx6Ri
cvHcK7qLNDVSOOnto21hfEhBgl5JHz00+xobugIj/oc2qJA+GULvzwNF1pdOb3Uw+raW1+Cytvm/
WcGijUECxBhnNq191D8/LV5NjVHeoXSubjj7wiN4buzKQ4lPyUzYMqcR5Qv2AAP1/QJ2g+uXlf6D
oNzZ0UR32Ke/qHCAT1R8F0CxbmYpjqT01izwCaGmwXWA9C+cuIJKa+Kfr8WH9sQO7cAXrMLe4V73
1o4kGc7M3UmCHZolNeT2Gxz1M9PUGvNXNnvmCNd60c0zB/CyenBh5Zj4mk35G+80aNUxc+44DI9X
y2JZseKj98iklmhnJb+PhQ8LCCdSNORgIoUIMCRhv+6r6MDJjnyNf4pj54/kzefmmwxbuF5IWyo2
lC3HuIRGXcNlzrj+vNNctNNMJ3uN8wgB0/mx4FBsq34yZT3zpwIEOWsCLwIIBbuDK5lo2MNB/blm
OO5DMy5QfW9G9xKHyfWJx6S7jxngjahmjwqwvvQ3w3PxTcDljtkuhnXU5ulbMFS35fC+EfazSySw
96/WN+3xk/KIa6VEfrYpiIKFFv751EcmqA9Zygg/w1PHXaiLVqE6PNV8rdfiLMBMvyzlLN9KZRqG
FSSJyUexZB7Xkz9m1JAq7Hw9knWYKCGVZTBBXAXBqdaLtD6N7UA25Gd61lMOo+owCMax1hOW8Ik0
2WNVaKWAEQ+UdBsebPIC8/cnuX8qSxa3kk5DPzkBGOtQFI17fBigPT4Fzm/Q3vaZXwkG/dsemha9
RlHkDEi+ZVrdxLU5iAkutg+g1NkhJMyIMyi6hJWbUYRaXdLyuhTK3+HnlMy3p5O8Zzw4iDsQrVfH
XQPtj5iKAVpJGD2QdYGLtkhyy0NhI4YVMPmNBHO3HUNaOFcUkxY+EKYnxQVty6L2z7ePJGqGeCAu
D3rW1INN84uwuwadxAMI8kJ6X+EaRaYOyhJ9+TsEYtKDbobERCNmG7d8EYUrq57csyGcEn7GwyDf
PqndbEVB7B22ZDBZYCS1+96O63WOeSxsTtGzCi6i1k/EC2gwgvjMiRqLkqWKRFBSnY2q3urPBOvf
I7cInvUK1djTBnRJoaBTwFOKYA7rHYGORxg+Mf01ZKbd4hyM1TKQEBx9HA9bR3RaN0MIrCf6rxMC
2cSCg/1laLhnyEyz/rHGTUuBcZhHArYmG27QEugmd64tNl7RBYzIZq+3q3So15fYYF84d6uEOt+N
K1++lqLQNYYT/0gaugG3IsC3oXAwGJIpoPdrRYP1BpKkC1XCW/qsPP6JBQ0M+YsRDYfQGhO875YG
O8P+2l+R0jwZYT3yw0U47ZkMlAlPqGRc0FRVv/rv8dEfB3tioOPTVBCobRAQ011/Bnhxlreswc5d
luRPBwS9hnkd1Cqh8MtjqQnCx90HCaYT010XhVjCqhth8IL1AEKDJg11cPRkq89CasTnZHsRy9U6
7GCrYfWlxiH4icnBDLcsKu2He3Uriq+uzJSfi2OuVSKu+DFxrWlQQpOdrbbnmzB0wwZ8K3l8TnKN
snI424N5rFipwX1Nr+UOIpmloY65Cl+bbnRTFHYwGePQSFNqRo5/r36ZItACfUu22HVPsujK+BC6
hzWpTzoOOZ3t41SmcPsENzCe8xvqRuM7rwnqJlXTkdG5U1otGlLyQ5mCq648nJiOfMzEnhgVgR96
7/wgdZDu7/9UqOLKkZtUd+XZeBa3Z3i2c5d4H/Lp/3IMsbIuwuIAp+1U9pKY/Qak6E7TNC8njWRJ
L7cB2jZvdiYqTW4YCJu+M4edJUvqdNpZuNQ1cEbZ2ZPOlgpxPixAL3zD2ea7HVLjwEhIGD3wdRlw
Mx2XlIUCUobmACyUECKT2nQ+NbctNs7UVhT6bttWCnhiyRFK4Assklrw9hA+z02FI/vnv0zNG+W3
Qick+V+0Cn7B/GDcK2yy4/CFyH1aY+iuJVUwTuVTfkaPZw44anT8Y5yqKE7B3HLTcXyGgrwK62IC
pueSFHcFPaqf+dI0v+8nHjoQkCXPeQZJDiRi3AlbNS+FFXuA7+Uj99cPYwWzMeVK5+4FVqRxMqlE
nP0J8lhwOSyjNlV2otFd9UWaVJB9Rn4tdHtZv5ocODnVpYxJ5NBxZPsyi6ja7aFIsnsVkuRi82z1
rQamT5NNOQPOkV8cqgv5O0jkw7Ex2fBG2jpmNFVL/C80jJcNBELqGKOvmEdtbFdXNqmL71lFTjuS
x/WqozNjjQs0H/U8v2M7/uhs9Yh8OVMtl1X4BXSCI0jQKdr0efMBSi3BLDCVqQFg6e6qYDHbiGhv
WEyncMAa/jvu4XBX1EZlvYSVbQ+0pt8ZI1X/qCCi5HLGyRU+f/X/PaWfsodvGGjOVuzPyRl9VJRM
6ciUxn+ONr1zR8peGUYcC9q1+svmQncVG+b8Aau2pabs54QBsJD+2xPpoY/bHBaZBLFPmoLfoVf+
H7NG1orLOEAoKdi+qPBIDvChoPDwk1yNBYY2XlPjxYkxhkcv6T9Np4cAiW9mZmYYprQq1jHtb0ga
/neGthK94QmM1p9BB4e0gDQ2kdk+P/Id72rtZ3hqEbcheQovreNTqaTXUqpbx6SMGzxIOKicpQAO
j76qIQ9rYZGxPjgt1unRI5j3FUSy1qRcMtLiSsnnQRQUVGy7SwzNBGF6m9T9z+cAE++lUlpYKkG1
HeOJ/5pEgyQdbn3FXe8pZF73jq19CewgmvCeMyHUtXTTjNqdLRi6UOZipDBy4IIQ4wGbiIkUpcM3
UPLu/WlvJWmhMUywzNaqOgdP3Xd1Bp3HnGBg1g1212Gotcgc29R0t9INs1a5vo/S5pY2lQA85cMr
ClowrWTUeA4rBqIIvI1Dcg7hnVeCpUTNAjmv4wJIh4fFl7xwm4mm/tUgNwr03cnQu5r4kjFUK9DX
6YbyMXRlwPGmRnFdKcqxYXpO0MkYTR+VBxt9E7ebL6YYVfgXM83SgN91HlTISURzdI3xA2N5hlV2
c3kX8v2RBEFdAtfjLbUHTVoqhCyyraJVywSM10YDFzQq+eeBY6GW0UOgSH6JUiUQ7DhVD0CgZgp/
cAUFgaQVO6QltBpC9T1zsjM6ndFp5cNEQLvt1cZKuZJga1ljG7lxWxIXO5Q9tn7fhg1NR1wKUc3b
r3mrN46hrI4EZGVu9GZaKG0Vk3i2B719IgvMNJtushi5HMClpKJOT7u8mSJ9MNHoBgH+tHMKbRXo
Aj8SLW0+pZLm0jRVPBOGTgjMPiqbcKjtW/asw7n5LmMTWvrRv+mMREZOA2lDF+GYSy1gjFFTahu3
6tYuCdfzG3FIqpAK1o5sWw3yNoxAD4ZHwyBUYAHS/yjKK+yKi0AX3cN22pcwEWzyeVkh9XU6sFJG
eoVhVekoItFipt/R/5GvuiTQWiVj3AQ6X1FMRVrua40L4WZjxj2WLA5lzpIIAZUxGkjcvs+jZdum
3Go9W+qUTMz3VoPs3jrPsOPsRRnjj9hWxDNRqiDZ83PjjnWkKMauVKUnj0IC3V/tHdMzqpYJPRYm
HbZNEsikCUy0ZHFc4A5YdJ72IiCYTbHiWE/g5ynr3EDX4M9lExKh7sU3qQJ+eERVMz0Q5wdwMaDy
D5BqYiABHr90VKl7AtZTihH/6uet+dV8Xc2U5S9G4n97nZEH6JMJXEH+ElBcfvYiakLIeE3iwvYn
b/qXOdB2Xe10t9nRtlVzUy+ptdZewmc9b6JSo3yu6lftqlFgTfXG6+NYSEcdFfHnskzDfUvbZUmt
nUyIhSbz6PxlDgheHkl9jlt+YbAevYImcwFM3gvNUZ9iCFnVrUJh0qweMSECaC/0ZrKJppUgWDXa
0fiDz6E/9BYSqh64ecuhO0RlEorHyX83Vjb1MmTrf0SIs+2LpH89Us+veBWFwCOx5rfjsvmZcU73
20Y610Fqd/UNfQdc5KDsqAojgI4xF/YuafSULLwz0pG87n09uI6LRI/sLQBmv2j2+azoPnIE6OPF
liIzD5g75irLZVQdwbIv637mSyGx2Oz0LE5/axpGANdJwiXlRZJ1rqor+Vy4sNMMPpsl87ONJoIv
H3U6wodyDLxHFK52ZJfD/n2e7/BLhK+UGKo/fDesbvqiMYmUf8SQfhUZoXigA1G2z2ELYnzGph0O
SdMPB3OkOmFmGeXwDfxK0fu2MGlBsqeV6fLLzr4gNHBnJXN/vGIG+byIDbYXRLZ4PiQ2s20HlfVF
aWvGWTjfQQnydvWlja5Br6UL95BjCBfBA7F7+lAwusfsWSYydOrK+v9Cjj6eTS0/4GxbO4jgjZ0U
0MvFNIijH8K9TyUewXGq58EA/r187zdowliZaA84DXNVbZqlSiKoBIw0L3njqnH9aXvffp1Ak5UL
VYpS9hw3fDnl/crIeRGQEolRxGGpZVuyY5JRxnlxtxO/RLd6FCWYLADPRlVYYBy1nhktH2AvPcXK
lxcphOEolqCqk82w5hL8pVP8tYHLI7aPN4A67IDY1211X+f54yicY1M1ZNPNAqn64wbkhGSzFJxP
poOohvw5PFHRg8gUJJmxeZOsPYF+xqREcF4yZGsI8nh68xGIzcu6auSNBX2ZqlHMqij7E4mCz1J8
f2JaSrn0FVslD3w/E06axW3m82W6HrrMuoTRPjKbsM7oHbMwH0B7Xs1Ib3cLaoZ5JZD+uCGZtskr
rOOAPBEnmxYVQO1aFQ3zczJxwJ6axq3uTT8qLtD/VJxQouBMCSTslMiL6E1nVtdzO08xQuRFts9O
5zCj+m9KEjjeda8p7uvXvXZ+W7qMRKbQKRdLRAP3avRlJ/EKZMiYPlTpgt7vxHQxNQWFp+iZNGL3
nf1clUNNwbMYMCO9bkAhgBsNzWQ5a5Y1YO2pnpWAwJKYqPIIYHC8zCAu+7MKKsFttmeZDwYpbuvz
nzI2jqGOe8MlKP/VtkYKbWAUjtBubwxiEyLoF/9zZ6RprLLdBNMhnP6RifolPDb3bWUakn3u1tIl
9TrfbRLPawOH8+gs1OdDX6aUrynyzJcrfHJbxddGZfEk0qp8E5Qc3yi3jUQe7w4qNEjOckbngn9K
jFyTGAR5UaXUowtAqkNafZ5nI6XhPhzXa6+EzIyB5WM68Tz5HBiiL3H7oUlCDshhsb0IWuqau5JZ
XzrGTbVoBR/6c2noKmB7Cmoki07BabbRaD7sjzL+M/+CapJF2eTeDAvA7MB+kCF9xjXTU81C2MSn
XHyT5UPssgU0HH6BkY+C7mWF998vgJbr96TYa2mIoQ/XX8Gq7SkfFCvqbQm5+ryKtkwNHvMOX+PH
fgBdljrDz7qhsdfd8oH29c76ceei8rSA9TiJ3gdVAGEw82gwS5UWGZhYMRDIFbyNmuabpnOFG0QF
jGCxIx8g66c7+TG6MvOH+gPCnrIDWYUC0D7LGMBcZFCmOtfmRztL9ekR+rOK0vJNb8LsZprtOdtV
xiOclPbPHyQ0XWIHEQbdOMxlU6+kmCqdcJtao82o397uf8H6IvexEze2LT744UG6mV6McinxE8mN
SYmFKN9TEoTU9GsQpcpl8gy6XPrCoMo7YpzJPEwaRtlhYzsK5GS80LArN+bRSJkJ9HvQ+vQcVRFt
FVe08U8hfsDKwTA1n/e6JrFqthRIZjyeE4Yt6NhEs/xpC3ckI9k+eU62u2GBLJjGBpEo+s9xRJLa
LXYRkO9xtEdL3480swkJL/w/KlcV7+bAKnv0q+1s9CjtLUlblFJ3qqmBiXfZq2YKh8LZcNP89mgV
RbsQZMy4+mC1l2ujgU33bGdCg3Eiho8g8b1T3FxV4Sch9+XtTqhdAowRvm9kPZ42Y+dIRcVGN3HJ
AMu52VmU2OPdIFUK3LhtH3KhBsO424Y7WUet/T1uxl70uYpw9Kvt0IJTgjIYE4KcPcKrQBS/DgUT
E8xj4rbnTD+7QikH26ZjsnDpbonStfAr5WWVD1pp0kjhEJJAurBgypuTiNKwD3oGHERE313YiNSL
ZMdrBH5Dl9DuvBtdIfHxgsEmIvX5/GJWBfIw6UoVbPqfqdMqumIv5Cn0SPqdmssZI+zydmVLawul
nSiAgV0mORhF1fiIjacxot4v+hgW+5j2A8m9OI8wR21tEQ3eUqgNafFjRNFsS2plp0b8gCnoY5KT
vp0rtb0li9L2xbHLbQE73Qom3XS/nvj7f/WVwuisVdaGkd1M9fi4WhT+lj/M6LdsfqnfCir2Sv6D
BHQFAJWPGK8qOm2U/PRTfrNR11RFI5uaC+ikyOqUz4PO+GLVVFDwCKWzO46KZYfAXw4jRu3VOegK
hvAYLH5oOoU0eGQiU80dFjb8vQZ8mRsjnoBh7ge3Di95udqLJmHhcIe0e5XY6YTOevnsmB28E3jD
tKE/PxPkQyXR9MRrg/MtaHzCbk7S7UPkvkJpxEUaPRbbBYiuhU3sj7XY3C1OCqZPDQ9PcJi+fQu4
f7kv8d9a3BGYi8RW9I+ufGpeF09WIVlNBnFP+TC/TgPo9+lVzSkKLjb5YlsD17yFHuf+5tuaba1l
J8voGV1sT0hYN1H44HvaQrTnjymgrY9IicRjq3/+n/pDdtpGhj2j7AcOPr7vCnBqh16ozszncRTa
qekUdKHhySPy1xiBrFCjd0kHTsn8MlxCOjvohvPD+9AO/JAq1TuG5yT1iisjwjCx4rM2MrezH2TM
HJNl+nqhnn+5D4edrqI4nakVLioSKXtaK7Pq+geYpczSaClK4wQjQU5QxEH4h+8Eb/kXflaLU1mt
3UXM6upgHZn+k+gwwYvqutbhKRFnY8Xk/c/57oo1uxCBi5ZfkPxByvAOdAC3kjIZIV8G7NlvowRH
0br5OluGPyc3yR88G9kPNS9ryJvDOg9Tw2cfE62zqnduw8oytAreHX8BBp6QrD052g/irpyqKMTV
QhS2u1/JXKhA6zPdp0gQe5+ustmppeaEJ3otHvItIRVL760Uv8xIxDSgDhi/uyvDoLV+7rQQ+SPt
q5ov7fn8d6wxG93P52Wl53ES4auLrR2ZrHgfZFNSyBq+PgGRX9Npetf+SCwuPnAAUt3Ez1UNm1Hg
B4f3k8q8kBRolMFmAxWI+8eNsNr0Zic28XFqS1HFFNyiP3TxzK5HgyyGX118Vh72LTtFukD8C8c2
+IvzOx2e7N+RD7HYjxNZetrIiG7aSzan9fkyTIb0ifw2lxw1uadY4QhFrnQ80+YtKxNpP6I1lTLb
1V7pkCZbU7+SYLQQYh0lTjORS2SJ9zWVbTuQmAxbZy6oZZSWMFTYFCySFEhdKs5BPQJ2td9PSwf5
W9DSsgUMT8Q1Q7OMElFoputUClT1q2J0pui/UcrZVEhidfNAGe/8fxo+Ajq2CxL6lpLPJpGBKtt7
pmAs2fBWvWFwSikQt815AtkONlAEmBUXwMGXRk6XudLFcvyBmwTF9w8DGNBbWvswgK060vGwjryS
fDU1yJRlqJLynFOGzvo3/UOZU5xkq9rQTaxNzoMQaL7vkfT+eE1cw6doyTCAZOzHLCTGLSzDhnGu
afV4CYqrO3LE77sCjGHAHlmBalTvmVQGG4K4zbhrtr6MJWkeCx+G0gVvwOVVDyQ17jSsxJYNxOgO
TwKfXSHoXnjIYShuZfV9wAJBq8/7vC2TVBQJ7KrPxSWzLJ433H6t09kTpZZPl3NdFKQQNQNvcfak
hLt5JmSiF/oU0bRGHOxhyegPNcX+8mrawy0139qCc908ANnaUyUHHkqnrf2fPyKHL+Dd7bJnXMAW
bNKmV91cSzXFOwbeaGIWUMHqp8QMcGuCae362HsA3niDTVWIeAVm0aX50FFTCO0KgY91ioFwYhih
DRv/YvtkhypTwl95ITnsXC08GOtYEtdffFCyiLPPRyzxS13RROg8uzJ7lCiDHMmV1EgosBoQCzgd
Ur1LSYpJ8IZA0HVhsGUYlGisRqvbx43LHU1oaYFNS8o24+Q9hZ3QIsuzOZ1XP4rIVa6RuKxDhWhV
3rbYXYfVasm4E6wnWYVicXKyfSmZfDRPGRW8lx8CiwGclHsOeqFIAKO+kd3E7g90bdBCVtI/mdiD
2BBXVvXrAVt3hL5m6OUC5EgidhXdIZhBSGB2QphUjr2+BPYBz6mhzm1BoXU6XU2D4xkZJ0WHWhy9
beZ5FkdyXev1SKlk1aDW4MZUHjMZR8sjQXmn6TqbUdPQnQBDVASzCJ06ZalHoVPGx9RtHwbdX8UC
ihIDrt2KQZHURfRPCe/AzgsOVMqZASbOJ1YGOmcy5Vg7cQPgVS2kKyqq+LlyVzYoeoL0rVdUmb11
/hRKITfHhAFHYVO2HRlaeyqbxysfXTM5OzxiVz61qku+78X6yhUNFNTTT0inaJ0f2BNDEKG5FnBB
b9T+5q3OXkmSxAJ++Y0XQJwAAnRFvIPVLLwoYmWGnVw7IxxQHU0xTVQanJVL4rzsbjZznjVWFT4g
J2SWIWF3wk3k33r7hnSRrq6DdZtTk/3ZQUBsCk3Tg+zizqg0T/ZP1SbwC7he1pAXXY6DnyMRIUxL
OjFICkiRvMB0KSPik/llXQCc7X/waOOpCVkvGwintThqoiehP/mWvc1ZyIQSlR3u3F8D+WHj0CZ0
cRbLmaNLXjFNxkRLBOoS/kcDzBzu89L2H5hyczODMeyf2T7QL4Ze6GRIKBk7g+v5Di+TDXYB4otB
bzoOkCEryu2obh/tem5BbP+GYEZXjs4L8SFiXFa825YCPnJ6RpEJyMkb2TKq5q18iRyF1ClkqJe2
jvzZoIDOYo6mgovzNJxJqRJf/OV0N8RY90m16HadZk36iyY2QHrwiq/VpxfJdQR+86VCb1+wNmL0
pg5bApUgOZ//h61egPMubuYiRl4moSFQuwhOl1KLaKfp4DqS7zNaMkn9hJ01BxVBRV8B+ovlo+c4
Aiy8oyvDmz+6bgNuR4pmcD5mYBcTt9q7wC+CqcUWm95k9WHSFLxHpPFbtuyvsp3dagP2PuO/q+fh
RfjlBNXNtpi9T7ineJ0T67C5GH556jdn8xWCY9wzi6xqyIEnhHhPSGEWwcIeuy54WUbLrhJStqgb
G7fhuT4swtUwgbBVXorybLGzjGDXUyavjDU3LEsiLqzWFBtzFiS3sXVlqAY+6VfvHwarxSs+cLjE
9Li81X3zZdu0gUwgdB9soKCjJiLktHJ02uv3r+U9ZWz1wU/IxnJrwIxd9TriCRcY6ECk9gOXhIrm
YQwpBU8j13hhCVCsAE/e6iAzMVPoA9Og/wJgKTx+JeNQ+6up2E6lNwE9NEjaf4sjpYuoBq/yanob
64e8LJ9tizR5tac/tF1J/HzxD+9vIIyLwdllUmiR28OXSXOgAF0tOMEVJLF+MN9fWFYzge9Xj8za
7kmSZ3AwSmMUiBSKbbMLAeGJDwoPfWyXV7C/E7gNJYb0An6sroaDu5rztAFaLhabq3sZ5i6jzEgc
Y/hTvUANEmx5mCtqcPkPFRyLpkU4tz1ZE+znrhteRLBU2ICLXWg73heEqlAIEP1BST3of/57HMq9
QKk5fBeMgyXYb6hpQNVBL08vtKqfWif5Z42pvRvTEDnAvNh2c+6lMKYcn68PjBsAXuCaCzCvfiho
hn6+hMc/MObJp8cQzjLddmU3jsIwzlxUTN7V69aGKb3l3T1gTy+ub1wRSbLwfxJ3u5jt5BkNakXz
LFFg9gM8XZxeAgNjVY6/OpPhUjwco7oawTsUyPJBCHq16XnCbSdNDCPhRG87Iojh1z+C6JVbA6Lj
3udxrzfV96/nNJ5CQVsPCZ5H782RttLktjbO1tIUfhL79QOZeLE+1S8KDHMHZcJH+OMt4wBlmt7S
w3uORpoO6o/6NxcZH2o5GQ4MeuAVATN/uHdMtKcHgkgRCF5TJQOor1bM19PjGVtNRIqrrYESj0Jz
4R67Ju0t/sOcj/JIRnVKOA44c1dOAmLsh4x3VeQd2nF2Jwq/jNEc+kNts3yh3VAq6JZw5AzEkb87
F1dObuGm5Nzx0lADzcJgWoIIvaFHdsaO1EylB+oIQ+jLXAM5ifSaPuebTSHRD2Zxh8nWtwjGuYNM
4Hl+iuaAfeBGcAOp/vkTBsV76oQEcqiWl8LxlORJwMbi+JgLG6eb5XtJzzQ7KnqhoEa0LPoNDSdf
2titU+hSxGU9DS89qslzYtj6S++bPvegGX8eJ+BSLOkwqY8iqC741NWJML8j7dwSyWItFJddZO6c
ggLyDAPazMxg3NatAU7PLxASnAHk6HGHNtIvO1BpagP5YF4RqE2oJrglbbHW1UUZ3SFau2weG6He
hesHxLLBBSKq5k4V5uXzIXGMHpEA7cRBaDwE72Hu+hy97DbR1ZCYf0/EQMrtrJvZDcjP1OfMawqi
DXwHwxtiTYAqLnU10j1qGTCBrzrG48UGdMN8xrNEou+AzzWGciutybxp18XbhIoazmH8l6MefbF4
CqKCvYto2WuXFNXQnhsEFDCQKg7mR+548SRZqSRNTy0ngbEbmGMvt/rUh+N10NK8P3dk1X4P4sVt
PY1oMmpsEk2j94cFD1cJVBYnvaMPfjJ4EUISj6EIE1feA7nrbhKU1TXrMz9HZ+38QJuxV3optMqE
Sk4XZpO2/ja0hrPprtJn0BCRZc9vd0nsKD3Hot3PeeUnAPcC6WLmCxjgWBQ6P4OLu6iL0nUe49Lp
D4VTz2jmTTpuMWSzoPiMbk4IRwbHPC3X9h+3JyQmsg2nkog/e3VOTRq2kfgPtvlmmQtBVp79MfUq
RGUetmocEwfxhIf8OkU1S5u+b4DFVffQc06es9+rLQUg6LMvqVh1ztONc5vFJudWR2D7jnyzIfBO
/M1vsdW8cFWrf16WQRrMBUCWcxxmcc9d9UuuaYA4enViXJyY23UFafXcUJP+gk7t9s+dEEQ0nNWw
CGrlzxxl1Iybgrwqu//v/0Di1tPj0ijUzO3j+woRjeFngmBz63eOC9H+d3jN1AVITFKVufplJKpP
Wu4ICxrRtXc+4V5C/kgeS9skT8kXSWqiP+IveZrla/R8U1Q+PpgIJAwgRWitRyPzUNVa0r+q2nCq
NS8dl5D4akT6tuUiBnyMgt2OqwQw9nazweaH889sll+jsl8XbmFvlCH5dzJmbewtnQlXbCZNMvep
13TPa0Cat/HxSsD8CxKEam4wmw0co7CfG30Zz2ZoFqRwa0/PyeHv83FJOC0Z5H5KPYnrGyP/E6SF
uitbpYRbb+DAMzYUYw8LMiMkWcVNLJzT4s1ij90tTDq+B6dxJLOa4tNOa7/Le5pYzjV1CE3BVMhp
hHIJ63bdw7eicrG8ZGQy7owgoh8TJAdUba77bSGjGiSC5NCjojuGlCrOocXgf8VPopxAbO6d7cXx
rz9AjCimT2nlpws0CjD4pxIRuevlbJo0aoYI8ywKpRSw92ZEKI5HbTJ8HF8IFIUvWeLrEBH/2cfU
Xp7Qp4EDjVWPt8U2uuQUlL6yQnjBzN+r+4yGMECC6a5XxbqDMifQaoSUMjU1eedVOrMMzysBTdAl
OK4DVX48HkBCqwbWRLLSpQHtXmLUC8WN843gfUVgOSL4oTZW0kKnOYhXXIUIsDd3sZmGMYM3aCN9
h2xmwIdAIgTlCSSvd9t07OMWAoAbgyVtCvS+qoqQGxcZSRTb2RRz6uk+hwxmmhtHis26vO0YuF9K
l6nHzhzrQzjdWlVN9jrO7ohMcEUQoWi+4lk3NJCdGP/hkw+FYlCGanW927VAY+caT/MGgXfKVJAP
192LtayDRvIO8MmkgBWRyG2z3tnWDCwNtdMZbl/TglljE3pE7KsqyNKjY8xMbfEzVPc8kUUaDKSK
qbxYxpu9ayBqwGH5pAPNRsz17YgK+TOSAwOmLOX75XbsvjdLXqzogPtTvtvfc4gTysamqwex3YdM
P5cy32h5hTwnXdsteYKN/2SgTtjLSBk/nOa3S7av37/apVzArH4mr1VYrfIPAYReue3hoJbE2NWJ
jWhB+VqEbV8mjvKkDRYDnA9girJA0alffFWscimv2f4gmg3SRpb+27GIbSqyo10j8xhx7Fz43z+n
J2Tc401liN3huSZAyJfvy3gNqj7gl6OPQszqHQk3ZW5w0SmIY3vKwq2EjvcgCCwEJ7sd7R4u0b7y
H4+4awLICCvd3hOAgLoKIZDi7HkvFglK6Jt3kyeoGA96Y7+SofSJCitQUmo4boKy+GS120lcD1e3
t4/jIX3FpQ+mpYNCP20AkeTfgiJCvF4+759KU4PHjMo2OsQSMoXoCTHHy6R0qR3RF0Jk+ksZ41lw
o96Bnte2A/1aNdX90+kdgSV0sZggcM0VskxCKCNdPZKHI+MxaGOC4VnWMfIsOr1D6r6wdOv+k24X
6++TE8dOxRucVQUSMSSS2Ubb9nGG3gFbM9gFYqpzwkOk3xKT3P/bdpRwtRQb2bJPcBlZosdJxqOx
6IGLE8j0ChSbdBswnodP6kpusvBlGnHufxOl0Tszv1hDWqC8srktIBdHZuw9efMVoXd5kuN+1XXh
VCaMhbxS1/q56ke/QOUJf7rzVvMkCUlFtreJ5MM63cW8hRSpoWnxmoXKakPqyZaSPd3dm80hZ/W1
foRckRPBrls5ofUA+kJLgKW8DnzHWad6fNmLVmicxNyz2qv828uqG/XJkpkvlXOEWiYeSCJsq8N1
gSQ9l7Qd4QBycyvrU/yyiL/BDsp3WcytqaJlIpW9Z/cHnoFr3u093qU22aAqSTjHnAA6OlHwQEfl
N4mBvNcrvwyednydt88toUD9z+ZbGt6xCTP/fMlMF10OTM+6tus3GQhnhhIYONckjmTKkr5n3Eg9
JGDNA+UiMqy7eTzZ1khArqq/jmqbeKy+0NJO7ErbV2AsMA2jE71ntP3UzzgjxqbPghMs3t6i64Xh
uvFp/JTMSglzEYxA8mLS5sHfADre2HZpQ/8FkzIRjQroFLEBDwK1h5dVkwfOZy/7iN0f9UF6qGaj
7PqycwDYNdPcnZpsVl7gg/gO43gZjrwHn/mhz9h4jP4TWT7D815SU1awzmZotDaNM6OiU5KvKBsF
TnxtS8Cx41U3kLcV3iknWiPM2ouL8IdqNkklv67+mje7RktwCSQeV7a9fg4OY1Y4PACYdfsx0l8w
vYA5SDRM4IDmAkza4LVgW+O3an2FhrFkt91+uKZuer2bbDQnqyJr92uhGFPpj6olAWpg5ZNWOJG5
laaMeKyNFneLNMl7CYaNBtzl5+pRh27wIrBM6h12pY0ze0v7covAPscFf5GlbaqY1GzLtrwi0fUg
6EFZsAjfAF/tbBZGcz+YSqFjghUUYiBF1UCj4wMgpMNj6yluyENgLo4O/bJ80ci+aL1xAyS9we2e
AOUdPx54DYh/nwSDpScC/2vHKt17DuMM2T+h8IxIzUWNjvZDD2q7j3flTe7Vd2JtKZxeHEdWad5x
DRYLCxjr8zr6N9CA1k3GHBErtqg1kZb4++Mmrwv+CLz5jnSBMo4j06Nkx14d7K8FvJJJ7drp66ow
Krb3P8bJQuP0wXm4ejypiykExzxswbM5hORyWZFDPylAAt47aMiNpV+O/697xBTiuSA+A+q7m4ur
F0HPrCLYPJyQ3IvZWFBXbGocLZCMttBFGMlAEhF3Hy4uaEh+dQeY9G4ud+N1tEcsEiTEmdVnPrAZ
Dy/6oX6e0lxdCDhEVzYxLr4dRBcEEy0+tEocNRpKRmjdGWd0mOs/R+TVIdX5oThOhYt91uniKD4B
AwUS2NKcmFOQ9rfupWdbTzwG2ytv7tlmaibQ2qZvVXndRDDRrt98LfKKKC8Aj4jNQVPpWTRLAHiv
nvzS4EbyPLcsnyzXaFsPPNPS+dbLG2+Aa41O3ZbxyJTsUnV56JqkP+xUWAYURAfgtagQGQ7iH1s2
mjqMUV7p4gEHIRDmJexDqU6o47b+VDHEHEWOqZQJF2AvFj9q1o6YPyus1q1yKqgpaNrVSgGMnLWE
s7BXGDiZSOTXSEFedGN3FACkED7fsyQUsl+SWlzvGeSlMnI33LPPwia9LzZwmb8dlG5UsAoUxmWy
XBPcERbABTvbuXtbTJgVs/wvzOwzZCfxuDOs2/DFeM7pRn53J3pg4hPpDJbwpxNNrrUGY3S5ld7f
x4Z2vhkL9lH3MMl9M5oKD6NVYeJvPqcq2BAiIpEWXsLSkC2ApXpm936SCLbcSKHc4wIjKRoniYJ7
wh/VbuuX3borI5wB4QSVnVyY7ibKYRWngaHtl3FCHACMYsIqY2TH4kSwrkKz26rO12TIA4xuFT7/
2dXkQb4PtfOhcj6dN/I4ZSNtVGQC+BLSQNd02ZKbqJ7DZu8ykJQzOIpZWmWe+mQIvtmmQYanQ5h8
n6aP+4yjkyIQcEQPNs8WEXc0O9CDL9M7Ls/JoAtKMi/qFxrdon1SoEc1Y9hSs7BohMSDznI0HCJf
4R64XjC9LhffvA7ZwvYGnYbHtJ6Lhs4CrQVLLwmwH+/0tMjsHCYsQVXToMsISRPPvkRiMamFbKbQ
t7MZzfTwtBx2PN2TvsP1lp+YSDfhtXZZsu0m6Bs04DfN48ZQmuf2G4UYJXAdEqtvsDRB5Ndtzaae
ihoCkrR7UhfT4evmUr+eucNZDnVNi3pkawvzZeUXqQ0/ZnqVUPwl43eCm4wKonISRtHYh0d+RWsT
g6zORzzv1+0rFdSGdIvmxZohv3oGQ8v/PlVTMC39WvQ3YeLDUUYfckrLQhPjTDN3cORCo0I4/z99
Ek5NILUnH8bF3/MrJtnucDWfVbOUgqKEtlyTzVlO+0vebff1ap/l0h2tDtqtsAAg9RVHeDuVqXWe
e5AMcQVbsLxzpkwEMwnW0eg+D4yRdrv7UTL2mIsgzbszYbWs8EA0PG5OjYl6FjnC2niTzWQ65s9L
bLQJEvzQVgN2N0XTYlilFfFrm6gV4sMKgwd6qf+haJpgWPiHQ+eVmE0ligrDrbNqa5+V5GSyuzkS
ZtlyI8Gqc+24xn2QmarN3TN3pFRNr9ZmLRENBmhqKt2VtL1NB1rG5cOnrOn6rq+5PARnRYkzq6qr
WKMBWTOYH+J9SKD8vtxDZUWC8lGrrbOXXpEEVLZ+6S5oHhqFHbpfoCSzpUeRYw78PiQxNI8etGOl
b32Jdxca7g0tW9oYYY38W5J4HwYIntjdGlupgfZfCJLr2GD0ySyY4DBp7N1U1akBwGpTa4I1pfMS
M7WyUzWrcL6mo+pA0n4sj44zYFL2h2rzoe7+/JTs0F40K5/qqOt2ne8yEyrvJf3Q+UzzpBQ/fax8
tEb7cIaMet7RWG7ilnzC+NxId8sP9DMsMUdFbmq0Drc0lE0SyuRDHHC2pc1uv0FowuA081L4RG4d
bcBNrpVBbfVwoB16TLR1r0cDjXK+4wvJvJOODnhN5Z9uJONIkmIo3ICaDeN/ubi6fFuWU+vc3Xu8
cYxFNhUJr+5JzIOmRmgKiD554AqNlxwToEsZPomjt+odDgG3g77m6LQ7K1PSoIeAdrWxX/oIgpRC
hPugugO9XabrpmjIkCoBkFf5IV37AZJtEJxPqZ19YxDr7y+hM1q8BATYyFDIe6YC+L3ea9zEkqoG
tFAfiyMymydBChE96XlED8gOgXZBbFIyIjfq+dsXoOCw93pZdJK8163gTmWAeLaLCV/bDDPUPBdR
UvfuvE/pen9c/rFTxRuwoU/K7EZurMbT6R3KKEYYV5oE1XgJWrD9e2AHFGQyAcWSXsm0QsaMxWWB
sol8vhdNJR9AnCb5YlovJY+Co65ztqfvVmJ0iQfquZbnTkelkmrcjGZzjRHCeZVCQbP95q42SD7s
nIsk/2UxP2YWRr2ieaVRbHTB74AEcOyQdNrHl2DzxX125PMO6QaX/CVtTRztvGX1ti576jrWI6+L
B7KmZWoYpKbo2VQMuRwG0RihBNXxPOVhYK0/UF+6+o6qDSoH0A2I3ppy0w+IkjMVHzfJT2ku63ld
QLjjOcr/Id6WTq9iTbUZH8LXVXqeBMRMW7DfKXnq5agibbry+9kXZxrofVxsnqM3vyD4a3w6K4GK
pSKfY6udufyqQZWPgDa9o/uoJpbj0XHqplKSuYudgwkocL2KF2xuvPSTFSSZpeNRO+ZpHu/gxqot
aznc7Miz30Tq0DuwTtUadkdz5wy72/E9Sq0o0/y9V+BoWQq6hrcj253bHDX4Kt5wu7rRrLm/9hrO
AGHcNudrzzZ0baglcKGQM+WbAsUJ9Pt3uE3aSqSUwEiw/d3X0H9ocpcf4QglXEiJ7oZo9v39inYq
QtS3lXlteFYEJM3JSKuOFeylSnxlYIUjdCDWU1K4Ey8MJOFPbr62rOeG6lu1nYAuBmioAHnTMyFu
I3rKRD10CMNnNKQTNiw4ajP9gesyLqWIDrLoW+P6cRIUrxXoxcTSr0mZT4nhHPGrxHmICUlRquGb
118IBHKX2gBsD7rwMVwQDrTbTt7U/+jaaNmscKZlNQNRGdiTLRg4hdb8InBOJUNZtousXQdaJs2p
V1JiNbpcp3BUbY6BdzT1JNQE2nGbB/ZKnckcNHHiXAmVWaiY2DWGIsC5ou+K45EKuoDkgoEnA6fF
9hDHjqFUe00W9uXKpfKfCD5Q2d9ad0aUQ426XfumI93l8NHwZg48en/QYw1tdoprRDl6oXcjNIoM
3Ane0/MwgeBzFuTs2MNnumSliExceBQ5nxKHlFt15csTT+io7M/zQq8wIVLQ3nbj3IJ1jUaZD2wY
yxz0dWI32kmyg76yn7Y1HRsfY4I2ifU+SkmbvJijX9RfBnQ2a/3BimW+dtZbqxXgUFG+qIEN6MNk
lR+cAToT+dNswKbYSwHpFtNxmgvuz9gJE+mUgVh/oCUzjiP5le0wgUL6CzNTW/v3X527IsnHBP63
z2ij5rKufl2kld91HRoni2xGVC+BzifsG8EEoWnETJBb5yi4OlzdhotKDNQmu8x8a6DnaLkudC06
jPGgRb93g05HUXLZBaa+2AEq0AK+K07MTuIW8EXSUYE1WaNTPtEc9fyib6FTPyAWvzM5rym2lL4O
UMazalrjzggrxBqRVX7Ul2bCZqgbR4PcJrANsHR1KaKuadl24j+UpDATpn33dv/ORpiTlyiCQaa5
x1QmpqRCTWrwYLaE17vjTBBnl5HK/GyQb3v0RNLk0kM40h1CDJZeN5IOxs0aQSCYVzU2HvosgQri
J0k61VUqn1nrsaYW5T5z7JBVXO4j9IoBGZHMgtdVhkwRFbTndDZYlJfDvRtT1ehVRl/xO6x8dLWm
E7/ksi+QKHuk/ROS8fSbgHkyPNIN+1mUJkLyq5gSjS32/+DcrasWsSpGaMExLonXtdewHtSQLnGk
FC+EYJiNR1IH6715PTIXD7s76wB989fw/8t+WRXva4W1h0Rs1eYf0gYfA+9ZQRocElvJLkkqspc8
W1Iy3jD0ThbL02UoHyUq39yizFsTHzUPV9B3U7v/ow/WhfwHTOfltSkpIo5Snlue1EiAFBhORnMl
XkshfOAXhIzGONf3Lk6o79b9uW2+VncEsQYw+dWOrfz6XmE3zyg3n/+dX0pTI6z+qblQGShg85Q8
WBGKyX8sNJJt0q12H2sBDP8RZcQSM3luTlYExk3rXNlseUrB5gQMax5NgqdIeAPvWv6qnpbOBy0D
b1Z1a6HP6fnAO7qVVxyKAi5wNHLPEBwyNPc0hl5Uyj/mB14+BAJvOOAgeceD8U6WtIGgPNOnYFaU
ufXRc9xtlrmEb3FwjX95UCuTMuZBgjAlCThcUnfAjsSTsFCrx2EJSMG+FxPaZNW8RnFBIYED2osH
Sq4hMK0rz+UsLSHAs8dYiS+OK4VedgRR7Kl8TNp2JyghcX49KqbDZrVK0BBn+QQ1UnkRN6PEvavE
2UQrjueEui+PxVa+0THPLC81GjFJQPLpZyJxAoG3rAMSj+X5mb2UtsEUF4jZBLBPpNWmGdPb9/XY
jbPjram7h1oNeyZilLR6dwiHjTwsKqKWHQaIdrrMJHyUBsX92ocN9hlBRNNXc0frcHYX1sHF5mr9
bBR83UYM+NnsSrj9D1V2wMIcy/0FjDrob8cGiZ4JaIbO3JBrKsCSPdyukHQBpKoKRUNC4Zyb2PlX
VEF0udIycfRef6wVSZrDWKpyJdn8P2N2VeXnBovLv0QVLaXEFf3ql8SGWASF9dJo/1tkRGgwO2FN
QbsKGMlIZTbRetTtcSFZFHmsQ3xr+u4LZeZ5Uil+rSJwl0AhSfOGpJUN+SLWMPXsWUdYh6Zz7IhT
9/HmYHfI78D/PNC3WKiuVj7l939u7eZDJ8lEYy/aobogbQ7NuU3+Oc+t2FSzVcEGKal6ssMgIoBZ
/VnMIcjd5H8N74ESn8Gzuud4omGEWZxfcKad4/E8zV7Uh2pOxM0H4uD6aE8ksuGslO5qMa9qee8x
pTIoX7V7MXxVrcrUaZe7zLzxm16RZI1FPKyyKliuGWTD7qXDeJDynC0pitpsf5fg50uAk1bCfOCI
gY/w5Z53x9BWmmAeZJfGLtzC7sG5p/SqwCl+QhbgIC9Iepkipky5273DBhvMpzfp4pUkNuArDmby
mMRot7g31HYqty80jJD4pH8Gu4O3ZPTjD7J6Fm2In3EIn0Z/h+Qo5FqbQBdlodBhmxtG4tCyt2ev
WzpW7+qOSkq34Fs/UXptOa/peMCK6tdyPs47alk97sIChxaLu+lW8l6L98SJs9t6Ph9FOp9jC/5C
c+7K64KseQxodU80oh05MAW+UukNDtl3tAzbF6+IaxuwFan8JXZjBHLUb8UwOXtpIfpUxpzT0UKl
+3hvhpcZZKWZNIqLjilZmZrqt96HgveSG6v+WekXS8ReyJ/U88Mb9Y3BynTJGhsR7lfUKJKRw1l3
azDUBrwIV/KLexikDPnA/vAmBUWlK+StNoo6X8K/A851CIytmYK7Gui7vGHdtbweAU1PHVWW8FSW
nZNolUMPzIdk8nZL3E3rdCjcRf0w8eXFl4jmn3chiNu6VMKIVeQ00eGY77/kyVEXnnWtw3Wp+PtO
S+tKrhBEvI+0w4nFx/s4XtjlgHEDk0UX3g2kIRVFKaIZdUhVJvE7HXcYyuXpTXAUSX5GJGZVtQtg
mbPS+hGWOD5ZnhXT99yv1T5FZNHwlYED1SpJ702NN7UUd8aiLsV/8W7Y5xOZyHO48DUjlnQTp0SX
E1pKpVa7rX+/9NKY7rAX2l6XqHUYRI6p7we3S6hIYPOzZu+3elFA0RCYJBmAo0webCcNEsy7KpiG
tgKNvvppuKk0ssd77wn7aTcCSudAe94DfJQB5hlXtLtRBbpNIJIgm1PzxUsXvhdh7kM9OgxmMBAn
nNP3Zkdt+5EvVSNd+I5F0hFS0LjsZKgE6Rr508BQJlnonL6ss3L6vdSyym4wQHtO0i1QKUFLdx0A
u7nfAcqF5JHS8/WMPhyR/QaHlHKluYYZNFKEd9DFMyJPI+NGETUJ+Izku3TZ7u2rxd1GF52gUURd
5v1HRSX8kRRHDMlqvgC9g3aJwEolNz504EJ7Zghacz8Ql27kujeMQzeGH6yvtVbo14bcun/cZ37U
gcZpKia9UG4vy4wo4J1Q2I+YCQPNY5HidivV5qJRdAaSyfB4yHcW1tKnaBOvvDZUUu2EGp2+aQ4h
TVjevtu+SWQBWXX7QnUy9d0NjzwGMaSyDrK9ydsJWSxM+PTE7qymn3dWkjOrXqknHgBCH1rnon1+
Zum+QFkb/eI5XYZwmX6pzxyCnS3c+7EAw5rKx8rsvwxlxjVY7iaM74KMkt3IbxOlQWA5xee6cF28
3oSi1XYHCNloZYX8KJ9ShrPxr26VZ+7PecQPBOFv6oOecQUlsG7lwrL6G+OWFZvHJ5BEj11kA7WS
UmeM6fSt13ntiuINkEPhRc8133E2itfiVzmDWvGkzGJ4eLbeGn7k7vKLLRVAJ1DUkn1FH9i/XlR5
1HkQr24BC2X6xjcEwLCNlPNGrEVbWt/fGTUiyrIbWgBlu10luVwwHFUDrc5GkxdPqg8szzG7qF83
Z4CZNfrwqJ0BQX7CcjFhLwFFgIvE586sWgBGKh/q2Zn5jUPKhvXHtYvTaIUpctb7jYtLKBOMrVTL
S+a26g+7EAzpYNv2yfAnV6LBQl1KcYisIIcbCqxCzDJV19WXWi36AzpfIkEUG20Y2cOw3LAZD9HU
Lnyjs9KW+FiGovlBnzXygriLsrKA2gik6RyUauHQDgmkZNlGYkdF7fQSRNd4AGiiteQGTQqqu4b0
RUK+X8Y43RE8MDIjk1haxYMLnYAeESsfgd8WRI2H61MQ0OldsoYFmVa8IatJEcfK9yQvKjA8IYLB
9fxleGZHFqGIakRxheI+AqRhAgYzLCcjCcL0GHo+TIBPBwAzRnPMWrOxhrdcety+fAiKmA+a1LWb
Vw71w9ike5SnZ1cSYfffthwQVigiFVi0sFIw5u/zjAHgB7mpubQ9Poo4mRxJ1Nvq/M9jokL2ullx
Dant2CeResODIUjurazU6OdrwxGp3peiT1MTwg9cog4qKyBW2s4fnZOwoZilq7aT792GwMKv5tdO
s2cmF8/a4dJeiBBiLJTSYaye4AwaZq3rpkVSLJ1u2UV0hXa6yP91WMEG0zqOxMN+2nCKMuiMdF4/
KOMhZ2myS0GYDF3ci3ec9YLwz6/1bvFGer+/EtMp2CiduqDDtb4/2wKxagswAIC84DsF2NoXoBSy
kHBvA8lMvwyKiQJlRwgfBgy/2/neudhNZI0G9rMjm4Yf5Aliknq/+2F0i2thJkv3I2+RrDwxpzF1
wOlNPi/0cNsfWKDKl3rKUz+eFHGhWQYwwq3BvP+WEwOO6qiQ2T7ShxPYX2xDXVPKs9b3+A8N3BgE
wBHGkbOc6arax8zrfe5fgk4o8dNkPEw6/HlI2HMgdIWzsqLCVA4KkJDr6EqCG8kYp6YcEmHe2HMe
r/wskSjzmxXfpQIcFEhySmyK6dqwLhlQ4P7hlBwNotQQepFdpItO9gRGNWEGMrPrTze3KjtfVgCA
ov++bGWDBwr875NLljG1QXHBQ2Wct+wQYTXqAEI+7VlqeYJxMqVti6ZiybWush4WCQai6eXXz9n8
LS32gR5ElJ4ReMk8vn0sfG0HrX0Gvei+58Fx3on43ktnW6hFqf59v63Ltpyeoxh58wsci7L3h2j+
+/Gbu0+OfanRiMFE4Y2AkEYcKzibhiJONXIGT7FwkPRM7n68PPNLMO7yBmIpK15/7Z99I1lMC1BG
UXmmakux0ne6D0372qSnl90IJNGInLxrpqIGSyU2cxJbuSWiUQMZUoSqbU4CDWsRlnvn8+hSXW8a
jF2Iz//a7z0kMJWldWC99Q+XwqUE28AmasQw4ln8690ooLtPToAK8SsFj620PI5GLI9mnKQqkHs3
dVNKXz6s4hcnDFLEfrwNzurOsUkGO9c5u3HEKMBRgiurK9Im5RMCq4+e/2UbvaRdjRp8Fo1PLdk6
jC3u/S4kB/9KPzv8WRezqOTl5qBs/i/qlDuiZ1Zsl1Ef/L8TdYhhVqGIg0ZBbUvBg3t4M/GqkegG
cPnHfjbiFDUrYnctoAcDDVt5mAGMxibmKjL/AcA5XgkfiC2BDWwkRifqpS4EdarvensL40SUIWdK
ZbR3hHFB7WHvVVxmJnlJDf749PoJHDkFjgNBZV84fypBcZ8xjCNKHYvELLNwC+xJKvGqakTUkU08
6P3gPHi2YIIp1N19fiGOWW8C+5euyHAxfoQxpPGMa2Peed0wMJ5zKqFr3oAJY/TECp5fLnG9B+V0
JnONNkYiuSZjTe0kt+1T53jfIQa8j2GcAArumV6mEnw9032iNwAFTniF2TZuSXBZNN0ESICEIcvx
xxd7jERDjIUvTt0do7PbfhjDAeG7jZ2jcka4c37N3cCjUR2QsbFL7eTBeCj4ID9E1K9bRWN+wPAf
ObJZsGTSLztLXslKbviYNJvY0Tuhsw7Ot6PPOs+lHPZIsj3/YOfmHdez1fXN1nDZ5HEwHFLoODTg
Tvg+NXsi/2hnzYI2sBGQqeGLjhzoggjaLmlcDSwBsvAAxdkg25iDnhEABj3R6U1lCfupjzEbQt53
d0RR+g5pwZW43hEh6/HYM3iHU7X43LnuOMGn3w9oW+znmxGqCpYB2zuvgYMPsXmlpZZcyxz3vyrZ
k0bC9rk0eS6dFjANSvy9MkRuilX4IbYgr+yq2f75bdzyZPy7RcMD62lJ9bxEnb/kNDGBdKqndEgK
gdaixZdEUhPJE3/G4lr2CGkr7w9eJT7uoFID5E/wJ90a+kjoOWwDizAEpuBG/cZjM6i+RgihGI+w
Iu1jpvYPTOHjrWVf40j4NvOTCPusisCIAPlC8k5iLrPesAXBOxUEEFajL+NoAZUVaDCKI2rFw/D9
wCCIINbqNYLXpq5ntuwQfClJEdayefTv28gPkZawR2XIGloCB3zrLHqlLPYSGRTbXUd6Rh5nTzdi
qcu+FAN4XmZwZlesNmiw9Ea3T+MrLZa3EOoGhl3q1rOYuusQCDMkZzp1JJS4D16JUOCpE5rpyGTW
6Qt2MADyYyoB/64M0IbbVRY7O4X6ztwYCTTa8ZZQWVhVBD5jLiSHbWGVHYrlVMUMj+qvOkU/rrjT
yjv5BQTJ6b81/trcnjTRvPFbMRn86q0qardkbxlL+6VwYEXnUrTMPEgGcVT7slzCU8lDcD273Y/R
AOFDSLviNuX4y2jHeRdcYzo63LuJeX3AsYJK7mJOfiCt2JQZGNduDpe9tQwXYqKsy2yA9H8SuLHp
J89qM8f7CGwdBb8xPbcqjElr9nbw+AcvAXmWDmoL9m9s8qGg4Ckh6HnYe01NqHGcOfYKkR089DfR
WktVzGXI4VL4xGcihQPeqdGySh598woMQLiDdQAGdf3k57n9BPGPY2Ehs7Q+DaWMvMuGa0znkZFL
4dC96Wgi95bGquQIAmOqhypQsFyWsb/+aXvtV5CNFS/tUO3xAlRpcvmTHg63i2xuCVSz1R0DP09c
/3ICigEF8U9XYbsHGXwU93iSbD+H5PBNfNDL0y6vUglNSKipSeglRPSnEeJzGPp/57eZN6KJ6G5l
dESmhOl6lLvyXoGSirBlNkpJ6MhriaeQ39aqPECBI0GTv5uJjUN7PmsyjHT23UYZr5YmRWfoaOlm
ogzecPFbJoL9u+h4yW/EtFIpKiym//KOBYwF1I3Hpqs3RnQDwFJgKKW/oiwMdHSRqV64fbdnuB95
GDUwD4h+WMqjL1OywFImUWGcxdHWvn+7rSQaJHJltRlMIPX0WsbbDxBzwPHfzwf1uhgnavmQhW9I
93bKkKfLtFZjLZgBLbHNyfOTgdrCwTWHsztXBsVDM1SzpSjpXyTUusOMl0O/2hm5CGarbQ16V+Om
9bv610vm4c7RWsp0joNdFnVy7iEWrYJX2kzjLesxI/Rin2EEtABbE7XFtC3w0jbroaabNAsyDVWu
Dvkhu5qmYYn/OrIFHyNZZFG7L+NZtUbBdGFDdE2uG9TqoDW0WPu0J6ZPTLCVKaX0JpDdw9iAVt0Z
kHDuUF9ih0nzVJkz/b4P9OMf56DzixGCAVDGn/akRy36VacGss1exZ3RSJmxwcTs1Itsm7kltV/q
ID7sPnnn2iR+oMHwIcXygCzvE1DzPnrTskMoRDxE1goohCkMGV19c1SHGCDgyWgiQvW0CCAeu06a
7i2dAgS7pDwvgaNm6azcfqRvbk5+Zw4fSJd2eePN0DzG43AXuoV5UX/KxnjxeplfuxRRgaqQzRAw
NpwURcX0kmsAkpRdKR1S56FXC2kjaI9WXB9azkwWvDWoxbgObk6fPSBuAgvgGKT2OGTSPC1zgXGd
FgRM6LtsITxjQoilyNZLDI0b759ZfsXKbUUxqTFZkn/l7cSkCSHOF4ote72O9rf4lTcGyolnXVVi
hA==
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
