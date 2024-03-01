import { Denops } from "https://deno.land/x/denops_std@v1.0.0/mod.ts";
import * as denopsStd from "https://deno.land/x/denops_std@v4.1.0/variable/mod.ts";

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

  return {
    branchName: branchName,
  };
}

async function setGitInformation(denops: Denops): Promise<void> {
  const gitInfo = await getGitInformation();
  await denopsStd.g.set(denops, "git_info#git_info", gitInfo);
}

export async function main(denops: Denops): Promise<void> {
  // TODO: gitプロジェクトかどうかを判定する
  await setGitInformation(denops);
}
