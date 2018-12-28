param (
    # "all" - all files separately,
    # "day" - zip by day, "month" - zip by month, "year" - zip by year
    [validateset("all", "day", "month", "year")][string] $mode = "all",
    [switch] $yeardir,
    [switch] $delete
)

function Is-Numeric ($Value) {
    return $Value -match "^\d{8}$"
}

cd $PSScriptRoot

$list = Get-Content .\directories.txt

foreach ($line in $list) {
    $split = $line.split(',')
    
    $src = $split[0]
    $tar = $split[1]

    if ($mode -eq "all") {
        Get-ChildItem $src -Directory | ForEach-Object {
            $tarPath = Join-Path -Path $tar -ChildPath $_.Name
            $srcPath = Join-Path -Path $src -ChildPath $_.Name

            .\7za.exe a $tarPath $srcPath
            .\7za.exe t ($tarPath + ".7z")

            
            if (($delete) -and ($lastexitcode -eq 0)) {
                "Deleting source.."

                Remove-Item $srcPath -Force -Recurse
            }
        }
    } else {
        $grpLen = 6

        switch ($mode) {
            "year" {
                $grpLen = 4
            }
            "month" {
                $grpLen = 6
            }
            "day" {
                $grpLen = 8
            }
        }

        Get-ChildItem $src -Directory | Where-Object { Is-Numeric $_.Name } | Group-Object -Property { $_.Name.Substring(0, $grpLen) } | ForEach-Object {
            $tarPath = ""

            if ($yeardir) {
                $tarPath = Join-Path -Path $tar -ChildPath $_.Name.Substring(0, 4) | Join-Path -ChildPath $_.Name
            } else {
                $tarPath = Join-Path -Path $tar -ChildPath $_.Name
            }

            $srcPath = Join-Path -Path $src -ChildPath ($_.Name + "*")

            .\7za.exe a $tarPath $srcPath
            .\7za.exe t ($tarPath + ".7z")

            if (($delete) -and ($lastexitcode -eq 0)) {
                "Deleting source.."

                Remove-Item $srcPath -Force -Recurse
            }
        }
    }
}