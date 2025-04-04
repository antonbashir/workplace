import sys
import psutil
from tabulate import tabulate


def status(filter):
    headers = ["Name", "Time", "User", "CPU", "Memory", "Ports", "Files"]
    table_data = []

    for proc in psutil.process_iter(attrs=["name", "cpu_times", "username", "cpu_percent", "memory_info"]):
        try:
            name = proc.info["name"]
            filtered = False
            if len(filter) > 0:
                for process in filter:
                    if name != process:
                        filtered = True
                        break
            if filtered:
                continue
            time = sum(proc.info["cpu_times"]) if proc.info["cpu_times"] else "N/A"
            user = proc.info["username"]
            cpu = proc.info["cpu_percent"]
            memory = proc.info["memory_info"].rss / (1024 * 1024)
            connections = proc.net_connections(kind="inet") if hasattr(proc, "connections") else []
            open_ports = [conn.laddr.port for conn in connections if conn.status == "LISTEN"]
            open_files = []
            if hasattr(proc, "open_files"):
                for file in proc.open_files():
                    try:
                        open_files.append(file.path)
                    except psutil.AccessDenied:
                        open_files.append(f"{file.path} (access denied)")
                    except psutil.NoSuchProcess:
                        open_files.append(f"{file.path} (process exited)")
                    except Exception as e:
                        open_files.append(f"{file.path} ({str(e)})")
            files_str = "\n".join(open_files[:5]) + ("..." if len(open_files) > 5 else "")
            if open_files:
                files_str = files_str.replace("\n", "\n" + " " * 50)
            table_data.append(
                [
                    name,
                    f"{time:.2f}s" if isinstance(time, (int, float)) else time,
                    user,
                    f"{cpu}%",
                    f"{memory:.2f} MB",
                    ", ".join(map(str, open_ports)) if open_ports else "N/A",
                    files_str if open_files else "N/A",
                ]
            )
        except:
            continue
    if len(table_data) == 0:
        table_data = [[]]
    print(tabulate(table_data, headers=headers, tablefmt="grid", maxcolwidths=[30, 10, 15, 8, 12, 20, 50]))


status(sys.argv[1:])
