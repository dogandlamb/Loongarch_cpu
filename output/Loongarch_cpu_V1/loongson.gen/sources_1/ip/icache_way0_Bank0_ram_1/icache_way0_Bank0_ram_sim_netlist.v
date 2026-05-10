// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May  5 21:20:17 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top icache_way0_Bank0_ram -prefix
//               icache_way0_Bank0_ram_ dcache_way0_Bank2_ram_sim_netlist.v
// Design      : dcache_way0_Bank2_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dcache_way0_Bank2_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module icache_way0_Bank0_ram
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
  icache_way0_Bank0_ram_blk_mem_gen_v8_4_7 U0
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
iQ==
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
