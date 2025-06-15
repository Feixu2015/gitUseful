# gitUseful
一些用于git查询的高阶脚本

## queryMapperMethodXmlChange.sh
[queryMapperMethodXmlChange.sh](./queryMapperMethodXmlChange.sh)
适用于java应中用于追踪Mybatis的Mapper的XML文件中某个方法的变更。
参数有四个：方法名，相对于根目录的文件路径，输出MarkDown文件名，分支名。
主要功能分为三个部分：
### 1. 配置管理
支持自定义目标方法名（METHOD）、文件路径（FILE）和输出文件（OUTPUT）
可设置追踪范围：指定分支（BRANCH）和时间段（SINCE/UNTIL）
### 2. 历史扫描
通过git rev-list扫描Git提交记录
精准定位所有修改过目标文件的提交版本
### 3. 文档生成
自动创建Markdown格式的变更报告
对每个相关提交：
记录提交人、时间、说明等元信息
提取并保留该次提交中目标方法的完整代码片段
最终输出包含时间戳和变更次数统计的完整报告

典型应用场景：当需要审查某个关键方法（如数据库操作方法）的演变过程时，通过该脚本可快速生成包含所有历史变更节点的可追溯文档。
### 输出示例
=====================================================
#### 提交 `1fde558545308b7b858f69016395a9cb8d2afdb6`
##### 提交信息
* 提交人：`user1 <user1@xxx.com>`
* 提交时间：`Tue Jan 16 16:16:53 2024 +0800`
* 提交说明：修改xxx查询问题
* 详情：

```xml
  <select id="pageByCondition" resultType="java.util.HashMap">
    select 2 from dual
  </select>
```

#### 提交 `a6ba163ceda934bcf1e090adb4b768ab4d3e1f94`
##### 提交信息
* 提交人：`user2 <user2@xxx.com>`
* 提交时间：`Sun Dec 24 21:54:01 2023 +0800`
* 提交说明：修改xxx
* 详情：

```xml
  <select id="pageByCondition" resultType="java.util.HashMap">
    select 1 from dual
  </select>
```
=====================================================
