#!/bin/bash

# Define variables
PROJECT_DIR=~/SCERS_RAP_API
PUBLISH_DIR=/home/ubuntu/SCERS_RAP_API/bin/Release/netcoreapp3.1/publish
SERVICE_FILE=/etc/systemd/system/scers-rap-api.service
PORT=5034
USER=ubuntu
GROUP=ubuntu
PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)

# Step 1: Build the .NET application
echo "Building the .NET application..."
cd "$PROJECT_DIR" || exit
dotnet publish -c Release -o "$PUBLISH_DIR"

# Step 2: Create the systemd service file
echo "Creating the systemd service file..."
sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=SCERS RAP API Service
After=network.target

[Service]
WorkingDirectory=$PROJECT_DIR
ExecStart=/usr/bin/dotnet $PUBLISH_DIR/SCERS_RAP_API.dll
Restart=always
Environment=ASPNETCORE_URLS=http://0.0.0.0:$PORT
User=$USER
Group=$GROUP
SyslogIdentifier=scers-rap-api

[Install]
WantedBy=multi-user.target
EOL

# Step 3: Reload systemd, enable, and start the service
echo "Reloading systemd and enabling the service..."
sudo systemctl daemon-reload
sudo systemctl enable scers-rap-api.service
sudo systemctl start scers-rap-api.service

# Step 4: Verify the service status
echo "Checking service status..."
sudo systemctl status scers-rap-api.service

# Step 5: Verify the application is listening on the correct port
echo "Verifying that the application is listening on port $PORT..."
if sudo ss -tuln | grep -q ":$PORT"; then
    echo "Application is listening on port $PORT."
else
    echo "Error: Application is not listening on port $PORT."
    exit 1
fi

# Step 6: Adjust firewall rules (if necessary)
echo "Adjusting firewall rules to allow traffic on port $PORT..."
sudo ufw allow $PORT/tcp
sudo ufw reload

# Step 7: Test external access
echo "Testing external access to the application..."
echo "Run the following command from another machine to test access:"
echo "curl http://$PUBLIC_IP:$PORT/api/RAP"

# Step 8: Provide instructions for debugging logs
echo "Setup complete. If there are issues, use the following command to check logs:"
echo "sudo journalctl -u scers-rap-api.service -f"

exit 0

