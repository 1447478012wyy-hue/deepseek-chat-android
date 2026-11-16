# Renders resources/*.html to PNG with headless Edge, then writes Android launcher icons.
# Usage: powershell -File resources\make-icons.ps1   (from the project root)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$root = Split-Path -Parent $PSScriptRoot
$res = Join-Path $root 'resources'
$out = Join-Path $root 'android\app\src\main\res'

$edge = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe' -ErrorAction SilentlyContinue).'(default)'
if (-not $edge) { $edge = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe" }

function Render($name) {
  $html = Join-Path $res "$name.html"
  $png = Join-Path $res "$name.png"
  if (Test-Path $png) { Remove-Item $png }
  $url = 'file:///' + ($html -replace '\\', '/')
  # Edge reports progress on stderr; run it through cmd so PowerShell does not treat that as an error
  cmd /c "`"$edge`" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 --default-background-color=00000000 --window-size=1024,1024 `"--screenshot=$png`" `"$url`" 2>nul" | Out-Null
  for ($i = 0; $i -lt 20 -and -not (Test-Path $png); $i++) { Start-Sleep -Milliseconds 300 }
  return $png
}

function Resize($src, $dst, $size, [switch]$Round) {
  $img = [System.Drawing.Image]::FromFile($src)
  $bmp = New-Object System.Drawing.Bitmap $size, $size, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = 'HighQualityBicubic'
  $g.SmoothingMode = 'AntiAlias'
  $g.PixelOffsetMode = 'HighQuality'
  $g.Clear([System.Drawing.Color]::Transparent)
  if ($Round) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddEllipse(0, 0, $size, $size)
    $g.SetClip($path)
  }
  $g.DrawImage($img, 0, 0, $size, $size)
  $g.Dispose(); $img.Dispose()
  $bmp.Save($dst, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
}

$full = Render 'icon'
$fg = Render 'icon-foreground'
$sizes = @{ mdpi = 48; hdpi = 72; xhdpi = 96; xxhdpi = 144; xxxhdpi = 192 }
foreach ($d in $sizes.Keys) {
  $dir = Join-Path $out "mipmap-$d"
  $s = $sizes[$d]
  Resize $full (Join-Path $dir 'ic_launcher.png') $s
  Resize $full (Join-Path $dir 'ic_launcher_round.png') $s -Round
  # adaptive foreground canvas is 108dp vs 48dp legacy icon
  Resize $fg (Join-Path $dir 'ic_launcher_foreground.png') ([int]($s * 108 / 48))
}
'icons written'
