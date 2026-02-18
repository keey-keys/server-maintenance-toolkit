# Server Maintenance Toolkit

A comprehensive bash-based server maintenance toolkit for Linux systems. Automates common server maintenance tasks including backups, disk monitoring, and log cleanup.

## Features

- **Automated Backups**: Compressed tar backups with automatic rotation
- **Disk Usage Monitoring**: Alerts when disk usage exceeds thresholds
- **Log Cleanup**: Removes old logs and compresses large files
- **Email Alerts**: Optional email notifications for warnings
- **Detailed Logging**: All operations logged for audit trail
- **Modular Design**: Run individual tasks or complete maintenance suite

## Quick Start
```bash

# Make scripts executable
chmod +x maintenance.sh scripts/*.sh

# Edit configuration
nano config/maintenance.conf

# Run all maintenance tasks
sudo ./maintenance.sh --all
```

## Project Structure
```
server-maintenance-toolkit/
├── maintenance.sh          # Main script
├── scripts/
│   ├── backup.sh          # Backup operations
│   ├── disk_check.sh      # Disk monitoring
│   ├── log_cleaner.sh     # Log cleanup
│   └── utils.sh           # Shared utilities
├── config/
│   └── maintenance.conf   # Configuration file
├── logs/                  # Execution logs
└── screenshots/           # Documentation images
```

## Configuration

Edit `config/maintenance.conf` to customize:
```bash
# Backup settings
BACKUP_SOURCE="/home /etc"
BACKUP_DEST="/backup"
BACKUP_RETENTION_DAYS=7

# Disk monitoring
DISK_THRESHOLD=80
DISK_PARTITIONS="/ /home"

# Log cleanup
LOG_DIRECTORIES="/var/log /tmp"
LOG_MAX_AGE_DAYS=30
LOG_MAX_SIZE_MB=100

# Email alerts (optional)
ALERT_EMAIL="admin@example.com"
```

## Usage

### Run All Tasks
```bash
sudo ./maintenance.sh --all
```

### Individual Tasks
```bash
# Backup only
sudo ./maintenance.sh --backup

# Check disk usage only
./maintenance.sh --disk

# Clean logs only
sudo ./maintenance.sh --logs

# Combine tasks
sudo ./maintenance.sh --disk --backup
```

### Schedule with Cron

Run daily at 2 AM:
```bash
crontab -e
# Add this line:
0 2 * * * /path/to/server-maintenance-toolkit/maintenance.sh --all >> /var/log/maintenance_cron.log 2>&1
```

## Example Output
```
========================================
  Server Maintenance Toolkit
  Host: web-server-01
  Started: 2026-02-18 14:30:00
========================================

================================================
  DISK USAGE CHECK
================================================
ℹ Checking disk usage (threshold: 80%)...

PARTITION            SIZE       USED       AVAILABLE  STATUS
======================================================================
/                    50G        25G        23G         50%
/home                100G       45G        50G         45%

 All partitions are healthy

================================================
  BACKUP PROCESS
================================================
ℹ Starting backup process...
ℹ Source: /home /etc
ℹ Destination: /backup/backup_20260218_143000.tar.gz
 Backup completed successfully
ℹ Backup size: 2.3G

================================================
  MAINTENANCE COMPLETE
================================================
ℹ Total duration: 45 seconds
All tasks completed successfully
```

## Security Notes

- Backup script requires write access to backup destination
- Log cleaner requires root privileges (use sudo)
- Store sensitive configuration securely
- Review and customize paths before running

## Logs

All operations are logged to `/var/log/maintenance.log`:
```bash
# View recent logs
tail -50 /var/log/maintenance.log

# Watch logs in real-time
tail -f /var/log/maintenance.log
```

## Requirements

- Bash 4.0+
- Standard Linux utilities (tar, gzip, df, du, find)
- Root access for log cleanup operations
- Optional: `mailutils` for email alerts

## Contributing

Contributions welcome! Please feel free to submit issues and pull requests.

## License

MIT License - feel free to use and modify for your needs.

## Author

OKIKIJESU OGUNYEMI

---

**Note**: Test all scripts in a safe environment before deploying to production servers.
