## P1_L1_drink

文件上传

题目编号 896-327

# Verilog实现饮料售卖机控制器

## 题目要求

### 1.设计说明

请用Verilog编写一个有限状态机，实现一个饮料售卖机控制器。假设饮料价格为2元。投币器只能接受5角和1元的硬币。

当顾客投入的硬币没有达到饮料的价格(2元)时，顾客不能得到饮料，drink信号保持低电平；如果顾客按下了退币按钮，售卖机应当把顾客投入的钱返还给顾客，此时back信号应当变为相应的值，且保持一个周期。

当顾客投入的硬币大于或等于饮料的价格时，可以获得饮料，drink信号变为高电平，且保持一个周期；如果投入的硬币大于饮料价格，售卖机还应当向顾客返还相应的钱数，此时back信号应当变为相应的值，且保持一个周期。

**注意：在出货的那个周期，仍然可以投币**

### 2、模块规格

模块名：drink

|  信号名   | 方向 |                             描述                             |
| :-------: | :--: | :----------------------------------------------------------: |
|    clk    |  I   |                           时钟信号                           |
|   reset   |  I   |           异步复位信号，回归初始状态，所有输出为0            |
| coin[1:0] |  I   | 投入的硬币，2'b00代表未投币，2'b01代表投入5角，2'b10代表投入1元，2'b11代表按下退币按钮 |
|   drink   |  O   |             顾客是否能获得饮料，1代表是，0代表否             |
| back[1:0] |  O   | 售货机返还的钱数，2'b00代表不返还，2'b01代表5角，2'b10代表1元，2'b11代表1.5元 |

### 3、功能要求

每个时钟上升沿，状态机从coin中读入一个2位的二进制数字。需要在此时判断顾客是否可以获得饮料，以及售货机是否应当退还相应的钱。

### 4、输入输出样例

示例波形如下图：

![p1_drink.png](http://cscore.buaa.edu.cn/assets/cscore-image/refkxh/39e2d320-6588-4b9f-9579-6932e96292e8/p1_drink.png)

### 5、提交要求

- 必须严格按照模块的端口定义。
- 文件内模块名: drink
- **模块内不要包含任何$display语句**，以防造成误判。