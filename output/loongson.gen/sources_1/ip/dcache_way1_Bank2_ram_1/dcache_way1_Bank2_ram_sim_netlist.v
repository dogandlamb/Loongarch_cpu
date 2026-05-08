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
7g==
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
