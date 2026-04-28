# fact-check-cy

调研报告事实核查与质控 skill。AI 生成的 URL 错误率约 60%，精确数字常有"创造性合并"幻觉——本 skill 自动核查报告中所有 URL 是否真实可达、数字是否能溯源、关键论点是否有 ≥2 个独立信源支撑、信源是否权威、有无自相矛盾。

## 安装

```bash
cd ~/.claude/skills
git clone https://github.com/CY-CHENYUE/fact-check-cy.git
```

## 触发词

- 事实核查、查证、核实数据、验证报告、溯源
- 看看 URL 有没有问题、这些数字靠不靠谱
- 三角验证、CRAAP、核对引用
- fact check、verify sources

**主动触发场景**：刚完成 deep-research / market-researcher-cy / competitive-analyst-cy 调研、即将交付报告或做关键决策时。

## 核心方法（基于市场调研 SOP P4）

| 模块 | 内容 |
|---|---|
| **SIFT 快筛** | Stop / Investigate / Find better / Trace claims |
| **CRAAP 深评** | Currency 时效性 / Relevance 相关性 / Authority 权威性 / Accuracy 准确性 / Purpose 目的性 |
| **四维三角验证** | 数据源 / 方法论 / 调查者 / 理论 4 类交叉 |
| **AI 幻觉 7 项检查** | 精确数字溯源 / 张冠李戴 / URL 验证 / 逻辑一致性 / 过度外推 / 时间线 / 综合幻觉 |

详细方法论与评分细则见 [reference.md](./reference.md)。

## 双档模式

| 模式 | 适用 | 时间 | 内容 |
|---|---|---|---|
| **light**（默认） | 日常调研、初步判断 | ~5 分钟 | URL 健康度 + AI 幻觉 7 项 + 关键数字溯源 + 基础 ≥2 源交叉 |
| **deep** | 战略决策、IP 引入这类高赌注场景 | ~15-20 分钟 | light + 完整 CRAAP 5 维 + 四维三角验证 |

触发示例：
- "核查这份报告"（light，默认）
- "深度核查这份报告"（deep）
- "这个 940 万的数据是真的吗"（单点核查）

## 输出

按以下结构生成 markdown 核查报告：

1. 总览（可信度评分 + 通过/待补强/不通过统计）
2. URL 健康度（X / Y 个）
3. 数据点溯源（X / Y 个）
4. CRAAP 评估（仅 deep 模式）
5. 三角验证缺口
6. AI 幻觉 7 项 checklist
7. 矛盾检测
8. 行动建议（top 3 风险：必删 / 必补源 / 建议核实）

## 工具依赖

仅依赖 web 工具（无外部 API、无浏览器自动化、无付费数据源）：

- WebFetch、WebSearch
- Read、Grep、Glob、Bash

## 与其他 skill 的协作

```
deep-research / market-researcher-cy / competitive-analyst-cy
       │
       │ （输出调研报告）
       ↓
   fact-check-cy ←───── 用户触发：「核查一下」
       │
       │ （输出核查报告 + 风险清单）
       ↓
  人工拍板修改报告
```
