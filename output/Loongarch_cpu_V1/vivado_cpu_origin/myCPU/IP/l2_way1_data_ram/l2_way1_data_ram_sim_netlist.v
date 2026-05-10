// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Fri May  8 21:05:36 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               e:/Loongarch_cpu/output/vivado_cpu_origin/myCPU/IP/l2_way1_data_ram/l2_way1_data_ram_sim_netlist.v
// Design      : l2_way1_data_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "l2_way1_data_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module l2_way1_data_ram
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [15:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [8:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [127:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [127:0]douta;

  wire [8:0]addra;
  wire clka;
  wire [127:0]dina;
  wire [127:0]douta;
  wire ena;
  wire [15:0]wea;
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
  wire [127:0]NLW_U0_doutb_UNCONNECTED;
  wire [8:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [8:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [127:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "9" *) 
  (* C_ADDRB_WIDTH = "9" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "8" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "2" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     13.401099 mW" *) 
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
  (* C_INIT_FILE = "l2_way1_data_ram.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "512" *) 
  (* C_READ_DEPTH_B = "512" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "128" *) 
  (* C_READ_WIDTH_B = "128" *) 
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
  (* C_WEA_WIDTH = "16" *) 
  (* C_WEB_WIDTH = "16" *) 
  (* C_WRITE_DEPTH_A = "512" *) 
  (* C_WRITE_DEPTH_B = "512" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "128" *) 
  (* C_WRITE_WIDTH_B = "128" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  l2_way1_data_ram_blk_mem_gen_v8_4_7 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[127:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[8:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[8:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[127:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 52192)
`pragma protect data_block
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
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
