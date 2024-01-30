## P2_L1_calculate

文件上传

题目编号 896-35

## 字符统计

### 任务

- 使用MIPS汇编语言编写一个具有字符统计功能的汇编程序(不考虑延迟槽)。

### 具体要求

- 首先读取字符个数数n（不超过100），然后再依次读取n个小写字母字符。

- 统计每个字符出现次数。

- 最终将计算出的结果输出，若干行，每行一个字符，一个数字，表示这个字符出现了多少次，没出现过的不输出，按照字符第一次出现顺序输出。

- 步数限制为100,000

- 请使用syscall结束程序：

  ```assembly
  li $v0, 10
  syscall
  ```

### 样例1

- 给出以下输入：

  ```none
  5
  a
  b
  a
  b
  e
  ```

- 期望的输出为：

  ```none
  a 2
  b 2
  e 1
  ```

## 提交要求

- 请勿使用`.globl main`。
- 不考虑延迟槽。
- 只需要提交.asm文件。
- 程序的初始地址设置（Mars->Settings->Memory Configuration）为**Compact,Data at Address 0**。