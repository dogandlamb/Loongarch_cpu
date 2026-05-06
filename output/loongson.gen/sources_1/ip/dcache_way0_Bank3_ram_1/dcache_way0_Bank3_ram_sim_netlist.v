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
uQ==
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
