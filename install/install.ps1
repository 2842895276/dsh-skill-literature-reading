# 一键安装（Windows）
#
# 双击 install.cmd 即可。
# 会问你要装到哪，然后复制过去。

$ErrorActionPreference = "Stop"
chcp 65001 > $null

$repo = Split-Path -Parent $PSScriptRoot
$src  = Join-Path $repo "skills\literature-reading"

function Write-Header {
    Write-Host ""
    Write-Host "  DSH 文献阅读技能 · 安装" -ForegroundColor Cyan
    Write-Host "  ─────────────────────────────" -ForegroundColor DarkGray
    Write-Host ""
}

function Fail($msg) {
    Write-Host ""
    Write-Host "  X $msg" -ForegroundColor Red
    Write-Host ""
    Read-Host "  按回车退出"
    exit 1
}

# 检查源
if (-not (Test-Path (Join-Path $src "SKILL.md"))) {
    Write-Header
    Fail "找不到技能文件：$src\SKILL.md  请确认本文件在仓库的 install 目录下。"
}

# 选择安装位置
Write-Header
Write-Host "  装到哪里？" -ForegroundColor Yellow
Write-Host ""
Write-Host "    1  全局（推荐）" -ForegroundColor White
Write-Host "       $env:USERPROFILE\.agents\skills\" -ForegroundColor DarkGray
Write-Host "       -> 所有项目都能用，装完需重启 DSH" -ForegroundColor DarkGray
Write-Host ""
Write-Host "    2  指定项目" -ForegroundColor White
Write-Host "       <你的项目>\.dsh\skills\" -ForegroundColor DarkGray
Write-Host "       -> 只有那个项目能用，不用重启" -ForegroundColor DarkGray
Write-Host ""
Write-Host "    3  自定义目录" -ForegroundColor White
Write-Host "       任意位置，需你自己在 DSH 里注册" -ForegroundColor DarkGray
Write-Host ""
Write-Host "    4  其他桌面端（Cursor / Claude 等）" -ForegroundColor White
Write-Host "       输出各平台的安装说明" -ForegroundColor DarkGray
Write-Host ""

$choice = Read-Host "  选 [1-4，直接回车 = 1]"
if ([string]::IsNullOrWhiteSpace($choice)) { $choice = "1" }

$dest = $null
$needRestart = $false

switch ($choice) {
    "1" {
        $dest = Join-Path $env:USERPROFILE ".agents\skills\literature-reading"
        $needRestart = $true
    }
    "2" {
        Write-Host ""
        Write-Host "  输入你的项目路径（例：F:\我的文献项目）" -ForegroundColor Gray
        $proj = Read-Host "  项目路径"
        if ([string]::IsNullOrWhiteSpace($proj)) { Fail "没输入项目路径" }
        if (-not (Test-Path $proj)) {
            Write-Host "  该路径不存在，要新建吗？[Y/n]" -ForegroundColor Yellow
            $yn = Read-Host
            if ($yn -eq "n" -or $yn -eq "N") { Fail "已取消" }
            New-Item -ItemType Directory -Path $proj -Force | Out-Null
        }
        $dest = Join-Path $proj ".dsh\skills\literature-reading"
    }
    "3" {
        Write-Host ""
        Write-Host "  输入完整目标路径（会在这里建 literature-reading 文件夹）" -ForegroundColor Gray
        Write-Host "  例：F:\my-skills" -ForegroundColor DarkGray
        $custom = Read-Host "  目标目录"
        if ([string]::IsNullOrWhiteSpace($custom)) { Fail "没输入路径" }
        $dest = Join-Path $custom "literature-reading"
        Write-Host ""
        Write-Host "  ! 自定义目录需要在 DSH 里注册后才能被识别：" -ForegroundColor Yellow
        Write-Host "    在 DSH 的技能中心 -> 设置 -> 添加自定义技能目录" -ForegroundColor Gray
        Write-Host "    或改 profile 的 cordis.patch.yml，加 customSkillDirs" -ForegroundColor Gray
    }
    "4" {
        Write-Header
        Write-Host "  其他桌面端的安装方式" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  [Cursor]" -ForegroundColor Yellow
        Write-Host "    把 SKILL.md 内容复制到 项目\.cursor\rules\ 下的 .mdc 文件" -ForegroundColor Gray
        Write-Host "    或直接放到 项目根目录 的 .cursorrules" -ForegroundColor Gray
        Write-Host ""
        Write-Host "  [Cline / Roo Code]" -ForegroundColor Yellow
        Write-Host "    放到 项目根目录 的 .clinerules" -ForegroundColor Gray
        Write-Host ""
        Write-Host "  [Claude Projects]" -ForegroundColor Yellow
        Write-Host "    新建 Project -> 把 SKILL.md 内容粘贴到 Project instructions" -ForegroundColor Gray
        Write-Host "    references 里的模板作为 Project knowledge 上传" -ForegroundColor Gray
        Write-Host ""
        Write-Host "  [ChatGPT 自定义 GPT]" -ForegroundColor Yellow
        Write-Host "    Create a GPT -> Instructions 里粘贴 SKILL.md" -ForegroundColor Gray
        Write-Host "    Knowledge 里上传 references 的文件" -ForegroundColor Gray
        Write-Host ""
        Write-Host "  [网页版 ChatGPT / 豆包 / Kimi]" -ForegroundColor Yellow
        Write-Host "    每次对话开头手动粘贴 SKILL.md，再附上论文" -ForegroundColor Gray
        Write-Host "    （最麻烦，但能用）" -ForegroundColor Gray
        Write-Host ""
        Write-Host "  -----------------------------" -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  要现在把技能文件复制到某个位置吗？" -ForegroundColor Yellow
        Write-Host "    1 = 复制到 Cursor 的 .cursor\rules\" -ForegroundColor Gray
        Write-Host "    2 = 只打开技能文件夹，我自己复制" -ForegroundColor Gray
        Write-Host "    3 = 退出" -ForegroundColor Gray
        $sub = Read-Host "  选 [1-3]"
        switch ($sub) {
            "1" {
                $proj = Read-Host "  输入项目路径"
                if ([string]::IsNullOrWhiteSpace($proj)) { Fail "没输入" }
                $rulesDir = Join-Path $proj ".cursor\rules"
                New-Item -ItemType Directory -Path $rulesDir -Force | Out-Null
                Copy-Item (Join-Path $src "SKILL.md") (Join-Path $rulesDir "literature-reading.mdc") -Force
                $refDir = Join-Path $rulesDir "literature-reading-references"
                New-Item -ItemType Directory -Path $refDir -Force | Out-Null
                Copy-Item (Join-Path $src "references\*") $refDir -Force
                Write-Host ""
                Write-Host "  OK 已复制到 $rulesDir" -ForegroundColor Green
                Write-Host "     注意：Cursor 的 .mdc 需要手动加 frontmatter（description / globs）" -ForegroundColor Yellow
                Write-Host ""
                Read-Host "  按回车退出"
                exit 0
            }
            "2" {
                Start-Process explorer.exe $src
                Write-Host ""
                Write-Host "  已打开：$src" -ForegroundColor Green
                Write-Host "  自己复制到对应位置即可。" -ForegroundColor Gray
                Write-Host ""
                Read-Host "  按回车退出"
                exit 0
            }
            default { exit 0 }
        }
    }
    default { Fail "无效选项：$choice" }
}

