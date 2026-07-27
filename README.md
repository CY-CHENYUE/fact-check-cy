# fact-check-cy

一个通用的事实核查与证据审计 Skill：把数字、引文、链接、报告、网页、图表和媒体内容拆成可复核的“声明—证据—结论”记录。

它不靠固定网站白名单、链接数量或百分制可信度给材料盖章，而是检查证据是否真的支持当前声明，以及时间、地域、对象、统计口径和表达强度是否匹配。

## 适合什么任务

- 核验一句事实、一个数字或一段引文；
- 审计报告中的 URL、统计口径和关键结论；
- 检查公司披露能否支持行业级判断；
- 区分法规已经公布、已经施行或已经失效；
- 识别循环转载、共同信源、断章取义和过度外推；
- 核查图片、视频的来源记录与事件叙述。

不适合从零探索“这个行业现在发生了什么”。开放式问题先交给 `deep-research`，形成候选来源和待核声明后再进入本 Skill。

## 工作方式

```text
保留原始表述
→ 拆成原子声明
→ 盘点已有证据
→ 追到原始出处并寻找反证
→ 检查声明与证据的适配关系
→ 输出结论、表达风险、限制和建议动作
```

结论只使用：

- 支持
- 不支持
- 部分支持
- 证据冲突
- 证据不足
- 不可核验

机器核验默认标记为“机器初判”。医疗、法律、金融、安全和其他高风险判断仍需要适格人员复核。

## 安装

### Codex

```bash
git clone https://github.com/CY-CHENYUE/fact-check-cy.git ~/.codex/skills/fact-check-cy
```

### Claude Code

```bash
git clone https://github.com/CY-CHENYUE/fact-check-cy.git ~/.claude/skills/fact-check-cy
```

安装后新开一个任务，让工具重新发现 Skill。目标目录已经存在时不要直接覆盖；先检查它是旧安装、软链接还是本地开发副本。

需要锁定课堂或生产使用版本时，安装后切换到指定 commit，并记录实际 HEAD：

```bash
git -C ~/.codex/skills/fact-check-cy checkout <commit>
git -C ~/.codex/skills/fact-check-cy rev-parse HEAD
```

## 使用示例

```text
使用 $fact-check-cy 核验“这项政策已经在全国正式施行”，重点检查正式文本、生效日和适用主体。
```

```text
使用 $fact-check-cy 审计这份报告。逐条检查数字、引文和 URL 是否真的支持相邻结论，不要直接修改原文。
```

```text
使用 $fact-check-cy 检查这张图片的最早来源、编辑或生成证据，以及配文所说的时间和地点。
```

## 与 deep-research 配合

```text
开放问题
→ deep-research 建立信息版图和候选发现
→ 人选择关键待核声明
→ fact-check-cy 判断证据支持关系
→ 把可写、需限定和暂不可写的结论交给后续报告
```

两项 Skill 不重复同一阶段：`deep-research` 不给候选声明盖“已证实”的章，`fact-check-cy` 也不把宽泛主题重新做成开放式调研。

## 附带脚本

`scripts/inventory_evidence.py` 可以从文本或 Markdown 中盘点 URL、数字和日期：

```bash
python3 scripts/inventory_evidence.py path/to/report.md --format markdown
```

它只生成证据线索清单，不判断真假，也不替代逐声明核验。

## 目录

```text
fact-check-cy/
├── SKILL.md
├── agents/openai.yaml
├── references/
├── scripts/inventory_evidence.py
├── evals/evals.json
├── tests/run-tests.sh
├── assets/wechat-qr.jpg
├── README.md
└── LICENSE
```

## 开发验证

```bash
bash tests/run-tests.sh
```

## 同步与许可

- canonical source：`cc-skills/fact-check-cy/`
- 当前独立仓库是发布镜像，不是新的编辑源。
- License：Apache-2.0

## 交流

![wechat qr](assets/wechat-qr.jpg)
