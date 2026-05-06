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
RQ==
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
