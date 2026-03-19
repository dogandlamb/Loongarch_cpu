本工具包默认使用 Vivado 2023.2

## 目录结构

- doc
  指令集手册、开发板等相关文档

- loongson-gnu-toolchain-8.3-x86_64-loongarch32r-linux-gnusf-v2.0.tar.xz
  LA32R交叉编译器

- func_test
    - func/
      CPU运行的功能测试程序（已预生成包含46个测试用例的程序机器码文件，可无需操作）  
      使用环境：带LA32R交叉编译器的Linux环境（安装：把LA32R交叉编译器解压到Linux环境并设置环境变量）
      可通过修改`./include/mycpu_inst.h`的宏定义值来改变测试用例数量
      使用方法：把整个`func`文件夹拷贝到带LA32R编译器的Linux环境，先用`cd`命令进入`func`再执行`make`
      需要实现的指令为：`./obj/inst_list.txt`
      功能测试程序：`./obj/test.s`
    - gettrace/
      trace文件生成工程（已预生成46个测试用例的trace文件，可无需操作）
      使用方法：每次在`func`执行`make`后，打开gettrace工程，直接运行功能仿真至结束后关闭工程即可
    - soc_verify/
      - rtl
        顶层模块、外设、IP核、myCPU等
      - run_vivado
        差分测试模板工程，直接运行功能仿真即可，不需额外再导入.coe
      - testbench
        差分测试文件
