# Evidence for Protect: four cognitive-offloading studies

Relayed 2026-09-16 by the Claude session working on the HBIR course setup, which verified the
citations. Not yet on any slide. Recorded here so the decision to use them is Steven's.

The fit: Part 1's Protect mode asserts that doing certain work is how judgment forms. These four
are the empirical base for that claim, and Autor is the one that turns it from "AI harms learning"
into "benefit tracks pre-existing expertise", which is exactly the student-versus-professor
distinction the deck already draws.

1. Gerlich, M. (2025). AI Tools in Society: Impacts on Cognitive Offloading and the Future of
   Critical Thinking. *Societies* 15(1), 6. doi:10.3390/soc15010006. Correction: *Societies*
   15(9), 252, 10 September 2025, doi:10.3390/soc15090252. Mixed methods, n = 666. Frequent AI
   use negatively associated with critical thinking, mediated by offloading; youngest cohort most
   dependent. Cite the correction if leaning on the numbers.
2. Kosmyna, N. et al. (2025). Your Brain on ChatGPT. arXiv:2506.08872, v2 31 December 2025,
   preprint. EEG, three arms, n = 54, only 18 in the session-4 crossover that carries the
   "cognitive debt" claim. Over-cited in the press. Give it the least weight.
3. Bastani, H. et al. (2025). Generative AI without guardrails can harm learning: Evidence from
   high school mathematics. *PNAS* 122(26), e2422633122, doi:10.1073/pnas.2422633122. Correction:
   *PNAS* 122(34), e2518204122. Field experiment. Unrestricted GPT-4 tutoring raised performance
   during access and left students worse than control after; a guardrailed hint-giving version
   mitigated the harm. "Without guardrails" is load-bearing and is routinely dropped.
4. Autor, D. H. et al. (2026). Does AI Assistance Enhance or Erode Expertise? Evidence from a
   Three-Month Field Experiment in Patent Drafting. NBER Working Paper 35720. Pre-registered RCT,
   133 patent lawyers, blinded expert scoring. Assisted quality up 0.34 SD at 10 days and 0.38 SD
   at 90 days. On the later unaided task, treated beat control by 0.32 SD, concentrated entirely
   in senior lawyers (0.45 SD); juniors showed no average gain and dispersed, fewer mediocre, more
   poor and more good. Authors: "Foundational expertise may be a prerequisite for extracting
   durable skill from AI-assisted practice." They do not generalise to students; that step is ours
   to make explicitly.

**Why Autor is the hinge.** It is the only one where AI-assisted practice left people better on
the later unaided task, and only the already-expert ones. That is the boundary condition behind
"the same stage sits in Protect for the student and Collaborate for the researcher." The junior
result is dispersion, not decline, which is a different pedagogical problem and a better slide
than a flat harm claim.

**Steven's own formulations of the principle**, for the notes:
- `courses/hdw/shared/admin/ai-theme-feedback-202604/ai_feedback_v2.md`, sections 2 to 4: the
  "stop trying to make assessments AI-proof" argument, thinking partner versus shortcut, staged
  assessment.
- `courses/hdw/shared/admin/ai-theme-feedback-202604/ai_feedback_email.md`, condensed.
- `~/Documents/nas_drive/work/teaching/2026-2027/hbir/guidelines/hbir_ai-use-statement_wgr107_DRAFT.md`,
  the student-facing statement (also a hidden Brightspace page).

**Caveat relayed with the citations.** The HBIR student statement cites Gerlich, Kosmyna, and
Bastani for its no-AI expectation and does not yet include Autor. If the lecture presents all
four, that statement is behind its own evidence base and should be updated before the page is
unhidden.

---

# Consolidated review: LLM use and cognition, 30 verified sources

Relayed 2026-09-16 (evening) by the same course-setup session. Every DOI checked against
Crossref or the arXiv abstract page by that session; preprints marked. Steven has chosen two
evidence slides for Protect (Autor and Bastani); this section is the base under them.

## The organising axis

