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
Zw==
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
