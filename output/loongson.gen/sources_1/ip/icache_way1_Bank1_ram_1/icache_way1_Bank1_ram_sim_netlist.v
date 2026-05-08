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
