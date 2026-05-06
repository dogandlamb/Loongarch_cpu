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
3BYLYViuGTQgrCVjO/+YE+b8XUNXmI6RRHR1Bb7B5ITppcnDZ7M5y3yHuDmKRUlhE/2TCrk5pZOu
DuQIUrkH66aA+Ae50yHvcrQJIsEx43IM9O/bwAAadFFvp70oyCu7G9dsv6NeetTjRG+w0v4GTlHP
hk/kRZU1r0ixrdD4cj0XnpbEXzZoRJ1Oiy7ADthFsZ3rDWSjHqbaXlhvzJ6GyM8H1zsrmHRg6YxT
i4mijml1rAnxJAL7QdGllt2o1V5HyXN2Q0ZQxoxzr4bz97ShR9enZ+UXYymYlKQoXh0GyvXbcfTT
8dkdYXIFfIdSK4UJkRPHLo/FdZQPJItVYI6jmBrIeEu0RXl1f7IlrA/xO74xZRm9D/0IvF0Za1IN
FVMfjGytPD4st6U9hiS99Liba0p1LQ9HKgU/B8rqv0WvnQg4PpLit6HIaJ9CCH/6EzzrSf8xVrsy
6gqDu8OOq/2JnbbMAr2vVG9xy+i/3IGGex0XdmLKS3eUusGFxImVkbN9QPuHcf141eseMe8KycIf
IzvdtflFzFzUS4vHDhpqvXdDmM8XGMTawtNJLWS2bRfUvWIY2x0o1OriPqMDA7jN2Q49L042/UAO
JXiDfowIiQ4V400az+BPTx6zPWIS3H7r5CgprKJ6eM6cprf2N6uMzEndicrbs1u8Z2X1pciw9mp8
iINeW1gO9Hpz/7KhXATA9fCNRGrooYU4PJVENKJAC8ZYhnsa2Ow6Qr45HbTghney4DakGYoW7g0u
kM15xDfVOPI4pTEpVQZDI5w4ooilRcMO8M3eAPpA4dMuPfiG1cF5xoqksuVoCikKjBbiAsQpJPN+
B7WyHsZPABA6dsPyMv/34Lt/tPdOY0sQlBdSgXl2SmEG5ujY2SQsaygfi2nFxc2+bqI1Q7RewKa+
5ZPi0ynCmUpPQ2pvAj7rI8M3vrqbvGPMBxS7dMZkaxlMZfZiOUUjyZOUqdNrWHzczaQfjvJL0pek
COnPcZfL9l4BHAIWQiqT2U308HxxtEe5s7TUR5KyViAYHgSHO+dxauB5ORSej8QocntE3RYaz7IO
WNNDXwqnvNZWs0GOT0FUpQATvOQkQAiRCEDfb/p8wCuzwFnaPC2QfcguX86q4xbBGplT8mVd/X7d
R8vqJ0F4ZmOUS1+XHEn2SN6EQex/s6TvUrsJ2UC9+t6nHjzYRSEve7EhD6ZsV8BV2me8ncQVOCwu
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
tw==
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
