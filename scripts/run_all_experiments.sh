#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$BASE_DIR/results/raw_logs"
mkdir -p "$LOG_DIR"

# В случае, если папка с текущим репозиторием в вашей системе расположена не рядом с папкой vortex, 
# передайте переменную VORTEX_BUILD при запуске вручную.
VORTEX_BUILD="${VORTEX_BUILD:-$BASE_DIR/../vortex/build}"
cd "$VORTEX_BUILD" || { echo "Error: Vortex build not found at $VORTEX_BUILD"; exit 1; }

echo "Starting Vortex Experiments..."
echo "Vortex build dir: $(pwd)"
echo "Logs will be saved to: $LOG_DIR"
sleep 2

run_test() {
    local test_name=$1
    local clusters=$2
    local cores=$3
    local cache_flags=$4
    local app=$5
    local args=$6
    
    echo "Running: $test_name... (clusters=$clusters, cores=$cores)"
    ./ci/blackbox.sh --clusters="$clusters" --cores="$cores" $cache_flags --app="$app" --args="$args" > "$LOG_DIR/${test_name}.log" 2>&1
}

# -------------------------------------
# СИЛЬНОЕ МАСШТАБИРОВАНИЕ: vecadd (16384 элемента в векторе)
# -------------------------------------
run_test "vecadd_strong_1c_16384" 1 1 "" "vecadd" "-n16384"
run_test "vecadd_strong_2c_16384" 1 2 "" "vecadd" "-n16384"
run_test "vecadd_strong_4c_16384" 1 4 "" "vecadd" "-n16384"
run_test "vecadd_strong_8c_16384" 2 4 "" "vecadd" "-n16384"
run_test "vecadd_strong_16c_16384" 4 4 "" "vecadd" "-n16384"
run_test "vecadd_strong_32c_16384" 8 4 "" "vecadd" "-n16384"
run_test "vecadd_strong_64c_16384" 16 4 "" "vecadd" "-n16384"

# -------------------------------------
# СИЛЬНОЕ МАСШТАБИРОВАНИЕ: vecadd (32768 элементов в векторе)
# -------------------------------------
run_test "vecadd_strong_1c_32768" 1 1 "" "vecadd" "-n32768"
run_test "vecadd_strong_2c_32768" 1 2 "" "vecadd" "-n32768"
run_test "vecadd_strong_4c_32768" 1 4 "" "vecadd" "-n32768"
run_test "vecadd_strong_8c_32768" 2 4 "" "vecadd" "-n32768"
run_test "vecadd_strong_16c_32768" 4 4 "" "vecadd" "-n32768"
run_test "vecadd_strong_32c_32768" 8 4 "" "vecadd" "-n32768"
run_test "vecadd_strong_64c_32768" 16 4 "" "vecadd" "-n32768"

# -------------------------------------
# СИЛЬНОЕ МАСШТАБИРОВАНИЕ: vecadd (65536 элементов в векторе)
# -------------------------------------
run_test "vecadd_strong_1c_65536" 1 1 "" "vecadd" "-n65536"
run_test "vecadd_strong_2c_65536" 1 2 "" "vecadd" "-n65536"
run_test "vecadd_strong_4c_65536" 1 4 "" "vecadd" "-n65536"
run_test "vecadd_strong_8c_65536" 2 4 "" "vecadd" "-n65536"
run_test "vecadd_strong_16c_65536" 4 4 "" "vecadd" "-n65536"
run_test "vecadd_strong_32c_65536" 8 4 "" "vecadd" "-n65536"
run_test "vecadd_strong_64c_65536" 16 4 "" "vecadd" "-n65536"

# -------------------------------------
# СИЛЬНОЕ МАСШТАБИРОВАНИЕ: sgemm (128 x 128)
# -------------------------------------
run_test "sgemm_strong_1c_128" 1 1 "" "sgemm" "-n128"
run_test "sgemm_strong_2c_128" 1 2 "" "sgemm" "-n128"
run_test "sgemm_strong_4c_128" 1 4 "" "sgemm" "-n128"
run_test "sgemm_strong_8c_128" 2 4 "" "sgemm" "-n128"
run_test "sgemm_strong_16c_128" 4 4 "" "sgemm" "-n128"
run_test "sgemm_strong_32c_128" 8 4 "" "sgemm" "-n128"
run_test "sgemm_strong_64c_128" 16 4 "" "sgemm" "-n128"

# -------------------------------------
# СИЛЬНОЕ МАСШТАБИРОВАНИЕ: sgemm (256 x 256)
# -------------------------------------
run_test "sgemm_strong_1c_256" 1 1 "" "sgemm" "-n256"
run_test "sgemm_strong_2c_256" 1 2 "" "sgemm" "-n256"
run_test "sgemm_strong_4c_256" 1 4 "" "sgemm" "-n256"
run_test "sgemm_strong_8c_256" 2 4 "" "sgemm" "-n256"
run_test "sgemm_strong_16c_256" 4 4 "" "sgemm" "-n256"
run_test "sgemm_strong_32c_256" 8 4 "" "sgemm" "-n256"
run_test "sgemm_strong_64c_256" 16 4 "" "sgemm" "-n256"

# -------------------------------------
# СИЛЬНОЕ МАСШТАБИРОВАНИЕ: sgemm (512 x 512)
# -------------------------------------
run_test "sgemm_strong_1c_512" 1 1 "" "sgemm" "-n512"
run_test "sgemm_strong_2c_512" 1 2 "" "sgemm" "-n512"
run_test "sgemm_strong_4c_512" 1 4 "" "sgemm" "-n512"
run_test "sgemm_strong_8c_512" 2 4 "" "sgemm" "-n512"
run_test "sgemm_strong_16c_512" 4 4 "" "sgemm" "-n512"
run_test "sgemm_strong_32c_512" 8 4 "" "sgemm" "-n512"
run_test "sgemm_strong_64c_512" 16 4 "" "sgemm" "-n512"

echo "All automated experiments finished! Check results/raw_logs/"