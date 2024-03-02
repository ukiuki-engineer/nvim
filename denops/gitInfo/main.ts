import { Denops } from "https://deno.land/x/denops_std@v1.0.0/mod.ts";
import { isGitProject, gitFetch, setGitInformation } from "./gitUtils.ts";

// TODO: git情報を更新するautocmdを追加する
// ->vimscript or lua側で

export async function main(denops: Denops): Promise<void> {
  if (!(await isGitProject())) {
    console.log("TODO: gitプロジェクトではない場合の処理");
    return;
  }

  // vim側に関数を公開
  denops.dispatcher = {
    async refreshGitInfo(): Promise<void> {
      setGitInformation(denops);
    },
  };

  await setGitInformation(denops);
  await gitFetch();
  setGitInformation(denops);
}
