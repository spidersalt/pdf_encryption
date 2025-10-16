#!/bin/bash
# Encrypt your pdf files using qpdf!
set -euo pipefail  # Exit on error, undefined variables, and pipe failures

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print error messages
error() {
    echo -e "${RED}ERROR: $1${NC}" >&2
}

# Function to print success messages
success() {
    echo -e "${GREEN}SUCCESS: $1${NC}"
}

# Function to print warning messages
warning() {
    echo -e "${YELLOW}WARNING: $1${NC}"
}

# Check if qpdf is installed
if ! command -v qpdf &> /dev/null; then
    error "qpdf is not installed. Please install it first."
    exit 1
fi

# Get source file with validation loop
while true; do
    echo "Enter path to source PDF file:"
    read -r source_file

    # Validate source file
    if [[ -z "$source_file" ]]; then
        error "Source file path cannot be empty."
        continue
    fi

    # Expand tilde and resolve path
    source_file="${source_file/#\~/$HOME}"

    if [[ ! -f "$source_file" ]]; then
        error "Source file does not exist: $source_file"
        continue
    fi

    if [[ ! -r "$source_file" ]]; then
        error "Source file is not readable: $source_file"
        continue
    fi

    # Basic PDF validation (check file signature)
    if ! file "$source_file" 2>/dev/null | grep -qi "PDF"; then
        error "File does not appear to be a PDF. Please provide a valid PDF file."
        continue
    fi
    
    # All validations passed
    success "Valid PDF file detected."
    break
done

# Get destination path
echo "Enter destination path:"
read -r destination_path

if [[ -z "$destination_path" ]]; then
    error "Destination path cannot be empty."
    exit 1
fi

# Expand tilde and resolve path
destination_path="${destination_path/#\~/$HOME}"

# Create destination directory if it doesn't exist
if [[ ! -d "$destination_path" ]]; then
    warning "Destination directory does not exist: $destination_path"
    read -p "Create it? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mkdir -p "$destination_path" || {
            error "Failed to create destination directory."
            exit 1
        }
        success "Created destination directory."
    else
        error "Destination directory does not exist. Exiting."
        exit 1
    fi
fi

# Check if destination path is writable
if [[ ! -w "$destination_path" ]]; then
    error "Destination path is not writable: $destination_path"
    exit 1
fi

# Get filename
echo "Enter filename (omit extension):"
read -r filename

if [[ -z "$filename" ]]; then
    error "Filename cannot be empty."
    exit 1
fi

# Sanitize filename (remove/replace unsafe characters)
filename=$(echo "$filename" | tr -d '\n\r' | tr '/' '_')

# Construct full output path
output_file="$destination_path/${filename}.pdf"

# Check if output file already exists
if [[ -f "$output_file" ]]; then
    warning "Output file already exists: $output_file"
    read -p "Overwrite? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Operation cancelled."
        exit 0
    fi
fi

# Get passwords securely
echo
echo "Password Information:"
echo "  - OWNER password: Full control (can decrypt and modify)"
echo "  - USER password: Limited access (can view with restrictions)"
echo

# Get and confirm owner password
while true; do
    read -s -r -p "Enter OWNER password: " owner_password
    echo  # Add newline after password input
    
    if [[ -z "$owner_password" ]]; then
        error "Owner password cannot be empty."
        continue
    fi
    
    read -s -r -p "Confirm OWNER password: " owner_password_confirm
    echo  # Add newline after password input
    
    if [[ "$owner_password" == "$owner_password_confirm" ]]; then
        unset owner_password_confirm
        success "Owner password confirmed."
        break
    else
        error "Passwords do not match. Please try again."
        unset owner_password owner_password_confirm
        echo
    fi
done

echo

# Get and confirm user password
while true; do
    read -s -r -p "Enter USER password: " user_password
    echo  # Add newline after password input
    
    if [[ -z "$user_password" ]]; then
        error "User password cannot be empty."
        continue
    fi
    
    read -s -r -p "Confirm USER password: " user_password_confirm
    echo  # Add newline after password input
    
    if [[ "$user_password" == "$user_password_confirm" ]]; then
        unset user_password_confirm
        success "User password confirmed."
        break
    else
        error "Passwords do not match. Please try again."
        unset user_password user_password_confirm
        echo
    fi
done

echo
echo "Encrypting PDF..."

# Note: qpdf's --encrypt requires passwords as command-line arguments.
# This means passwords will be briefly visible in the process list (ps).
# This is a limitation of qpdf itself, not this script.
# For single-user systems, this is generally acceptable.

# Run qpdf encryption
if qpdf --encrypt "$user_password" "$owner_password" 256 --modify=none -- "$source_file" "$output_file" 2>&1; then
    # Clear password variables from memory
    unset owner_password
    unset user_password
    
    success "PDF encrypted successfully!"
    echo "Output file: $output_file"
    echo
    ls -la "$output_file"
    exit 0
else
    # Clear password variables from memory even on failure
    unset owner_password
    unset user_password
    
    error "Failed to encrypt PDF. Check qpdf output above."
    exit 1
fi
