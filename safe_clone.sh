#!/bin/zsh

# Function to check if a command exists and install it if it doesn't
check_and_install() {
    if ! command -v $1 &> /dev/null; then
        echo "$1 not found. Installing..."
        pip3 install $1
    else
        echo "$1 is already installed."
    fi
}

# Ensure a repository URL is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <github-repo-url>"
    exit 1
fi

# Clone the repository
repo_url=$1
repo_name=$(basename "$repo_url" .git)

# Remove existing repository folder if it exists
if [ -d "$repo_name" ]; then
    echo "Removing existing repository folder '$repo_name'..."
    rm -rf "$repo_name"
fi

git clone "$repo_url" || { echo "Failed to clone repository"; exit 1; }

# Change directory to the cloned repository
cd "$repo_name" || { echo "Failed to enter repository directory"; exit 1; }

# Create a virtual environment named 'safe_clone'
python3 -m venv safe_clone

# Activate the virtual environment
source safe_clone/bin/activate

# Install necessary tools within the virtual environment
pip install bandit safety pip-audit

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
