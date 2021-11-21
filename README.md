# Automation_Project

In version 1 the following was added
On execution of the script, it should update the package details. ( apt update -y)
Script checks whether the HTTP Apache server is already installed. If not present, then it installs the server
Script checks whether the server is running or not. If it is not running, then it starts the server
Script ensures that the server runs on restart/reboot, I.e., it checks whether the service is enabled or not. It enables the service if not enabled already
After executing the script the tar file should be present in the correct format in the /tmp/ directory
Tar should be copied to the S3 bucket

In version 2 the following was added
The script should schedule a cron job that runs the same script automatically at an interval of 1 day as a root user. (It means the script will create a cron-file in /etc/cron.d/ directory with the correct content.)
When the script is executed, it should create /var/www/html/inventory.html with the proper header and append detail of copied Tar file in the next line. The script should never overwrite the present content of the file.
