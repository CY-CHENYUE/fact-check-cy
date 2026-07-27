# 可选领域配置

领域配置用于补充法规、术语、证据要求和人工审批边界。它不能替代通用核验流程，也不能把指定来源预设为永远正确。

## 1. 何时需要

- 项目有明确司法辖区、监管要求或内部合规规则；
- 某类数据有法定主数据源或统一口径；
- 用户要求只使用指定来源；
- 高风险任务必须由特定专业角色复核；
- 团队要在多个任务中复用相同的术语、截止时间和验收规则。

不需要为了普通单点核验创建配置。

## 2. 推荐结构

```yaml
profile_name: ""
scope:
  domain: ""
  jurisdiction: ""
  audience: ""
  cutoff_date: ""

definitions:
  key_term: "项目内采用的定义及出处"

source_policy:
  preferred_primary_sources:
    - name: ""
      applies_to: "它适合证明什么"
      limitations: "它不能单独证明什么"
  required_source_types: []
  disallowed_or_limited_sources:
    - type: ""
      reason: ""
  archive_requirements: ""

claim_requirements:
  - claim_type: ""
    required_fields: []
    minimum_evidence: "按该声明性质描述，不写机械链接数"
    required_counterchecks: []

risk_policy:
  high_stakes_topics: []
  human_review_required_when: []
  prohibited_inferences: []

output_policy:
  terminology: ""
  citation_style: ""
  mandatory_disclosures: []
```

## 3. 设计规则

### 为来源声明适用范围

不要写：

```yaml
trusted_sources:
  - 某机构
```

应写：

```yaml
preferred_primary_sources:
  - name: 某主管机关法规数据库
    applies_to: 已公布法规文本、修订历史和生效日期
    limitations: 不单独回答个案如何适用；仍需核对司法辖区和现行版本
```

### 为声明类型规定证据，不为结论预设答案

不要写“出现两条来源就通过”。可以写：

```yaml
claim_requirements:
  - claim_type: 产品保障范围
    required_fields:
      - 正式条款版本
      - 投保须知
      - 特别约定
      - 适用地区和时间
    minimum_evidence: 以该产品当前有效的正式文件为主，营销页只能作为待核表述
    required_counterchecks:
      - 免责与等待期
      - 医院范围
      - 文件之间的冲突
```

### 明确人工边界

对医疗建议、法律解释、投资决策、承保/理赔结论等写明：

- Agent 可以整理证据和暴露冲突；
- 哪些结论必须由何种角色复核；
- 哪些信息缺失时必须停止；
- 是否允许给终端用户直接展示。

## 4. 使用顺序

1. 先运行通用声明拆分。
2. 读取适用领域配置。
3. 将配置中的术语、证据类型和审批边界映射到声明。
4. 仍按实际证据形成结论。
5. 在输出中注明使用了哪个配置及版本。

若配置与原始法规、用户临时明确指令或新证据冲突，披露冲突并暂停相关结论；不要静默服从过时配置。

## 5. 维护

- 每个配置写版本、负责人和复核日期；
- 法规、产品条款或数据口径变化后重新复核；
- 把具体客户、内部系统和私有数据源留在项目配置中，不写入通用 Skill；
- 删除不再适用的“权威白名单”，保留来源的适用范围和局限。
