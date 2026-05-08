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
Tg==
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
