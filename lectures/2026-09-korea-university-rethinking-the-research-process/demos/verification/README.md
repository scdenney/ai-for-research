# Illustrative numerical verification demo

This project-specific teaching example has 25 binary rows: 7 positive and 18 negative. `generate_result.py` computes the positive proportion (`7 / 25 = 0.28`) and writes `generated/demo-result.json`; that generated artifact is always reproducible and is never edited by hand.

`report-stale.md` preserves the initial stale abstract and table values (`0.31`). `report-corrected.md` preserves the corrected values (`0.28`). `compare_report.py` parses both values from the selected report and compares them with the numeric `value` read from the generated JSON. It exits nonzero for stale, missing, non-finite, out-of-range, or invalid inputs.

`run_pipeline.py` is the acceptance path. Each invocation generates to a new temporary result, then compares only that fresh result. If generation fails, it stops before comparison, so a pre-existing `generated/demo-result.json` cannot supply a stale pass.

Run the self-contained demonstration and write receipts:

```sh
cd demos/verification
python3 run_receipts.py
```

The runner works in a temporary copy. It records stale and corrected pipeline outcomes, a failed-analysis pipeline that stops before comparison despite a pre-existing `0.28` output, and invalid, non-finite, out-of-range, and missing-output failures. It does not invoke the preserved OSS verifier, its `--run` option, or any research pipeline.

This is an illustrative project-specific consistency check. It demonstrates a narrow numerical comparison; it does not establish research validity or reproduce an external project.
