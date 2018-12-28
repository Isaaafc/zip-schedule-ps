# ZipSchedule

Simple PowerShell script to zip multiple directories automatically using 7z.

## Getting Started

Clone/copy the code to your local computer. Create a text file called "directories.txt" in the same folder as the script. Add the source and target directories you want to compress in the following format:

```
path/to/src/dir/1,path/to/tar/dir/1
path/to/src/dir/2,path/to/tar/dir/2
...
```

The script delimits the text file using commas, so make sure there are no commas in your paths.

Download 7za standalone version (not the installed version) here https://www.7-zip.org/download.html and put the 7za.exe in the same folder as the script.

### Using the script

Basic command:

```
powershell -Command ".\zipSchedulePs.ps1"
```

Use the *-mode* param to specify the mode - "year"/"month"/"day"/"all". The default is "all", which zips all subfolders in the source directory into separate files. All the other modes assume your folders are in *yyyyMMdd* format.

Include the *-delete* flag to delete the files after zipping and testing.

Include the *-yeardir* flag to group the output .7z files in year folders

### Execution policy

If you get the error "File xxx cannot be loaded because running scripts is disabled on this system..." add the *-ExecutionPolicy* param to your command:

```
powershell -ExecutionPolicy ByPass -Command ".\zipSchedulePs.ps1"
```

## License

This project is licensed under the MIT License