// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top dcache_way0_Bank0_ram -prefix
//               dcache_way0_Bank0_ram_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module dcache_way0_Bank0_ram
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
  dcache_way0_Bank0_ram_blk_mem_gen_v8_4_7 U0
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
6A==
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
