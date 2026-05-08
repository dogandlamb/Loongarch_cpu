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
