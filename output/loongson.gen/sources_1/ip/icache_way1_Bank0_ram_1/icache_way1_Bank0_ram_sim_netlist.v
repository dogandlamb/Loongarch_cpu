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
XA==
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
