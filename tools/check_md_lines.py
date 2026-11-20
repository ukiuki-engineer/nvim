#!/usr/bin/python3
"""Markdown の「1行の詰め込み」を検査する。最後のコミットから変わった行だけを見る。

使い方は tools/README.md。引数なしのときは PostToolUse hook の JSON を stdin から読む。
"""
import json
import os
import re
import subprocess
import sys
import unicodedata

# 詰め込みの基準。1行を読み切れる長さと、1行に入れてよい話の数の目安で、数を持つのはここだけ（AGENTS.md「書き物」）。
MIN_ELEMS = 3  # 要素がこの数以上で、長さが LEN_WITH_ELEMS を超えたら違反
LEN_WITH_ELEMS = 40
LEN_MAX = 60  # 要素が少なくても、これを超えたら違反

REPO = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
HINT = "1行に詰め込まない（AGENTS.md「書き物」）。文を分ける・括弧の中身を下の段に出す・並びを箇条書きにする"


def visible(s):
  return re.sub(r"\[([^\]]*)\]\([^)]*\)", r"\1", s).replace("`", "")


def clean(s):
  # 要素を数えるとき、コードの中の括弧・句点を数えないため
  s = re.sub(r"\[([^\]]*)\]\([^)]*\)", r"\1", s)
  return re.sub(r"`[^`]*`", "X", s)


def width(s):
  """読み手に見える長さ（全角1・半角0.5）。コードも読むので数える"""
  return sum(1 if unicodedata.east_asian_width(c) in "WF" else 0.5 for c in visible(s))


def segments(line):
  t = line.strip()
  if t.startswith("|"):
    if re.match(r"^\|[\s:|-]+\|$", t):
      return []
    parts = [p.strip() for c in t.strip("|").split("|") for p in c.split("<br>")]
    return [p.lstrip("・").strip() for p in parts if p]
  t = re.sub(r"^(>\s*)+", "", t)
  if t.startswith("#"):
    return []
  t = re.sub(r"^([-*]|\d+\.)\s+", "", t)
  return [t] if t else []


def elements(s):
  c = clean(s)
  sentences = len([x for x in c.split("。") if re.search(r"[ぁ-んァ-ン一-龥]", x)])
  parens = len(re.findall(r"[（(〔]", c))
  return sentences + parens + (1 if "・" in c else 0)


def is_crammed(s):
  n = width(s)
  e = elements(s)
  return (e >= MIN_ELEMS and n > LEN_WITH_ELEMS) or n > LEN_MAX


def find_violations(lines, target=None, old=frozenset()):
  """target は検査する行番号（1始まり）の集合。None なら全行。[(行番号, 長さ, 要素, 本文)]"""
  out = []
  fence = False
  for i, line in enumerate(lines, 1):
    if line.strip().startswith("```"):
      fence = not fence
      continue
    if fence or not line.strip():
      continue
    if target is not None and i not in target:
      continue
    for s in segments(line):
      if s and s not in old and is_crammed(s):
        out.append((i, width(s), elements(s), s))
  return out


def git(*args):
  return subprocess.run(["git", "-C", REPO] + list(args), capture_output=True, text=True, check=True).stdout


def changed(rel):
  """(追加された行番号の集合 または None＝全行, 削除された行から出る区切りの集合)"""
  try:
    git("ls-files", "--error-unmatch", "--", rel)
  except subprocess.CalledProcessError:
    return None, frozenset()
  diff = git("diff", "-U0", "HEAD", "--", rel)
  added, old = set(), set()
  for l in diff.splitlines():
    m = re.match(r"^@@ -\S+ \+(\d+)(?:,(\d+))? @@", l)
    if m:
      start, cnt = int(m.group(1)), int(m.group(2) if m.group(2) is not None else 1)
      added.update(range(start, start + cnt))
    elif l.startswith("-") and not l.startswith("---"):
      old.update(segments(l[1:]))
  return added, old


def check(path):
  real = os.path.realpath(path)
  if not real.endswith(".md") or not real.startswith(REPO + os.sep) or not os.path.isfile(real):
    return []
  rel = os.path.relpath(real, REPO)
  target, old = changed(rel)
  with open(real, encoding="utf-8") as f:
    lines = f.read().splitlines()
  res = []
  for i, n, e, s in find_violations(lines, target, old):
    head = s[:30] + ("…" if len(s) > 30 else "")
    res.append("%s:%d 約%d字・要素%d：%s" % (rel, i, round(n), e, head))
  return res


def hook_paths(payload):
  """Claude Code の単一ファイル指定と Codex の編集・シェル操作に対応する。"""
  fp = payload.get("tool_input", {}).get("file_path")
  if fp:
    return [os.path.join(payload.get("cwd") or REPO, fp)]
  if payload.get("tool_name") not in {"apply_patch", "Bash"}:
    return []

  # シェル経由の編集も拾うため、コマンドを解析せず Git の変更一覧を見る。
  tracked = git("diff", "--name-only", "-z", "HEAD", "--", "*.md")
  untracked = git("ls-files", "--others", "--exclude-standard", "-z", "--", "*.md")
  return sorted({os.path.join(REPO, p) for p in (tracked + untracked).split("\0") if p})


def main():
  paths = sys.argv[1:]
  if not paths:
    if sys.stdin.isatty():
      return 0
    paths = hook_paths(json.load(sys.stdin))
  msgs = []
  for p in paths:
    msgs += check(p)
  if msgs:
    sys.stderr.write("\n".join(msgs) + "\n" + HINT + "\n")
    return 2
  return 0


if __name__ == "__main__":
  try:
    sys.exit(main())
  except Exception:
    # 検査の不具合で作業を止めない
    sys.exit(0)
