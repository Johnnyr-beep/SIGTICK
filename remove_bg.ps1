Add-Type -AssemblyName System.Drawing

$srcPath = "$PSScriptRoot\src\IMG\LOGOFINAL.jpeg"
$src = [System.Drawing.Image]::FromFile($srcPath)

# Crear bitmap con transparencia
$bmp = New-Object System.Drawing.Bitmap(2250, 2086, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.Clear([System.Drawing.Color]::Transparent)
$g.DrawImage($src, 0, 0, 2250, 2086)
$g.Dispose()
$src.Dispose()

# Bloquear bits para acceso rápido
$rect = New-Object System.Drawing.Rectangle 0, 0, $bmp.Width, $bmp.Height
$bmpData = $bmp.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadWrite, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$ptr = $bmpData.Scan0
$bytes = $bmpData.Stride * $bmp.Height
$rgbValues = New-Object byte[] $bytes
[System.Runtime.InteropServices.Marshal]::Copy($ptr, $rgbValues, 0, $bytes)

# Recorrer pixeles (BGRA en memoria)
for ($i = 0; $i -lt $bytes; $i += 4) {
    $b = $rgbValues[$i]
    $g2 = $rgbValues[$i + 1]
    $r = $rgbValues[$i + 2]
    if ($r -gt 235 -and $g2 -gt 235 -and $b -gt 235) {
        $rgbValues[$i + 3] = 0  # Alpha 0
    }
}

[System.Runtime.InteropServices.Marshal]::Copy($rgbValues, 0, $ptr, $bytes)
$bmp.UnlockBits($bmpData)

# Guardar en todos los logos
$logos = Get-ChildItem "$PSScriptRoot\public\pics\logos\*.png"
foreach ($logo in $logos) {
    $bmp.Save($logo.FullName, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Output "Reemplazado: $($logo.Name)"
}
$bmp.Dispose()
