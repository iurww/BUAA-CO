## P2_L2_add

文件上传

题目编号 896-52

## 矩阵转置相加

### 任务

- 使用MIPS汇编语言编写一个具有矩阵**转置相加**功能的汇编程序(不考虑延迟槽)。

### 具体要求

- 首先读取矩阵的行数n和列数m，然后再依次读取第一个矩阵（n行m列）和第二个矩阵（n行m列）中的元素。

- 两个矩阵的行列数分别相同，但n与m不一定相同。

- 测试数据中 0<n,m≤8。

- 最终输出矩阵**转置**后相加的结果。

- 输出中，每行n个数据，每个数据间用**空格**分开。每行最后一个数据后面没有空格，最后一行最后一个数据后面什么都没有。

- 要有输出提示语句 `The result is:`。

- 指令条数限制：100,000

- 请使用syscall结束程序：

  ```assembly
  li $v0, 10
  syscall
  ```

### 样例

![P2_L1_Q4_1.png](http://10.212.27.185:9199/cscore-image/zhongzihao@buaa.edu.cn_old/afecea50-b5c2-4e8f-af18-e7dfeaa4add8/P2_L1_Q4_1.png)

- 比如我们想要计算上面这个式子的结果，我们会给出以下输入：

  ```none
  2
  2
  1
  2
  3
  4
  5
  6
  7
  8
  ```

- 期望的输出为：

  ```none
  The result is:
  6 10
  8 12
  ```

## 提交要求

- 请勿使用`.globl main`。
- 不考虑延迟槽。
- 只需要提交.asm文件。
- 程序的初始地址设置（Mars->Settings->Memory Configuration）为**Compact,Data at Address 0**。