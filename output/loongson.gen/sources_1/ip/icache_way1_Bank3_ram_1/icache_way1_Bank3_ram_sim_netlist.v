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
0A==
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
