// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top icache_way1_Bank1_ram -prefix
//               icache_way1_Bank1_ram_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module icache_way1_Bank1_ram
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
  icache_way1_Bank1_ram_blk_mem_gen_v8_4_7 U0
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
