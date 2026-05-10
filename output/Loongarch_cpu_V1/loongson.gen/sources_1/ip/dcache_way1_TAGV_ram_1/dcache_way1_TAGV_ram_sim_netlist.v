// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top dcache_way1_TAGV_ram -prefix
//               dcache_way1_TAGV_ram_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module dcache_way1_TAGV_ram
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
  dcache_way1_TAGV_ram_blk_mem_gen_v8_4_7 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19536)
`pragma protect data_block
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
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
