#!/bin/bash
    
set -e
cd /mnt/backup/

# Define output variables
backup_type=""
extra_params=()

log_with_timestamp() {
    echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") $1"
}

determine_next_backup() {
    # Current date minus one hour
    current_date=$(date -d "-1 hour" +"%Y-%m-%d %H:%M:%S")
    current_date_unix=$(date -d "$current_date" +%s)

    # Check for monthly backup
    if [ -f "monthly/mariadb_backup_info" ]; then
        start_time=$(grep "start_time" monthly/mariadb_backup_info | awk -F ' = ' '{print $2}')
        start_time_unix=$(date -d "$start_time" +%s)
        if [ $(date -d "$current_date -1 month" +%s) -ge $start_time_unix ]; then
            backup_type="monthly-$(date -d "$start_time" +"%Y%m")"
            extra_params=("--extra-lsndir=monthly")
            return
        fi
    fi

    # Check for weekly backup
    if [ -f "weekly/mariadb_backup_info" ]; then
        start_time=$(grep "start_time" weekly/mariadb_backup_info | awk -F ' = ' '{print $2}')
        start_time_unix=$(date -d "$start_time" +%s)
        if [ $(date -d "$current_date -7 days" +%s) -ge $start_time_unix ]; then
            backup_type="weekly-$(date -d "$start_time" +"%Y%m%d")"
            extra_params=("--extra-lsndir=weekly" "--incremental-basedir=monthly")
            return
        fi
    fi

    # Default to daily backup
    backup_type="daily-$(date +"%Y%m%d")"
    extra_params=("--incremental-basedir=weekly")
}

# Call the check_backup function
determine_next_backup

if [[ -f "$backup_type.zstd" ]]; then
    log_with_timestamp "Backup already exists for today - aborting"
    exit 1
fi

password_aux="${MARIADB_ROOT_PASSWORD:-}"
if [[ -f "${MARIADB_ROOT_PASSWORD_FILE:-}" ]]; then
  password_aux=$(cat "$MARIADB_ROOT_PASSWORD_FILE")
fi

# Run the backup command
log_with_timestamp "Saving backup to /mnt/backup/$backup_type.zstd"
mariadb-backup --user=root --password="$password_aux" --stream=mbstream --parallel=4 --backup "${extra_params[@]}" | nice zstd --no-progress -T0 -9 -o $backup_type.zstd
log_with_timestamp "Done Saving backup to /mnt/backup/$backup_type.zstd"
# Save to S3
log_with_timestamp "Uploading backup to s3://$S3_URL/"
STORAGE_CLASS=${STORAGE_CLASS:-DEEP_ARCHIVE}
aws-bin/aws s3 --no-progress cp $backup_type.zstd s3://$S3_URL/ --storage-class $STORAGE_CLASS
log_with_timestamp "Done uploading backup to s3://$S3_URL/"

# Function to delete old backups based on filename date
delete_old_backups() {
    local backup_prefix=$1
    local keep_count=$2

    # Array to store filenames and their dates
    declare -A backup_files

    # Extract dates from filenames and store them in the array
    for file in $backup_prefix-*.zstd; do
        filename=$(basename "$file")
        date_str=$(echo "$filename" | grep -oP "$backup_prefix-\K\d{6,8}")
        if [[ -n $date_str ]]; then
            backup_files["$file"]=$date_str
        fi
    done

    # Sort filenames by date
    sorted_files=($(for key in "${!backup_files[@]}"; do echo "$key"; done | sort -t'-' -k2,2 -r))

    # Delete old backups if more than the specified number to keep
    for ((i=keep_count; i<${#sorted_files[@]}; i++)); do
        log_with_timestamp "Deleting old backup: ${sorted_files[$i]}"
        rm -f "${sorted_files[$i]}"
    done
}

# Delete old backups based on the backup type
if [[ $backup_type == monthly-* ]]; then
    # Keep only the latest month
    delete_old_backups "monthly" 1
elif [[ $backup_type == weekly-* ]]; then
    # Keep only the latest week
    delete_old_backups "weekly" 1
elif [[ $backup_type == daily-* ]]; then
    # Keep only the latest 7 days
    delete_old_backups "daily" 7
fi
