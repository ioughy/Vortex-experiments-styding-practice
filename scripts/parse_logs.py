import os
import re
import csv
import glob

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
BASE_DIR = os.path.dirname(SCRIPT_DIR)
LOG_DIR = os.path.join(BASE_DIR, "results", "raw_logs")
CSV_DIR = os.path.join(BASE_DIR, "results", "csv")
OUTPUT_CSV = os.path.join(CSV_DIR, "results.csv")

def parse_log(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    
    instrs_match = re.search(r'instrs[=:]\s*(\d+)', content)
    cycles_match = re.search(r'cycles[=:]\s*(\d+)', content)
    ipc_match = re.search(r'IPC[=:]\s*([\d\.]+)', content)
    
    ipc = None
    cycles = None
    
    if ipc_match:
        ipc = float(ipc_match.group(1))
    elif instrs_match and cycles_match:
        instrs = float(instrs_match.group(1))
        cycles_val = float(cycles_match.group(1))
        if cycles_val > 0:
            ipc = instrs / cycles_val
            
    if cycles_match:
        cycles = int(cycles_match.group(1))
        
    return ipc, cycles

def main():
    if not os.path.exists(LOG_DIR):
        print(f"Ошибка: Директория {LOG_DIR} не найдена.")
        return

    os.makedirs(CSV_DIR, exist_ok=True)

    log_files = glob.glob(os.path.join(LOG_DIR, "*.log"))
    results = []
    
    for log_file in log_files:
        filename = os.path.basename(log_file)
        test_name = filename.replace(".log", "")
        
        ipc, cycles = parse_log(log_file)
        if ipc is not None:
            results.append({
                "test_name": test_name, 
                "ipc": ipc,
                "cycles": cycles
            })
        else:
            print(f"Предупреждение: Не удалось извлечь IPC из {filename}")
            
    results.sort(key=lambda x: x["test_name"])
    
    with open(OUTPUT_CSV, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=["test_name", "ipc", "cycles"])
        writer.writeheader()
        for row in results:
            writer.writerow(row)
            
    print(f"Успешно обработано {len(results)} логов. Результат сохранён в {OUTPUT_CSV}")

if __name__ == "__main__":
    main()