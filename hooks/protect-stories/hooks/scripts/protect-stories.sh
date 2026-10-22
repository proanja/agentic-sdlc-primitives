#!/usr/bin/env bash
# Blocks agent edits to stories/ and .github/hooks/, and asks before terminal commands.
set -euo pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo '{"permissionDecision":"ask","permissionDecisionReason":"protect-stories needs jq to check this tool call. Install jq, or review the call yourself."}'
  exit 0
fi

# Copilot CLI sends toolName/toolArgs (a JSON string); VS Code sends tool_name/tool_input.
jq -c '
  def norm: gsub("\\\\"; "/") | split("/")
    | reduce .[] as $s ([]; if $s == "" or $s == "." then . elif $s == ".." then .[:-1] else . + [$s] end)
    | join("/");
  def decision($d; $r): {permissionDecision: $d, permissionDecisionReason: $r};

  (.toolName // .tool_name // "") as $tool
  | ((.cwd // $ENV.PWD) | norm) as $cwd
  | (.toolArgs // .tool_input // {} | if type == "string" then (. as $s | try fromjson catch {patch: $s}) else . end) as $args
  | if ($tool | test("^(bash|powershell|shell|run_in_terminal)$"; "i")) then
      decision("ask"; "Review this command: it must not change stories/ or .github/hooks/.")
    elif ($tool | test("edit|create|write|patch|replace|insert|delete|rename"; "i")) then
      # Paths come from keys such as filePath, or from "*** Update File: x" lines in patches.
      ([$args | paths(type == "string") as $p
         | select($p | map(strings) | (last // "") | test("path|file"; "i")) | $args | getpath($p)]
       + [$args | .. | strings | split("\n")[]
         | capture("^\\*\\*\\* (Add File|Update File|Delete File|Move to): (?<p>.+)$") | .p | sub("\\s+$"; "")])
      | map(select(
          (if startswith("/") then . else "/\($cwd)/\(.)" end | norm | ascii_downcase | ltrimstr(($cwd | ascii_downcase) + "/")) as $rel
          | ["stories", ".github/hooks"] | any(. as $dir | $rel == $dir or ($rel | startswith($dir + "/")))))
      | first // empty
      | decision("deny"; "\(.) is protected. Only a human may change stories/ and .github/hooks/.")
    else empty end
'
