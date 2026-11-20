import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

import check_md_lines as checker


LONG_LINE = "これは一行に情報を詰め込みすぎた説明です。" * 5


class TextChecks(unittest.TestCase):
  def test_plain_text_and_table_cells(self):
    lines = ["短い説明です。", LONG_LINE, "| " + LONG_LINE + " | 短い説明 |"]
    self.assertEqual([item[0] for item in checker.find_violations(lines)], [2, 3])

  def test_fences_headings_and_br_separators(self):
    lines = [
      "# " + LONG_LINE,
      "```text",
      LONG_LINE,
      "```",
      "| --- | --- |",
      "| 短い説明<br>別の説明 | 項目 |",
    ]
    self.assertEqual(checker.find_violations(lines), [])


class RepositoryChecks(unittest.TestCase):
  def setUp(self):
    self.temp = tempfile.TemporaryDirectory(prefix="md-lines-")
    self.addCleanup(self.temp.cleanup)
    self.root = Path(self.temp.name).resolve()
    self.git("init", "--quiet")
    self.write("notes.md", LONG_LINE + "\n短い説明です。\n")
    self.write(".gitignore", "ignored.md\n")
    self.git("add", ".")
    self.git(
      "-c", "user.name=Test", "-c", "user.email=test@example.invalid",
      "commit", "--quiet", "-m", "fixture",
    )
    patcher = patch.object(checker, "REPO", str(self.root))
    patcher.start()
    self.addCleanup(patcher.stop)

  def git(self, *args):
    return subprocess.run(
      ["git", "-C", str(self.root), *args],
      capture_output=True, text=True, check=True,
    ).stdout

  def write(self, relative, text):
    path = self.root / relative
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")
    return path

  def test_unchanged_long_lines_are_not_reported(self):
    path = self.write("notes.md", LONG_LINE + "\n短い変更です。\n")
    self.assertEqual(checker.check(path), [])

  def test_changed_and_staged_lines_are_reported(self):
    path = self.write("notes.md", LONG_LINE + "\n" + LONG_LINE + "追記\n")
    self.git("add", "notes.md")
    messages = checker.check(path)
    self.assertEqual(len(messages), 1)
    self.assertTrue(messages[0].startswith("notes.md:2 "))

  def test_moved_existing_text_is_not_reported(self):
    path = self.write("notes.md", "短い説明です。\n" + LONG_LINE + "\n")
    self.assertEqual(checker.check(path), [])

  def test_codex_finds_staged_and_new_markdown(self):
    self.write("notes.md", "変更です。\n")
    self.git("add", "notes.md")
    self.write("docs/new file.md", "新しい説明です。\n")
    self.write("ignored.md", LONG_LINE)
    self.write("other.txt", LONG_LINE)
    expected = {str(self.root / "notes.md"), str(self.root / "docs/new file.md")}
    for tool_name in ["apply_patch", "Bash"]:
      with self.subTest(tool_name=tool_name):
        self.assertEqual(set(checker.hook_paths({"tool_name": tool_name})), expected)

  def test_claude_relative_file_path_uses_event_directory(self):
    payload = {"cwd": str(self.root / "docs"), "tool_input": {"file_path": "note.md"}}
    self.assertEqual(checker.hook_paths(payload), [str(self.root / "docs/note.md")])

  def test_deleted_and_outside_files_are_skipped(self):
    (self.root / "notes.md").unlink()
    paths = checker.hook_paths({"tool_name": "Bash"})
    self.assertEqual([message for path in paths for message in checker.check(path)], [])
    self.assertEqual(checker.check(Path(checker.__file__)), [])

  def test_hook_exit_status_and_feedback(self):
    script = self.root / "tools/check_md_lines.py"
    script.parent.mkdir()
    shutil.copyfile(checker.__file__, script)
    path = self.write("docs/new file.md", LONG_LINE + "\n")
    payload = json.dumps({"tool_name": "apply_patch", "tool_input": {"command": "patch"}})

    def invoke(*args):
      return subprocess.run(
        [sys.executable, str(script), *args], input=payload,
        cwd=path.parent, capture_output=True, text=True,
      )

    result = invoke()
    self.assertEqual(result.returncode, 2)
    self.assertIn("docs/new file.md:1 ", result.stderr)
    self.assertIn("AGENTS.md", result.stderr)
    self.assertEqual(result.stdout, "")
    self.assertEqual(invoke(str(path)).returncode, 2)
    path.write_text("短い説明です。\n", encoding="utf-8")
    self.assertEqual(invoke().returncode, 0)


if __name__ == "__main__":
  unittest.main()
