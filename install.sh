apt update && apt upgrade -y
# Update Termux packages
pkg update -y && pkg upgrade -y

# Create the script with proper permissions
curl -o $PREFIX/tmp/Sel.sh https://raw.githubusercontent.com/nyeinkokoaung404/Selector/main/Sel.sh

# Check if download succeeded
if [ -f "$PREFIX/tmp/Sel.sh" ]; then
    # Make executable and move to bin
    chmod +x $PREFIX/tmp/Sel.sh
    mv $PREFIX/tmp/Sel.sh $PREFIX/bin/404
    echo "Installed successfully. Run with: 404"
else
    echo "Download failed!"
    exit 1
fi
