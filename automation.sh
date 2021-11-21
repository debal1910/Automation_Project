s3_bucket="upgrad-debal"
myname="debal"
timestamp=$(date '+%d%m%Y-%H%M%S')

echo "****************************************************"
echo "Updating System Packages - running sudo apt update -y."
sudo apt update -y

#apt list --installed lists all installed packages
#2>/dev/null is used to suppress the warning WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
#grep apache2 matches for string
#grep "\[installed\]" is being used because if apache is first installed and then uninstalled,
#then there are some stale packages which needs to be filtered out 
#wc -l counts number of lines.
echo "****************************************************"
echo "Checking if Apache2 is installed."
APACHE_COUNT=$(apt list --installed  2>/dev/null | grep apache2 | grep "\[installed\]"| wc -l)
if [[ $APACHE_COUNT -ne 0 ]]; 
then 
    echo "Apache2 is installed."; 
else 
    echo "Apache2 is not installed. Proceeding with installation."; 
    apt install apache2 -y
fi

echo "****************************************************"
echo "Checking if Apache2 is running."
service apache2 status
if [[ $? -eq 0 ]]
then
    echo "Apache is running."
else 
    echo "Apache2 is not running. Proceeding to start it."
    service apache2 start
fi

echo "****************************************************"
echo "Checking if Apache2 is enabled for start after reboot."
ENABLE=$(systemctl is-enabled apache2)
if [[ $ENABLE == "enabled" ]]
then
    echo "Apache2 is already enabled for start after reboot."
else
    echo "Apache2 is disabled for start after reboot. Proceeding with enabling it."
    systemctl enable apache2
fi

echo "****************************************************"
echo "Taking a tar of logs and uploading to S3"
cd /var/log/apache2
tar -cf ${myname}-httpd-logs-${timestamp}.tar *.log
cp ${myname}-httpd-logs-${timestamp}.tar /tmp/
aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
echo "Completed uploading to S3"

echo "****************************************************"
echo "Checking if inventory.html is present. If absent creating the file with appropriate headers"
if [[ ! -f /var/www/html/inventory.html ]]
then
    echo -e "Log Type\t\t\tTime Created\t\t\tType\t\t\tSize" > /var/www/html/inventory.html
    echo "Created the inventory.html header file"
else
    echo "inventory.html already present"
fi
echo "****************************************************"
echo "Appending the details of current upload to inventory.html"
echo -e "httpd-logs\t\t\t${timestamp}\t\t\ttar\t\t\t`ls -lhrt /tmp/${myname}-httpd-logs-${timestamp}.tar | awk '{print $5}'`" >> /var/www/html/inventory.html
echo "Completed appending details of current upload to inventory.html"

echo "****************************************************"
echo "Checking if Cron entry present. If not creating it."
if [[ ! -f /etc/cron.d/automation ]]
then
    echo "0 * * * * root /root/Automation_Project/automation.sh" > /etc/cron.d/automation
    echo "Completed creating cron entry."
else
    echo "Cron entry already present for automation.sh. Skipping!!!"
fi

echo "****************************************************"
echo "Script execution complete."
echo "****************************************************"