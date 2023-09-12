# Service Monitoring and Restart Script for QlikSense Services

## Background

In a QlikSense environment, it's crucial to ensure that QlikSense services are running smoothly across all nodes. Manual monitoring and restarting of these services can be a time-consuming task. To address this, we have created a batch script that proactively monitors the status of QlikSense services and automatically restarts them when needed.

### Purpose

The purpose of this script is to:

1. Continuously monitor the status of QlikSense services.
2. Automatically restart QlikSense services when they are not running.

### Implementation Considerations

- **Proactive Monitoring**: The script provides a proactive approach to monitoring and managing QlikSense services, reducing the need for manual intervention.

- **Configuration**: The script can be configured to monitor specific QlikSense services. Configuration settings include service names, maximum retries, check intervals, and restart timeouts.

- **Logging**: The script maintains a log file that records service status, timestamps, and relevant log messages, providing a historical record of QlikSense service activity.

## How to Use

### Running the Script at Startup

To run the script automatically at startup for monitoring and restarting QlikSense services, follow these steps:

1. **Locate the Batch Script**: The location of `monitor_services.bat`

2. **Open Windows Task Scheduler**:
   - Press `Win + R` on your keyboard to open the Run dialog.
   - Type `taskschd.msc` and press Enter to open Windows Task Scheduler.

3. **Create a New Task**:
   - In the right-hand pane of Task Scheduler, click on "Create Basic Task..." to open the Create Basic Task Wizard.

4. **Name and Description**:
   - Give your task a name (e.g., "QlikSense Service Monitoring Task").
   - Optionally, provide a description for your task.
   - Click "Next."

5. **Trigger**:
   - Choose "When the computer starts" as the trigger to run the task at startup.
   - Click "Next."

6. **Action**:
   - Select "Start a program" as the action.
   - Click "Next."

7. **Program/script and Add arguments**:
   - Browse and select the `monitor_services.bat` or enter its full path.
   - Click "Next."

8. **Finish**:
   - Review the task summary and click "Finish" to create the task.

9. **Enable "Run with Highest Privileges" (Mandatory)**:
    - In the task's properties, go to the "General" tab.
    - Check the box labeled "Run with highest privileges." This step is mandatory.

10. **Testing the Task**:
    - To test your task, locate it in Task Scheduler and right-click on it. Select "Run" to manually trigger your batch script.

11. **Save and Close**:
    - Click "OK" to save your task's properties and close Task Scheduler.

12. **Reboot Your Computer**:
    - To ensure that your task runs at startup, restart your computer. Your batch script will run automatically when the computer starts.

Your batch script will now run at startup as configured in Task Scheduler, continuously monitoring specified QlikSense services and taking action as needed.

---

*Disclaimer: This script was created using ChatGPT assistance and is provided as a tool for proactive QlikSense service management and should be used responsibly. Any service-related actions should be performed with caution and in accordance with your organization's policies and procedures.*
