import { Denops } from "https://deno.land/x/denops_std@v1.0.0/mod.ts";
import * as denopsStd from "https://deno.land/x/denops_std@v4.1.0/variable/mod.ts";

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

////////////////////////////////////////////////////////////////////////////////
// export
////////////////////////////////////////////////////////////////////////////////
// gitプロジェクトか
export async function isGitProject(): Promise<boolean> {
  try {
    const command = new Deno.Command("git", {
      args: ["rev-parse", "--is-inside-work-tree"],
      stdout: "piped",
      stderr: "piped",
    });

    const process = command.spawn();
    const { code, stdout, stderr } = await process.output();

    if (code === 0) {
      const output = new TextDecoder().decode(stdout).trim();
      return output === "true";
    } else {
      // Gitコマンドが失敗した場合は、現在のディレクトリがGitリポジトリではないか、
      // またはGitがインストールされていないことを意味する。
      const error = new TextDecoder().decode(stderr).trim();
      // console.warn("Warning checking Git project status:", error);
      return false;
    }
  } catch (error) {
    console.error("Failed to execute Git command:", error);
    return false;
  }
}

// git fetch
export async function gitFetch(): Promise<boolean> {
  try {
    const command = new Deno.Command("git", {
      args: ["fetch"],
      stdout: "null",
      stderr: "piped",
    });

    const process = command.spawn();
    const { code, stderr } = await process.output();

    if (code === 0) {
      return true;
    } else {
      console.error("Error git fetching:", stderr);
      return false;
    }
  } catch (error) {
    console.error("Failed to execute Git command:", error);
    return false;
  }
}

// git情報をvim側のグローバル変数にセット
export async function setGitInformation(
  denops: Denops,
  fetch: boolean = false
): Promise<void> {
  if (fetch) {
    await gitFetch();
  }
  const gitInfo = await _getGitInformation();
  await denopsStd.g.set(denops, "git_info#git_info", gitInfo);
}

////////////////////////////////////////////////////////////////////////////////
// private
////////////////////////////////////////////////////////////////////////////////
// ブランチ名を返す
async function _getGitBranchName(): Promise<string> {
  const decoder = new TextDecoder();
  const command = new Deno.Command("git", {
    args: ["branch", "--show-current"],
    stdin: "piped",
    stdout: "piped",
    stderr: "piped",
  });

  const process = command.spawn();
  const { code, stdout, stderr } = await process.output();

  if (code !== 0) {
    const error = decoder.decode(stderr).trim();
    console.error("Git command failed:", error);
    return "";
  }

  return decoder.decode(stdout).trim();
}

// リモートブランチがあるか
async function _existsGitRemoteBranch(currentBranch: string): Promise<boolean> {
  if (!currentBranch) {
    return false;
  }

  try {
    const command = new Deno.Command("git", {
      args: ["ls-remote", "--heads", "origin", currentBranch],
      stdout: "piped",
      stderr: "piped",
    });

    const process = command.spawn();
    const { code, stdout } = await process.output();

    if (code === 0) {
      const output = new TextDecoder().decode(stdout).trim();
      // リモートにブランチが存在する場合、ls-remoteの出力は空ではない
      return output !== "";
    } else {
      // Gitコマンドが失敗した場合、リモートブランチは存在しないと見なす
      return false;
    }
  } catch (error) {
    console.error("Failed to execute Git command:", error);
    return false;
  }
}

// 未pull、未pushのcommit数
async function _getGitCommitCount(
  currentBranch: string
): Promise<GitCommitCount> {
  try {
    if (!currentBranch) {
      return { remote: 0, local: 0 };
    }

    // 未プッシュのコミット数を計算
    const localCommand = new Deno.Command("git", {
      args: ["rev-list", "--count", "origin/" + currentBranch + "..HEAD"],
      stdout: "piped",
      stderr: "piped",
    });
    const localProcess = localCommand.spawn();
    const { code: localCode, stdout: localStdout } =
      await localProcess.output();
    const localCount =
      localCode === 0
        ? parseInt(new TextDecoder().decode(localStdout).trim(), 10)
        : 0;

    // 未プルのコミット数を計算
    const remoteCommand = new Deno.Command("git", {
      args: ["rev-list", "--count", "HEAD..origin/" + currentBranch],
      stdout: "piped",
      stderr: "piped",
    });
    const remoteProcess = remoteCommand.spawn();
    const { code: remoteCode, stdout: remoteStdout } =
      await remoteProcess.output();
    const remoteCount =
      remoteCode === 0
        ? parseInt(new TextDecoder().decode(remoteStdout).trim(), 10)
        : 0;

    return {
      local: localCount,
      remote: remoteCount,
    };
  } catch (error) {
    console.error("Failed to execute Git command:", error);
    return {
      remote: 0,
      local: 0,
    };
  }
}

// 変更があるか
async function _hasGitChanges(): Promise<boolean> {
  try {
    const command = new Deno.Command("git", {
      args: ["status", "--porcelain"],
      stdout: "piped",
      stderr: "piped",
    });

    const process = command.spawn();
    const { code, stdout } = await process.output();

    if (code === 0) {
      const output = new TextDecoder().decode(stdout).trim();
      // 変更がある場合、git status --porcelain の出力は空ではない
      return output !== "";
    } else {
      // Gitコマンドが失敗した場合、変更がないと見なす
      return false;
    }
  } catch (error) {
    console.error("Failed to execute Git command:", error);
    return false;
  }
}

// user.nameとuser.email
async function _getGitConfig(): Promise<GitConfig> {
  try {
    // user.name を取得
    const userNameCommand = new Deno.Command("git", {
      args: ["config", "user.name"],
      stdout: "piped",
      stderr: "piped",
    });
    const userNameProcess = userNameCommand.spawn();
    const { code: userNameCode, stdout: userNameStdout } =
      await userNameProcess.output();
    const userName =
      userNameCode === 0
        ? new TextDecoder().decode(userNameStdout).trim()
        : "unknown";

    // user.email を取得
    const userEmailCommand = new Deno.Command("git", {
      args: ["config", "user.email"],
      stdout: "piped",
      stderr: "piped",
    });
    const userEmailProcess = userEmailCommand.spawn();
    const { code: userEmailCode, stdout: userEmailStdout } =
      await userEmailProcess.output();
    const userEmail =
      userEmailCode === 0
        ? new TextDecoder().decode(userEmailStdout).trim()
        : "unknown@example.com";

    return {
      user_name: userName,
      user_email: userEmail,
    };
  } catch (error) {
    console.error("Failed to execute Git command:", error);
    return {
      user_name: "unknown",
      user_email: "unknown@example.com",
    };
  }
}

// git情報を返す
async function _getGitInformation(): Promise<GitInformation> {
  const branchName = await _getGitBranchName();
  const existsRemoteBranch = await _existsGitRemoteBranch(branchName);
  const commitCount = await _getGitCommitCount(branchName);
  const hasChanged = await _hasGitChanges();
  const config = await _getGitConfig();

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
