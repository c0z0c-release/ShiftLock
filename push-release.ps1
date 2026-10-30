<#
.SYNOPSIS
    release 폴더(배포 전용 리파지토리)의 변경 사항을 커밋하고 GitHub에 push 합니다.

.DESCRIPTION
    release\release 에서 가장 최신 ShiftLock_<버전>.exe 의 버전을 읽어 커밋 메시지로 사용합니다.
    사용법: .\push-release.ps1 [-Message "메시지"] [-Tag] [-DryRun]

.PARAMETER Message
    커밋 메시지. 생략하면 최신 exe 의 버전(예: 0.8.1)을 사용합니다.

.PARAMETER Tag
    v<버전> 태그를 만들어 함께 push 합니다.

.PARAMETER DryRun
    커밋/push 없이 수행할 내용만 출력합니다.
#>
[CmdletBinding()]
param(
    [string]$Message,
    [switch]$Tag,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

$releaseRepo = $PSScriptRoot
$artifactDir = Join-Path $releaseRepo 'release'

function Invoke-Git {
    # git 은 진행 상황을 stderr 로 출력하므로 종료 코드로만 실패를 판단한다.
    $prev = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try { git -C $releaseRepo @args 2>&1 | ForEach-Object { "$_" } | Write-Host }
    finally { $ErrorActionPreference = $prev }
    if ($LASTEXITCODE -ne 0) {
        throw "git $($args -join ' ') 실패 (exit $LASTEXITCODE)"
    }
}

if (-not (Test-Path (Join-Path $releaseRepo '.git'))) {
    throw "배포 리파지토리를 찾을 수 없습니다: $releaseRepo"
}

$latest = Get-ChildItem $artifactDir -Filter 'ShiftLock_*.exe' -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1
if (-not $latest) {
    throw "배포할 exe가 없습니다. Release 빌드를 먼저 실행하세요: $artifactDir"
}

$version = $latest.BaseName -replace '^ShiftLock_', ''
if (-not $Message) { $Message = $version }

$branch = (git -C $releaseRepo rev-parse --abbrev-ref HEAD).Trim()

Write-Host "대상 리파지토리 : $releaseRepo"
Write-Host "브랜치          : $branch"
Write-Host "최신 exe        : $($latest.Name)"
Write-Host "커밋 메시지     : $Message"

Invoke-Git add -A
$pending = git -C $releaseRepo status --porcelain
if ($pending) {
    Write-Host "`n변경 사항:"
    $pending | ForEach-Object { Write-Host "  $_" }
}
else {
    Write-Host "`n커밋할 변경 사항이 없습니다."
}

if ($DryRun) {
    Write-Host "`n[DryRun] 커밋/push 를 수행하지 않았습니다."
    Invoke-Git reset --quiet
    return
}

if ($pending) {
    Invoke-Git commit -m $Message
}

if ($Tag) {
    $tagName = "v$version"
    $existing = git -C $releaseRepo tag --list $tagName
    if ($existing) {
        Write-Host "태그 $tagName 이(가) 이미 있어 건너뜁니다."
    }
    else {
        Invoke-Git tag $tagName
    }
}

Invoke-Git push origin $branch
if ($Tag) { Invoke-Git push origin --tags }

Write-Host "`n완료: $Message ($branch)"
