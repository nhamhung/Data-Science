# Intent Statement — Academic Success Portfolio

## Problem Statement

People who complete Kaggle Learn's tabular-data microcourses (Pandas, Data Cleaning, Intro to Machine Learning, Intermediate Machine Learning, Feature Engineering) have no single project that exercises all of those skills together, end-to-end, from a raw dataset to something they can actually run and show. [Q1]

## Target Customer

External self-learners who have just finished those Kaggle Learn microcourses and want one worked example that visibly maps back to what they studied — as opposed to scattered, unrelated tutorials. [Q2]

## Success Metrics

The project is successful when all four agreed deliverables exist and work: [Q3]

1. A well-documented notebook that builds a Kaggle-competitive model at university-project depth, applying good practices.
2. A Docker-deployed Streamlit app that lets a non-technical user interact with the trained model.
3. A Quarto (`.qmd`) research-style writeup explaining key concepts and results.
4. A script that produces a valid, Kaggle-submittable `submission.csv`.

No leaderboard rank/percentile target is in scope — competitive score is a secondary benefit of "good practices," not the success metric itself. [Q3]

## Initiative Trigger

Opportunity: the user wants a teaching/portfolio artifact that didn't exist yet in this otherwise-empty repository. [Q4]

## Initial Scope Signal

- **Workflow-selected scope**: `academic-success-portfolio` (a composed plan: 9 of 33 stages execute, 6 approval gates). [scope]
- **User-confirmed product boundary**: Confirmed as matching intent — a solo teaching artifact (notebook + app + writeup + submission script), with no team-formation, operations, or infrastructure-design stages needed. [Q8]

## Dataset & Technical Decisions (carried from prior discussion)

- **Dataset/competition**: Kaggle Playground Series S4E6, "Classification with an Academic Success Dataset" — multi-class classification (Dropout / Enrolled / Graduate). [desc]
- **Deployment**: Streamlit app in a Docker container. [desc]
- **Dependency management**: plain `requirements.txt`. [desc]
- **Writeup format**: Quarto (`.qmd` → HTML/PDF). [desc]
- **Repo layout** (pending confirmation during Functional Design): `data/` (gitignored raw+processed), `notebooks/01_eda_and_modeling.ipynb`, `src/academic_success/{config,data,features,model}.py` as the single shared preprocessing/training source of truth, `models/model.joblib`, `app/{streamlit_app.py,Dockerfile}`, `scripts/{train.py,make_submission.py}`, `report/report.qmd`, `tests/test_features.py`, `requirements.txt`, `README.md`. [desc]

## Assumptions & Open Questions

None.

## Review

### Findings

| ID | Severity | Location | Finding | Required action | Status |
|---|---|---|---|---|---|
| R-01 | Major | intent-statement.md > Success Metrics | The sentence "No leaderboard rank/percentile target is in scope — competitive score is a secondary benefit of 'good practices,' not the success metric itself. [Q3]" converts Q3's *unselected* option B ("A specific leaderboard rank/percentile on the Playground S4E6 competition") into an explicit exclusion. The stage definition's grounding contract states: "Never turn an unselected option into an exclusion or requirement." The confirmed answer to Q3 is option A only; it says nothing about excluding leaderboard rank as a metric. | Remove the exclusion sentence, or add a follow-up question that explicitly asks the user to confirm leaderboard rank is out of scope, then cite that confirmed answer instead of Q3. | New |
| R-02 | Major | intent-statement.md > Initial Scope Signal | The line "`academic-success-portfolio` (a composed plan: 9 of 33 stages execute, 6 approval gates). [scope]" cites "6 approval gates," a detail that appears nowhere in the Q&A file or the `## Sources` register. Q8's confirmed answer mentions only "the composed 9-of-33-stage plan" — no gate count. Per the stage's grounding contract, `[scope]` "proves only workflow-selected scope," and confirmed product-boundary detail must be tagged to the scope-confirmation question (`[Q8]`), not `[scope]`. This line is both unsourced (the "6 approval gates" figure) and mistagged (the "9 of 33 stages" figure should carry `[Q8]`, not `[scope]`). | Remove "6 approval gates" (not confirmed anywhere), and re-tag the "9 of 33 stages" detail as `[Q8]` since that is where it was actually confirmed. | New |
| R-03 | Major | stakeholder-map.md > Stakeholders (row 2) | "End readers of the portfolio (Kaggle Learn graduates)" is listed as a stakeholder with an "Influencer" authority classification, sourced to `[Q2]`. Q2 is the *target-customer* question, not the stakeholders question — its confirmed answer describes who benefits from the project, not who has stakeholder authority or influence over scope. Q5 (the stakeholders question) was confirmed with answer A naming only "The user (sole developer/author)" as a stakeholder. Promoting the customer to a stakeholder row with an invented "Influencer" designation is not directly supported by any confirmed answer to a stakeholder-scoped question, contrary to the stage rule "Never invent a stakeholder role, interest, authority, or communication requirement." | Either remove this row (Q5's confirmed stakeholder list contains only the user), or add a follow-up question asking the user to confirm whether end readers/customers count as a stakeholder with influence, and cite that confirmed answer. | New |
| R-04 | Minor | intent-statement.md > Dataset & Technical Decisions | This section (dataset choice, Docker deployment, `requirements.txt`, Quarto format, and a full proposed repo file layout) goes beyond the stage's five required sections (Problem Statement, Target Customer, Success Metrics, Initiative Trigger, Initial Scope Signal) and pre-commits implementation-level decisions that intent-capture is meant to frame WHAT/WHY, not HOW. It is correctly sourced to `[desc]` (no `<document>` block is present, so `[desc]` may ground artifact claims per the grounding contract) and is explicitly labeled "pending confirmation" for the repo layout, but the dataset/deployment/dependency/writeup-format lines are stated as settled facts with no such hedge, risking premature lock-in before Requirements Analysis or Functional Design evaluates alternatives. | Consider hedging the non-repo-layout technical decisions the same way the repo layout is hedged ("pending confirmation during Requirements Analysis/Functional Design"), or move this section's content out of the intent statement into a carried-forward note for the next stage. | New |

### Summary

Three Major findings stem from concrete grounding-contract violations traceable to the stage definition: an unselected option turned into an exclusion (R-01), a numeric detail with no source in the Q&A file plus a source-tag mismatch (R-02), and a stakeholder row whose role/authority is not supported by the stakeholders question it should trace to (R-03). One Minor finding (R-04) flags scope creep into implementation-level detail that, while technically sourced, sits outside intent-capture's WHAT/WHY purpose. Per the stage's own verdict rule (NOT-READY if >2 Major findings), this artifact set is not yet ready to proceed as-is; the fixes are narrow (re-tag/re-source three claims) and do not require re-running the whole stage.

**Verdict:** NOT-READY
**Reviewer:** aidlc-product-lead-agent
**Iteration:** 1
