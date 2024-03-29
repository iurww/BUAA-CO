## P1_L1_vote_plus

文件上传

题目编号 896-424

### 投票表决器Plus

现在需要你用Verilog语言编写一个投票表决器。投票者的类型分为np（normal person），vip和vvip三种，每种投票者的人数和一票所对应的权值如下表所示：

| 投票者类型 | 人数 | 每票权值 |
| :--------- | :--- | :------- |
| np         | 32   | 1        |
| vip        | 8    | 4        |
| vvip       | 1    | 16       |

该模块在**每个时钟上升沿读取投票信号**并更新权值。若某一投票者已经投过票，则将其视为**在以后的每个时钟周期内均投票**。

模块端口定义如下：

| 信号名      | 方向 | 描述                                             |
| :---------- | :--- | :----------------------------------------------- |
| clk         | I    | 时钟信号                                         |
| reset       | I    | 异步复位信号（高电平有效，复位时将投票记录清空） |
| np[31:0]    | I    | 每一位代表一个np（高电平有效）                   |
| vip[7:0]    | I    | 每一位代表一个vip（高电平有效）                  |
| vvip        | I    | 代表一个vvip（高电平有效）                       |
| result[7:0] | O    | 当前权值                                         |

## 提交要求

- 必须严格按照模块的端口定义
- 文件内模块名：VoterPlus
- **模块内不要包含任何$display语句** ，以防造成误判
- 我们保证在使用模块前进行复位