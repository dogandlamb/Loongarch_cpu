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
/A==
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
