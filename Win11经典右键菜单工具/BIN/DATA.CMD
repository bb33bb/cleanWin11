@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

SET KK=N
if "%~2"=="+" SET KK=Y
if %~2 GEQ 65 SET KK=Y
SET ST1="HKLM\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\15\586118283"
SET "ST=\{BB06C0E4-D293-4f75-8A90-CB05B6477EED}"
SET "SB=%Windir%\Branding\shellbrd\shellbrd.dll"
if %~1 EQU 1 CAll :Win10
if %~1 EQU 0 CAll :Win11
Exit

:Win10
REM 更改为Win10风格的系统属性UI
reg add %ST1% /f /v "EnabledState" /t REG_DWORD /d 1 >nul
reg add %ST1% /f /v "EnabledStateOptions" /t REG_DWORD /d 1 >nul
reg add %ST1% /f /v "Variant" /t REG_DWORD /d 0 >nul
reg add %ST1% /f /v "VariantPayload" /t REG_DWORD /d 0 >nul
reg add %ST1% /f /v "VariantPayloadKind" /t REG_DWORD /d 0 >nul
reg add "HKCR\CLSID%ST%" /f /ve /t REG_SZ /d "System" >nul
reg add "HKCR\CLSID%ST%" /f /v "InfoTip" /t REG_EXPAND_SZ /d "@%%SystemRoot%%\System32\systemcpl.dll,-2#immutable1" >nul
reg add "HKCR\CLSID%ST%" /f /v "LocalizedString" /t REG_EXPAND_SZ /d "@%%SystemRoot%%\System32\systemcpl.dll,-1#immutable1" >nul
reg add "HKCR\CLSID%ST%" /f /v "System.ApplicationName" /t REG_SZ /d "Microsoft.System" >nul
reg add "HKCR\CLSID%ST%" /f /v "System.ControlPanel.Category" /t REG_SZ /d "5" >nul
reg add "HKCR\CLSID%ST%" /f /v "System.ControlPanel.EnableInSafeMode" /t REG_DWORD /d 3 >nul
reg add "HKCR\CLSID%ST%" /f /v "System.Software.TasksFileUrl" /t REG_SZ /d "Internal" >nul
reg add "HKCR\CLSID%ST%\DefaultIcon" /f /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\imageres.dll,-149" >nul
reg add "HKCR\CLSID%ST%\InProcServer32" /f /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\shdocvw.dll" >nul
reg add "HKCR\CLSID%ST%\InProcServer32" /f /v "ThreadingModel" /t REG_SZ /d "Apartment" >nul
reg add "HKCR\CLSID%ST%\Instance" /f /v "CLSID" /t REG_SZ /d "{328B0346-7EAF-4BBE-A479-7CB88A095F5B}" >nul
reg add "HKCR\CLSID%ST%\Instance\InitPropertyBag" /f /v "ResourceDLL" /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\systemcpl.dll" >nul
reg add "HKCR\CLSID%ST%\Instance\InitPropertyBag" /f /v "ResourceID" /t REG_DWORD /d 100 >nul
reg add "HKCR\CLSID%ST%\ShellFolder" /f /v "Attributes" /t REG_DWORD /d 2684354560 >nul
reg add "HKCR\CLSID%ST%\ShellFolder" /f /v "WantsParseDisplayName" /t REG_SZ /d "" >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\NameSpace%ST%" /f /ve /t REG_SZ /d "System" >nul
if exist "%~dp0shellbrd.dll" (
	if not exist "%SB%bak" REN "%SB%" shellbrd.dllbak
	copy "%~dp0shellbrd.dll" "%SB%" /y >nul
)
if "%KK%"=="Y" (
	if exist "%~dp0shell32.dll" (
		taskkill /f /im explorer.exe
		if !errorlevel! EQU 0 (
			if not exist "%windir%\system32\shell32.65+" (ren "%windir%\system32\shell32.dll"  shell32.65+ >nul) else (del "%windir%\system32\shell32.dll" /f /q >nul)
			copy "%~dp0shell32.dll" "%windir%\system32" /y >nul
		)
	)
)
Goto :EOF


:Win11
REM 还原为Win11风格的系统属性UI
reg delete %ST1% /f 
reg delete "HKCR\CLSID%ST%" /f >nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\NameSpace%ST%" /f >nul
if exist "%SB%bak" del "%SB%" /f /q && REN "%SB%bak" shellbrd.dll
if exist "%Windir%\system32\shell32.65+" (
	taskkill /f /im explorer.exe
	if !errorlevel! EQU 0 (
		del "%windir%\system32\shell32.dll" /f /q >nul
		ren "%windir%\system32\shell32.65+" shell32.dll >nul
	)
)
Goto :EOF