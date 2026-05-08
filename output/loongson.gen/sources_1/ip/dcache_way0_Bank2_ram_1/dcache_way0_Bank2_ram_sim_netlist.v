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
Pg==
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
