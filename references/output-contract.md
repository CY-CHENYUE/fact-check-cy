# 输出契约

根据材料大小选择“单点核验”或“多声明审计”。保持结论可追溯，避免空泛总评。

## 1. 单点核验

```markdown
# 事实核查

## 结论

- **原始声明**：
- **规范化声明**：
- **事实结论**：支持 / 不支持 / 部分支持 / 证据冲突 / 证据不足 / 不可核验
- **表达风险**：无 / 缺少语境 / 错误归因 / 过度外推 / 因果拔高 / 过时 / 伪多源 / 其他
- **把握度**：高 / 中 / 低
- **工作流状态**：机器初判 / 待人工 / 人工确认
- **适用时间**：截至 YYYY-MM-DD

## 为什么

用 2—5 句解释证据如何支持、反驳或限制声明。不要只重复结论。

## 关键证据

1. [来源标题](URL) — 发布者，发布日期。它直接说明……；局限是……
2. [来源标题](URL) — 发布者，发布日期。它反驳／限制……

## 仍然未知

- 未解决的定义、访问限制、版本或证据缺口。

## 建议动作

- 保留原文 / 改写为…… / 删除该断言 / 标注不确定性 / 交给专业人员复核。
```

## 2. 多声明或报告审计

```markdown
# 事实核查报告

> 核验对象：……
> 模式：快速 / 标准 / 深度
> 资料截止：YYYY-MM-DD
> 覆盖：X 条实质性声明；未覆盖：……

## 结论摘要

- 支持：X
- 不支持：X
- 部分支持：X
- 证据冲突：X
- 证据不足：X
- 不可核验：X
- 最高风险：……

## 逐声明结果

| ID | 原子声明 | 事实结论 | 表达风险 | 把握度 | 工作流状态 | 关键证据 | 建议 |
|---|---|---|---|---|---|---|---|
| C01 | …… | 支持 | 时间范围被扩大 | 高 | 机器初判 | [来源](URL) | 收窄表述 |

## 重点说明

### C01：声明短标题

- **原始位置**：文件与行号、章节、URL 或时间码
- **原始表述**：……
- **声明层**：来源归因 / 底层事实 / 分析解释
- **核验所需条件**：……
- **核验说明**：……
- **支持证据**：……
- **反证或限制**：……
- **共同源组**：G1 / 无
- **结论依据**：……
- **适用时间**：……

## 来源关系与证据缺口

- G1：原始数据 A → 新闻 B → 报告 C；后两者不算独立数据源。
- 访问受限：……
- 需要补充：……

## 修改与决策建议

1. 必须修正：……
2. 标注限定：……
3. 补充证据：……
4. 需要专业复核：……
```

## 3. URL 与引用审计附表

仅当用户要求审计链接或材料含大量引用时增加：

| 引用位置 | 访问状态 | 页面身份 | 内容支持关系 | 原始出处 | 处理建议 |
|---|---|---|---|---|---|
| 第 3 段 | 可访问 | 匹配 | 只支持较弱结论 | 数据表 A | 收窄正文 |
| 脚注 7 | 访问受限 | 未确认 | 未核 | 未找到 | 不判失效，补可访问证据 |

不要把访问状态和事实结论合并成一列。

## 4. 数字审计附表

| 声明 ID | 原数值 | 原始字段/页码 | 单位与分母 | 时间与范围 | 复算 | 结论 |
|---|---:|---|---|---|---|---|
| C03 | 18% | 表 2，第 4 行 | 用户占比；n=… | 2025，中国 | 通过 | 支持 |

没有原始字段或口径时写“未提供”，不要猜。

## 5. 证据记录最小结构

需要机器可读或跨 Agent 交接时，使用：

```yaml
claim_id: C01
parent_claim_id: ""
original_span: ""
original_claim: ""
atomic_claim: ""
claim_layer: "attribution | underlying_fact | interpretation"
verification_requirements: []
context:
  claimant: ""
  published_at: ""
  geography: ""
  population: ""
  cutoff_date: ""
evidence:
  - title: ""
    publisher: ""
    url_or_path: ""
    published_at: ""
    accessed_at: ""
    role: "primary | secondary | counterevidence"
    relation: "supports | refutes | limits | irrelevant"
    direct_location: "page/table/line/timecode"
    independence_group: ""
    limitations: ""
verdict: "supported | refuted | partial | conflicting | insufficient | uncheckable"
presentation_risks: []
confidence: "high | medium | low"
evidence_status: "sufficient | insufficient | conflicting | access_limited"
workflow_status: "unverified | machine_preliminary | pending_human | human_confirmed"
rationale: ""
open_questions: []
recommended_action: ""
```

## 6. 写作规则

- 先给结论，再给证据与限制。
- 来源放在它支持的句子附近。
- 区分来源原文、来源数据和 Agent 综合判断。
- 不复制长段原文；只摘取核验所需的最短片段并遵守版权限制。
- 把访问日期和资料截止日写清楚。
- 不把证据不足写成错误，也不把单一原始来源机械降级。
- 若用户只要求回答一个事实，不输出庞大的报告模板。
- 默认不改原文件；用户明确要求修改时，先保留核查记录，再只修改已确认部分。
