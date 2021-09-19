@echo off
mode con cols=85 lines=30
ver | find "版本" >nul && title 沧水的KMS脚本 || title Cangshui's KMS script
setlocal EnableDelayedExpansion&color 70 & cd /d "%~dp0"
%1 %2
ver | find "5."> NUL && goto :start
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :start","","runas",1)(window.close)&goto :eof
:start
set KMS_Sev=kms.cangshui.net
ver | find "6.0." > NUL &&  set winv=vista
ver | find "6.1." > NUL &&  set winv=7
ver | find "6.2." > NUL &&  set winv=8
ver | find "6.3." > NUL &&  set winv=8.1
ver | find "10.0." > NUL &&  set winv=10
ver | find "版本" >nul && echo 提问建议请留言http://kms.cangshui.net || echo Feedback: http://kms.cangshui.net
ver | find "版本" >nul && echo 捐赠赞助请访问http://shop.cangshui.net || echo Tip: http://shop.cangshui.net
ver | find "版本" >nul && echo 【A】KMS激活Windows || echo [A] KMS activate windows
ver | find "版本" >nul && echo 【B】KMS激活Office || echo [B] KMS activate Office
ver | find "版本" >nul && echo 【C】清除Windows KMS || echo [C] Clear Windows KMS
ver | find "版本" >nul && echo 【D】清除Office KMS || echo [D] Clear Office KMS
ver | find "版本" >nul && echo 【E】查看支持的windows版本 || echo [E] Supported windows version
ver | find "版本" >nul && set /p xuanze=请输入你的选择: || set /p xuanze=Please enter your choice:
if /i "%xuanze%"=="a" cls&goto start1
if /i "%xuanze%"=="b" cls&goto start2
if /i "%xuanze%"=="c" cls&goto start3
if /i "%xuanze%"=="d" cls&goto start4
if /i "%xuanze%"=="e" cls&goto start5
if /i "%xuanze%"=="g" cls&goto Feedback

:start2
cls
echo.
ver | find "版本" >nul && echo 提问建议请留言http://kms.cangshui.net || echo Feedback: http://kms.cangshui.net
ver | find "版本" >nul && echo 捐赠赞助请访问http://shop.cangshui.net || echo Tip: http://shop.cangshui.net
echo.
if  "%KMS_Sev%"=="kms.cangshui.net" (
    echo 正在检查能否连接到KMS主服务器...
    ) else (
    echo 连接到KMS主服务器失败，已切换至备用服务器...
)
dir /a "tcping.exe" | find "258,560"  > NUL && set tcpingstatus=successful
if  "%tcpingstatus%"=="successful" (
    echo tcping命令可用...若等待时间超过60秒可尝试重新运行脚本 && tcping.exe %KMS_Sev% 1688 | find "0 successful" > NUL && goto failb
    ) else (
       if  "%winv%"=="10" (
          echo ======================================提示信息=======================================
          echo 因系统自带的ping命令无法准确判断服务器是否可用，因此将自动下载TCPing工具
          echo TCPing为安全的开源工具，开源地址为https://github.com/jtilander/tcping
          echo 尝试下载TCPing测试组件...
          echo ======================================提示信息=======================================          
          curl --ssl-no-revoke --connect-timeout 3 -m 10 -s -O https://kms.cangshui.net/kms/tcping.exe    
        ) else (
          echo. 
        )
) 


