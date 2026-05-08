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
uQ==
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
