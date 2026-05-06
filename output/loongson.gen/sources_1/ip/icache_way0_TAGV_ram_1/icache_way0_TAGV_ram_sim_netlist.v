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
