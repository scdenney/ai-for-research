# Selected OSS 2.31.0 evidence snapshot

This is a small, readable evidence snapshot for the approved lecture. It is not an OSS installation and it is not a bundled OSS comparator.

`installed/` is copied from the installed cache at `/Users/scdenney/.claude/plugins/cache/open-science-skills/oss/2.31.0`. The cache metadata identifies version `2.31.0`; it is the authority for that installed version. The included plugin metadata records that skills are on demand and records the declared `CC-BY-NC-4.0` license. `LICENSE` is preserved from the local OSS repository.

`codex/` is a selected comparison copy from `/Users/scdenney/Documents/github/resources/open-science-skills/codex`: the named research, review, citation, fact, replication, three conjoint, and session-hygiene skills plus their Codex `agents/openai.yaml` configurations. The local source was dirty when this snapshot was recorded. The manifest records exact file hashes and dirty paths; it makes no claim about an inferred source commit.

The selection includes `research-repo`, `citation-check`, `fact-check`, `paper-review-lite`, `replication-package` and its verifier script, `conjoint-cleaning`, `conjoint-design`, `conjoint-diagnostics`, `sitrep`, `finished`, `commands/verify.md`, and the installed static-check script. It excludes all unrelated files and whole repositories.

Verify the existing machine-readable manifest and pinned copied-file hashes:

```sh
python3 verify_snapshot.py
```

The default check reads only this snapshot and `SOURCE-MANIFEST.json`; it does not need the original cache or local OSS repository, and it does not rewrite the manifest. It uses static hashes only. The preserved `commands/verify.md` describes an optional `--run` in a temporary copy that depends on the host environment; this work neither invokes it nor claims a hermetic environment. The snapshot is evidence of selected filenames and baseline crosswalks, not numerical validation.

The absence of a bundled verifier in an earlier release would only mean that release lacked that bundled verifier. It would not show that no skill had ever run code.
