# System Info Scripts

Enhanced system information display scripts for Linux (specifically tested on Linux Mint).

## Scripts

### 1. `sysinfo.sh` - Comprehensive System Overview
A detailed, beautifully formatted system information display with:

**Features:**
- **System Information**: Hostname, uptime, load averages, OS details, kernel info
- **Hardware Information**: CPU details, memory usage with status indicators, disk usage, GPU information, CPU temperature
- **Network Information**: Active network interfaces with IPs, external IP detection
- **Development Environment**: Python (venv), PyTorch, CUDA, Node.js, npm, Docker status
- **Git Integration**: Current branch, status, and remote information
- **System Health**: Disk usage warnings, load warnings, memory warnings, service status
- **Visual Indicators**: ✓ (good), ⚠ (warning), ✗ (error) status symbols
- **Color Coding**: Green for good, yellow for warnings, red for errors

**Usage:**
```bash
./sysinfo.sh
# or if symlinked to ~/.local/bin:
sysinfo
```

### 2. `sysinfo-simple.sh` - Compact One-liner Version
A compact, horizontally-organized version of the original command:

**Features:**
- All essential information in a compact format
- Two-column layout for efficient space usage
- Maintains color coding and visual appeal
- Faster execution for quick checks

**Usage:**
```bash
./sysinfo-simple.sh
# or if symlinked to ~/.local/bin:
sysinfo-simple
```

## Installation

1. **Make scripts executable:**
   ```bash
   chmod +x sysinfo.sh sysinfo-simple.sh
   ```

2. **Create system-wide shortcuts:**
   ```bash
   mkdir -p ~/.local/bin
   ln -sf $(pwd)/sysinfo.sh ~/.local/bin/sysinfo
   ln -sf $(pwd)/sysinfo-simple.sh ~/.local/bin/sysinfo-simple
   ```

3. **Ensure ~/.local/bin is in PATH** (add to ~/.bashrc if not present):
   ```bash
   export PATH="$HOME/.local/bin:$PATH"
   ```

## Customization

### Python Environment Path
Update the Python path in both scripts if your virtual environment is located elsewhere:
```bash
py=/your/custom/path/to/python
```

### Color Customization
Colors are defined at the top of each script:
- `R` - Red
- `G` - Green  
- `Y` - Yellow
- `Bc` - Blue
- `M` - Magenta
- `C` - Cyan
- `W` - White

### Adding Custom Sections
To add custom information sections to `sysinfo.sh`, create a new function following the pattern:

```bash
get_custom_info() {
    print_section "Custom Section"
    print_item "Label" "Value" "status" "$COLOR"
}
```

Then call it from the `main()` function.

## Dependencies

**Required:**
- `bash` (version 4.0+)
- `tput` (for terminal colors)
- Standard Unix utilities: `free`, `df`, `uptime`, `hostname`

**Optional but recommended:**
- `lscpu` - for detailed CPU information
- `nvidia-smi` - for NVIDIA GPU information
- `sensors` - for temperature monitoring (install `lm-sensors`)
- `git` - for repository information
- `docker` - for Docker status
- `systemctl` - for service status

## Sample Output

### Comprehensive Version (`sysinfo.sh`)
```
╔══════════════════════════════════════════════════════════════════════╗
║ SYSTEM OVERVIEW - 2025-09-25 18:53:32                                ║
╚══════════════════════════════════════════════════════════════════════╝

▶ System Information
──────────────────────────────────────────────────
  Hostname:          cloudwerxdev-H18-mint
  Current Time:      2025-09-25 18:53:32 EDT
  Uptime:            up 1 day, 5 hours, 1 minute
  Load Average:      4.59, 2.62, 2.63
  OS:                Linux Mint 22.2
  Kernel:            6.8.0-83-generic
  Architecture:      x86_64

▶ Hardware Information
──────────────────────────────────────────────────
  CPU:               Intel(R) Core(TM) i9-14900HX
  Cores/Threads:     32/2
  Memory:            22Gi/62Gi (35.4%) ✓
  Root Disk:         826G/921G (95% used)
  GPU:               NVIDIA GeForce RTX 4090 Laptop GPU
  GPU Memory:        8826/ 16376 MB
  CPU Temp:          +64.0°C ✓
...
```

### Simple Version (`sysinfo-simple.sh`)
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 SYSTEM INFO - 2025-09-25 18:54:10 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Host     : cloudwerxdev-H18-mint | Uptime   : up 1 day, 5 hours, 2 minutes
User     : cloudwerxlab@cloudwerxdev-H18-mint | Shell    : bash
Load     : 2.92, 2.42, 2.56 | Memory   : 22Gi/62Gi (35.5%)
Disk     : 826G/921G (95%) | Python   : 3.10.18
PyTorch  : 2.6.0 | CUDA     : 12.4
Node.js  : v22.19.0 | npm      : 11.5.2
GPU      : NVIDIA GeForce RTX 4090 Laptop GPU ( 8826/ 16376 MB)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Troubleshooting

**Colors not displaying:**
- Ensure terminal supports colors
- Check `TERM` environment variable
- Scripts fallback to escape codes if `tput` unavailable

**Missing information:**
- Install optional dependencies for full functionality
- Check file permissions and command availability

**Performance issues:**
- Network timeout set to 3 seconds for external IP
- Consider commenting out slow sections if needed

**Git remote not showing:**
- This is normal if no remote is configured
- Add a remote: `git remote add origin <url>`

## Performance Notes

The comprehensive script (`sysinfo.sh`) typically runs in under 2 seconds, with most time spent on:
1. External IP lookup (3-second timeout)
2. Temperature sensor reading
3. GPU queries

The simple script (`sysinfo-simple.sh`) runs much faster, typically under 0.5 seconds.

## Author

**CLOUDWERX LAB**
- Website: http://cloudwerx.dev
- Email: mail@cloudwerx.dev
- Motto: "Digital Food for the Analog Soul"

## License

Free to use and modify for personal and commercial projects.