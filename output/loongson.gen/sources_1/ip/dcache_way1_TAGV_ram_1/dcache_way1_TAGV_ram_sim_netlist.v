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
