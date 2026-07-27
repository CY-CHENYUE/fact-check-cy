# 方法依据与适用边界

最后复核：2026-07-28。

这些资料用于约束 Skill 的方法，不是待核声明的通用“权威来源列表”。

## 1. 公开事实核查原则

### IFCN Code of Principles

- 页面：<https://ifcncodeofprinciples.poynter.org/the-commitments>
- 支持的设计：非党派与一致标准、来源透明、方法透明、组织与资金透明、公开更正；尽量提供足够细节让读者复核，并优先使用最合适的一手来源。
- 边界：IFCN 针对公开发布事实核查的组织。本 Skill 只借鉴其透明与可复核原则，不声称符合认证，也不把新闻事实核查规则机械套到所有企业任务。

### Full Fact：方法与常见问题

- 页面：<https://fullfact.org/about/>
- 常见问题：<https://fullfact.org/about/frequently-asked-questions/>
- 支持的设计：核验事实而不是给人贴标签；提供可自行复核的来源；AI 用于辅助发现和处理信息而不替代人工研究与编辑；复杂结论不应被压成简单真假标签。
- 边界：这是一个事实核查机构的方法说明，不是跨领域强制标准。

## 2. 横向阅读与 SIFT

### SIFT 原始介绍

- 页面：<https://hapgood.us/2019/05/12/sift-and-a-check-please-preview/>
- 支持的设计：Stop、调查来源、寻找更好覆盖、追溯原始语境；将其作为快速行动序列。
- 边界：用于开放网络信息初筛，不能替代专业统计、法律、医学或媒体取证。

### Digital Inquiry Group Civic Online Reasoning

- 页面：<https://cor.inquirygroup.org/curriculum/collections/teaching-lateral-reading/>
- 支持的设计：离开陌生网站，查看其他来源如何描述它；横向阅读通常优于只在网站内部评估其自我陈述。
- 边界：主要是网络信息素养与教学研究，不直接给出所有领域的证据等级。

## 3. 声明与核查结果结构

### Schema.org Claim

- 页面：<https://schema.org/Claim>
- 支持的设计：保存声明本身、作者、出现位置、时间和足够上下文，避免脱离语境。

### Schema.org ClaimReview

- 页面：<https://schema.org/ClaimReview>
- 支持的设计：把声明、核查者、核查日期、来源和评级组织成可交换结构。
- 边界：数据结构正确不代表核查结论正确。

### Google Fact Check Tools API

- 页面：<https://developers.google.com/fact-check/tools/api/reference/rest>
- 支持的设计：已有 ClaimReview 可以作为线索检索，帮助发现重复声明。
- 边界：先前核查不能替代对当前语境、版本和证据的复核。

## 4. 自动事实核查研究

### FEVER

- 论文：<https://aclanthology.org/N18-1074/>
- 支持的设计：将流程分为声明、证据检索、证据选择和结论；使用支持、反驳、证据不足等标签。
- 边界：数据主要由 Wikipedia 句子构造，不代表完整开放世界核验。

### AVeriTeC

- 论文：<https://proceedings.neurips.cc/paper_files/paper/2023/hash/cd86a30526cd1aff61d6f89f107634e4-Abstract-Datasets_and_Benchmarks.html>
- 支持的设计：面向真实世界声明，以问题—答案证据、来源和理由支持结论；强调避免时间泄漏和保留上下文。
- 边界：仍是基准数据集；系统在基准上的表现不能替代真实任务中的人工复核。

### 复杂声明拆分与开放网页证据

- 论文：<https://aclanthology.org/2024.naacl-long.196/>
- 支持的设计：复杂声明核验需要声明拆解、原始文档检索、细粒度证据和面向声明的综合。
- 边界：该流程来自研究系统设计，不代表所有简单声明都需要完整流水线。

### 拆分的局限

- 论文：<https://aclanthology.org/2025.naacl-long.320/>
- 支持的设计：声明拆分可能帮助检索，也可能引入噪声并损害最终表现；需要保留原文映射和覆盖检查。
- 边界：研究结论依赖数据与系统设置，不能据此完全取消拆分。

### Automated Fact-Checking Survey

- 论文：<https://aclanthology.org/2022.tacl-1.11/>
- 支持的设计：自动核查通常包含声明检测、证据检索与验证等阶段；证据质量和任务定义会直接限制结果。
- 边界：综述描述研究版图，不提供适用于所有组织的单一工作流。

## 5. 来源谱系

### W3C PROV-O

- 页面：<https://www.w3.org/TR/prov-o/>
- 支持的设计：用“引用自、修订自、源自主来源”等关系记录证据谱系，识别多个页面是否共享上游。
- 边界：PROV-O 是通用来源数据模型，不会自动判断来源独立性或事实真假。

## 6. 链接访问状态

### RFC 9110 HTTP Semantics

- 页面：<https://www.rfc-editor.org/rfc/rfc9110.html#section-15.5.4>
- 支持的设计：403 表示服务器理解请求但拒绝处理；访问被拒绝不等于被引用事实为假。
- 边界：HTTP 状态只描述一次请求的结果，不证明页面身份、历史内容或声明支持关系。

## 7. AI 风险与人工复核

### NIST AI 600-1

- 页面：<https://www.nist.gov/publications/artificial-intelligence-risk-management-framework-generative-artificial-intelligence>
- PDF：<https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.600-1.pdf>
- 支持的设计：对生成式 AI 结果使用已知基准、多种评估方法、来源记录和适当人工监督。
- 边界：它是生成式 AI 风险管理 Profile，不是新闻或法律意义上的事实核查认证。

## 8. 数字媒体来源凭证

### C2PA 2.4 Explainer

- 页面：<https://spec.c2pa.org/specifications/specifications/2.4/explainer/Explainer.html>
- 支持的设计：内容凭证用于验证来源记录、签名和修改历史；来源记录可能不完整。
- 关键边界：来源凭证本身不能说明图片、视频或其中陈述的现实内容真实、准确。
