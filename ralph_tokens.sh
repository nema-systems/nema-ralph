#!/bin/bash
# Ralph Token Stats Monitor
PROJECT_DIR="${1:-$(pwd)}"
LOGS_DIR="$PROJECT_DIR/.ralph/logs"

python3 - "$LOGS_DIR" << 'EOF'
import sys, json, os, time, glob, io
from datetime import datetime

logs_dir  = sys.argv[1]
run_start = time.time()

INPUT_COST  = 15.00
CWRITE_COST = 18.75
CREAD_COST  = 1.50
OUTPUT_COST = 75.00

def cost(inp, cw, cr, out):
    return (inp * INPUT_COST + cw * CWRITE_COST + cr * CREAD_COST + out * OUTPUT_COST) / 1_000_000

def fmt_k(n):
    if n >= 1_000_000: return f"{n/1_000_000:.1f}M"
    if n >= 1_000:     return f"{n/1_000:.1f}k"
    return str(n)

def parse_logs():
    if not os.path.isdir(logs_dir):
        return None
    total = {'inp': 0, 'cw': 0, 'cr': 0, 'out': 0, 'calls': 0}
    for path in glob.glob(os.path.join(logs_dir, '*_stream.log')):
        # Only include logs created during this session
        if os.path.getctime(path) < run_start:
            continue
        try:
            with open(path) as f:
                for line in f:
                    try:
                        d = json.loads(line)
                        if d.get('type') == 'stream_event' and d['event'].get('type') == 'message_delta':
                            u = d['event'].get('usage', {})
                            total['inp']   += u.get('input_tokens', 0)
                            total['cw']    += u.get('cache_creation_input_tokens', 0)
                            total['cr']    += u.get('cache_read_input_tokens', 0)
                            total['out']   += u.get('output_tokens', 0)
                            total['calls'] += 1
                    except Exception:
                        pass
        except Exception:
            pass
    return total

while True:
    t = parse_logs()
    now = datetime.now().strftime('%H:%M:%S')

    lines = []
    lines.append("")
    lines.append("  ███╗   ██╗███████╗███╗   ███╗ █████╗ ")
    lines.append("  ████╗  ██║██╔════╝████╗ ████║██╔══██╗")
    lines.append("  ██╔██╗ ██║█████╗  ██╔████╔██║███████║")
    lines.append("  ██║╚██╗██║██╔══╝  ██║╚██╔╝██║██╔══██║")
    lines.append("  ██║ ╚████║███████╗██║ ╚═╝ ██║██║  ██║")
    lines.append("  ╚═╝  ╚═══╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝")
    lines.append("")

    if not t:
        lines.append(f"  Waiting for logs...   {now}")
    else:
        total_cost = cost(t['inp'], t['cw'], t['cr'], t['out'])
        effective  = t['inp'] + t['cw'] + t['cr']
        cache_pct  = (t['cr'] / effective * 100) if effective > 0 else 0

        live_log = os.path.join(os.path.dirname(logs_dir), 'live.log')
        if os.path.exists(live_log) and time.time() - os.path.getmtime(live_log) < 5:
            status = "● RUNNING"
        else:
            status = "○ idle"

        lines.append(f"  Token Usage  {status:12}          {now}")
        lines.append(f"  {'─'*40}")
        lines.append(f"  Input (raw)    {fmt_k(t['inp']):>10}     ${t['inp']  * INPUT_COST  / 1_000_000:>9.4f}")
        lines.append(f"  Cache write    {fmt_k(t['cw']):>10}     ${t['cw']   * CWRITE_COST / 1_000_000:>9.4f}")
        lines.append(f"  Cache read     {fmt_k(t['cr']):>10}     ${t['cr']   * CREAD_COST  / 1_000_000:>9.4f}")
        lines.append(f"  Output         {fmt_k(t['out']):>10}     ${t['out']  * OUTPUT_COST / 1_000_000:>9.4f}")
        lines.append(f"  {'─'*40}")
        lines.append(f"  TOTAL          {'':>10}     ${total_cost:>9.4f}")
        lines.append("")
        elapsed = int(time.time() - run_start)
        h, m, s = elapsed // 3600, (elapsed % 3600) // 60, elapsed % 60

        lines.append(f"  {cache_pct:.0f}% cache hit rate   {t['calls']} API calls")
        lines.append(f"  Elapsed: {h:02d}:{m:02d}:{s:02d}")

    # Single atomic write: home + frame (no separate clear step)
    sys.stdout.write('\033[H' + '\n'.join(lines) + '\n')
    sys.stdout.flush()

    time.sleep(1)
EOF
