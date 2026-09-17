# Opening and Part 1 speaker notes

The opening contains six physical frames and is budgeted for 8:00. Part 1 contains eleven physical frames and is budgeted for 15:00.

## 1. Rethinking the Research Process

**Duration: 00:30**

Welcome the audience and introduce the lecture as a practical account of how AI changes research for both students and professors. Move directly to the scope of the talk.

## 2. AI in research and teaching

**Duration: 01:20**

Give the audience the three-part agenda. First, ask what research and teaching work should be automated, protected, or done in collaboration with AI. Second, explain how I use a research knowledge base and Open Science Skills. Third, show a short example of checking a claim against its sources.

## 3. Generative AI and agentic AI

**Duration: 01:30**

Generative AI is the broad category: systems that produce new material such as text, images, audio, or code. A large language model is a model trained on large amounts of text to predict and produce language. It often supplies the language capability in a generative system.

Agentic AI describes AI that can use tools, observe what those tools return, and choose what action to take next. These categories overlap. An agent can use an LLM to interpret the task and generate language.

Avoid implying that every generative system is an agent or that agents use a different kind of model.

## 4. From a conversation to carrying out a task

**Duration: 01:30**

Keep the example constant: find the source behind a citation and report what it says. In a basic conversation, the model answers from the conversation and whatever material has been provided. The researcher performs the next action.

A tool-using agent can carry out several steps. It can search the project, open the source, run a command or script when needed, and use the result to decide what to do next. Claude Code and Codex are applications that support this kind of work. Their exact tools and permissions depend on their configuration.

The difference on this slide is the ability to act and continue, not a browser-versus-terminal distinction.

## 5. What changes when we use agents for research?

**Duration: 01:40**

Software development helped make agents useful because agents can edit code, run it, and receive quick feedback from execution, compilers, and tests. Tests check whether code behaves as expected under the cases and specifications supplied. Passing tests does not establish that software is completely correct.

Research has a different checking problem. A source can exist while the sentence citing it remains wrong. Checking support requires reading and interpretation. Measurement, research design, and inference require substantive judgment. An agent can help collect and organize the evidence, but the researcher must understand what that evidence establishes.

This difference motivates the three modes in Part 1 and the project infrastructure in Part 2.

## 6. A claim we will return to

**Duration: 01:30**

Read the historical sentence and its two citations. It claimed that studies of unilateral policymaking showed that citizens penalized executive action relative to legislative action.

Ask the audience what those sources would need to establish for the sentence to be accurate. Do not answer yet. Explain only that this is an actual excerpt from an earlier manuscript version. Part 2 will show the working arrangement used to examine sources, and Part 3 will return to what these sources said and how the sentence changed.

Evidence: NWO Paper 2, parent of manuscript commit `75366c6`, `sections/frontmatter/front_matter.tex`; citations `ReevesRogowski2016` and `ChristensonKriner2017`.

## 7. Automate, protect, collaborate

**Duration: 00:15**

Introduce Part 1 as three modes of AI engagement. They are choices about the role of human cognition, not a sequence in which collaboration is automatically more advanced.

## 8. Three modes of AI engagement

**Duration: 01:45**

Automate work that is routine and gains little from your personal attention. Protect selected activities when doing the work develops or demonstrates the understanding being learned or assessed. Collaborate when human judgment and AI capability both matter.

The examples clarify the boundary. Scheduling and formatting are routine. Close reading and explaining a method can be the point of an educational task. Comparing sources or analysing data can combine machine reach with a researcher’s substantive judgment.

The same activity may belong in different modes for different people or purposes. An experienced researcher may collaborate on work that a student needs to practise directly.

## 9. Hand off routine work

**Duration: 00:20**

State the automation position confidently: hand off routine work. Efficiency is the goal.

## 10. Save time and attention

**Duration: 01:10**

Use the four rows as ordinary examples: schedule meetings and reminders; track tasks, milestones, and deadlines; file and organize project materials; format references, tables, slides, and documents.

These tasks still need clear instructions, but performing them personally contributes little to the substantive research or learning objective. Automate them extensively and use the saved attention elsewhere.

