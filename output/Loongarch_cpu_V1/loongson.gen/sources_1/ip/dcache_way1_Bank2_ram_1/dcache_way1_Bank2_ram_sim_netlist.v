// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top dcache_way1_Bank2_ram -prefix
//               dcache_way1_Bank2_ram_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module dcache_way1_Bank2_ram
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
  dcache_way1_Bank2_ram_blk_mem_gen_v8_4_7 U0
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
rQ==
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
