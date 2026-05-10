// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top dcache_way0_Bank2_ram -prefix
//               dcache_way0_Bank2_ram_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module dcache_way0_Bank2_ram
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
  dcache_way0_Bank2_ram_blk_mem_gen_v8_4_7 U0
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
