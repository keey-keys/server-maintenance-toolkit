#!/bin/bash

# ================================================
# Backup Script
# Creates compressed backups of specified directories
# ================================================
# Source utilities and config (only when run standalone)
if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/utils.sh"
    source "$SCRIPT_DIR/../config/maintenance.conf"
fi

backup() {
    print_header "BACKUP PROCESS"
    
    # Create backup directory if it doesn't exist
    if [ ! -d "$BACKUP_DEST" ]; then
        log_info "Creating backup directory: $BACKUP_DEST"
        mkdir -p "$BACKUP_DEST" || {
            log_error "Failed to create backup directory"
            return 1
        }
    fi
    
    # Generate backup filename with timestamp
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local backup_file="$BACKUP_DEST/backup_${timestamp}.tar.gz"
    local hostname=$(hostname)
    
    log_info "Starting backup process..."
    log_info "Source: $BACKUP_SOURCE"
    log_info "Destination: $backup_file"
    
    # Create the backup
    tar -czf "$backup_file" $BACKUP_SOURCE 2>/dev/null
    
    if [ $? -eq 0 ]; then
        local size=$(du -h "$backup_file" | cut -f1)
        log_success "Backup completed successfully"
        log_info "Backup size: $size"
        log_info "Location: $backup_file"
        
        # Clean old backups
        clean_old_backups
        
        return 0
    else
        log_error "Backup failed"
        send_alert "Backup Failed on $hostname" "Backup process failed. Check logs for details."
        return 1
    fi
}

clean_old_backups() {
    log_info "Cleaning backups older than $BACKUP_RETENTION_DAYS days..."
    
    local deleted=0
    while IFS= read -r old_backup; do
        rm -f "$old_backup"
        deleted=$((deleted + 1))
        log_info "Deleted old backup: $(basename $old_backup)"
    done < <(find "$BACKUP_DEST" -name "backup_*.tar.gz" -type f -mtime +$BACKUP_RETENTION_DAYS)
    
    if [ $deleted -gt 0 ]; then
        log_success "Removed $deleted old backup(s)"
    else
        log_info "No old backups to remove"
    fi
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    backup
    exit $?
fi
