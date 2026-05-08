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
kw==
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
