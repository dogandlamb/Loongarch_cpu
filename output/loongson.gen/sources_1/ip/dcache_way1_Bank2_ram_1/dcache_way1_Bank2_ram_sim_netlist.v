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
+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
vg==
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
