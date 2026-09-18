import os
import sys

import matplotlib

matplotlib.use("Agg")

SCRIPTS_DIR = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "..", "scripts")
)
sys.path.insert(0, SCRIPTS_DIR)