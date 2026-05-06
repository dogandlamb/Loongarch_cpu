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
