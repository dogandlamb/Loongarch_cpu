// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top icache_way0_Bank2_ram -prefix
//               icache_way0_Bank2_ram_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module icache_way0_Bank2_ram
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
  icache_way0_Bank2_ram_blk_mem_gen_v8_4_7 U0
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
tg==
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
