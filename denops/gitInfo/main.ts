import { Denops } from "https://deno.land/x/denops_std@v1.0.0/mod.ts";
import * as denopsStd from "https://deno.land/x/denops_std@v4.1.0/variable/mod.ts";

async function getGitInformation(): Promise<any> {
  const gitBranch = Deno.run({
    cmd: ["git", "branch", "--show-current"],
    stdout: "piped",
    stderr: "piped",
  });
  const branchName = new TextDecoder().decode(await gitBranch.output()).trim();
  gitBranch.close();

  // TODO: 他のGit情報も取得

  return {
    branch_name: branchName,
    // TODO: 他の情報もここに含める
  };
}

async function setGitInformation(denops: Denops): Promise<void> {
  const gitInfo = await getGitInformation();
  await denopsStd.g.set(denops, "my#git_info_", gitInfo) // TODO: 完成したらmy#git_infoに変更する
}

export async function main(denops: Denops): Promise<void> {
  // TODO: gitプロジェクトかどうかを判定する
  await setGitInformation(denops);
}
