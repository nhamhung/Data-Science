# Setup and Deployment Manual

This guide covers a clean local installation, GitHub publication, Streamlit
Community Cloud deployment, and GitHub Pages publication for the Academic
Success report.

## 1. Prerequisites

Install the following tools:

- Git;
- Python 3.12;
- a Kaggle account; and
- optionally Docker and Quarto.

Before downloading the dataset, open the
[competition rules](https://www.kaggle.com/competitions/playground-series-s4e6/rules)
while signed into Kaggle and accept them. Generate an API token from your
Kaggle account settings. Keep that token private.

## 2. Clone and create the Python environment

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd <YOUR_REPOSITORY_DIRECTORY>/projects/academic_success

python3.12 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

Windows PowerShell activation:

```powershell
py -3.12 -m venv .venv
.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

If an existing environment was copied from another computer, do not reuse it.
Rename it and create a fresh one:

```bash
mv .venv .venv.incompatible
python3.12 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
```

## 3. Configure Kaggle and download the data

The repository deliberately excludes Kaggle's CSV and ZIP files. For local
development, install the Kaggle CLI and place your credential file at
`~/.kaggle/kaggle.json` as described by Kaggle.

```bash
python -m pip install kaggle
kaggle competitions download \
  -c playground-series-s4e6 \
  -p data/raw
unzip -o data/raw/playground-series-s4e6.zip -d data/raw
```

Confirm these files exist:

```text
data/raw/train.csv
data/raw/test.csv
data/raw/sample_submission.csv
```

Do not use `git add -f` on these files.

## 4. Run the project locally

All commands in this section run from `projects/academic_success` with the
virtual environment activated.

Run the tests:

```bash
python -m pytest -q
```

Train the default model:

```bash
python scripts/train.py
```

The trained pipeline is saved to `models/model.joblib`. A compatible default
model is already versioned for the hosted application, so retraining is only
required when the model or feature pipeline changes.

Launch Streamlit:

```bash
python -m streamlit run app/streamlit_app.py
```

Open <http://localhost:8501>. Stop the server with `Ctrl+C`.

Run the notebook:

```bash
python -m jupyter notebook notebooks/01_eda_and_modeling.ipynb
```

Generate a Kaggle submission:

```bash
python scripts/make_submission.py
```

Render the HTML report after installing Quarto:

```bash
quarto render report/report.qmd --to html
```

The output is `report/report.html` and remains ignored because GitHub Pages
renders it in automation.

## 5. Run with Docker

The image does not contain Kaggle data. Export your API token before starting
the container so it can fetch `train.csv` on first use:

```bash
export KAGGLE_API_TOKEN="<YOUR_TOKEN>"
docker build -t academic-success-app -f app/Dockerfile .
docker run --rm -p 8501:8501 \
  -e KAGGLE_API_TOKEN="$KAGGLE_API_TOKEN" \
  academic-success-app
```

Do not put the token in the Dockerfile or commit it to any file.

## 6. Check what Git will publish

From the repository root:

```bash
git status --short --ignored
git check-ignore -v projects/academic_success/data/raw/train.csv
git check-ignore -v projects/academic_success/.venv
git ls-files | sort
```

Before every push, check for accidentally staged large files:

```bash
git diff --cached --stat
find . -type f -size +50M -not -path './.git/*'
```

Expected local-only content includes `data/raw/*`, `.venv*`, cache folders,
`submission.csv`, and `.streamlit/secrets.toml`.

## 7. Create and push the GitHub repository

The local repository uses the `main` branch. Authenticate GitHub CLI, then
create a public repository and push it:

```bash
cd <YOUR_REPOSITORY_DIRECTORY>
gh auth login
gh repo create data-science-portfolio \
  --public \
  --source=. \
  --remote=origin \
  --push
```

If you create the empty repository in GitHub's web interface instead:

```bash
git remote add origin https://github.com/<USER>/<REPOSITORY>.git
git push -u origin main
```

## 8. Deploy the app to Streamlit Community Cloud

The app downloads `train.csv` directly from Kaggle on its first hosted run;
the dataset is never stored in GitHub. The owner of the Kaggle token must have
accepted the competition rules.

1. Visit [share.streamlit.io](https://share.streamlit.io/) and sign in with
   the GitHub account that owns or administers the repository.
2. Select **Create app** and choose the repository.
3. Set the branch to `main`.
4. Set the entrypoint to
   `projects/academic_success/app/streamlit_app.py`.
5. Open **Advanced settings**, choose Python 3.12, and add this secret:

   ```toml
   KAGGLE_API_TOKEN = "<YOUR_KAGGLE_API_TOKEN>"
   ```

6. Deploy the app and inspect its logs if the first boot fails.

Community Cloud finds the lean dependency list at
`projects/academic_success/app/requirements.txt`. The small trained model is
committed at `projects/academic_success/models/model.joblib`. Never commit the
secret shown above.

If the app reports that the competition file cannot be downloaded, confirm
that the token is current and its owner has accepted the competition rules.

## 9. Publish the Quarto report with GitHub Pages

The workflow at `.github/workflows/publish-academic-report.yml` downloads the
private competition data during the build, renders only HTML, and deploys that
HTML to GitHub Pages. No dataset is committed.

After creating the GitHub repository:

1. Open **Settings → Secrets and variables → Actions**.
2. Create a repository secret named `KAGGLE_API_TOKEN`.
3. Open **Settings → Pages** and select **GitHub Actions** as the source.
4. Open **Actions → Publish Academic Success report → Run workflow**.
5. After the workflow succeeds, use the URL shown in the deployment job or in
   **Settings → Pages**.

The report workflow is manual so the first repository push does not fail
before the Kaggle secret and GitHub Pages are configured. Run it again whenever
the report changes.

## 10. Updating deployments

- Streamlit Community Cloud rebuilds the app after changes are pushed to its
  configured branch.
- Run the report workflow again after changing `report.qmd`, report
  dependencies, or shared feature code.
- If the feature pipeline changes, retrain and commit the updated
  `models/model.joblib` alongside the code change.
- Roll back either deployment by reverting the responsible commit on `main`
  and pushing the revert.

## Troubleshooting

### The model cannot be loaded

The saved model was produced with scikit-learn 1.9.1. The Streamlit-specific
requirements pin that version. Recreate the environment and reinstall
dependencies if a local environment uses an incompatible version.

### Streamlit cannot find the data

Locally, download `data/raw/train.csv`. On Streamlit Community Cloud, define
`KAGGLE_API_TOKEN` in the app's secrets rather than in a tracked file.

### The report workflow cannot download data

Check the Actions secret name, token validity, and acceptance of the Kaggle
competition rules. GitHub does not expose secret values in workflow logs.

### A large file was staged accidentally

Before the first commit, unstage it without deleting the local file:

```bash
git restore --staged <PATH>
```

Then add or correct the relevant `.gitignore` rule.
