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
Cw==
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
