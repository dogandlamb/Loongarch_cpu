// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Fri May  8 21:05:34 2026
// Host        : DESKTOP-829P7GE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ l2_way1_data_ram_sim_netlist.v
// Design      : l2_way1_data_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "l2_way1_data_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_7 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 52272)
`pragma protect data_block
YyRgQ8rhW373x9t7Y3CImMMRY9SPmSIYQGPTpD8XLp+GMsSEOE8yd1tKYL2bTOnlhAwYSmc/BC5y
dejK0Rdin6+xsAlH+xfHnZ3HOZNCg/wmbD4XhKJAhS7BA5utCUg+lpDfrfhODWNEPgy1khw5sAr2
B8yRyCbH/yitiO9Ij9IyL2cFRvQHKTliI8NLn/P3OgroBMx/QyaqemVtEpj0P5vdit7DN2lOKS2c
hlkVe3z3I7laFTTFFwPigJ/2gq7hoFDsbL8UbxQauELn762eUcaXII8mHDrjbcVHjHBCORlzGqDR
UOZ8mSmMfMea6CCk/4Ln4kjQ57XHv4sO4gAgK1vVYRzO4Sf/eS7uf3Ocx4ypHsFiF0bFAw40Octj
7rw1D/kQErKODvTU8OPtMNDfk6HabFQk5bPg0sxG527n8m7K1q6XH8eRIOxgT1fcn1eHa9C9mFj2
jWDkKFO2o+dHuJkFBnAKCKGD6Z90BG2jNg/FyT3Uy3LMyo+UcJ8Gj7DF2qwCeH9Um1YP/XvklH7N
Z5eFBA+A6sxe52I8J1n5kxySo8YnL+vle1QJTAQ7OE8yuGFqvUiLbTCJq2Jbr2aK5DhQS3a9kTdM
BdYPledN1thybSnll1+7sbFW0tuk2+fmx4TN51yqu9UelWrnU9cAWIkIvvKEybveNzrpiwEKvvk2
/nY+DPX6nUBzcqNLvCGUps6NNAaDlXUaseY9Nso8CkKdm3WrdtkrCepMPaeJGIeRoLjZbcHWcCdc
pbi1NKClGcZonKY3BVNmaC+ef0LWd/vBFK2gVRuFtzfNE0egd0W8sGyTXew6aXButL7G3PTZF/RD
WvaIoZ79i9voOcG3H3Ip033DNPooZCLlRa/VA3Y3edN+rlDllH1/YT/JOE8FmPZ2fHDRh5SZO6rq
XLDAC/HgMsnZ4yh+2+q652BmL52n26IGWDgQTZjvW9axCFMSxhTCuqG2SMhtPAAnhdb2gQOv7f4m
acEhNLrmZurzdISgyS8JIJc0lCENKzH+sHZnmUsGWcv5QtB+Nc8h33X4Bbuj4PDCZBAIzZJ8G7XS
qxUxhJcJ6yLpe4D169txQCcmcrkAtDZtwhwlob3gIgtGJ7DVz1ZHLIFsntghP/8NdtmIh2wvyk9B
ECg71KNjJLzxh7MdUeHxzLIf+8Y2NMEKFZ4VuiXAI4Kf1NdbWiXS3X7xD5vMTB3GgY+OtzZWHjmv
z8lcwsm7IuebXfF4w4xSDnlq4dJzT/bC5d4722zFHgA7EzjNT89a3vr02Q2hq8I3BydoNOLePJUK
gJBUg/xngRsGbGU5llKKzl8vUAo2GOHAP6niWzvNzqrvi4b5ro1sf8OyEkmCp0OAEB21KHLaMspV
iylD6yFxiYhlTgK5USYxUzt0d+7XhOGRbhnuGnAy+XUCBDzDcaXfSloeIkbG49W2dqENyvem/NEd
d6pDfKK8mKHxpRmEiEdDmzOkgbcDj3f4afWoAUqcxmER9kC6+5tpKu0IWy26eVBllvtQ16fNQDzr
jhUdvqhy9D+C+Rzg/FXwVp+LsERXfNTXe18xd5XaARkcJIaAexxXZ1LJ6GxlllztCmgU/5B4h59P
3tt44s0ORQR4jbkUnyyJHQEFOpffJfTan26YyQVAFPk0VCOjmv8jd3ywh8jVuuv0NGBdqD811DfI
FDMZsucAKL6nb0O/k/+cxot8dPadsu5klftM4f5yp4SPVbeeSSbF5EH4I7m7RgwRrZe544d/1i8Q
RWv9bfc3nkeKtorBSVGI5ZjirFd+y9pKytsuXYCGMnL8WHaDpRLtNzzL4zlmAqTyB6em+y+uznjg
OkVKfvKsSorH9TugFCUZkSR963iX+DseggBRYAiny/MER9zU7kjtU9eVdk7Cs8WFaSlbPWJe12S7
VxDDFAQteFXtpfkuY0n1N6eJ08ejUIOgeRtPFdK4UAwZ01iNYKO+mMGKsObVaLrK8qMwWB7A3vRs
LgY8dftSplVA4n2LvaSQnflOU2oG7+hoISD+9Fc+iz3p8mp3/vmsF96RFJVA1NOpyHhrSPDw/M0m
Xn4mppeO/WTzHpLIJbYJpewd9tS7vic4yioptUjSxCuyfdnvhIpSlbswqHYDXPUTifjPKsCoxpxy
WEyIYJ+mx9J1ynap4vExK4P3/bw4vTnBOlKIAsJDsOIgfqyltHpLygq/ZKCfpdHmr445WooUa4RF
JvzjsDBGePjAmnjbc06GK+P7ZGEecrK7SgUaXXEZ2eMprofj4HBgF9DrnfyZbJBaRVMTMUeNNri9
1g74xnBK+m9OmN72RrKj22ZXMBdOIvp0gaantBlA3Mn7FfEWskqy6BWVqOxdlAakVupCdVCfi4yG
QsyWFzcTCmp+k04pHKHCF1MMYR7drdDeM19d4P6MaMhMHSDNk1oFMhPglysP6PMC+LUD36bXS/Bd
4AH/Z1VdVcxCAKoepVJnPiASAvDgTqL1bO0yiJ0WuL034vI/U54kn8cloJOsvbI9YgdOSyq/DNRe
Hqa2U2CDVmI7iwY3FVyLo1fCZ2l2iZbZWbW8kDhfkwu7C+3jgEPeq/cE8b7XiEMQrGyrLH3Ra+9P
Oo+9GgIzViIWd2eDGR+DWWxM8owJ0kJr4v90/Y2csWf0n3p3s0wSI4mU3/HmuzwmeRFj2sNrbrOY
xUMCsOktK0nn1RUKaxvj0JAHy7wXWW+zf6VvP1mdHbQtmnTa63XECnmLAjVdyu+NZFRePJwseK5N
258mU3wlaukeRZ8OuKlY92e7tdblR3tICXvMsWf4dvDckev/B3O8p6LNyYdXT0PFQb4DoPmGd8rL
8A9OACedTwhtiL4MCtIVsCELtWZd6QSwH0khr5Tml6+nOyOsdLctvh/THasHFiVoUiOnWHNjDIZo
FccQgX9AuTqloSb4kW3iv9J1JdaQ2QWeFLYwT8wvm2P+Z9d/CE5Uw+qSrQ+bzYPsp1lMLLuXOYN0
x3j7qh/oHV8VeVebgv2O0RmbECPvrrDcvj+RGwWztgnyllXgzwQb4boq2nJ69rO09AbRQpXFvYje
46hPdXzEuPBlTRl+YVLaLAo7FaU4WFwfQXR1kv7fcxVmAu6pThL2o+ixzJ8A4MgTCiQpGsoocaOg
7hpAMs5nKGH1+F1gszX61uo7/xARuPKP0FRfrHiV3prJ19YxYq/ikIal4bcZjIaJgnioLOSIRzF5
dWX8QdO9t0qn1idx/Tpyn5JOyG3p6SjekCLnwi42JI/Kc6+IW/nmMR3D3GoiPgASzvT/CMhb69v5
WxVqe114vZOZmzNWZNnVxH+iH1LYKFyJ1uDa5d/Wo5z4BjYjleueOoDFd7SlcjeojseEzyqTOnD3
HkE8yTeFILFUGOheTjaMI2XOtJ+AaiKwU9DMrfv0x3zyFaLEsav7KIKyBALXcDhoUPex3LylawU4
VXDHlVssRoG0AdAnHTcczYf1etQa8y4nJC5WX7Cd+QMvWWoU1hw/EvMYryqiMDsrWzQ6hLID+nsF
VBWhn0tXYEVtIgN+xWhk0AvS6jjEdGS6WjJiOjTA9YKpgBiHMK4KitlwwFodNH1IgpR2POe5VZ88
vLvciuCCitXXKS968QKPrUbTdK7Lv5SMFhkmG1SkQ9qqojvKPipHt8N771TmIK9+o6VqeeHoplu8
IJJwMQK2ij4XaEPOsIrA3tnPpCX56JaCXF/QN/LPS4AiWbVaB9x6XK/oHF9X1Ge+Lz4/rOdYuK5k
6lnUp2LLXEk+gYWZY9H7Re198hy3EATsSGi2qX/LuMBQCuakxixbTjNof723m/Z2InKwDgSzdU1/
76+7VRA/ygO5aTbtrwFgIFgx3SAitZG8Wr5ZA1zUdADhENtbDXzZylACRUWX5YuXGX3s3TGhRGED
3/ExYom2bpEAYnrwKlvN/dYEi5RAkwfNcPRAPDdj9ZQwFoKP6mdMpwvHKVSOipja80NZ+mmOb1gz
Q8UXpzTg7SYJbwB/ga7mBH6/jVFt8foAKLQLsdxDsb83YwBx3vn1F2naRPwMC/5vn9hC0gych9Si
Qp9osgp5TN546RDKFqM9aSKdAcq25YcaHwyTc0DdPo9jd2slEa0lN1oefXXGudjMkSKEUmJCIV/Q
RnxtLAtseynxTmI58RLT8CeU1epQoqZjmzo8dqxwYSUT3NhEoSgn7FPHOULSM24EDaiDwiv4+YGW
cbJ0aQPk6lXqTQkFmhnNVxW5z4704pDYWUdLjN/pFoJ0wI4SucVpwqAM1RbmQ6gvOIm2P7T3AfaQ
TVVcF7rdd5j68OFK1xVw9M4ZXfgEbrvqg+RDy/V2gRqBaTz+V9iHT50TUu79PHfWJYWCFdVp8jsO
oG2y7EHvCb8E73uMzWAKGvd8lwBq5SJsn2VpCflqlDdMNdc00fzofc+6vcpIKbdFP1QeWdi99Fz5
o9aicKArUTnhK1iIE4YSkHpB+kmMwjqW1H9IPPAnZnCVjPjPeA1+q/fbG5+v+I+DsMA51w6uSq+F
XYEii06QIXEKh8vpTxfiOA/WGSFdo5WQ7cddvE40yINVB69hAzjg4Jyly81EYrmlQXxmIDGak9Ka
5izM1vEhBewvucIjsGtxhOY1zXwKsvz1ERyGDzyEDE9DwzS1tOHQvFhviaVa+nqef4i8RBDBXE0u
ibeHZOHnGTd4cWIRtzPZp+Rnz/qMoCDtKaKAz5Q/spxFUXybo5ahE2zsD1Yjh+DqwEj2rOxtjRvk
ASoHAJp3R1raR8kSqp4orZxRxuodiwrz0MpH5JXvSUJO2DvolB4v+DINo8G6mUksT4034neAB96T
3dv2Gw2aRv0TE1oidJVLwxWrgzWLWGp312J2CBmE6iFTOmhs2foGQ6Pz/CxzPPpYJJer3V3BqCYh
nd8FbBziPYOk2fwu5bEW8c5QBhbJo29YAK4i2z6LwAO3gEpwnBL8ZywhufyscirVMSn9kYyjzGHz
7lAycmLBKgSX87KrJolGnzPrmmxZKwPrUpuQMQY/JmHBjFSPnYnJpVvFQSpY91VLK9kF4WrX4hvs
RbuJDSGo3RWO+zBbp9Ju5Q8eMPG/1fACRiTRPGuV3sNOZe/iCwMqYdzARzuLWMYgNU4bqgkUIh5O
L1nzDnTaCB2sMYe7/40ckdoxP8j1MNvp5P1Lwt/Zd7nvO9tcMsVoa9eXmpW/XUltw+KBYB+o5W/X
EYgGWKqke/Pt0a1B0xCV8legm2esAy1GkPBuP0PisOYVkKQSeeqb1wss0/MHLhjpeYbyDX/2ZRdz
8H3dDmrR5GGTMpHeXEh3YaaplaSBSYTtoexPwZl+9g8+52ES81krMSlh462lZnKtGsBvqP2fv3MZ
o2v8soWzHFj1812p96QMDndjaTgf/aAD+B8lZgmdDVqErsFZToWJVFzM7qWLK+Xw+mNx1vc8q/RG
Xp61rTqCOMQjdTMQ23DRPIra+reTtXcFdvbb1CqwzMkauyUpOlTr5qQROUxgZq7vLzfTgS2WPBC5
FptzMxt8UsAMsCdo5TRazB7PYnwjMuE40RwXkwhk1xikDng8ccfpGQkEu79TYnol97rqM8BVuL7C
93ztlXXIZiAZWKIv1t4ohi9CW+YVe+bexPSNEQft4DKzzQzGrvebYGs4MY/ZkTWGxj4dloXwFW5v
/6OQXGNiHGVnHRqDyaLLUZM95SrRakow8MT6qRHN+ExqgthFxxv6lBjFMHops/BcHD12NS7a8yGZ
Mx2JnxwpHx6nuQW13Xe/gN+weQ0JYXH8UCM+7cp1rtSVz8zvH15U1Ah2V9zc9NUsJE8/6+DkLmeG
Nxv+v/ZoSvZE+q+iZZkeVnMLNSwLJ8PcrmBGqHhn5ofuekZVq3eRQdQP7g9hePn2rAA2IWxvMpkF
Ml7T9Tb2HqZgMIhchkWTrv6obhsCuZgzbyJzktJnkOZTTUsaJVG7ngcEr5y88Rlhfvk8/Ht93ZdC
bCHIF353Qrq/1UECVb+gyueJp3BvQ4C+4ZwyllXDxwrpVcjcVMZMBKmBxhsgja2QgKIJzk/6nBEU
oqRr83OBB6pd74mMGYK3oGaDWJYkxjGJjjdFP8AUbsimkVhwZKG90nd7OaKP3G4u33aWkUEOd/9M
KzqdlbU6FHOj/Rw8rwYvFPu3vJT2M1TTacWzH9H5xqr0r/FrRpQopSCrtyKveoY/BGoAvvHTJ/Dr
lMWnY+hJizRitYz9qKsNso8KrIxqlrTmtEFTQpeg4hp7e0YR3cT2dra4lDiTNxyA+TZXfHL+pjCB
V0EvCNCOdVCk5VIPQ+hA4rwtH85Dk7TYfX93HwW0lOWOTwuhYuQA2s8HKwgg6MPV/YkxXHXpE/ZI
JXFhlmcCNBCqxTXmLYqg+oHEn7zXLM5A9H3hG3e84rGkfpSnYARqH9p7Y3lPc8RyD/o3jw3m2wFp
XN1vkf4BxDx0AXPBiJx65sgU5OSulb6rlMHlZrYMzmz9Ma2XJUKHGO8dJYR9id1ue3QiyxxhUZzd
3x9S8zeDXy9zp1GXQ/xvE0EOHOIBhFtd53hgeQ/ibzXQ7FNeuPea/m3RsYF+vs87+Zzch3qfQxE2
2vTG+A+6aXiwnGBCJRoDeos9NO+Fy44gtSGOUAdVqGyez6Rr3m92eKUOOTeGIv20s/w6gNCIL53D
2CuhPaqikcM+WZGuDbCMtPAh2TbDobGDJ7LU1Xtyfk2y6YNJgTSMX/4CTTFq6Lw5xT8OvYnVhfzD
VmI0P16r1EyWW3JfweW4faQ4Dx6CCaWVaHPB+i3AyH2jHqfsb3TujCIsIjwMQcceGClrgMglc/Bc
Ck98K+pfKnsVV2bm0G+OWWqIqCQsOpzwgkfUwfSDYz2G771mWN85/+MLyIk3Y02kAlEXOnWLVz+8
SJ85LSTCFfs0EYp4wHKNahXCuLpIOsbNEf7XWErk2Uj7uFVKAiBDEnrRHfe/JWBhJt1MKHlCjKdr
IJx4D5ugMI51KDTLhPBzro4zU9+6M+FKPH+z1lZiI9ZVgwfy6CHdus7dBZ2rBtUMsO9GY6ErKoCs
cQrxSApXlV8Cc7yHTX1ZbfxAqqK/SLs4Dv8mw8GEskOd08s3kRhyfsgJsUUXkjAS9EdtnSI14IQZ
Lnf+BBNHfgLBvi9jmppDbmVjWeIdEWcCXO2d77aLYrEE+LijMRwdrEZWHFk4Tnb37AZGrXKq/2Hz
CLJfdcqyQ0w1Pk8shGKRa3rXcUHEMQD5jAo2VtdKspcFrxVczNjSKTtd3Ma5Drpx/qYLXpdzRxlB
FywBnqkdR6nPQiV/EmjuwI3QKlf/RCOc1EFTSJS+NYdf4kAwfKtTdi9QwVcfXWns8yKqnnsDU5P7
O2NpwQZWVO8jqKOyoIO1dsvLm4NdjOWGXPmjwBYMRuywcxXc/94evN1PF7PmaYTpa7n9vikEqcyr
lgBHbwbsNWTuIwJwsxYUNV9uw92pG8GhphjVfav9IRFcfev+QBQsqNgQHOkICWEGGojapSq4Js9Q
3v06+/ISyBcBepHYvV2ncA8vPNjYJ2GBOmw78ocJo5/w5xCbz89lS4UpBGat1hp7bstDddWz2SFh
BNphYOTUETskZwR39bX2p2nah8onHbqxAx30R8Bl6RE4HaeHWsWew897wFGe9SWm8Mh4ooeMZozf
PL3z6SKyi6lQ2EmG+OYCZnT77kd7kMxfLuZ/P6PMY6gTht+f4XdsWswn16LsMk1HVsVSKXoZP7W4
nnvfzI0DdJFMLdIH5olxnblTg1sfz/246tah4GWpioWTvnxOT+QhLCIf1uN/0HPJVfh3vdClhyCR
1YDr1IYOFkGw2FB4221PBNMNHykYf3DXnNkSGTHRcGK0WWSJ+UnCsaXafGSkjGVukEK81gbLMDs4
pxKLem8aceVdXFK1mc5QsREnk4/gP8RzupKxRjTSxGu/pndZ4kIXtZpOcebUVvhgL+qKzZt2Zhpv
eRNSMpMg7gM3lAuCLp3SfC7e+bTXbobSEPrcVmvKXJ7XRzzi4Zg7zFKGwDkaJIXeifHB0W1v3/5N
T8TF/5XDtsa3H9H6D8bQNH5/KKAAnJb5Qr4axB41HJfP5ooaRWCeOcQlTaCj1BHsFmbV6t8mSWDi
sVRr/F2VKhqZuLQhRkmYOCLTUuelnsRBmjfCWpohVZvTu+kQQQso3vfWJOhgSJcmDjRnNE0h1Qy8
AQ9lfBiVqBb1cYf8PpjrcaORKFVz8zJe4/JjQtK8341PgJI209XXtp7v5Ud/LqLLe+ukuOSDTwiw
aeYhsFGh7aiDGv1laHumQbbPsYzTJaPtsj2V/p1auF8Ll95i6ikQbA08cQ1l9J7qvV+09ElFZvRL
YtEiRxzsntCdi95JDSSY+tPvcDK/MtfdG7TtYHev0/Bi7fOr45Iyu8+3Bo/WsF/OMKz22XyQt1wr
Lib9gKhDVmXsxQIfCKrHfiUdpkBqocwr55gQ3/fxwjT31kCIW85a9eCOHRf7CRJH3papdOdeSo2h
SRNdOYR1+sV9DW6wgyTzhtfGNqDlbIhEvrQWacGcEU4QeVKk8yKBezy+GwuV2o/750LzF+aKxNci
H34RyZ7bebY6TTHYanN2prJkokzKOITSntAIGVsshavdC0ISDunFvBly8JY0gdbsYnge5P8RSHE0
R3BdUH161z13gW4O4seLzoF+0eR2Kn4PtAOamz2GFp8acqZ0I+C8NzUyAdIHBTDhXbBzC65Sn8aG
Ky0n85X7J88dZbXIWcIoip7IN072ysx+KSx7J2pYJdwl1guIzsNLVVhBsUwiAZa1noWeNuUo2Iof
8Zla6yKOZyo7S2/skmoSRmFb7B/oeftWiLwZFp6QreXnZWfu1Kc5m8Np90q0PqRYndPeDWZS8+fM
hza7rmqzcx+kgOunuwNOTlcym02cmd0/3h/ZK5wPv7rFXK4+4cYUQye2nPlSRTeY3clPnPJxoZ6z
yiGJkTbdrdt4n1Fczjg6j76+5jn4uvQpiZM7jvgDU3ljcHBHy7/lKhCzrR3N7kSSkAAOpunx8Kan
MV8uBeYTG7jmyBFet3z5a2yhBDtV2FpAXhJoNqMZCvDvBGPpyLXAkVF3cuG8R4zAnrPIL8s0FX+y
ByT39iKW5xBFO/WOfITFaFCDuVVQpd4u/j1NOsogpt3hin0ytPZ5UiFy40hiUuOhOE8pVxSE5uar
WgE1I2NWEQYnYMZd46v57wXbmIYNKY51+R+RczoitboKB4cRPmjahgttxIMhaHQZ1FcD+hpY6K8+
tg/45ODIjexuF1yT6+5BA3YwEQOKsmmnuT/fD6cW0lnv5ajhTK/kiVl1cw2t+wBAUT/jP39h93Wb
EdTTqCq74tUNwmzfRF+0OBKirTC0kOCB1hUZlrcwftt67wL5CAVhMUZ4YvpfYrYpTTk3Rh0ad3vz
0N9r3wkeSpsX5wokPRQ3dgorl2g2Y0+pfJuvYj1kcr0UxBsrIeLvlylWEiWZsmzhky4cFLvpdwOE
5FMhPjWl+UYQ+JmMgg4XL7yNx1SzUPTkexbsc+Dit5YAdbYcBvXTrnLiVbz846tlx/VH3seuKIjn
XsLFdRVuWX3NVfKKHjPP7DIqBxgXTQ3kG428Y/lZBMmkT330gb0vHvyPL+wm1/iYUhKjEoRjpmnf
zpPPcVPMRiB/kzu314+YJijeZfF2jW051f3orawinEPW1vRJQO53zf7H5wem27eQQVkQs5DiYfsj
QdQR7zbKT+rMYmJbYekC7evBAaQK1N4xgEafEvfXcmSSEWEz4HHM9LNWzdVIN50Cbizza1ykTv7d
tCKJlRq4xBwUE+FmHTZsQjQuz/JOFtVOgduo2ROQe5hYoYhTzK0I1Bc1UzvtR3es3a8rgNqCqXDt
gl7vUmRN5doLfMxh4UJP1NgAZZTr9b3L8pqThXRQDeFAzGeUOuhOkeYPcsjLiroUR/5H1rhfa2yY
gXFJcB2h08UHlO5JGdyIP+CK7bTmuv1XSkF3TEkeRii6YQ83LS0WRjAXulMJnBbWcdnt28DeQUmr
7NN2VnYqjIg9rMYRhSsFj/SRGNrJqQk5+JhQBMYjX0F1Lm5m8kVqopFS4Rx80hCdK2jcOY5UC0FV
0sRgwR8D/OvPftJnCWxyKzj5S1idRAEMwm69fsB+fApHYT9QTooA0dhYOsuek5efmpXO+r7ZaL1X
whD7oa30WT8acGz/HWlu03PYreq92oEhCQPxbCt9by9HLNNW9+9FxjkhwX9Z6UFbsV+L2AmOceF4
FcoWVWpBKUzqd57Db15rp1Fycr2FkOUXtCKIGI9t7S+8uT2i/BJtT+Wcin/MOADl5zHVPTZpX1of
yd2Vot62jIZuRH4uW2w8LxXpSUw1zusbd9Ru+fqLp5QEmO4aMs6RyneM6+SPI443TCi9AMKcseLV
UNO5gSv7ISzwZowgXXC1sWVYlc4426VeQ+fAg6x8fJfhEhmaRUftIerqnOUv2SN2FDWA9rvT6W90
NlFv8OSS0nCYdNkoJdGOJyWpyN3rLDULw+CsShbv3cT8T5ZuKkKMkNecEb5w2On5iyH2oqROH6U6
iT2eOsGtNLWMKNKwFa1UkOJX2TE2KlMprDttvygAO4K0QU5oAxmS1O4mrjfh6S8b40crwkSlwX1b
WchmoKQ215cAVwEzQgxgcR/W7cEA6sRCQsw2tVy1unr5bfLvhHZ5UoXVsY8GDL18X6rWqobvqYRo
ZV4nSahYMORXYz1afNs3wOhx7XTaFMWDDtT94rUEH07yAP4fZ48DZ2Y/tGEftCaflX/tiHN8N023
6zlNy3tD6T8b5KKlS/k7EdXeEWbhh4BQL4vZmZXF7ZH+Vgt5B9pa/7ny54Mx7Y2vNM7YDlVIZiPD
sOhQxGF/k9VT3ySfrdRTHywJH1BdM202xWpS1Ig/qE/3Fs4Cr1F9XiX+EH5QTxujQGlE/MoXHN5P
WDwryC/N9/BNfH7D7ABcYBkPJZAbai+965czM6tuL5vSqMPXzej6OQD4Fulyml5bdgOPU9AaLXrE
OMTRhsDvBHDFKa9BpE/7Vp8/bsJV493l8484br1sL4lSRU+Z4lTgQmpca+xqVCy9S2LaPmLzXTXB
y+jzZVKxQVP/WmJGC27/+KV0PoAj7Pmjdh0+0f4n7ZxnZvQIH2r2lBLG51GkSvZSueWpUl1BpQBV
RJJNRlTifA4UWfbTIQ8KXuvDk9z58dqJ3l+U8aPmBTBJqged/yLmgKj7VPsq27iW5QqxpOUk80Xb
jHeU9v0uSoUJcaoK+PIKD4PX0uewSqgpipNz7Gg/Rb9n8qiS7CVWph5FgG5NYgQ0wL5JxJUgZ5I0
jeRmW1ORs+Bb/oxJNv4XGylVXPKxR/VQbzsoPVN5MOIeZl6kJD/BOBBhxcNSEra5UqQBU9YDV5wl
GLg3vOSBEDgQSR5wmiBoB0YtIhl2Dbi7HA7JVHLACJ5apcBe4HBnUvermzRJDOkHh/Btj8USBDPp
uGihbBFdZUTOEKtgg0SfxbmRzy73CpLAcqDasVuabaYaqoXbbiH9jxOP8bQ8vXCuJ/tTzf9CN+8F
ZFHXpV/8j1VnIg9SKO/30a/BE16PIV0ZZ7pF8PIJM43sBzjQHedLSqESGtf7DCr1kp5GNcVtBQTL
rF/TTBM2tXYn+AQIzDQmf5HZya3vsHfCfgFXzeMTb0DRg2zhJ9Ow2xTpWDevJ3nC70uwTepAXaff
IRbCqMxFA+S9/9rsu3pgO2VPduJiwhXQ7zQJhKtrVHRiQc8ULpNyQoF5O4MhW/bYri5ufK7zLyGJ
J0JHK/+MeEOY3EkEBYve2oEgdoWnrKZ++3VCIyy7c+T3fMRO5JvjYH5OGWroDnBGnxGnWltiPzo2
ZZTJ4sqzBLg2CNHtj7X4PQTBEiEl7e2bQbxT8vNKEHVoY5tpYEp9TgGE4PKFMy/LZ9/bLOV2VTeK
VdwuQ9mdWH+STc6YdCsGXyIx4QdsaMknT3XV8dAS9utYBN2v6P6i2cnnWK8+B3JV58XAcVZN+FXD
ayRFKXqW3sqSX9XVsP2Zk96AMkNZcMc5e4wIT0YQuQ9pRYlClyRcgaSuLQfeR3zZ5cuIzI/PVHn+
JOiuJKZ0ob0vb3fz01GAOf5ZTchhGAjiMOcJmaSK0wV1wpusq0CxKr+YUqtPz3o4EEsbvATW1ev/
rKrCyAwuN3rzdVKW1qKQHDS0GGfMNgaN+Z2KjF0prQpWzPq4d3lGUATbQrtjcJNLPyNAD3ckg/gS
TIr3X/CqwMtaeRtL1RwLClSZhNT/GtVNvz91jZY1UL8cFxYVq7RnJtdKSQpuAxKsiyhuygUnM5zU
q1cfI0HEzjQwlHpDYfHzU/ncN57mEmlKtp5V8WpmcQthVIxPzII6qcGwei/O8qtB2q6EFtszCbMX
NQe1qdxW/X0sQlsIsu4JTQabWGUKatD1VDgvXHIAVb6sNv0siFkROAHRH9QitdgPJ2R9Ye8vIkST
rTiQ5MsUNg3RUsLvHEwnxzTbJlbwdtVmVM+BALeuKPGKifemzcYxTugK4QNfg8jCVcFTSIOT8Nk4
Emm2WEyvpjNPwgT49ts8wlHdwwXXvZQd5Cc4Kc1KRW7T7b6Rsq/tn0xvRHzNR+3qHne5qSdGO4Iy
1DKVp49QlySqFNrQ8RluWeFxypzrNJFUozHEjB5Sl7iDQqtGybtCk43Mk6+oEeVphqv39sw8IPGe
EdbrK/7J7j0fH43BPT/v4ezyFZ3+MH/jwZVGI3j1VOPbCM7flUmIR0UBlrLAnZyCGo3MTZ3KxfxS
3xCmc7MgWg63oi0GoHUuB0w2+QghKT4K/s0pzwtlQ8iGtSyIpSQ9s/xzh6Cjr10uMy7TSWlx6Q0g
R5xdgEaUm8yEdnOhioOFxOvCFirNz02SRYtaXCsjkffsPLDWltQSPRbgluDDxSBUEWR9nvT4yGql
1qm7EgnpYkumWZEkc1b+d9w/e8+A/o9xR0cuK7NhB3IadRQ8SBBK+dnyeHloUmBqP1MSIFFLCMcu
X08Yh53tKzP/di98RiXYHZTsz0gd+8hzNbTE+cq/6jEqwFx4BSlurJHyO3E5s2s2FTQPgzj6TUCZ
yKp99s088y/ubht2eRH7jWK9g/odYAQUqcAM2fPMHJjpyR7UQdamZm6ZWTR0wKNO/DIIxCdDiEwE
EZI+xJTGk0X3KU8+5w9Z8qsVYu2JTDm/OZiAmYq6FJbcrz1eJQ5NTlvcLVydNCXXDK8BTmDUsDwZ
84gwhjoRVheNs/JhHHgMDRP1jq5Myr2swWt/CYXJr5WPCfsUCA1QHnlWfk85Yuke4znBL1rFp4WG
mErNhyD6Qe3VSbF15DypUTbCZVkPgDT+nSnTdnAdW1jpy/ktjWKuAMgAhsdmopXau760670h/BO+
+phUqSpRhY6nyBUg0ScuYL1V2d71fdPGjKxoQICX9pynAbAOIf3/KGgtkWqvRMof9WWuKuwNY8gO
wbvkNo2kePlHE2Zu5yvmcY+MahgCfhuB340aVqx9F/OsujQ5o3gMfez4+G0wrxuBxyf3aOQWEYZH
IwCgiC7/E91z4UKtXTRMk1wTBzdBaOeYwUWFrpWExc3/Hn4PTYQD/WFQlBRWrDJl6kz+G5oeh6mn
SJqAM8XZ61LtHiO9jqHu+06u2Eu3/5i1rIWc/5mquXE/+XyYxL7xibdL1c2/QvMrjTusD8K6k06h
JFkVjmXZ1DJfK/gXm62BYXWmD698nJtJg9530CCVfvFbiJ0zAwfib+5a62qdN28IzvHiJbLNaRzy
P7UTj2p9ookxSyZPw+ZtJNi+Vbym6tso1Tc67Js6G9JBT2OihWGvXaZieEMs6rJhcXqSqAJ2aG10
xCCWQRkipF7NTeapVyflqOLf34WimGxwtoUNxiERD8u4BX4ZW8S81tLlbH2nideIoc01jnfHh1hX
e4GxvNxExDfyK9t06U5TGkmFa1BlIWnhfE7J0E8PIQ3Cz+VV6w+cQuljWuYEv1CpioN/bqXXKYTq
usB2LEn95lturd2+jEPCT8/VeUveDNnMnREWvPbFl/zuUszH7qYURosLed/48CpGZ3JxksYXrihb
DY+fgXRo5m1ubqMlh/e9P4UlvUEtdbAsP5eEd6KozyRah2s6xoY9goQ6mU/PtvOa4mI6qTXUpcg7
/CKmuS7tA8N+ZKUPZmkXtvPPL8Kkvjwu0MZbultqkgbRIoSJqW7YNlealWWeMVSYTqz0SOekH/YQ
HweoiGYUXUPrT4gjVXglePLNb3X5HgkVV/T1D07naolOYVBfR5UJc0GnRpAH8COg13HRzNwF0AC+
0DtS3Bwe6RDF1vkxfTAO7alZ+Lf3sPLexZOgeQ6Hh6gmxMheOgY/FgfE9F+8vQKGL7Ifgl5I5Dh4
llzyRByOYztKq/aqSomQIVL0FW6Ax6IBEsPFUaevKOYfjytLKJHJljmDgvr4Ig8aTBii2v69qGIV
xfJWnN5zH5CpNw99vAXUH2emQdAWtZ4gcb5H3s4NXTTFI/43jb07pK5NHEoi1g7y+wd9IUm2LtSp
+fzytTyy8VpP0g2WI1xHjj7GgoUKzQur1vCD4ljE4Ri88o82GOSTwQt4NlZ3IrKuSOtbrvU9tiF8
hNtcSrg8IaXySiVmMvQKLH0TpDX3Nb8mhOrpolSZ8NmYHKhWw8mJ/la3TxDgt95/b37YvgRqSu1d
3CnAcmZPWE2ndp381b4T+Wt9p4uYnV6eo1vPorMsn5YRlaF+8p2xkWh2PM4fjgLqL9uj2YgXj0mT
hAVlF+5mkiV6FU4BPUMh1osxokViW5ZuYDLMwTkjSbb/QxsyqtlKJXv5ykhaFbJJ/fHRS5Psyepk
bzR5zxpi4qMv6YjGm+wI9mPErAQnJwOPVTa9gKHxpOtIGviTwcw2+mMwH4NLwmlxlZ1P1J9z46Cp
gDfly99IoJlfdhUM7YiGRvev+SQ8qk7/P5CmbzqRzokz7abTUDfYKvgfWIru+NMshrAtyBGMEAzC
o+gH+AjWBn+2CwTubgLIu+8HlIymGuzjorDZqHfD/6Z7+6bQYQRwPAzYBa1LCmT5oVVZyx2gBjx6
lmehL57N/P06gsikRmoS2/zWFnWqoexdtjd2VIYxaRq+Fr3yUJNmKfh+PQKL5DIUL8gcjgH/fqhX
bq1i5MCffTLy9HE8os106NmCEnpyWneXvdBtld7CvXTAzk/0ZN3JluZVEveadcBw9Jojs0/09ONj
I3pwyqWgrMfKBt88CCzAFdI8EO0a/uR8Iy9ESAESJ45iYrYUxMzogL+KBBvs9QiTK3xjNnsyJtUQ
iyFJX2jj++AB5aeX7vqixAqcOxJHnColDZULPt18Bca/ERh58GqHGvfQ4Wo6JJn/3TJG0sPxuJDy
tzraKspMWqtA0WRmFahk7GiSF7IDB5ulgsn2PAZel+ge5Ioewcs/GBYev9CQNT7wmCiH1flWipHI
vhtgavULaxde4LhmdjtfsnrHfRBdpzB85IYUZUxJ1bmoTuoIkll8gV/uBpc+W3fB0J5UmvwU24Lb
S83gs4fEo3QCwVbcvI5rmFc0eLyXco83W0e+zXlOxo5KymZKMxvOiuta6xhGP6okFoGj1LFgK0T/
Cr/GF66qEfCvkbJIHnbnmBc9ocqR0I8paIY9q1zMfZjSj1EZF1R9LldkwYgQ1Bc/gMXFw3MU2czc
BpTCEKHQKhb7TWPNn8MdliIFNqL6WR5U2lD9zrYN9Y08uRi2DqxpFJR4QEPkPd7lBNoOYJLa1zd5
j5FBeIlq946c92b4bk1Au1CdHHZghy5l8ry039p3fb5b+ttatDvGmCIRe2bPDorH9x3Jl6P+WPxc
o/BwBdTh+BJdQGp1kTZDGNYYGjusb1yLTd8j/jEb0Btk1VqnQ2MvYQXNWkbPB66gGr2B6lOpPc+W
ycdqKOfuMvM9cQeDGERMJmIL+euS+busz9YlisWq5z9etrW9ErIm6KnAVfiGDRKUra08fD0bVaxx
xC6cfFAIoWI7vWhdXz521s3stHIai8ixjEUuToJqbygNLNMSw3tui+uCVStZOCa/63xpi30n1rR3
C07YtGTj78PVyPAeRIGdjUpCU8uoeEQ4m/yWuIzWFL43AZbJXbsgqv0SVW9p+ID7RJqXx9dqWnoq
zWSXhOJf4+Plxa/TUIL3fy/XkrKGM9UeLoziwtw5qmm5UjwceHG+WsaD3RRAj1Sa+FC6pdD7QP9M
EfnFjfigoogt+FI5XRFAMqfwMXSkeXI0SgvvjRNy03EHEDjb/MJnudGd2nosHD5xX80Ig5a7Upfc
I3cL6OdAsEe/99QRKyx28GH2JnX4LE5JsJ3tq2EZN9dimvaH4CPhk8gsuikVmCnvuAx2dD95DwJ8
TfcUnsHvPHogYZ79+8BgtAJlirk538pJgBa+qdvOga/0Txqp51ww+TVB6KjtdALfbwEGG6kPW11j
MEiLKfOvaotnuwZ2/tjZA1SYavDKa9M5DVsJtcljgP0dWeaP3/8UfftPmUxCWc4I9aezw89If/w7
oZiw0oIUm1mPteSAAkmC818b98bzh2YiOeH40hbkEhkj99BIeMAcTomVlQRir5Eb2TuP0EEIH06U
vHlkVpj1RNSW2trOKzXoujoEUPuLOdBKOq3jfDKuh5MGe8ko/eyCVPb8iNsqqZCaUiCJ9KkLYDOJ
miKt4iJFKYYkFyQu/XnJIJ26MNLN2OijXzWtHuDh0Mq16+xyE0oqZ/qm6QKF3Etkm/ZaplnO7ObH
b28kU9pg8kLDObu6o440M9ZSj/5s2aVmv38Vyy7R4e5FU11mawQ/vIo+zr5m6uKbAcMjE46ZGFjA
AgzSdJI1FvIWSD9mVBA2mW3YwBTBdgI824G/fiy3N8TciHtYHqgFMpdQia4n4ShFx5OZh+hDi/fB
Rgh/25YBf9DUWWU/3cH4c3GYoddVjhNAJNXwH6Lc4D6dpi966RHWgjVQYID+FAjhWKipgN0hcHWc
4MxgCWBFAaCuVYq6q/HSAJpM/Vv+MDQGoZeukKywl/3x2G8WTF+6QbNi/Jy1y739PLwRbIJJFlWs
AnrQxj/BxWiMfuvc6+jV1X2QLBhz0gz/a/jGcFuUCMV4z1xL7qdFKtLN4YD+8OD4AuLPHMSXUZ6l
xfu7j8BmtVmaw7Il1CwFrpR9FBAPeKqpLWsAeM02eMhUbgA3IiEKGXtik5eImITUMtoozo6EL6u9
QlYar9iXXfwWlC8INtTe4LIaiw1jpuf0sovpw4eDeANytvTtrNGXY8dKQvCa13LI+BPbIc2dRYNQ
HVrCZZdUtSPQyRstbTX+nMAbB14VsTCANqIBW9n5Q9cOlQu9PLZN0JxUI6lnHuxK9oXnX8yvMr8G
rG1ysMKP4dHODdYrEr96crG5xFIToeaPPrcEeDuXusMqkUxZX2VKDKw604NFOSwZBECFa2ECRh6M
KP4CIjd1zla85uzWFOR5YLKruQb7Jqb8S46njFdJIAcom5JAtM523qd+94gh7gT9W+/wZ2Hquu7O
D/Zxu1OzhdyCK3BQK4OhgaxbqGTQNJZNVMoHD0UfdSLcaMllK/QwhtlDKiWjlJ9/XVZeXqIVU1cw
xBGJMaJ5sn9ACayQkBQWU663J+57u3628C1c0K9ghlJR+5xMbSTPI6XDt9hRM33ZJeZhCnuie8g4
VNEbyl8TJncz43wbpH9AGVoPLPoNSZSOA6bjrw2N1C0kRx31RSeUREuXVuULzwq+x9Y9acYFGFSl
yaDwEPmyYiUWqYff9/203Hadi2ce0TUpdgJujAChWxGSd7Pb/yP0+YNCBTFmjELRH/P0jcbQH38O
F9Dke1KBQQKvJRfmP1ppnpxZZjLYOXPd1mPEDcyjBlGhIhtleFCj9aov4eMyBFY/BWhsZ2sQPVie
udxJeOoxoD7ssxgRxu7B1V+IyiTGchdLPXrQge8dx2/k3pUHLVYFqnSXG/LC9uMw4sNRhDAl2aFe
85f7P63TfDUIGZyuPp2Lovnsa4nmKYpbLmHwRf4T1zjCIEuZJG+uhNh7iYePd94L6E7sPA2616Ap
KXDHbQZ3N8WC2jDFH1iqdCsUPldM3y4BLOQWSvYnguntI36yt8xYeyYaM7dEru6SkBawJTNNwKtc
ohgFmoNdrdsz3xV7mXgH0QBUgULseECTQ9udJlcnxZZ7S4quYvdR0d/18kD1czHGNhNxiQWq6kgx
ZqFle2FyGuse1DJ5UDGEMyK7IkV2egEJKuRj1utu40T+SDKzPYH1wQSKS7+rwzLsvU1ocI0B+KKL
f7ZsstJyH/vstqu7jbDMtcHEVp6UeCwWAIWD686sd+r455s4sNLGPVXmMiaWRBleUwuVN4c47vnV
l33THa2sZqCMnKiSR1Qrsyc7Uh+3Fho+mO+AkaAZXxQJ3bO66OhTzK1ptMkMPOknu3aI5mA5Irqe
ep0DCUA2+HAD7ftF2jxC2eAHCryXnN5HiENsX6L1rUVhmzGQYkLVXXZ3wzGTX9HjeCXJRfLNmOzK
njVRt7XLGhloiGrz+rTJnTY7Qo1PauJVLk3AgUSj1P7dytvX+dmvUPqwhxbJvn3oy21kE5MRpSoa
BfyuA+X1k3JmFAkFrasboAGTU9cJFQxsjsDaD0iKT5f5apcGpi4sWROlqXooiTR1v5TH+ZPY0dIz
y+H1VndP6bASa8pseIA9rEDtuyYrn/mzfT3CFeqnqIPKmhcllNLhyoiv9EhWJruey95e+p0UZboX
DFKpN7LpqORBy7dtQj13i2Vnqdr3lsFG7IlbCjzSbaC8Z0pzKillEB11tpHFfD0AkvmKsmaI4/+H
MSALPd4hFe+QfhOps5HpcHEvdeqKpJLFV1AvK/tWk3/JkMyLrIQpzxjqSiHnoFe0CEquZpwcDgWO
AJp0v2an8zlVSEDq38dr2REDsQboSDMBBd0rkUqJQIn7Jsfix1/SV5QfP2AK+kyWvVLHBckc4cSh
Tid6bZVax/syQZDUvfESwcAu/SAbTEn6nysYeVR4xJRhoB5phMRkNPRmwMaTn5XsyTqAJF7OPegf
TrYfCKjkHc3cxAsoYCDjGpgHs+uQKM8Y6RjRuyZ1wuUcKAM/fTVXmS8u7infSkEFpvTQYhScgI3i
AhOJtT/G3PlsnCPIoeHFUxqdQ8pKVnVK00dvml17gQJB0jIdoJpPd0/9ZXBKZaBvE4Jh41tmd42x
c9RiivVFauyyByAtnlSF7EqgGxzwBj/sBkf9KnyfsK4D9qOI+Ck+AZyEKOEoIY+uKXeAxClDNIyg
xTYYHkReq1DlLTVUha3/fL4xkWZjet1Ir8MwLuAbQMHDqczEMhPSm2k2kaEDG98/rq/qoXpIpW8T
59SQ9RsIuveIyDYqTAFFa1koCNpnbIF+mVkXQ5DgbHRAfGwnr6BXBHrAIRa0ZCwFwIQLEqmXjWPw
FAI+7czpnX33VY7x1BccU2s6vMZaheNalv2BoCnMgON6DtWtsSAErmo9EITq03+J2q58wy71GQs0
kXaIsBHXlcCIvDdoSE/HoPmAIqYIWPGc0PkDEh49qvbrFBSGHZc13DMphPurZ6nnjSJDadRWEITk
m7SxlN5SiFleLStz5WDipReWUej6SixVGCla5x6VNE+gDXk4R+U1oFo+sScGafLmOSYi/bZ3w4uv
xYOnWCHQrTswrxb3OxfpD+Og4s2eaCGe3OKe5NaBCl7dw3q2P3K4QdE6JiPfXJg1tSOb3bu7J9hf
s6prIVsP5u6qteDjK4sN6P7lBTz+X8BRmm89oAi3HZOiuQJ3r5gRCeSayknyhdlnY5HcJ7hIxHzn
L8renNCnbp2Pr87XA7Oph7U8ADctnMmaAjEEE70MqT/WLTB91x9yAqkDRP5I4f4fpvrSS9teTBwY
v/wNmp/rimxF5rGdSocfJgwPgF7estYxuSZnLQ9hTeEKOw/KZtVXsbk7cxbVACLXbTWKtxZ4OUuX
Rs8Hd/PlZQxWrKpsxRgZcp5dZt3I/xoZ5QVWX7aaONLP3DHDr4I4riWcXx/Av5flxB8/x497I02c
vX3L9wY1bmYGB3cNyD1u0fht8u8Dga4Qs04w0pudoNIGQGJ3XyZXyOjbWsC1Qcj0M2sbPCsfF1x5
MprGIHP6gd+d+G66jg8C3GQNK7ziQqSbFdvjYqUNdYoEVJ6T0P2Pr1TMnvAhmPIw8/m2rPWIkYtG
8TnFTjX1MnBFQpbIn1HGMgnQQhDo1B+7443r8HvAJR5GG6efDZxUZGZWEZR8IqxRGHsoaoH/T9YS
fNJtTZdYrI4tcRg9F4if4AghBP/gdaN5Amt6kGVUhWQzJYiKosoXjh7AlX9Ue0oqZaRaqz8V7NzN
vaRjXe4We8u1gOaEqYHe98VBqpBwALe9P50ntKk27B0RDsBooKvEsW+CS49OcTQzCw4mIJIMnwlF
F4delQe0slYCkJ3u4E4wipnyVA5tHTGcCEATgpVYER60/v+noz8GDV2a8o4QLCtVph8G5Cckb/kA
+/Iv/9CNncYSZZZBqtnkngVGXqhXR9BUTWCypi1GMKxOjjnI+XLxK0og7rqVssO67CpoHYVWNhQc
0yMfGha39GFcEBAhmwpRgeo3t04mIwLlgjui1lh/SPywRRcYXuZEanCH/Ipz1Zm0W3FExZN2QbKS
uTMP8TtcZ53vviUeUc/gzvhToTKXIfj8VWXCZWzYn22jwJkyTCvE7ku5VuTVT2JWRRw/yNxNuxDw
rIDzXbUqeVmD7NmZH7qjxAvmABH/7qU3tXH+Qcy88v09UIuKnHdotWYXaxV+99JLZdFypCM0BXuZ
ap7dHOOIVBNMPnILUsAHQJ1N5K24Sd2/Pqo1EjtgygAtRhTSch0s9iOZgQweyI52SZMw4D7YBn5F
jjwDJ9fhNWUjPZisz7Qomgtt1lDZef5UHP3rihKXMzX3t1z4mjs8p9dOmHRjXGd37zRrdaObOfjw
HGoZhZOtXp4MMgdW3m+N+7t21idLbTVQ8uO+B0OpowRuqnsQJcHnYm+8BDADMwNKnsy+7Tt60jIf
WrIweQO1HlDVauxkJ82THFV89qkAfOBM+mpdY+cT6ivEmy/sglqcUsTSt9XSKUZrkcGNsEW2E0iT
IjUZSuYCkXMYy19RhBEc/wi5UhoBaQ8zKNTm1jpjxNsRMeOK+Yr5YruiS+xcnQnppNQ9cvviOh/K
EddEjBbqHKD86cnUYDOTIFc+rw+px88Yr7VPkfMfZfJYTqQ1cXonz4MvcHwBjOpTAcQmEatPSUQj
JJtTkEfI+3/tYIIeXdaD5MlqTD+Fl5EDXByKihudsTQoCb/EZfgkO8Z8vDjghpUhpn0sU+RAn8of
joinj2q7FzzHruUGIZH3XXa4RYhYI29+Lp3jd0SSLKxvxVyrrD9MEHpzFUIF13oyJPsZ3nqoVNNL
xF0LTzxYjE/nBphcpasRxBa+MLmhpAS9LsGMuUpP+Cj0CoEyDIxAOet/2D+Q47Cik0ObiCqIa3X9
U7V+gJ9UxdqjJUVh0rFr3Ira9/kOwruSR8y7HTxLXJtfMDqcrpEHWsJk1IgieXAv3rEN79KUAeFJ
yw91Q8vpa1TUXHywZ3KEaTHKtl/197gQ8ske2oOErgkixJTGqTT7Y8FbdnrvTtAtG1pqENpc09UK
hTEcp89N1PfUcHxCho1UYlnSSGu2cuhVFEwSqO/WakijDpZ12kG2Q5zB2WgB43uE/BUfF0yOAAgc
ZO+UCdbCNmNDiPNYM1s8dqnUqKqsLFaFxOfijEzXijBsExPen0PehfNEukxzyCS+4PTZdRVZ5bWR
dBQngu8DsQbK/8PEcs1IGh2maelmEA4C7PMyNpqpVR65Wh36KynnHLHJyQR5vjAr2G3M0M+ljEGV
xaC37xdcytVJ3U8BxudI/Y3U5pybWa8Aliu5QryuwjrZcGREnBRP4YavqdO39u5vnOFJXZoP6Shn
zS0+snjXLTl4lTahLdFeXl8oDkOa4GSaMM+xrdmOURvC+YH4enl0B1Cbh5P+E+gljUYjGxXtjhPP
py/KgwgJwDVZRARWp/hZdTiEX3URVTcpH/COELXS/nVc9O/XmjXbfrBx1viJHszXh6H2F9O9jzcX
8t3baeffZ1x2xfWkdV26Tf2YqqCM2hZryw1IbLN9sM3XIWPH5TMz/GIH3Wk8ePOhlVOlRisVBGga
sAceuZayXAXHzdgH0Q59euNFiBQR2Nk/uDOawIWAG3+yKOklHs0aGZxdYHjd/Jmu778gPZRGToOZ
GuPH804GH475nkzvIdIAKb6qQWrJfmCD7tsFFyRwf8uiKj7rZGcu9WUdJOu+d/LztpqjzjkvQAa0
Jn416Ig/tFNmbyukDzCwXtqGrB2b0X2dPNwVvKtRHVirP2OhAxPB6tkNvVvuExsczheC8lDqBkew
kLGcRDLuvb1zvq1Bc9C0VB/2CaaQ+XLOhl4+fZghrG8JcnjSkxnwBjCPjYV36KZNnZyE/cBz9T/y
PvaitvJkywrWx1re677F9kyvWh9KPWdsQYboIl2kUG9kCeWjkzGQbjWEKbWQToz4dXJ+BFGWQYDg
pMuZEBngLGgAbjer+a7ArcxbP7fafS7K4zGCuPt2nn5I3vmfokITDnE865g84+At6WbEqOoOvE9J
afZqPdg8dMOciwlaczPKGSeuyBFGv11scAFmMdu8iygp07NMBxHuutB8J2gQN41JxCwmMvyv44kD
pEr5fN6Co6s8SMqfbBzYUOced2vOGItWXamOzmsvgJvTfa+V4XFIEnF3fUrnmqqE8n0xOlepXRNJ
ldrIZjhTualZXLc8fs0e9YnyPdEehZnizEERlAGxVJE23Ms+PRkF5chcKSt7skZv3NnYXv2rOxdb
qrY30fkCJnn3YNRsAcgkZbHEiEiFByHFKy/BI0FyM9AmDWSB3lqrDFmSLcwCkh9zphT9GaEUqa5k
Bf7fVs3c2ciwcAhVK3wMjpqqyU/J0KTcisAGopyOVWOklcRKJeRYRiyW/Jc6hsCAJoZpeZEtJFF3
pjq6O6A3J+6hiZOJmyTbui83nE6D6b5ygQmp9vqZ3X9pVRYIc3VMDhaocvt5/x78aE5Pq4qFx3AH
N9dtwiaX+KcasTvwyY8FKYD8YD4Bet9p/EoUfITjNMYG6o8QkqLCq95+MNIZgsmLdHkx04ZDn+Q9
YqehX1O9wlJWAO2mr9868g2/his5nctmPUuhQvpLZWhmePTwGRtay9ewCVEuHitDyfXYMEbLZrZi
+3oqIdaq/8VuZEF+tgNvUIJed8VwDGhRpWWFFm0Peavhd4mBhjtdQL+Etjpql4BlK1DO81LFBVwx
YHOM0Vv7EHXK8c9Q923UksJ6/MyzW1tYGCl4YNw8Mh3ZVxfoDdOEI1EB2tvI5n7edX7G6gzMUyld
q6NIdIgvnPyHF/lav3hcN5eXXyOzkRLUfBn40mK+Z7CT+0Igi6o+W5LWtaT+vK3ms1WDRXYnENT+
Nn4GqzCNHNnn8azF7/a5tqD+IDDSt/8XZolLQC+7dghJNN0pryG/iFXvxFDFGPaPakim7QwgAPf9
e9HbPkg7DHNf1/hulxeUs44z/s/eeR/NxT+QyCrEWjdXuOCP3YSyWzuYJ5WyEfmn6OZ+BGqJmZHz
6tZAaAYnzqS6DEfHFcY2OQit/990ogg/FZE5LaKf/LDjmfJiYeAC7VYHdT88oGBM8XaEYlMSGOtK
h9gU1V7Q7dQ+cXM1w2ccwmS7lkUd2RkKbQceeoCQmlMTIErDCabxOPBVhO55aO4FOXjeZQLHfjsP
rkbTOK9m6euoXRh5NJ0+JF2kiSv9HZJy/91Q/LZHdtWYVoLhxoukSwkQyIwfTgsvB/j7OI503W66
MS0A46D8vOH6a0eebmNqz3wYc4yfveBR8+oeMjICG1k5jFyl+4T8qEkNzi3njezCERIa9LPdF/L+
hcXvswo5tkxlgYI9qfyPKX+R9bsN0rXt1wRuP9p3sf9r2LDdYHyi8mNrdHZYIBuONEncRTXJ6wGE
gPnAsROhLMW8Uftb+D1fRSnE8cpWDvJ8WuDiElPIzDmeNT2vGTw+FpGvRJ0sIC+Y4lBPSlZvCCE+
F7lPcYwqGaf0rSuxUTTSbFiAZHlP5nbaXaFRFCCtYyRwhzf7BHFlkjwf+utAT7QWqM6K6g9wQ3+j
VBquzGJ6UQ4Sl6C818g/SIl83TtR9Ebglm6sRH9DJmIU+GxHJv4ChZO7z0n7NBLK/sMjVtC2SHAj
3aIzCa0QMCYnXSyCAhn8hpS2+v9AEPKHKi7A9qJi8I7f198QraKhNnlxUI/4fbGnjpaPTBn7IOex
zXmkZy08qkXON8Z0Ogxa0c4kKpDL/kq95b/jYwnUNPjfUfk8N1PuNfQzdWRtiKXCWtGgMjl0UUbR
MsdcRkD7wLiFDvomDTFPMXgiiZ3lFeMDtKjoQrL9wJv35DDJS3GJD4HKmuZtGNakuB5UV+IfMyA5
K8mn8tkchlbILdCKbaFyjuvZ41goJdGTM63Mx69mC0KdZLgF+qao9rrnHogqPSzFvBBJenpqpJuz
ohmBeruQTZg2HuG3aIS2iEPYZpVtv05haHjBmX9S1/eGpLs+9x/QwYLF2Ftu/x2pyNEBxK8Rnl4I
f5Ydr3d4/SK8qnZC4iaMt2ya1eXH4RPGkaaIQ6MHmN/MjhX8th5huJAsmhFqmAcGQKuG25+fKzo+
YoeUuZae8gc5H/RiLOrSFGU3EnvyYanKEqhpJclsE8wMpg+ppEiBru6IY39OfVHdwG8KGGXllBNW
h7194uRng/UBsWR3skY0khX/7l36jIWBBAm7JSEW/1/jEBYKRVHeogqRv1OSuhm89lJoxBmivVyt
crOxn+fqu3sqomubVZcj2d6wItrlZFinuH7Rf3BsTOZakPcnUU2lprC7Ah+AXO3nETQRHqdxyvpd
RQnmy9OgZ7KIJF4TpPhFMCvtqXaIrp0xVVg4rcRL0cURte89etpcVSZyCNPBI8ewIaY38D54BfTR
Oi3zxM1HgjFLNN6sk4xYnbEMtQesN+0xb6lfpLwp1vAhzTi4QWrC9PZ31YUKjrMUoI6vxqopaSP3
3V1e25q4f5p/hUo0MK67+I9e+LheJS9714GEU73zePMsevjyQuVOJWKl7GzkmuGsfQfwH+9AoLbb
D7mYLCCRGRQW7lXB8z7zF4eoUg4AcegGweFjOD8x6iCJgpq+InFH0bvJOE2SNrN/RwEJcD6cKTpS
iNRy4YafyZkLb6XNxXMX6cb+FA4cBfOkvigjk/I2+5cj9y47pHs4BLNlGY/yp2GXrIA4Aa8kFiRS
9vuk35thNYCs6a6/TAG3FKffx8+RFEeDYH2zH+YK1ehf7uY80S95ujhOeRpSXTZnM5RKE4CKKrYi
R9afhtvPtk+L4oGwvbNIFG9PpNl4f8TBZiXgeik6Vn6SFHEOc0ahu1NVM4nHGuOgJAHTsDk6QzFg
DlGhje2/l1BcB/cXWRPvEC4h0NZNsOzWYdz4K0iu1kP2JscYkWCZ+hRtMtuyS96acyPYl3cP9k29
UAo1tNiQwrAlmxinIC4tifg/e0AuSR3c3Z+ipL0E8emdxntfuRHjG8XnV6+hlL0VFxlgaFMo6GNt
J16RfEKsKK3QSbnsfHQ5B7is3+VPtPpUovplNvJXm9JTwzFZwdOXqbngmufBtvPEexV0cry9nZkW
6n21k3UaEVgWlDQjt5Atg3kK36JWWWDE0f6o2iU6iQfHzfvcloXxdj+Gq1nbvQa68c4tzNWv5lSk
btSLjYdfMI4+enddv57JDYxd28pGkG6zHfgbawbI3RQiQaW2RlJYFZa2SObjQShoLEIP5PyBT0UZ
vEyOgGOIYZLtXXRxo1EjwiYPERiG/YqUaZOzLO1SK8E1o/NQGGilAlT6OXbajoodELCkJvFzNU1E
xwJoXXto56589LjVHyfkeEufmuTTCTQ4S+j29OvkBAyUHibfK1W2p+6x6rDkzC74MNmtaYvWwXLJ
3xC/e8dIcBS5negjNK/wIkVYyXiBZcgd2OWIUlsf1AkWfdKy2z376RKWRGeekvtylMhRYQcmRge9
qfPy7SX6y7pwZrKwD1RUxv0QWulZWoEKRz0QxWg+9k9bhll5NDDlWUGdFqKDHyF4XHq6mSvH2Zha
uC7c6jO75NL4SdFVh1PYKkN6jtMWuWRqNBlFQxY9IwOlJ/oeiX6syeAHhJG2c+4esthy5qc6s5T2
aE6MuZ2O0ig02P+tU8OF/MKFTGwKiOEDP8cCjGZarjE8+TNhXtETgtrBjmCt0B+p+UkuRoEQMaA0
R85aiftE9DVf5i1oTIjwLEIyvYCv/qcYzv1VxzS+41qCLJSkSmDKM9zV30jyMS5YeQQCYbet0qSM
zNg4TTapLMNTTmRhi8PGAyMWAyS1DYsx54FZAQprp+C2vzZ2jrO+haol1LGd5irta3TOrpMlq33u
+Ipv6kM2S2J+615tZBuBOHVjimJr3Sbc39iab0Dv9VKiwv5BEVw5kiY6HMAW0wYqpg0TJfm4wjqj
2skLz1TMdB/vjZF8cnLIghBlfFJAeYY4zICl2oNaSkJFoW1Yoz5JPH//j6d9pzjlsaNq6WdK4/EO
NJNuipGRMIfYZ7S9sFdTNCEmwYBO/SJJgsIhC11agVybuPlJZN9PwvqdpwLta9p0216k7CJ0J47u
gQgYFDL+fsRFIu1vJhMlCRFTgBrn5Zw1CtWB4PfdNtjU1JbK9idKD5Vdzugy6UialDQYlw7m2QZ6
3WANMZbFBpCsGeXudGdoJXLPDaShZ0tx7q9uhJYA3Mmixj+OLwVR+cZ6M+Wr1H9vjVDjJt/phnAh
f8LAvq69cdbqDYOguvQFTnmrixAcmGiFgRMPCH0KQH9+Xf6gzEeDRbiadNhO/tYlgeDbkVW/O3Ji
iDmfbzSkp0XUy7CPP1x5+QNVlfQT3E7ZhrkcQZYvH35fHcBV19XJWDeejzyOJH1/59SBKEbg984Z
NcOJI+5rLH7ZIUMsE3CJQqOrk8BDtyr2tIdOv48p3+eBUDwqLbfjvZz2OQKXevrZ+DSEhY63mYcU
EXgU500txL8RIA4EbRkQA7TmxaaOqwEexIesQaJvE/eDuzjEsUaxwbjt7RcZitUW5B8rAPphRwOj
9d/Fyoxtfw9KC7zlDyU1facG2lNkwqBaboOq862cRYYtwQ/+AZgM02ziLCDL2/JhH1loLUKERn/4
l45heAddGl0LCYiZlHABAN6HfM95Ko9Z4prUHUWJiw/qbZ0e00WUvKRczd215ptKLls1Ngb5P1G0
OLpzi92eQia7Nf/NPLeUa1Z/huOtpDt6HBhvU8qJ9LSTQrOJ0V1qRToh+t3Ni5j3ix1To4Hx6XkJ
C5LlcKp6DWPLbIusIadNyoRCdNdtUQvnJrqkm0CI52Yy5iPLj5osQ6mpekP06ajU1bwqsWu55xpk
3VU1u43DDgVRGmeGXBi/93PgXByP3UqSrVXBHTT3o1ilhh1D2s1xwSrAETYSb1mRftU0s0GwnGHR
ShSS1DMrzx69ZzKjdQ+LMYitxJ2Rk8YBn0PAaCBO0O8TP3VVQ13sVkUUdQUxZbXmiMyE3lJ+zMhY
c+KK0o7ysZyE66jkR6aN5v8fXumuqBXzveseHWMMjqEPjNNoOPfW/a0yqV3EnojAzcziQAt3G76b
tG/bU8q/14OUnzEjerAT8ULhthp/Hr5DQ7wZKzRuLJrba+GEUzcSxTNJklKYnCM3moKc7NDDwfEL
IPCJxtDaJ+BZqH0jSr0nmK3f2St/t02CAumCcEx4KKqhWBQXzhKhK1ZD0kvr7XFaT/zi5VUTEOdA
nOAveF9lc38/4Td0etEVqE7R+Uu/YI+rGPmGsCbtyigNOs9+21TWHUKZDQ0ElcbaY08c/CB6MBxc
l+C/13WTdyHMdQwgdihJyUME6p4ic5EcH/01fPCZhHH21IdapUY41wEWd2ZQXoxEbzYNzLWPcg+Y
glfL1lFTlhApXwaCUY9Vb1ahTQX3l+0vcQSR96eBgCLFyCAAPgkvajIpxAJaTuG/hG+lfu0JO43p
n6tzmwsL/8+n9oSMDm8o8zA4G0zqWTluTXmAzW1TTDiOliwBVFYYpri6GK5KD6ICWwEHRtZI8Kl8
txHtrIW+rs4s8PMCqHBlqOlEJ1xF5hHRQFLSt9pQTGsDW/gT/ZisqklkEN9n6NnJXDlU7Il4OY92
En/9Jk2HH1jyDl3xlm7ppQm8ZDoWBZeakHKRTNVLq3BR7g7gjUXa9tft5TtZysGD3xBFG2J65VVe
qXsdnt5Tq3A7xMSsW2pVBLTuhS4O/BfG53JBpxQQHNz3gS8zKfd9hpGfaPiP6ZayS3r9yCLehS6F
3FoWUtAKVVglwDtt7HcIO93P+zFuRL3ocvZNgHEXe90i3bchOT1RMaoNUoDuI5GUOTWsFJ5jaAQW
gqndB7bGbKHhUhkL41oA9WpSF+ZE76tvsICxxdJ2XpIssOXVokiInYWP6vWrjaexcg71lZaUYBjf
POcZLy0vAeorpANRexjXVSEp9EkkysNMuIQXBW9WbNKRLEEjC8BP4EZZ5sURaMPyWf7m5Ed+oPz7
LIJEdl9LP6U6LhHYyvHwxnPzv8vx+OjG1R/9kzyqlSpuNRTZI/HgEm/pOZR8vC+6rWuTsm0Ciclc
w64kMKXKe79R++3YRMlxYSAcRAdNgE/EsNL+9hnaFpNwHSFb1FotlDpcB0YMp62MdERUzz2P1j9j
Z/EQ39/YfzzHpo4p7KiZesL+QvJR0Yx9+CIVIZOzFqtmkq/IxQZ75ilqengMIGdiU5bsQg/DW7A8
R6KgSYdRp2CSsC+cRsU4luNr/1svuvwpsejvA92Lsj9MdN851ajAUru06cFLNDqST3PCeDM2gRaA
2SRyPFhyua1sUT8OHFg05I3ftB20NPJ/7Wj7WlOR0rmtuPmoIy5gcXHdo7YnGzpGunsFt4PLmHtr
i+i2oFf87FXEVWQGUdSTaB8LgQqu2O/r2HSUftPPu3pPrK8Wg8PLzdnOTFDiuu1thZqcwzzVIMow
T1FNQxhTJsBUnCppfrZqAHgExnzLGk6rvCi5PX/TmmnvDwglHWo6MKSvOB88OwR9iixowYwoI1+m
rRhbP+JjahHI0lWlxiP3Rq/ymkaXyi4wP57xdAGbM6ktQqlTCBlglwQ6tuPFBttH9y4W4NN/niqg
hopXRszsXOt6m36Iv+3lDp03IjvOyou4lIY+iuSSR1MnuiWYGwpAvxdfhcSk6O7/a+/RZsY1ArHQ
n532RRaGhsMTZSWHji75i1tFt8hmi+Fxa6F7Ai9TftiL2rZVMrW3TfVlsCemgmwoUljY2ThJbjd7
OEINmFpUrHoN/c1EmnBbKSZjm5pE0fNO7rRUyd/s18cUyxmh8JbvxHhsK9Iz8jIVYVUeLlIB+RpP
dz9ex57o7BCX+3muSdf9qM0bNoi91KRkiJCrCY9FXjFTuTpdOmDKgl1T5o3utE4efLw6z1VcMisf
Zd9VqLjXjGdlZKeh9nk0QajBl3FxcAmD/42BPBFkvVkmrHhOoy+oEWrLKmVIM9diwi2R+ieSFNst
g3pRCJyWn7zzQCKXQX754NlD9tP4oSTCcCe14GiTUD/bIVOOz+TMcK1CZJuf7u52BhF8mDs5//td
ixJtPNN8Qy7ocAecAPZViCttXhf9l31bsxBPb+inVL7Mx/1/lWkkI7i2tN8P6gu8reGsEwQ1Oq+g
brpBzJ5+qDa09jOzNULMvXHTTqwVCLcBucqDprR/15RDcAXoY85L485mcJkud/0xU4m7ciQKOUW0
fKyobVCGsl6Yy1WBCVVsgHGtTsbO7MMkaslp1w7zvdrQgbQjtpsPfUIJkOBCpf38I0uzpxR33AeW
Qu64uq4vGg+rBqJspZRZAduI0/Efl7f+t5hY06ttwmrLJP6kCnBWQXfb/kMR4ZWs0QnGHU8TnKxR
QWYdU+1d/myuerzox/YN3/TEra/OCJIL/1scVM6mlqXh1JyMRr2qT2g3qwAr8/QjMML+v5jDob0D
p+1+qm5JL3o0Ov6fAw6UA9MOrwcXvazazcgUWVhUxPF3A/UZ1d658JPS7a3N9nj4iYx5aFEeqsZl
YJ37+O8+Em7r2edkERjaEXOsHLRyKYLAwUFsYiuuXdYTzjR7j8VA5MKwkCHlnrEpmE1qe5LJFU+1
DBYYgxefT82fD/7KD7fp28qAqPsJv2Vol4Chw/xp0Hk2iEwxVWeCmF0JKG64/erUEsLFyGwJh+PK
7ES3zVNnpJ//PDVBorFrK5FUfUQKVCSYPg9YWLJv+/f9pt4/Tnz0w41loq1mj+akMmyeaGB8L9kK
nVrw0QhlEc01sULJRUh7d4jkKNKV/XPCjvFGkVh6Su73Cmj3PbATMrBHHLsDW2TLHJmBnv3IzTYd
IUIFu/668xMcQhn6Q4L+15p8ADs5Yy8L4RuXNKF7OKms6HCp9Q3seuPNMpZGrDxZO4YlgjqSiRY2
JxE0JSeIB6HOOwot1gpzuN/aIVJQ4CHV9FXLbVmbuDstYpkju98FVKl7wTbvQGfnh2WwDUBGBst6
SUsdnMxzgc31jKgt4xpgkgHsMDnFTCg6rEp+vghU7sjbR8Up38oeHrFoKFieKJzefZTnNpyYPtzZ
j4fenFOozRzbIZT2fuqUWEY90IDWJF+7xIOmbG/cTrrPkxnBY2NFsxFaf5oGLyyQKF+ObVid8uJD
NlO8z5ummJPzB5ueb2GMR5dYFWJI0q7hS0nSOrgoN02uxMgSisKiw9wBYu9GG3yliqoYrk2pfm8K
piOGqbylVIrHSnEI2I93YXu0/YekT0wRl/oplEh6+6sYHe21HUar97gv/kNr7a7JtkbBRa25Uqkk
ybhkWMGlYgnAPKfPGwSEKXc1HT2A7q3fHbcGr3pbawvySbRv1RtATLr8PXbF39V1QFXHjEA96Wu6
zSm86N6nErp6SzpnDuCxBdvYvmWpb9H+YycHqXp4LF3v1wtSUBrF50elg8XQntQ+kNWFPCSy0XZR
zC3dDi8Z2s1E3l3++0XYYSffftLTBsM4+MVXZlxFEtyuNWqkkJ0EeLEWwqlbmjpaI49S2C25/DEX
yvT7OLkjJ3rxAtgs2ERDFtkjImrQbbznzlIpMv8FzL/4/QzkLc7lMRRsG4vSO8NIORbuMOV5ewy7
gAWgaN2iyhqX8/E3sibXiTfY9K9ngEHQvl4naswe8VSbGfRTnIjeRQnE07lzGpx+OLfqiqGz3TXd
aDfoQmIePQDuBTNb8kqyNFpPaLUR8xSrNmVeSpdgUhoTHgFax6tw6l2Ig/DS1Y21aa7ZhO/dlltj
V9XcGriWsnz/wAbclXu+04Cyn6yVPGXbCItmd3XJkWyqKeKzSdnrhZ5Jn+ueR5qx5Ys9kl72o42h
Bpy/XhIWqxczqgmYzpqW6EIfRJZ6hdBbI8LRIhCslmKQoLoVzMQFVfXXgTHFXxUaKnj0YSjSLPGS
fDZyssLN79wyYYNwuppHlpBbIfAr9AwxeLY3fhV2Yhd6pQnIwsc3MySeexRwylVxLXBECnGH3CZD
poZ7q1PerxNvAj5vw/+3MMsikLrfpvlLmy+Sr5Al2OnbyZ1CA5EJ/FK5469Z2eZKGKb/kflBDhX3
OVglVt6fRM3W1pr9CtNGzjRtic9rKsaD1j+1IFRbfB7J0bdD6qSWg/zHd5mr8/adOIgMb9ODT6Q+
DAEmq4Idoo58jSUh8qCNcjZR10cEKOlU0wvVlUP2ffYkx7pIPXk6Fn1jRJsK8JdwHq+AvADCNxDN
jlwnYIlOtsX9/uJGCOXOGaHznBDI5R84UwxW+ZHXTVqBxQcBM/Z2JB2SqHet8W6o8zpTUAGNVG2k
EGLVFlNYuG6Scpf0rWNVsSM0Mu5Tq5i9VHGm18U8WrUMWewAqSqgQG1yIVpipa0rLV0mJIXeTShC
sOQj2xw0qTtsMsam5dVIGaSW0EiiEObJe7Qmf/Am9C1dWD3/EJpKf5LPQcG8MbSbmWUWaVh50Y+2
cBIBvImfaYvlio2F3zXLH+kQaYYio3FaKqPYCcyLJX2C7UHaZt3TebWSbaDJlKRdO4WX7fEEE/DK
gbATaCbj7Iuv9cSioYs8sXRp+upbG1Q4W3Vt42tA2V5iHu/1ybzW0SaQXfTwW8Im60a4VYOvtjor
IHkrcD6e2CsycPxQYHodEvPvi6ile8m53+dV+RpQNlbNO/WEbArOqxMApK5uJlzeJTMbnJTko+4P
4+XoY89VfyyC9HrJxZUN20etUgMQ2WYtQpZDuA19+bex6/1xqe/+2WfsxfOBhr0ya5HfbdbkQHP4
x2E7zbV5V5jhc0Q1L7CskKn14HcWRcOv3WzjQvcaj8mOBRgp8Vbo0bk1CDEEEL9ILpfR1qF2jxu3
U9tiiskrf9OQyfolVctAEolf8t+UrwWX3NTFURyU8LYunZ7X9y4tGPBCZ8glOUnbGB56YXVnYnvQ
UnBtKLgmM+y39tSSG3TvPFRiu8aSCsOAjt4P+9oYxUWyuTNTW9jdXpiqrIvLVarSdowvNqvWxClC
sYM4UtxNntzPCl4KWrAmvZ0L/la21LCVsyzfuRPdRpRn7m+mppHefS36vRcUMILUl6p4UFqIwXnW
fpQmsiELVjfPLodXeJfedjf/jfUuODUQ82/YJT2XvtXQGb182fVc0eQLucfkSgpMnKNgqwNz9CwR
wajKl7mJTujz8ec3ut+kBq4hnrwCTyWRqezWz9ysRiBIMriHtZbrKvJz77+R7qnaOL0Vc1wFXIv+
13utHqv1wRvr16tcdqIDwlgkFnrtunuP2tfrvxHo8B0pG3dBcTRdzApXycR+OqFoBSuR3YNMNRSF
FbfASQvDOWPDD5hDIfhf1xw1cQVuue0YgeulN5Rr40A1EIFh+KH67R9LTkW/imL4l4+xcjmODRZH
vSL1LleeVNO0sMH+7dQlNA7HOSpfupIc2nBNBRuHbdrY3PgqIW7EplcqwRbx7mgIeveA5jUUQg1c
54r6lmEsgzlSVobpB6VvstQXK1Pe8RLxPSxl/1dTn/q9xg0TOqdmaaqv5t06rPTFdTqf958RqysU
lxw2dRdiFKT8ZmUk3omGNxyutvIAgZDUXpQOFKjeetXzppPAqzmtux9fTacC29Qg+1JQyNUiD6tm
G40wrMA5ejKsQQEPDhZJw5yhY8hZVtuAxgDkZMO1eKnW3ybG0O1lQ2liN86TvgMyrOkfGFCf0kGM
EJ6bDgnnB4EnHYdapkKlAHbQJpvAN+nREjQVWzIcvCCYocgY3siUIgaPTkyM5rYpuIbqtz9b5shO
eQkOS5BWQ6UXz4f18DaeSSXmnUmbTBuLlhjv/OMlitwjRlgYJUAZeT1K9vxSnOqWpkWiCHuZkGAN
A4Rx3PbItkHjHtmwl4HZjmtcBoV6PUTkMaXagP/VlfwOWENK80p/utiRtyYunlRFxyzAHoEmBt7t
qMVa5qVe53/1EFrvqta+QsOJOv0WeNnOfOsr4R+piEz1N7vqrbCcTLXoUNuCsXBC6Z08I0q6Lhb2
0mW49ig+JzViN5q8hApJnZT/VFIoUjvO9be4TblxTyyWv8BiHBa5l/QevG4RVvTvzD4P/GPxuR4J
+iaZlvXzUqCrFgP2ZJBPOijqwyHrUgElOn1xTiuyP/i+ioiUQyHa3lHP8wnl5tJLSjedg2K4X+Ze
DqGtrRFNdlbsDGT0H9zItRn/H/7T60C2M9RK/A6FgcouYWoPZ7M6qRy7sgNEpRTf5aWN8RIXGIup
JZmR77Ys4Esw9U7vLrtIEH2Ckm5f1qLToYhDnkbSjh6nWstlontraCp2FAu5Ek4i9y415xBY+Cn4
yL/ixOky0kz21ACbR3FGvY7mxHLEY6/9oY7dtqtvfuF0NP3iuRpEtUkkf9a2HhJ6be+KHwMkmwpT
kXvImhPBQbyjezDiTd9taVKegIYiB6aWD0Bzszk1mtKYWF4sCRnXadkHEML+MsklFpz6ECzMzH7h
Gh55s2jgoimfQL7fqSjd9nc2KGOIkrfPlVLaBr+zy64xub34jw1Wn3RkWXI2pYdMx1+TZyWS4QET
RPX+ToqezxinPRBawNx1m+awyUdBsYo5QXd/QLcSbiqba+0d+2BYh16sbVtOIU3dLzrUAAzcRo9y
IIPy+BOihAdlgFE99Ld0thBIUvRpWWzdmylsXrbchfdEX943tG/TojhRe8bZWILEKfYdkyXf8Wxb
ST5yrgHJGk4n+fnt6Y3TWIwzQdw8wVElIjoQVAC0UHzsZvrPX5Eg1fhX7sve2uJTb2pDqLSpcN+a
zUC3z/O0mSMKUrrXXpZrTR5IX2CuCdvqGCign64KCu75iOZS4mZgdgCB6cviFt0uIPc3+Qfy8iMd
4gk6V1sCChnE32MdEWMqOvrdVJYGeSZFPI8u/XkKzNA9RrQmY9/ldn4YEozUsNNQa+DNRO6AkewA
lVSlT65xQX31HOATktgVwOgZbj5MWnrQmFplLM48DoGxWv1z8wU6DMtybsE2/pAzBkJ1CgKmeE33
/Lu9fC0Vy+tk5F/ESAHLiF5iYQ9mjJS5Gi1zdU6C7KZQ7u/dXVK/c3YuYktSHnG6TNlgEjUPTNN3
PMQzpDxfJkQxTwcq0koMTFOqdJBxT8EhfSHo46WarejeRwr5xT+uTBY0UuWWhkXrgK0SLTbpGHQC
+Ux1/ywD8M7nVDxXFSwvlELDchPjM+qp78L5hd7joSfrj0HYVhG/eG/jPv3bZcN0lRR65HSR+wku
X/VzENb0MigAvF8UGwGx0d4bt27luAU53IELwbM1AP24YxEvEGaD3goeBJy9FsyiMJAdHjPGYC9D
lMeko1lx1o7yQ+jRjR7ntYcx1sGAcsfuSLsFm21s162PdiT97u5Tx15WXpH4+asUTM787bXTgIGN
yXkLNBGvDpEJj4MVjxycRfVAsk4uhO9W8znO7FAi8trwBwrSqeCYko1XG+fowP5tFMpCPbDx392H
1rgunmvtQP45Y5DKtoacN8TK2V3L3V19UGTVIvNk405f+sdlExwkzIPf0PQLBTCWV6oebkwVLcvJ
1y1Aaf/hLDVG50j9e5flLJ5eyoSvbCBy+tMHo5PNFOTqhls0Yl3D32z0kZJwKWzWj9I9fMzrNGzF
2GdcbyKYtAR8KtojNa0gGsrSUuDS/qFJYbKwvNLbrFTQ4bzD505YBcHBrlywE6fetTihD/C2ZxS6
wGX/ULLXJPrAxseI/sVhXixQB2DDxsb+nD+6NKUoHanTxhwh++r/eJ1VKZIzRbsM9Er5Pgy5T00C
y5j1yU+a/UMfu7a0SMc/B7v1DZVYGznvjf9Ns4WQs/c3E3Fhvv54d+tKgtWTzLHjF9RHg964yvfl
w/lQ1/JUQL6jLf/B9Jc7pCMVwJv3xa+AernoLCP9grUl15PLD6RHxKY0iMJRzPY6Nq3tUmm6OgbN
p7JuM4Nbuyb5SftYXiurrIomHTRodFw9hZNdOOAqN3+tLf5MOqvBn2jS14hSVBfBM3DDaXYH3UUU
00rn7GLuhi/Qw/fVp3THPFMelKcxrmJ9GKaVv1yv4sUlFEOUiaDbAL8GzJawIfAXL7QVc5BD6oFz
h6Ud8lVCkmqeKAx93ppzLyncSVBn35bQcs/yhTYjZ1tQFTHhYj6idY7+JoGRRv3rRKPGGLERiIPB
Ub4wSgxCPazuSxhRJ8DRK3bEbZBSxVerZhcoMycm9GoFHbWiRcBorjhus5+z2MUzdr03oNdPYlDl
h07TEbMfWQMS1rFr7xu0ZCGeUubO5bdPpwYcH+8ZIqMW/8IukWUx/rSWekHuxaE6nA8cB0xWAelR
yOmdScV1p6WQdNTHUVT1iBXY/faok3YwlZASO4r7WpOkqbozbLD4F/JQA0hYZw/96mfT5oZKsHYM
VxdsiaMcbUf5eZqL+vh8p2swXutpOjqr9efs8Sg1a+HuP1aznkyVh0ETfz4dKr/V7UJS4eKmXK0Z
+rRLLlLl1yBnmu5QQrUbYrsDcBk7DTk745u1TJVaPjLYcfBup92fGIUautcQwxUkF6w7CR21LUj3
mjDZHc8IKL1txvqni46RmcDh7ITgp2OWNci9ekSXwTJy7D4su/74MTsOGMbG8T5TmcWD1/LBFLj8
DT8GwTbYeNkx9w0afUKHuaaI1hA/+yCFWTF9/LPQqn1t70ufvbvLuRqmhkilZR+k0saj8yTMQd+Z
S1rDu/szyKmb5f1BmW9uFyX3SyWUjCGja6wXBAJoZmzi8gG87Y/0Xq0eMRJyLiRggf3ton0cY1zW
Cgs9O3a4TRIMV8su657L4XD7mABvmcjl2T5B/mbm4WjgQ4NcxrSp4y8+q9EVfgo+l/RfO5DqsdiR
XrpCy3+4kXfZhvBEBNGWtHi7emoVrvm3w2hgUW+cwdcEI0XtE6o6aIrmW4YkPGtyaaNL/lGGt+5f
O6rvGMdrnY4x2iYKGc6YEnve6G7IX/F1aCmZQCgrIn2sCYUBXgBKah3x8PB5AMzd2iWBkMSmjEL4
ezhdbpq5N96p86OWpBm+zDMNqXARUJIse7r4qSEWdNUe0AeeVBySvnowHqE65aWM9ZcbrcPirooh
/ec0x5VJdIaNWuaB8Pg9s1Zl5//ujHTqxPVO6ADXGbc3BCnpi1zcsSHCRPf2rvmjMxXnOfuV/kg8
ydJX6oBDkv0Mf6Mg50NFpISc9w/EgY7xo0lYqzkzqeusifbSA3mD/Z2cckPKIEmL027+1Ku6PLwB
DWEfas6Z+P4H8uQkHM7VwOsaT7bm4potiASxtu5fdLZ7m08E541wvynp52Z++ukQB6nrJFv4MLqn
SwlX/rkNkjjGibYJ4WhkF/9XAthJAiTX8Ao/PVpmJZoSk8ycbVAHpdZpqpe/D+FS76B81KMl2GmD
bqK53eEO9CT2fFL0pqsADfd9s0yHrTUAYerrUjUI5zYqosTJnMDBlvAeCHTkHuVMlV1G2Tb1b1HP
afcWKQOORf+RpVfYmBRhHEYlBD9seWcn1paybOw2KTB5inU74I8kcJcTAUnoYraQ2b/1ddMK0Es3
rLnhHlloPV9OTjxQwLjOuuXsEEXfFEIOHnrsLNAwnyyKipzpn6+WFw8ReStIbEVMd3nMKJ/iSbyp
koPn9EserpIECSq34h1OVbWUpRC4WbrrzcuGS0CIxgv7CRkzO1Ne46Eo4E6/OgxnU8e4tm/YO3xJ
IQxVzMUyKiYeenB82R51RfMOJPQ+/wJWraYvWRiKIOyjCpLTsPsQAnbWshKxO0Rq2jYyg1BI61Dn
wT3FSk6xXZU/Z2nLmulm9ZuOf9q3/jnDYtIes4XZYNZgHcJ23GqQPGCObEmFb5qqyNI4lJSIVuSq
AY1VReCSP2+R5Nz7uLmP7dfc7Hx0SW3elkGIQWibMPDVpHnQ+Ko8+r/DlM6PD4IYORw7I9REcggQ
HgYV72poZja/9uOS/+W/baQpa0ZdAVzRRrDXpSjMJWkSTarmr3utzxwh3biHgOaZcRQhkPpMEoyP
K6gvf9jJHw0RhnJIuf7upTRETmPGThOkNqMCWGZPydSspamFcM+nkEyZ/+0Bx7Xa9hfcdrhJJaCM
FRDI3UikKcfOjnrRn4gi6uiBVrN9LBDWGKMwL0CSHPKw67wtrj0AXy6UKa+utIyN9SdYwUWTd+Wd
NuuGpTy6V1vsFznQubkFBba4lf4h0dI+1irDPVIAFYcx2kcHk6wQWBx6FvTZHfzlCVdn4AYpzNML
RTzR4EInaqM7OfDeyYryvBpI8+eJ0xHEpg9xueFM0/Wi4f7pi4YLfC5etdWCrll4LgOHZZgrhVXA
KwgtqB68RAo9UsxFo/ChFozgMqxjmVYEqYrOjCnQ9aQz/oDTM9+vLsHNo5rFNxy5VZTU6T71uiob
21eNaxTrSLEVxdY+Cp2NxTPs8bs+oLqI2etlwdXhZAT+LFDa/RnhnK3C6b8h3B2gMmpUusRgaMbp
BhfodLokxlpp0aIlfKCc8/4jrRZaW6+SVgyddUzd97z9+fibeLyg2gj1RM169rhaEp11aFi63PsH
sfO6TzjXjJn99e7MzL6RKS6aZXvQJVq+wZ2RgfYTaN1V0TTPknOZCsxrVtaUDZzR9lis6m1a/6Y9
mva8HZbz/QrVYhcGFHtcl0ex/H/mDWhb/kVf7iC7Gk1jZ2DjCvp8fETl3/ew1l/casRL65BfxCmD
srRjm9d8+GvV07XPFrpFlQkgEUeSicpbHqi1AkIrt1puqdItsZKL9TKLsDIuP4wvMWcKVt/96X3Z
ZVayRsVVLH05E4KXWul9j6bR1b2Yx1Dplt7JI0ov5RJLnfY3gYzrOpi0dflyYZMUxatpSDEwFT8R
A7yxm7pjJY2UHkNzx4Qqzom8EIX4VByFJxmPLErJXIv6PY77BAg0XFvOjz0pTRRKf4P99FWaFkkV
Z3swBi0yMJsGjP7qIg0sMGnyUPhAvcARMfyrzlSGinYHSYh9HgM/t2CiL7LQoG2oy+5d/jqdPGv/
luIi3cqDUOyiCJZ4VRK71mB0ucvi3bHUGyylBm1yBWFVDtfcosXLqlwWxKrf07ji6/BLRFIauKRb
ZhYpqdzi+jDdJQX/v/aj5YyF7aQGdmdVsWlQlFLvS5jO8Trf6ACnK2VlGe7XyKN5kHcdaKKt/0zn
2Ly7S7mgrtfeMbtbLCGRnaRxmlgkZBR9Gj+/wcap5qTXrHa5RA8p1x6z5j4+ziWUEMXNq5NJs2Dd
FFj9C/nqui55TZ95B11Ma6nILCkkv8yqZ5EV75gHk+VEyBQDxRmBW59zzRtm6m3GqtKT+fQ8gSrh
bozr8DLO89FkLXrj2A5eXYzJNGTP1WYjUUa/yfPM4aIqbw92yRXKVrVsQyV7UTDCjqxKLmbMPvht
Fv2BcKK86+LxUAHP9UOaXBRrIXKNjxCFFtzOcaudDZqTA9wjl2BWBlArd7ODGgFChh4t/TGwbzEx
fq+2ePhkLcOlVmmi02VR9VGNn9ywFeuIXXTK03hOF8V7ze/g3C9RysUGRxK1Lqeihv/osQsBT6OC
9jXCYDYuaY7HN6MaZDl2IHbrK1+JcyMjchQCdfbjTjAYrVZgE3gEjqz6q3ADORWGIYqbwXB3vXxb
lKiYo4Z1XvqPGA27bFTBmPfuXP+gIe1uvW/gTptiG5lCj/0V42qVXj5efDIPkPEiOQYd5/f/iyH3
s7oUjeuh+5ozjYsgc3t2ifzGMETllMQjr3QQKKK/ITYxhkGXlJvfncoTGL/gIRjIY2ODQTfhGs2z
8YPTPIF8YBqHDCUJOlctTUQP6FG9nC1XoXXbmHtMrerxai9WEpTkI1FC5Htde0syjzbUnnCThFBB
JQo+CHx84uP4KRzvabR11O9UA+el9iCitspGmVQkta/n46tvU+yyTYoq/za9fsjF+ySNsHkSUWY6
c8brYVR1SP2vyFj758RsTS6BrJ/5QFFvsKBCfGPxUdkKSv8HpV/JI7CNU/9p3pHv5veyXc387boe
CeFn9bnOI420dydHTW7zpyVgiuTzhtHm0vA3R8Xd5A1BoZkWHRAdTOehAc6vYI2VaroJLojyp/OB
8T5rxqMynVtO7+DJs+aAYjQShxQ0mfWQrcsCLvnDt3w4Ud0FF45SNpxWWk8s3yW1yAYMqlQEf9u7
wEra+eW3zgTRWflU0Fe6f7DIZlTp7LW0Yw+DQ8bovg8fKZBMGnOwNyOcJm130QxPJET5HeWvYFpH
K34Dj83GVy0nmFp9oMv9DZQrmSEI+PbjZIr+rL/ulVgWsqnWkVposppO+DoOZramFl+rMt6kEBhM
Gc68vK7zthvNcTwAlsWRWh/9UbJyUzKg/71cUKd2ayRv97ShgtUSmJ7GIzhvzh7w0VHuBXLwLjbu
wV8RaX6kn1sxch+jp9lfPeq62nbHNczDJ1b25JqbQYQhQzOkbTKBYrBN0Uz8tyjbkEFnVLC+qoHO
HIUwCw/j+Be4xJvzcR3fCQx2risDI/jdKDgfV/Jf8W8dbmOdzGR7JUAlB701ZIUWpwO5MlnlrLZC
8qjJf2ZIa7ddoGyP7jGfQc80Nqm3B7tU8D0fNtu53PUxWoYGtWLI3dIkmgHYQrgRnIR8baAT9+F6
X00VqdRw7v9z/+4JxlB6qfnN1mXlIjcbwgqlAPqObJzr1wA33Tnp7hmNRZ+M29CExZiQJc1KOB9J
R5LVdVuG3/gYhekEYY0XyyVG1PFXB1agPF27N4zWfPi0BmOy0Gvf3qn+PoydkWN0zqIdhGElDKUC
KPquo4Z5euWOWPuCt+nbDY6ilhbER67iSG7kBHjS4NmVe6/YRg80QfLufGfMrU+f/2h+I0nYr5IP
figEZYN2FSSBgfqcnJO0/4wiSp8W85qXYo3s3ej1XewU+7JLQMj6CdDMZLx2XKUCNgUWT4WJwKn5
cZ59gIkJw0D0chhl6G8qCre9NAq2JrpCUSa2AIFEX135edNOqBauDArcxeVbA7vEbYGLjIiXxx2d
wGcMjmY6KWbLaj+zL1/6oMFkPfKhgvp83k2Ix3w8qqWPwjd9e1LOKX9H/azKRqZ8f6ucW8wsFFDL
Dd8Uitv5n9t86dztJS4OEUlowGJdAXlY+KnzNRzX0rXcjB+KGfiVzIAuuhwu2lw4ntZ45v+NQPIF
vheBfjsfYYWW5Gmg1tOv/vgwTEgobRW6jbqio6XEruvgUL2lFybCYQ4z+WU0brpfdgZ8V0/AiNc5
kmF0y+H6u2vCTQb5cbc3tk53Ut7tZdlwzLbZ9kb5KUbkW9fBW2PrQLsi/+qTwwwcUbiSjVtRs7xA
pG6ZiKq58ihG7fu2hwIg5hByYyddVdSxCdSihpe3ze7r/DIPrG3EnMOgCqqslizAIZDGnf0SJI0L
a2NVB/RPM6r5crk0nca59gSs0mtAwbzVWhRC9GwuEsY2Zk5Rj6rdWCeCC9lJ5Oun1rxo7fyQyLbV
iRlkqwrePstM81henN2HF+SkFJQaotemwx9saSP+lwxbiLioFVszSAxdwiJTGj4j3u6h8ksThCXS
17GagYRww4Nl5R7luTpH/GGm+ml8FSET+3tlneUR6Els70ZTSAWPAulrYpvLJPS4NbmaeqpgP+4C
d6VbN+fPk0dXa13Rk3muiRChIPWzNqAOKGo5NG+UHIAMf7C/XAnYJr+24TrNxWaqgOWyzNeWACX4
H1GPNnP8FTT5Aua5vfQCac7e2Ye/tgwT8iSY6kWISBRHtPO/rl1vxfT4JzuxB3xPiezrkpLMX0Yn
3Xj5yjMraBpYVT3Vs21dRIlXnlxr4X1xU4leO/UMvgM/OUfHrbfChYvQTdcDjX3GKOdV/itQCka1
hvTZqlJb9XKOwN9gXSZ0+mcN6qNP4kjD4wCKOqzTLurdH1fK4DsRV4bGDwX9C8qoQqDUZC+a2bD3
RDN3TgCC9ysDduBbykxI45aPIjmlDgBS1QrsOBNR16qICw6W30regONycNH/jGRCPbfHNAHIGkWf
tL8Kkli9AaDm5ho3eLQ8CbLI4HgpFq0mTXCl7NtotRX+I2IJNvwdTGr0iGpil0cQe6lV+1SlYcdK
MSNiIc1n7ilEdNGfRPFM6WRD26GCgH/ooifXEaYhxK31IpBgIFjJfnR68qIymjSv02vMYhjiDMBe
+q/Tvk3eY/ETOlV/k2zNFrX9qZqp6rbfY/lfrW/6gcSj5CosjhExpe6lvRGyvH7AVYxL/Sl2Cz4S
hDliHxbslj4uchBWm3KH6dpfzUPkxa0h1hJ/wr3wfUwgDcdsXGwtTh9vqbuaAva2mn+5/hrLzgPF
O7lrJ/Eh78LQWjOyUft/PDk8YXuhVra7RAT2n61NssHO6bwKu5UVKLL1trv0LVDrbKSOW9aa8p62
WxVaU596tSjMcbvlWI+szjA8EJONAszd5eY1GvkclAI22E6Wa6miKpB1FBtwHfehf3gAMs2MOg3d
45dPuVZ7LYVFprrz72JOMqw1RytB7CsMFCqoETVc54eRH4+FgRbKU2TN/GDsH3ckQILU0OclCfkl
CR2rGxVCOVIIckfgZ1V5LSvy6q/62hfP3C2Qd8ADJxJvuqApZUNOt+YyYeoSnGu4IXdkqrYHLVlY
Yhgv/VmBwNXG4SEgivAxRvy4EggGtrLfg+XmMT66na8HFPizaizu5SuLcb1X4rkgUsa48ybiz6n0
K7VCHgYViT6EqS4CmiliuYQO5eI1sG/4/4gHOmuXEcNm5WetUUFUAmBdrxmbIvn6YsqpfNOw6OXq
DHBAu46dwqj6Ss/oSonk/MGa3kuJiszDcfG+nGjoPXzF+sObkg9H1/EloaOxyu4et9Ct8fo5rvHS
kVVqFsR5ipdY+LQb+TkqO/q7WSS494fmetQAcxHH0qrtKW7NiDxeyiP/cbEFMO5+iLMzMdj5sxqw
mIlhz1mQ3mVr91A143N2XyIv0V7Ms4b3pJxwqp41bi4NONdQo1ppmWSmElYHK389avek9EHTNP/n
BsXwa3+lXfGAn0Sv9VQ1s7LWqlGRw/+dbyFHpLLMHk76e5OQ8E4HkCtAJ8Ly0vOzJSDkpIJAjke8
s99q1RtNlPmFY1OEWIbRCNjrFbDu+uvVwguEp+/xV6V3y5e9GcI3sK8T17RzF9tJamG6SKKwGQob
LBIgLzuc4bZXPFwyol3DaBIfFepXFSUiA8NjMrma/ZP0QNEsooMvRL69XDiGU4Cy/o3lWR9uZFBV
e5YCZvgbg6QGm2q+O1i2Y/4SdwcWTKHkfu+xBuKermC8zVR+dlMNJaG0BSdbW7ePSTwY5fmuFk14
2nfxD8I/AOgKMl+bEuOVN53Dbj4E/fbo+Bg5/6JRW8JMcOZ2komZ+3ZaEeLZU822VnETn+CLHC4g
l+Yd/oY+r1cx4+BdR6IZmeLMTL6SEme5Pup5+HjzwcO6q3wgVrL7qWziVIVnph/EFJCOs0D2DIHs
OGT1aCY73uq0glWDwEUPMtMYt7PCS3zLekxAzFgA6SYnx7uezMKul2o3nayu+xqXc/+tU14U6Yn/
G3bnBXB0QuqRIfnl2c6cx8U1gl874sv+dHONav9nmCbPGwVAuAhrukkUg4sGZ3UavncezJajvlGE
Hqvz4zahXhxWsxgkveeqbUY/CYmwxkNteKdO6hMMVXKmBkrt+nnofj7sv/OtX341VQRikvVjPnkY
NMzhuIUBR2XCrFr9VEZcEv9MvwWUpFahOhMXTVxu5AdX0floUf4zjfm70sq0peCXpHAmoqkrpAlS
otvIqPcrY/ztc5PxF40TvS+UhESngXdLwi5EII7L8CQMubXE03pjeUIrPRRHwm3vDFb6XwFF6gf8
RwkFt4dXltQJlkWWeTv3uk1FFm4ZBzz6lJqs6rdiaw176XobBQ1UUszxpA/2abHjxfNIL+lMobuf
/BNlUxvWeAZTjuSWWTzGGzeGqM327yWjphHsUEc1CSo8L6E9iRfq3CZUYW9YA9aVN912NOthJoQy
bg0/ngekK7wivz9lz2wlK8c0fFzbpVF2N40J4jPgNxanbyEvvi91/OaRkrQdZ3DavHRMrJ6/zH42
MBdQDKKifgfjTj9C8MX5268oY+cbwaTUl7SyoxHON5vvwC8Kne5p7csEXvgt66jBv+BCzN6vyszW
DsIu4YA3bC9rLxeSOIVxrQiDr84F5LOtmX5YiGLOQMAO4OVJt+E/eo3nOxAt32F8OUpiPbdJ6rPQ
Z5kG+oEvvb3SNo57iz9efd5+woHL/0UIrzKeXt5xUhOFFZTXRJMec8f1M80eBmWhJdKFVF4sThCE
+KVgEDdwxsRHjnL4Yq8Ypmq/Y2rihxonTPVTWIYvmMy8lHS/79S5yKNlhC8AwIqRP5h9jB3nxq5a
70PM2Vkv28Fv70Yoyvg8HkTH8InL5jk31ZRzeyppk/1rLd5MXt36vQBv2lBwn/FLhrRCZ8u/uSk/
p2OG1g70L0Suq5Wzwg46kJ0fJwRAyrS0iV3Wie8J4fX7ZwRg9qM5dqLkbD+3ZW4HGqTRRBIqtWWu
6gIws5AoD6m2A41lW1KnA6drOUyqFHrzEqLfzLyaovCudg0K5cAcnWEQUF0zFW1nyJvubtBXntOv
arlVf818r+hMayn8LRChwI5LmZkPgeJPk1SIlrtuMSA88JIcJjwLzL7Jw3M2XHv2mcQhcPDknqHQ
rhGOWxP7bkdf24B5YaihUnuAuFX6CNw5tN22it70lqUurdR/kMwoUIkPWBunksUO+AVsOmBa29xg
DzxBm+o1SypDRCKCS6FeNfrruGhjtQ/J1wP6tP9vrfKuLlETSsp5zak2CN1xGaH0yDMaHr00ilrj
xQCiOIf0jol2IIlrVIRFZ5FaUmdA88zl2feDQG8rfQefAnmIpm4Hve6DR1NyX4mGOpqfGryo+khU
3sEn3dxkyslIaDBreTdJKTDQx7Y6tf0SDKOujbcv7NK8yshnyv28yebMAGgiVuex4pktFKdhQSDo
x2RkQVo6l8amyahNXFFgSf9lmDEiRfkTqZLOg5vQc/VQfjtFdDl/ledy3j2I1RPR2Wr40ap5yL3d
457sTPKcCfj0YIjFZ8585qwuI1Ne7KniPh0892qSp5cQnucBlQLV1CkYNeN4P4opNeb3+xyeGkwo
YWEW9gCCcER7aEOh1FHynZeJ5PWHWUrFUOf6D0wxqNtIeWmknxnznX8lL1y6OrJBXohajg3hwiWe
QawgEhiYaaJkEMeTrjHi2nfrcntRfwaGmtsWKd2OAKahEQzrQpvkQFKO8w/ljba1m4vvXSZ7fMCx
FhsgzSE/BQu6VqzsMZ9ohhLTrgQ9dmkChX74PdeikMBk9+XKLN11FB7efW2T/6nPxtG9fzPDWHJ6
UVuNZV3C3lWFGbak/r/p2b3+oNyS0AiFgrDcb3eEiygzveDQP0dT0JqB1D5zypW0Aw5RD1eVTIDO
Gk6/V0NYUOmogY7BV1/1lWtCedl7ASyMk/3+4VRnIZ4bXxi2gZ3YhDNpUCpNinKkLCZDByU78dV8
DIy56bNvxln0HHizqugF5LW24PyhhKSD7jgcs6xibR/b42u8uH1QfUbtDe5cmb6FI19v7tFRpmEP
dQ6VM5uQOXQF6jZiomSAv6KYdrjHmF3Zba/GKPfkqsfy0LsSgUzHBY8l/uAxNb9eVp3GChOBBuDR
TmfAmbsncIWU0laWRKZP74oCa6zAS9L2+9pe4bFWyDHnt7H3Kd3HAtssLLTV5y4BmUHSCiINU2SG
p8ip1TLmpLvvemanIvNu4yHkTssXxG+sfBy5101yKznV3ra+guP2t3HQWnaoTkL2c+a5gd3KFGjA
pWyAZHrrzKp6Ryldl1Dsm5Fz0ZvOB3hKpYn6rYYZjp6moPGedKLo1qNDfCnG1bL6reUHBUPoGZ3f
gVOI5/+NY+SGf2Js2BgsEwrb2racWXvl+T17UtWldF1fSeN2nijpx2cZ3gxplf+N6cb5pfGhB3ql
9F7bNh44uNeTryCOhRRoU/8Wr0COdhMqaLADiMPfynZIwDTDvH00iZu/K5LQaqinpXNPxkCQRxLu
ScmjodulwT1MoHYFwJHuAH5YccTw6TqwJ8JQAfwnjfjfdKCMbx108tMQVnL4d8I7rltMD6/CKGxT
0uWdKlaQVM+NxPpXllQL0Ay40jB0BMa/238SHCAbC/CmFtVPoEQDk2kXkmhO29RDce6+Eg4SarbP
qetPLibqmRPHr81W1N1q5kiXk3RmMNhRhzKB+jBCAgqvHDjHkGiTbPdQh9MDv1TIP2IdB2+gadBz
bXwMyOrKmwMVB1/ddubeaSShMGGsZG7dfro6SpFX9eCgOqkIQdi44mu2Z9Ew1GLps9PXXSWRnwj3
Ahzo1HOd16/7W9/q8uAyvRCqCr/Ho2UNSwpjTGX6LsfOLmVn6kWpr7q66R7RVLts6C+e9PxRyRai
h5ZImVs73Ruu+qwuJ6eqbHcNwOb1z4O3T963wgDkupqWRj3z4tBlgcFEJAJwcuGPhCS+Dm3OKcBB
s+3AhIRUXtNH0uDOUV3D+wL2is8wmq8rJXPWN3dw3SCNsvrf58kEdm5VZFP9PCcjk417yO9SGzIz
+Ica0gvDWzwM36BNsgS5O4oXBKNRbYwxyhsLzwNee24yc3FNMD9ZSEF0pt/uLYMAZ+DWdomCrLB6
Jxnkx0ccjDNNxOFXBwIg1lCqdJeJLvL7OL9TKX6WSUznEA5i8fecW6PV8EVdZ8jNuGZlvI16Ff0h
YxeZ2VkJheCviv3N2quFtl+nwU1OYnq2NpSBzWTRPmozok3CojhtUQNbhFD4cIyEZtH6E7dTco5c
MzChKdg0T1byYyNDO9NRsoA6wXNp42Tn6uYm1NjCDP1NOvLP40GIfe5zXsZE59WpAZ66Uc7hc3YW
jNAo1lQpzlsWjObicrcI+Yr7fjHoL5KlqoeiMptJsiyt3FJCBE3bBqdPWBiaeUUwWnkrQTVh+yyf
ecTiZ2ySt2d9ebIS5213O/jnJ5JjNp4m/kNYDRrPO/vyjhxcfe5CFoP/4ITk+1QRl07fJPRlUAr8
Vem5SoNy1uFYdl9lQ4SEiCpYeaxgaeFkYkpsew3HMbVA8IHqLOtZlF95Dmr+Yt2fDARigNK8KUGr
wzhJO7iDfP3jG7qpVgM19rsDUNYSV0SUim7ETpTHSN9Cgl55PD0jLfKrU8fiZc9ZQ1yWRe4kpETw
Lxor5YXMlUyHQf3eeTDzGoMOdQEJNFjWAgJQC5yBTvKLYxGqvTVeMDkeTGpLnopj1RQHY/VmmC6L
9LA4Z1D/LowbH73FfC5RbkwfhNcbUfB/ISXOGHBTIWwvmjplZzDihN5We61Dn9BztzA98jPoXUu/
Q5XLH8QZUSkwQysNlG287W486y83/7wHrhcpj7VEtqlXsODQARzJckgrUFxl9sOxW8TTlf4H2D4N
Z0w3TcS3SuAh8YB4bM3IQdMym79md56SAIhXXw2mkQd17wEzrPRwL96l2C+3GXdKXx58VSsRKu/0
YZimwV7MQiAbtFU05Ux/Nt8FTzBJY/ivHmykuXPVhFezInFwccz+n52zyIPRPqlCnhBFXH+41cDm
lHppDbaUQjcGiOmX64l0zsPOaWgxtKXGCZHi/WOMpS7Jw5T6OLg2MKDM2JvgCFusMAyRnvrpGUyK
2KmvbIsSi4ECwsW1FBYgmPdHDCvlOLWXH6LzDtA6WucbJhXAApDkPoRKf11J/hOBhTmDUaQ0L7H0
Op59p9hregA5lhGN2HDzsSkUSSOYMw47AevN1clszjvsOK8uek+W3M/yDwmIhpGsyfxvmuvXpyMj
nDDkxCOG/Yt1Miowf0OtCIqTTt3fguIjBecsCjxNRkwEDkFq1rYjz05r7lCGQ7ajZUbkIQYn9WdC
e4933qTPGmE7y3SAlSBH4iye/Ae3VHMNoF9sdZ+kwKrBZu3gDyu5qinUSdK3bsYjHg9YCDBsU0cJ
ybm7LkHnygc3ZbGMXlb2uH9XjdEqlG8XWUMuuGNu7SuwqO2C5yNYjk+H2gmjHMsNks/bqBcdXU87
E17q8f+W7QpYiElx1ZFWJHRgkPIQA9wO1mfc90C8JBlIYNAAKIDai6TzOI04SNF1wMKuTkse7j98
iT4v6pBv36SizOJy3sSUuGlp2bRV51EggbVoQMq96oaCy+aebluHvqoMQVTIWwDie2OK4NB6Bkp1
3ux7ugV+gPAuhf5ehAkN7w3gzd1MSIDnz3IwNcv+eXciWQhUMQEMGMyKcWot3lySxTvHCbfTTCxV
H15j0RCNZpRLsuGmkPrsq1jSdWfD+fmtDKp9x8r+y+wmRymLylds5Ie6nVF4LSMDXx9K6vV/V4+q
ADUqyJIfJwSyNsrml5jxlwYeYPIW+BqPk40iSCYTaIRw0ENYyIL+EjlJRoLXKFUO/bMIHbCSwIpO
slqGol8jJgoZr1hT06iUWPYfZqLJbfY2D+04cp+seVSxpa18IzVctLZ/a04hGzOgqeUHh7IJljBa
QplWqcRbKzOeiD0lbij4iBVUyNYPNViCsxzl3zYr5WtAuELDbysvzYIaEeL/afxVIABLp9eMc9/N
nOvJGcWoA7yBkn8hn7TH6pplnOcgi92aEhDTNvhP/UixrgyMPiirsB4Mnc/ugbNCfFCTdi33XTbT
L/nf4AKiUsr98omty7Lovvumqdoth1I9leO2gcVizN86kF1dgSzn2JKXuHTqBKqSiBSCsu/KPfw2
YPPV1A7SSVOKh5Ldwq58xJggG1O3LFeQ/sajYXRtSm/reuk64y/NylwnESFavvRDuZGRoPwBT6RT
dR64mxLxwv1Dbt9rSdROUQLzBca0TrKubiZkXdIOikqIJ0d2W73f3jFFyakE/RUmMFLAkx10XYge
zrPXVBKy7pqqtOJzqIFtioeJNMpW/1QnPgNVkMj8aoplAKbKe1j9q98SIu29M8zZF9z8o0BS9Qxd
sc2Jvliyw1e3Qw10YLf5PON/LkkzIgjI199eiJMQtkludMbPpCTOi1qcxBhAiRoY9EtauoIcqSmk
8W+HwibJMkdZbc94WIL7R7ZBX5syfrPlfRLaNMJAzaeJWEnCTpaEzNOdruQfVKbbcv+RCYGxe1tv
UeflGhOfnrKX3g6IzsxSmiWrZFCOyszy6AkPR3rbTb9JkYxaDpFSf9RuX6MYqshCXDDwYMgbBUNF
91siRTQwylDV9bLVkrQEyXltlMYbT8RItjXIRw2ZSGCM2tdGkB6G63VU8Wl+nngfkRVNy0kxMeXc
jEX+DzG5AmoJRTxY6iN2AQvgdyiSM3y6BtaVuryO3GDhiwaOt/jY7ZD8ytXQgs0hGsROmKkiIE09
/YybDkEMzRr17u8AoLRdnBEiWPgh1Df4PD85h9li/P/XBI4dRIlggKgdGgROTd1lVAtStMTw9i6X
wj1G/ejZWoMWHEJG0CUHWfh7l/8iOZKATiEErxhINqa9Jby6ECE8HF6wNpausQyBA8F3vTrcdnSD
Rq8NbADX/PTGI4jf+LmrdHk0nTFwH7X11wKFlkAavzBLH3MlEyyjaH0cs8STkBvmivvB0hWqKZUL
ESh00O1nMZfbimoD752SZqX5QArRRKOs63g/P++YRG6Rw6WWErihyC4o7YNJdsdSnATOtKMy+j0W
bnLBLgqvwRef2Lw8Qrh960wmywNvT4klRO00PbV+JREadDtPYavFYPMmrHIVkmUOfBcHPJYMw/PB
r1SCou806PE6yFR9yXorFNye2MU5844tqU+xsLn/ij34KriuxgEsChfdF6EM1MuCPmvFVjHG7Sbv
DNKda+2Mc/K4Nhc4naQPBqM8dHFgkfFRYFOPu36q1vuGLr/NLpRUW6aEn+Fsdg0Q6K9+ofO9FmFa
XVT37ViMrp7CgOoOsb9MN8xb4vWIpAZMW9DTvyFjuxuPuceRl48WDcRgqB4fdZN0gwIUoXNN7Wjt
ezOSo4IpAwOEqzqrx76HlB4OVZ74n0FdpRtrExXiSfTa09Lzbut9YR7sslZQluoayy+Dmoo0dHBS
2+GlvuqIMLk1f1tVeD3/Np9X5jZr2Cj4SLbgNVyEMPpvTJv6Fhc31go5aHJwcvskM87NW1KgDsfc
RawEz2SGJs2LeN8ucz1R7TgVfNHLt4XJE4XpZ9rvJBH9xkjvMCUQCWOGRE4MGjTsUO9HVqZ5cPio
eb0OirFTVh7gWs0ExcB3FlwSUtPu7RNGhA9WUg+C0YNzslRdax4Hx2QjBp5J2PVei/1W8t0zV0UJ
h6tvFHCV90ESKfvm+mEAdAmgfS6YSZvAudNGT+Q/HTvFjSwzLlqPDqZnpYvz9DYBu4MZYJswbkTx
0ssWDKU6SEHq8Qa9pqGn/uI0/OIenYFTKSRcX8FzZPsokGJChmH8qg9zhmIfWShTV2qN4jkAt+Rl
EPXFKPVWNSJIys1YkJ6m99gZtSRaqVchwcyejfbPW5Vpc1K6bkptBLV7Bw+SCvpMPOzZexmwfvrf
lLKwlRlu5zrQX4ezQRw/iFkKMfzUowZ29zFGp1APucZ8LbGtJB4iQMx07PROH9lvOsOTR5pA8MgO
UXXHpsxzXEr8XPdoMY14D/aMqCepV5i6rgQsqLPRQnlT7r7f1U7q29AOXMDoFGRXabHKX1sp44z8
X7DY1jdEcbX6f7Lt4lHD2mcjpVzfv7febuJEo3xHr5Ki+tOxwuIQVIgJxf8/EBMeS5bAzsvLRFnq
u8VG6S91+f2X5dCgxmUmwFKyEDKOiLoRM9W3sOcOSfp3/9E6K0FBrpyda4iFzstTYikbRYtkVipz
lBiTYvqq6RmcEo/21LrYQfktgcjrm8YL5LDzEkA9n0FavTxl5F2pwvSvR/AQtvmQjt4oI7RM3qbz
Y+WpU5ZLoOPUvql9DSeM98Li9RjzWlV5yg1mv0rvX7cx8CDgOmc2vPYELWWdfbIAsjHcv+1C64lw
7cncA/vY5fWNWKVpWTrGh6Xz2yCfzKaH+I5lH6x4qMCwVQQAFbKpKJlubxfeLx7ju5IiTvcdprU1
o1vL91o8k3HeWOoqUIILA4k/nv2qpoJVZ0YBLspYk3FhezWiwhFg6jjTrKPx40d6JTr4MrhnoidS
gLflRXSq2eielKyH9FXwfItHRrq3XDbi6idkpI0K3rzJpvpUOHgSXHhaoqmMuBc2izmyCQ45PSWz
CdlVxd79daR9HvvaDRAsKUT7Qk+LH7INBVEgdGM96l2mBdQlvj9rh7WDBLltSC06YfectcshBQT1
jY+Lic659Xrlnz3MvGmrBKayJ6DBudNwNzefQo4rL2Ils8OlsWhzRMyTTGlAfwzRBZuw/y/K58Va
YNupfk99rId0WVNWb1cR9lrMMvctqrZOrx/pzyrjdA8LQdYnWvBmnfXv+wYWj2Jm910RzR31F7Vb
ZOkodB9s8G0dDZY0CTLdos/C1n12x7GBdU7vp0RWK6rtkcWHJ2XKWRiFrzOmuDccglf+wiGWb75v
RHKJZtdw6rtUeMUno07fbrbKBwZpVIiJlP9RwgexFyO2lSOoO4kjlvo27ZPSNMCbylcc61NDZcD2
RSRwafjM28qWM5xkudCZpCWiZKu/RbgxVryNyCnFCg43cy8pZWqJtzCPJuiU8qt3IRoAkOZML2nx
x65F/2YPc/1X/1smQgUEYSMtQ/flkbQT5m7zgkRDX/IIiKeGAezFysgYTwjJEMyIfqvcUQrKgrIW
IiuyQJIwZFHzHHK2qYIRCL/s58Yy39Ydr507DROWRepYpeTelGhtIoQfkwm3Uy+WLHHPiM1fC7oJ
ETbNXns7oJCvCO3bc2Ppl1W6tU79CUnXxILVtnA7xBYn5jiWgx5T41KZMHtOk5626yznYBHZlTA3
vvkqm0hxONAW7viYL/sRkLWkajYNDOjsszOOPjR1K1UHfzA6Oi0xzYWnfoXj16XXVQM+aFUs2K6l
B4LujJqWOktDriJHYzF9UZQnv9TEQ/4Hqy/wJbdZrGt6HFKNZ58Z6pHW2DpCteaqee0m8amvTBpX
c+UeUh4k5H128zi77ejGRztOAQne37RKuO99szMuZ14MVstNv42tFGHk8IuCITvW+bISkiR0JxS+
t2uY0ZYsuiO5OStvbcXssrX18cn66tXmt1cXF9UpBtF9XsnpduDmzjEzfL6LYS3X2cOhczKy3Oab
V61Q2+sEx6fhOkwbijLpkngsdMxz6xSmqnqhYa6mSPKBwoGt6aCZ5Crb9w9MRRsc0hZG4NKiWUHV
zZNbxAngmkSTWl/s73CKBHEDmdznu/WQLjXMlOqMuONbQTdaIFmIJ+MBUiPAUgHZjKJWL6leZO8B
Guu/B0f+LYdXC65yp5179E3/F78coV1PxsZh8TP+fOd7qhSibRf5Mpys7EkrSErBWWD+kRExQBu6
VKjSgBoDlyHdUXDLigL8jXOVtuNYDeGmflCAiGzxUZBExQQ6C/nefs1bFylwgFQSm1E/Y8NqX2N5
5gVcWmC8oRYwNNcSnqVEjzRpLlwpFjbqWVCTSLqGi+kxXSkX6aInI2omDXe3Wtv5FfQvCHqvoMbh
ocx4SbcFclJqprDd8q05zlJHQLhAUAhWMgrcYNac+FstqjE+ldA/gqmI+GvROiic/b1OGdmOXinR
UibBrnoTAYAPmaF7yRQFEZRbAK5vyBN67uKq6hZD8RXR/VgDVS1Nfddt5dYM6swvtOmARJyGJNLi
TtRwGY/JEdSgmOCtConKA+ZJz7jxwbToA7Z+hUf4V2ZHes3YcvhtY9UKkZCNyRyAVbLS9fdFW0UQ
a38qOt+/Mx56z1rzeRMDvCg+Z8S40YNaqYNVavb2ElqS7l9je04curaSoKNslpyiY9pdKQT81BSr
Ne4mX7+NFKZblw2fAlvQtML8iuJh9fSzT3vea2uEkC6aw1yAx0ZuBNKJn7aSFhU/r5DNvxwO85Yr
Cq/S8k7BTm+vDqDbNWxpWV6dT89TTsYuzuyHKEDS7umeTa2xj6AeLFCWvV0yoEGNVtEXN7VJvnq7
rx0dpj/ap9WknbHJVVlLqNngzBEZhNObVQIXI3JUqsD6uuDtRnpySXoNWem6yF7qfDDf3wcwF7pl
huGPXk56oS0bsAwyCbac3OwF5FCORTQ03B3wFIGqYEcDVgNtHOcs6wmjEmBDo11rg4XWfiMAIyQh
/cG1VfjSCZdyZJXXCgNNOipeSlS+4S9atVd1+wrRB8EdIkkWMUHXj6gpBSwRIJIgqnRtAryeQ898
BX6Gep8dsVZteKhWfUlT1VZU855MRezHUYiL7HOravb1qQ5KCgY05vZnUyZImWAhAsvcs5xnC4me
yoz8dg8vrXlW2qEXvSApoqHTQqU2RwKqJZiE1lpkDHBgxNnroMeHB7wF7IRVqS6NoVpVOog+nOp9
poZBnaXrha6dyVGl2YzxM+p8OQulZ0ssTSC9nCvSdwmbUgu8H1gZQZbduFVCdeWZ7yFwk54KqdKn
gytOWM4NGl7NkfRDZgW0JslnZkW/R/NxIkDE4H2pchyrB5XnWv7qAYvw9O5m0hlqH8RdFKQBv/Mu
MJUEI6sAOA8LTukWhRcnZ93Ae8eOps7pmKAp/x+43SqtK+4eAHqSuOq9IRhD+kpvWnPHBWbAXl7Y
sx3hv2L7pJGQ1d59sNnT38sXZFaFIUHeK6zj25SbIolNYq0DLE192pLYiAa2Hff4h8mW+j5oar5m
N4P4Fz9NlPkv63wHVdBFHLh7VXxEJTwkVg85l7v6aXp9e7/XfKcLsBdKe2KdVJmSj2uA7LmRxj3k
/725RAccP8wmPB6E/PwcBU5crxZCf05swChyqt6NH58JwRm231CogZYV8mrpclmP9BmIyTLYvpGb
5MqXS2/Qo10E1t6fJelbn5gR+m+krzfOMGgcK9RybEHj3LEnkSR6ae0TldC26sEEUuJTP9DzsJbw
lEkYNeXf6wzJQRR3b0tiU9ubk34WxXKqnI4zgMH5cIMLxCTcFrbMDuNh1EN9y5K2KHVfg+yyMRKg
owai4sDExieWdiHBqLBJlkJHX9hwaf/L8IDf1cw9TALZ5Pe/mFrzcUr5/JcWeeJz+0PlUQsLYSU/
3vIGWyTIT5lpY76zBlrwDOVGT5WrJKOahdCK8CdCSUHLqiViwIyo+yKCpQAEuf5pl0mrIPsv5v0N
GWpUqCpLm4i4UkcVHFROGATXh/EhwZWqwx0YPJtch0EKMezogq1LxyGN+wN4TQGrwDKPTjp7auy+
1Z/Ser85TKpMEhIVgTBpkXTi83rf3qLLDq9z++WmXWf0N4a4arh6+3lAIIcwQ6QIJi1oySJoTsfu
V9esfz65X6t3CozM/w42uVM6h1lQWFhtqrVoNSEm8syWCf285hMyWbE/c3T6WkQk0HjIx4Dx+0L+
rfjY/XaK1gq6HOS6rtYYCn+uVegnq1amTSC6/8Akf8ZiWENhduVHG4bjHM8Qg+EkiqJ1nFOXDdWc
HxRUH+w5q0yKoAu86YEO5ZQiyM2QLtmDubkClLcxwBl2nS8Gq/AUR/+yLIVbizNJkiYOHfB0qNt5
k9QbT7JnUUtconq7O4krtYJOo/Uw12dbmziU1Ky6WBQu6hp1AhRJimnltx7zZra1p2THQKlPwmcn
9f0MFfooF3JwwL3/N7eX2iJAV8CuXJNFLcTUDgRs2f85gb0jDZw+DD6q3mYygCOQrrBJgL2Z8JHG
2IUa0AMJYJmLtvagrJTDwNncQlc+4usJ2rUU7dalV/y66dcLqJTsWVORrvUCVwfpDYallOh8RgLh
oWFrjY1Qd8hfhb4x7x0dW8axEeqZJgbDnNtyIj7gvCWwwQjNlNAFN9cP2styIC9o+/2AYCps1pm/
PYImss2iokUwHZ5FVuj5pNNn5rIPouFZue8s79Thgxv3F1QZwzpfoSuzBZQ2nsE3cvJ/Ef1kYFE0
uIiH5RTlKNCflRSWXEONQSG8Xw/5WKbSzazaJ4yKRQPiY8QjLPqO5uxwigS8hl4MrnWWiyd7lIhO
ArNkh8QKGC38WmSEhACmxol77a1BI49Aw+zLrA2MW5AslmqvEVgIKRlHrAHgG5w1UupVk+7HAPn3
b99Qib2elKAWIkmOhUtQAmSkzaxNTrhncYV4qRVGeG/8KwLSP8EgizDy0eoAuPsbdxNViNAUCjXU
ld9BZ65TI0293pLEYfsN2yblc9iavew6gMqUTb6MTvg042qomR7SISoTQVQ4UFiD2/jkJWzo8yKn
CoVGJ2wwS8upeyMsRYqOaSMu2iFYXXE5Tz9N9sG70gdLZDrLFKPNrDT8kerOieKMLA6T5F6EnOQc
MDj0fhdM3rG0JQDaIk8+9gl69s40aXs+q6TPgDkBiJgKH+UYSJk/6q69qCA1H6udYHCnpQeYCPLG
+yezZekRjvlxcFD94Piab38Yr7aBLam9irHOZ/a/5Z9iO2RhGp4nY4H+A3VjrIZWWBP4PQeLgVP1
PAfAIVIR7EqSHb7KDZh90fpebhjtb+89fzl2VNOkoW2nBW3xhSzRrcZrA/NOLcsAbSbgXFSLkJ9H
D+AbPqA982j/aXh6Vb5CmYAgxA8NikVDhT0YjefvAEeaBzzay68vHYP0DJXEYIvFMcyYsbiNknbZ
qczMLCBhUV0yHd8syTmZE6LSZVKlmdsU1zEhTHQx/YwCainedHiKjqKLEtplTzf/rykkwcTt1Jjg
NzPsWmuWtKuKTZqRLffAz6MJ7kJVPZCCl6GMy2YyPM5k1aukFvvVaDi+Svvx2JmpfUTreSTuaEPE
fAwhjvXDBp8waSkHAisgQ7qIW3XO73hqLTWwiBcVOjlVQlhLZp+juaO3uo+qEDmK1XLZWePgrT9Y
tQmuwJmbBNmMm36zv3oRw8JyuDlIV4Na4e9MRRa9xP9oYkweiK/GiBYxwqSUWeEgx7bJYmVhd9kB
xU3nJDPIM0kBtpijZrtc3JmfBMmLMvq2KlQLT9tG4ONdOs/XM2nfRq0dGl53+wqHcMA6W5+RITm9
CnPLLVzvQYVIoK4vFB6X1+Ub0Ao1EozRoyOfJ94rCaFVzMYPVZswTHKdUVKL3u1D9H2d6MEROr/n
uOlm9VXyRm7ci6HaU00Y9zvsgQ6tBWhWgbsEk+vWr6wUXGzscl/EgvTDadirOo/lQo3M1k0/ugAr
ugcowIfVRIXjzMwKXbjGp4Wsg2A27QYLMQzykPxemnBPITDScedtj0MEuSyPa5Vi0WdfUe2e6Sal
L8ZNDC57VQ1C2DuwEuALDvUEf/81NoK6h9TYtry09VmmtzZ0aXmdfLmmy7noIdxnCUK6KPKH5dXk
2teyN3CaCiEY5Yp8UraSJjtjw0z9D7+25c5Oi55M+aBMi/6+CA7Ij+H3oXRQwYMsw2eYqSpTwGFY
6MsneHs7+XrCavXP9QXXxvlYfd9BwYmzIow/nGwZg30MQIDZklKN9hOxfIp2wydXC+PTD8S4vYZE
JjpXmyQAAnciceE4EuyMOtwOlJjTKyGqHLwiA9GeUbYJMcRFL4jiQL33N5/e4nbHQ7P9dPtD26VG
zP1s75vpULOg7SjE9+Cq7oqxLHpoPHJiG+0tE4/IowRI5QXMGG5RZ6DaSlh1xb1E5D5iu11y6tN4
YEINIylPqf8dJtOGIEXlnrIbEVspllkFNnA3/NuvmsjIJjnVhf6KVRhj/M6+BXTC0V/UHc8ldv4t
kGpbyQuj4sxgql6FoY6bsgnxVzHB3Zc3Il4FSzJkBuIZAjAKkqm7nCmqHDIrMJN04bZwIA2Ox22q
bNEVagXUT0f4xHgUGgK/iovWeLmER37IfypfbdyjZmn5LrSHJicMTSH+1PdPo+DIFQ/cu4tp4Z+Y
LQGj/of+RjxC1c4t9J/gWE7puLk+eZiiKf7RI4ZxOHKac4MidbPl4Rq/bCOzqw6sYvnJBqjICmoB
cj66o687rgauBK8wcMOcRIcgelTN7WhXSHL0+YujvrfI+5Ns2/hwTXezYIG0pRv+/Y7tmSqrBIkP
2Y4O0OxKPT6f7Y3s1rLdVzIhKypRRKhH2Za6WJxkIm9TGLL1Vz1nBSOOygnAu1jYyW/8CJ5I7C0h
vZAvYWvVZEl13JbNWQ/zHXBoLEjkclhI43FesO9geXFHRU6rQmnnf+g7LPvo0TrdB4W76GhhPLtu
KK5fWK3xqGUwrTJItOVnLa4ikw+590gUmot82s+HTJBsFfwR3e9lk5TTvVJ0j1CN4liPR8acRyvc
mvNu/a3jTZPaYCVv6xsv2HSIWZkSLOODLcV30Z0NHBBdJs+MQq8fr7B2dvsXdPSnWWREFI/kOq+l
2eZ1x3O7CVKpKZG8vmSsZQU4pCs/ok5p+4Z/6bsiWXQu90zNrw1NqCSRMYCU/zLR7UYF8bMfAiWy
V50HevGBYYR2v/2CztQpV151yGwfaLa8CPbfeBdFEOHMug0fK2zkmYMTTT0Od+YK1jLR742VitPO
7+dN6O6/LM3AQguKbvvoZB/EwK2or/SDy8NsSb0GEFuEAldcuaHqvF7RldaB62xIpK6gIOF3Ie68
UPgSr0acMc++9a27tt+DQayNIkiECuOwVDd4PZx9YqLRNMfwnJ1oPJ8uynRd3YIgQf8OGMRZ6Nco
OfsDvquFTgFK07Tg+Q2XobPGMR9Fh0bsuvBlD3gb7U0006p+wouqGzHh7TduvIWLZWD0plCYj60p
0T2NlXSl0pdVGsNEV8oPUl6rjqQ+Qw3ICEjdfxCEHE0JOS19VGxxbJsIfG7wLcOkIyvyg4Jm37dk
h0YvJ79wEk6zZWivQiKlzJ7xPrTSUdHaWXcf6i8azz61olBew4HEi7o0Zr9hrR6uSVhK+AZuQcOA
NaxmZk1RKqxjULtalhpbgdR9y9uFpZ9sNoKYm67THqAG7iVMDuMsyl0QCBCZrK70uXdHThWNZfgb
JFgv6iG5MSmkXOCssee+d9ns/UZV3HavekcTK3+2T6F/xfjT3+3p/n5iYCVYwziy3h+1MkgZ3hog
zky7NHN1XdaLXvQJZMD1idmRpB5XUthcXzjCHbBZZTfrGJs792zzl12yYW1DfkSeqHu/ywgS239k
jCSOfji/rE3PdcCBQqedvDtx/GA4MFI8XxWq005wdmixTDnBm8jxmP1SvBnkz94NYdEdTwezHYeL
jfBBRaXCpFi3I+20Pr5MXM5luqfc1edZrvYpkusoUhKSHN6vA/q9Tbc8H+FNRzBjUENPVunI97N8
4svodVMzlhdBlJ2nv63VPH7w6M7I/o7Ul2s6wwJTAH9djbK/Hw4d2AymZi8NJCFFwQ9sa37MFmJs
03REyIV9ys92xmXExDCAs7R3xvAXoB+ZL/CD502YYGzPPlxWu5AwyeBJ5peX9Znaq1fFbNhzb1LP
40fDjf8Sujt0veMRk5R/3NZd/afpCpX717a7lWNb7IsgGqIReTC/Yo6YrQXDxVolV5xUDhMJt9Y6
+M6N8TOnavNO699ug9oAkS+IYdHyMBeBPmbKiaWmu9miTSH8BnQ9jEJNEyM3WfYuEXl0nohwOUWW
8Fb8Zwpua8w0cUtQu+fYfC993jjHW9E2U7om5Fvmxj6jQyS349Vygyl0igkLdiA5HGaehpfKZRRC
btMzlLBzeU0mtuW3w76Bl8/q9r15kP3Bhe2UzlKtENmESXeXANsj3ELc0jKYux44wewJtqxP+a6o
oFKV6bvvgugL7G1uLyyg4lkJ3j8ESkpR6soBFmfpMz5TLtrJEqAWOtX4xbu60cuGVRYXBFlqoHai
fILFY2YjDKWGmDR1ELz4/kICBwhghTZFHILkSGL6hlBb9rh20KTnHVA5G5NAC2Fk7VySXZrxEQPv
dVcisDZx4Waw427jVcjXkTnTg9PNuWor2gNSZyFE1bbzZDFcIjI4VX1o18RM9UI8cQNtFNPf5RIa
Q4s6hjWU45TGUtL8xT391bN2ZP3kuibRkpGkesHKfEVcLiUzdALWyjg9ALl87VqBmgCWH6FMJfrF
Ckb9aViA8AtTG9IrDzF5lXQoY1SQMFGYm3pioVNm9ldjEAKXmOW1ObxM6AEtGiRuGHfQDA8GDNLb
E6w90ati85XjPxC1i8f+f6Ckiwv8jq1mnW0SyKaw0ynv+w4zWn2VbMZNOHETkv5+8SLgEe9i/jAM
WFmGDrcQ7fl6oYiYiEcC51invONpVV/dGWDwRpWU5GzyVoxXzAcJEWU96icTSfiwH1p964cjg3QY
aYK5s9b7U6UG2++KfFHHEHjcs8T8U26N71IH3zCBruQ/S6kOI17N4+hfU7Xk/7+RflGlnmnOv0Ud
lhtciC9HODAFcpT7Jj/5OLHN+6wlo6oR8jw6NY/4fH2f8VMp3kD3cjPk50tRntKK2ngzhtHREmnQ
/UNdJn4Yb/V4i2vAIj/UIfhMFRUj3hKKspGxZVGbsIJtN8VGJRn0w9n2pUTolqOKeZpPK5ldDzdK
TPUkQWpuM7TH98HdWcPJ6PYSGcHR/IjIg7+OXANCwS6JFpolDotsDbvOAsIteOsUFJ/JzKzT7Gev
QOiLHD36ya7xmsN2z2fIn9aI4xnFfRHrkSa8zzHwvJMp1Qqi47ifhWcALrTupDUP/swc2Qwg+N75
jIJ8Kyu+0+Uq9wWvgdCYKuEV5HqOh/j1oTmn6JK2KYxcEJGdAuVabnxPYLU02Bzd0I39viBIINLB
rEmUDji7oMLAT1A9qLULSMzg1i9WIkY6MeyUyZynk7U/LzVOHzL3sdwXbH2imAjHZHcSZUT0uKQy
rqwqmGY9QKVrpToxg8eYwxHQpTJcIQGYddruKsW4lzt/VbkHt0UnGeNo9QjfjssNi591OydxMvkg
0PScOkWzPcmHw+USg5X7xTQXJJwKp2qIH/6CuhY+YNZ3S53394FINtrv81lbL894yqLg6IvSYt1K
/6hQAk2vHo83RgrmGVBP83ntpKtPa0AbIYhKgX94VTb/JzRtvqJQ5fHtl95aj0GsChMpYQ4Pyhse
VYugJ7qAj/0o5JVnlFn75Y1WIjnM4xAwy/3uV27vJaO1LS1A9YhVD9jHrqu0mHzDGpud3PJPz4XV
j7h5PWkpN+50gtM1WUAGvZYbRulxfbvl1zU0ZEIIQXbRiYnSPxG2IuKTASg0Gmkl99atAkWwZh6N
NPzIAS0AKtjqvcz6jX2ArKQUZJep9Zk/VNBEKjAqwwHZrnBbUktz1C3KiOZ4/Jl30AkwD15vLtwa
oKYWnG64hIAGbwzjJZhpwe+71gqjK3/+0jDzUxKCx2xMu9qYLYuj6/IbfFmfVFYJWVEl7c0abGNR
E+PSUHIzXN+D2D9IDFfTtjoKgjKTUqmhaq6E8ibBU7O3NiKuNNlSVRU0SwkLObb/yArjAuqeJHGk
/mB0YkyM1FRg5Z4MQCpwQ+74TVVPLragVGNF3V5u+mdRsXm5pS3bkLtNg7mauuzm+vpevTTsgPCj
bGsTuG+n8ZiXRYrYKbUS18VcidVXWzlYAaQh2oYhIaukwOhw9Ww2RxgWgnOm8CLA/aSSEpSr7OO2
4Y1hBuxYNaumjTJMb1r1KlvDVrSzgJRe+Ka1u/67OZbjSWUk7g6WxOMwzP2SY4EpeUWaTU4ijCAU
oq5uv8qJxHJMuOVohi0r5NAQICighjIKhobZKzIMDP1n6VD3SSJMdIOTCJ9YawmWh0kKYtD1ImaA
zGgyaWTq9zeDimvnX/Hi9XgqlJbMMGUHRrIf1DrcEEPMFEto0mgc0DgM6WhZXSIL6dG/neYZm9CC
3MeC4OKyKL2gp9mTKfMxf+3XSijk56wLbdkRdbnjbKwKJimdxagzq9tNur9/jy/7Y0cqI9eIVynC
RdguGRJ5xOnjRTF8iEuHd5zW1Wta9khllzL3oXEnevzDYJP7xkXbKv6j3rBDhqtfRJdwQW/0mfVb
zk/Cmrp8znMLe4BW7lEm2f/nKr94jI/De+KWu49l2Rr7SJQuVl+NQKP0x9CzTMztNv4piA4sz/mx
jXbXvJkFGxHuYUucoGI/+BCzUtPh1oPybnqgeuzz7qaFuzU9wmcCZrIVemMcoBk4RmUaw/k2gyAh
dB2xqUrI+HgRKsVLx7ML/XjVL4xHsAk4FwyQ1v/lhTB0PJQAE7k/UVl6xqXaMkAboQ8gZ1GBSU6Z
47bGqNdY3H6pZg1mX8rD1yQ+MiwssEShfYGfqzIa9p2633Z8u8Mx6qZsdSjsD3ultsQ0w0IP/vL8
xYz52Pq9e/2I/5W2dH8Y91bdaTM2SQ8vjZl46rGDhF0L5vkh6z3D9tlOsv1J430XLbnJ0e4vC2JR
ybgIs2KCNMtNrmqIJ+E+EmoV9Ym/QNfqQPuLT4tIVCZfOVj8ypufI8Da7RL+AQnFS+aHTGsyZMjf
a5U+vR38wrBbFfdT5B+AU3VgcyL4SwtkhEkMX1jI94ZGKul2uysVsvm1fsQ9wG71sBlinGN33gH1
DMfHOI2MDfw+Ne7DWwEqsEYeyvg2xLZDVAgnzp1TSalVvy4o3i8d8OmedKhAW1JbwoImDaL2RDkv
Ve1Va0SiOCB+I0NM2MArNOKGR1XKZiuYsp1Ur1VZE05jyYiNKskErnUDB9FbGQZQ2KTQ0Ffs0wuk
IMVyE7vIpkr3dP5iksj+Vq/5HCjo8v5eABV1NNoSbIffurep5E6szR4vlNeCwQUQhCu00a6UwF7a
aNZep4FrjzKV4YZk3wj5p6sdj1NluRCx5+9559jdISBORtWOt5P+zcv08KPxV34ZJD+5Yz8va8Oj
BKD2gPG8DZV9AJPhjF6PHX5Crepw7a5wLmfqe2FQMhMCIh811AtzoQDaLITpAu3Rtr9k+WP1Jz7i
x6r+KmhqrtGThKr3FqJMIcspSZrZmkYJRzPKA21H7lAktxwD8hI3IoAJ7IlCwD1M9GupRHP9cpEh
xjGAm6THDq1AnOrtSB4/bWBxiQ3ThHk2G8EpOVFsjtXC3/QWRzkd0pALZWOapdO/PuHycO8VLCqZ
8bsGLFBaergJi1wFYCD6p2wzX4J3NHyDJkj9zVe1RfenQ0rm9SCHDf9ZMCGmIJ/eErzflErBhC0h
a4oTpelEtwxz4i7EsoT+q8sit0tQBB69UlRJNeNXne8IbIX4TjFaFEfo0DySIYrtlB7yB6scVBww
n1GgVDtStV0vfUuMjZZw/ODEQ/nNhI+K69DWfYGURwHkUr1ZUqaOf57ErTHckv+HTJLRPW1tTaNN
W4qwRaSOVbz38TOEuK3fB9qu8cFAWiXiRVbjyXdncU6GeTjjS5NEYSL387qqN2sZP0nj//EV9QO4
IvvRJ2EZasfRtxWz7pXNxBuiwzZx2PwXUyqOAsUWMpYgdOvbWk5fR9HcfICTeywIhC4vKUG6lCEK
8AURjzglBmYzsFODpgo0IrXznhDBrjrFsV9DOQpHANj+7lmZm0LtRq6DFlfnDUj5pp6FBQocQvQw
pThcwT7jjPTTHh4wogre9ekWl5jrya5iUK9KR/FM8B/IQrBvqpkhVU4M8aP5QQRi/KR5XMd7G4mK
ezYUn7JyHCnUggyx5Q0UaKyVwnrHMJ472aFVbLaKrUkNJ6em5g7I4G+rdf9kslghsxWYohnsGEP6
QScAHlsPutgVFb72oaQoLQtid53jyEVVQyC9OzKavSzyAN1gYNjUyf2YiKNc7APZU22KKc5CcDP0
QH9X8zopxB0Sb6FzwujXBnPcpcnpJdEFVCa9fUdcF8vmlSTHXL7I/ukGw2zEg5x1a1M0y2ng+obh
P4rciaBcPhRoWEXtNynDDH++Av51e9il2QCBuPAcyjcfCgflil1o5e6G45cGJQwK1ot3Ua+1w+Cj
aGfsniPxdOT2YVTgHFHsNfch9RfN18sjblmS8s+H1+sxZcWBQKxBekqiWrRr431RL68I1s45Hgix
LK/w4he8fuMAecZ0+H9Rt2oTZJAYOC5aun6uvKSclOCsIx5IFDc8hHfSI5Ejv51TgXO2awcaCjof
xkeRZ+LFGvpDpg+fC92YkuCRqJVGusFHsiCsMw4bArfpzheWFQKpA9oVX2OYKFPY8a6miajgkK4E
TXyFWTROlZPUttXDbUsT7GuNFMbq0HEzv/KUxhPO1t4FV4eMqli4I5yxk2W57emn8ymfBo/20ORh
13yH9RWKINxiTOea5ingD6lxvpvbEvs+X6ZMggi7NcX2gJWbm0Udp+C0H304/8hT7BPDzKaVfXJl
WwuGS+pxIjufsvybP3N8YKygeZF8CmBhNJbnrKuOMnKSplLlApML4opGVMk/JyCWzWAxuCCeISno
I7N9ni65HMAfDiuWeOhflrDb4PqfC8NKywLZLL4ECrkkWXlirkLc9fosfLFDMJipC+7NgmK4xD42
+1yckf2/aoAkvUUIbL+aFeErhvTFnJ6fOgnWNe+yjEIkyStCyMg0ZJUh1x/yViM8YNaEmxRjQoIv
MHP60bOmFcVbyM8ZuXzI8fHhc8F99FBLZUBpo2oUsay1GOpTBiImm4/TOvFYdgMChdC4IGvbxdP9
veF3C8UdhYmKVq2XtjdEqSvm01ZAIDna60Mq2ebjmHBv8yHu8M/y0WIDFcZ93u1sOc4AcGnTEOOf
0Lomc7Fw698UwIpL5IGC72xhtE2B64VYrFfxQCtX9h/ZA7lOuh40Qw1/wikshy2jU6Z4KPCVvA7H
/Ydd3mCHldhrncETcFjHp5jV1cKx3wRdOBTy+qbyw6bZGtoS0SoFyK7OuEJnSHxjxlgV7+fYfQ4B
JikRRakIWbOCUwTIp0FXIcvZQxHiFTutP5WV8IkXpj+E/ZwItAoBuDcxYP9Ja0ZsKAyMDv0I24Ej
M4YDugO3LH+UDsQo6aJSzx5v8jHgJs2lvXbq3X0RIZ78bjzTE08TVIG2RVWBFzHqaVx6RBVtl2g7
mvSnY/EuOKr3ANCqHXAfBMMUkdCozBURZq/jTvXOnNIGV5nn44ZlJwbBcFvIqRED1sxdopzoiy4E
WYGAR9R7eQdrDKVIfTN/66TufhqMdzRZHsDNJG1MiJGSJzi78SQO4/pBq1g5C/yGz8GkD/uxgw0A
xRB1hyREDEd3ZjTFceky4zHGQSyRjWVBWVEfxPbNtuewqVEsFUo+tSxb04JJJkV+5Ix/U8sI0EqK
Ov8lF78wXZ+8QwiA7TENVOYCyhkHvxOK9gpsEweGyROTmK4Bh4JDolnsFtB8NFey+X6PktqTuAZz
Vtfo2R4YRXqXTUBkftAfj/knB3O3MBHFuKoGPf2mnrCGWhIvhf6YqBYH+JC5V3oKwBwIUbdCYdao
j6jytu9VD1wsvAD88FwzVhcpjS1yntRlDjnPyb4R5cjtEWbOFKP+T4fl00iKVlzFfAuFqUqS+j2h
KCvKSKgI5VeeIz7NLbaJCNLoEK828sQ4BZLpnKC6KstRIWiLkOjVqcpaU3rnw02PlsOtHgPZNEwJ
9JLePqHy0JdXzixRsJmVxjyQVp/ErQsVIljzY7k4GrH/5r5DnNM2q2IEkKNepwsdLvgIVPc1y8b3
OGwb/GM3i5J9i+MeVVVCUlmwFweM1KfLVzIqiyus4ikf2XOfqvKQmK3/Gw42I277FFMEcf4CWA5N
uN2pekHl2FNuograP8HrYFjcELdFvlKq+UnOmwysWGcEJ966GuOGGIMlW2mP/ZPA3UCBcICxZA7X
ftJXfj9w1sSGQXu2v1ieEukbtwLgexv3VzGdBxJ73TnxUQpVfg6oSjdvjAiRXGq/wJT+2ApZW+8E
eNUmMXT34d+DVS32Nocd/91RAWBHuqya0b8QLoxfyeP41R92c36ZH8gu/PhZ65x47AadLMnykn8i
4HSiFncUygKlm5LSLX95HKHYgj1/URudr31iWEwVQuo5zVEZr9zsIoz+dZ8n+ZgpOIfv9B4BoXGr
XUGy88rYms4humQ5CqeTbdp167Z0Bs7Ed9uvaMJJkpoDkn+4nvKmdVi4PYVuGUP4N95pHQUINQtm
yszT0xXt0pKhS5aHuPKlJVvGLdRPidmlxFUWg281izUvv0ISoA4sQpudmtv7kZACVKzZjq1A+eI2
2OxTx7AIVi3IxI0hBCBaYAq8Hr4SO1pNJ+/SVIMoS733E8D4Q7XZARP4ChwkhJG2TTDgz1j7VZW6
n2iPa9eNdu+LgS5zGjQ6aIvLqMHmSOgWc7QGU/DNU3P54IJ3YE/HSgnb7k8wdxfMMXne8xTtiC5b
GowvK8Yv777zyndSqurGKz5c0fpDJre9MGFFo/OCJhwVk0GOF5UBk+Z0rPlssqfcVhnhvkfV/lRE
sVDA907K+PflM4aOeZCrBZWuV2fu5Bffebj7aaeu24AjjMffViVr8WYZ4/ZJiIGDSKQwQ3OScg4/
B4FcAg5ZFoklZRUyP7E9RCGOgxCA2bHxQQ4ThAqzypLamXZj6JOnjWiFpJrzj+Q6PIDXzefEN50h
PrYbIaauhctyPlqZuk/y+i9vo0A+KhUTFETUWinxuymSI7H6H1DoskvzLqZvChSVGX7Fjim6EoOW
OMYCCjgg5V89b3kfbSx6thTpTMZEHd8Nr0SGMPkXe0VCFplcnYs6RPiShCXHVGHO7/9G0Kstd1Yj
6r1r5brOd7qXyVkJztSBNunp2pCby1oZGot12YsBl98db//mq+YTK9JVeuFrymQGmIVZk1GYn2Pc
B4RIeEoZeXBrxcP9DnICVxcC5PCMit1TMK1Fac+PeVhyzmTx+x/CVc7DnLfjGjQBoLs7aYc8THZu
dgU4Nf1xILKsfG3d/CZ6zhiO/eNhW5EUucNvJ5rsvsXvMygLAGJrLYGk3yASoa6oFLOshwyMcjzu
OV4r2uuHI4jj8gFJIP7GG0dfjAsJ8dMbOWByKArzMo7OlcQtFOY/nLhpSTSy1F67RLf4GNyl6rpR
tii0ImlV2x4ufS7ACIpVKYOz5O22KYNhpfVNEhcAWQMvAE7zqHPNBFdMhsbXD4nWiTYYpS0vkNbK
k4foJUZHTLx8xNCxFJ7a8VXhn9huPo+DLSOId4FCXpzixqgUaePNAVo0HuSTXrKLVv2wA3RgGZrT
8IwQHENRSUAUKdGUIDSlAUKADDhDBwNUMGNTjqAgUe3sVXUJjFv2KonB+N305wCL+mbKiojHhu1u
bZszPC2BO3ih81M9kL76pQOBrBHl9p/bZ31tffGe2ewe1uRMDq/c4xNm577NXDvS1OXsMkTv+90t
/c/v5C3Ep1IrM7zH+ptCn2asqxmq/qhfv8XkU0wRKYe0RDhf2VyreE1yAZktwBF1GyDArMW0v6sf
1ZcqlxWeFdYnbJfOi96tzFaFx5m6Yh83fEI96FDaUJ3OXgy9qNNmlY7dK0sB+dwVd13mXGC4gc+q
65nTP6A6c6Q1A1cviQ7r/ySW0OW8v+ZttIFcdxcsCX90A2eHWU7PFVOPxQCW5H45R4ENmwcP/K1q
48kokss1W0QzypwoVhA1HgsM4o33e2G4CkJqTAKUFhm4vFDb4VjMDgjTd8s+m7jHaJ+RWqUY7XX8
O8j64u+VX8f5IeOKZixQJj93YanDIuIBvSVXMBOODTdk42auYQ33elGa3UlMTpjnQ/nQ2Z+wwKtb
hQKgTNJFR1hPeZ7xUnNUI60wDytLhM5f8MHR5RjNBCB9rcZMUwCuJgGj1kl+5nbkJefn3z8B0+9p
qATzCeaVPGoiCBS57mJ5dAEdOKfLWbbafAKZ+E2r6QVjbtmciA0Q9SA5B9carTWsdmH5+7vg5IPQ
kMgZHEz+XMOZi2KnfaWWzkhmNy6oYU+Ykc4FVIU7EZdy+YvIY6adNvZPxRVmvphCF+d60NMVEQbX
2JhrbAOvxA8ox3Ru9F0BOb8+zg3bfjWJik7fgkpQ81fyGNy97uvLdlO/oIs/HZOrWNRLxNoRlJCB
kQvqotzL3PBTdpDsI2S0OWcrqbBx5ZEuKGgTsMtsg6/m/CyMcNsnUzNmc+KPlc1s1LBwDhqgTeSE
/c7/t7PE/wffAwhaCMZ1Nk3MqRHB0RGun+yTfznPJ71hLwD62eMGOrsUbtO+/Dq8Z+zS0oM8JJGE
9W+5Dmo+U9IJaFSbQiyDKa90n+AoPdi17u6fSO4EaqAAMK0jfMvWaxecDGDfvD1GPCXIh9wgigJj
9ZgVPC+tKaxoKS10S+xIrqvtUwH8Kl2QzaATryy2Ds2ZUICyucjFpGP5NqTD010y6mbuTTuY9/bt
LlJVpqUGeOnw2VIyUaIdv0mqDgxx8+h3Do6US0f6Dn5Ls3GZBGfCoHqfMjCy8YnP3Bd09zblMlKx
syzXTW/daVwPYx0odB1Hhyz4Yy95RvSq8IPXs43eHvbw6vH8Wqf9nZXQzLR+XY4vcZMrykDIRl+k
aIty2CFUn3paXymA+ETyQI5bVVZsOuMu6Y0HlxmEfPLKfV6WIsjNPdALSgod1onLecpK3i2K00vx
h5WlPz673SvJlnue2bs28P7m1RPDl5L9o/wU3qGkkYkuTXeLZLTuyAzsYEYtRpfNtc/QwFsfouum
xOGEIDuTAgANJZpVg4RltuiwUvSsFf9R/PrgnZdYFFelDONakyt1YD6S2uvpg6iHuZoBVDculmVG
hu5n2D4qK1CJ6JRbbr7GiDPQKcTYffQOrZ4GJWXF5BGwJUTFo6lnvPXwAaYhNVu6EPYyw3vblKd/
ENTrDE1GtCpqS4EuYz4lLMMft9zL8X0d8qX8pgu9Nhlo6WWJMdvwMRnetMU6cbRg5uTylyGnmsAB
QtiCPgHa45QNVobfIqLInzr13QO0tETDylNJaxYugVvWP5Fm7dbt2rIiIedWeExIIKy1hYFyu5pr
fvhmSvSV62Tat1ZodYZaBwNCA1uKK7r96SPxs6bNxI7Oj2t5Ln8ntYV7C1eAmXkpN1BO9sycKMN0
qGsyJfrhDRwoFB5Rp+XLVnud/HWw84IG55DKdlGw28uhkus9c2skOmfWHVI/pznGrKxOxS782R72
ecPhUxzjLT2EcHofPejK1LVf/TuLKQZkwuYE8EzQ2b7w9Wdt7A/Z/b4myQ7nKLo0k4DURUgT61d/
g+kehfITlj+ABGNAJdxykTBsfLScaLg0V4a8orIRf9bH59Z1Zy8DaQgeOC1HoRZchIY2ZcFSeb2G
PCsP27UA8j8jEiKntoI7Q8NhIrG2ho4xYKkH/UYytAE2fYx9jek/Zo8mqajksB8wZX8h0Hlb96g6
TX72bDluHUkF6J7Pi/mxPkwA5XG9tbusHvhjZrOPr3VAc1UfvSVlP2RVeXS1esNqxXsX7MLfh22w
qV+44LyJXmYW+w0TQ2nkh+McBsSYlAIWFByP7c5FdzsGaVqDxJNG2TKTb2as0SGXNZjpbKM00mu/
zAaUhrMJUUT3U7NuezrGeSPF/x+XwxZ72x+4wnxXnXgefs77Ggq/BLLhcRNoHIiCO46/kZ3JWXDE
cqpZkyiXS5wmwThK0yNm6eHZdrxdo2+wV/YOw8WS7WClriL+f3bBpMrY+5fvBRaz6u7oPRtAFrKH
zFD91AFZUE7LC9l1nqyAvfnJ6rNuqGXaSHzoPX/ohJ5Dm7gETZNoivVz4ciq1ByHXAJ40b0sP+S3
FARJsdqcr9Jk1J8CGrSp/O3m3Tnj/roJPp69SML7OTxWwOk8rLPHtaGgvtH0VpXWQrg/1/Vq0jBn
9GGh7FJPydMRkimAn/1xvcxNnIkXFYAZ9rc2Eh45uiXzFJw+vbyoZ/P4WztjG55bFmAcvulU6oWV
he26orQIrdSCEGiGsmxZDU+JlNdKCjQOzPwmAiGL08FSzethf1T8ZZN2ODXjtrBds+twuYwzXm8S
vgo4HjIajPeMvXLW1kbxD/+fXhf0kg1jl6eVSYid0Og08Gj8sOgJsGg2vk+1JlDZwiRi09nEUuXl
4Ve8fBmqdswRqWPykN0ryXzlAzUQjif6WE2nylevcu3M4oT44qQ/KRqc54qKtQXWal+sMkpOJatx
rICSrmMMIWfLLST2/H8pQYmmWfFC1mAxoZfe4Lm7sejzcboU5FuAv8zb6doJ2pnkCF62trh0YN4i
4BA+rEKPKo+WEy54YYxBkVmRgSMvoY/zil1AdzB3WkT5+r4Y9ONRQNVkfBbKjmGjk/fW4UNKNKfO
Z/wGjIcyttqEfz60qxpua3ZCHRGdm4e+xFsB/DOxPQ8m9+l0p2RUCJnrKub7jPdwlc4+WvO37h4R
0c/0Ik/plga11Jj8/f35vJTKOVmr02anZJb3nhUp0vE61hcezQMAEXXcm/6n6kmk67XhO3lDsrEB
GqXtEBEyWks1GB/nuXiMbQpKEuqXZ4BXi00lMONVpDGPNa5/1GF0d+6tRc99Cvl1XYcoVP0dHVYv
5YFxpv6GSOQxfKEWsztRCmRx5xsqMlp7apK4syG0PgGHCvBseFjLV4ZwGJIOaJbrrsc9V55/bv6b
z/hbINQNv2jHLMajPr4uot3G118tIlNIBBXXZUlV7pkRWehYz2X18gLscn/3I36PSdlJ5F05LFPJ
9ZUiQK3yAcqmVMm7jK+awFIkyoC/0gpZ8iEZgCjNDII6qnKwW/3ZTzBD+GBuL2F5/GRz/xzkqY/7
33xn5Ba8ixJ3+WxgzJRfXtdGUgh//15lG2shttcS1FngDIxJi+bAZLEi11Z3r7ykv2r4VXV3T+yu
itdCaV4NSh1VAeF21pkPvPJHb1k+55XCqUWGpaNkVUtsGwevGxf/hyspJAilGCHONxU209FLgAzb
QvvGKWWnZMdvd1XGe/XoB8pOfZqFd3sSD7PyOGraF2+14vXiSSMlxsMzYQ4zB/8KOV7rVp/mW3n5
16gQPLb309/v6Jx7vO7ZVFR08IZ7zjE+2LDX6JWWpcYSdxLJAdcO0qlgRDy1FAFK/u2dz/DaMrBX
WmVMArZTf+ExJxzP5qPhoAuh24dFA0bMxyxxgMCKmYJOeyjMRGK/4+45yESsGZKHt9CIIHSAVTxG
xmlG0EO/XklSStDIvmw8pFCL5Kytlu3DcCpe8el74jK05oebW1Bejzl9QNmkMoIJ8cWqpefJbuDO
gsJ+FVEWzKssUu13+ps6oROawe3tu9eEvh9tAledT25ODI4G0sowttlK0wdtjOkwAQaFIu4NC9PP
XwhGE1F6zVDa9DgDO788IvlhMYDMUxaBUsjJvHS+Nczo6gliwsEAmY9a2bUipkJ0fqFQtsx8CRRn
g48ltGiK5JYzI7+AmqQL0a+mFlZExsNlQCcjAmOmYr4Ib6Za5gvtjSHEqYacozRKzqFOipU+l8yG
9E//7YhJnQXb5eVnQXrZAVgNVVHZPYbxJ9zsjNUGqcaugkQA/YFnQmN1B43oKeEGQhRskpfTb5FR
qZV0dmZLUhXB38/6p4rrHsFFpG2xC4ViwRfGW3hQvmwTC9QsdiN2jQj/wg8UEZMmad8ApdR0FYPf
1VJ2qxmMCmCs9dENsSqOScEetbr5YBFro7l7Adg4Jzj/S94vekiJZUJ0q0YP3lrrpfee+VFM3A/l
vJFt9TcRl2Rc3LY5wqmAgx3EcvXOww5leC4HnO3cFO9tjnuwZ9eTkfKLe4mGLnjknE7z9d7q9JMm
Tew3RyYsqkgpUXbZEGBEnYfUGo+O5UXVP9QQtWTSLY8DPRKQicxOguYvj1klhmI2Y4piOnwbAFwP
l8Cp
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
