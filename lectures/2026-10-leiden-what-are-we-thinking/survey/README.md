# Audience survey runbook

Anonymous Qualtrics survey for the Leiden seminar, 21 October 2026, 15:00. The QR goes on slide 2;
the responses are exported when the talk ends, with no break, and shown in the closing discussion.

The scripts reuse the BA3 Text as Data toolkit in
`~/Documents/github/courses/ba3tad-26/instructor-workbench/surveys/` without changing it.
`_toolkit.py` pins its `build_surveys.py` by sha256, points its spec, build and ID paths at this
folder, and reads the template QSF from the toolkit folder. Credentials come from
`~/.config/qualtrics/hdw26.env` (override with `BA3_QUALTRICS_ENV`); no script prints them.

| File | Purpose |
|---|---|
| `specs/leiden26_audience.yaml` | The survey: fourteen items, one question per page, nothing forced |
| `build-survey.py` | Checks the spec, then runs the toolkit build (`--validate --dry-run`, `--push --activate --validate`, `--links`) |
| `make-qr.py` | `qr-audience.png` for slide 2 and `qr-audience.pdf`, a 16:9 backup slide |
| `export-responses.py` | Writes `responses.json` (labels only, no IDs or dates); also the deletion mode |

`ids.json`, `survey-id.txt`, `_build/`, `responses.json` and any CSV are git-ignored.

## Tonight (dry run)

1. Scan `qr-audience.png` with two phones. Submit one test response from each; check that the
   page loads on mobile, nothing is required, and Back works.
2. `python3 export-responses.py --since 2026-10-20T00:00:00+02:00` should show the test responses
   with `DistributionChannel` `anonymous`. Run `python3 results.py` on them if it exists by then.
3. Delete the test responses so tomorrow starts clean:
   `python3 export-responses.py --delete-before 2026-10-21T12:00:00+02:00 --confirm-survey-id SV_...`
   (lists them), then the same command with `--execute`.

To fix a wording error without changing the link or the QR:
`python3 build-survey.py --push --update --validate` (refuses if the survey has responses).

## Tomorrow, when "Your answers" comes up (no break)

```
python3 export-responses.py && python3 results.py && open results.pdf
```

`--since` defaults to 14:30 Amsterdam time, so anything submitted before then is left out.

## If something fails

- **HTTP 401 or 403** (token expired or lacks permission): skip the API. Build the slide by hand
  from the Qualtrics web report, using the item wording and labels in `_build/leiden26_audience.qsf`
  (`python3 build-survey.py --validate --dry-run` regenerates it offline).
- **Export stuck or times out**: in Qualtrics, Data & Analysis > Export & Import > Export data >
  CSV, "Use choice text". Then `python3 export-responses.py --from-csv ~/Downloads/<file>.csv`.
- **No Wi-Fi in the room**: use the phone hotspot for the laptop. The audience uses mobile data.

## After the seminar

Delete all responses, as the survey notice promises:
`python3 export-responses.py --delete-before 2026-10-22T00:00:00+02:00 --confirm-survey-id SV_... --execute`.
Then delete `responses.json`.
