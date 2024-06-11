# Safe Clone Repository Scanner

This project provides a shell script to clone a GitHub repository, install necessary security scanning tools, and run these tools on the cloned repository files. The script ensures that the environment is safe and clean by using a virtual environment for the installations.

## Description

The `safe_clone.sh` script performs the following actions:

1. Clones a specified GitHub repository.
2. Removes any existing directory of the repository to avoid conflicts.
3. Creates and activates a Python virtual environment named `safe_clone`.
4. Installs `bandit`, `safety`, and `pip-audit` within the virtual environment.
5. Runs these tools to scan the repository for common security issues.
6. Deactivates the virtual environment after the scans are completed.

## Tools Used

- **Bandit**: A security linter for Python source code.
- **Safety**: Checks Python dependencies for known security vulnerabilities.
- **pip-audit**: Audits Python environments and dependency trees for known vulnerabilities.

## Requirements

- macOS with `zsh` shell
- Python 3.x
- `git` installed and configured
- `pip3` for managing Python packages

## Installation

1. Ensure you have Python 3.x and `pip3` installed on your system.
2. Ensure you have `git` installed and configured.
3. Clone this repository or download the `safe_clone.sh` script.

## Usage

1. Save the `safe_clone.sh` script to your desired location.
2. Make the script executable:
    ```sh
    chmod +x safe_clone.sh
    ```
3. Run the script by providing a GitHub repository URL as an argument:
    ```sh
    ./safe_clone.sh <github-repo-url>
    ```

### Example

```sh
./safe_clone.sh https://github.com/robinhood-unofficial/pyrh.git
