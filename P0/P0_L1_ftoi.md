## P0_L1_ftoi

文件上传

题目编号 897-319

# ftoi(附加题)

本题为附加题，通过与否不计入P0课下通过条件。

## 提交要求

使用Logisim进行组合逻辑设计，要求输入一个16位的单精度浮点数（符合IEEE-754标准），输出该浮点数的整数部分(包含符号)，用32位二进制符号数表示。具体说明如下：

IEEE-754 标准中一个半精度16位浮点数的表示方法:



利用这种浮点数表示方法进行编码后的值可以分为4类，如下图所示

![3191.png](http://cscore.buaa.edu.cn/assets/cscore-image/refkxh/1355d1eb-54b2-40b8-bd40-f149806392b6/319-1.png)

- S代表最高位符号位，由sign[15]位编码，规定S=sign；

- E代表指数，由图中exponent[14:10]域编码，规定**补码**

- M代表小数点后的二进制小数位，由图中frac[9:0]域编码，Normalized的情况M永远有一位前导1，因此不占位，相当于1 + frac；而Denormalized的情况frac前面是0，M默认就是frac，即规定

  

Normalized例子：

![3192.png](http://cscore.buaa.edu.cn/assets/cscore-image/refkxh/a0392088-377b-41c3-9bf2-0b574dff28ed/319-2.png)

Denormalized例子：

![3193.png](http://cscore.buaa.edu.cn/assets/cscore-image/refkxh/bc7b0fa6-4e53-4a52-9094-4c376f7a65f0/319-3.png)

模块端口定义如下：

|   信号名    | 方向 |                             描述                             |
| :---------: | :--: | :----------------------------------------------------------: |
| float[15:0] |  I   |               16位半精度浮点数（IEEE-754标准）               |
|  int[31:0]  |  O   | 该浮点数的整数部分（带符号），用32位符号数的补码来表示，超出表示范围则取低32位。 **第3类Infinity和第4类NaN为了简化直接输出0即可** |

- 必须严格按照模块的端口定义
- 文件内模块名: **ftoi**
- 测试电路：

![3194.png](http://cscore.buaa.edu.cn/assets/cscore-image/refkxh/9389b939-ca13-4bf5-b435-17207af40b7b/319-4.png)

- **注意:请保证模块的appearance与下图完全一致，否则有可能造成评测错误**(查看模块appearance方法:在Logisim中打开相应模块后点击左上角![3195.png](http://cscore.buaa.edu.cn/assets/cscore-image/refkxh/20c7f458-7b8f-4040-8001-8e602c1c59ab/319-5.png)按钮)

![3196.png](http://cscore.buaa.edu.cn/assets/cscore-image/refkxh/a43aaf76-a974-47fb-b41c-90ad1f5b8051/319-6.png)