## 11. Preserve the work that builds understanding

**Duration: 00:20**

State the principle firmly: protect the work through which understanding and judgment are built or demonstrated. This is a principle for selecting activities, not a categorical ban on AI in teaching, reading, or writing.

## 12. Protect selected steps that build understanding

**Duration: 01:30**

Use interpretation as the example. A learner marks the passages that matter, states what the author is claiming, connects evidence to a conclusion, and explains the choices and revisions.

Assistance may support the process, but it should not let the learner bypass the practice that the task is meant to develop. Visible intermediate work also gives a teacher something more informative to assess than a polished final answer alone.

## 13. AI assistance and later unaided review

**Duration: 02:30**

Autor and colleagues studied 133 practising patent lawyers at 11 US firms over three months. Junior means fewer than seven years of experience; senior means seven or more. On the left, lawyers drafted a patent with AI available. On the right, they later reviewed and revised a patent without AI. The paper calls that task redlining.

The assisted-drafting estimates are positive for both experience groups, although the senior interval crosses zero at the approximate 95 percent level. On the separate unaided review task, the junior estimate is near zero with an interval spanning zero, while the senior estimate is positive.

Describe the junior result as no clear average effect. Do not infer either average decline or proof of no effect. The authors separately report greater dispersion among juniors; that variance result is not shown by the plotted mean and interval. These are different tasks at 90 days, professional experience was not randomized, and the study does not directly estimate effects on graduate research skills.

Evidence: Autor et al. (2026), NBER Working Paper 35720, Tables 4 and 6, column 4; Figure 3 and Table 7 for dispersion.

## 14. Practice with AI, then an exam without it

**Duration: 02:30**

Bastani and colleagues studied high-school mathematics in Turkey. GPT Base provided unrestricted assistance. GPT Tutor provided guided assistance designed to support learning. Both groups performed better than the no-AI control during assisted practice.

The later exam was completed without AI. The unrestricted group scored 5.4 percentage points below control. The guided group estimate was close to zero. The guided tutor mitigated the harm observed in this setting, but it did not establish a learning gain over the control group.

Keep the outcomes separate: assisted practice and the later unaided exam are not a single before-and-after trajectory. The study does not establish that guardrails improve learning in every setting. Bassner and colleagues provide a useful qualification from programming education: better assisted performance did not produce greater measured learning in either AI condition.

Evidence: Bastani et al. (2025), PNAS, Table 1; Bassner et al. (2026), *Computers and Education: Artificial Intelligence* 10, 100537.

## 15. Combine human judgment with machine capability

**Duration: 00:20**

Introduce collaboration as the broad category in which machine capability changes the scale, speed, or form of the work while the human retains responsibility for substantive decisions. Reach is the goal.

## 16. Collaboration across research and teaching

**Duration: 01:30**

Collaboration can operate throughout research and teaching. An agent can retrieve literature and compare passages, organize data and help write or test code, assist with visualisation, and help structure or revise writing. In supervision, it can organize feedback after the teacher has read and evaluated the work.

The researcher or teacher retains the substantive decisions: which sources matter, whether an analysis answers the question, what a draft should claim, and what judgment feedback should express.

## 17. Four ways to organize collaboration

**Duration: 02:50**

Christopher Kenny presents four models of agent use, adopting Colin Swaney’s 2026 workshop. The table reorganizes them by who plans, acts, and checks.

In pair programming, the human and agent work together throughout. In a planning commission, the human makes the plan, the agent implements it, and the human checks the result. In a review board, the agent plans and acts while the human reviews. In autopilot, the human gives the instruction and the agent carries out and validates the work.

These are all subtypes of collaboration. The final pattern describes who performs the immediate validation; it does not transfer ultimate responsibility away from the researcher.

Transition to Part 2: the next question is how to organize these collaborations around project files, a source-centred knowledge base, and reusable skills.

Evidence: Kenny, *Agentic AI for Political Science Research* (10 September 2026), p. 16, adopting Colin Swaney’s Spring 2026 “Claude Overload” workshop.
