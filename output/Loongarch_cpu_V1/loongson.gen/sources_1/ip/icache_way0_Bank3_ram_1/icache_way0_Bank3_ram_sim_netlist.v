// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top icache_way0_Bank3_ram -prefix
//               icache_way0_Bank3_ram_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module icache_way0_Bank3_ram
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
  icache_way0_Bank3_ram_blk_mem_gen_v8_4_7 U0
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
wA==
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
