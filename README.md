# Data Science Portfolio

An end-to-end data science portfolio project built from a Kaggle competition.
It includes reusable model code, tests, a notebook, a Streamlit application,
and a Quarto research report.

## Included project

| Project | Problem | Deliverables |
|---|---|---|
| [Academic Success](projects/academic_success/README.md) | Predict Dropout, Enrolled, or Graduate outcomes | Notebook, trained model, Streamlit app, Quarto report, submission script |

## Quick start

Python 3.12 is recommended.

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd <YOUR_REPOSITORY_DIRECTORY>/projects/academic_success

python3.12 -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

Download the competition files after accepting the
[Kaggle competition rules](https://www.kaggle.com/competitions/playground-series-s4e6/rules):

```bash
pip install kaggle
kaggle competitions download -c playground-series-s4e6 -p data/raw
unzip -o data/raw/playground-series-s4e6.zip -d data/raw
```

Launch the application:

```bash
python -m streamlit run app/streamlit_app.py
```

Open <http://localhost:8501>.

## Repository policy

Raw Kaggle data, virtual environments, caches, generated submissions, local
secrets, and report build output are excluded from Git. The small trained
`projects/academic_success/models/model.joblib` artifact is intentionally
included because the hosted Streamlit application needs it for inference.

Never commit a Kaggle token or `.streamlit/secrets.toml` file.

## Complete manual

See [Setup and Deployment](docs/SETUP_AND_DEPLOYMENT.md) for:

- macOS, Linux, and Windows setup;
- downloading data and training the model;
- running the notebook, tests, Streamlit app, and Docker image;
- publishing the repository to GitHub;
- deploying the app to Streamlit Community Cloud; and
- publishing the Quarto report with GitHub Pages.

## Project structure

```text
projects/academic_success/
├── app/                    # Streamlit application
├── data/                   # local Kaggle data (ignored)
├── models/model.joblib     # deployable trained model
├── notebooks/              # exploratory analysis and modeling
├── report/                 # Quarto research report
├── scripts/                # training and submission commands
├── src/academic_success/   # shared data/features/model package
└── tests/                  # automated tests
```