dir /a "tcping.exe" | find "258,560"  > NUL && set tcpingstatus2=successful
if  "%tcpingstatus2%"=="successful" (
    if "%tcpingstatus%"=="successful" ( echo. ) else ( echo tcping命令可用...若等待时间超过60秒可尝试重新运行脚本 && tcping.exe %KMS_Sev% 1688 | find "0 successful" > NUL && goto failb)
) else (
        if  "%winv%"=="10" (
          echo TCPing因下载失败或其他原因导致不可用，采用ping来检测服务器是否可用，它的测试结果并不一定准确   
        ) else (
          echo ======================================提示信息=======================================
          echo 你的系统非windows10及以上版本 无法自动下载TCPing工具
          echo 因此只采用ping来检测服务器是否可用，它的测试结果并不一定准确
          echo 你可以自行下载从https://kms.cangshui.net/kms/tcping.exe下载它
          echo 将其放置在本脚本同目录下，重新运行脚本即可
          echo TCPing工具仅为检测服务器是否可用，缺失也可以正常激活系统
          echo TCPing为安全的开源工具，开源地址为https://github.com/jtilander/tcping
          echo ======================================提示信息=======================================
        )
    echo.
    echo 开始Ping测试...若等待时间超过60秒可尝试重新运行脚本
    ping %KMS_Sev% | find "超时"  > NUL &&  goto failb
    ping %KMS_Sev% | find "timed out"  > NUL &&  goto failb
    ping %KMS_Sev% | find "找不到主机"  > NUL &&  goto failb
    ping %KMS_Sev% | find "not find host"  > NUL &&  goto failb
    ping %KMS_Sev% | find "失败"  > NUL &&  goto failb
    ping %KMS_Sev% | find "fail"  > NUL &&  goto failb    
)


if  "%KMS_Sev%"=="kms.cangshui.net" (
    echo 本机能够正常连接KMS主服务器...
    ) else (
    echo 本机能够正常连接KMS备用服务器...
)
goto office

:office
echo 检查安装的office……
call :GetOfficePath 14 Office2010
call :ActOffice 14 Office2010
call :GetOfficePath 15 Office2013
call :ActOffice 15 Office2013
if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" set _Office16Path=%ProgramFiles%\Microsoft Office\Office16
if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" set _Office16Path=%ProgramFiles(x86)%\Microsoft Office\Office16
if DEFINED _Office16Path (echo.&echo 已发现 Office2016系列软件[包括2016/2019/365/2021]
    ping 127.0.0.1 -n 2 > nul
    call :ActOffice 16 Office2016
  ) else (echo.&echo 未发现 Office2016系列软件[包括2016/2019/365/2021])


echo.&pause
exit

:ActOffice
if DEFINED _Office%1Path (
    cd /d "!_Office%1Path!"
    if %1 EQU 16 call :Licens16
    echo.&echo 尝试激活您的Office ...&echo.
cscript //nologo ospp.vbs /sethst:%KMS_Sev% > NUL
cscript //nologo ospp.vbs /act | find /i "successful" && (
        echo.&echo ***** 激活成功 *****   & echo.) || (echo.&echo ***** 激活失败 ***** & echo.)
)    
cd /d "%~dp0"
goto :EOF

:GetOfficePath
echo.&echo 正在检测 %2 系列产品的安装路径...
set _Office%1Path=
set _Reg32=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\%1.0\Common\InstallRoot
set _Reg64=HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Office\%1.0\Common\InstallRoot
reg query "%_Reg32%" /v "Path" > nul 2>&1 && FOR /F "tokens=2*" %%a IN ('reg query "%_Reg32%" /v "Path"') do SET "_OfficePath1=%%b"
reg query "%_Reg64%" /v "Path" > nul 2>&1 && FOR /F "tokens=2*" %%a IN ('reg query "%_Reg64%" /v "Path"') do SET "_OfficePath2=%%b"
if DEFINED _OfficePath1 (if exist "%_OfficePath1%ospp.vbs" set _Office%1Path=!_OfficePath1!)
if DEFINED _OfficePath2 (if exist "%_OfficePath2%ospp.vbs" set _Office%1Path=!_OfficePath2!)
set _OfficePath1=
set _OfficePath2=
if DEFINED _Office%1Path (echo.&echo 已发现 %2) else (echo.&echo 未发现 %2)
goto :EOF

:Licens16
cls
echo 【A】激活为Office2021版本(仅2021及以上版本可选)
echo 【B】激活为Office2019版本(仅2019及以上版本可选)
echo 【C】激活为Office2016版本(全版本通用)
echo PS：Office365版本是没有批量激活版的，如果你是365版本选C即可
set /p xuanze=请选择...
if /i "%xuanze%"=="a" cls&goto installOffice21
if /i "%xuanze%"=="b" cls&goto installOffice19
if /i "%xuanze%"=="c" cls&goto installOffice16


