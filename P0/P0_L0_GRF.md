## P0_L0_GRF

文件上传

题目编号 897-269

# 实现GRF(P0.Q2)

## 提交要求

使用logisim搭建一个GRF。

GRF中包含32个32位寄存器，分别对应0~31号寄存器，其中0号寄存器读取的结果恒为0。具体模块端口定义如下：

![2691.png](http://cscore.buaa.edu.cn/assets/cscore-image/refkxh/ce607c36-eeb1-4d0e-a12e-f7df7d7764bf/269-1.png)

模块功能定义如下：

![2692.png](http://cscore.buaa.edu.cn/assets/cscore-image/refkxh/d66424af-8540-4323-9feb-40ccd2c6819c/269-2.png)

- 必须严格按照模块的端口定义
- **0号寄存器读出的数据在任何时刻都为0**
- **请使用寄存器部件来实现GRF中的32个寄存器**
- 文件内模块名: grf
- 测试电路：(grf为你需要搭建的电路)

![2693.png](http://cscore.buaa.edu.cn/assets/cscore-image/refkxh/80982b2c-9f4f-4820-95c2-6f710a816c06/269-3.png)

- **注意:请保证模块的appearance与下图完全一致，否则有可能造成评测错误**(查看模块appearance方法:在Logisim中打开相应模块后点击左上角![2694.png](http://cscore.buaa.edu.cn/assets/cscore-image/refkxh/183c0822-7199-4822-9ceb-49ec8d166cef/269-4.png)按钮)

![2695.png](http://cscore.buaa.edu.cn/assets/cscore-image/refkxh/1afc3d18-ac53-466a-9abb-fe00a74f4d8d/269-5.png)