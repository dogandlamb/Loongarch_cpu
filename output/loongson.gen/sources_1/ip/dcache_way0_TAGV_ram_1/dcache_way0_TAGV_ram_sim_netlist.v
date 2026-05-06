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
