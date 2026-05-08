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
ug==
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
