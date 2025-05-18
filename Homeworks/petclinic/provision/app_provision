#!/bin/bash

# Variables
APP_USER=petapp
PROJECT_DIR=/home/$APP_USER/petclinic
APP_DIR=/home/$APP_USER

# Create application user if not exists
if ! id "$APP_USER" &>/dev/null; then
    useradd -m -s /bin/bash $APP_USER
fi

# Install required packages
apt-get update
apt-get install -y openjdk-17-jdk git curl unzip

# Clone the PetClinic project
echo "==> Cloning Spring PetClinic project..."
sudo -u $APP_USER git clone https://github.com/spring-projects/spring-petclinic.git $PROJECT_DIR

# Build the project using Maven wrapper
echo "==> Building the project..."
cd $PROJECT_DIR
sudo -u $APP_USER HOME=/home/$APP_USER ./mvnw clean package

# Check if .jar file was created
JAR_FILE=$(find target -name "*.jar" | head -n 1)
if [ ! -f "$JAR_FILE" ]; then
    echo "❌ Build failed: .jar file not found."
    exit 1
fi

# Copy the resulting .jar file to user home
cp "$JAR_FILE" $APP_DIR

# Set environment variables in user's .bashrc
echo "export DB_HOST=${DB_HOST}" >> /home/$APP_USER/.bashrc
echo "export DB_PORT=${DB_PORT}" >> /home/$APP_USER/.bashrc
echo "export DB_NAME=${DB_NAME}" >> /home/$APP_USER/.bashrc
echo "export DB_USER=${DB_USER}" >> /home/$APP_USER/.bashrc
echo "export DB_PASS=${DB_PASS}" >> /home/$APP_USER/.bashrc

# Run the application in the background
echo "==> Starting PetClinic..."
sudo -u $APP_USER nohup java -jar $APP_DIR/$(basename "$JAR_FILE") > $APP_DIR/app.log 2>&1 &

