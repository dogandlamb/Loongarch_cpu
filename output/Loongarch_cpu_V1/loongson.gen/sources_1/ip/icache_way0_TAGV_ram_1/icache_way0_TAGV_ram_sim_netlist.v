// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top icache_way0_TAGV_ram -prefix
//               icache_way0_TAGV_ram_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module icache_way0_TAGV_ram
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
  icache_way0_TAGV_ram_blk_mem_gen_v8_4_7 U0
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
