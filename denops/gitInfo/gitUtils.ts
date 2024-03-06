import { Denops } from "https://deno.land/x/denops_std@v1.0.0/mod.ts";
import * as denopsStd from "https://deno.land/x/denops_std@v4.1.0/variable/mod.ts";

interface GitCommitCounts {
  un_pulled: number;
  un_pushed: number;
}

interface GitConfig {
  user_name: string;
  user_email: string;
}

interface GitInformation {
  branch_name: string;
  exists_remote_branch: boolean;
  commit_counts: GitCommitCounts;
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
    const { code, stdout } = await process.output();

    if (code === 0) {
      const output = new TextDecoder().decode(stdout).trim();
      return output === "true";
    } else {
      // Gitコマンドが失敗した場合は、現在のディレクトリがGitリポジトリではないか、
      // またはGitがインストールされていないことを意味する。
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
    await _gitFetch();
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

// git fetch
async function _gitFetch(): Promise<boolean> {
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
async function _getGitCommitCounts(
  currentBranch: string
): Promise<GitCommitCounts> {
  try {
    if (!currentBranch) {
      return { un_pulled: 0, un_pushed: 0 };
    }

    // 未プルのコミット数を計算
    const remoteCommand = new Deno.Command("git", {
      args: ["rev-list", "--count", "HEAD..origin/" + currentBranch],
      stdout: "piped",
      stderr: "piped",
    });
    const remoteProcess = remoteCommand.spawn();
    const { code: remoteCode, stdout: remoteStdout } =
      await remoteProcess.output();
    const unPulled =
      remoteCode === 0
        ? parseInt(new TextDecoder().decode(remoteStdout).trim(), 10)
        : 0;

    // 未プッシュのコミット数を計算
    const localCommand = new Deno.Command("git", {
      args: ["rev-list", "--count", "origin/" + currentBranch + "..HEAD"],
      stdout: "piped",
      stderr: "piped",
    });
    const localProcess = localCommand.spawn();
    const { code: localCode, stdout: localStdout } =
      await localProcess.output();
    const unPushed =
      localCode === 0
        ? parseInt(new TextDecoder().decode(localStdout).trim(), 10)
        : 0;

    return {
      un_pulled: unPulled,
      un_pushed: unPushed,
    };
  } catch (error) {
    console.error("Failed to execute Git command:", error);
    return {
      un_pulled: 0,
      un_pushed: 0,
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
  // 非同期処理を一括で実行
  const [existsRemoteBranch, commitCounts, hasChanged, config] =
    await Promise.all([
      _existsGitRemoteBranch(branchName),
      _getGitCommitCounts(branchName),
      _hasGitChanges(),
      _getGitConfig(),
    ]);

  return {
    branch_name: branchName,
    exists_remote_branch: existsRemoteBranch,
    commit_counts: {
      un_pulled: commitCounts.un_pulled,
      un_pushed: commitCounts.un_pushed,
    },
    has_changed: hasChanged,
    config: {
      user_name: config.user_name,
      user_email: config.user_email,
    },
  };
}
