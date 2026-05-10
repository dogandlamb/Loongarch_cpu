// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top icache_way0_Bank1_ram -prefix
//               icache_way0_Bank1_ram_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module icache_way0_Bank1_ram
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
  icache_way0_Bank1_ram_blk_mem_gen_v8_4_7 U0
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
cA==
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
