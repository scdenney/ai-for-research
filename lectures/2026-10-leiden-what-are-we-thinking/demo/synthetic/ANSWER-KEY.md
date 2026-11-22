# Answer key (archives demo)

Kept out of `~/kb-demo` so the agent cannot read it. Everything is invented: the sources, authors, newspaper, bureau and figures. The historical frame (repatriation from Japan through Pusan after 1945, cholera in 1946) is real, and the draft says nothing specific about it beyond that.

| Draft claim | Key | Problem | What the source says |
|---|---|---|---|
| Historians have long treated the registers as complete | `park2021` | Fabricated reference. Real journal, plausible Duke DOI prefix; the DOI returns 404 at Crossref and the title has no match | Nothing: the work does not exist |
| Most returnees crossed on official ships, so the registers are a reliable census | `han2018` | Reverses the source | "Official sailings carried a minority of those who crossed." "The registers record the ships the state sent, not the boats people found." |
| Memoirs describe families paying boatmen and landing unregistered | `kim1972` | None (control) | "We paid the boatman in rice and in my mother's ring." "Nobody wrote our names down when we came ashore at Pusan." |
| A newspaper reported that "most of the returnees who landed carried no papers at all" | `hangdo1946` | Mistranslation and changed scope. 상당수 is "a considerable number", not "most"; it refers to those who came on small boats, not all returnees; and it is one quarantine employee's report | 정기선이 아닌 작은 배로 건너온 동포들 가운데 상당수가 증명서를 지니지 않았다고 한다 |
| The cholera epidemic caused the suspension of sailings on 12 June 1946 | `bureau1946` | Causal overclaim | "The Bureau cannot say which of the two halted the sailings." (quarantine order or reassignment of vessels) |

The conclusion ("a small correction to an otherwise sound count") inherits the reversed Han claim.

Rebuild the inbox with `bash make-inbox.sh`.
