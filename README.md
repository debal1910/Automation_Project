# Automation_Project

On execution of the script, it should update the package details. ( apt update -y)
Script checks whether the HTTP Apache server is already installed. If not present, then it installs the server
Script checks whether the server is running or not. If it is not running, then it starts the server
Script ensures that the server runs on restart/reboot, I.e., it checks whether the service is enabled or not. It enables the service if not enabled already
After executing the script the tar file should be present in the correct format in the /tmp/ directory
Tar should be copied to the S3 bucket
