#!/bin/bash

# Linux System Info - Installation Script
# Author: CLOUDWERX LAB
# License: Apache 2.0

set -e

# Colors for output
if command -v tput >/dev/null 2>&1 && [ -t 1 ]; then
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4)
    CYAN=$(tput setaf 6)
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    RED='\033[31m'
    GREEN='\033[32m'
    YELLOW='\033[33m'
    BLUE='\033[34m'
    CYAN='\033[36m'
    BOLD='\033[1m'
    RESET='\033[0m'
fi

# Print functions
print_header() {
    echo ""
    echo "${BLUE}${BOLD}╔═══════════════════════════════════════════════════════╗${RESET}"
    echo "${BLUE}${BOLD}║${RESET}  ${CYAN}🖥️  Linux System Info - Installation Script${RESET}  ${BLUE}${BOLD}║${RESET}"
    echo "${BLUE}${BOLD}╚═══════════════════════════════════════════════════════╝${RESET}"
    echo ""
}

print_info() {
    echo "${CYAN}ℹ${RESET}  $1"
}

print_success() {
    echo "${GREEN}✓${RESET}  $1"
}

print_warning() {
    echo "${YELLOW}⚠${RESET}  $1"
}

print_error() {
    echo "${RED}✗${RESET}  $1" >&2
}

# Check if running as root
check_root() {
    if [ "$EUID" -eq 0 ] && [ "$USER_INSTALL" != "true" ]; then
        return 0  # Running as root
    else
        return 1  # Not running as root
    fi
}

# Install system-wide
install_system() {
    print_info "Installing system-wide (requires root privileges)..."
    
    # Check if we have root privileges
    if ! check_root; then
        print_error "System-wide installation requires root privileges."
        print_info "Please run: sudo ./install.sh"
        print_info "Or use user installation: ./install.sh --user"
        exit 1
    fi
    
    # Create directories
    mkdir -p /usr/local/bin
    mkdir -p /usr/local/share/linuxsysinfo
    
    # Copy scripts
    cp scripts/sysinfo.sh /usr/local/bin/sysinfo
    cp scripts/sysinfo-simple.sh /usr/local/bin/sysinfo-simple
    
    # Make executable
    chmod +x /usr/local/bin/sysinfo
    chmod +x /usr/local/bin/sysinfo-simple
    
    # Copy completion script
    if [ -d /etc/bash_completion.d ]; then
        cp scripts/bash_completion.sh /etc/bash_completion.d/sysinfo
        print_success "Bash completion installed to /etc/bash_completion.d/"
    elif [ -d /usr/local/etc/bash_completion.d ]; then
        cp scripts/bash_completion.sh /usr/local/etc/bash_completion.d/sysinfo
        print_success "Bash completion installed to /usr/local/etc/bash_completion.d/"
    else
        print_warning "Bash completion directory not found, skipping completion installation"
    fi
    
    # Copy documentation
    cp -r docs /usr/local/share/linuxsysinfo/
    cp README.md CHANGELOG.md LICENSE /usr/local/share/linuxsysinfo/
    
    print_success "System-wide installation completed!"
    print_info "Commands available: ${BOLD}sysinfo${RESET}, ${BOLD}sysinfo-simple${RESET}"
    print_info "Aliases available: ${BOLD}si${RESET}, ${BOLD}sis${RESET}"
    print_info "Documentation: /usr/local/share/linuxsysinfo/"
}

# Install for current user
install_user() {
    print_info "Installing for current user..."
    
    # Create directories
    mkdir -p ~/.local/bin
    mkdir -p ~/.local/share/linuxsysinfo
    
    # Copy scripts
    cp scripts/sysinfo.sh ~/.local/bin/sysinfo
    cp scripts/sysinfo-simple.sh ~/.local/bin/sysinfo-simple
    
    # Make executable
    chmod +x ~/.local/bin/sysinfo
    chmod +x ~/.local/bin/sysinfo-simple
    
    # Copy documentation
    cp -r docs ~/.local/share/linuxsysinfo/
    cp README.md CHANGELOG.md LICENSE ~/.local/share/linuxsysinfo/
    
    # Add to PATH if not already there
    if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
        echo '' >> ~/.bashrc
        echo '# Added by Linux System Info installer' >> ~/.bashrc
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        print_info "Added ~/.local/bin to PATH in ~/.bashrc"
        print_warning "Please restart your terminal or run: source ~/.bashrc"
    fi
    
    # Install bash completion for user
    mkdir -p ~/.local/share/bash-completion/completions
    cp scripts/bash_completion.sh ~/.local/share/bash-completion/completions/sysinfo
    
    # Add completion to bashrc if not already there
    if ! grep -q "Linux System Info" ~/.bashrc; then
        echo '' >> ~/.bashrc
        echo '# Linux System Info completion and aliases' >> ~/.bashrc
        echo 'source ~/.local/share/bash-completion/completions/sysinfo' >> ~/.bashrc
        print_success "Bash completion and aliases added to ~/.bashrc"
    fi
    
    print_success "User installation completed!"
    print_info "Commands available: ${BOLD}sysinfo${RESET}, ${BOLD}sysinfo-simple${RESET}"
    print_info "Aliases available: ${BOLD}si${RESET}, ${BOLD}sis${RESET}"
    print_info "Documentation: ~/.local/share/linuxsysinfo/"
    print_warning "Please restart your terminal or run: ${BOLD}source ~/.bashrc${RESET}"
}

