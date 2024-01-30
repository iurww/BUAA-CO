## P0_L0_FSM

文件上传

题目编号 897-9

# Logisim中的FSM(P0.Q4)

## 正则表达式匹配

正则表达式是对字符串操作的一种逻辑公式，它通常被用来检索、替换符合某个模式的文本。它的规则比较复杂，我们现在只讲解其中比较简单的几种规则。

- [...]是指要匹配中括号中的字符(注意是字符不是字符串),比如[xyz]就是要匹配x y z这三个字符中的任意一个。
- {...}是指要求匹配”{“前的那个字符几次，比如a{2}是指要匹配a两次，a{2,4}是指要匹配a 2至4次,a{,4}指要匹配a 0至4次，a{2,}指要匹配a 2至无穷次。所以[cd]{1,2}就是要求匹配(c或d)一次或两次,即cc、dd、cd、dc、c、d都是能匹配的。
- (...)是指将()内的字符串视为一个整体，比如(ab){1,2}对应的就是ab或abab。
- 我们也可以将多条表达式组合起来，如a{2}b{2}就是指匹配a两次后再匹配b两次,即匹配aabb。

## 提交要求

使用Logisim搭建一个Mealy型有限状态机 检测串行输入字符串中的能匹配正则表达式b{1,2}[ac]{2}的子串并输出。具体模块端口定义如下：

![91.png](http://cscore.buaa.edu.cn/assets/cscore-image/refkxh/a216d4b4-f5a2-42d3-826b-809434d21829/9-1.png)

模块功能定义如下：

![92.png](http://cscore.buaa.edu.cn/assets/cscore-image/refkxh/132120db-39b9-4083-b224-52f0b1729978/9-2.png)

- 必须严格按照模块的端口定义
- 文件内模块名: fsm
- **注意: 每当匹配到一个子串时，需要输出一次1。例如对字符串bacbacac,模块应当在第1个c输入和第2个c输入时输出1,而在其他时刻保持输出为0。**
- **注意：有限状态机的设计是Mealy型有限状态机。**
- 测试电路如下：(code部分是你需要搭建的电路)

![93.png](http://cscore.buaa.edu.cn/assets/cscore-image/refkxh/bc2d20f2-2f34-4582-bfef-0844d90ef338/9-3.png)

- **注意:请保证模块的appearance与下图完全一致，否则有可能造成评测错误**(查看模块appearance方法:在Logisim中打开相应模块后点击左上角![94.png](http://cscore.buaa.edu.cn/assets/cscore-image/refkxh/8d0ddcc3-d17b-45ee-bf32-8ce2d9511b78/9-4.png)按钮)

![95.png](http://cscore.buaa.edu.cn/assets/cscore-image/refkxh/33e43d0f-e089-43ef-bf2d-55eb664b6f8c/9-5.png)