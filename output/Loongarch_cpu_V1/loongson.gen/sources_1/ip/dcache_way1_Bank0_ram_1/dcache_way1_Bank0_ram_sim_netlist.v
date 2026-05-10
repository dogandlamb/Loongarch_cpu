// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top dcache_way1_Bank0_ram -prefix
//               dcache_way1_Bank0_ram_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module dcache_way1_Bank0_ram
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
  dcache_way1_Bank0_ram_blk_mem_gen_v8_4_7 U0
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
itJrNWiGMyeFLY1oyBHwXblC8wkucHtsBWo+uwwXuT1rQgHXWZQeD1zSxHKarc25VxWRUqXkZL5c
cRpsiCUBuk2OSHuQzRVD6i9OR31XtWbEu22aWc4dEu7Nk5dYnWeNzwqyMjaOcy5p0B4f0H7xYgkL
VNBdvhMijMj55c1c5h+kTYC2JYDs+natlmHmygGw9XoV4dNAq6DWxxcNVHwV7grjU6ekrZ62Bohp
DbYB1r2rUEsYoT0ViXP00YxRCf5FPPKdVAsgHqVjmx7q+M5Gc4YI0G5zOUHMdDBQGqfL8lEPPciT
p+zfA96j5/vAcNYVOj+fXJJRKf4bLwmXL2SPspxyJ0zUYhNfOyjZfV4uU1rgjzNg9yIc3WMF6S4G
2xyUYH1vpJ4Ql84u4N8o46d9zYYnBFk0Yq+zsCaqixRuYuXdm9QkfGjjXcPPvSin2l4oUmpZzqTE
XcfXOqVxwgYH2WGcshhnpmya/Ixc52lfxLtqV2OCkmh5gSRWV1xE2LBkNMgCVt6vOhsdJa9bFOqM
xSX4blLiburkBxAxVOjDAp1w7nu9JwBbSnPmOx4DThnacGgsPq1M0RnpiMbV9Iz49lCGNSUiBkQe
kDqSOQTEih/juiweaZmRMGAIBkp309geeX1r7N7DeXfHVrc60llfcgJ5htfiXkiYVpk7jeh6VjFQ
AVaF8KJFwjcrX2sDWN2NkZRahabqitUXin3jXug5LPRl1EWSNQk529PTV0+lGgmOUvStousObvyI
P+ifMPrb+3LhlGXw4APkERCjzln/jl/kjauXl3g3Yb6Z2wtP5KFUpEIZuFhLVKdV+MLN0huHczeE
Cfc7zwmNRHGTLM9Ss2fSLga4M1wglLGGEGb6GLAPMWlv/0prERrXc6tChEfxGNWuhkWrhqMNVaQK
ybZ4D195Oz8sWYQrGLHM4fiw4lEEToFZCjzDqBY+DWQI7gH3OxYkEFprtA+DlY8tes8IGlKM5YVY
aiuJQYILMNbA68tCVrE2WgOVe5BlG5xpPvIq/y63gqSynI2N1tQqq3H6ScIbEn0wlyi4t1v3hKiv
ZY5xcSltrJ4b/JuHrqxH2PMpefAE0+xVGagNriFY2aphwUYKLSYZFUr9ZKrYGT7B8RGoF1PanrMI
Cxt6jP2aOXehQMnD5vdk5HnW87YaokiS+Q4R4I4yDIQW4tHuqDtCBRFFZ99LejfeCG35XBj3csAH
edzPO2ZYwVeVzcbzKL86QuqkKOwe4eckXig3XdjyVmPW/r4+5fp2v6xY6o9O/EUNtooaT0QMHzM0
OthSxERMKrP0qwwEQkURKzuCzaSKUnxkglm8UNiEGbj7PtGLoTdX9UWE5JZ3J2yfZ8yUSqZRskFh
LJ4fNeaLZwg1mp/30W2iWV7IGiElHOw6OwrMHP18N75hNTvuKtt2duu96gdR0BA+2k6kh0mmme75
aqKOYsuKBnWPdLjMU0jBCX8yrDJKml2E6G2HkwDUt/w4DqFYV12z/6gKFc2Fs9Li9PrI4jLq2Ldp
0kb+WPdDfvEQtAsrb43/2fz1B9FZIH6RJJ84cm1g0Vez5o/MnIZL2WJFTZ7TME2rjCQkiCyeRG5V
BB2WQS4nTvlWtmsYOhCAFyfZJBM7aKPWutdLr/tPsB0wrPiaIajvMWWw8EiHZKVvAfdd+6GsAChq
fvcqGIgLssKyfnQW5w1myUEN8Z8X1icA7kvsYSoeu/uXxzdl88rQpg8ENhCh8BK4MDvefko5KlWA
o7RLwpniydWCOhDkmFLEkMX9qunrWayNnHTGBeUlKLWcYC4YPAvYBp/mV0j4uowQPgybHxobWe6H
smDveoTRYwXvdF2PDYV712KnazxRyXdlKeXXP7BPgiWHbi/1JiVhATMv8rIGh0R6988b1Er2J38N
QD9/7JdB01b1K6vuhkWc9YVrEkjo65259kJUXhBJDagzfUxz46yqb9kgcQywaYK3+RuQ1SDNzKx9
JGQyWqhWfBmq4H0uWwD7ntPOsT/OzNs3ywr4O1CEs4Fs/8fLV7NrkjB48G8u+s9wWDWSTblYdSb3
HvDmKvqXfBrXQp7pYrwKJkEeZ1brgxJP18EzzudQ8nY4+A2hBGPeD8z6mD8de+ttKAwLjYK2r6VH
xNaH8tKbwqPRobFd2KjbRt11qdlmd+2onCUJgJr6mNUnoIL2UJsF5fpajr7KUIUKqOYzbuvuKXAY
m59fOvzx5WsawdwXaLxVFVfLrF3K27xmM1j4UUdyCDEvLDM1Pfl0QAhpzwMVfd5Q1dvbsHhjRNKd
gUtqI3AmN+mtg5GlhWDFe10aGGqthKP+7v+tXufG7bfOuHA9UH6J8VV2HbbUI1OooCuDqmOOvch+
GuI+dsKodzKgwA7Yz7+/pTSLDDHaKEwZW3avcjB5EFzjZL9nO8H/KD6YpdwfmFotzlyLEI6mvrff
UtTFjmUGgNhO0CENQ0RQs8XNEjGe35BH866m8KWu3iWFxKrYMNMdLaD9SNyoMB2D9W2+QAtvzIBj
7doLkusii05LkjHdh/0SZ+wh4ERtfudsvVoXA3vpvj6IulGZ8qC87MAxNw7BxFLNuoBAOKnqc1Ic
6NYOsJOe1igf/qRXPspLs1W9VzOefJ52QSroIUL6u4Mve2CvwcizIii5+ReOGChrdlSc7hM2kmyV
Sj/aWObBvoYVMQvl06pXzR/HtxoOYKMcM/EqcodYm9GsTVXGUuK8CTfR+0KtgiYDSJ4FLUmIE4Ib
opBDlq/DksJEwXaXIh4V37uuLEf3HmnXxQdoUDnGFeD25GD/FN2cI569BpRc5UnbBipy8/iugjP/
CVLXb/tkf8AYvLsNGK2U4g8nncQq0wK6dKbKxTcbdXLaIJsECw8mSfkpWvBZPm1Af3tkTGnqVWZj
AEoeO5wTTHn37CXuxSb4GSAwokSFxBsfr5nvLKd7fIPRdZKlOW4sCYFiNAD92Yl/gWrKVuDI4BXn
m0jtZ1XO6UYyqeK4UzxX1uTV9k8RrOvDm65eFvQ6Fx4jUf24deJT3+cIXnP2qaQqQ1WowdqWyM6C
19ENAuJJzWgMnLW4mFB5Nk+NN3cdy8K/O1hSFEzyir3FCnq9TttMIoYMFey5/1vP+ReQBK07LglC
k79acwrPTsMMoeq5laBAbT3ZJanCSDcLV/oGdzEChvbcIof2K2b3k08NGKRlacyVZ68/eouBQ2jL
Gk3IEG5pdegP8Nh7uPIk52Ev9itYEdIWgLRZZ0huYj9eGBU75hMA3EWI1CYkuJCwzXXrL483M8ub
KbR6tP95ZtFvATJm45ES+jGByHwAOrHTKkkq1rLLqCYYFrMJozE00LWi56KHLi9kCR2VR63JvET4
lAnny7MJqm1dVStZMMlLv/N8XHJKYCCrEpFI+PtSrM8wvFywJqqXG2yy4AZPWuS4Iblr19JMxhMu
AXCgWGD2eI4CyU1BJqTiFg5GH71BSc8aHeMPyV/iBB8EjbTU1UDgOL/nFRaZLS9YlOIvpiVB8SPf
PWbVpJZlGXkU+1nqys4XlrcjVS9fAqPNw1vzZCzd+czIw++nOPt7x6e8Xi+7AC3INP4eO+COyElT
C9SxTxg0eP9yTfb1nxve70f6TLLG887b5FzlSnGfVYSlrWqPm1HscLBwnTSkd8lHh5ea5jLrSqAq
YH8/sRv7HN/yZSmvTYPFcMtZue4mnDLpKsQKRbGAWoReSwYn6ZbcE2eljrO8AnEqZ4hwmR807o3n
T84mzjJy5TwqEgjUCHZn01+UZYGEt5s+XbF06fS4CEIxZzTtPD6T57ml5pemKfC5S7hGvTB98oPp
SD0DNWPcP4R+FSeLTBeCqiJba9TAuLmbFag2c+vwH8VA59zlIiTpq6AZg4oGd6AMmDgvZGHMMs5F
Id3j+dFnWfB4KafbHJGmm0npZhIrn3wRP7FR0epIMjQ+pJzzG8CB3ndPzo7Q122XfTwqXqRnHSmL
O+DxXgrh3+G4nInOaTE+d2NCpXaig3nDrKIJzK0f7j1lBWPC5CnN+pliBc/WpLMUzznB582jXcBU
RFcpgb4EI7ui4eZKVnqHkdsT/PbY/yCLPZTuUJCmlt9Z3ZkgirLJStZ60+/sYjFBCkZHc/4umKvc
V0L3QYMDH8Z7c08YEZzgDUiCPiFXIPIhlrHfKABWy/uAfNr85nJGNm9CW5T24XJVbuNblolEvYxB
e7dwaAp1ITSmEnbyZi1jhYHiNqS3HkdJz57Hp4f0LZikUQmHONyt139piZCnA6YXXRdrbiBKdgpv
TWvItxYAPMaBjujnBLdyDT/1efGnHyUyrC+aNt3K/iqOFYGdRECRdjvjlZQ28uiwxcbIgwYJXCMt
WjpA/HhiEfS3UCnIOZGws7NE8p/cnQASXvSghWODKOtrUw2iVkYQ4N1rCM0bMPsCddnn+fAEcEc/
yDr0vLZTiT2VpEFQ7W2WS30DbQlvx8Tw6dXEF5lrqe3+Vq62WWvIa1hbZzHlyRMaQg2t0D3bWc4U
ZJbRdTburZKjY6H3vRE+4GSTFTwmc29Z0OAiQzGiMSp7AIDNoDIHOWN1rJXwWJthqC/0L8ljJo9e
zB+hPOgELDOMF3U6n2v3b3VBPFhk6OEIKQg2qKh5FxEctj0icEU/oJtw0VpjoJC2CT6nQRh4A2G1
aZWwybLuYYzr0budGHdYyu2Hnr2ZCgcwEDVmDOEXlrJRg39t8Y8Zj3QAXnV+VvrHTJYaNgZquw58
HakWcCg4j9d/IzvuYt15JaCGw4ghPQOtvGYZ+5k5qie4Qcyj76LE0wKq3z/jL8Dev/Jedjo8BP/Q
1+hHer7ojD7RujbvTZbDaWoKW1T9yCRfB9pE9XJTTGIjdzgP6Bp5Ur8gZX2uv3qz+Kl8svjdjZUU
Vx2mYIK9ODSREtzdz9KFdj2XzcrnsZkzxCNgEXs0mxhbxg7ISaqhJCJkdJWcv86gC0ZRtkAqQ18k
oM3av/mdi5Kij4WIV/J0ue+bo56QITTRYdCfxQzK0aM98q8ecmBBbhh7tBzsiT6PNqnaYuZ6SwuH
M08IeyU8G4pc6LwY19P1M9gPNjny4xmqaQmKG7DryyMj/sorRQg1YBVQ2tJZc8gHpGBiJ0JIs4Yn
UqImjntzcuM6dpIlR3v+cYufFgkxdgiCWuJGjta3FaHTvKD/EIsS6vy5ngntJk1EMCblItRCtG0P
6g1qd9DLC3zM19+QUgwzBkdf6f1NjUQ8Fxndcd9v9SU5ZCjCEtmbnz9SDZuun+jKuodK8mPs8y7z
plSax0CjgJ3pVSiMncggLQmXiOQBIX9y+BNlTW4Jz76JdF3ZqmDiJGFgdC9Ncu1w08GlgflsF40o
Bye+dJwJxRHoGh9dgwxFTiHB+c2dLLvMGhoPsKtr4egsoKjZZSQ21wXMvngJYmhIf715e29NehlW
5rSXn9tG9hWgR16ZKtZDoqahhxNEbOfNVDDLbc2NyJn6/iBfIbor8wn5kyKFLtHQMLOT3Wkw6Dnh
vWCTeNRcU+VcLjy9ONkJfSTPfkp4ZFZiC9DC4WwbtR2V5b/QRXEMZpWaJ+ejh6+sxrYTMWPDAeak
CVvqxX11IirifcIRl3g0150nQ2izI5IuW7zqdvtHSGAP1KzdSBVmEB9PtzdX9930Up2McQ8qGSEu
gEBCa+I+KScvmflqxEiz47pU1A6yNXqLt7Lao/1eoUJTn3mhpoF25el4B1kzeyiDA4VXvxEgZ1Nn
7SpxSLc3uQd7o9Sfm+oQiVMA7Ky64foQjwRQvRwlADvM0g0LNufPWOsd6KDG3jAcBCFUO3POtz1+
Hrryyi84SFLcrxg/Frynp9D+Zz5QXGNuXZe74Y936hBIaVKgAosYlBPbGGtiZcIxHL7gGnZZcMZz
hh9qlOwZZpllIpmVX27dCulSsdYpbNoEAkBLie6pE52hWFJ1ZUukH0VIYciMmaWpgU/VEafR5uVZ
wc4Zck3BXP/ABjraHFNEFW+9kuDlkiGBRjoxRFdYKYljlKeBIFlYT9hvNWD52/WdGZM4ZavLJGc5
vmU9Q/vx6+jJHveBjcQ8bkTmilJBskWsGTwIdwBTE1Y/ypgVibbNFugIwaNHwJATtMccFpcniimc
rYbuKaluOK1TNUSulof/Ri0o5N8hWuZcK52YMbDsTYw8+xH2nmpo099a9+9JRtJVyavyiM5hIfIp
Nzoq9/0trTh+PKACT4imyuLixWzOR8dNbbFI7+n6zt0KpVZlIa+jh6FoTW8RVGAXiu5vF3FxzMd+
ZJdD3OA6y2KjWX/W36F8L+L7HAtOeblanLCarntwso1xoDlMHlbMEZbI1zX6i7RhChXezY58P4eA
pHJkvugWAvvzOFNdXyaGeZkpAO1er5dh8UZ+8LRaYaSeLHy201d33krn6GGRkUU0nxcGX1JrgIKg
JZg0NI+UhGP53CWC7+cHPd9IC4kHzAvI4S4qSkhW9BDp4omnPufqmHR5gOYsGwT9z3nlRtzK1Xkm
tfDMj+ATISYUZ2yeeK3jCHBm5DWU44+JsS4qfDSxdt8y+aPq2rFBTJz5o+bKHlBMlzpKEcT2OO0E
LJn1WjsNffS2HBsWU8vDPyyfcjlniFA8RONV61aIfRSW1Jup7FwJb7DL44MaZjC8wyAzFHaO0W5V
477XfduHNL3cCH5yuSj4N5SHHWbr/+Nh9gBHFZmvHAiLf9WiJ1YpKpXWL6q9OMiQc+LoSyWLL8z0
gMSesditizgFFv9zkq8+YG6HuPwbk5vo4+9gG9oHDiezojxi2ekIW8XK7+00r2gmdmlWLgemUZiC
6WMFHkzl5ejb9JshCFaEu3Uk06nBqlxLU5br+JZHZGiaD+FLZ7vPmBVtNuYAvBvpCN+63qzp2h7N
27504PIV/NdKo5PKCMd9jX/e7TUvONQPICwq0fu1EDe4YTQSKGE9kZ+p3HD/KWJFzuGOn6FK+oWx
Ka4eS6fRHYbeROY9AbAiScRiJqZV7q6UkxRL3Z9p2hVRPUQ8wtASL8hkSqG8stdlNAuoH9NGDXlW
wGOAg3LPwshdWsmHnDhBkdDTNbHkrYhpCOoQ00VvcSgAMD80msS8gvdPqyI0qdvb2R9SL1y2C+31
9XaW9i0ySpPsjfEb0QPw3TgGPKNeySrviLgdsqFI04tuytZmFLqTgkGVdVFmQX/YPM0i4NjyAFwc
nXgohHnrR7+gxQMr5tWrmEu5DgWFmJyav12Jj6xCfzVyUQfVtV5CUijPtqA3aN6KIy/5LiuxWB2E
1niO226Q0tKQQq47zP2LHLnJnHptXzYcps6CTAkUZjNJ1LmY2NaU9szuXV7YIu2uMJyQkg8IIydq
EbSXDe5th+IuJUCnboEb6lLgpaWfvBRFDgZdR9yzrx3psgCpybghsTdAAlCXz1xatxhhT1BYoOYq
GtakFCZgkhQn5wEr3Q+YuwW8eqad77F1hXEX6FZqwGRnmfmASzt3E5yGKkmo/4uGXEhyyWNmzNNE
yVJpCy61Mqc64VsPpR7da1NltwpgaoGfgCMJOZlMVl78MuvRc8bgSraYJHalDKmUsiXYt2Lspn77
NmKfuL0EZmQ7vi+g+XpJpIBkZZ08oRat/AHRe+HMDGbCDSZaAmb9hnjrRHFPbndX/LMoP7xswUW8
lDvDnuIrFMl2cy0mrIP+mCkAV/Dy/ttcOKu+msOD8TXVTol8TKLPp9q1LOLHQ/OYZhZkSl1mI73b
HHGi/hlCWvB9vPDODZhZ2JtfgBG+Z7k/obgtlpsxR1QMiS1zwITjCaBBaIRjRFIzQ/Ep9evb99Mu
UF0WBLRrCvWL7NS/dSK451GrZ/72aSl2unY7Q3a1A5CNXNaehzdE1pEr91zlrJyi8xtjS4PDsUlE
j9VTFz2GlK35pnyE9bEZFd0YZqXGOS/w6gsKDvI8scZuC3nSL61nrxDLqN3mTosD/ePi2/qB4MUJ
DagcpTFNDrek714bJFFyri2bip2Cl5dNxDLdINJx+Gpu2kgnN0VqTAENxsWOa+SCkQGjkMriA1dI
rv+E+/hv16jktSu85IN6uAkPEUZ1jmrqC0SU61mcoEuXRXu7Mpyx5PFf04wAwzpgQNZl8t4lMcdK
AtyvbjjAr8IlYs+yG4bs3MwnyUvctniOOrkjLmQFzGp/3gtsIg3TLlT1TW6A6qyaUZvdZrV+bQEn
fmVWFvbid12TTYJSjHqr8fv95lLHVpraDo0k7dSvqsfmyYzLV2QmN00NOZa0cwHLilw6XJWx7rfk
4DmrdcI8mrFnCKFGuta0093d8bzCxCOJiu8FW+vMYAVf71qQltvGNlW8mknhtAw93jA0Oh1OX2im
o+53OjwBLlVUb+zARyiU/418q2rnZZiBNEaEa2J2dajwYkUjSwDEpaJhO6cLdKKcFuywbQd1ySbT
0njpRLJsSyi6IYhq8NW9ackqXxDSIoHs7TRMQ55tsTrdMd1UaLIOT4N/YKNzHL1czeGS+i0JnCi2
3i/pOw2Rral4eRYdc10wdpazoUpDkad6DCPQjaWE58V+vkYZK+Aic6QLpoQ7xFVwCDUSJlkSp8z6
EAxgpVD3una74xc9m84kvwDzX+1vf8N5AEV0g522uWo8S6Ooy3X1gbEvCAPQdIc/fA7zEcTapMl8
FYNhF959autmfkPsx4e9zC/0oXpzsduwIiYPrrvvJf3bYwN/Q/njQsk9gwhrmqauvpKiy6e0oT8f
BCUOH4/TCevvbwKwqg2U+gk7p9Z6lNzRzbfKonOjOnuhpc4e/9MM+jsNrSOpimGk2Tu22b7gDWsF
9XNmNAphMSuxRy9ihCBlgn9HUqoAgjDl1X8XdfzvgVweUQhn5kY1ODFUpyHNppelvm/m+40sX0/d
E/EwNxAv7j+9qGqaof4o7wM7lUrSolO1hMmqVjbTJ4Fl1xFOZFQ20esG61mPswbHAfVsdlfv0VI4
duR63ttk9jprWLW4fi1UUSkyYcdBAqyIJYABFydQ5Lj3wJ8UvQGBRnpP4DAswUY0c/WYwEKl45kh
e2cqyBb9kmI4/27SlZBAghbVrghVuSJteoMJppBR2UswdDScaATNVeLZzppdkV4OOt89G6ih/3Om
Afwe9broUqcUB4q8FYKrG1E9zzdtZ/ifSN3GIp9+vnrJ7uXrCbU8ijMoEZELzGQvtRe+p/700vLq
gtlrLREuwmdUmOPfPlYbdVzaLwQgLpus/z4HpjqLvw+FAjbQfJoNBpRAnfDg6Y18gVJyTw5uYsHc
fUhW2d5Kn1KFlW4saehwp0GA4xj4aqvG6cqdSDXzHPsaP2yMZHaV6vxssMwKLtN/cjoVAqQtMlhX
tx/ctUO8nmlpEDxjAQjjMO0DDrD0YY3TT9O1ieqVv3myHAv0gjvJPO/rgQBY1Z/5cfi34xoK7FRQ
zV6sLUIyVyZB1XCNdEN32B7I5oGvjXKxL+eWp0dnw+bsSEL1TsRxXTriQ6F+fKqhkWY2zjBYfVbD
ntbwfgbvF7y4IKyt6GuolLqfAY8SwU1qRDMn8UlGnPrqrjUCu43+iH0LxL8jx3/On6oRSfNUDqZD
SN7pGNg7nJRlWap8JZC3CYaYumudzzGuplCoU+OeaxoA5IOgqeATFV7H/6YvC9vifw2j7e5uICuS
Qo+ZFPsPFZTxUsypim7xaG40muuaYNTyWFZ4xvsPq1NtDfvwY5ido8RqutJr1QUkQH12Tj3mH1T0
Blf0bsIZfP/L8yG/GLsmBOQBZKTXXypevkotjx8DeXdCa27k2kr/YfpWWy0lPjYSHSafLjHZhjcj
D0r9vZHP0CeIbRV8tNWNV+38EpmlMlQEL9NJ3YI0liJLvnOgdnjNldo2q5WCF7FxtUh99O1HidNr
HzwktT3qdwc9qRvjq9gZ9rvi1Ga8DikhEGTLH20WAmRqMPsryHvHlRhrD9Lx27BharQXuo+Gx5nA
5OM+vPfCQ75HzNoE98pHt9qdSrX2R5ZzMYQxWSSTjEvcUaZuy8AZOvfWgslovCimwG7vZzrlcbrm
RVoCulnk2CrCoWkwDeu7n3DP6Wmw/uQXiQ8+nR5MvpjMRQyOmz1GaJDR5gJiXQxFgPrrqfhx1W4r
zgAlHy6k9fr0z3XBfPigSeaZ1Vg3+vdstD/r5F+dvQUVrPsKO3MhrwvCjT9HGmlAOMUmrryVIItg
0LCYEAvXMjRIo1nzoi/sjAf7TBc8/2dxmjgz2o1XjnsrojdcigG9JBx21g/pIgHyIQhyVLvtiDSn
AP/+nATlo9PfjIsxP+czRxzTIe20/bUxDvA70VZDbMvnT4cy8LRrc1C5tV4DJXVjYhDqYi/5E3UX
RhxsHwp2RVBOgIbJg7gfHPY/gnWBxwV2iYx16q23ufqKREyRRtny+X6XuxSLivfvEG6Ux5WwT0FS
+qPXmssYo7khAZlhKYY/G9df/pzHaRFJKy+ex2LIDGkiDgF9GTfSkeqEHkNSE2GFfFhiOsvrPJMv
tmLC8gAH8eqmnHnRl46yqkHYkdfKTu3IDDqPCGxOAc9rxouYPWeJDK3y9s2gyErRXjh9ZWN7/U9y
LH2bhOBSWEMROIYg36Nu8AmP3XFlRc3eateQ5F55gzHjGJ+mdPqwSbEbxHGPWPabUEOfiOHV3exn
451Sa+99WvWXI9E1WgZif0qIExOEf1oVga7Gy9n68K9IyDPs/waGw3sRZtxo3AYC3KECy0nkSPC6
QQQ5lorpMDRjztAmMidLdi1kJhx2nTnAmSjgNWu3k44/jBi9XxxnFImC6lzLRJQT2JXvBlxbZgtg
DVr0M+mqLNMSQJphdlXdCUsbkax+dYRdhd1n4BQHTeAbQVye9I1BBRPaQi5d6VHJeqhZbAkSyv/o
9ma/DmwxNgpIZM4CegrryarslA6Xekg0WraxtYedhMPzIDXj0eL2+vTpQbI148XlX2HS+JczPp3+
adfhP7v5y+aFMZXdjuqlNiWWqITOynocNvJrzcCQ4EygDe9mUmRaHCovOJhRA/pv8mL3oUIczs4d
eujs1eNZ/XaQNynz3idn7xICDm/+yp1EiIsZBJBUSuX4mUDaeIYtKwBwm1a/DX+hrhVMfFwqCuxr
pSWRGfNBPmezT8VDNguFz8y+H9JjglLDG9M3tScbV955g/nlrW9b7FkBoXv12nMMnxJo4nl4mvHI
DkAEjouW/nOo/90cKNEGU/Kagw9+cUSmJ/qEPEKMhk/YdWKnJs8dTerPat93PEVUJwCwwxh97PmF
Cq+0EnJ9H5rU6q5LIseO7St5tVllp98lLQzsplasR6TpfynbRLMHZt4qcHqzidbaYuOuw1Z3Xutd
WXU1FhW+lTeoYVDnhD3hAD/iCgXJ4ONrDEl5bWkL/ZRMh32MZJdVFYM6KaZI4wkuA68dJWXV24io
zC+0BEY61E9Havb+o/1DUVsMbUjYzbVDrdsje9clJtn08uD2akJguuFVfxdaUsNBgk/zXMu0B7Sc
sFhzoYqnoumHC+lumuFhdCiWD6CuULnFb3nJF10SmO8LwPCZuFJFQKdVCZxpC1VAEL4QrnQCEGdI
MBAiFHzs6qwgEVmV2mz5DgbB7PTbt47VrIeeSjLJoU6Ya/3HUIcjQwjBBYEjD6yy8j6cOjSpkQNR
C1M1Of3CsWWHmfuLJVnU4AmQCuGzypTqUL68ilOnbqWq3zq+B70drg5ucrMk7pZ+jg9xmC2aVMVr
qvrxTyR6RDnFYqyEchybfKCh1BuHHQ8b2YJi/2c4/W7ZtWykyMlFkxLqfHC1fDWeGCDhuTUAY8B+
IQw06uYgkvV8oIbwKLrHl5x82FfaxrZy2UDslD8RjtPUCdsDadaNEe3x8/ofUgln2m0Em8/JtZeZ
d1gtwYwBx1qszIysbXv1E6EILycZ2VdhChzPaBTg7lRMK0LaaUfbZSHiMU8opiVjUe+sHUC44r6o
3wNZeT7g7a12N18cm2p6fHlmCjQg3RSFF+5gmTmMKkWC9YM8KApLm6BxzawYpKWJCdA/TNNbMkPZ
Pznvago2LcaPtd3S2k0CHttHOU+qFqiiOR8euD6t1WBlwI1+zaRCA9muG+4hlakILN9vaN/bFge4
s/2C31woJ13QFnti6Nl8b2brtxa/kaX2jpx0hqU9pkLou0+EGlVdjZob3YukeNuiqwlJXwDXNfUv
ZM+wteoYbRHLnG4i8goIQmWx91+gMSLjBqw2/q92O7enpJsTu6EHdmoEjoFDksBsgxYPePja5i8G
1iqrMLdCHDbic3AcWp6edQlJAoEaasGNlnyEkw/7UoQ5tkRsorljoMO7HAi+CX8HZhriR5VhWE4G
KGpogYQEi8deROUOmXE5oM77f1etpDrMLGbhDrgTVEOAXooxqp+V1CO/YwvW09n/RIFeay1dn2ND
cRiz8hMY3DfQqDux5lRRh10gALoszQxXBDOD8wO0TC6oHfwpKJ9H0x+jkqttgoDnTAoGkqkNCUCy
xL95tHeg03z00cW4WYsL44pwFfqWC6EegoERkZq6hXRWWsJ3w8VAQmpcsHE/KjqUUjOBmNWNkYcY
Tx0f+kFKcnbwke0mfO4Je1g78wsj7NnbBgExo5TEi35VttDHkVc6I/S8baQ65esTuAnW2+sBCasv
Gur3Mln9YCw0dnTW2oHc0vJISirPkKtVyGUdqv/ovWS2ERlAJfBxcvDRdxpO8nwRFJggsqKxbT/+
iogVvmcFrhZlmxVN0AOM9nq5qT5ZLHCCIJ1bX8WU6XX6VwE3EoR+Hatxu7ZJ5Mpm3+jzXYiOJhPY
mwtSU0qp0An4o4IBCgy+A5oCBh5CLwprTTXGIM76xBTo/iZP3K9HdnkrCQU+SaEhZXNqu+XMJeRp
YJ4empdmj5cHeTrcWYzSRHHNsSbN+k5qcwwa5DOlkYfPmtUGrPNAf8KGjx1D5reobaqNX2sPvMj8
UOaYvABp0Y7X3EV+uCo7Earx+4em9oLFVKbbB31ZK7BZXvyyIK2e334r+UJjrJ4De6L7nnmD8m0x
EBfvnhPlZxZKb37adBF6eoYLPsYRU6tl92TxELzbEAMdUoxLbPB9vENZif02+DIgnABXW/09cPVO
uDIZ3QO4lGcYM3waeBjHmCwjWzVWlLzzil7usEoiz1HOzyi5zyH4BEcntMnqzg95YETXCqUFUERX
jz2480+0jbhCbI/PdLlWf9JtIS2gi5L44BOOPfB42vg6WpOJR6VmjaGPSltAnv4m/kj20L4sm7Zf
I115WZXNvN3yelWDrfoi6vBIoynJp6ta1bZqWoEDLfKWWCtyHgEt/rmfRt9MjWqfuFIXN3Izbe3N
xA5a6W+IxXWW/aBKD1BRniyglY+WC44wfD52CGzVeXBhkffq0BRlUFhrGSivpsDOr7iimiSpOJde
nn/XU9PUg9vX801wnI9iJB1RbAIG1HiuzN6qidJ7jPUMOsPR5hj4tBpGWnjukalyRiPmpS9eclLm
5vXxlAgJ0By+h/YlkMgXj/mL+LP2IaDL0zpYz+FgeZKzwYkzyC9DbFK/3wUHnFLFs4veywm+M/L6
lRWmryC+Ho05DivHQwqgbgme0e+g5SMZKZo9PqhLfRagKzPfiq6fnnbcGCzM8C0ILKRCMhnQCI8U
ROUEyGYEolC3Rfwxw66cSpEhNKCTb6NjWnXR0d3gx0DmiF+4CqUtv7+w+Op2mNXTsF+c9zwOK+aW
6jpFByyw+P672YebX9uDtTjzV5LHlBnzkb7omOE3P7Z4i8XD1QA3Ct5WFZUiyi/kzaCl+9W1gtah
f/AfUdVgDvGjHn1YCs3bj4i50+ECaD4fFTe3EdsIbmqkFtynb6X/N2dcmJD5IPCi4Otg9veK+BVX
0s5iJz+pSGL9JH3ePtHS0/f9XAVYr8WdmAMoazzKO0G96yLmo32yaBo0EMvY4lGbKitkI/0E5qLN
YguXghLxPBrL4J7CcEeRn5Q6AV92xKxWyAz8hh0YNjs2fJl+ZdZacZZ04VE5WlWIMjMrJajMhBcX
TzGW0lJ/VSrJJRh2mdtGJJBJqcN15Y6ii3YqDsQfEAbq62X+iZ88NF3+ad8bRNfxeCIz7XolRxMD
OPI7HSexZX4IFL3IDe2cLUn47TAQ0PvCa9EAjRyVwUvBsofBtSUOiRez7GnSJcKKaL4MOPk0ivu0
diNBUtzj7uG+xvkZgzsJkyaBAmL+Xq0vYRZ5FFq6micFpm5XtoKxCHsnTVSX7G7dLM7HbvPs3E1O
xV58EyvEEU2ytaZQiG7cS2Eb+Lx85qrpA0ipJGIlbHjBWWf6mkQ+a7fKL31eqpGz7c/i4Isygvqf
9tNha3fNW1VmPVc92KSa2hHwPI6qErRKx6F+HoXXyrsRTBDQuF/n1TFYtF0EAfsFQPz77P/sVM3Y
CMW0F0QNHLDYzWWKJmXb/LhQ4hi37BdJqsYJmlr0LVjRqnh5WGg7wbud1B6dvSICX5pEgCeHzyKk
KrSRulmvJz12sX6wvSL0kjafykWTynGp7bn5Kpe6PFxWwX6xJRUAqZ9Ka/oRnebt8SESbqhmCHPD
7AO5jxdV4NYBcBlG8vontuO/zpnesowlmSm4XktwEKI0v+M7DSSwaAhbwOtYCPy7bMjO67g8gGBS
Lhk8khCgcAf8zKtOomrlOKl5p3jUymtHSDOBkE73d64KL4HcASo7oI3u0j1ZZW0C95yX4Mmocs27
Rwqyv3ujrgKHIdBWhn3mXHH+qh3bbEZ3lPnlDJzqnFQiJSsTGy5wS9sKsp4TWklsXpaBX3v6kdBv
AAr4ZBjqhA+x9ZFqkngGiLC+3fMFV/q59VZqJBYLdyt+rYz83xo23wLydv+7ruVbyaZ9ZyWRp2lp
k5tDU6FQzmuTQ1TZTlHXuwlOaXqx6Rl1V+i4DJqY3qaCUCDPkosDm/JKG8DITQ1suLxMVUwANJL5
T4EY2/vOdUCYelrCNtP6EW6d5Cn/lP/wI20o6k/MzJzJBtN2BNTQNSdiaLB04MLXwvR7fNBZlrgp
h+MWe44s7Fv9hiU7cjpfAar/YWiHLv/dnasLFsMZnmKl4G9B15blBwgw+nUf70o3IPzbjZ4DYdVC
qrtg3cjf+nEThvOtMItfvHJb1mCVwbh2/oEXF6PGUhxLpLf1u6UUXUqpaOn4xejOcJIXEjiEKVFa
hSTrxq4S6m+/EmeCL5ymH1U2eFBseiAmePM2N1jmUxA/+dtTEoLUtolfl2dLV4Ud/HsCwOT6N8dm
B11naVlNcfGpcSziObpXPZXe+iCF1nhZR/ODne5Deb4TrSGy5j8AXUHxB5awJsIQZXHS2P5KEi+N
Eg/Qtvr11IVMQxpqw44PFA3s9HuE9DcaeVb2geWv0MG+AMgtVx1JlemPzspOGf5ptKB2kbq5xkY0
z7V8/LGVF/u8yxRwlmIPq6UZnV0Zr17sVXXkyIJpcI0Q03bvYL3J5fL4N2GBaMvi2qzrP2u8EvpF
Myuz/HLTfYj0mcvp2VEQ0eAOUBtc3LJqn2Cd16jMB3CAIXANOgUzBPHyCbx40gpOqvmmkr5HmjL5
Hclsqun2vkGKY1IOM7B+OdHsBARjBHXXf23qmBJAN8MYJMsyCyEK3WoV1piHU8HDNHta2dhQdRHt
nd09U1bXw2Jba5WjQkhOvN3BQ91gOpAShjgW1ie9XoLa2aUQJVQm7oRU/YpBundEGV0wF8Z96JLc
o+tQtv1d7d4MjoUWg0ddtytL4f4q0CpCg9T6RCnMxAj+462bTD/y8cAlk3/3RYv9tJo+QW6KpaIH
qgH8kZlTix7gdpTWvpkIf2CGdbtR8repZGQu9rmDpkUPuDQO8PboRZn62gWaZjaqxnssy9LRF/JN
J+x3zmujKpTf6UiSa6NHFk/uH7QPBBmfssvxZAGMtan/uZlrChFCAen3gAt6M6/RE3rYqFC288HP
hlazWOoHBzYa4QsuxruDf4nD1fQlHDoBHX3rtaysgq4N9ohcA2KwJB6hHIz1tS73avFCmZ8I7Key
wbia0oKb0MifKswzuyN2mMRWX9wT7Uz6IQTj/Z2ZCfRzy37/h+n0TjU0mBTKdxu1FBRFEJ/m2c+B
z7qD4rD3cgR2rlMn9Oeq2OPU6kWAnpWFYIKn6LUpTRFLMzOI+YLNsOK2rk03vKG5g7YAJf2h7sbH
YZv8/qrpZocarvuX9oR8wMjcAJDT2Wv2Iuf58zJ/1vmEZheHainDzObyYqbtMh1JYvnXvf92APJ6
K8i9GBfqzE78yPd0Nv8yA4dpWNULLALfPrLDl0ljuzWPXSJQXWJ4pl8GoDlsHW8fRzwnueip8dYd
D10CO3hkRZv2Zh96S4/i17QDRzf0M9b+aYs7Ae5Zf5810VWV33++aCyitzvcRdJ9vuO9Sg9w9qs8
lMJpUZDBWUyimVwkRRr+ksqpAQf5ieyXhA9PzPhtnNfLEm+ggS/Q6vvgs4RZn/K7331MwdKAG23z
QXozLdRcp8F9tM6NHnfSwGA9zQ095kYnQvP0aEkm/rxYqotmxc9+pNtQ4MQgpA6n7aqdI+faav+y
wFtRnPOj8q4KVOyJyTjFt/to5NGdRl9640SeLnDeNEvkxVw7kNU898gbSZLrHPO7L57c2anpwr/w
295LkngwzOPxai77l1Qsa9HkPrilTDjOi1HnM//IUw6HFZ4DnT79f78k3SbXu7DJzFalHIJxGqkO
S5zG67KjPVrpCq5cVo5uzHkIqzf7IEpyyyxWnz0PyfAuJG0mlG2Kqq9MKEBctQN1VpamKLTCLEey
WMxt6Oob9GAqoJips6XYH1B7fBn0Jsh5EqzgLnGsXjB4WzvPMu5bI1FWsirtZg6/s78rw5UrCQQu
g/DJV+wg9P4sZumpi1HecP1Arhgg/4MEf6FTriU4b2dBcc8rBa2VemuZ2Prt8+IW7Zo6nQ/SkPUG
yMYcYYn1p8wcU0f9l14RMWw67pk/2ftchx9WJJ+lAnhmWxxE5dtan1jNsxp6JH23EBWnaOg2GkaX
unnlwAwAg9DW7jpnvlD+Qszta4FhhdMOSi8RhufVrt51ergf5Tq+6Ud7qrFPNIZ1XxcUXLfcNg5K
RJL5n+IXoWkilr6h+dW/UNELqB1CLe0H9JmlDr7GPRQ/QIicQALyWoeqgm+rdeL8KZWinp4vTe7L
SIoUoaYxfWZVGU3h2wV9jx7zbFcem8/fMNV14CCyX55+4vU28BYIH+YwjpWL3NEWWzUn0HbSJMnh
Dq6Zom6uEBuoCludE28O7O67VnBF0SVRHe3wLQ5CpMgsUW19Yba+8Nvh+CqT6NVTN6gVHMBAk5A8
SJgq90ooN/MoIQGHZAwJ9+/EpBKo9NCe3BQOsjiq+Ix2f0n9ScySkDfSSZb3J5oRq4b1SulSeqOE
aoK+aI51r9oze2bDb6VLmLB6qeuMpwMLec3Z0qDmlBqElzrR5MNE+Vf9I5cWM8qLbnwbch+8mcH6
Jq08MFdHVdatOHTSddYFzNhfa+Vzt0qHfDKu0jjqwB5LCXuVVuJ8MnpI8ngO0z13OG+cH22lS8IZ
ZYBVHcs1kFQWDnkWBxBzJOSU3E3KnX/Rl7GIZNkQZdG9Hg05Lf8NRaY4Q+rLWJPoUgmjvwBTERcf
vhn4CQjYSCJZ1WAMF8fwH1G5uqkO4jH1X3Plzbr249xSlbbNyk4bC+g3sLl/KI1p5GJU5LYIAmdb
x5Lrc1H052j+67BZs7wB9XyoaM9lAvnrHWTuKzpj0EjqdqmHliyAFINaG346oRhdMbhqpB0+Jpj9
adKJtONOCMKrRdTw5W6R4AiLv9mHhPTHASEZe0G+5uEtVut/z7N2t1diDeHv7ePXfHNP+FKyUsaG
nnrvkmkQlIiQ4x3cZUIHGMaIs6mWR6zLWRiannLmKwTSZPduy5LXH1KWNV6R5wIZ13oQTQ+YvGT1
t89m25ILIEPVwvta4dZRPa6E6Uyr9psSDtK3SC7Q9WKlBguTur+j3mAx1T7SmAVnI0l9zcQFAs3F
sxx689lkMlYFFv9rIGGUcIGaszJ5YRLfZO/SJH7WGgfWoWVcthf3N7StutqHMQf9t0QBZc1iC+jQ
KS+n6kMeq6Wktf63kIE87Ds0sHPwLDnSbMS1inZic7Dkhia6D8g+Ol/EbGE8Umm8jLaAoBZCCC00
JG/qWMgOwjTs5I8sMqljY+unkBaAE8SMyY39y3AKKCRDN4kxTFLq+3pS3Grn1Ky8PqNm+TaDOcK2
zCX3pQKPdHdRSQhn8ZrZ4ikemtJJO9fwLPLWwCBR/Xh0Tg0BC1N4M3lmYutQjkpQTbfZvG6WYQGo
mpNIm66P3wGJdPBN66G0xGnkxnECDF/jFd0UBloK9wiX2e5GjTCpUXpx4NmaOsrPiG5G+ykOZPCX
yJFJHRPRZjdluiwegrUlxq/d8Z9uEo5BB663zxmvkgGMLJhy42dHswYFlY6LhQx16oHRKRARe/c2
TycPduM+o1GsibRTmAZrm+JSRUYCT3zPeLuXiy40FgdrW85vbzKWptxG3FUmK9oMRYDWl+3AD0Qi
jLEiGlAMSyceGi197E0mT1iDgX0pFNnc5QUMw0CpWTGTvhfiFFxbq8VUnMw434XbDjcTwpny/jP0
4meoZzUbZj8C6lC/xOcf5n94+2RN9dDcfr2V6WqUp55vV9mv5jbGlfT6j51CWvlA+m+hu0eLm6Nq
a4UFFij5Mz6aPI24R6MHdy+cLsXGQVxSzPgvjtv/obcgOP+AGhNC2+eA3z6fbXjuMrOuFLe86if4
sPCIE2RHVF5NicE18XI0A13SCV2hgvLQ7IY1DwzIqnhSLzOU5Y3/amxCsntH4QeP9q+3wNZwh3OV
cpu4K8Fp+zOh/CWfDPxATc2tpUjtyzlubjZSsEX0ZQuTsQpAmK4uqIulGtlwxcJ3/cXfyF9BllnW
+p6opwtpJ+LNmQisw0h8NPt+YS4S/WPPtONdRwPOjdj1rplNFdwGH///1W+krJafCDA4KecHKlgd
+GEF1+xEqdcajWJSsoHS7sG3aE5BBtAoxKrktLP2FJMn+QFNB9dempfmY31jXx0PrXI0KdvLuo0I
0UELFPuw9vZ7SbWTKSvNdL54oZUY7MYvJFrDhy6tcsmOalLK4df2Cl3iec19LQ9mtMl1fdNeIlcV
f9gwZQ/kKY6+WrR5iLHsaO7dueIEkEobtBgPLwITAFDInZRdJncYWDw2a9gcH44D0sJYxuHOhSsX
/jUYIHJc7EYvxqAbz+8cuRrqA/woX9AOm2+xWUsviB3eLnqIYtNbFnS7Dka25UKFLPXSip00Mbe5
FFC9iA7A9Ma59lPj+yeBL5ULTUR7LZc91x0mJfS4yK/VAO7ZRA6t4CBEM6jhmSYA8KT4FOD02lpk
7DCqQyGTKDuecOUsURbxjajU+/0g5jOrVwltNONd5lNJUIif4VMtV7NWFBYyqQ4bmRcRH/bdc5SK
G/RLdq8d3FsVND7cs2JCC12cnGiWNrlNT2+FptxN7mOsKXerpzs/s0GuavqDEK2hWPjX0SrtIYv8
vSX/FjJDZ7sbzUTea69bzbxkKqpCiUqjXKUDHCDMb3bpVebWWCaHvP+C7cm7TSc2anuimp99Eu4Z
Prngiyazcfy79ygq5y2nTQColMiHBdmWyLO19mv3xRaJsHq0DBjIYGys2spHVS3s13V5eHPVX2dS
8cec35sn8OGVkR6x9zKNNCn4Q3HcUxdwDAZ6aYpkaIeVAe/uvjRV2IQtfd783VBuxh5QgTF17n/7
kE8qYKZ6aUVZaAET4PDw/d2hEJxTcToh0+GPHFaDt4J5/CQA36MUxrNRh1UXZbCs/h3LzVrBd+K+
phoXYVHV8YyNue3/JXACXj/eDG5GhlMe5dHqOoDS73mk1G5hQsHXjFDzFUXuCEJy2uB/fYd6UrS9
ShnSXBx90dj377hjabkOmGCkqP115s9N1ljUI9tTYvT4M6GQY+ry0kj2Wxlc5kPISTXEx5iQEZ83
CxNTAyZc5F1RVoJfvFJOufA7LQfq5sStDxr+ieIXKfBZB8aEokRpnVbdL04b0HWqyjLG9tQ1c6MX
hO3HgTqERKfS09SJUv1e3Q8Ar8KbYKJ96y8YHSwG53qP5excjCn/Wnt3Q6CTLOcdC14MtBZHC37U
weha112NrtjqZus5EAZHdWZz5KF3K1n8Ncf4utOBC6JyzoncCtNjfsUPCRtfmrBLG7tFKNnAyQYc
C0Sv9oflKxlEnkmTXHUFzaa054ptsMQu/FOEC0h7WUnnFUpCPI/Z9BiRyo/zidv8L46luaDGWrms
qqGvx41bW07hKlHyT7uT6RaOgI3Mz7JwPlV84pyJkUcbC0K5CKJsuRrlZ/7/nYEjQoekCGoaYbwi
OZo+wZTcD0O/fCERVGKRgHes9XnQ4LN+zL/HFlWxwaggc5IkQkNf2zmof2qbpF5ZMcbV457Bgaxn
ZvIyxqaUp8SM7NPM2C/vIUxz9IyDLL0PLnLEeIHA2jPYvVcSeF1ITiLSOZ35iwR6mj+yBWLP59dR
a/n1hrJ0aJ8vWxNcN03zeyjpdXfBaEqEoVV4bJyTeU3MvraJXXGyWFG4O5M9bWWkiNzZt4mc4HDk
bJWNk/7NxtOlaiuEKbtxx1nKuuq3nYu/la1Mm+HCr4v0a2uPWmlQlBVoM5P5d4hXfL7nU3oPKPN4
fks957QjgriGEAD5LWMOPl0gKZGZ1wUuFh7SRcPK3YMK7ZBKrbQzOOoVWwVlpZicjqibR7Fhpjao
S0UT9GV4Cu5+A10tZngUOOxTQFBGrknwCrKwq3qXiwtqDGvj0gYOLBJ366wL+3Y7GZVUOhoMGnCn
xTZylfEJKdCarIURCQaAKwnl54JO0ievfigMXyB0PQtP3H6S8HRljHzqSSPYceiCbZqtMW0pIzJK
isQLmiqJdHqyFlrlqdOJmifDDo3JS1djOnKw0Ua/SaIjWhlNvhE9N42HwMT/W9FAWGBAbH5CnNGz
y7aHtUZXTaXZF0uE7h2+EAgTO0hszop7F24I/qswzfTCUTRXOCnZPgi6yR2xCMeu7utrt/UNi/eY
TmDanuzSJG8CYxrLby6dd5D35gJWkjx6yofhYp1JQ2daGswvCbcT/LDdPhXndCeGl+/4k91kraHC
ORwhd+TkJGAbBCRw5vx464iv8AG8eUvhqrYBHt1MxsHKqXkkfMyv0zGW0zoOPuaYkdlJ591Ve4GB
IFZI18C84D/PR6fC4x+zIjauCMtYdzidSsU+km3Cxf3BZZXcjKkL9C1A8YbuXtq6kdDlgITzdtCa
irZzKoIZ8WIAaPNqOsilNFPA79Smrz199APB2W4JJqSossiNIntlqF4CY6V4QP3z0Z/hA6nLT+2e
oo7tTqMN8ye98SE98rj5uu/CpzCXkCwWW4euZg+3O4I/CAQhIkB4pAcCu0LnxvXXSJAr3UEPnBV4
b4WHAFHCn+DSxZDLHpCHZznFBgAsuviR/5SqpfCJSo8C1cP79Mmj/+GwDQsjc4ZtME+0ARRHQdst
KPtUc2gYx+gqZkS67qFQH9xdPb+AbpepFpWxNBsyTIvEOh9G4jUX2r0UA5DtlGAEb2Z40S3jG4Y6
AurwVaFirvBvbt4FgW9FjiSHyRv3ILZg7MrBaijtLHCWhCb9AS8aUR+D7m8MYLjjASoltZdhDSS4
KqxcDo3hWmj3s1bzkaGEap24qefEK7J3RofxJzQdO50E1/DHHTRydpuXY81v+5MRuOYWu+BH4lNV
f4pjyloLf9v0PCrsHxWCLYLSmjeNojIyQWqFUVN8pHS3SxOsOhj5W/voWMTNkZuQ7EO7Fxr2yvK/
Gr/4UfungTKfoUbDrvSKbDruOIGSQ1QC4lJk53oV6vY8kGiJwgLoDsiZB/kOx66Sn0gPJIfzYoUK
pHfBPZ1h5lw/agUceRYVthZNsX4gE9Jtt8Ly6cgtlazwdDzOdkebiHoH6klLItWMopHLZAofSdpI
JzTr4DLIVE85DzBkX/vOXZ0MA1nCGPbuwPtu7ouECwC5KrfitSOCYux54pZscfoYpf8WARubMmpa
KI4IdiePBWUl1lMTL1GK42+8mT/oePgUFkIfVHu6uXrcdX6C3zfNcF6OcTGArjaypaPekgddGE67
qP3wS5+3oPHLxU33WTkXcmsK7eQVDoekAMto7Y9idg/CfH1yon+kIAwGP02UMlww9gyuS8ZBjUU3
+KIKk/jp44h2deWsQPnQPX9uhxmt5QDbKwoTCCEdMzz63SGc6/5fDIqE5AGzsW7oWsgZ87uOj11G
l72IxDEniWssX7mepztUjKtV7lHD04vWn0l0t6+B6hozJ6KQFCxJb7cOelTLdJBodKtT9LmBDLdZ
tKhHyKmtxnfl6Rc0eheuH0g4SNnODcvNWpn0HQvDSwLPw0Sn5Y25rRFxDQMEPZbXnOuK8MJhiIRo
jDsl1/2U7e5b+HSCP4kxuW3KcX4wmTJ168vi4o94MMCjN2s/nVNysQDUMI5LDb0+/oZ53aisfWfx
ePW7yJJbE9t6gO9AIusDaOxbtcOefmzpgEkz3ZaQ4t/sCSl7ZaIT8SoO/P1jd+BWdPuntzu/qNtH
YIzvtB8v/lKy4JJi+++dnE0HYv6GEoZ5e3LlLvC0GqMY0ylZ1HvD3kzzFQSJNK1oyo7JHZ5jqJal
NF3TqeLFXjBMPwBvioGPEqlJRwiur+fImWTy7VKmJlFmFXa0ehA2zKE3WIZPMLDDlsrKsdwzWmZ+
VnUOR0h8f0saylgbDP7MLGadGTP81LxMgT6Y+remNoQvOSk2Yeefu3oTGwVE+AOIK259VlmIV4DK
kb/qK6CKXYe1ZMtD68YWnE3+eRxs1FG0IGoFBzvVxvgFggMRGH05hKCPVxT+njF7XFN5WSqBX7H/
ugHLCVz/arjdbIfzOfsUYXZrOl8Ys9lDDyEkAIpqVPHaaIzaD9vBAbuvJ0E6GkLu7uP0br1ToQTe
+U6gQZJ3Ff6PKnnYHRap8r8mN+RnueYtlm1/X3dJreCVXFxYimvxQy13BBmrBo1W+WH2R6dYGvc1
9vyjNBI0Asb6NTD5oPXFCOgYss16RQhUS6ny9Jpn71huka0eHmomnDp67H1zSOEFy4Tf2iUcYCfP
jNBaEPXy8Gxl7+h4mPLTqmQKYMrjkuBwAhvPgxUFBr86Xr6KFb2g81z3/k8yXCiuHVjxcV51WSiY
rZ7GL9WjrPvpfWtOCJXsBbXdtPIel9IlB8cK+p5U2eV0KsrqZZKHAZIOkZ1vrVobl1E1HvuTObdb
WNkrvFm/Ltqw6nOWfgGe77k3qBXFnMFP3in6dShZMH6dYwf9We6tzRCfOQrOVnHuAtGZ6robQMgR
hXcINNHdr+w+1p3laSwWBQU1tLT3OSHdd1MPRlBwPz8Il2f8ypq/yDA6Dd0HVrJJgZp9CE/Jtb+i
2OF0C2EOBT4gjlvtXzrSLS0xRDgSHmjlpydA4h/gqKuDbwnl2B8i0BLJ7js3129wrBzmL50VBUl3
siD+sn8OW0IK/jxn20nPna6I8BgvqE9PG7aOnCCSdOUG7oQXT00e1e2cWb9NbdtU9DAhg/xpRIwV
g/+ab89zR7TOy1oMNnjFyZKudtrRRCSy77bD31AE2pefLTqleiarf7pn2h3Q7Al9/pJfeuZlxz/r
+OU9JY91v5xMOHwD6nfhSBf7/wq4m/Pw6v9b0x1+lg9CdsETw9DstG515LleATfGicGJi6YlfAIt
CY7B2WfRuull+lFiA9OgoqcZGT0D+oOPZQQx/axYLumAS58k4YkvcT0boZ9F+4NRTiX5tSCKJTyW
Q/WWYtu81nr8iTY7B+YAqbML47UxZgvQ/fvLxcdkXLXklzRpATrSqvGxnbSdy6GOGIfsp0exauSZ
ct403aJTP5WzG+R5w33ljq+uljCy9aJI5JntXgMtiYoCBY0YPCGkRTBHKjmxOPuKFXTUDA6PPqus
wsfHzoAftWymjPO0wpY+TO0Jfb/Xd8JGtHo7O072p4Ehs725FcsX6w05TYOg7sOdFsHtqCG/71yN
kyBZgqV+NR8YJqy+h1lnd6qKghFBhX594Pk8+7/LnpGeHvytTJXKo0hd8jrV7bd6nXGSwK2cMNV0
Kikz7muLY9CXVb930HusiZHPTTdN9K0CWrvSjwiLZeWEOtdlVBj5Wyotf7mCAb49TpLQjPATL0cT
0AVY24n8FM6zjwF6Y/o8ejrzJOBDJW/Oz+r+WY9crsUuykMP7M3QrnvPoYf3dEjCTQ1P9dIRyJLC
XbMZWA1H2PeFIbP5e6wsk1NWp1vLgFF6VuzSZ8BOvy7ZJATwrkmitr+QaMaLkQOiYuEOmQgPaee7
8w2vKo3Qmt9inwRFd5tNJ4vagvpGEP03u34HBQoTHxHqzEuCtbOkaa5MJNIghNDp6HNdg9WBrbin
qjfDnrnBC4PgHAs/FNIfsSXV3mbqh4aYM2qY7jbqgDGsJVeufuD9J1vZLxvgCamDxOu5D0OwtEzh
gyOojcQkP/3p/OOYjmabkRjPjuqyJamq6sCamm+fQUOln2fpOtYVCOgOt/RgwG88qArUAvBp5eBa
XoESzRoHHv4syoSjOoreYGFWr4iX9zhf2kkNGnmiyofs/SJgkS+TAIrMZtRDAgmdtVCQ/ke0QP6V
84v47UXJbycUGGjMxlmJFZYRRPCN9ulgu/Wg24KpuHqFm6txp+Bq/GkyNltGTkFwU6EVjS37/g5a
d6PZdHHpNxi4tDrde8o6MTgsml0UXuF7+/WfT3LUecV7wJgQAl8iB7cJPqhIwDYFkqmbmERl/FeQ
L9xzEPbFaP1Kr/C/FA5RZckzHAIzJ64D1yAF6M8a9wIyG5+r+6E8STkpNjwv7RAmz5YJgjNdTvw4
bo24y5fe7CFk6mTZx38oItaSqme+ArRy/Qe8dq6AfXxFxf5nscxwYet/Xna0lVk2GI59or6uoKKM
G/jFtJ4qsvGc4aUbM3GXeouUac1W/pEVZir/AF4TfvREW+f4b29xjUfynh8a1kUzPEUbd4tUT8lo
11wXqlR4d45235ZROeaDaHkMSRpGX9meqJLDApoC67epzuxjsP4LsXnb0DrzsbvxgkPUCyofBifX
uFMRd+MHItuH38TqRyNfaore/x8MsqvkhgK+eEaQBcEhBdqrx/d5C7xwr0HndUiQOr1h7J28A3N+
3YrO9u6KJNKJ305mHysHdvWAv1312ZC3D8owjQQONx4FtX5A/sV5jv/jnSJpFr41EJfoGmzUzvP6
tt3WmtCirRCODQmmjMRdRNhrYa+C5f3ItyCewQ0CSNAyWZquCmtBjXbjonUo9h1VtaamojMc4u3E
0/nlIDTWYnCUI9sKWjvm7cr8qG1jOcBlLvYnQuwsydaIlsumUdBIN3QHwx2Zj/QZat9zc1pRUXkX
WMk6OFBhrO6KvoJOxfQVI8L+1SOym03956ouwLnjvXRWBTIcqSs848gGNDGT5P9f7XUnelZPsHiU
q7kXy3wl8rBBogv8YYMs8DFTUr3Sdirql6YGZE+qcjRmZXzRCJOBarb5/2oGw8lE/vfvN/zwRTWO
TVlWo/v1fyrv6CiTcUhZU4YxklLUfAf5dI1+XE8DydrUuJrk90HR/ie4CQX+5kNrsOZRleGMYOnR
zmTQQjaNN8BvMFKHWnC16fs8LZodNaEwW9KatfJ0wv6uanImk3+QhzC2Q3OmjMlikDONpnZS90Dv
sKPkmAvUg0Dcd0WsSmxDb8WTjo3nYOERYtZCAmAAMA0zs+sJIq2AaLOyDGwb1apd4Y7BwGtGiPqr
wZCfN0CDkSezOHN6fcQkLnfHPZr7Uh5K5cPM3atDG/ATSyibBlfehOdmiaezEZB2+6gAEMPuaxDM
fh+F3csnp06bRYOmmp5RMvpiA3AwyKzi/EQ5/VaNAh9vKghDYXjbbUM78la/nvgvfJlt2aYHUx4T
1HBCDF70MW3/nB+ZENMQYFoztlQ/sHJd2qEQxdgP8rjw4mVJwEORjdtZFfZdw3rjvyEz1uW099qh
DPNK4Ns30fCOHHjEgaFMRNzpFoSd0bG6bwDz5yrfxi3NKB/VkMqg0Y33cPbODWI7+6mP+aGOShPm
J8lJjBoHA0XNJ0aa1y5VikNGmVnu7loDC1AEPfmqksTQBMG0+IDRVH/3XqPnAYV3JidpDY5p68TJ
k0aLHmqBivEGKilMcS5DRPlern2OnN90XNDwq6QmTbUTTo13VZZKJdWW+DHXfuU4hTRWYEjDK3NK
iA==
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
