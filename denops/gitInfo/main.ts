import { Denops } from "https://deno.land/x/denops_std@v1.0.0/mod.ts";
import * as denopsStd from "https://deno.land/x/denops_std@v4.1.0/variable/mod.ts";

// TODO: git情報を更新するautocmdを追加する
// TODO: git情報を更新するcommandを追加する

interface GitCommitCount {
  remote: number;
  local: number;
}

interface GitConfig {
  user_name: string;
  user_email: string;
}

interface GitInformation {
  branch_name: string;
  exists_remote_branch: boolean;
  commit_count: GitCommitCount;
  has_changed: boolean;
  config: GitConfig;
}

// gitプロジェクトか
async function isGitProject(): Promise<boolean> {
  try {
    const command = new Deno.Command("git", {
      args: ["rev-parse", "--is-inside-work-tree"],
      stdout: "piped",
      stderr: "piped",
    });

    const process = await command.spawn();
    const { code, stdout, stderr } = await process.output();

    if (code === 0) {
      const output = new TextDecoder().decode(stdout).trim();
      return output === "true";
    } else {
      // Gitコマンドが失敗した場合は、現在のディレクトリがGitリポジトリではないか、
      // またはGitがインストールされていないことを意味する。
      const error = new TextDecoder().decode(stderr).trim();
      console.error("Error checking Git project status:", error);
      return false;
    }
  } catch (error) {
    console.error("Failed to execute Git command:", error);
    return false;
  }
}

// ブランチ名を返す
async function getGitBranchName(): Promise<string> {
  const decoder = new TextDecoder();
  const command = new Deno.Command("git", {
    args: ["branch", "--show-current"],
    stdin: "piped",
    stdout: "piped",
    stderr: "piped",
  });

  const process = await command.spawn();
  const { code, stdout, stderr } = await process.output();

  if (code !== 0) {
    const error = decoder.decode(stderr).trim();
    console.error("Git command failed:", error);
    return "";
  }

  return decoder.decode(stdout).trim();
}

// リモートブランチがあるか
async function existsGitRemoteBranch(): Promise<boolean> {
  // TODO: まだモック
  return true;
}

// 未pull、未pushのcommit数
async function getGitCommitCount(): Promise<GitCommitCount> {
  // TODO: まだモック
  return {
    remote: 0,
    local: 0,
  };
}
// 変更があるか
async function hasGitChanges(): Promise<boolean> {
  // TODO: まだモック
  return true;
}

// user.nameとuser.email
async function getGitConfig(): Promise<GitConfig> {
  // TODO: まだモック
  return {
    user_name: "ukiuki-engineer",
    user_email: "mock@mock.com",
  };
}

// git情報を返す
async function getGitInformation(): Promise<GitInformation> {
  const branchName = await getGitBranchName();
  const existsRemoteBranch = await existsGitRemoteBranch();
  const commitCount = await getGitCommitCount();
  const hasChanged = await hasGitChanges();
  const config = await getGitConfig();

  return {
    branch_name: branchName,
    exists_remote_branch: existsRemoteBranch,
    commit_count: {
      remote: commitCount.remote,
      local: commitCount.local,
    },
    has_changed: hasChanged,
    config: {
      user_name: config.user_name,
      user_email: config.user_email,
    },
  };
}

// git情報をvim側のグローバル変数にセット
async function setGitInformation(denops: Denops): Promise<void> {
  const gitInfo = await getGitInformation();
  await denopsStd.g.set(denops, "git_info#git_info", gitInfo);
}

export async function main(denops: Denops): Promise<void> {
  if (!(await isGitProject())) {
    console.log("TODO: gitプロジェクトではない場合の処理");
    return;
  }
  await setGitInformation(denops);
}