The literature divides by what is measured and when, not by helps versus harms. Optimistic
findings measure performance with the tool present. Pessimistic findings measure capability after
it is removed. Sorted that way the contradiction mostly dissolves and what remains is a moderation
question: who is protected, and by what.

## Four clusters

**1. Assisted performance** (large, consistent, mostly settled)
- Noy and Zhang 2023, *Science* 381(6654): 187–192, doi 10.1126/science.adh2586. RCT, 453
  professionals; time down 40%, quality up 18%. The "0.8 SD / 0.4 SD" figures are from the working
  paper, not the Science version.
- Brynjolfsson, Li and Raymond 2025, *QJE* 140(2): 889–942, doi 10.1093/qje/qjae044. 5,179 support
  agents; +14% overall, +34% novices, about zero for experts.
- Dell'Acqua et al. 2026, *Organization Science* 37(2): 403–423, doi 10.1287/orsc.2025.21838. 758
  consultants, preregistered; inside the frontier +12.2% tasks, 25.1% faster; outside it 19 pp less
  likely to be correct (one task).
- Cui et al. 2026, *Management Science*, doi 10.1287/mnsc.2025.00535. Three company RCTs, 4,867
  developers, +26% tasks. Three of six authors at Microsoft/GitHub.
- Wu et al. 2026, *Humanities and Social Sciences Communications* 13(1): 684, doi
  10.1057/s41599-026-07019-z. Meta-analysis, 35 studies, g = 0.67, mostly with AI present. Not a
  retention estimate.

**2. Cognition and metacognition** (the mechanism)
- Melumad and Yun 2025, *PNAS Nexus* 4(10): pgaf316, doi 10.1093/pnasnexus/pgaf316. Seven
  randomized experiments, n = 10,462. Learning a topic through LLM synthesis versus following links:
  shallower learning (3.43 vs 3.86), sparser and more homogeneous advice (unique facts 0.46 vs 0.72;
  similarity 0.159 vs 0.057), rated less helpful by third parties. Experiment 2 holds facts constant.
  **The most lecture-relevant study in the set: it is about the research process itself.**
- Fernandes et al. 2026, *Computers in Human Behavior* 175: 108779, doi 10.1016/j.chb.2025.108779.
  Performance up about 3 points, self-estimates up about 4; higher self-reported AI literacy
  predicted worse metacognitive accuracy.
- Spatharioti et al. 2025, CHI '25, doi 10.1145/3706598.3714082. Accuracy 93% to 47% on the one
  task where the model errs; 23 of 30 single-query users accepted the wrong answer.
- Kim et al. 2025, CHI '25, doi 10.1145/3706598.3714020, preregistered, N = 308. Explanations raise
  reliance on right and wrong answers alike; source citations and visible inconsistencies
  selectively reduce reliance on wrong ones.
- Vaccaro, Almaatouq and Malone 2024, *Nature Human Behaviour* 8(12): 2293–2303, doi
  10.1038/s41562-024-02024-1. Meta-analysis, 106 studies; human-AI combinations worse than the
  better of the two alone, g = −0.23. Mostly pre-ChatGPT systems.
- Stadler, Bannert and Sailer 2024, *Computers in Human Behavior* 160: 108386, doi
  10.1016/j.chb.2024.108386. n = 91; lower cognitive load, lower-quality reasoning.
- Lee et al. 2025, CHI '25, doi 10.1145/3706598.3713778. 319 knowledge workers; confidence in AI
  predicts less critical-thinking effort. Self-report, correlational.

**3. Unaided capability after withdrawal** (smallest, and the one that matters)
- Bastani et al. 2025 and Autor et al. 2026 (above).
- Darvishi et al. 2024, *Computers & Education* 210: 104967, doi 10.1016/j.compedu.2023.104967.
  1,625 students, AI support randomly withdrawn after four weeks; performance falls when it goes.
  The cleanest withdrawal design in the literature.
- Shen and Tamkin 2026, arXiv:2601.20245 (preprint, preregistered). n = 52 developers, unfamiliar
  library; no time saving; 0.74 SD deficit in conceptual understanding on an unaided quiz. Authored
  at Anthropic; name that.
