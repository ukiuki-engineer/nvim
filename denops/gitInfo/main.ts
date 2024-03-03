import { Denops } from "https://deno.land/x/denops_std@v1.0.0/mod.ts";
import { isGitProject, gitFetch, setGitInformation } from "./gitUtils.ts";

export async function main(denops: Denops): Promise<void> {
  if (!(await isGitProject())) {
    return;
  }

  // vim側に関数を公開
  denops.dispatcher = {
    refreshGitInfo(fetch: boolean): void {
      setGitInformation(denops, fetch);
    },
  };

  await setGitInformation(denops);
  await gitFetch();
  setGitInformation(denops);
}
