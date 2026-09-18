import pandas as pd
import plot_graphs


def test_get_metrics_found():
    df = pd.DataFrame(
        {
            "test_name": ["sgemm_strong_1c_64", "sgemm_strong_2c_64"],
            "ipc": [0.5, 0.9],
            "cycles": [1000, 600],
        }
    )
    ipc, cycles = plot_graphs.get_metrics(df, "sgemm_strong_2c_64")
    assert ipc == 0.9
    assert cycles == 600


def test_get_metrics_not_found():
    df = pd.DataFrame(
        {
            "test_name": ["sgemm_strong_1c_64"],
            "ipc": [0.5],
            "cycles": [1000],
        }
    )
    ipc, cycles = plot_graphs.get_metrics(df, "missing")
    assert ipc is None
    assert cycles is None


def test_get_metrics_empty_df():
    df = pd.DataFrame(columns=["test_name", "ipc", "cycles"])
    ipc, cycles = plot_graphs.get_metrics(df, "anything")
    assert ipc is None
    assert cycles is None