# COVID-19 MATLAB Data Visualizer (JHU CRC)

This project processes and visualizes COVID‑19 pandemic data from the Johns Hopkins University Coronavirus Resource Center.

## Data format

The `.mat` file must contain a single variable:

- `covid_data` – cell array
  - Row 1: headers  
    - Column 1: `"Country"`  
    - Column 2: `"State"`  
    - Columns 3..end: date strings starting from `"1/22/20"`  
  - Each data cell (row ≥ 2, col ≥ 3): `1x2` double vector `[cumulativeCases, cumulativeDeaths]`.

The end date is not hard‑coded; the program detects all date columns dynamically.

## Object model

The program converts the raw data into a hierarchy of objects:

- `Global` (root)
  - **Countries** (`RegionNode` objects)
    - **States / provinces / territories** (`RegionNode` objects)

All three levels use the same class (`covid.RegionNode`).

## GUI features

The `CovidVisualizerApp` provides:

- A single plot area:
  - X‑axis: dates
  - Y‑axis: cases/deaths
  - If plotting **both**:
    - Cases on left y‑axis
    - Deaths on right y‑axis
  - Title shows selected region + options (metric, cumulative/daily, moving average window).

- **Country list box**
  - First item: `"Global"` (computed by summing all countries)
  - Other items: all countries in the dataset.

- **State list box**
  - First item: `"All"`
  - For countries without states/regions, `"All"` is the only option (shows the country itself).
  - For countries with states/territories, the list shows all states. `"All"` aggregates them.

- **Moving average selector**
  - Spinner: integer from 1 to 15.
  - `1` means no averaging.
  - Moving average uses past N−1 days plus current day (trailing window).

- **What to plot**
  - Radio buttons: `Cases`, `Deaths`, `Both`.

- **Cumulative vs daily**
  - Radio buttons: `Cumulative`, `Daily`.
  - Database is cumulative; daily series is computed.
  - Daily values are clamped so that **no negative values are ever plotted**.

## How to run

1. Place your `covid_data.mat` into the `data/` folder.
2. In MATLAB:
   ```matlab
   cd path/to/covid19-matlab-visualizer
   addpath(genpath(pwd));
   app = CovidVisualizerApp;

