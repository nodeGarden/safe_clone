#!/bin/zsh

# Function to check if a command exists and install it if it doesn't
check_and_install() {
    if ! command -v $1 &> /dev/null; then
        echo "Installing $1..."
        pip3 install $1 &> /dev/null &

        # Simple progress indicator
        pid=$!
        while kill -0 $pid 2> /dev/null; do
            for i in '/' '-' '\' '|'; do
                echo -ne "\r$i"
                sleep 0.1
            done
        done
        echo "\r$1 installation complete!"
    else
        echo "$1 is already installed."
    fi
}

# Ensure a repository URL is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <github-repo-url> [--cache]"
    exit 1
fi

# Parse arguments
repo_url=$1
cache_flag=$2
repo_name=$(basename "$repo_url" .git)

# Handle the --cache flag
if [ "$cache_flag" != "--cache" ]; then
    # Remove existing repository folder if it exists
    if [ -d "$repo_name" ]; then
        echo "Removing existing repository folder '$repo_name'..."
        rm -rf "$repo_name"
    fi

    # Clone the repository
    git clone "$repo_url" || { echo "Failed to clone repository"; exit 1; }
else
    # If --cache flag is set, check if the directory exists and pull the latest changes
    if [ -d "$repo_name" ]; then
        echo "Repository folder '$repo_name' exists. Pulling latest changes..."
        cd "$repo_name" || { echo "Failed to enter repository directory"; exit 1; }
        git pull || { echo "Failed to pull latest changes"; exit 1; }
    else
        # If the directory does not exist, clone the repository
        git clone "$repo_url" || { echo "Failed to clone repository"; exit 1; }
        cd "$repo_name" || { echo "Failed to enter repository directory"; exit 1; }
    fi
fi

# Change directory to the cloned repository (if not already there)
if [ "$cache_flag" != "--cache" ] || [ ! -d "$repo_name" ]; then
    cd "$repo_name" || { echo "Failed to enter repository directory"; exit 1; }
fi

# Create a virtual environment named 'safe_clone'
python3 -m venv safe_clone

# Activate the virtual environment
source safe_clone/bin/activate

# Install necessary tools within the virtual environment
check_and_install bandit
check_and_install safety
check_and_install pip-audit

# Run Bandit
echo "Running Bandit..."
bandit -r .

# Run Safety
echo "Running Safety..."
safety check

# Run pip-audit
echo "Running pip-audit..."
pip-audit

# Deactivate the virtual environment
deactivate

echo "Scans completed."
