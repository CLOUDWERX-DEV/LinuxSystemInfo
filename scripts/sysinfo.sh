#!/bin/bash

# Enhanced System Information Script
# Author: CLOUDWERX LAB
# Purpose: Comprehensive system overview with beautiful formatting

set +o histexpand

# Color and formatting setup
if command -v tput >/dev/null 2>&1 && [ -t 1 ]; then
    B=$(tput bold)
    R=$(tput setaf 1)      # Red
    G=$(tput setaf 2)      # Green  
    Y=$(tput setaf 3)      # Yellow
    Bc=$(tput setaf 4)     # Blue
    M=$(tput setaf 5)      # Magenta
    C=$(tput setaf 6)      # Cyan
    W=$(tput setaf 7)      # White
    Z=$(tput sgr0)         # Reset
    DIM=$(tput dim)
else
    B='\033[1m'
    R='\033[31m'
    G='\033[32m'
    Y='\033[33m'
    Bc='\033[34m'
    M='\033[35m'
    C='\033[36m'
    W='\033[37m'
    Z='\033[0m'
    DIM='\033[2m'
fi

# Unicode characters for better visual appeal
CHECK="✓"
CROSS="✗"
WARN="⚠"
ARROW="→"
DOT="•"

# Helper functions
print_header() {
    local title="$1"
    local width=70
    local line=$(printf "═%.0s" $(seq 1 $width))
    printf "\n${Bc}╔${line}╗\n"
    printf "║${B}${W} %-$((width-2))s ${Z}${Bc}║\n" "$title"
    printf "╚${line}╝${Z}\n"
}

print_section() {
    local title="$1"
    printf "\n${B}${C}▶ %s${Z}\n" "$title"
    printf "${DIM}$( printf "─%.0s" $(seq 1 50))${Z}\n"
}

print_item() {
    local label="$1"
    local value="$2"
    local status="$3"
    local color="$4"
    
    if [ -n "$color" ]; then
        printf "  ${DIM}%-18s${Z} ${color}%s${Z}" "$label:" "$value"
    else
        printf "  ${DIM}%-18s${Z} %s" "$label:" "$value"
    fi
    
    if [ -n "$status" ]; then
        case "$status" in
            "ok"|"good") printf " ${G}${CHECK}${Z}" ;;
            "warn"|"warning") printf " ${Y}${WARN}${Z}" ;;
            "error"|"bad") printf " ${R}${CROSS}${Z}" ;;
        esac
    fi
    printf "\n"
}

# Get system information
get_system_info() {
    print_section "System Information"
    
    hostname=$(hostname)
    current_time=$(date '+%Y-%m-%d %H:%M:%S %Z')
    uptime_info=$(uptime -p 2>/dev/null || uptime | sed 's/.*up \([^,]*\).*/\1/')
    load_avg=$(uptime | awk -F'load average:' '{print $2}' | xargs)
    
    print_item "Hostname" "$hostname"
    print_item "Current Time" "$current_time"
    print_item "Uptime" "$uptime_info"
    print_item "Load Average" "$load_avg"
    
    # OS Information
    if [ -f /etc/os-release ]; then
        os_name=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d'"' -f2)
        os_version=$(grep '^VERSION=' /etc/os-release | cut -d'"' -f2)
    else
        os_name=$(uname -s)
        os_version=$(uname -r)
    fi
    
    kernel=$(uname -r)
    arch=$(uname -m)
    
    print_item "OS" "$os_name"
    print_item "Kernel" "$kernel"
    print_item "Architecture" "$arch"
}

