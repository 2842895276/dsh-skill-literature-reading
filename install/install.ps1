# Windows PowerShell 5.1 / PowerShell 7
[CmdletBinding()]
param(
    [ValidateSet('Codex','DSH')][string]$Platform,
    [ValidateSet('Project','User')][string]$Scope,
    [string]$ProjectPath,
    [switch]$NoPause
)
$ErrorActionPreference = 'Stop'

function Assert-PlainTree([string]$Path) {
    if (Test-Path -LiteralPath $Path) {
        $item = Get-Item -LiteralPath $Path -Force
        if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) { throw "不支持链接目录：$Path" }
        if ($item.PSIsContainer) {
            foreach ($child in Get-ChildItem -LiteralPath $Path -Force) {
                Assert-PlainTree $child.FullName
            }
        }
    }
}

try {
    $source = [IO.Path]::GetFullPath((Join-Path (Split-Path -Parent $PSScriptRoot) 'skills\literature-reading'))
    Assert-PlainTree $source
    if (-not (Test-Path -LiteralPath (Join-Path $source 'SKILL.md') -PathType Leaf)) { throw '安装包缺少 SKILL.md，请下载完整仓库。' }
    # Check every Markdown reference before touching the installed copy.
    foreach ($file in Get-ChildItem -LiteralPath $source -Filter '*.md' -Recurse) {
        $body = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
        foreach ($match in [regex]::Matches($body, '\]\(([^)]+)\)')) {
            $link = $match.Groups[1].Value
            if ($link -match '^[a-zA-Z]+://' -or $link.StartsWith('#')) { continue }
            $target = Join-Path $file.DirectoryName ($link.Split('#')[0])
            if (-not (Test-Path -LiteralPath $target -PathType Leaf)) { throw "安装包引用缺失：$($file.Name) -> $link" }
        }
    }
    Write-Host '文献阅读技能 · Codex / DSH 安装' -ForegroundColor Cyan
    if (-not $Platform) {
        $answer = Read-Host '使用哪个平台？1 Codex（默认），2 DSH'
        switch ($answer) { '' { $Platform='Codex' } '1' { $Platform='Codex' } '2' { $Platform='DSH' } default { throw '无效平台选项。' } }
    }
    if (-not $Scope) {
        $answer = Read-Host '安装方式？1 指定项目路径（默认，可选任意已有文件夹），2 用户全局'
        switch ($answer) { '' { $Scope='Project' } '1' { $Scope='Project' } '2' { $Scope='User' } default { throw '无效范围选项。' } }
    }
    if ($Scope -eq 'Project') {
        if (-not $ProjectPath) {
            Write-Host '可输入任意已有项目文件夹，例如 D:\论文库 或 F:\文献阅读，不限当前目录。'
            Write-Host '安装器会自动补齐平台所需的技能子目录，请不要输入 SKILL.md 路径。'
            $ProjectPath = Read-Host '请输入完整项目路径'
        }
        if ([string]::IsNullOrWhiteSpace($ProjectPath)) { throw '项目路径不能为空。' }
        $base = [IO.Path]::GetFullPath($ProjectPath.Trim().Trim('"'))
        if (-not (Test-Path -LiteralPath $base -PathType Container)) { throw "项目文件夹不存在：$base，请先创建或选择已有文件夹。" }
        if (Test-Path -LiteralPath (Join-Path $base 'SKILL.md')) { throw '请选择文献项目根目录，不要选择 literature-reading 技能文件夹。' }
        $relative = if ($Platform -eq 'Codex') { '.agents\skills' } else { '.dsh\skills' }
    } else {
        $base = [IO.Path]::GetFullPath($env:USERPROFILE)
        $relative = '.agents\skills'
    }
    $skillRoot = Join-Path $base $relative
    $destination = [IO.Path]::GetFullPath((Join-Path $skillRoot 'literature-reading'))
    if (-not $destination.StartsWith($base.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase)) { throw '目标不在所选目录内。' }
    if ($source -eq $destination -or $destination.StartsWith($source + '\', [StringComparison]::OrdinalIgnoreCase)) { throw '安装目标不能位于源技能内部。' }
    # Check all ancestors to avoid writing through junctions.
    $ancestor = $destination
    while ($ancestor) {
        if (Test-Path -LiteralPath $ancestor) {
            if ((Get-Item -LiteralPath $ancestor -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) { throw "目标路径含链接：$ancestor" }
        }
        $ancestor = Split-Path -Parent $ancestor
    }
    Assert-PlainTree $destination
    Write-Host "平台：$Platform；范围：$Scope"
    Write-Host "目标：$destination"
    if (Test-Path -LiteralPath $destination) {
        # Keep backups outside skill discovery directories to avoid duplicate skills.
        $backupRoot = Join-Path $base '.literature-skill-backups'
        Assert-PlainTree $backupRoot
        $backup = Join-Path $backupRoot ('literature-reading-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N').Substring(0,8))
        [IO.Directory]::CreateDirectory($backupRoot) | Out-Null
        Copy-Item -LiteralPath $destination -Destination $backup -Recurse
        Write-Host "旧版完整备份：$backup"
    }
    [IO.Directory]::CreateDirectory($destination) | Out-Null
    $files = @(Get-ChildItem -LiteralPath $source -File -Recurse -Force)
    foreach ($file in $files) {
        $relativeFile = $file.FullName.Substring($source.Length + 1)
        $installedFile = Join-Path $destination $relativeFile
        [IO.Directory]::CreateDirectory((Split-Path -Parent $installedFile)) | Out-Null
        Copy-Item -LiteralPath $file.FullName -Destination $installedFile -Force
        if ((Get-FileHash -LiteralPath $file.FullName).Hash -ne (Get-FileHash -LiteralPath $installedFile).Hash) { throw "校验失败：$relativeFile" }
    }
    Write-Host "安装文件校验通过：$($files.Count) 个文件。" -ForegroundColor Green
    Write-Host '文件安装成功不等于已验证客户端加载。请在所选文献项目中新建会话测试。'
    if ($Platform -eq 'Codex') {
        Write-Host '输入：使用 literature-reading 技能，开始文献阅读。'
        Write-Host '若未识别，重启 Codex 后再新建会话；检查是否有其他位置的同名旧技能。'
    } else {
        Write-Host '重启 DSH 后在文献项目中新建会话，输入：文献阅读。'
    }
    Write-Host '正确首轮：询问先完善背景与偏好，还是沿用设置；等待回答，不直接分析论文。'
    Write-Host '已有论文也先询问；明确跳过设置或恢复阅读进度除外。'
    Write-Host '项目根中原有的 literature-reading 文件夹不会被删除，论文与个人档案不会被修改。'
    $resultCode = 0
} catch {
    Write-Host "安装失败：$($_.Exception.Message)" -ForegroundColor Red
    Write-Host '若已生成备份，可从提示的备份目录恢复。不要将本次操作当作安装成功。'
    $resultCode = 1
}
if (-not $NoPause) { Read-Host '按回车退出' | Out-Null }
exit $resultCode
