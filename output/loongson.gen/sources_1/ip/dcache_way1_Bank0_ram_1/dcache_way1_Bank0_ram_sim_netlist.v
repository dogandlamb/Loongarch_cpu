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
UGZXZBiLyDomc0qrsmr+OtSM3FfRHkYyVuitzLFENKNfOx5MNqjfRUAblyKz+JSvDEjo74VM/G5n
3FHCSKCc6k5iGCz6jpYwmfIiL2R6t6D1oxHLpB6Tclw1EbXJtbAavTkYyX3f18qA5EzzbLMM5Xcd
zyl3HWjpuQPbmI3b5LSq6t147crqC/L8duvdcxaqBX2WnQ87+RhlFwy1D07LqFhM6TqQpqyBmhJW
Y+Ehwh9ans5XZoAahSoplhejYHfYd+eDcF3XkR8FcgZnzedBaNRvW6NiDsfQ+tGMNnXn5DwmiwhH
jWHvJoYsRbCJrxqF020O0RxSFH8Ax9iOq0sKkcSBdk26hgwAavuLIognqX8Xr3taLKhD6cW0WOkk
uk0DjEaNZEQWD8bbiNcQ5EXiqki3X8IGzil2xir4U7gCcH0pYUYVlpYVIVdoMUh6kwHxVw7z/Fxt
HgMTseI66TWJwU+4jJaLm0BjKkk887gwCvKjKhAgS58b1vDwv8NKwPk2a5SloD2fDL2dxxST423k
WPNDY5IG+wc1YFF7owKbxGNMWRTOp4JG6r7DFso2YDTHhWAvkM9KtxtQaZj/3Vmr4up/QuVkws+C
Lxbs7TMqqXe8zl9HnDfGkfooQv0GFT6bcIuefaxcvYAQF4MrNaIXjTG40UOLDPgcbxP1bH1uxpYs
xigb/g8i8GDZxK8O4yMzKtH+l9mUdoxfPfpoHuDm4E54jPkYcAces+3EJ1Tjf/6lv6nIQnG6tMQA
T8cNWupU8/JeWcfodDk1gPfVtUFm62kcgqiffhKp0sP9y23lIZvbmpbu/rbdGh4MGfvrK4GsMydp
zK1rAGS8eolqHDlcrxVRD+SFAgPKx9ANywNBbVJe1muEkjG0QXjUCYU44bykn+NvR4XCgqtso5GD
kl2rFJXMTGycNekpFVwqBrlQnhaUbEeNIpxTq8s+inHk2EfArVwu0kYQrbvN6ahoWjj8RDZqndx8
Fg/48m5OXObJLs7I3flmo1ExBNLtk6PMSZIbKRz0r4AgKGNd4pSwNOfOU+YFpCglZmGklneFWDed
AfnQh0QeIPRgviBI+xBqjltMW7zMLZdReTa5rCWGifkxa4fZJ4glMSLKbd5Ell8eGGdNqOlRF7h7
F1KemoGCaRtCpn/IXpFuY6gySwbLjK3XEC4B6mM0ouRmni5w7SpmjRLMxDAgMjtyO/+0bE+Y0IhX
3X7CC+GzdDsmW+03k4cIrHtBwfU5b2blG3XsAw9Wl7NkIUzr7zuECf50W3ECFjccwtRInbZwD4Vy
DzrTxFX9KE9NJ+3Zy8SX3+EgmW4v/xgWQiHAtYM6NQb9tjxuVaeA1abr0AJ5fHb7XHYnsazxCtS7
G/GZHeL8GRvsDWI++mMkSBN8rBDMCL/xLxjLB7ayJMroo3BpB956yVvhVNdpfdMVuQpRAHq2r9fr
SWLEQUyDXhB/jBIu7v/JLHvgHPxPbf15LhTTEcuwAufLSZNNAgAkSSzn2Snpaavn8bSKDT+1tAlo
T6l7bJOumfTsDSZc3gXpp/hl1U/maVCE4aCyU7RaV5phWBa4hEyRmyqF8t3M5rqELHU6qMQWN36Z
Aa8UoO31awl/6ZTn4cOJr4jTWonO06j02SODyC3PfjzE+mL7sPlHpOXNYwLjVIJqB5BMJYiCO/jU
K1hctEz2mzOlZ5dc4vcniXBVwa4SCQWxVnYwAcsTVJHcmBg8Cn589BGO5l/nx9c0OHTDt2+MjQDR
+g6dN5I75ymndvSqidvzQ6skcOl9eIyzGcPQM1TMOvHH2XsBZ/Tz1YY+TB+99pKHMu+2GBBmK8x4
jYd5fO76lldGY5NvmREJ5aitVc7b/JsmSYVJ89DqMsEsvWU8YxdQoSOvjYmxVVTF7y8O861KD3K8
D4ajW5vWQ2GWu8cOcCVOihwBMCQF+isYmkxJdFQmYDhrBwo7DqmVIuIWCNEM6ouk+hYvCiBztRdP
pOZwVEQ6an/ZWM00yuZFTwaSb6DsE24RhGorEYHPEHGRXilFkevDnht0n09gL6sgOFYc1epbEtI0
bHeS6bx8ZJgPTOhm94UuK0/14AB9wTdWMI9HH6GaxDYONUNAKZinXcHUQ4HLkx+OEoJ/5huF+qOo
hrMiV9qz0Vgm+G9ikGRWSKIQojWelzGpGv/yE+yT8xnGCcovnqKEV8FZ7t1YGt896iPIRY47sB4L
e+ZSUjc25JKwVwFmVifuT/uNyeVldB7o5Zr4VWBhbmUiwBY2B7rmli69UJ1AlGdcz9B87ryBWwm1
z/EaHZ/pKUPgBE+Y8Xlw4zoDxqgi3ttiVjKlMqSI1ZVsD8LXlymThhURbtgsFgsCbyCYkRVWrvqP
SxKc2q0H3oBEPymskxWOxHM/X/aanJXgQ6sOtJRmm9/RfnbTG2s/lOOCw6hUkQ/SiEtwYAi1nNQw
SZegwbGdpUHMOsq84mHfCaCyupsz7vPpD893EPpNajeUihPqXTpl9voALI4+07m0GCoXJCqZPyD8
xYw7pqLDobwvHR6Uf69RCkHhbOKXPpjNZnn6L3Ma0BfM0Jc25RJSvXtgLOg0jMsidsGg+evUzNv6
BAXwW0ToaBk8mOjVg4ePsB7nGACdLj4FZbq6xyTz5Pk7t5DkfWArZXQ1/7TADtcjhhtHeSQ5lXWV
fgQm2+lORMg+sRFZ7K7xN2tKCeteddsnrjsjKdUp63ZwGvwmlHU45RuXxC3b0HnOYGQnAPXK/IAB
y48l4XRdAfI9QS4Zivw75hcQ/Kg//M9Mt7c/IRvO4U5S38D3DETNS8e6Kr1+0P6ja9vRSpca9+tm
KVZOF8pJl4urBvqAJjWHHCsiJ2A8ZLLBhTDk7XpF/UL++TdrbsO1WOzuIs8ESMb67rdYY2mhkMuR
xuyRhAgPHOmrO1FybP6haYX44K9OBESmKfRzaTNLh8WTig6PX/WeLvgOmIqdBtfxrCty57V4rZiQ
hrJrZAFHrCZWFBOIqYlBypajZpv00RDw45LWlTc6hepztbO15wzVnyQltdGfhqs3CWoxL9A+ROwE
D9ykS0JGpdTcxMJ03i330Oi3PMvfzIM6PFfBUoqiIARzSPldPq5TIPkJSOnYBb3+rPdaWQZw08dz
gC+KTaGqKthrip96l+s+/7RXnwlhGiJi9Mx1g4QnnCF+WBUJalNaqRBT9ywIMmYfjBcaZnVWiLl2
9Y+tBuYlRCVYzsxaxP3eZzQxdCNoD0LeSCKGOisYJobSLcYCUGJVSCD4rcAMNaHzSbsa/Z2N+Igg
77n3BXwx4kH+OX1Grq7Q38MIgTzkpdHMvtekan0hZIaSBMBsCo7lMjdnCKdhlRxMdPXR1awPazHw
5KjThRYGKy4Gge9x5PgmPHAbTB3sEEFV2NCWccJIOlhZN4uCN47Yzg4XSscvrFeBA4Ne5T07dv6p
uH64V4GyNRBNDgcIhds15MUhnil89kv9upjkuoRzSznQ8gHlzg5GTKnZm5XZ44BVM9A+emNqfHsf
Fmx4mg/BvgxdFG0uAG8CRSVT3e0OrikYBogrhjMYVPa+ZYsSndN1fZzilztqn0RMsIHq0pOTNCBW
bWCds2203dooj8er9A9O3pcUYD8RtLC7mDRgccG0um+ri7XssDtsuELQuRyKtonD+929BkFLN2gA
6yLQIyP3pcNbpgXLMlQcj8PEh9kLTu6vb1otBq0GilLA5aqQM4+ltc9U4HsFoKtXZqNdTgatDS62
PaxaRb6nU8mBAVzuZuMiKN6JqcD42+HFHc3qo6Vyedi43KzIOb1L9gKTn5SM2EB7v+f5BrRNsWDx
oc7urlCVvDCsXQzqictuKZMdXLPkBorXkZC7+p7l3iqsRGh5oCMXgsbJYfR1nCvFFBLjPmmJB+mX
mrUVzN+cj/uh6zPUIen2ARSGqJjYflVyFkXqwt2r1lOMyYvldR4KThBjtbap5fyR5VNfLLs6fND3
o4Gy64UZSUH+D2+wo2ny92QnM4Eo47Y3Sq2nmPPB3arQj3TkCjrdEEgMli7sHsckPFpKqu0OhVur
Broe1UWBCqhsvg8p/PyRJ2jzCjv1w0LQfCk7m5BNjen59KZtcWFckGx8mhhpGK5QXQ54VJhjPMx6
bfCOwJat7Dz8GQf1+khEdmZgd5Bac0MP3fn7aUsFu0bN8I66Eqoz7/8amRvNoLxIehbIjdf7sFmc
DGTUfR6cIOD+1lPvqlKklkpEES2tsmUzp71h5LSaUrkPLVaTkdIh5ru3eJVFsyIb1C+9zwynrzHq
vPINqi+fxr5WAgBqtjL96XE5MimnQp5lNMhsyv18MNUFNW+bQbIYWkT5UCnbR74dLT2lDmX3YcQm
dElCpeFHfGDSeYwmj81MOHTbCAZJjYDN7Rh2tQxF4aiWvwG4BHU9PodnO3lwYI4ucuk7UxtlYqih
94HZw4I2b5nhBFW3tNMLcP30I29yiQ9lMW5+egx0MtBad6EZbnvd5UkdZaqwnP+S6+wb8MXFWayc
LYerYFfkGqbj/oj8Ppa4X2MbgBFZqR/B1FsyvEycH7OnpCtf1FFi8sKh5lWbqO0mmfJVBokSEsTy
iNg5OXr6x3Ztelks11xL6k970GA+2kH4qfa8XBrhMwapJEcMBP0dtBljZ1O2vkCSuWKQIMaWnI98
ZHiY2eAfppAd0kjspjNTuiyfinuPkJtamDOMWyM/DfAeGXPGWqnJw7KEW0keFDdZ/q6qX/KoUHaO
gT+q3q46F2ws1VN/Qf/R4pZFk/MN6PBhoAzc5/zlpSazQsK1w0K1L9haIZIR8czILTebS8VRGgP1
k9SvI9EUGoT2wh/z3miHm4+gyEEU3yXH7cRBE1Mmw9JHorM7fhXdwJD7k+y6ZAilXzqz6hF9QmRE
089ehyUQGHYERH8Y98nEHbWCsZOgejI7ipqy/4EGWFKrKXzAXEX4AQBz8cCyRe0lAJLNe23WDK9S
LTx0s8lW7d9EgCpvqmKlxRCxtfYzCHOHum1ttza8AX1BPLct5xAghNpQkSrxnRlCeC2LCxWiqQAw
YlKKLOOaaF00hTjnm2LYhzSujLLZlDK7cYhQQg6M/AOtmzEEBSNu7VGBLXcsTQFhkzptPJEv/erx
QjSkGhsh6NaDjKuuIOuwfilI8UxKUP3P9vaeqFKkH2D+ifRh40LqKvrjZ9Zi7hbQbU0HJ0tTDHSt
EttJ4EPhpzhaK8kAGMS3UdUL1BWdpGoB3G+oA6JhEwaWXVH6qXWsUw1YA7AT2J/d/CbqeONLQFlQ
xaHwOaDXuVlkW6ozw54+OHY4du7U4clpEGyBaRp9xlQLQGhr4RosV0DYy6ZzVA/GUR2MkSzKqlT/
3A26UuJV5Qc6mZotq1vGNVOnzJgXnJPnMIUR4KDObRttIpDW65qHB690dlZgVXsTOBB4fAeR+Emc
HX6kpuQFRogsKMKf4iLuZ3CPM+TfzDJ6hzI1Kq85q33JBpwVpJgHqFwQ/L/PwgbIg1J/h+7aCALH
qIjI1zo/dR2Z+i9a79FhD+GRRyE7Hk30/gAgGWz9gQGl+8t7Y7ySsn+VOV56P+ZBGbLtguNm7BUa
zaMpoNN7wtRJ1wzN3KQpnmzlducPTrSVsKUf2xDzOJRB0cmh1yLW6vgUpGbEng8IhAv5ckgrtQaQ
V+6ljE7Zy4zX0Ar3pbfTuK96tNEwuwv9APVMUIEJQdTY1hutRooKu/eBw6cazFYvwUskt8crzm8b
IwN4QDGl8WeifJv2wzyq2xaM4JyZPuVkLNeTGeSOyY0nHX5eV8r93ArBgWeXGvMrNCmSX5lVhx1V
6sWzr98eQaAZBdTSYPuAQB4BxXmw3LAuN3oFuqvBpsUB6y3NmXohlqIBrAu3bXsXslNa/RqbQmyy
efjMJHIic5Xl9vEjqFCj0ZTFbQOZCgj+rNgzlt8d/DqKwrJhTu+0W/WE1mcfM0SaemXOdl28TyL/
Pnuyf3pwXhBSUdItSPxMw7UauNzefdfL6JQPqoR8bcNwNYoiVIq1JLAxAoUVNpbUfINlfNjAt8hb
AfoDqDs9UdRR/HD6RljfjaCHVoXdi9M7ign20WVbDxgDP5BplI7lDAvpg+rih+gNnh8JvUIUCY4q
sZQzW8WiqdVEf/NSbzry+qiJxMcCOoLTzEloQ21JuLmHKKB1cgdshdToh65e9gTLKxTpat9rFICG
W81LZINxG2MDxPk/I7jzhCuvZOR4iXowVKoUol7qf0Csg6pBX51Ux/akGyXrJvo5zvK40pnB6VrB
8M3vS+jTn0af9eT/emEs0bd2RZ/XPzRYIUBnRgPl9ZcuzJoDJWJKMKR4eULG4HutI3sQ9f31moKk
n+2SFyPhC9HtMMCaIXESeOdsZayenGvteuirp0N9JtUjhRAtuWTh6wF0CzTqtZrfyaF7h7CNELLx
d7F+rY50lopVUwc6pG7TdkarDRFPU3WYJtavavrW8XXCuzHJxy1BXFqqcZzsZMztcpET0QkagyxA
D48m/ezI0dB1X6vP1TFSv3kKDd4yN634ADxTQ7BK30LSs1DPhjNQpbsv4KYNgx9TfUPinVNusXpM
r/UYreMG/Ij10+XWPIFVwGv4H+DNuaGphb/FlRI9bJCu+UoqevV4dijO/RTFIUC5qPLJLut6/hJw
tibaBV265tpS9Vt+WpPiR9632DGI+G6Tuqolk2glvPomYo4fN/O8zxaUsnBuwSdT+zYHOK/d0QGf
Q3PLIpr9f9dEcYsVCfVvD4giftFVb0mMpXk1z5LBgRKBjbW/ymEp6cg3PIHMby/w6A/uzJvYVMJl
ly35ZMMqAiMMAraSpn3rqMx3sB1kXzrxpgYpqrlRJFFzyF6BoJRLXYwb3zSfM0YawyxHuAWMnnnh
a9WYeg+VdfOVIpxs6cski1MQOoo3RB96l4/rTymFOWPXAGuCmmh9IqFX+OrLaEp7DEIy1o6jbqYe
1JKSnpvWBh5n/f0x/5oe3xKQIdqagZvAU0t/hEwkLBnBWT1Fht8XHWdOgqw+Kay7PfDmgrzagTnB
H83/xzoXXV50QRUyZztJpvQwCQNzi7KfVxdzZw/GGYHbHbGMiuU6ZmYJPdPnVq4S+Ed792fJHcAx
s0pz6htoINhyc1lwDnCPry2n71dfH4MfGJ+v6H8y7nuYnk8Eax5/fFHG1n2LKKukimtxbxzd/SVc
X+MsDVsfggYtiG203J2QT/Nj4ffKG5VSK7rEqZgQZp57VzzKXZOPnj9D9SYNehRVIK1nA8HSyr2j
HQm5HpiKOz+EwZUuXR4UPx1y/hpiVpHcRSN8Fa8SneSzF0nwmpLYRPUMoSr7945mcRkU8+8zswR7
hXtV+OIWm+rvS0wZo66rkbkC2Xoo9ZSimbYHvTG80aS0WkFwWgLd8k29XXzVju4luqOvxL5w200O
NmkYmrSFZhPfI/L3Tn/bEy08M2UNbWBzKkdLnks28K8Vh73QDZ8a/00qgcHmVEO8ZSgnaIBQezuz
x9KkgBu/E8cBeSOvFU1BUgqmZ723XHdodsl8rruLk/V/lakLq5n4Bx3JkOUBx2Jw28jlaVgFJmH2
DGwE0eAu5aQGJiysL3DkPIbRerPGYUZUZl3KUqdMl+5/eZYWB0SFvApAzGp3RDt7nAeRx1zX/Gz/
WI/kmGWwSf9ZbPEi9qYEunJx7tynRCoi2IooVWcA0s72HK00BDGeWWNnje/w7M2/xQbf/frL9+Gw
QtAZX34OZfP8Qn5jPiIwGoP9sDJw1tjhEoZOuAqTR2V9woOdk46/wostiMOGJTiBJKbye747uhvg
aIF1gQhJAKOS2SUZw0eGIHFhJCtO6IjKi617+oldWheufkbW5loa4ma6EAjLYG/DczP3bx+KR0Kv
+geuesa+Cz2R3Q7cYH5DwTLpz/Anb2/g2+1UhFoVRi4QzUS7eX/3M/TuO+zoFNN21U7rOnayZQEk
NsQr2QafrYRKf/jgywd/+q2hHbuUCa2OlXyovdLkXeIlGJIHZq7OJrohqnk0G4bEfYOeyWnAhIo3
+RBursHuAqyBy4DhzO7iXfeqXZZjlIJjGZBr8YPpSYzbgzpm/Pr/gZmPEd5T3BjorhDrJWvo76WS
KQtRBKj7yLw8nm3jv/rnEfr3BFTWSNEN9eUWpTxUBmVvWPDngGXPMRmsU0u5TlXu+VWZYqLfbyq/
eRJVrg+ctKYedW3Gj2QINGwFW+xU66uXgKljV5Jkp+3b5SiqbWgx6Vr+/P1m3L3ipI9rsw8i8Wi1
9LCPwRr5Z+5v7vsbE+gtsh+Yny7EviO0mpi7ogK4wWOCCe7WWvOMNqziP6uTNU+DeKvDh67BhJhm
/foNahCrl5OMSHWiIuoH/ewpVQIBvffZ8QwkpT3oFSYSD5A1wvFcdArG2eHDN07U4RDJmxSaEDHL
fYGmLmtQincD5Dd6kMjThAkfYXpTmON+QVQhjGvsj8uM+ucn94ESpHXLTjf+qcHQoNseUeNWoy1V
rrfRbezNJdg0FyOnyADqQRXOZlis2iIqMDHE+kGw3LYL41sHEiDvTX7BiCL2MjbEYCLrLW0APX6X
hysu0J52Bp9SdDX08uxGCFF9RhkaOCDZ6XpDUnWwP+xoaxOIqHhLRls8feEERXnYNvWH3mJKa9mh
iTXIswZeNTKZS3shGgr5sjrBbOO4cDR/UQDixWEwEsk0MBENSh8RF1O8VFLpzg0YYSjsMs2quhUR
IxBgmCPMANQUznKYtbdtaHyUYzx5yZXUD2AjLFFTerMSTmlImmlBNFWM2mJhPmtrguo+0JPCVQNs
5IXHeTrsnV7+pGHPgynegkCF2vgWYAKaCpzCjOlkeC3WORMnRt85bnwODmWQIayzRNj1Mt6L+1H+
XqGW6UvLWW7P0a8GzG4lLESqls15QCboVJm8hDuV2woou95HD5XcAtCFMdMiFJsp3ywHH2HoZW8r
Y71jaFOs46UKeXgrRfN7a+kQGzVjXogi6+tg8jvB6PV5YfncfteJHdotEYT/0CuVC9Db9pedNKm5
HArPtNI5rWs+cx0aRm4mGRo2KEZevU3tLelz38jzyE985/s8GJFMOhNR8D8jgvtbG3vMzVH7EwU+
79/7Vdiun3w+jgeJj4i8/DuuY/RfNk4UK6plrd/GBt2jpaQtiAL15qfuxrZ9a14IVOzZqpspQzl5
AWjyfZz+x8r1YkrCMOA8W3+JID26uYm3Wi20xLsy+gfbdZpSWkSt8ZeeytDwj1LrXyJpOd0iSCOv
PzqRR6vv0npkbyYTJCUNeqBqmLy+BLWRLvBQTQ+tv5B7XKYSX8uABFXwg8r33lKaMbroJDpm+hBh
XT4FCHw26EX+9qKeWZlA6XmSJ1xpeWKrRTlqKyNO43eEEuKXBD014EJ34Ce7ME5khIX0S8E6CGhP
53L3eI3SIY46ZjSXJq9LFyRTvPdrvDhIuwNPT5Xm+lLiMZvbSYq2jDaQ0PHPFZ1O2VcskYyaQDqE
H6bHRc0yrYxUW9tHYRRXT5yMFFV9lRUYtU36gU3w4XVmyDH1YSkqSzDAJ7s/KycRNxIFFbLpKbKX
NkfpLcZhLRimYxjSbjOBUwcYzlNihx0agOPwX+BB18KC2JmznhO+NXUaTmh/y2ECxaoK9fLB/aaP
T/as/CZboPkbedWNqsvOvJrm7CW93yS4m9upLgat8j2QdrHwRQxes4KSK7/4KIsNvnSsAMgh5x6L
HifBr7V5SfwI4YJLlQhtcieK6is4pihIKhsgrMfyItjf1cKKwBdACMgZXv7E/Y0ack6aRfql/32O
rZuDm7u/r3WtdtjMxyzZmO4LtyMQ+ePwSu4nup7TMRkW1WvrYMYlZG/ol9W6uzuxwno3ShRBjm7T
bEoa3etWpDi1JLXKArm7llkIIH0LvQFl1v0hJfrAScqdJIz34CpvwOM0w5Guvs8aZ028rSI6qdqB
L9BNg+X54qqJ2mNWbZVBCB7n8qFtPF7+EwPTIn837qciSRP2fXbKj1AOe3HZLyod2f1jiH8u8tN1
IvAw3ah07Bh5gyvzxU02aaPlcQpvW+MOoagEZYeUUQpcnqsj1ZBSvau07fEJY9W7LBvIx/9LIQTF
2SFshwv8ECej/L1vqzhbx11cPjDTifJcHdiJ1Xf1VPp6KoSV7Wa5abz/vvU0iIKhM15oB3Tp0toR
SZsPXntNuOA17wnKFocqwIBnJU+uoGhjGGAMoJriYjI9Qmd/JT9lhv0zeHj+pT9Byqn6/sL5rQUC
Qq2kCZtvuL582UBHnBxAiaiS/szB5v5cCAMCiqrIheEBEjuCPSDB5rirX6lpUAum6WWRkunS5iQ+
m3WlyD78oGjZoWYKzKDWGqQbZxsrYCUaY/f6dOmHSPvVlEnu2rBQPeJyoxb/FctaBzN9TpGWFUpm
9jv36+ugAhrWRJ0msdwZ6qgP1FOUGSYMTp7N8bo8DmtkjRyNyPSX9uvkzcN4ZW2NFGKK/57h7kDE
pBPDmU6TW/EyUMFGFSY3Jip0FEJ7Yg1dDopCJFQnpnroTohYEX7/R0Q5uIrTpTIRy90zjhEMB2yB
YFIZu4KuRvapYrlg73Ypdjg+3WAOoYiMZqLmccCcnHBB2+aCiOFMmVEmUcZlQQer8Qw4M3Z994PN
Zr6HbV+dBsaRsUkFoE43jY7ThHYqeHPyzlnTbh6u68myMr7GZeHi5Pz1ROaS9wqtACMcfFqe9lFl
3aydkE1eRB4bbtvroihSx+tuAEvzWeKEk/ADuHuN8uBKpZ20DL0ntAjW6llRSziHC33otUFHeAPr
850+vK0opUJ22EBtYYk5MxRhV7NNdIKOwutGnJPJXT37YYK+Z9SDzOv7C6bdoYY1THIRxdR/z1zM
80dVWCjS5Hz4dJKJX6cM/+n3pibv+TS/B0Jw8XsGIt0puHyhK8vEkIuvMhCvdv6yUoHsFy43wuEI
0tK1nNdsWExh4prRfNfwkTWgnOCjBvkbU6KP5udmej/PIdsSZe+Hmh0UeCA484DBbONWK+agbCw2
QU0e9VJ0e2ixcSFVF+mLnUMAvnVtKU9HEekMcQgNNtfpVIwJqUs8MdCRtMSiFvf1OrxfPtlWKeZ0
EqlTFzMj5uy6cQaLf7n/59vfwq5NvqyDiWLW0LMaOoOno05vhocUu1pYsmbpbVfc8SZtSBje+Lcd
lVKPyL2oR94w7ayaauqhZ8WwSIWDcxzCHU3n55wahAJieGL2/0J4EWTdQ2s0hYCasYBTQeXJ4beh
q9YDgfIcw7DXupa5s2fbNxPpfehdwDAH6mwLJ+9J05Vo+CnUmsAMuSRocxmCnqtcr2Ei6xBoKYk8
pshRx5zkgzw+5PFcfCrgfxszvye0nfFNK+euYGBMWuXlUYhmZI2REWn2NrLWYMEIEgwuRakRE3je
xC2jQdF5DgktTDWbZO9reEg+KQYM3P9i6MkyRV0uui+Ue9IdU5hFAmp+ls0fYHt8X8C9FWb7y+gj
kJGBjL9Fed12aR3jLS1QSe3+zXs680Fn0gVVF6j8Do51XxcomNbS0CftXS8nCJE1e4usxs6PNGmR
zcp1B2IjrvTfxfhr93eDynK523Ghyu2N7VnuadIuDWPnhes99a3QLRcWT0yMpOZJAEnoc82Y1A2K
K7E96NbDzu1KhR5H/0+Qs8d4jJTAtBMbaoit8ABCCiYBguQIOoVLGGKjv6HWbegMXc77aIHRSPH+
E0mlVelpuFjcDhntHKzlLMi1Gsw8aKgesgqNPX0JYyq4MMbuwmD9P4fm9/bgtDG+8T5L2YO4Xs6z
wartblp9OFvP4FGLFamB4GjVPAESCnxvbn2OeSEjvCP6MeRPtsuILp5cEug6Q84ZWkSb8wV/tNYn
FUN5nxL85lFMJ8F78BR1KU86gdia0pnYulrG/xi2QR1hV63PR2Sy4IHOrOazIBpKpX3FgUZHOh2s
bcKehl8euORyWl7IM51HxlW/KNvlrr60/yFQJlgtgyt4oohZnLC2oqf6zvE3j/d2oXkHFBdppc60
P864FfIIvqG6JFbG7UXmpPelkAlASso43CqfD3/2CSw7tIVo/LtkQ5Hedop1gvnKDQGkILMlB8QK
BDl5Q/4svIWncATCja2p1vNiFdfo8DlbJxBY/G6hrukXyqEIudU0xWhWnOjS/r7PCty6E3/MAAv/
/R8Wv/rQB65853Avr85H6+2ioV5W45uZLkNgQ29lLeufWqKS3tM6qfX/64SldLuxtnhfrMHgWD/O
9sv8siAHurfsDI2fjGFaKQ9hO1Qy+CNaDU5ozOzugWldvQLJIbo2v/cRh5MAenC7Ah7s6tOKgT4T
LSeCrPwOyjt8m7Rf5vTni2Bqn0AHZqUnNh5Xyd8EcnqERm3FwHkyWT2ESBA1ZkdvB65775EbW/bJ
9EUycFBQiZ6kgDeZBdM4pOu/JLnJFMlFKpudgFkHUHRQxbjqFT8Rr2gaSnEN2thgNNJ6dR7kL0BG
prv/mPlgBmsN79A8y1g6rRW0UtPKpGWTqByApP7nl0mF9GxpTYYZMlAfh8OdLyXU4MC7AYWiX6hH
vL2SJNkB9SVgIqMIZx+5y3YnIQdxmgtBmky190EFf6tPX5OqqhnOsOXzUaHCFEBk3EuFwOC/waSs
Je74LjyoZqI+8frOchyX45ax1DydEZT6fljzlyVNRIgDQbV4FvyGjj7x1s86dVtxcg4a9k8wucPg
VTNtkqQFO8YWyYhggdL2T4XjptAlxOPU1K2pU1wA/54uwCCHpWuCxvLVlh0fu1ZeCzuXlawdrtIZ
4XYEqVTHCMsGGLz6mHnm4wDiSPPGWGv0XxTmVFFx/ErJsIi5pDijt7Ja95v+0+eWiu0umYKTYPjF
issrXsQgM4PIIGjKygL2apEre8qxxyacB12LJ5oBk9cn/mER7uJ/wdY5sCIjei7JZGrd9hVsTOK5
JEu6dP7zaTqngYrprRmSr15EkRMcbz1tK4CJC0tZ60MfEHFOeU+VQZzaSnRhLYcg937rXvG9SvUc
XTlXFaNCpXqg03i/1MACCq634d94KlMItn8lyDi3JJI2hkClB4hQZ5Q4IXuFSWvJWTV70TvI5lMF
83nTT+j8EYSmmDkuNY/Y8rtcTMGKIXAGhqvjqR8TNW1pqmyk1YfLsI+AuWZv68yS2OZKM4jiHrlz
nYiEtph/9HuiDZzDe35zqBhgTY0GjcP6cJqHsU/+se3dZcTajJ2nmI4QGDFuEqEzjS/3zSX8m6Ls
nDejIpYSTq+bBCoIUXHfhBt/2lc21NAopFoTiUuoxsTivMEJW5bLFUCU19sYwf7m2dEwrk1tw3SK
0meqsrzTru7eY98OHUmMtAVl4IDuw+VFEELFXnRmsoUkFM/jXmzEni/A3Bka65yqB1uhVMtRj6g5
UatiHSQ4oYYH8Ukrjrm+CFp2bK/H6M11rYb/oeXkF56iiCItMEP8BtiWRPkOKgFBV7zQ8KkR3fHN
10pV1D1FurkC+jzn8kw5FqXYgyRg7HRKNqS1VFqi4gIAnMbUO7H0Iy8Z6F2ZktX3xKO7DjdOF9yY
56fmhwFVRsEGS123kotbWOLPDsO9/SHcC1I7xodsj2Soh7wTjkDkZNJdNokYP354OZ/BmQYTr8qb
AQebEavOp3zeivfp2DIR+5a4H/ceLOiuuXjeoU/EDuKfN0MJWingiiQ50ffRoNs7kTF7XWH5qsg8
27aPDbDA5XkjODDYPugoapKYCKddJRlR5wsx3Un0rMC12MJlYrEjZuaVFePqsL7jEneYu4Z2rW6e
A4F3fAxyT3kM4+f4iCFf/514HAyhsDfkFlS9ASpY8KY1lYCc4RyInpiar8rNrwugD3empuKAJt7D
U3XYU8DyBKuRcLJJyhA9cI4pLyPQyuIl1AIuK9B2U4kDWwkubwFuOP8/Gz1CTYler/azhDk3q7i/
N7XJxrP5Kn3V++qU8Xo3W2ghXw6d3ZCYbDkdyHWQ/Sv/jCu8ia5+hAHVQk5Ik0mZqIw+CErFjhm8
tjh5+lZ95O1Aqdn2prk3d8OBH3cdsWi7bTkIz7CJn0Sr/qtrnNQAa2O6kwvQ5TMLmFazqAr3R9r8
CrRAGGzUeq0OmGHh8UPZIWoKZwnnpu77BpBlwG/Oy7PqY3mGfEBoqVWGvrGdnAepG/tLhPCK5SQ9
sti/UFtFGObOBeyFb8CuBDXQFLwTiMzYQTvSwWN9o2Vg1A7NUjES7e0Mp0JDcbSiFcDZE7BjGZfT
QvMLNxSdMMsQh4x3lHjXnmmW8hAbs86cGLiUrjBvxxm3M68M/UN9/lVW9Ayol6yoJ6gggyw3MuHY
7cf1bYEnZpTc/YRmZ50nrSmngsOL2piWkCBG7rCHWkHwxIX1tpioDX50TlAqm8T8uJYmQsedrXPo
0dA2xrU0Dwj1FHcHctRqVd/LdCw5NSHg88L7suxXgy/c2tP0UfLgl2IBZFsMyt7J6XyyCII/kB4l
NS39IBQa5w0MQPHcxkQ3ehGHoYadWAptOz5dXGmSV5rDhotbMrKiAF7IiH/iyx8Kchd+ZcNrrgg9
psOPaJVa6NIgPuUyZWZnKneZ+Kayu9/GNCckQqx49MYsGbB3d3/cFq/r7AeIjn2iP4jipUEME7mO
rdm41V/0dyrEJ2nd3DHwwUfvQ3KacFR93J0xddhGPIqSnnITgNQK/y48MSWp4q4eHbT8f6Cn2Cfb
MT/8gbXYWhjncVLAbYeFYiz/dQ676OAWKqN4psFDzpSZFASbywBMTGviPmcaeVZEh+GOCtH/UNT7
WxC093lNGhIDzz6g8tHYZR9FvrQTQ+lTQukeOmMZ3w66iSU+jwgEUznvtRhbr+Ds7soP0pLk7wGi
AKGSrWDEdx5ORVbur3Im74qeglKBiWXbXy5YalrOa2zGcv0aIPW+egmCysI2ysMJIj7RAd8yTQTe
v7xokkUFlnevc5t6RO/8YLAJeasxDXIWgSoxW3k4V4HXbxXXJaNx+BheZhnxO1enwFXlMsFkiUnY
vZ/iaWcdvi/i5/4HA1RnRF8ze+iPk2thkwodRlDXaV1sV2IUYJObbRJy91HpXxspLQmOsSe+DKeM
rePUec2TLdjpiYJRnFdQCV/yk3zJsBsuJ7FUs+Y+FvqE07GKPgTwWHRw6sIWxX7fiJR6kqWmAf04
V39nLHTVAmEC8Xo5OGvJzw8PvN5baIWNcKdaD6WkMuGIVHlCPJc9ki5bko3s9Xz2vqF6zpHQqBTV
G/L8/OPQwNQoB0tm2hczDNO+Q6uE8hxoBlCTEx7o/29OHSgqPTKm0fAOGwK3V9JUEt0XKhYTe0+W
Dwn9NybO9fErRuaE/M3swwWCYu+levpSk5ZG4ZqfRduQaYRmRJwVJ5pUOcetCqFCs5gw0bIOroqa
L3qzXP+sLL8oQZOKZcKSEMPh67VnkknJtx2bNM7awLuVJDn4eyO0YVqkRM+2LwfKSrhcL8PdnPIh
95lQdhFKdi4dXz4O0g26uSNg0Pk9bzCyJJrDPHB0AfgFj5tkXjofJmI8shPOQBC07qN/iIdNlKQ0
PDrjZq47CfrmZHRkm3Rsd5uk9cJcOg47wmG/DK67woepj+ogzJ5X/dMUedaWMZk+qbuT9p9/2c4e
QEi1PkukhqBaCz26OkVDyxJhhcuA50Og65oPOzcrcxI7Ny9DPv0xBzyvNbwQzxaGgqZaZZtDScad
w6TOZ4COdU1b5uJICzO8JNyqJaCzYM8RI3BuagDDab2RlnPhZ5qyBUHhwnzHmKb2xN4mqT2Ruhi1
hkVt5Ej4VKvn1Lg3by6HvwBU8pUngwLJGXnKhBGbQrxY9s0d4yV6CGePlN63HYUFq/5r/WQjHspl
zGtyXYK0PbH8WhImREKoxzjswtWXtfGhr58KqS4pHm69RV43UwmIqnQT+kJQnD1VV0vRdma+mtgO
7DKLjWv5y33rFFhx4SPKyke14PYbQQOIZhOKVphkP3A+M9ejCZsH2D7BVUrRKujxXHn+9Cs6kAZx
xZaD6m0PghO+i6r9/+sAIAuA9Ek2VVl1q3fnu8IcoSdDjer5QoxQZ6uCcqiJcoSUoEMx/fhFq4MA
A6OlryAazZ0Y60hdEPjzBOCqN6N+IoYfcxtVU5OzWtlE/VDbxYpKvLaMRFR1Y18/HWZx6L9qdkJ3
zAdJsmHP9lqTraAxTeArsHslA6d+saRN9iyKwB4QZnujqkuc08/CljYaP9WhPg+5jg73qmVpsZ5E
5nhk6CffzB59pHwfJMpd4kqo9vaokXJCbha1OaGZWWn/Cgtejhwf3ZWr6G5CEoB5EgFIkbaXavp6
Y0sPicj5LqqyAawVtbJME4TtKr/VGYeKm1pclE0Ndko3ZmX95qEAXWVB60mdQPmYk/sEvhfKru/k
a5Ptp1H/bvBYITbNosEebi9sDLY95IS5bbyPl/+AjWFTNVQuELHhScPebElRivHVgWyH8hKop3As
MXpQu0BKksMVLvt1jUItybX14MkDAFAR4G05U2bS5oGlVMzqnNfoQ3dVcdH2N0s/7aSdxxiJZ5Fw
K23ErPWv56FSR3Df4c7bu7m/aONwqJj/roEHBNbREJYB6hduFKeCUcudrdET9jpuqNNXmkQHjh+O
nHPu4IAQcZH5hMGLAOVGGu6xPZXWBofYCEqdN6vS/GsBZUuuyBWKhmkdY2jSRG4PMBiGIUG22Bqm
1E5oZtnYR5FBZCWbB6Hd09ArnUiSdHk/S66YqdXTXp92fG7BYyZ5vyuPH6kFQBiHSQT1EmopmN/X
MioXpKyh8fh1MxwLqx7ioAsLFqSmurYggOin2YP2gn/4MJlkVwaUO36oxZo134BIn/ZD9L2Pr2Dy
udR/BY5T0EKb7D1cW+x2z9Cae0LqJ+EOGjLL1b3LjERGvxzlyC+Mx4npgN1Tv8u5tuKzO41yO6uo
cnSa6bCLNvwg0OzRJJR2yu3yqwkADlEKrSouOww1CMzqBcksoBLfhCj85/34t/yxU8XSKey1BbRZ
qlEnY/EibbSditvW5pVe2iM8SF9q3LMGF9qlP4DwYZCv/uJ8oaDRgoprpelObEgER3jrPTUgOsNJ
GmTM0bYI22NfoZnChU3y2LCPglhrcnAL9EcFNckuQH25+MDK9tTUZhn0Oqys6MZfkgGLnI17k4Tf
kT41T3jNk2qBFK/YHK0nIpKImSjLAbIS+NVdiZvv7m5yvV+LoZ0Sd7t1Yp8e77ntr61ER8/DFYe1
HgvVjkArBHltY0csqZYVfL6n03BtPG5s4XTLfWOUn/Cv4uiH9el8JQt4ioXcRXZeZUK8b7MZGZ9b
o/EisprnCxw9fCPC/qLJCkORu1sGxNPiCCJ8INfRDJoJ6LGYuOfHHIbpPo0qD9DoLf9J+SRhbSuT
Kx1c6bjLhJSWi64CLWVSlOjOjU7Y2gsmXLShtFBXBH7xUfVWI38XSLEPJP46n/lMshb8Fk6b5W09
bqFB5EW1+y1EK6DXOiAsrJOiBvinIPL0poSDYZ2k2o+NAnr4Caw0ZaqqQBZHQYqlhR/qhfbonsoL
1Q8bisTKZVpfk2RGcQId7EeF2z6fPSwrf6N/LjilM5m4O8MoeUonGIxTwXShxKzwp8t5suK8Ulg2
BWPO1hb665IqMaxS3B00BCQbxvYZ687ucn6Ate+peg536i3lwfv+416iRVqCJHrzcIdf/0OR1jhr
MCc+blWgS8dSbtwcwrmTlvPW7xMrltkD+3oyF2mjSFOtHkdAwHFTESaEpo65nBSdGx53/Rm0Ib80
4QclKBwv8kQnXSBknEIogTahJOAl8JMWHoARSbWZK6oFHISTDqrgTO06wgDlRW5UGm/ZPMDpQpAF
mNp42zRNUcLMXzVK4Kz9DN3vhCQnbXpYZRrOGVEjBV0C276HyHAZdi8tBQbqh8UOjQizSaBO0wI5
9/u95CbXJeEzf3mRz1wxt43UYqo9VGAY12ARVMK5EDMBE2DYE1JM2clW9h3TD+BEZye+kLUe+HUK
4OI3sDPWCQAkI3BE29sqPwtO8D707G2/6r4ugQXFgQ2e7jHzfnXEkiNbbb8mfYkgjDbgpjcetu8k
6Tkg8lyGfqIThDCMwtU7RhGl47XDKI1IquHI7TIcMF1lPMLSZ0+cQuqw7Bt9bRn/5TMuFwh47zyZ
qW6fAS4v87CzJX9g4joBOgofKsZa5/JOaBE7WGIioCbhXcM7gD/BEdzN1zGBp5aGrB9L0e9ucYiX
JoFr989H3IctNN2kIx8cbBvH/Jt5wHv0QfGbdBggvYI15ZVqpZaQuKGWklDeOOc5nW7DgzPczopx
zNMlpPv4RElmjVB2RYBhdDz9E4PZKJUNSXgsnsZSo4Hv/xnF0hw8skMpzzF9BghsNxyyQp755m6A
wnIue9UWvZIpgMc7ki+X9SOYHXVIx6nmlBFc0/qm3v77YhocDWfQYWoxpVN0M7Jej+BBAM1nf0Jg
a/aHAMVg9ylwd+q+ORz2VUfmooaApRD4v78FSres2waEMOth10S25GSlkp0ozl5nltrBAgI6/sSG
3Co15b8tkW7d17F6qsPO0koP/XKfS67ctXuil/tJClgyNeMkjrWAU4Swqit8wIAnilUGnfZOsqvx
CaVVBOeKyLUJLNnQKoT4TB9qJz8qcNmaES68/qDULgoBoJeScgiVEEKbayntq2/cGFazrZgoakf1
7T+EUk7O3bx5B1FV8s05rlmlGRxa/GTcN0GnQYH/MNL1HGwzc/4Nq86hTG0lotuM3ShNkk6oHnw7
r52ZqOLpgRAGBP1DDAtWcXCyjmIWMbZnkvwehNfa4KZ0OaJJKaCh/5eavs7c3UV96GOrUVLgzoVo
9heyRdDSspqMFHrNIEAz3QJV9aC2gA6Whs0hsVLrS8XAbT8FCzdjYzYX5XPV5c4mnH6A+OVy9vYj
bBWJdAAatf3k3Tu18C3xDyLS4Bqa96bcCx5+dZhsHWzWKq7ME2BtAYO4NqC8BMoxI14fwk09brc4
v69q1WV6Frtv3YtpS6NWQo2L5VjWUru/0O6UIu0/5JyNmV2Uz6FjBHv66JIHGJJrG2gOUhIj+BC9
nnSIZsYgII5yvRObaDMkLmAHhH2nW2y7ZPRS/pWZhacbsgNXGNHDQdWo/ALJziOtmgA9Bzp2Gzh0
w3lY2rIFkfTB1oCH9NVgWPoGdFvC/kciQ6aRejzcZpzcLwBBQdZrpeIjLWYjddSMQIMZYHF3jbOi
FetcvsV98GYA0wW8yRJnn+o7fPfMs6FhLpeIDDK9fVMpHz6oEpmE+wDRZmptAq1WmbYKAzfx6jdw
n53vrwn4ReDdFrZj22fTH886ligynxxvhREBmDY8i3Cw33K8mB2Pgmqh19SswIU0kzz6b1jX2WyV
aXuQR7/DlKqST/iwi8qSojcDLBN0TCtlJ2NQGfrZXKlW8CsG4H8XWZDWpOwOESVzxpVe7Bv2txt6
xq0AY5gk3o3aK/nZNDrlPuPLxNpJuiYCST8JXC2G5KYOsLREF5yOCVi5ru68E1JI+jfB8RJuqe4x
Fz0q0m1fsItXz3dZUckcu3iWqky+7bxYNgHkfLf8+Q183H4bnlL9rgt+IUnJgS43DnrPsDMgZpRT
bHfNVeCkKTi9Yyi+B4DgE2mt3g7uj7H4Gmxzyx0n6Mx6EXvdEomkgmL4mO/To3OCdv1OsU/qX+Pu
fAzG1j25zSKXxDGWVXNnHzmzNVLZ2QwIse//deUy3Bwf2yPoPcz/nnKVVk6Sbcd6ZKXlttDg3DFX
XKKfYpR0BIKSFtw5sR2gteqTjMavPG37D5QNLk4di0DNvhvdG6GI/mzBEt38bQt9Vcv9Tgj9giAs
qqlN5Y4aXWyKMnSG/VQSK+1JeIl2sEwxHloXOoMX+xNUJxBTjCiy8E/tR8g5wgMH8gMxD/jq2D00
ABL1lxhy6DK5JQ3K63PH+BY2vv/4sNpRnuViJFXlFbrBA1BmGRPlVqKFQoaEi8mRg8ngDAAr/w/3
7FILCb6nPMM2b3atY5b72wGVeHbcTsQDmCcfZDBAuviELA62xMzxmD4JvhapWBcxGR6indd/SQvs
xFahlZQX32ugMqnn8AFZ1R/BmLmWBFiVBrjvoefBkR/uzf+co8sLXU0hEt4ZBCqRNWVjegDv+v2D
KHljpELb8MgCeV7pbBirROhA2ecqqzi1TePKEGsOAd0KbHSrGv87mimqrCz5IbUchtwBGGR3wt0O
vyKTQm7R/QcY0BGaa1EquhUfoLWufWTAY/zs6CRZneBUpEPHxm31Maj8Z9DEVUeRzp60ooAmGl7+
I6GHSJE246R5Pa196Ke3PRNUoV9gTiOVAj27yhmNb0jCnqQCwTnxkAOlZsKpo3Pe+MBiHe0xiHTh
/UHkUcGdmFDtWRRWtDduCd+SI0j+AAsqFB2oxjf6LRJLldZUHDAlGtcDMiYrocRARPI35WxBS1T2
DWM9tQ8Rh1wOMpmvlEvAwRzOksZSrlZPdGHd4A1VAhLhtgCcEFuinNarhmmMXPjIWL92Y8ZsLBoG
94IZ7vzWTHYcTqg7mUlt3U3jSej2Q0pgr9JL0xq9b+7cP1D8/RSCR7TeMOmcdrI+vpPETd5C/5OV
agZ9R+D2IDDlrXY5p9331JWPeVhWhXb5Oda12Ro0dVcgBHSwZ4U0xg79LSuNeJRDwtdsLUF60ftt
MgLayIwxIPGvqnXJdmpOKaVLgxQaKHE+OUolODkr+nQYD4NIJADib2xA1VnmWLJlfxZ1AhGX8REP
FfzNjtV0u0TYHA+GBFsoyTcfbpSWgFQHuv2zIY5lP4MyK9vKioECnvobhLR9syZOXgkCPXRP09Rd
N64Bu4OEk/zxrVg8VA+Qfsw0pyUpNH1ScKDsdI0/yulRUGIo91h620vxUkqFmuyINO0PLuXrn2jh
7zUeRyBqTE0Y5AM3s8RO3uj2EjLdUNjKsUWiUohhs2jUxdG13v6lazDmYSGw9zq6QhaceLFSGqxl
ER6htMV9Xk/oniGPxp9McAwNdbZSypYghLVNzMVNz35jWp/Rkn9uqvVM+v0Dp+YYbZwp6REDgPLn
Cpa0pf94LCpLSDjd9EBX0dmAzlucMW5c1FPNMhPK4OBfDgoHkxqJJ0M3aOSYXLIK5OmItGFnxk2l
zoTyJY3aaYzBjhtk3AFLGa0UnJ+vUED68OdOtaGvo12bQym2K7PMpyJ7ISgj/sxterLLbIkJVREL
QJhRTYgmVdLNWwnbpZ4vhgfeeDvZYljxR4wXPRsJDhDx3yfaBsX/k3zTyfzWP3cBRHxuC8LW/Pay
sI5m2OpV3zPuRmighQy7gn2/QtjnS8n854h1sa+LDeDhcyW9kt8fkra5H6yFuwIBGumUjt6SlvJz
vz8ytFKVOcpTmoIo7idJvSkKLJ0WIyZ57Wrym9jHZotC8WL95OsTLLBBgikQTAoT3puHjr3UQofE
BDxGeSsQhQFaiqZVj2/bNtEP8oTRq13ETDPc8Dq95kKgSvxzUis3PQy8H0mas4fQLJUGo6PUHWxo
klWDT2GGMeiE/53eyorsn0juNQUJpfKQatOYE4zOuFrKNvVerfRpHWf15hKLO9hAcphLVQG+Xllp
EG6z8EUUdJwMp9VIO/JRH6Y1BE2FJG/ZfESFlw9kWD/qP8LWjBuTo9zAAe1UOtYRMZd4XcVmv/nU
rTerqc9//6i0+vU3uFhklKg9Um4AYNNNjd3Wyh397Ge+E3PvIFQMj+luBQUpaamGTnAP+8qVlkTF
1CAMGOAWwtiyWohNjei/3i6VGyZl6qNHq5Ek0IPZl368ltAiWiSAuP4rckO927jEKGwsmLTWp51N
N2kRtxisHfzLHyB9aywlThjf9TpboJWhtlBHzEJNOEa6jMa9cxU8U1k7NeUoJYx4NKBeV1bZ0he1
VunqruUDzDGHf5GHKyS//aQ4T9N3DiyhcA1obvjeZlDG9Jba6Cb6B48/vRCVflBpPLswfA2nAfMq
Sbzq3ekcVg5TEZldAqBI1HgD6kqpiPgu1MU/jSLtEXgi9kRCvKQrss7+HYqCAO5yhR7Pwcd97z39
9yp6eOh1tHFMfRiT7QZi5BKcn3kZYuje/6MIDH922UQHW3jRmbKdVtPr122Vl8YoCg748sdyI8Cj
o7XLFO520pJwmm9TvJRxOyWZgPPkaopbqKg8qIBhiJPWhf49yHHZkcVleH1u5N51OZwi98/QpC77
WMwvpg2LVgDEvFyoOPfjYzmgEAihOsVpW5BTnqUz9jPdVfe4NHfzXVfHqRVXko0Gh1J9/Vv9CjmF
WxaCQUvuVSAzVwSI5aqulx5RVZsvml5NlGTsvvVyRTr1nuwgPGThV1cX1ONIP9S0qFMzlNTHSkls
E1dPSHHw1ltIYOabqTFEjQNIZPYSmG+GGB0kaqa8d0kc1w7HwyFAERmTLdbHEwj80zabIzHAc7Z0
ORlJvWXR6CrYxRornXU/l7EFZ6BnnUCCLY09WG6/QPzLVL3iD2HL7aWcf/iJAefVgw/ysx8+GDAN
D/BpWo86WaLxaBtbQQlQPk02o0nNmK8pCK3qctabAxjtFSYXLOt97zoJRChtW+etf1aF3uTVnlGE
TZl1hMxQe3FaFRtUQabQ9/26OUSO2B82WlXItvaXCY3DzshP0zKGYsOb3V4gJl5LOsMmAfzbYVn0
KaJ9lT94Qd/HAB36DkloXvrYi77DLBY+LQCUdJBX4x3HitC9eZUoIdDPJZLW9M1GdKuQo1FIcC+V
HER65lQpuxDoYPE9ipeC3p/auVXxeHEgEb4AMMIdEtSzqysw0fQug0G4b//Oj0kcHBsNaGSjMcU/
xrKtIbg/MzE7nlb2RmCNOB2s1TM0wl1E3LbXTINYxt61zgU1r7rSJGOQFCbbvIV4OyGf1uhZVl01
KXXGGE8ZAn+u3vhAfGl84F9hauRbMjH+nKMsh3+srN3N4llashEwgvzj5cH3ct7ubcKl44OEUwmx
928uLcWWywF55BT6+wU5KKLiwTjqdiecAlP+F8owYy4dToYED6Z62IUCcnHMsEmdWSUUbD2ybPdO
o5590DtlCxRHB7Bvge/AeazQzTS1Wn+uTEEtfxzq2Ec4sgAqgg+zqdTS7tSJMa5Kv0wR/PRaNG0z
9NHlYXO6cXfhw0BwYmwje3PX2tz++OROt4oOCLr8SE4CSGEcN9/kCZOz5tvmdjiW+D90ofASVw6i
D61EdXSqVPZPuTIcwcXblxdUwLefUH7tCCKryTUS4mfDWP8o0gIv5/lLkhjuYaDXRwbrSlQQkqVf
6c2ZbWBQQGw1hdoIMzyQmw490evL81i7Y3u2AQQA15uIOg7zcnVzXXSctKCGAtnoA99plE1rfKUC
IO186mH98C9vFYtE9//dCfgh3hhdh5BRed49wjoXvTDF/OqW6unj08cVIHbOPSqbTKMYXqGTgYMY
aEtCtVwhn4Cnc6yT6W/TdHvfGahPjZDIONjoBPJ13qvv1FCBFF2KsFM7aIX1+fv13vElaNGknfyz
0YdhVXCSzwTbHdGu7sV2iN0CVpKHSkrBUWtLvRTcJ1cctNaR4CmVFsGDvNwLFwZldNxR+nWOE5Uj
UCsfW4FjEUrue8K/lV9nGG2joy5oIWb9eTO162pcnN4YcJ1mtbD6LML9xD2uE/6Kv2Ac34a3UaeY
bg66ZsMYPOeGe70lDREcWz/D0EmAfjqT+KZPCPdw9wuY9Op2mgn9DcQkvF8NSGX80Wukevx0IP/b
F4dNq6cBfAX6MxqwB0X4JhabbNCJnWJ4eaT9ZlNfvQ1iKsTJjA6ppztkHD2JyTpmnk/HcCraxAkX
lSshD3phErRgjwxzoxv88NAUlEQtxdsihjvLTiw7uul9/iXrIlWwJthvehWlycKEn2iRu7vtO2HO
us4VTBYsFmPymDwwLrK+T+QJ5+7T5eTqIRNH6j8+F41t1VikJqd3LIxccAhWYw3DwGX8+gW2FBpw
gJycrvPWrnnXap7+rAABw4+lr/8Zj+CE9b27EMDfuNI0DZsgGUTX+H8qMjzLf/xPUii8IKyi76oI
Bg5EaFvpHz0yFWGAn9svINCHSzApVyFoeivwNDtG+jHDONPa0mqrGQEmNPIciS+x9wtvsNEOFymy
HTCGS6E5DtuiXAQ/dq9Ppk08vkuzRPyIEjCZ4wR9xDCGIR70TBBPXktqd204j7DWOxXM+X2ElU6x
c6dCY0IR01WW+oPUQbnuqB306IUnwzruV1fOZ/5fJo+X2NBhiVt/Y82HSSYTHQOY2h6GFd2sdzzT
0D6JYCaR+d0bb5DAbm4aVg7OfHwQFXSUx7YjKLZ3A2uU8ojJhnO+ZDJSiCmJYeQc8JIVaJwNuTc/
pmVeSG82s1nNvAGHKBfkX+EY6sRSiCyw7RDAwciGQRJoMbNH8AXBiMOkozq5FbWmxxTNzUl3Z2zN
dBgH5beb3X5cnz0OWNO5lvrHOreiCGxg3SYEvGh5PTxjER0E3VwzfVi06fSxtJ1gyp9pkhenU0By
xq/1EMMw9NrbVYcEYRWcIzVclYaZi8ZmqgCnGujrPRd+IaO70ucBfRQXUaWEGJngT/BEDRZI71as
98KfTZ67QRp4TcM/fUfPCAyiw4WRV5cc+8IJODOOmTPO9UVOQxUErSdClyYI2JKuEpEl0eA1hsVi
3GX2oNmlK2lSed3WofzsbndIN/fucNVThS9s/OfCJyEbTC6H0dUdsRcsByoe4K5lX6z98hxCuz0J
E4qgjiQZOGxunQfWe5A1EMqoSbPLZrdm9MIoDhZphC/8xzhIs83r8zIEdsQV7IOvmMatzUevi3ID
sK+JzYRAzshBZi8XILJo8l4YXgZdIZE9mxqYHlipffWL649dab6nvHlzMQ8ikwU5aPuh9pRQy3Gq
ozG/ofbFRivH4Znyk4h19Qlid3dnobekbQgH/z3mcF47CImFQzB4StOG0KwDj431cIamMuu03A7H
v27BnMq24hHb1btzKp48ukxoWUVwXEUWVlzaMByuFh+Sf2tJ+p5hwmiFe2I6XGfwuMWfTFkUl7zp
QBpTVMzKGP3lLSQ3knttNCuB87s7VZDgB8iudgf9rUk8WRyhJdrSGxZQNWivn/jxxWQrgZHlzqzq
sTNpwz1oyqUBMewGV81IGyIOabpGvq+9KHg0/PaJ2wRh5YLd8IPU32iZI4qc/BbT6CI5Tdk+/coY
5SMx2QyEjoCcHgBjNNmLodcjkeZNsgbbmNcyrxfT3EdxQTJxyNVPGvS4l+dRJTRAMY08sSdyPVcq
KssftzBLOPgmMOqRckx5xwsbDekrrOj55pD0Jj5OOO/Jm8lCXoQ6d/YmJubKCK+HbWVq0vLe1lWO
0lh3xXlu66j+MeUOVbEFPedZKipDBkN9etSYj673JIAjg6f2/8LuvWVIgRaxej/TMRZeTOHlL/Q6
Y9AexB6VRsUIIVIhSSO6R2Bn98ptES9U7DyQiddvLysNg+XBLX1U8G7Zc4Z9Ont+UfZvaaIyvKAK
m1QqNW4BePd8zmEevSeHA3Tiib3I0r0M5kscDE+83NHsTbMIDTdHZpley9sUalsmi04HxFsoTycA
mO8JsSmkJi7uBGr+4psDeGwtkPjvVKq0p1t6rA0m65F+jO71Qs7+eYSX31wxaSPSa7bw9R9lTU6/
ZrD0KqTWUU3AqgEmzgfkOzwV07f+oIaTcWpbnlPhYO2QkWtMGi8ummyMkj48vYsBQCmpvSdag+5I
piPZHDMoQ83TzpbdI4DGTmfqZUTwE7nyQOcuu7z2u5nd91Gh8OQEHMpQiopEgfn85QP3o8KhLvzt
kOHOfdKIzhKK1kTP5Wl1FRaFXRR8zLAf1IcTPY1kR7sFT/Zl9lIh9SeIXF8suoLjcB+/DaEarPew
jnA3Snle37F4iVhaq2BMCxwCkN0xizj5DmeP5qT2mcOSeK/1lKZZk0vPZVUVW0Rnsy/SsQSPbplr
ajTJ/z+VKAv+G4HNSpAzmS9WJCFb6Ru/avIBZmoIfsaBcweuOuap6/vAjX6Uz6uaE0ZQ6hhS2VQo
2jCUcN0/Nv9P9FfVHcDt9KlORO8QlwFJ+jZpG9WSb4zILaSQXRBD+CeG263tzJYCHhL7Ff8jhDE6
qqpjwuNYDD1uTVkeGyI5ulNVnVf9YDLM7kqQFP9HwrrRQnD5Xi/elR1I0fnbaQ9y9hgJfYm2i8Ea
SES5Z+b4WvTpR4hpFsI8PZvsd/SSGedQyQmHgRaY4RoWvNa0vPi8jC6NPfYPIKB/aKyQ8FMS6l0s
bg==
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
