# 文件清单与用途

> 每个文件是干什么的、谁需要看、要不要动。

---

## 一、技能本体（缺了不能用）

| 文件 | 用途 | 谁看 |
|---|---|---|
| `skills/literature-reading/SKILL.md` | **核心**。技能的全部指令 | AI |
| `skills/literature-reading/references/config-template.md` | 配置文件模板 | AI + 用户 |
| `skills/literature-reading/references/card-template.md` | 完整卡片模板（CORE-） | AI + 用户 |
| `skills/literature-reading/references/card-template-lite.md` | 简化卡片模板（REL/METH） | AI + 用户 |
| `skills/literature-reading/references/glossary.md` | 通用术语速查 | AI + 用户 |

**这 5 个文件构成技能。缺任何一个都会导致功能不全。**

**用户实际只需要复制这一个文件夹：`skills/literature-reading/`**

---

## 二、给人看的文档

| 文件 | 用途 | 谁看 |
|---|---|---|
| `README.md` | **GitHub 主页显示**。英文版 | 所有访客 |
| `README.zh.md` | 中文版详情页 | 中文用户 |
| `QUICKSTART.md` | 快速上手（5 分钟） | 着急用的用户 |
| `docs/manual.md` | **从零开始的详细教程** | 新手用户 |
| `docs/design.md` | 架构图（ASCII + Mermaid） | 想理解设计的人 |
| `docs/files.md` | 本文件。每个文件干什么的 | 维护者 |

---

## 三、安装脚本

| 文件 | 用途 |
|---|---|
| `install/install.ps1` | 一键安装（PowerShell） |
| `install/install.cmd` | 双击入口 |

---

## 四、示例配置

| 文件 | 用途 |
|---|---|
| `example/.literature/config.md` | 填好的配置长什么样 |
| `example/cards/00-index.md` | 三分类索引示例 |
| `example/links.md` | 链接总表示例 |
| `example/papers/.gitkeep` | 占位，保持空目录 |

---

## 五、可选文件（npm 发布用）

| 文件 | 用途 | 不发布 npm 会怎样 |
|---|---|---|
| `package.json` | npm 包清单 | 不影响手动安装 |
| `cordis.patch.yml` | 插件注册配置 | 不影响手动安装 |
| `LICENSE` | MIT 协议 | 别人不确定能不能用 |

---

## 六、不提交到仓库的文件

`.gitignore` 排除了这些：

| 路径 | 为什么 |
|---|---|
| `/.literature/` | 用户自己的配置 |
| `/papers/` | 用户自己的 PDF |
| `/cards/` | 用户自己的卡片 |
| `/links.md` | 用户自己的链接表 |
| `node_modules/` | 依赖 |
| `.vscode/` `.idea/` | 编辑器配置 |

> 注意：前面加 `/` 表示只匹配**根目录**，所以 `example/papers/` 不会被误伤。

---

## 七、作者私人的文件（不在仓库里）

这些放在仓库外，比如 `F:\deepseek空间\文献阅读项目-作者资料\`：

| 文件 | 用途 |
|---|---|
| `发布到GitHub.md` | 怎么用 GitHub Desktop 发布 |
| `宣传文案.md` | 社交媒体、群分享的文案素材 |

**为什么不放仓库里**：里面写着账号名、个人情况，对用户没用。

---

## 八、仓库结构总览

```
dsh-skill-literature-reading/
│
├─ README.md                    ← 英文主页（第一印象）
├─ README.zh.md                 ← 中文版
├─ QUICKSTART.md                ← 快速上手
├─ LICENSE                      ← MIT
├─ .gitignore
│
├─ skills/                      ← ⭐ 核心
│  └─ literature-reading/
│     ├─ SKILL.md
│     └─ references/
│        ├─ config-template.md
│        ├─ card-template.md
│        ├─ card-template-lite.md
│        └─ glossary.md
│
├─ docs/
│  ├─ manual.md                 ← 完整教程
│  ├─ design.md                 ← 架构图
│  └─ files.md                  ← 本文件
│
├─ install/
│  ├─ install.cmd
│  └─ install.ps1
│
├─ example/
│  ├─ .literature/config.md
│  ├─ cards/00-index.md
│  ├─ papers/.gitkeep
│  └─ links.md
│
├─ package.json                 ← 可选（npm）
└─ cordis.patch.yml             ← 可选（插件）
```

---

## 九、GitHub 页面显示哪些

| 位置 | 显示什么 |
|---|---|
| **仓库首页** | `README.md`（没有则 `README.zh.md`） |
| **About 栏** | 需手动填（仓库右上角齿轮） |
| **文件列表** | 按字母序显示所有文件 |
| **目录** | 点进去才显示 |

**优化重点**：

1. `README.md` 前 30 行——决定访客走不走
2. About 栏的描述和 topics——决定能不能被搜到
3. 文件组织——决定别人能不能快速找到 `skills/`

---

## 十、一句话总结

| 问题 | 答案 |
|---|---|
| 最小可用的文件是什么 | `skills/literature-reading/` 整个文件夹 |
| 用户实际需要复制什么 | 就上面那一个文件夹 |
| 其他文件有什么用 | 文档（给人看）、安装脚本（省事）、npm 配置（可选） |
| 哪些可以不管 | `package.json`、`cordis.patch.yml`、`example/` |
