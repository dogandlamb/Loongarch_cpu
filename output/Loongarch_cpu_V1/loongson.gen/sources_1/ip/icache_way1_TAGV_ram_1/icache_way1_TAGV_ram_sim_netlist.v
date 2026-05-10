// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top icache_way1_TAGV_ram -prefix
//               icache_way1_TAGV_ram_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module icache_way1_TAGV_ram
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
  icache_way1_TAGV_ram_blk_mem_gen_v8_4_7 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19536)
`pragma protect data_block
+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
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
