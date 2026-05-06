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
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
Yw==
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
