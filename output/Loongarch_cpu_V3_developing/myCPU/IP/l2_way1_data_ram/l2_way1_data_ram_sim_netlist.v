// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue Jun  9 20:29:59 2026
// Host        : admin running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top l2_way1_data_ram -prefix
//               l2_way1_data_ram_ l2_way0_data_ram_sim_netlist.v
// Design      : l2_way0_data_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "l2_way0_data_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
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
  (* C_INIT_FILE = "l2_way0_data_ram.mem" *) 
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 51904)
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