get_hardware_info() {
    print_section "Hardware Information"
    
    # CPU Information
    if command -v lscpu >/dev/null 2>&1; then
        cpu_model=$(lscpu | grep "Model name" | awk -F: '{print $2}' | xargs)
        cpu_cores=$(lscpu | grep "^CPU(s):" | awk '{print $2}')
        cpu_threads=$(lscpu | grep "Thread(s) per core:" | awk '{print $4}')
    else
        cpu_model=$(grep "model name" /proc/cpuinfo | head -1 | awk -F: '{print $2}' | xargs)
        cpu_cores=$(grep -c processor /proc/cpuinfo)
        cpu_threads="N/A"
    fi
    
    print_item "CPU" "$cpu_model"
    print_item "Cores/Threads" "${cpu_cores}/${cpu_threads}"
    
    # Memory Information
    if command -v free >/dev/null 2>&1; then
        mem_total=$(free -h | awk 'NR==2{print $2}')
        mem_used=$(free -h | awk 'NR==2{print $3}')
        mem_percent=$(free | awk 'NR==2{printf "%.1f%%", $3*100/$2}')
        mem_status="ok"
        mem_usage_int=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')
        if [ "$mem_usage_int" -gt 85 ]; then
            mem_status="warn"
        fi
        print_item "Memory" "${mem_used}/${mem_total} (${mem_percent})" "$mem_status"
    fi
    
    # Storage Information
    print_item "Root Disk" "$(df -h / | awk 'NR==2{printf "%s/%s (%s used)", $3,$2,$5}')"
    
    # GPU Information
    if command -v nvidia-smi >/dev/null 2>&1; then
        gpu_name=$(nvidia-smi --query-gpu=name --format=csv,noheader,nounits 2>/dev/null | head -1)
        gpu_mem=$(nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null | head -1 | tr ',' '/')
        if [ -n "$gpu_name" ]; then
            print_item "GPU" "$gpu_name"
            print_item "GPU Memory" "${gpu_mem} MB"
        fi
    elif command -v lspci >/dev/null 2>&1; then
        gpu_info=$(lspci | grep -i vga | head -1 | cut -d: -f3 | xargs)
        if [ -n "$gpu_info" ]; then
            print_item "GPU" "$gpu_info"
        fi
    fi
    
    # Temperature (if sensors available)
    if command -v sensors >/dev/null 2>&1; then
        cpu_temp=$(sensors 2>/dev/null | grep -i "core 0\|cpu" | head -1 | grep -o '+[0-9]*\.[0-9]*°C' | head -1)
        if [ -n "$cpu_temp" ]; then
            temp_status="ok"
            temp_val=$(echo "$cpu_temp" | grep -o '[0-9]*' | head -1)
            if [ "$temp_val" -gt 75 ]; then
                temp_status="warn"
            elif [ "$temp_val" -gt 85 ]; then
                temp_status="error"
            fi
            print_item "CPU Temp" "$cpu_temp" "$temp_status"
        fi
    fi
}

get_network_info() {
    print_section "Network Information"
    
    # Get active network interfaces
    if command -v ip >/dev/null 2>&1; then
        while read -r interface ip; do
            if [ "$interface" != "lo" ] && [ -n "$ip" ]; then
                print_item "$interface" "$ip"
            fi
        done < <(ip route get 8.8.8.8 2>/dev/null | head -1 | grep -o 'dev [^ ]*' | cut -d' ' -f2 | while read iface; do
            ip=$(ip addr show "$iface" 2>/dev/null | grep 'inet ' | head -1 | awk '{print $2}' | cut -d'/' -f1)
            echo "$iface $ip"
        done)
    fi
    
    # External IP (quick check, timeout after 3 seconds)
    external_ip=$(timeout 3 curl -s ipecho.net/plain 2>/dev/null || echo "N/A")
    print_item "External IP" "$external_ip"
}

