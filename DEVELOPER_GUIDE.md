# Developer Guide

This guide is for anyone who clones one of the portfolio's five independent
repositories to run, edit, or extend it locally — a teammate, a reviewer, or
future-you on a different machine. Each repository is fully self-contained
(its own venv, data, model, notebook, app, report, CI, and deployment).

If you only want to *use* a project (run its app, read its report), see that
project's own `README.md` instead — this guide is for people who want to
**change** something.

## 1. Install the prerequisites

These are machine-level installs, done once, before touching any project:

| Dependency | Why | Install |
|---|---|---|
| **Python 3.12** | Every project's venv is built against 3.12 — a different major/minor version may resolve different (or incompatible) package versions from `requirements.txt`. | [python.org/downloads](https://www.python.org/downloads/) or a version manager (`pyenv install 3.12`, etc.) |
| **Git** | To clone the repo. | [git-scm.com/downloads](https://git-scm.com/downloads) (often already present on macOS/Linux) |
| **Quarto** | Renders `report/report.qmd` — a standalone binary, not a Python package, so `pip install` never gets it. | [quarto.org/docs/get-started](https://quarto.org/docs/get-started/) |
| **Kaggle API token** | Needed only for a project's complete dataset. Tests use synthetic data and each deployed app starts from a bundled sample. | Create a Kaggle account, then **Account → Create New API Token**, saving the downloaded `kaggle.json` to `~/.kaggle/kaggle.json` (`%USERPROFILE%\.kaggle\kaggle.json` on Windows). See the [Kaggle API docs](https://www.kaggle.com/docs/api). |
| **Docker** (optional) | Only if you want to run an app in its pre-baked container instead of `streamlit run` directly. | [docker.com/get-started](https://www.docker.com/get-started/) |

Verify what you have:

```bash
python3 --version    # should print 3.12.x
git --version
quarto --version
kaggle --version      # only works after the pip install in step 3 below
```

## 2. Clone one project

Choose the project repository from the portfolio table in
[`README.md`](README.md), then clone it directly. For example:

```bash
git clone https://github.com/nhamhhung/traffic-accident-severity.git
cd traffic-accident-severity
```

To contribute through your own account, fork the selected repository first
and clone your fork. Its `docs/SETUP_AND_DEPLOYMENT.md` explains how to
enable GitHub Pages and create a separate Streamlit Community Cloud app.

Repository names use hyphens: `academic-success`, `disaster-tweets-nlp`,
`energy-demand-forecasting`, `recommendation-showcase`, and
`traffic-accident-severity`. The recommendation repository has two
sub-packages, `content_based` and `collaborative`, sharing one app.

Everything below assumes your shell is inside the cloned project repository.

## 3. Set up the environment and install Python dependencies

```bash
python3.12 -m venv .venv          # use the 3.12 interpreter specifically
source .venv/bin/activate         # Windows: .venv\Scripts\activate
pip install --upgrade pip
pip install -r requirements.txt   # installs every Python dependency this project needs,
                                   # including jupyter/ipykernel (for the notebook+report)
                                   # and the kaggle package (for data auto-download)
```

This one `pip install` is the complete Python dependency list for the
project — there's no separate install step for the notebook, model, or app;
they all draw from the same `requirements.txt` and the same venv.

## 4. Get the data

Each project's `README.md` has a "Get the data" section with the exact
`kaggle datasets download` / `kaggle competitions download` command for that
project's dataset (your `~/.kaggle/kaggle.json` token from step 1 is what
authenticates these).

You can skip this step for the test suite and the default Streamlit app:
tests use synthetic data, while each app starts quickly from a bundled sample.
To use complete Kaggle data, configure the token and set
`USE_FULL_KAGGLE_DATA=true`; see the project's README and
`docs/SETUP_AND_DEPLOYMENT.md`.

## 5. The three things you'll most likely edit

### A. Model code (`src/<package>/`)

This is the single source of truth. `config.py` (paths, schema, constants),
`data.py` (loading/splitting), `features.py` (feature engineering),
`model.py` (pipelines, training, evaluation), `interpretability.py` (SHAP) —
every notebook, script, app, and test imports from here. Nothing re-derives
logic locally, so a change here propagates everywhere automatically.

**The edit loop:**

```bash
# 1. Make your change in src/<package>/*.py

# 2. Check it against the test suite (fast, synthetic data, no download needed)
pytest tests/

# 3. Retrain, so models/model.joblib reflects your change
python scripts/train.py              # or --model <name>, --stacking, etc. — see --help
```

`models/model.joblib` is what the notebook, the app, and the report all
load — retraining it is the one step that makes your code change visible
everywhere else. If you only changed something that doesn't affect
training (e.g. an interpretability helper), you can skip the retrain.

### B. The notebook (`notebooks/01_*.ipynb`)

This is the narrative walkthrough: EDA → cleaning → feature engineering →
model comparison → the same training call `scripts/train.py` makes. It
imports from `src/<package>/` rather than redefining logic inline, so if you
changed the model code, re-running the notebook's cells is how you confirm
the story it tells still matches reality.

```bash
jupyter notebook notebooks/01_eda_and_modeling.ipynb
```

Pick your project's own venv as the kernel (Jupyter → Kernel → Change
Kernel). If you don't see it listed, register it once:

```bash
python -m ipykernel install --user --name <project-name> --display-name "<Project Name>"
```

After editing, **re-run all cells top to bottom** before saving (Kernel →
Restart & Run All) — a notebook with stale outputs from a previous version
of the code is actively misleading to the next reader.

### C. The report (`report/report.qmd`) — most important to get right

This is the polished, external-facing writeup (methodology, honest results,
limitations) — the artifact most likely to be read by someone who never
opens the code. It's written in [Quarto](https://quarto.org/docs/get-started/)
(a `.qmd` file, not a notebook), with embedded Python code cells that import
from `src/<package>/` the same way the notebook does.

**One-time setup**, in addition to Quarto (step 1) and the venv (step 3):
register a **named Jupyter kernel for this exact project**. Every
`report.qmd` pins a specific kernel name in its YAML header
(`jupyter: <project-name>`) — rendering fails with a "kernel not found"
error until a kernel by that exact name exists and points at *this*
project's venv:

```bash
python -m ipykernel install --user --name <project-name> --display-name "<Project Name>"
```

Check the `jupyter:` line near the top of `report/report.qmd` for the exact
name it expects (e.g. `academic-success`, `traffic-accident-severity`) — it
must match exactly, including hyphens.

**Anatomy of a `.qmd` file**, top to bottom:

- **YAML header** (between the `---` fences at the top) — title, author,
  output formats (`html`/`pdf`) and their options, and the `jupyter:` kernel
  name covered above. Don't touch `jupyter:` unless you've re-registered
  the kernel under a new name too.
- **Markdown prose** — plain Markdown, rendered as-is.
- **Code chunks** — fenced with ` ```{python} ` / ` ``` `, executed in order
  top to bottom by the kernel, same as a notebook cell. Common per-chunk
  options (each a `#|` comment on its own line, first in the chunk):

  ```python
  #| echo: false       # hide this chunk's source code in the output (prose-only figures/tables)
  #| output: false     # suppress this chunk's output entirely (e.g. a setup/import cell)
  #| label: fig-foo     # names the chunk, for cross-referencing with `@fig-foo`
  #| fig-cap: "..."     # caption shown under a figure this chunk produces
  ```

**Editing and re-rendering:**

```bash
# Edit report/report.qmd (prose + Python code cells), then:
quarto render report/report.qmd
```

This regenerates both `report/report.html` and `report/report.pdf` (PDF
rendering needs a LaTeX distribution — if you don't have one, Quarto will
offer to install a minimal one via `quarto install tinytex`). Re-render
after *any* change to the `.qmd` file or to the model code it depends on
(e.g. after a retrain) — a stale rendered report is worse than no report,
since nothing signals it's out of date.

Render just one format, when you don't need both (faster):

```bash
quarto render report/report.qmd --to html
quarto render report/report.qmd --to pdf
```

**Live preview while editing** (recommended over repeatedly re-running
`quarto render` by hand) — opens the rendered HTML in a browser tab and
re-renders automatically on every save:

```bash
quarto preview report/report.qmd
```

**Editor support:** the [Quarto VS Code
extension](https://marketplace.visualstudio.com/items?itemName=quarto.quarto)
(works in VS Code and Cursor) gives you syntax highlighting, inline chunk
execution, and a one-click "Render" button — install it if you're doing
more than a one-line text edit.

**Troubleshooting:**

| Symptom | Likely cause |
|---|---|
| `Jupyter engine failed ... kernel not found` | You haven't run the `ipykernel install --name <project-name>` step above, or the name doesn't match `report.qmd`'s `jupyter:` line exactly. |
| `ModuleNotFoundError` inside a code chunk | The chunk's `sys.path.insert(0, "../src")` (near the top of the file) is missing or points at the wrong relative path — `quarto render` runs with the working directory set to `report/`, not the project root. |
| Output looks stale after editing | `quarto render` sometimes caches execution results; force a clean re-run with `quarto render report/report.qmd --execute-daemon-restart`, or delete the `report/.quarto`/`_freeze` cache directory if one exists. |
| PDF render fails, HTML succeeds | Missing LaTeX — run `quarto install tinytex` once, then retry. |

## 7. Running the app and tests

```bash
pytest tests/                       # synthetic data, no download needed
streamlit run app/streamlit_app.py  # http://localhost:8501
```

See the project's own `README.md` for the Docker build command and the
app's page-by-page description.

## Quick reference

| Task | Command |
|---|---|
| Create the venv + install all Python deps | `python3.12 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt` |
| Run tests | `pytest tests/` |
| Retrain the model | `python scripts/train.py` |
| Edit/run the notebook | `jupyter notebook notebooks/01_*.ipynb` |
| Register this project's Quarto/notebook kernel | `python -m ipykernel install --user --name <project-name> --display-name "<Project Name>"` |
| Render the report | `quarto render report/report.qmd` |
| Live-preview the report | `quarto preview report/report.qmd` |
| Run the app | `streamlit run app/streamlit_app.py` |
