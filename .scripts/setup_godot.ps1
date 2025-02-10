cd ..

$godot_version = "4.3-stable"
$godot_executable_name = "Godot_v${godot_version}_win64.exe"

$godot_path = ".\.tools\Godot_v$godot_version"

if (-not (Test-Path $godot_path)) {
    mkdir ".\tmp" > $null
    
    mkdir $godot_path > $null
    Write-Host "Baixando e extraindo o Godot v$godot_version para a pasta $(Resolve-Path $godot_path)..."
    Invoke-WebRequest -Uri "https://github.com/godotengine/godot-builds/releases/download/$godot_version/$godot_executable_name.zip" -OutFile ".\tmp\$godot_executable_name.zip"

    Expand-Archive -Path ".\tmp\$godot_executable_name.zip" -DestinationPath $godot_path
    
    Remove-Item -Path ".\tmp" -Recurse
}

Start-Process "$godot_path\$godot_executable_name" -ArgumentList "--editor", ((Get-Location).Path)