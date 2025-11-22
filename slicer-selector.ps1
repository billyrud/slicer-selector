Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Get file(s) robustly ---
$cmdLine = [Environment]::CommandLine
$matches = [regex]::Matches($cmdLine, '("[^"]+"|\S+)') | ForEach-Object { $_.Value }
$Files = $matches[1..($matches.Count-1)] | ForEach-Object { $_.Trim('"') }

if (-not $Files -or $Files.Count -eq 0) {
    [System.Windows.Forms.MessageBox]::Show("No file selected.")
    exit
}

# --- Main GUI ---
function Main {
    param([string[]]$Files)

    # Slicers with executable paths
    $slicers = @{
        "Bambu Studio"   = "C:\Program Files\Bambu Studio\bambu-studio.exe"
        "OrcaSlicer"     = "C:\Program Files\OrcaSlicer\orca-slicer.exe"
        "Creality Print" = "C:\Program Files\Creality\Creality Print 6.3\CrealityPrint.exe"
        "PrusaSlicer"    = "C:\Program Files\Prusa3D\PrusaSlicer\prusa-slicer.exe"
        "Snapmaker Orca" = "C:\Program Files\Snapmaker_Orca\snapmaker-orca.exe"
    }

    # Keep only installed slicers
    $slicers = $slicers.GetEnumerator() | Where-Object { Test-Path $_.Value } | ForEach-Object { @{ $_.Key = $_.Value } }
    if ($slicers.Count -eq 0) { [System.Windows.Forms.MessageBox]::Show("No slicers found."); return }

    # Create form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Open With Slicer"
    $form.Size = New-Object System.Drawing.Size(500,150)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = 'FixedDialog'
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false

    $x = 20
    $y = 20
    $buttonHeight = 64
    $buttonWidth = 64
    $spacing = 20

    foreach ($slicer in $slicers) {

        # Extract name/exe path
        $name = $slicer.Keys | Select-Object -First 1
        $exePath = $slicer[$name]

        # Extract icon
        try {
            $icon = [System.Drawing.Icon]::ExtractAssociatedIcon($exePath)
            $bmp = $icon.ToBitmap()
        } catch {
            $bmp = New-Object System.Drawing.Bitmap $buttonWidth, $buttonHeight
            $g = [System.Drawing.Graphics]::FromImage($bmp)
            $g.Clear([System.Drawing.Color]::Gray)
            $g.Dispose()
        }

        # Make the button
        $btn = New-Object System.Windows.Forms.Button
        $btn.Size = New-Object System.Drawing.Size($buttonWidth, $buttonHeight)
        $btn.Location = New-Object System.Drawing.Point($x, $y)
        $btn.Image = $bmp
        $btn.Text = ""
        $btn.FlatStyle = 'Flat'

        # Freeze the current exe path inside a closure
        $exeCopy = $exePath
        $filesCopy = $Files

        $handler = {
            foreach ($file in $filesCopy) {
                & $exeCopy $file
            }
            $form.Close()
        }.GetNewClosure()   # <<< THIS is the fix.

        $btn.Add_Click($handler)

        $form.Controls.Add($btn)
        $x += $buttonWidth + $spacing
    }

    $form.Topmost = $true
    $form.Add_Shown({ $form.Activate() })
    [void]$form.ShowDialog()
}

# --- Launch ---
$null = Main $Files
