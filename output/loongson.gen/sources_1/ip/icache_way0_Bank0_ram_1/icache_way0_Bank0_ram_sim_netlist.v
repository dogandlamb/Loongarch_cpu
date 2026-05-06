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
qg==
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
