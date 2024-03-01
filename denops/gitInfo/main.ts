import { Denops } from "https://deno.land/x/denops_std@v1.0.0/mod.ts";
import * as denopsStd from "https://deno.land/x/denops_std@v4.1.0/variable/mod.ts";

// TODO: git情報を更新するautocmdを追加する
// TODO: git情報を更新するcommandを追加する

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

async function getGitInformation(): Promise<any> {
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
    return null;
  }

  const branchName = decoder.decode(stdout).trim();

  // TODO: 未pull、未pushのcommit数
  // TODO: 変更があるか
  // TODO: user.nameとuser.email

  return {
    branchName: branchName,
  };
}

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
