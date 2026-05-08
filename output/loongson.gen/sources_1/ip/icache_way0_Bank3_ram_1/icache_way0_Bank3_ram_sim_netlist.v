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
