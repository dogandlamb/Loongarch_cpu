// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top icache_way1_Bank0_ram -prefix
//               icache_way1_Bank0_ram_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module icache_way1_Bank0_ram
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
  icache_way1_Bank0_ram_blk_mem_gen_v8_4_7 U0
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
NA==
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
