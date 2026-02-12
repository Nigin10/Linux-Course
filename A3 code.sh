#!/bin/bash


SOURCE_DIR="$1"
BACKUP_DIR="$2"
EXTENSION="$3"


if [ $# -ne 3 ]; then
    echo "Usage: $0 <source_dir> <backup_dir> <file_extension>"
    exit 1
fi


if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory does not exist"
    exit 1
fi


if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create backup directory"
        exit 1
    fi
fi


files=( "$SOURCE_DIR"/*"$EXTENSION" )

# If no matching files
if [ ! -e "${files[0]}" ]; then
    echo "No files with extension $EXTENSION found in source directory"
    exit 0
fi


export BACKUP_COUNT=0
TOTAL_SIZE=0

echo "Files to be backed up:"
echo "----------------------"

# Print file names and sizes
for file in "${files[@]}"; do
    size=$(stat -c %s "$file")
    echo "$(basename "$file") - $size bytes"
done

echo "----------------------"


for file in "${files[@]}"; do
    filename=$(basename "$file")
    dest="$BACKUP_DIR/$filename"

    if [ -e "$dest" ]; then
        # Overwrite only if source is newer
        if [ "$file" -nt "$dest" ]; then
            cp "$file" "$dest"
        else
            continue
        fi
    else
        cp "$file" "$dest"
    fi

    BACKUP_COUNT=$((BACKUP_COUNT + 1))
    filesize=$(stat -c %s "$file")
    TOTAL_SIZE=$((TOTAL_SIZE + filesize))
done

export BACKUP_COUNT

# -----------------------------
# 6. Output report
# -----------------------------
REPORT="$BACKUP_DIR/backup_report.log"

{
    echo "Backup Summary Report"
    echo "---------------------"
    echo "Total files processed : $BACKUP_COUNT"
    echo "Total size backed up  : $TOTAL_SIZE bytes"
    echo "Backup directory      : $BACKUP_DIR"
    echo "Date                  : $(date)"
} > "$REPORT"

echo "Backup completed successfully."
echo "Report saved at: $REPORT"
#!/bin/bash
read -p "input from user:" numb
for i in numb; do
echo $i
done
