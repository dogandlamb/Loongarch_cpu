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
XA==
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
