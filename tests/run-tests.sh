#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL="$ROOT/SKILL.md"
README="$ROOT/README.md"
EVALS="$ROOT/evals/evals.json"
AGENT_META="$ROOT/agents/openai.yaml"
INVENTORY="$ROOT/scripts/inventory_evidence.py"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

require_file() {
  [ -f "$1" ] || fail "missing file: $1"
}

require_text() {
  grep -Fq -- "$2" "$1" || fail "missing text '$2' in $1"
}

reject_text() {
  local file="$1"
  local text="$2"
  if grep -Fiq -- "$text" "$file"; then
    fail "obsolete text '$text' found in $file"
  fi
}

for file in \
  "$SKILL" \
  "$README" \
  "$EVALS" \
  "$AGENT_META" \
  "$INVENTORY" \
  "$ROOT/LICENSE" \
  "$ROOT/assets/wechat-qr.jpg" \
  "$ROOT/references/domain-profiles.md" \
  "$ROOT/references/media-and-provenance.md" \
  "$ROOT/references/method-and-evidence.md" \
  "$ROOT/references/output-contract.md" \
  "$ROOT/references/sources.md"; do
  require_file "$file"
done

[ ! -e "$ROOT/reference.md" ] || fail "legacy reference.md still exists"

ruby -ryaml -e '
  text = File.read(ARGV.fetch(0))
  match = text.match(/\A---\n(.*?)\n---\n/m) or abort("missing frontmatter")
  data = YAML.safe_load(match[1], permitted_classes: [], aliases: false)
  abort("wrong skill name") unless data["name"] == "fact-check-cy"
  abort("frontmatter must contain only name and description") unless data.keys.sort == %w[description name]
  description = data["description"].to_s
  abort("description too short") unless description.length >= 120
  abort("missing general boundary") unless description.include?("通用")
  abort("missing research boundary") unless description.include?("deep-research")
' "$SKILL"

for text in \
  "声明—证据—结论" \
  "来源真实存在" \
  "共同来源" \
  "证据不足" \
  "不可核验" \
  "机器初判" \
  "人工确认" \
  "开放式探索由 deep-research 负责" \
  "不要把“未找到”写成“不存在”"; do
  require_text "$SKILL" "$text"
done

for obsolete in \
  "综合可信度评分" \
  "whitelist_boost" \
  "AI 生成的 URL 错误率约 60%" \
  "差异 < 10%" \
  "WebFetch" \
  "WebSearch" \
  "名创业务必查信源白名单"; do
  reject_text "$SKILL" "$obsolete"
  reject_text "$README" "$obsolete"
done

python3 - "$EVALS" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as handle:
    data = json.load(handle)

assert data["skill_name"] == "fact-check-cy"
evals = data["evals"]
assert len(evals) >= 12
assert len({item["id"] for item in evals}) == len(evals)
assert len({item["eval_name"] for item in evals}) == len(evals)

for item in evals:
    assert item["prompt"].strip()
    assert item["expected_output"].strip()
    assert len(item.get("assertions", [])) >= 4

names = {item["eval_name"] for item in evals}
for required in {
    "single-numeric-claim",
    "report-wide-audit",
    "url-200-does-not-prove-claim",
    "policy-effective-date",
    "company-claim-versus-industry",
    "shared-upstream-source",
    "conflicting-reliable-sources",
    "missing-evidence-is-not-false",
    "media-provenance-and-event",
    "restricted-corpus-audit",
    "open-research-route-out",
    "deep-research-handoff",
}:
    assert required in names
PY

ruby -ryaml -e '
  data = YAML.safe_load(File.read(ARGV.fetch(0)), permitted_classes: [], aliases: false)
  interface = data.fetch("interface")
  abort("wrong display name") unless interface["display_name"] == "通用事实核查"
  description = interface.fetch("short_description")
  abort("short description length") unless (25..64).cover?(description.length)
  abort("default prompt must mention skill") unless interface.fetch("default_prompt").include?("$fact-check-cy")
' "$AGENT_META"

temp_dir="$(mktemp -d /private/tmp/fact-check-cy-test.XXXXXX)"
trap 'rm -rf "$temp_dir"' EXIT

cat >"$temp_dir/input.md" <<'EOF'
# Sample

2026-07-28，报告称活跃用户增长 18.5%，原始入口为
https://example.com/report?id=42。
EOF

PYTHONPYCACHEPREFIX="$temp_dir/pycache" python3 -m py_compile "$INVENTORY"
python3 "$INVENTORY" "$temp_dir/input.md" --format json >"$temp_dir/inventory.json"
python3 - "$temp_dir/inventory.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as handle:
    data = json.load(handle)

assert data["note"].startswith("Inventory only")
assert any(item["value"] == "https://example.com/report?id=42" for item in data["urls"])
assert any(item["value"] == "18.5%" for item in data["numbers"])
assert any(item["value"] == "2026-07-28" for item in data["dates"])
PY

require_text "$README" "assets/wechat-qr.jpg"
require_text "$README" "Apache-2.0"
require_text "$README" ".agents/skills"
reject_text "$README" "~/.codex/skills"
reject_text "$README" "课堂"
reject_text "$README" "课程"
reject_text "$README" "水滴保"
reject_text "$README" "cc-skills/"
require_text "$ROOT/LICENSE" "Apache License"

skill_lines="$(wc -l <"$SKILL")"
[ "$skill_lines" -lt 500 ] || fail "SKILL.md must stay under 500 lines"

echo "PASS: fact-check-cy general evidence-audit contract"
