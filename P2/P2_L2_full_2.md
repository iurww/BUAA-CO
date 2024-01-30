## P2_L2_full_2

文件上传

题目编号 896-53

## 倒序全排列

### 任务

- 使用mips实现全排列生成算法
- 输入一个小于等于7的正整数，求出n的全排列，并按照字典序**倒序**输出

### 具体要求

- 只输入一行，输入一个整数n(0<n<=7)

- 按照字典序**倒序**输出n!行数组，每行输出n个数字，数字之间以空格隔开，每行最后一个数字后可以有空格

- 步数限制为500,000

- 请使用syscall结束程序：

  ```assembly
  li $v0, 10
  syscall
  ```

### 正序输出的全排列的C代码提示

![MARS_code_911.png](http://10.212.27.185:9199/cscore-image/zhongzihao@buaa.edu.cn_old/bb1566f4-cbb8-4e7d-88f5-b4da8b295ce4/MARS_code_911.png)

### 样例

- 给出以下输入：

  ```none
  3
  ```

- 期望的输出为：

  ```none
  3 2 1
  3 1 2
  2 3 1
  2 1 3
  1 3 2
  1 2 3
  ```

## 提交要求

- 请勿使用`.globl main`。
- 不考虑延迟槽。
- 只需要提交.asm文件。
- 程序的初始地址设置（Mars->Settings->Memory Configuration）为**Compact,Data at Address 0**。