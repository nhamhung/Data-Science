---
name: academic-success-portfolio
depth: Focused
keywords: []
description: Solo data science portfolio/teaching project predicting student academic outcomes (Kaggle Playground Series S4E6) — notebook, Streamlit app, Quarto writeup, and submission script built around one shared preprocessing/training module
skeleton: on
review_cap: advisory
---

# academic-success-portfolio scope

Composed scope for a solo, single-unit data science portfolio project with an
already-agreed intent, tech stack, and repo layout (Kaggle Playground Series
S4E6 academic-outcomes classification). 9 stages EXECUTE, 24 SKIP.

## Why these stages, why skip those

Intent, structural, and risk uncertainty are all low: the dataset, tech
stack (sklearn/XGBoost-style pipeline, Streamlit, Docker, Quarto,
requirements.txt), deliverables, and even the target module layout were
already agreed before this scope was composed. Verification entropy sits at
the low end of MED only because this is a fresh, empty greenfield repo with
no tests yet — expected, not a sign of hidden complexity.

Kept: `intent-capture` (formalizes the already-agreed intent into an
approved spec), `approval-handoff` (mandatory phase gate),
`practices-discovery` (settles tooling/test conventions for the new repo),
`functional-design` (the shared `src/academic_success` preprocessing/
training module is the single train/serve source of truth and deserves an
explicit design pass even though overall structural uncertainty is low —
this is a deliberate un-skip for real engineering practice),
`code-generation` and `build-and-test` (the implementation/verification
spine).

Skipped: ideation framing stages that would only restate what was already
agreed (`market-research`, `feasibility`, `scope-definition`,
`team-formation`, `rough-mockups`); `reverse-engineering` (greenfield);
`requirements-analysis`, `user-stories`, `refined-mockups`, `domain-design`,
`units-generation`, `contract-design`, `delivery-planning` (single
self-contained unit, no multi-component or multi-unit decomposition needed);
`nfr-requirements`/`nfr-design`/`ci-pipeline` (no genuine performance,
security, scale, or CI requirement was raised — risk is low, the stack is
already fixed, and test coverage is delivered through `build-and-test` plus
the requested `tests/test_features.py`); the whole operations phase (no
production deployment, no cloud infra beyond a local Docker container, no
operational surface to observe or run incident response against).

## Membership

No keyword triggers (composed scope, `keywords: []`) — resolves only via
`--scope academic-success-portfolio`. Initialization plus a thin
ideation→practices-discovery→functional-design→code-generation→build-and-test
path execute; everything else is SKIP.
