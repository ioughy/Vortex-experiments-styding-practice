import glob
import os
import subprocess

SCRIPTS_DIR = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "..", "scripts")
)


def test_shell_scripts_syntax():
    """bash -n для каждого .sh файла в scripts/."""
    scripts = glob.glob(os.path.join(SCRIPTS_DIR, "*.sh"))
    assert scripts, "Не найдено ни одного .sh скрипта в scripts/"

    for script in scripts:
        result = subprocess.run(
            ["bash", "-n", script],
            capture_output=True,
            check=False,
        )
        assert result.returncode == 0, (
            f"Синтаксическая ошибка в {script}:\n"
            f"{result.stderr.decode()}"
        )


def test_run_all_experiments_exists():
    assert os.path.isfile(
        os.path.join(SCRIPTS_DIR, "run_all_experiments.sh")
    )