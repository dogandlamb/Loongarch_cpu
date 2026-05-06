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
vA==
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
