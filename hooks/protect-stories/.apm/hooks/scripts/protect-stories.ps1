# Blocks agent edits to stories/ and .github/hooks/, and asks before terminal commands.
$ErrorActionPreference = 'Stop'

$Protected = @('stories', '.github/hooks')
$ShellTool = '^(bash|powershell|shell|run_in_terminal)$'
$EditTool = 'edit|create|write|patch|replace|insert|delete|rename'

function Write-Decision($Decision, $Reason) {
  $output = [ordered]@{ permissionDecision = $Decision; permissionDecisionReason = $Reason }
  [Console]::Out.Write(($output | ConvertTo-Json -Compress))
}

# Paths come from keys such as filePath, or from "*** Update File: x" lines in patches.
function Get-FilePaths($Value, $Key) {
  if ($Value -is [string]) {
    if ($Key -match 'path|file') { $Value }
    foreach ($m in [regex]::Matches($Value, '(?m)^\*\*\* (?:Add File|Update File|Delete File|Move to): (.+?)\s*$')) {
      $m.Groups[1].Value
    }
  } elseif ($Value -is [System.Management.Automation.PSCustomObject]) {
    foreach ($p in $Value.PSObject.Properties) { Get-FilePaths $p.Value $p.Name }
  } elseif ($Value -is [System.Collections.IEnumerable]) {
    foreach ($item in $Value) { Get-FilePaths $item $Key }
  }
}

# Copilot CLI sends toolName/toolArgs (a JSON string); VS Code sends tool_name/tool_input.
$hookInput = [Console]::In.ReadToEnd() | ConvertFrom-Json
$tool = "$(if ($hookInput.toolName) { $hookInput.toolName } else { $hookInput.tool_name })"
$toolArgs = if ($null -ne $hookInput.toolArgs) { $hookInput.toolArgs } else { $hookInput.tool_input }
if ($toolArgs -is [string]) {
  try { $toolArgs = $toolArgs | ConvertFrom-Json } catch { $toolArgs = [pscustomobject]@{ patch = $toolArgs } }
}

if ($tool -match $ShellTool) {
  Write-Decision 'ask' 'Review this command: it must not change stories/ or .github/hooks/.'
  exit 0
}
if ($tool -notmatch $EditTool) { exit 0 }

$cwd = if ($hookInput.cwd) { $hookInput.cwd } else { (Get-Location).Path }
$base = [System.IO.Path]::GetFullPath($cwd).TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar
foreach ($file in @(Get-FilePaths $toolArgs '')) {
  try { $full = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($cwd, $file)) } catch { continue }
  if (-not "$full$([System.IO.Path]::DirectorySeparatorChar)".StartsWith($base, [StringComparison]::OrdinalIgnoreCase)) { continue }
  $relative = $full.Substring([Math]::Min($base.Length, $full.Length)).Replace('\', '/').ToLowerInvariant()
  foreach ($dir in $Protected) {
    if ($relative -eq $dir -or $relative.StartsWith("$dir/")) {
      Write-Decision 'deny' "$file is protected. Only a human may change stories/ and .github/hooks/."
      exit 0
    }
  }
}
