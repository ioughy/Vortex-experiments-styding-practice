#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$BASE_DIR/results/raw_logs"
mkdir -p "$LOG_DIR"

# В случае, если папка с текущим репозиторием в вашей системе расположена не рядом с папкой vortex, 
# передайте переменную VORTEX_BUILD при запуске вручную.
VORTEX_BUILD="${VORTEX_BUILD:-$BASE_DIR/../../vortex/build}"
cd "$VORTEX_BUILD" || { echo "Error: Vortex build not found at $VORTEX_BUILD"; exit 1; }

echo "Starting Vortex Experiments..."
echo "Vortex build dir: $(pwd)"
echo "Logs will be saved to: $LOG_DIR"
sleep 2

run_test() {
    local test_name=$1
    local clusters=$2
    local cores=$3
    local app=$4
    local args=$5
    
    echo "Running: $test_name... (clusters=$clusters, cores=$cores)"
    ./ci/blackbox.sh --clusters="$clusters" --cores="$cores" --warps=32 --threads=32 --app="$app" --args="$args" > "$LOG_DIR/${test_name}.log" 2>&1
}

# -------------------------------------
# СИЛЬНОЕ МАСШТАБИРОВАНИЕ: sgemm (64 x 64)
# -------------------------------------
run_test "sgemm_strong_1c_64" 1 1 "sgemm" "-n64"
run_test "sgemm_strong_2c_64" 1 2 "sgemm" "-n64"
run_test "sgemm_strong_4c_64" 1 4 "sgemm" "-n64"
run_test "sgemm_strong_8c_64" 2 4 "sgemm" "-n64"
run_test "sgemm_strong_16c_64" 4 4 "sgemm" "-n64"
run_test "sgemm_strong_32c_64" 8 4 "sgemm" "-n64"
run_test "sgemm_strong_60c_64" 15 4 "sgemm" "-n64"

# -------------------------------------
# СИЛЬНОЕ МАСШТАБИРОВАНИЕ: sgemm (128 x 128)
# -------------------------------------
run_test "sgemm_strong_1c_128" 1 1 "sgemm" "-n128"
run_test "sgemm_strong_2c_128" 1 2 "sgemm" "-n128"
run_test "sgemm_strong_4c_128" 1 4 "sgemm" "-n128"
run_test "sgemm_strong_8c_128" 2 4 "sgemm" "-n128"
run_test "sgemm_strong_16c_128" 4 4 "sgemm" "-n128"
run_test "sgemm_strong_32c_128" 8 4 "sgemm" "-n128"
run_test "sgemm_strong_60c_128" 15 4 "sgemm" "-n128"


# -------------------------------------
# СИЛЬНОЕ МАСШТАБИРОВАНИЕ: sgemm (256 x 256)
# -------------------------------------
run_test "sgemm_strong_1c_256" 1 1 "sgemm" "-n256"
run_test "sgemm_strong_2c_256" 1 2 "sgemm" "-n256"
run_test "sgemm_strong_4c_256" 1 4 "sgemm" "-n256"
run_test "sgemm_strong_8c_256" 2 4 "sgemm" "-n256"
run_test "sgemm_strong_16c_256" 4 4  "sgemm" "-n256"
run_test "sgemm_strong_32c_256" 8 4  "sgemm" "-n256"
run_test "sgemm_strong_60c_256" 15 4 "sgemm" "-n256"

# -------------------------------------
# СИЛЬНОЕ МАСШТАБИРОВАНИЕ: sgemm (512 x 512)
# -------------------------------------
run_test "sgemm_strong_1c_512" 1 1 "sgemm" "-n512"
run_test "sgemm_strong_2c_512" 1 2 "sgemm" "-n512"
run_test "sgemm_strong_4c_512" 1 4 "sgemm" "-n512"
run_test "sgemm_strong_8c_512" 2 4 "sgemm" "-n512"
run_test "sgemm_strong_16c_512" 4 4  "sgemm" "-n512"
run_test "sgemm_strong_32c_512" 8 4  "sgemm" "-n512"
run_test "sgemm_strong_60c_512" 15 4 "sgemm" "-n512"

echo "All automated experiments finished! Check results/raw_logs/"