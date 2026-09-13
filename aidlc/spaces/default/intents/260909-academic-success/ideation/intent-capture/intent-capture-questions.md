# Intent Capture Questions — Academic Success Portfolio

## Sources

- [desc] Initial description: "Build a data science portfolio/teaching project in /Users/nhamquochung/data (the AI-DLC framework is already installed there — this is a fresh intent in an otherwise-empty repo). Project: predict student academic outcomes (Dropout/Enrolled/Graduate) using Kaggle's Playground Series S4E6 \"Classification with an Academic Success Dataset\" competition. Already brainstormed and agreed with the user (not yet approved as a full spec): maps to Kaggle Learn's Pandas, Data Cleaning, Intro/Intermediate ML, and Feature Engineering microcourses; deliverables are (1) a well-documented notebook building a Kaggle-competitive model with good practices at university-project depth, (2) a Streamlit app (Docker-deployed) for non-technical users to interact with the model, (3) a Quarto (.qmd) research-style writeup of concepts/results, (4) a script producing a Kaggle-submittable submission.csv. Dependency management: plain requirements.txt. Proposed repo layout (pending final confirmation): data/ (gitignored raw+processed), notebooks/01_eda_and_modeling.ipynb, src/academic_success/{config,data,features,model}.py as the single shared preprocessing/training source of truth, models/model.joblib, app/{streamlit_app.py,Dockerfile}, scripts/{train.py,make_submission.py}, report/report.qmd, tests/test_features.py, requirements.txt, README.md."
- [scope] Workflow-selected scope: `academic-success-portfolio`.

## Q1. What business problem are we solving?

- A. Give people who've completed Kaggle Learn's tabular-data microcourses (Pandas, Data Cleaning, Intro/Intermediate ML, Feature Engineering) a single project that exercises those exact skills end-to-end, from notebook to a usable app [desc]
- B. Build a production-grade student-outcome prediction service for a real university
- C. Not yet defined
- D. Not applicable
- X. Other

[Answer]: A. Give people who've completed Kaggle Learn's tabular-data microcourses (Pandas, Data Cleaning, Intro/Intermediate ML, Feature Engineering) a single project that exercises those exact skills end-to-end, from notebook to a usable app

## Q2. Who is the customer (internal/external)? What pain are they experiencing?

- A. External: self-learners who just finished Kaggle Learn microcourses and want one worked example that visibly maps back to what they studied, rather than scattered unrelated tutorials [desc]
- B. Internal: a single team member's own portfolio piece, no external audience
- C. Not yet defined
- D. Not identified
- X. Other

[Answer]: A. External: self-learners who just finished Kaggle Learn microcourses and want one worked example that visibly maps back to what they studied, rather than scattered unrelated tutorials

## Q3. What does success look like? What metrics matter?

- A. All four deliverables exist and work: (1) a well-documented notebook building a competitive model with good practices, (2) a Docker-deployed Streamlit app usable by non-technical people, (3) a Quarto research-style writeup, (4) a script producing a valid Kaggle submission.csv [desc]
- B. A specific leaderboard rank/percentile on the Playground S4E6 competition
- C. Not yet defined
- D. Not applicable
- X. Other

[Answer]: A. All four deliverables exist and work: (1) a well-documented notebook building a competitive model with good practices, (2) a Docker-deployed Streamlit app usable by non-technical people, (3) a Quarto research-style writeup, (4) a script producing a valid Kaggle submission.csv

## Q4. What is the trigger for this initiative (market pressure, tech debt, regulation, opportunity)?

- A. Opportunity: the user wants a teaching/portfolio artifact that didn't exist yet in this otherwise-empty repo [desc]
- B. Not yet defined
- C. Not applicable
- X. Other

[Answer]: A. Opportunity: the user wants a teaching/portfolio artifact that didn't exist yet in this otherwise-empty repo

## Q5. Who are the key stakeholders and what does each care about?

- A. The user (sole developer/author) — cares that the project genuinely teaches the four target skill areas and holds up as a portfolio piece [desc]
- B. Not yet defined
- C. Not identified
- X. Other

[Answer]: A. The user (sole developer/author) — cares that the project genuinely teaches the four target skill areas and holds up as a portfolio piece

## Q6. Who decides scope or priority, and who influences those decisions?

- A. The user alone — solo project, no other decision-makers [desc]
- B. Not yet defined
- C. Not applicable
- X. Other

[Answer]: A. The user alone — solo project, no other decision-makers

## Q7. Are there communication requirements or a reporting cadence?

- A. None — solo project, no reporting cadence needed [desc]
- B. Not yet defined
- C. Not applicable
- X. Other

[Answer]: A. None — solo project, no reporting cadence needed

## Q8. The workflow was started with the scope in `[scope]`; does that scope match the user's intended product boundary?

- A. Yes — `academic-success-portfolio` (the composed 9-of-33-stage plan) matches the intended boundary: a solo teaching artifact with a notebook, an app, a writeup, and a submission script, no team/ops/infra stages [scope]
- B. No — a different product boundary was intended
- C. Not yet defined
- X. Other

[Answer]: A. Yes — `academic-success-portfolio` (the composed 9-of-33-stage plan) matches the intended boundary: a solo teaching artifact with a notebook, an app, a writeup, and a submission script, no team/ops/infra stages

## Assumptions & Open Questions

None.

## Consolidated Summary Confirmation

**Decision**: Does this all look correct before I generate the artifact?

- Looks correct
- Request changes

[Answer]: Looks correct
