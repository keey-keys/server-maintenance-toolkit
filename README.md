# Server Maintenance Toolkit

A comprehensive bash-based server maintenance toolkit for Linux systems. Automates common server maintenance tasks including backups, disk monitoring, and log cleanup.

## Features

- **Automated Backups**: Compressed tar backups with automatic rotation
- **Disk Usage Monitoring**: Alerts when disk usage exceeds thresholds
- **Log Cleanup**: Removes old logs and compresses large files
- **Email Alerts**: Optional email notifications for warnings
- **Detailed Logging**: All operations logged for audit trail
- **Modular Design**: Run individual tasks or complete maintenance suite
## 📁 Project Structure


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
