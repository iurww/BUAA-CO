## P2_L1_bsearch

文件上传

题目编号 896-415

## 二分查找的实现和运用

### 任务

- 使用 MIPS 汇编语言编写一个利用二分查找算法查询数字是否存在的汇编程序(不考虑延迟槽)。

### 具体要求

- 第一行为一个数字 m，为需要查找的数组大小，m<1000

- 接下来 m 行，每一行一个数字，代表数组对应的元素，整个数组中的元素不重复且从小到大排列

- 接下来一行为一个数字 n，为需要查找存在性的数字个数

- 接下来 n 行，每一行为一个数字，查询这个是否存在，存在则输出 1，不存在则输出零

- 二分查找 C 语言算法提示：

  ```clike
  int binary_search(int key,int a[],int n) //自定义函数binary_search()
  {
      int low,high,mid,count=0,count1=0;
      low=0;
      high=n-1;
      while(low<=high)    //査找范围不为0时执行循环体语句
      {
          count++;    //count记录査找次数
          mid=(low+high)/2;    //求中间位置
          if(key<a[mid])    //key小于中间值时
              high=mid-1;    //确定左子表范围
          else if(key>a[mid])    //key 大于中间值时
              low=mid+1;    //确定右子表范围
          else if(key==a[mid])    //当key等于中间值时，证明查找成功
          {
              printf("1");
              count1++;    //count1记录查找成功次数
              break;
          }
      }
      if(count1==0)    //判断是否查找失敗
          printf("0");
      return 0;
  }
  ```

- 步数限制为 200,000

- 请使用 syscall 结束程序：

  ```assembly
  li $v0, 10
  syscall
  ```

### 样例 1

- 给出以下输入：

  ```none
  3
  222
  223
  224
  2
  222
  225
  ```

- 期望的输出为：

  ```none
  1
  0
  ```

## 提交要求

- 请勿使用 `.globl main`。
- 不考虑延迟槽。
- 只需要提交 .asm 文件。
- 程序的初始地址设置（Mars->Settings->Memory Configuration）为 **Compact,Data at Address 0**。