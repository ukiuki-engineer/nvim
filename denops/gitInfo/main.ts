import { Denops } from "https://deno.land/x/denops_std@v1.0.0/mod.ts";
import { isGitProject, setGitInformation } from "./gitUtils.ts";

export async function main(denops: Denops): Promise<void> {
  // vim側に関数を公開
  denops.dispatcher = {
    asyncRefreshGitInfo(fetch: boolean): void {
      setGitInformation(denops, fetch);
    },
    async refreshGitInfo(fetch: boolean): Promise<void> {
      await setGitInformation(denops, fetch);
    },
  };

  // gitプロジェクトの場合はgit情報をvim側のグローバル変数にセット
  if (await isGitProject(denops)) {
    await setGitInformation(denops);
    setGitInformation(denops, true);
  }

}
