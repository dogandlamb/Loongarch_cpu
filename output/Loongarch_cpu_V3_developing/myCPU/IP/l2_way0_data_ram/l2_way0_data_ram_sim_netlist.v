// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue Jun  9 20:30:00 2026
// Host        : admin running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/h546d/Desktop/chiplab_for_Vivado/IP/myCPU/IP/l2_way0_data_ram/l2_way0_data_ram_sim_netlist.v
// Design      : l2_way0_data_ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "l2_way0_data_ram,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module l2_way0_data_ram
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
  l2_way0_data_ram_blk_mem_gen_v8_4_7 U0
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