- Rismanchian et al. 2026, arXiv:2605.21629 (preprint). 3.2M ALEKS interactions; time on task
  down about 27%; proctored correct-response odds down 25% cumulatively. Quasi-experimental.
- Budzyn et al. 2025, *Lancet Gastroenterology & Hepatology* 10(10): 896–903, doi
  10.1016/S2468-1253(25)00133-5. Unaided adenoma detection 28.4% to 22.4% after AI exposure.
  Observational and publicly contested; say "contested" aloud.

**4. Scaffolding and design** (the actionable lesson)
- Bassner et al. 2026, *Computers and Education: AI* 10: 100537, doi 10.1016/j.caeai.2025.100537.
  Three-arm RCT, N = 275: hint-only tutor, unrestricted ChatGPT, no AI. Both AI arms beat control
  on the exercise; neither produced more conceptual learning; the guardrail improved affect and
  load only. "The comfort trap."
- Wang et al. 2025, arXiv:2410.03017 (preprint). Tutor CoPilot: the AI assists the human tutor and
  never touches the learner; +4 pp mastery, +9 pp for students of the weakest tutors.
- Kestin et al. 2025, *Scientific Reports* 15(1): 17458, doi 10.1038/s41598-025-97652-6. Purpose-
  built tutor beat active learning, 0.63 SD; post-test taken at home, proctoring not reported.
- De Simone et al. 2025, World Bank PRWP 11125, doi 10.1596/1813-9450-11125. Teacher-orchestrated
  Copilot, outcomes tested without AI, 0.31 SD. The teacher orchestration is the guardrail.
- Lehmann, Cornelius and Sting 2025, arXiv:2409.09047v2 (preprint). Substitute use versus
  complement use; widened the prior-knowledge gap; usage mode measured, not assigned.

## The reconciliation

Autor's seniors were experts in the task performed. Shen and Tamkin's professionals were screened
for no prior exposure to the specific library. What protects is domain-specific prior knowledge,
not general seniority. Graduate students are almost always novices in the specific literature they
are entering, whatever their general training, so Autor does not exempt them.

## The guardrail claim, softened

Bastani shows a guardrail mitigating harm; Bassner shows the same three-way comparison leaving
conceptual learning flat. Defensible line: guardrails reliably change effort and affect, and only
sometimes change learning. The design that unambiguously worked is Wang's, which keeps the AI away
from the learner entirely.

## Gap verdict

Six studies measure capability after withdrawal, four randomized, none beyond three months, none on
graduate research skills. The evidence base for the thing we most want to know is the thinnest part
of it.

## Slide plan under the two-slide choice

1. On the Autor slide, state the junior result correctly: scores bifurcated, fewer mediocre, more
   poor and more good. Widening variance, not uniform loss.
2. If a third item is wanted, Melumad and Yun, not Gerlich or Kosmyna. Otherwise it leads the notes.
3. For the Part 3 claim-check demonstration, Spatharioti (93% to 47% when the model errs) and Kim
   (fluent explanations raise reliance on wrong answers; citations and surfaced inconsistencies
   reduce it) make the demonstration a lesson rather than a trick.

## Do not cite

- Toner-Rodgers, "Artificial Intelligence, Scientific Discovery, and Product Innovation": MIT
  disowned the data in May 2025. Students may arrive with it; one pre-emptive line.
- A retracted meta-analysis on this topic, *HSSC*, doi 10.1038/s41599-025-04787-y, circulates in
  generated reading lists.
- Gerlich's original Table 4 duplicated Table 3; the correction carries the real ANOVA.
- Peng et al. 2023 (arXiv:2302.06590): the n = 95 could not be verified; superseded by Cui.
- Humlum and Vestergaard NBER WP 33777 was retitled to "Still Waters, Rapid Currents."
- Unverified: arXiv 2605.23177, 2605.29392, 2604.09444, 2606.26181, 2606.06253, 2606.15766,
  2606.09845; Barcaui 2025 (doi 10.1016/j.ssaho.2025.102287), whose retention figures come from a
  third-party summary.
