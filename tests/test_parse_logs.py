import parse_logs


def _write_log(tmp_path, content):
    log_file = tmp_path / "test.log"
    log_file.write_text(content)
    return str(log_file)


def test_parse_log_with_perf(tmp_path):
    """При perf=1 берётся последний IPC — системный, а не core0."""
    content = (
        "PERF: core0: instrs=743808, cycles=842291, IPC=0.883\n"
        "PERF: core1: instrs=743808, cycles=842291, IPC=0.883\n"
        "PERF: instrs=47603712, cycles=842291, IPC=56.517\n"
    )
    ipc, cycles = parse_logs.parse_log(_write_log(tmp_path, content))
    assert ipc == 56.517
    assert cycles == 842291


def test_parse_log_without_perf(tmp_path):
    content = "instrs=1000 cycles=500 IPC=2.0\n"
    ipc, cycles = parse_logs.parse_log(_write_log(tmp_path, content))
    assert ipc == 2.0
    assert cycles == 500


def test_parse_log_compute_ipc_from_instrs_and_cycles(tmp_path):
    """Если IPC в логе нет — считаем сами."""
    content = "instrs=1000 cycles=500\n"
    ipc, cycles = parse_logs.parse_log(_write_log(tmp_path, content))
    assert ipc == 2.0
    assert cycles == 500


def test_parse_log_no_matches(tmp_path):
    content = "nothing useful here\n"
    ipc, cycles = parse_logs.parse_log(_write_log(tmp_path, content))
    assert ipc is None
    assert cycles is None


def test_parse_log_cycles_only(tmp_path):
    content = "cycles=100\n"
    ipc, cycles = parse_logs.parse_log(_write_log(tmp_path, content))
    assert ipc is None
    assert cycles == 100


def test_parse_log_zero_cycles(tmp_path):
    """Не должно быть деления на ноль."""
    content = "instrs=1000 cycles=0\n"
    ipc, cycles = parse_logs.parse_log(_write_log(tmp_path, content))
    assert ipc is None
    assert cycles == 0


def test_parse_log_takes_last_cycles(tmp_path):
    content = (
        "PERF: core0: cycles=1 IPC=1.0\n"
        "PERF: instrs=100 cycles=500 IPC=2.0\n"
    )
    ipc, cycles = parse_logs.parse_log(_write_log(tmp_path, content))
    assert ipc == 2.0
    assert cycles == 500