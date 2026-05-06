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
