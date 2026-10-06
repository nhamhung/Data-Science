# Data Science Portfolio

Five worked, end-to-end data science projects, each built around a real
public dataset/competition and designed for people who've completed the
relevant Kaggle Learn microcourses — one project per major skill area
(tabular ML, NLP, time-series forecasting, recommendation, real-world
traffic safety). The recommendation project itself covers both major
techniques — content-based and collaborative filtering — built and
compared head to head in one place.

Each project is fully self-contained: its own virtual environment, its own
notebook(s), Streamlit app, Quarto research writeup, and a script proving
the model works end-to-end, sharing nothing with the others except this
top-level structure.

## Projects

| Project | Problem | Report | Streamlit |
|---|---|---|---|
| [Academic Success](https://github.com/nhamhhung/academic-success) | Predict student Dropout/Enrolled/Graduate outcomes (tabular classification) — Kaggle Playground Series S4E6 | [Report](https://nhamhhung.github.io/academic-success/) | [App](https://academic-success.streamlit.app) |
| [Disaster Tweets NLP](https://github.com/nhamhhung/disaster-tweets-nlp) | Classify whether a tweet describes a real disaster (NLP / text classification) | [Report](https://nhamhhung.github.io/disaster-tweets-nlp/) | [App](https://disaster-tweets-nlp.streamlit.app) |
| [Energy Demand Forecasting](https://github.com/nhamhhung/energy-demand-forecasting) | Forecast hourly electricity demand, including recursive multi-step forecasting | [Report](https://nhamhhung.github.io/energy-demand-forecasting/) | [App](https://energy-demand-forecasting.streamlit.app) |
| [Recommendation Showcase](https://github.com/nhamhhung/recommendation-showcase) | Compare content-based and collaborative-filtering music recommendations | [Report](https://nhamhhung.github.io/recommendation-showcase/) | [App](https://recommendation-showcase.streamlit.app) |
| [Traffic Accident Severity](https://github.com/nhamhhung/traffic-accident-severity) | Predict severe vs. non-severe accidents from Addis Ababa police records | [Report](https://nhamhhung.github.io/traffic-accident-severity/) | [App](https://traffic-accident-severity.streamlit.app) |

## Working on a project

See [`DEVELOPER_GUIDE.md`](DEVELOPER_GUIDE.md) for how to clone any one of
the five independent repositories and edit its model code, notebook, or report.

Each repository has its own `README.md` with full setup and fork-deployment
instructions. In general:

```bash
git clone https://github.com/nhamhhung/<project-name>.git
cd <project-name>
python3.12 -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

Then follow that project's README for how to get its data, run its
notebook(s), train its model(s), run its app, and render its report.

## Repository layout

Each project is deployed from a separate GitHub repository. A local portfolio
workspace may place their checkouts under `projects/`, but they do not share
Git history, dependencies, CI, GitHub Pages, or Streamlit configuration.

## Replicate a project

The repository includes a helper that copies any compatible project to the
`TranNguyenVu-code` account without importing the source Git history, then
enables and verifies its GitHub Pages workflow:

```bash
scripts/replicate_repo.sh nhamhung/energy-demand-forecasting
```

The first run creates a public repository and one fresh import commit. Use
`--update` on later runs to publish a new snapshot commit without importing
the source repository's history. Run the script with `--help` for all options.
