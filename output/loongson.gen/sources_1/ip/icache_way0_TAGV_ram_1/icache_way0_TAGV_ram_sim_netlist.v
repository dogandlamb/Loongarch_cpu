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
