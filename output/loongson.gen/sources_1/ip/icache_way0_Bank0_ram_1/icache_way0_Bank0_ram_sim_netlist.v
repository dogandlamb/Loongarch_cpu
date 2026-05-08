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
Og==
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
