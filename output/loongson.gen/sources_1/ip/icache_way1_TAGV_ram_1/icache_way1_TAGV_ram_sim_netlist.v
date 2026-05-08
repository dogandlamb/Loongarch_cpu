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
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
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
