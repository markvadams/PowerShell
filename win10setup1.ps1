######################################################
# WINDOWS 10 DOMAIN SETUP
# Run in elevated mode
# Restart required for certain settings to take effect
######################################################
# Turn off Telemetry
Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name AllowTelemetry -Type DWord -Value 0
Get-Service DiagTrack,Dmwappushservice | Stop-Service | Set-Service -StartupType Disabled
# Privacy: Let apps use my advertising ID: Disable
New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion -Name AdvertisingInfo
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -Type DWord -Value 0
# Privacy: SmartScreen Filter for Store Apps: Disable
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost -Name EnableWebContentEvaluation -Type DWord -Value 0
# Disable WiFi Sense
New-Item -Path HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi -Name AllowWiFiHotSpotReporting
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting -Name value -Type DWord -Value 0
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots -Name value -Type DWord -Value 0
# Disable P2P Update downloads outside of local network
New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ -Name DeliveryOptimization
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config -Name DODownloadMode -Type DWord -Value 1
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization -Name SystemSettingsDownloadMode -Type DWord -Value 3
# Change Windows Updates to "Notify to schedule restart"
mkdir -Force "HKCU:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name UxOption -Type DWord -Value 1
# Start Menu: Disable Bing Search Results
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -Type DWord -Value 0
# Stop Getting to Know Me settings
mkdir -Force "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
mkdir -Force "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore"
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore -Name HarvestContacts -Type DWord -Value 0
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\InputPersonalization -Name RestrictImplicitInkCollection -Type DWord -Value 1
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\InputPersonalization -Name RestrictImplicitTextCollection -Type DWord -Value 1