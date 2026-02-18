#!/bin/bash

# ================================================
# Shared Utility Functions
# ================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    local level=$1
    shift
    local message="$@"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo -e "${timestamp} [${level}] ${message}" | tee -a "$MAINTENANCE_LOG"
}

log_info() {
    echo -e "${BLUE}ℹ${NC} $@"
    log "INFO" "$@"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@"
    log "SUCCESS" "$@"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@"
    log "WARNING" "$@"
}

log_error() {
    echo -e "${RED}❌${NC} $@"
    log "ERROR" "$@"
}

# Print section header
print_header() {
    echo ""
    echo "================================================"
    echo "  $1"
    echo "================================================"
}

# Check if running as root (for operations that need it)
check_root() {
    if [ "$EUID" -ne 0 ]; then
        log_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

# Send email alert if configured
send_alert() {
    local subject=$1
    local message=$2
    
    if [ -n "$ALERT_EMAIL" ]; then
        echo "$message" | mail -s "$subject" "$ALERT_EMAIL" 2>/dev/null
        if [ $? -eq 0 ]; then
            log_info "Alert email sent to $ALERT_EMAIL"
        fi
    fi
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}