get_development_info() {
    print_section "Development Environment"
    
    # User and shell
    user="${USER:-$(id -un)}"
    home="${HOME:-$(getent passwd "$(id -un)" | cut -d: -f6)}"
    shell="${SHELL:-$0}"
    
    print_item "User" "$user"
    print_item "Home" "$home"
    print_item "Shell" "$(basename "$shell")"
    
    # Python environment
    py=/mnt/9C12DA5412DA32CE/Servers/comfy/venv/bin/python
    if [ -f "$py" ]; then
        pver="$("$py" -c 'import sys; print(sys.version.split()[0])' 2>/dev/null)"
        torch_v="$("$py" -m pip show torch 2>/dev/null | awk -F': ' '/^Version:/ {print $2}')"
        cuda_v="$("$py" -c 'import torch; print(getattr(getattr(torch, "version", None), "cuda", None))' 2>/dev/null)"
        
        print_item "Python (venv)" "$pver" "ok" "$G"
        [ -n "$torch_v" ] && print_item "PyTorch" "$torch_v" "ok" "$G"
        [ -n "$cuda_v" ] && print_item "CUDA (PyTorch)" "$cuda_v" "ok" "$G"
    else
        sys_python=$(command -v python3 2>/dev/null || command -v python 2>/dev/null)
        if [ -n "$sys_python" ]; then
            pver="$("$sys_python" --version 2>&1 | awk '{print $2}')"
            print_item "Python (system)" "$pver"
        fi
    fi
    
    # Node.js and npm
    if command -v node >/dev/null 2>&1; then
        node_v=$(node -v)
        npm_v=$(npm -v 2>/dev/null || echo "not found")
        print_item "Node.js" "$node_v" "ok" "$G"
        print_item "npm" "$npm_v"
    else
        print_item "Node.js" "not installed"
    fi
    
    # Docker
    if command -v docker >/dev/null 2>&1; then
        docker_v=$(docker --version 2>/dev/null | awk '{print $3}' | tr -d ',')
        docker_status=$(systemctl is-active docker 2>/dev/null || echo "unknown")
        status_color="$G"
        status_icon="ok"
        if [ "$docker_status" != "active" ]; then
            status_color="$Y"
            status_icon="warn"
        fi
        print_item "Docker" "$docker_v ($docker_status)" "$status_icon" "$status_color"
    fi
    
    # Git (current directory)
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        git_branch=$(git branch --show-current 2>/dev/null || echo "detached")
        git_status=$(git status --porcelain 2>/dev/null | wc -l)
        git_remote=$(git remote -v 2>/dev/null | head -1 | awk '{print $2}' || echo "no remote")
        
        if [ "$git_status" -eq 0 ]; then
            status="ok"
            status_text="clean"
        else
            status="warn"
            status_text="$git_status changes"
        fi
        
        print_item "Git Branch" "$git_branch ($status_text)" "$status"
        print_item "Git Remote" "$git_remote"
    fi
}

get_system_health() {
    print_section "System Health"
    
    # Disk usage warnings
    df -h | awk 'NR>1 && $5+0 > 80 {print $6, $5}' | while read mount usage; do
        print_item "Disk Warning" "$mount at $usage" "warn" "$Y"
    done
    
    # Load average warnings
    load1=$(uptime | awk -F'load average:' '{print $2}' | awk -F, '{print $1}' | xargs)
    cpu_count=$(nproc)
    if command -v bc >/dev/null 2>&1; then
        if (( $(echo "$load1 > $cpu_count" | bc -l) )); then
            print_item "Load Warning" "High load: $load1 (cores: $cpu_count)" "warn" "$Y"
        fi
    fi
    
    # Memory warnings
    mem_percent=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')
    if [ "$mem_percent" -gt 90 ]; then
        print_item "Memory Warning" "High usage: ${mem_percent}%" "error" "$R"
    elif [ "$mem_percent" -gt 80 ]; then
        print_item "Memory Warning" "Moderate usage: ${mem_percent}%" "warn" "$Y"
    fi
    
    # Service status (common development services)
    for service in nginx apache2 mysql postgresql docker; do
        if systemctl list-unit-files | grep -q "^$service.service"; then
            status=$(systemctl is-active "$service" 2>/dev/null)
            if [ "$status" = "active" ]; then
                print_item "$service" "running" "ok" "$G"
            elif [ "$status" = "failed" ]; then
                print_item "$service" "failed" "error" "$R"
            fi
        fi
    done
}

# Main execution
main() {
    clear
    
    # Header with timestamp
    print_header "SYSTEM OVERVIEW - $(date '+%Y-%m-%d %H:%M:%S')"
    
    get_system_info
    get_hardware_info
    get_network_info
    get_development_info
    get_system_health
    
    # Footer
    printf "\n${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${Z}\n"
    printf "${DIM}Generated by CLOUDWERX LAB System Info • $(date '+%H:%M:%S')${Z}\n\n"
    
    # Run nvidia-smi if available for additional GPU info
    if command -v nvidia-smi >/dev/null 2>&1; then
        printf "${B}${C}GPU Details:${Z}\n"
        nvidia-smi --query-gpu=name,utilization.gpu,memory.used,memory.total,temperature.gpu --format=csv,noheader 2>/dev/null | head -3
        printf "\n"
    fi
}

# Run the main function
main