# 目标已存在则备份
if (Test-Path $dest) {
    $stamp  = Get-Date -Format "yyyyMMdd-HHmmss"
    $backup = "$dest.backup-$stamp"
    Move-Item $dest $backup
    Write-Host ""
    Write-Host "  旧版本已备份到：$backup" -ForegroundColor Yellow
}

# 复制
try {
    New-Item -ItemType Directory -Path (Split-Path $dest) -Force | Out-Null
    Copy-Item $src $dest -Recurse -Force -ErrorAction Stop
} catch {
    Write-Host ""
    Write-Host "  X 复制失败：$($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "  可能的原因：" -ForegroundColor Yellow
    Write-Host "    1. 目标目录被占用 -> 先关闭 DSH 再试" -ForegroundColor Gray
    Write-Host "    2. 权限不足 -> 右键本文件「以管理员身份运行」" -ForegroundColor Gray
    Write-Host "    3. 杀毒软件拦截 -> 临时关闭后再试" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  手动安装：" -ForegroundColor Cyan
    Write-Host "    复制 $src" -ForegroundColor Gray
    Write-Host "    到   $dest" -ForegroundColor Gray
    Write-Host ""
    Read-Host "  按回车退出"
    exit 1
}

# 验证
$ok = Test-Path (Join-Path $dest "SKILL.md")
$refs = @("onboarding.md","config-template.md","card-template.md","card-template-lite.md","glossary.md")
$missing = @()
foreach ($r in $refs) {
    if (-not (Test-Path (Join-Path $dest "references\$r"))) { $missing += $r }
}

Write-Host ""
if ($ok -and $missing.Count -eq 0) {
    Write-Host "  OK 安装成功" -ForegroundColor Green
    Write-Host ""
    Write-Host "     位置：$dest" -ForegroundColor Gray
    Write-Host "     文件：SKILL.md + 5 个参考文件" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  接下来：" -ForegroundColor Cyan
    if ($needRestart) {
        Write-Host "     1. 完全退出 DeepSeek Harness（托盘图标右键 -> 退出）" -ForegroundColor Gray
        Write-Host "     2. 重新打开" -ForegroundColor Gray
        Write-Host "     3. 新建对话，输入「读这篇论文」" -ForegroundColor Gray
    } else {
        Write-Host "     1. 在项目文件夹里打开 DSH 对话" -ForegroundColor Gray
        Write-Host "     2. 输入「读这篇论文」" -ForegroundColor Gray
        Write-Host "     （装到项目里不用重启）" -ForegroundColor DarkGray
    }
    Write-Host ""
    Write-Host "  验证：如果技能生效，它会先问你几个问题，而不是直接分析。" -ForegroundColor DarkGray
} else {
    Write-Host "  X 安装不完整" -ForegroundColor Red
    if (-not $ok) { Write-Host "    缺少 SKILL.md" -ForegroundColor Gray }
    if ($missing.Count -gt 0) { Write-Host "    缺少参考文件：$($missing -join ', ')" -ForegroundColor Gray }
}

Write-Host ""
Read-Host "  按回车退出"
