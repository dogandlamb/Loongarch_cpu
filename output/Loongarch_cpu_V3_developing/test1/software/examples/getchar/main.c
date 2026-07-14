#include <stdio.h> 

//BSP板级支持包所需全局变量
unsigned long UART_BASE = 0xbfe001e0;					//UART16550的虚地址
unsigned long CONFREG_UART_BASE = 0xbfafff10;			//CONFREG模拟UART的虚地址
unsigned long CONFREG_TIMER_BASE = 0xbfafe000;			//CONFREG计数器的虚地址
unsigned long CONFREG_CLOCKS_PER_SEC = 100000000L;		//CONFREG时钟频率
unsigned long CORE_CLOCKS_PER_SEC = 33000000L;			//处理器核时钟频率

int main() {
	char c;
	char a[100];

	//getchar测试，输入一个字符后需要加回车(0x0a)一起发；putchar需要跟putchar('\n')才会真正输出
	printf("please input one char:\n");
	c = getchar();
	printf("this char is:\n");
	putchar(c);
	putchar('\n');

	//scanf测试，输入字符串后也需要加回车(0x0a)一起发
  	printf("please input string:\n");
  	scanf("%s",a);
  	printf("this string is:\n");
	printf("%s\n",a);
	return 0;
}