:installOffice21
echo 安装2021证书
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021vl_mak_ae3-ppd.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021vl_mak_ae3-ul-oob.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021vl_mak_ae3-ul-phn.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021vl_mak_ae3-pl.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021vl_mak_ae2-ppd.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021vl_mak_ae2-ul-oob.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021vl_mak_ae2-ul-phn.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021vl_mak_ae2-pl.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021vl_mak_ae1-ppd.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021vl_mak_ae1-ul-oob.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021vl_mak_ae1-ul-phn.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021vl_mak_ae1-pl.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021vl_kms_client_ae-ppd.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021vl_kms_client_ae-ul-oob.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021vl_kms_client_ae-ul.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021previewvl_mak_ae-ppd.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021previewvl_mak_ae-ul-oob.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021previewvl_mak_ae-ul-phn.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021previewvl_mak_ae-pl.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021previewvl_kms_client_ae-ppd.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021previewvl_kms_client_ae-ul-oob.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2021previewvl_kms_client_ae-ul.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\client-issuance-bridge-office.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\client-issuance-root-bridge-test.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\client-issuance-ul-oob.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\client-issuance-ul.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\client-issuance-stil.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\client-issuance-root.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\pkeyconfig-office-client15.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\pkeyconfig-office.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
cscript "%_Office16Path%\ospp.vbs" /inpkey:HFPBN-RYGG8-HQWCW-26CH6-PDPVF > NUL
goto :EOF
exit

