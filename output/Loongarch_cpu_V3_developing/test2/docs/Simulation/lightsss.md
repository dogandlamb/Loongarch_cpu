# lightSSS 使用说明

lightSSS由香山的lightSSS移植,详细原理请看开源文档：https://docs.xiangshan.cc/zh-cn/latest/tools/lightsss/

旨在尽可能降低仿真波形带来的开销，同时尽可能保留波形信息，提升debuger效率。

## lightSSS 使用注意事项
**lightSSS仅支持verilator版本大于5.016，请将版本更新至5.016以上**

**与原先chiplab相比，std=c++11更改为std=c++14**

**移植香山lightSSS代码，FORK_CHILD=1开启后波形切分，保存尾波形，在预定位置开启波形等有关波形功能不再可用！！！其他功能与原版chiplab功能一致。**

## 使用方法

当需要启动lightSSS时，需要修改sims/verilator/run_prog/Makefile_run文件

修改FORK_CHILD=1 即为开启lightSSS功能（不需要开启DUMP_WAVEFORM）
```
DUMP_WAVEFORM=0
FORK_CHILD=1
```

依照正常使用chiplab方法运行。

即可看到fork_simu_trace.{fst,vcd}文件的生成

注：**由于lightSSS依赖子进程运行两次，因此log重复生成属于正常现象**

注: **如果你切换到正确的verilator版本后lightSSS仍然没有正常运行，请先clean**
## 参数说明
可以使用./configure.sh {编译参数} {参数} 修改以下参数
- `--fork-interval` : 每多长时间（ms）fork一个子进程
- `--slot-size`     : 同时最多支持多少个子进程存在，多余的会被kill掉
- `--wait-interval` : 子进程每隔多长时间（seconds）检查父进程的信号
## 测试
已在Openla500上验证lightSSS功能，且运行时间有显著下降，预计大型规模波形测试上可以带来10倍左右的性能提升。

