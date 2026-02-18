#!/bin/bash

# ================================================
# Server Maintenance Toolkit - Main Script
# Runs all maintenance tasks
# ================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities and config
source "$SCRIPT_DIR/scripts/utils.sh"
source "$SCRIPT_DIR/config/maintenance.conf"

# Source all task scripts
source "$SCRIPT_DIR/scripts/backup.sh"
source "$SCRIPT_DIR/scripts/disk_check.sh"
source "$SCRIPT_DIR/scripts/log_cleaner.sh"

show_usage() {
    cat << EOF
Server Maintenance Toolkit
Usage: $0 [OPTIONS]

OPTIONS:
    -a, --all         Run all maintenance tasks
    -b, --backup      Run backup only
    -d, --disk        Check disk usage only
    -l, --logs        Clean logs only
    -h, --help        Show this help message

EXAMPLES:
    $0 --all          Run complete maintenance
    $0 -b             Backup only
    $0 -d -l          Check disk and clean logs

EOF
}

main() {
    local run_all=false
    local run_backup=false
    local run_disk=false
    local run_logs=false
    
    # Parse arguments
    if [ $# -eq 0 ]; then
        show_usage
        exit 0
    fi
    
    while [ $# -gt 0 ]; do
        case $1 in
            -a|--all)
                run_all=true
                ;;
            -b|--backup)
                run_backup=true
                ;;
            -d|--disk)
                run_disk=true
                ;;
            -l|--logs)
                run_logs=true
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
        shift
    done
    
    # Set all flags if --all is specified
    if [ "$run_all" = true ]; then
        run_backup=true
        run_disk=true
        run_logs=true
    fi
    
    # Start maintenance
    local start_time=$(date +%s)
    local hostname=$(hostname)
    
    echo "========================================"
    echo "  Server Maintenance Toolkit"
    echo "  Host: $hostname"
    echo "  Started: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "========================================"
    echo ""
    
    local exit_code=0
    
    # Run selected tasks
    if [ "$run_disk" = true ]; then
        check_disk
        [ $? -ne 0 ] && exit_code=1
    fi
    
    if [ "$run_backup" = true ]; then
        backup
        [ $? -ne 0 ] && exit_code=1
    fi
    
    if [ "$run_logs" = true ]; then
        clean_logs
        [ $? -ne 0 ] && exit_code=1
    fi
    
    # Summary
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    echo ""
    print_header "MAINTENANCE COMPLETE"
    log_info "Total duration: ${duration} seconds"
    
    if [ $exit_code -eq 0 ]; then
        log_success "All tasks completed successfully"
    else
        log_warning "Some tasks completed with warnings"
    fi
    
    exit $exit_code
}

main "$@"
