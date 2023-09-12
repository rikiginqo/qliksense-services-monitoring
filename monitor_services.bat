@echo off
setlocal enabledelayedexpansion

:: Define an array of service names to monitor
set services[0]="Qlik DataTransfer"
set services[1]="QlikSenseSchedulerService"
set services[2]="QlikSenseRepositoryService"
:: set services[N]=""..


:: Set the log file path, maximum retries, check interval, and restart timeout
set log_file="%~dp0service_log.csv"
set max_retries=3
set check_interval=20
set restart_timeout=12


:: Determine the number of services in the array
set service_count=0
for /l %%N in (0,1,100) do (
    set "service_name=!services[%%N]!"
    if defined service_name (
        set /a service_count+=1
    ) else (
        goto done_counting
    )
)
:done_counting
set /a service_count-=1

:: Create the log file with a header if it doesn't exist
if not exist %log_file% (
    echo "Service Name","Timestamp","Log Message" > %log_file%
)

:monitor_loop
:: Get the current date and time in a suitable format
for /f "tokens=2 delims==." %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set datetime=!datetime:~0,4!-!datetime:~4,2!-!datetime:~6,2! !datetime:~8,2!:!datetime:~10,2!:!datetime:~12,2!



:: Loop through the array of services
for /l %%N in (0,1,%service_count%) do (
    set service_name=!services[%%N]!

    :: Check if the service is running
    sc query !service_name! | find "STATE" | find "RUNNING" >nul

    if !errorlevel! equ 0 (
        echo [!datetime!] !service_name! is running.
    ) else (
        echo [!datetime!] !service_name! is not running. Restarting...
        
        :: Retry restarting the service up to max_retries times
        set retry_count=0
        :retry
        set /a retry_count+=1
        
        if !retry_count! leq %max_retries% (
            :: start the service
            net start !service_name!
			
			:: Wait for the specified restart timeout
            timeout /t %restart_timeout% /nobreak >nul
			
            :: Check if the service has been successfully started
            sc query !service_name! | find "STATE" | find "RUNNING" >nul
            if !errorlevel! equ 0 (
                echo [!datetime!] !service_name! has been successfully restarted.
                echo "!service_name!","!datetime!","!service_name! was restarted after retry number !retry_count!" >> %log_file%
            ) else (
                echo [!datetime!] Restart attempt !retry_count! for !service_name! failed. Retrying...
                goto retry
            )
        ) else (
            echo [!datetime!] !service_name! restart failed after maximum retries. Stopping monitoring.
            echo "!service_name!","!datetime!","!service_name! restart failed after maximum retries" >> %log_file%
			
			:: Exit the loop when maximum retries are reached
            goto :end_loop
        )
    )
)

:: Sleep for a specified check interval (adjust as needed)
timeout /t %check_interval% /nobreak >nul

:: Repeat the loop
goto monitor_loop

:: Stop monitoring
:end_loop