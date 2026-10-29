# 文件清单

完整复制 `skills/literature-reading/`，不要只复制 SKILL.md。

| 文件 | 作用 |
|---|---|
| SKILL.md | 入口、权限、交互、按需读取路由 |
| references/interaction-guide.md | 首次启动、阅读方式和操作节点的用途解释及例句 |
| references/thinking-interaction.md | 思考互动强度、分层提问、反馈与可选思考记录 |
| references/onboarding.md | 可选背景问答、边读边了解与最小初始化 |
| references/config-template.md | 紧凑配置模板 |
| references/config-reference.md | 配置说明 |
| references/history.md | 历史关联提示、设置、筛选及兼容规则 |
| references/save-policy.md | 保存方式、旧配置兼容与原文归档 |
| references/research-tracks.md | 研究线索保留、增量保存与不受 N 限制的检索恢复 |
| references/output-format.md | 全部输出格式校验、PDF 提取质量及临时文件自动清理 |
| references/saving.md | 查重、增量保存、恢复写入、标题字段 |
| references/growth.md | 成长回顾与学习记录 |
| references/deep-reading.md | 按需深入模块 |
| references/card-template.md | CORE 卡片 |
| references/card-template-lite.md | REL/METH 卡片 |
| references/glossary.md | 术语速查 |
| references/knowledge-cards.md | 知识卡片建卡、查阅、更新及双向关联 |
| references/knowledge-card-template.md | 按类型调整的知识卡片模板 |

`install/` 是现有 Windows 安装入口；`example/` 是示例数据；`docs/interaction-review.md` 记录验证范围；`package.json` 和 `cordis.patch.yml` 保留 DSH 包装元数据。

根目录的 `.literature/`、`papers/`、`cards/`、`knowledge/`、`links.md` 是个人数据，已在 `.gitignore` 中排除。不要把真实阅读档案混入示例目录。

`tmp/pdfs/` 为阅读中间文件，完成并保存后可按规则清理；不属于用户文献库。源码仓库忽略 `/tmp/`，不要将测试缓存提交到 GitHub。
