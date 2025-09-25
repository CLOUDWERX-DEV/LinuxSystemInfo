#!/bin/bash

# Demo script for Linux System Info
# Shows both comprehensive and simple modes with explanatory text

# Colors
GREEN='\033[32m'
BLUE='\033[34m'
CYAN='\033[36m'
RESET='\033[0m'
BOLD='\033[1m'

echo -e "${BLUE}${BOLD}"
echo "╔══════════════════════════════════════════════════════════════════════╗"
echo "║                    Linux System Info - Demo                           ║"
echo "╚══════════════════════════════════════════════════════════════════════╝"
echo -e "${RESET}"

echo -e "${CYAN}This demo shows both output modes of Linux System Info${RESET}\n"

echo -e "${GREEN}${BOLD}📊 COMPREHENSIVE MODE (sysinfo)${RESET}"
echo -e "${CYAN}Full system overview with detailed information:${RESET}\n"

# Check if sysinfo command exists
if command -v sysinfo >/dev/null 2>&1; then
    sysinfo
else
    echo "sysinfo command not found. Please install first:"
    echo "curl -sSL https://raw.githubusercontent.com/CLOUDWERX-DEV/LinuxSystemInfo/main/install.sh | bash"
    exit 1
fi

echo -e "\n\n${GREEN}${BOLD}⚡ SIMPLE MODE (sysinfo-simple)${RESET}"
echo -e "${CYAN}Compact overview for quick checks:${RESET}\n"

if command -v sysinfo-simple >/dev/null 2>&1; then
    sysinfo-simple
else
    echo "sysinfo-simple command not found. Please install first."
    exit 1
fi

echo -e "\n${CYAN}${BOLD}Available Commands:${RESET}"
echo -e "  ${BOLD}sysinfo${RESET}        - Comprehensive system information"
echo -e "  ${BOLD}sysinfo-simple${RESET} - Quick compact overview"
echo -e "  ${BOLD}si${RESET}             - Alias for sysinfo"
echo -e "  ${BOLD}sis${RESET}            - Alias for sysinfo-simple"

echo -e "\n${CYAN}${BOLD}More Information:${RESET}"
echo -e "  ${BOLD}GitHub:${RESET} https://github.com/CLOUDWERX-DEV/LinuxSystemInfo"
echo -e "  ${BOLD}Documentation:${RESET} README.md and docs/"
echo -e "  ${BOLD}Support:${RESET} https://github.com/CLOUDWERX-DEV/LinuxSystemInfo/issues"

echo -e "\n${GREEN}${BOLD}Made with ❤️  by CLOUDWERX LAB${RESET}"