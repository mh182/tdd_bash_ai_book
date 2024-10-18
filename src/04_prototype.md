# The Prototype

Prompting the AI:

> Write me shell bash shell script which downloads a CSV file from a given URL
> and move the downloaded file to a specific folder on the linux file system.

Answer from Perpelxity:

> Here's a bash script that downloads a CSV file from a given URL and moves it to a specific folder on the Linux file system:
>
> ```bash
> #!/bin/bash
>
> # Set the URL of the CSV file to download
> URL="https://example.com/data.csv"
>
> # Set the destination folder
> DEST_FOLDER="/path/to/destination/folder"
>
> # Create a temporary file name
> TEMP_FILE=$(mktemp)
>
> # Download the CSV file
> wget -q -O "$TEMP_FILE" "$URL"
>
> # Check if the download was successful
> if [ $? -eq 0 ]; then
>     # Generate a unique filename based on the current date and time
>     FILENAME="data_$(date +%Y%m%d_%H%M%S).csv"
>
>     # Move the file to the destination folder
>     mv "$TEMP_FILE" "$DEST_FOLDER/$FILENAME"
>
>     echo "CSV file downloaded and moved to $DEST_FOLDER/$FILENAME"
> else
>     echo "Failed to download the CSV file"
>     rm -f "$TEMP_FILE"
> fi
> ```
>
> This script does the following:
>
> 1. It sets the URL of the CSV file to download and the destination folder where the file should be moved[1].
> 2. It creates a temporary file using `mktemp` to store the downloaded content[2].
> 3. It uses `wget` to download the CSV file quietly (-q flag) and save it to the temporary file[1].
> 4. It checks if the download was successful by examining the exit status of `wget`[1].
> 5. If successful, it generates a unique filename based on the current date and time[2].
> 6. It then moves the downloaded file from the temporary location to the destination folder with the new filename[2].
> 7. If the download fails, it prints an error message and removes the temporary file[2].
>
> To use this script:
>
> 1. Replace `"https://example.com/data.csv"` with the actual URL of the CSV file you want to download.
> 2. Replace `"/path/to/destination/folder"` with the actual path where you want to store the downloaded CSV files.
> 3. Save the script with a `.sh` extension (e.g., `download_csv.sh`).
> 4. Make the script executable with `chmod +x download_csv.sh`.
> 5. Run the script with `./download_csv.sh`.
>
> This script ensures that each downloaded file has a unique name based on the download time, preventing overwriting of previous downloads[2].
>
> Citations:
> [1] https://stackoverflow.com/questions/37271513/bash-script-to-download-data-from-url > [2] https://gist.github.com/ufuk/81568e3e71ce98fda59061912453431f > [3] https://help.mabl.com/hc/en-us/articles/19459817511316-Reporting-API-Export-results-to-a-CSV-in-Bash > [4] https://community.spiceworks.com/t/linux-script-to-export-csv-file/706006 > [5] https://www.linuxquestions.org/questions/linux-general-1/how-to-download-this-csv-with-bash-4175687534/ > [6] https://www.unix.com/shell-programming-and-scripting/266725-csv-download-bash-script.htm
