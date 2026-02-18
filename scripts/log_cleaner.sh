#!/bin/bash

# ================================================
# Log Cleaner
# Removes old logs and compresses large log files
# ================================================

# Source utilities and config

clean_logs() {
    print_header "LOG CLEANUP"
    
    check_root
    
    local total_freed=0
    local files_deleted=0
    local files_compressed=0
    
    log_info "Cleaning logs older than $LOG_MAX_AGE_DAYS days..."
    log_info "Directories: $LOG_DIRECTORIES"
    echo ""
    
    for dir in $LOG_DIRECTORIES; do
        if [ ! -d "$dir" ]; then
            log_warning "Directory not found: $dir"
            continue
        fi
        
        log_info "Processing: $dir"
        
        # Find and delete old log files
        while IFS= read -r logfile; do
            local size=$(stat -f%z "$logfile" 2>/dev/null || stat -c%s "$logfile" 2>/dev/null)
            rm -f "$logfile"
            if [ $? -eq 0 ]; then
                files_deleted=$((files_deleted + 1))
                total_freed=$((total_freed + size))
                log_info "  Deleted: $(basename $logfile)"
            fi
        done < <(find "$dir" -name "*.log" -type f -mtime +$LOG_MAX_AGE_DAYS 2>/dev/null)
        
        # Find and compress large log files
        while IFS= read -r logfile; do
            local size_mb=$(du -m "$logfile" | cut -f1)
            if [ $size_mb -gt $LOG_MAX_SIZE_MB ]; then
                gzip "$logfile"
                if [ $? -eq 0 ]; then
                    files_compressed=$((files_compressed + 1))
                    log_info "  Compressed: $(basename $logfile)"
                fi
            fi
        done < <(find "$dir" -name "*.log" -type f ! -name "*.gz" 2>/dev/null)
    done
    
    echo ""
    
    # Convert bytes to human readable
    local freed_mb=$((total_freed / 1024 / 1024))
    
    log_success "Cleanup complete"
    log_info "Files deleted: $files_deleted"
    log_info "Files compressed: $files_compressed"
    log_info "Space freed: ${freed_mb} MB"
    
    return 0
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    clean_logs
    exit $?
fi
