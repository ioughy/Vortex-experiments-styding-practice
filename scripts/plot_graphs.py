import pandas as pd
import matplotlib.pyplot as plt
import os

def get_metrics(df, test_name):
    row = df[df['test_name'] == test_name]
    if not row.empty:
        return row.iloc[0]['ipc'], row.iloc[0]['cycles']
    return None, None

def main():
    if not os.path.exists("results/csv/results.csv"):
        print("Ошибка: файл results.csv не найден. Сначала запустите parse_logs.py")
        return

    df = pd.read_csv("results/csv/results.csv")
    
    os.makedirs("results/plots", exist_ok=True)
    
    cores = [1, 2, 4, 8, 16, 32, 60]
    
    def calc_speedup(ips_list):
        base = ips_list[0]
        if base and base > 0:
            return [ip / base if ip else None for ip in ips_list]
        return [None] * len(ips_list)

    # --- STRONG SCALING (4 графика) ---
    strong_configs = [
        {"app": "sgemm", "size": "64",  "label": "sgemm (64 x 64 elements)",  "marker": "^", "color": "g"},
        {"app": "sgemm", "size": "128", "label": "sgemm (128 x 128 elements)", "marker": "D", "color": "m"},
        {"app": "sgemm", "size": "256", "label": "sgemm (256 x 256 elements)", "marker": "v", "color": "orange"},
        {"app": "sgemm", "size": "512", "label": "sgemm (512 x 512 elements)", "marker": "o", "color": "yellow"}
]
    
    for conf in strong_configs:
        ips = []
        for c in cores:
            name = f"{conf['app']}_strong_{c}c_{conf['size']}"
            ipc, _ = get_metrics(df, name)
            ips.append(ipc)
            
        speedups = calc_speedup(ips)
        
        plt.figure(figsize=(8, 6))
        plt.plot(cores, speedups, marker=conf['marker'], color=conf['color'], label=conf['label'])
        plt.plot(cores, cores, linestyle='--', color='gray', label='Идеальное линейное ускорение')
        plt.xlabel("Количество ядер (Cores)")
        plt.ylabel("Ускорение по IPC (Speedup)")
        plt.xticks(cores)
        plt.legend()
        plt.grid(True)
        plt.savefig(f"results/plots/strong_{conf['app']}_{conf['size']}.pdf")
        plt.close()
        print(f"Сохранён график: results/plots/strong_{conf['app']}_{conf['size']}.pdf")

if __name__ == "__main__":
    main()