# Check dependencies
check_dependencies() {
    print_info "Checking dependencies..."
    
    local missing_deps=()
    local optional_deps=()
    
    # Required dependencies
    for cmd in bash free df uptime hostname awk; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        print_info "Please install the missing commands and try again."
        exit 1
    fi
    
    print_success "All required dependencies found"
    
    # Optional dependencies
    for cmd in lscpu nvidia-smi sensors git docker systemctl curl; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            optional_deps+=("$cmd")
        fi
    done
    
    if [ ${#optional_deps[@]} -gt 0 ]; then
        print_warning "Optional dependencies not found: ${optional_deps[*]}"
        print_info "Install these for enhanced functionality:"
        echo "  • ${BOLD}lscpu${RESET} - Detailed CPU information"
        echo "  • ${BOLD}nvidia-smi${RESET} - NVIDIA GPU monitoring"
        echo "  • ${BOLD}sensors${RESET} - Temperature monitoring (lm-sensors package)"
        echo "  • ${BOLD}git${RESET} - Repository status information"
        echo "  • ${BOLD}docker${RESET} - Docker service status"
        echo "  • ${BOLD}systemctl${RESET} - System service monitoring"
        echo "  • ${BOLD}curl${RESET} - External IP detection"
        echo ""
        
        # Distribution-specific install suggestions
        if command -v apt >/dev/null 2>&1; then
            print_info "Install with: ${BOLD}sudo apt install lm-sensors util-linux pciutils curl git docker.io${RESET}"
        elif command -v dnf >/dev/null 2>&1; then
            print_info "Install with: ${BOLD}sudo dnf install lm_sensors util-linux pciutils curl git docker${RESET}"
        elif command -v pacman >/dev/null 2>&1; then
            print_info "Install with: ${BOLD}sudo pacman -S lm_sensors util-linux pciutils curl git docker${RESET}"
        fi
    else
        print_success "All optional dependencies found"
    fi
}

# Test installation
test_installation() {
    print_info "Testing installation..."
    
    if command -v sysinfo >/dev/null 2>&1; then
        print_success "sysinfo command is available"
    else
        print_error "sysinfo command not found in PATH"
        return 1
    fi
    
    if command -v sysinfo-simple >/dev/null 2>&1; then
        print_success "sysinfo-simple command is available"
    else
        print_error "sysinfo-simple command not found in PATH"
        return 1
    fi
    
    print_success "Installation test completed successfully!"
}

# Uninstall function
uninstall() {
    print_info "Uninstalling Linux System Info..."
    
    if [ "$USER_INSTALL" = "true" ]; then
        # User uninstall
        rm -f ~/.local/bin/sysinfo ~/.local/bin/sysinfo-simple
        rm -rf ~/.local/share/linuxsysinfo
        rm -f ~/.local/share/bash-completion/completions/sysinfo
        print_success "User installation removed"
        print_warning "Please manually remove PATH and completion entries from ~/.bashrc if desired"
    else
        # System uninstall (requires root)
        if ! check_root; then
            print_error "System-wide uninstallation requires root privileges."
            print_info "Please run: sudo ./install.sh --uninstall"
            exit 1
        fi
        
        rm -f /usr/local/bin/sysinfo /usr/local/bin/sysinfo-simple
        rm -rf /usr/local/share/linuxsysinfo
        rm -f /etc/bash_completion.d/sysinfo /usr/local/etc/bash_completion.d/sysinfo
        print_success "System-wide installation removed"
    fi
}

# Show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --user         Install for current user only (~/.local/bin)"
    echo "  --system       Install system-wide (default, requires root)"
    echo "  --uninstall    Remove installation"
    echo "  --test         Test installation"
    echo "  --help         Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                    # System-wide install (requires sudo)"
    echo "  $0 --user            # User install"
    echo "  sudo $0 --system     # Explicit system install"
    echo "  $0 --uninstall --user  # Uninstall user installation"
}

# Main installation logic
main() {
    print_header
    
    case "${1:-}" in
        --user)
            USER_INSTALL="true"
            check_dependencies
            install_user
            ;;
        --system)
            check_dependencies
            install_system
            ;;
        --uninstall)
            if [ "${2:-}" = "--user" ]; then
                USER_INSTALL="true"
            fi
            uninstall
            ;;
        --test)
            test_installation
            ;;
        --help|-h)
            show_usage
            ;;
        "")
            # Default: system install
            check_dependencies
            install_system
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
    
    echo ""
    echo "${GREEN}${BOLD}🎉 Installation completed successfully!${RESET}"
    echo ""
    echo "${CYAN}Try it now:${RESET}"
    echo "  ${BOLD}sysinfo${RESET}        # Comprehensive system information"
    echo "  ${BOLD}sysinfo-simple${RESET} # Quick system overview"
    echo "  ${BOLD}si${RESET}             # Short alias for sysinfo"
    echo "  ${BOLD}sis${RESET}            # Short alias for sysinfo-simple"
    echo ""
    echo "${CYAN}Documentation:${RESET} README.md, CHANGELOG.md, docs/"
    echo "${CYAN}Support:${RESET} https://github.com/CLOUDWERX-DEV/LinuxSystemInfo"
    echo ""
    echo "${BOLD}Made with ❤️  by CLOUDWERX LAB${RESET}"
}

# Check if we're in the right directory
if [ ! -f "scripts/sysinfo.sh" ] || [ ! -f "scripts/sysinfo-simple.sh" ]; then
    print_error "Installation scripts not found!"
    print_info "Please run this installer from the LinuxSystemInfo directory"
    print_info "Make sure scripts/sysinfo.sh and scripts/sysinfo-simple.sh exist"
    exit 1
fi

# Run main function
main "$@"