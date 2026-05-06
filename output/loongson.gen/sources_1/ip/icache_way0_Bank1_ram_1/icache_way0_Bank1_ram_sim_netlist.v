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
Kg==
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
