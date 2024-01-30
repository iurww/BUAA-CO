## P2_L1_hanoi

文件上传

题目编号 896-330

## 单步汉诺塔

- 输入格式：

  - 输入包含1行，只包含1个1位整数，即0-9中的某一个整数，记其为n
  - 汉诺塔三根柱子的编号从左到右依次为'A','B','C',初始的时候所有盘子都在‘A'上，编号从上（小）到下（大）分别为0~n
  - 移动这些盘子到’C‘，要求移动时只能将某个柱子上最上面的盘子移动到相邻的柱子，并且任何情况下大盘子不能在小盘子上面，即A上的盘子不能直接移动到C上

- 输出格式：请参照下文的C语言样例，要求实现同粒度的输出（即能通过逐行strcmp的检测）

- 数据范围：

  - 0<n<10

- C语言样例：

  ```c
  #include <stdio.h>
  void move(int id, char from, char to) {
    printf("move disk %d from %c to %c\n", id, from, to);
  }
  void hanoi(int base, char from, char via, char to) {
    if (base == 0) {
        move(base, from, via);
        move(base, via, to);
        return;
    }
    hanoi(base - 1, from, via, to);
    move(base, from, via);
    hanoi(base - 1, to, via, from);
    move(base, via, to);
    hanoi(base - 1, from, via, to);
  }
  int main() {
    int n;
    scanf("%d", &n);
    hanoi(n, 'A', 'B', 'C');
    return 0;
  }
  ```

- 输入输出样例：

  - 输入：

    ```
    2
    ```

  - 输出：

    ```
    move disk 0 from A to B
    move disk 0 from B to C
    move disk 1 from A to B
    move disk 0 from C to B
    move disk 0 from B to A
    move disk 1 from B to C
    move disk 0 from A to B
    move disk 0 from B to C
    move disk 2 from A to B
    move disk 0 from C to B
    move disk 0 from B to A
    move disk 1 from C to B
    move disk 0 from A to B
    move disk 0 from B to C
    move disk 1 from B to A
    move disk 0 from C to B
    move disk 0 from B to A
    move disk 2 from B to C
    move disk 0 from A to B
    move disk 0 from B to C
    move disk 1 from A to B
    move disk 0 from C to B
    move disk 0 from B to A
    move disk 1 from B to C
    move disk 0 from A to B
    move disk 0 from B to C
    ```

- 有关输出格式的提示

对于输出格式感到困难的同学，可以初始化一个字符串，ID 为 0，`from` 和 `to` 都为 ‘A',然后在输出的时候替换相应的字节。这也是题目为何要求 n<10 的一个原因

## 提交要求

1. **请勿使用** `.globl main`
2. 不考虑延迟槽
3. 只需要提交.asm文件。
4. 程序的初始地址设置为**Compact,Data at Address 0**。