:installOffice19
echo 安装2019证书
for /f %%x in ('dir /b ..\root\Licenses16\proplus2019xc2rvl_makc2r-ppd.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2019xc2rvl_makc2r-ul-oob.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2019xc2rvl_makc2r-ul-phn.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2019xc2rvl_makc2r-pl.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2019xc2rvl_kms_clientc2r-ppd.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2019xc2rvl_kms_clientc2r-ul-oob.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2019xc2rvl_kms_clientc2r-ul.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2019vl_mak_ae-ppd.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2019vl_mak_ae-ul-oob.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2019vl_mak_ae-ul-phn.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2019vl_mak_ae-pl.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2019vl_kms_client_ae-ppd.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2019vl_kms_client_ae-ul-oob.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplus2019vl_kms_client_ae-ul.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\client-issuance-bridge-office.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\client-issuance-root-bridge-test.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\client-issuance-ul-oob.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\client-issuance-ul.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\client-issuance-stil.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\client-issuance-root.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\pkeyconfig-office-client15.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\pkeyconfig-office.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
cscript "%_Office16Path%\ospp.vbs" /inpkey:NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP > NUL
goto :EOF
exit


:installOffice16
echo 安装2016证书
for /f %%x in ('dir /b ..\root\Licenses16\proplusvl_kms*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\proplusvl_mak*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\client-issuance-bridge-office.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\client-issuance-root-bridge-test.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\client-issuance-ul-oob.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\client-issuance-ul.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\client-issuance-stil.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\client-issuance-root.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\pkeyconfig-office-client15.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
for /f %%x in ('dir /b ..\root\Licenses16\pkeyconfig-office.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" > NUL
cscript "%_Office16Path%\ospp.vbs" /inpkey:XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99 > NUL
goto :EOF
exit





:start1
cls
ver | find "版本" >nul && echo 提问建议请留言http://kms.cangshui.net || echo Feedback: http://kms.cangshui.net
ver | find "版本" >nul && echo 捐赠赞助请访问http://shop.cangshui.net || echo Tip: http://shop.cangshui.net
echo.
if  "%KMS_Sev%"=="kms.cangshui.net" (
    echo 正在检查能否连接到KMS主服务器...
    ) else (
    echo 连接到KMS主服务器失败，已切换至备用服务器...
)
dir /a "tcping.exe" | find "258,560"  > NUL && set tcpingstatus=successful
if  "%tcpingstatus%"=="successful" (
    echo tcping命令可用...若等待时间超过60秒可尝试重新运行脚本 && tcping.exe %KMS_Sev% 1688 | find "0 successful" > NUL && goto faila
) else (
       if  "%winv%"=="10" (
          echo ======================================提示信息=======================================
          echo 因系统自带的ping命令无法准确判断服务器是否可用，因此将自动下载TCPing工具
          echo TCPing为安全的开源工具，开源地址为https://github.com/jtilander/tcping
          echo 尝试下载TCPing测试组件...
          echo ======================================提示信息=======================================     
          curl --ssl-no-revoke --connect-timeout 3 -m 10 -s -O https://kms.cangshui.net/kms/tcping.exe   
        ) else (
          echo.
        )
        
) 


dir /a "tcping.exe" | find "258,560"  > NUL && set tcpingstatus2=successful
if  "%tcpingstatus2%"=="successful" (
    if "%tcpingstatus%"=="successful" ( echo. ) else ( echo tcping命令可用...若等待时间超过60秒可尝试重新运行脚本 && tcping.exe %KMS_Sev% 1688 | find "0 successful" > NUL && goto faila)
) else (
    if  "%winv%"=="10" (
          echo TCPing因下载失败或其他原因导致不可用，采用ping来检测服务器是否可用，它的测试结果并不一定准确   
        ) else (
          echo ======================================提示信息=======================================
          echo 你的系统为windows7 无法自动下载TCPing工具
          echo 因此只采用ping来检测服务器是否可用，它的测试结果并不一定准确
          echo 你可以自行下载从https://kms.cangshui.net/kms/tcping.exe下载它
          echo 将其放置在本脚本同目录下，重新运行脚本即可
          echo TCPing工具仅为检测服务器是否可用，缺失也可以正常激活系统
          echo TCPing为安全的开源工具，开源地址为https://github.com/jtilander/tcping
          echo ======================================提示信息=======================================
        )
    echo.
    echo 开始Ping测试...若等待时间超过60秒可尝试重新运行脚本
    ping %KMS_Sev% | find "超时"  > NUL &&  goto faila
    ping %KMS_Sev% | find "timed out"  > NUL &&  goto faila
    ping %KMS_Sev% | find "找不到主机"  > NUL &&  goto faila
    ping %KMS_Sev% | find "not find host"  > NUL &&  goto faila
    ping %KMS_Sev% | find "失败"  > NUL &&  goto faila
    ping %KMS_Sev% | find "fail"  > NUL &&  goto faila    
)

if  "%KMS_Sev%"=="kms.cangshui.net" (
    echo 本机能够正常连接KMS主服务器...
    ) else (
    echo 本机能够正常连接KMS备用服务器...
    )

echo ======================================激活信息=======================================

ver | find "6.0." > NUL &&  goto winvista
ver | find "6.1." > NUL &&  goto win7
ver | find "6.2." > NUL &&  goto win8
ver | find "6.3." > NUL &&  goto win81
ver | find "10.0." > NUL &&  goto win10
echo 未找到合适的NT6系统，可能是WinXP或Win2003。
goto office

:winvista
echo 当前为Windows Vista/2008。
set Business=YFKBB-PQJJV-G996G-VWGXY-2V3X8
set BusinessN=HMBQG-8H2RH-C77VX-27R82-VMQBT
set Enterprise=VKK3X-68KWM-X2YGT-QR4M6-4BWMV
set EnterpriseN=VTC42-BM838-43QHV-84HX6-XJXKV
set ServerWeb=WYR28-R7TFJ-3X2YQ-YCY4H-M249D
set ServerStandard=TM24T-X9RMF-VWXK6-X8JC9-BFGM2
set ServerStandardV=W7VD6-7JFBR-RX26B-YKQ3Y-6FFFJ
set ServerEnterprise=YQGMW-MPWTJ-34KDK-48M3W-X4Q6V
set ServerEnterpriseV=39BXF-X8Q23-P2WWT-38T2F-G3FPG
set ServerWeb=RCTX3-KWVHP-BR6TB-RB6DM-6X7HP
set ServerDatacenter=7M67G-PC374-GR742-YH8V4-TCBY3
set ServerDatacenterV=22XQ2-VRXRG-P8D42-K34TD-G3QQC
set ServerEnterpriseIA64=4DWFP-JF3DJ-B7DTH-78FJB-PDRHK
goto windowsstart

:win7
echo 当前为Windows 7/2008 R2。
for /f "tokens=*" %%i in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductName"') do set ProductNamea=%%i
echo "%ProductNamea%" | find "Ultimate" >nul && (  
  msg %username% /time:99999999 "Windows7 旗舰版无法使用KMS激活！请更换系统版本或采取其他方式激活系统！"
  pause
  exit
  ) || (  
  echo .
)
set Professional=FJ82H-XT6CR-J8D7P-XQJJ2-GPDD4
set ProfessionalN=MRPKT-YTG23-K7D7T-X2JMM-QY7MG
set ProfessionalE=W82YF-2Q76Y-63HXB-FGJG9-GF7QX
set Enterprise=33PXH-7Y6KF-2VJC9-XBBR8-HVTHH
set EnterpriseN=YDRBP-3D83W-TY26F-D46B2-XCKRJ
set EnterpriseE=C29WB-22CC8-VJ326-GHFJW-H9DH4
set ServerWeb=6TPJF-RBVHG-WBW2R-86QPH-6RTM4
set ServerHPC=TT8MH-CG224-D3D7Q-498W2-9QCTX
set ServerStandard=YC6KT-GKW9T-YTKYR-T4X34-R7VHC
set ServerEnterprise=489J6-VHDMP-X63PK-3K798-CPX3Y
set ServerDatacenter=74YFP-3QFB3-KQT8W-PMXWJ-7M648
set ServerEnterpriseIA64=GT63C-RJFQ3-4GMB6-BRFB9-CB83V
goto windowsstart

:win8
echo 当前为Windows 8/2012。
set Professional=NG4HW-VH26C-733KW-K6F98-J8CK4
set ProfessionalN=XCVCF-2NXM9-723PB-MHCB7-2RYQQ
set Core=BN3D2-R7TKB-3YPBD-8DRP2-27GG4
set Enterprise=32JNW-9KQ84-P47T8-D8GGY-CWCK7
set EnterpriseN=JMNMF-RHW7P-DMY6X-RF3DR-X2BQT
set CoreN=8N2M2-HWPGY-7PGT9-HGDD8-GVGGY
set CoreSingleLanguage=2WN2H-YGCQR-KFX6K-CD6TF-84YXQ
set CoreCountrySpecific=4K36P-JN4VD-GDC6V-KDT89-DYFKP
set ServerMultiPointPremium=XNH6W-2V9GX-RGJ4K-Y8X6F-QGJ2G
set ServerMultiPointStandard=HM7DN-YVMH3-46JC3-XYTG7-CYQJJ
set ServerStandard=XC9B7-NBPP2-83J2H-RHMBY-92BT4
set ServerDatacenter=48HP8-DN98B-MYWDG-T2DCC-8W83P
goto windowsstart

:win81
echo 当前为Windows 8.1。
set Professional=GCRJD-8NW9H-F2CDX-CCM8D-9D6T9
set ProfessionalN=HMCNV-VVBFX-7HMBH-CTY9B-B4FXY
set Enterprise=MHF9N-XY6XB-WVXMC-BTDCT-MKKG7
set EnterpriseN=TT4HM-HN7YT-62K67-RGRQJ-JFFXW
set ServerSolution=KNC87-3J2TX-XB4WP-VCPJV-M4FWM
set ServerStandard=D2N9P-3P6X9-2R39C-7RTCD-MDVJX
set ServerDatacenter=W3GGN-FT8W3-Y4M27-J84CP-Q3VJ9
set EmbeddedIndustry=32JNW-9KQ84-P47T8-D8GGY-CWCK7
goto windowsstart

:win10
for /f "tokens=*" %%i in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductName"') do set ProductNameb=%%i
echo "%ProductNameb%" | find "Server" >nul && (  
  goto win10Server
  ) || (  
    echo "%ProductNameb%" | find "Enterprise" >nul && (  
      goto win10Enterprise
      ) || (  
      echo 当前为Windows 10。
      )
)
set Core=TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
set CoreCountrySpecific=PVMJN-6DFY6-9CCP6-7BKTT-D3WVR
set CoreN=3KHY7-WNT83-DGQKR-F7HPR-844BM
set CoreSingleLanguage=7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH
set Professional=W269N-WFGWX-YVC9B-4J6C9-T83GX
set ProfessionalN=MH37W-N47XK-V7XM9-C7227-GCQG9
set Education=NW6C2-QMPVW-D7KKK-3GKT6-VCFB2
set EducationN=2WH4N-8QGBV-H22JP-CT43Q-MDWWJ
set ProfessionalEducation=6TP4R-GNPTD-KYYHQ-7B7DP-J447Y
set ProfessionalEducationN=YVWGF-BXNMC-HTQYQ-CPQ99-66QFC
set ProfessionalWorkstation=NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J
set ProfessionalWorkstations=NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J
set ProfessionalWorkstationsN=9FNHH-K3HBT-3W4TD-6383H-6XYWF
goto windowsstart


:win10Enterprise
for /f "tokens=*" %%i in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductName"') do set ProductNameh=%%i
echo "%ProductNameh%" | findstr "2019" >nul && ( 
  echo 当前为Windows Enterprise LTSC 2019。 
  set EnterpriseS=M7XTQ-FN8P6-TTKYV-9D4CC-J462D
  set EnterpriseSN=92NFX-8DJQP-P6BBQ-THF9C-7CG2H
  ) || ( 
       echo "%ProductNameh%" | findstr "2016" >nul && ( 
         echo 当前为Windows Enterprise LTSB 2016。 
         set EnterpriseS=DCPHK-NFMTC-H88MJ-PFHPY-QJ4BJ
         set EnterpriseSN=QFFDN-GRT3P-VKWWX-X7T3R-8B639
         ) || (
              echo "%ProductNameh%" | findstr "2015" >nul && ( 
                echo 当前为Windows Enterprise LTSB 2015。
                set EnterpriseS=WNMTR-4C88C-JK8YV-HQ7T2-76DF9
                set EnterpriseSN=2F77B-TNFGY-69QQF-B8YKP-D69TJ
                ) || (
                echo 可能是某种企业定制版本...不保证能激活成功...
                set EnterpriseS=WNMTR-4C88C-JK8YV-HQ7T2-76DF9
                set EnterpriseSN=2F77B-TNFGY-69QQF-B8YKP-D69TJ
                set EnterpriseG=YYVX9-NTFWV-6MDM3-9PT4T-4M68B
                set EnterpriseGN=44RPN-FTY23-9VTTB-MP9BX-T84FV
                set Enterprise=NPPR9-FWDCX-D2C8J-H872K-2YT43
                set EnterpriseN=DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4
              )
        )
)       
goto windowsstart




:win10Server
for /f "tokens=*" %%i in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductName"') do set ProductNamec=%%i
echo "%ProductNamec%" | findstr "2022" >nul && ( 
  echo 当前为Windows server 2022。 
  set ServerDatacenter=WX4NM-KYWYW-QJJR4-XV3QB-6VM33
  set ServerStandard=VDYBN-27WPP-V4HQT-9VMD4-VMK7H
  ) || ( 
       echo "%ProductNamec%" | findstr "2019" >nul && ( 
         echo 当前为Windows server 2019。 
         set ServerDatacenter=WMDGN-G9PQG-XVVXX-R3X43-63DFG
         set ServerStandard=N69G4-B89J2-4G8F4-WWYCC-J464C
         set ServerEssentials=WVDHN-86M7X-466P6-VHXV7-YY726
         set ServerRdsh=CPWHC-NT2C7-VYW78-DHDB2-PG3GK
         ) || ( 
              echo "%ProductNamec%" | findstr "2016" >nul && ( 
                echo 当前为Windows server 2016。 
                set ServerDatacenter=CB7KF-BWN84-R7R2Y-793K2-8XDDG
                set ServerStandard=WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY
                set ServerEssentials=JCKRF-N37P4-C2D82-9YXRT-4M63B
                ) || ( 
                echo 无法识别系统版本……
                goto Feedback
              )
          
        )
)
goto windowsstart



:windowsstart
echo 设置Windows Update 服务为自动并运行...
sc config wuauserv start=auto > NUL
set winupdate=0
net start | find "Windows Update" > NUL && set winupdate=1
if "%winupdate%"==0 ( echo. > NUL ) else ( net start wuauserv > NUL )
for /f "tokens=3 delims= " %%i in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "EditionID"') do set EditionID=%%i
if defined %EditionID% (
  echo 版本ID为%EditionID%
  goto windowsstart2
) else (
	echo 找不到序列号……
  goto Feedback
)
echo.&pause
exit

:windowsstart2
for /f "delims=" %%i in ('cscript //Nologo %windir%\system32\slmgr.vbs /ipk !%EditionID%!') do set kmsresulta=%%i
echo %kmsresulta%
echo %kmsresulta% | find "非核心版本的计算机" > NUL && goto keyerror
echo %kmsresulta% | find "Windows non-core edition" > NUL && goto keyerror
cscript //Nologo %windir%\system32\slmgr.vbs /skms %KMS_Sev%
for /f "delims=" %%i in ('cscript //Nologo %windir%\system32\slmgr.vbs /ato') do set kmsresultc=%%i
echo %kmsresultc%
echo %kmsresultc% | find "无法联系任何密钥管理服务" > NUL && set retrya=1 && goto networkerror
echo %kmsresultc% | find "could be contacted" > NUL && set retrya=1 && goto networkerror 
echo ======================================激活信息======================================
echo.&pause
exit

:start4
set nextunnum=0
echo 是否真的要清除Office的KMS激活(仅支持Office2016及以上版本)？
set /p xuanze=【Y】继续   【N】关闭
if /i "%xuanze%"=="y" goto nextun
if /i "%xuanze%"=="n" exit

:nextun
if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs"  (
goto nextun64
) else (
goto nextun32
)

:nextun64
cscript "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" /dstatus | find  /I "No installed product keys detected"  > NUL && goto nextunsuccess
for /f "tokens=*" %%i in (' cscript "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" /dstatus  ^| find /I "Last 5 characters of installed product key:" ') do set office5key=%%i
set "office5key=%office5key:~-5,5%"
cscript  "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" /unpkey:%office5key% > NUL
cscript  "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" /remhst > NUL
set /a nextunnum+=1
cls
echo 清除进度%nextunnum%/10
if "%nextunnum%"=="10" ( goto nextunsuccess )
goto nextun64
pause
exit

:nextun32
cscript "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" /dstatus | find  /I "No installed product keys detected"  > NUL && goto nextunsuccess
for /f "tokens=*" %%i in (' cscript "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" /dstatus  ^| find /I "Last 5 characters of installed product key:" ') do set office5key=%%i
set "office5key=%office5key:~-5,5%"
cscript  "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" /unpkey:%office5key% > NUL
cscript  "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" /remhst > NUL
set /a nextunnum+=1
cls
echo 清除进度%nextunnum%/10
if "%nextunnum%"=="10" ( goto nextunsuccess )
goto nextun32
pause
exit

:nextunsuccess
cls
echo 清除完成
pause
exit

:start3
set /p xuanze=是否真的要清除Windows的KMS？【Y】继续   【N】关闭
if /i "%xuanze%"=="y" goto nextunw
if /i "%xuanze%"=="n" exit
:nextunw
slmgr /upk
slmgr /ckms
slmgr /rearm
cls
echo 清除完成，请重启电脑
ping 127.0.0.1 -n 10 > nul



:start5
cls
echo.
echo windows 11：
echo Windows 11 教育版                    Windows 11 专业教育版
echo Windows 11 企业版                    Windows 11 专业工作站版
echo Windows 11 专业版    
echo. 
echo Windows 10：
echo Windows 10 教育版                    Windows 10 专业教育版
echo Windows 10 企业版                    Windows 10 专业工作站版 
echo Windows 10 专业版                 
echo. 
echo Windows Server：
echo Windows Server version 1709-1909 数据中心版  Windows Server version 1709-1909 标准版
echo Windows Server 2012 数据中心版                         Windows Server 2012 标准版
echo Windows Server 2016 数据中心版                         Windows Server 2016 标准版
echo Windows Server 2019 数据中心版                         Windows Server 2019 标准版
echo Windows Server 2022 数据中心版                         Windows Server 2022 标准版
echo.
echo Windows Enterprise：
echo Windows LTSC 2019                   Windows LTSB 2016
echo Windows LTSB 2015
echo. 
echo Windows 8.1：
echo Windows 8.1 专业版                    Windows 8.1 企业版
echo. 
echo Windows 7：
echo Windows 7 专业版                       Windows 7 企业版
pause
cls
goto start




:faila
cls
if  "%KMS_Sev%"=="kms.cangshui.net" (
    set KMS_Sev=kms9.MSGuides.com && goto start1
    ) else (
    ver | find "版本" >nul && echo 连接到KMS主/备服务器皆失败，请重新运行脚本或检查计算机网络设置... || echo Unable to connect to KMS server
    )
pause



:failb
cls
if  "%KMS_Sev%"=="kms.cangshui.net" (
    set KMS_Sev=kms9.MSGuides.com && goto start2
    ) else (
    ver | find "版本" >nul && echo 连接到KMS主/备服务器皆失败，请重新运行脚本或检查计算机网络设置... || echo Unable to connect to KMS server
    )
pause

:networkerror
set /a retrya=1+%retrya%
if "%retrya%" LEQ "5" (
  goto networkerror2
) else (
  echo ======================================错误信息=======================================
  echo 本机连接KMS服务器多次失败...请检查网络设置...
  goto Feedback
)
pause
exit

:networkerror2
echo 因本机连接KMS服务器失败，正在进行第%retrya%次重试..
for /f "delims=" %%i in ('cscript //Nologo %windir%\system32\slmgr.vbs /ato') do set kmsresultd=%%i
echo %kmsresultd% | find "无法联系任何密钥管理服务" > NUL  && goto networkerror
echo %kmsresultd% | find "could be contacted" > NUL &&  goto networkerror 
pause
exit

:keyerror
echo ======================================错误信息=======================================
echo 激活密匙错误，可能是脚本不支持你的系统版本...
goto Feedback
pause
exit

:Feedback
echo.
if "!%EditionID%!"=="" ( echo. > NUL ) else ( echo windows激活时使用的密匙为!%EditionID%!  )
if "%KMS_Sev%"=="" ( echo. > NUL ) else ( echo 激活使用的服务器为%KMS_Sev%  )
for /f "tokens=*" %%d in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductName"') do set ProductNamed=%%d
echo 版本为%ProductNamed%
for /f "tokens=*" %%f in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "EditionID"') do set EditionID=%%f
echo ID为%EditionID%
where curl > NUL
if "%errorlevel%"=="0" ( Echo 系统已安装curl工具 ) else ( echo 系统未安装curl工具 )
where tcping > NUL
if "%errorlevel%"=="0" ( Echo 系统已安装Tcping工具 ) else ( echo 系统未安装Tcping工具 )
whoami /groups | find "S-1-16-12288" >NUL && Echo 脚本拥有管理员权限
echo ======================================错误信息=======================================
pause
cls