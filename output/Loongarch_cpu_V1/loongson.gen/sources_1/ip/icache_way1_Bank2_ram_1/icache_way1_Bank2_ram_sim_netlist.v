// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top icache_way1_Bank2_ram -prefix
//               icache_way1_Bank2_ram_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module icache_way1_Bank2_ram
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
  icache_way1_Bank2_ram_blk_mem_gen_v8_4_7 U0
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
6g==
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
