// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top icache_way1_Bank3_ram -prefix
//               icache_way1_Bank3_ram_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module icache_way1_Bank3_ram
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
  icache_way1_Bank3_ram_blk_mem_gen_v8_4_7 U0
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
2A==
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
