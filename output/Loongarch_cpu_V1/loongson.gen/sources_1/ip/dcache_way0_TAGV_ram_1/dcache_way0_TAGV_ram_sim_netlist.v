// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top dcache_way0_TAGV_ram -prefix
//               dcache_way0_TAGV_ram_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module dcache_way0_TAGV_ram
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
  dcache_way0_TAGV_ram_blk_mem_gen_v8_4_7 U0
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
