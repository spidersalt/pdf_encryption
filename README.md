# PDF Encryption Tool

A secure, user-friendly Bash script for encrypting PDF files using qpdf with AES-256 encryption.
```
  ┌────────────────────────────────────┐
  │                                    │
  │                     __     ___     │
  │                    /\ \  /'___\    │
  │      __   _____    \_\ \/\ \__/    │
  │    /'__`\/\ '__`\  /'_` \ \ ,__\   │
  │   /\ \L\ \ \ \L\ \/\ \L\ \ \ \_/   │
  │   \ \___, \ \ ,__/\ \___,_\ \_\    │
  │    \/___/\ \ \ \/  \/__,_ /\/_/    │
  │         \ \_\ \_\                  │
  │          \/_/\/_/                  │
  │                                    │
  └────────────────────────────────────┘
```

## Features

### 🔒 Security Features
- **AES-256 Encryption**: Industry-standard encryption strength
- **Password Confirmation**: Prevents typos by requiring password confirmation
- **Memory Protection**: Passwords are cleared from memory after use
- **Input Validation**: All user inputs are thoroughly validated
- **File Type Verification**: Ensures only PDF files are processed
- **Sanitized Filenames**: Removes unsafe characters to prevent injection attacks
- **Permission Checks**: Validates read/write permissions before processing

### 🎯 User Experience
- **Interactive Interface**: Clear prompts and helpful hints
- **Color-Coded Feedback**: 
  - 🔴 Red for errors
  - 🟢 Green for success messages
  - 🟡 Yellow for warnings
- **ASCII Art Banner**: Professional welcome screen
- **Progress Indicators**: Real-time feedback during encryption
- **File Details Display**: Shows encrypted file info upon completion
- **Path Expansion**: Supports tilde (~) for home directory

### ⚡ Robustness
- **Error Handling**: Comprehensive error checking with `set -euo pipefail`
- **Input Loops**: Prompts again on invalid input instead of exiting
- **Dependency Checks**: Verifies required tools are installed
- **Overwrite Protection**: Warns before overwriting existing files
- **Directory Creation**: Offers to create destination directories
- **Graceful Exit**: Clean error messages on failure

## Requirements

- **Bash** 4.0 or higher
- **qpdf** - PDF transformation tool
- **file** - File type identification utility

### Installation of Dependencies

#### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install qpdf
```

#### macOS (Homebrew)
```bash
brew install qpdf
```

#### Fedora/RHEL/CentOS
```bash
sudo dnf install qpdf
```

#### Arch Linux
```bash
sudo pacman -S qpdf
```

## Installation

1. Download the script:
```bash
curl -O https://github.com/spidersalt/pdf_encryption/releases/download/latest/qpdf_tool.sh
```

2. Make it executable:
```bash
chmod +x qpdf_tool.sh
```

3. (Optional) Move to a directory in your PATH:
```bash
sudo mv qpdf.sh /usr/local/bin/qpdf-encrypt
```

## Usage

### Basic Usage

Run the script:
```bash
./qpdf_tool.sh
```

The script will interactively prompt you for:

1. **Source PDF file path** - Path to the PDF you want to encrypt
2. **Destination path** - Where to save the encrypted PDF
3. **Output filename** - Name for the encrypted file (without .pdf extension)
4. **OWNER password** - Full control password (can decrypt and modify)
5. **USER password** - Limited access password (view with restrictions)

### Example Session

```bash
./qpdf_tool.sh

# Follow the prompts:
Enter path to source PDF file:
/home/user/documents/report.pdf

Enter destination path:
/home/user/encrypted

Enter filename (omit extension):
report_encrypted

Enter OWNER password: ********
Confirm OWNER password: ********

Enter USER password: ********
Confirm USER password: ********

# Output:
SUCCESS: PDF encrypted successfully!
Output file: /home/user/encrypted/report_encrypted.pdf
-rw-r--r-- 1 user user 245678 Oct 16 10:30 /home/user/encrypted/report_encrypted.pdf
```

## Password Types

### OWNER Password
- Full control over the document
- Can decrypt and remove restrictions
- Can modify document permissions
- **Use this password when you need to edit or manage the PDF**

### USER Password
- Limited access to view the document
- Restrictions apply (set to `--modify=none` in this script)
- Cannot modify or print by default
- **Share this password with people who only need to view the PDF**

## Security Considerations

### ⚠️ Known Limitations

1. **Process List Exposure**: Due to qpdf's design, passwords are briefly visible in the process list (`ps aux`) during encryption. This is a limitation of qpdf itself, not this script.
   - **Impact**: Low on single-user systems
   - **Exposure window**: Milliseconds
   - **Mitigation**: Passwords are immediately cleared from memory after use

2. **Terminal History**: If run with command-line arguments (not recommended), passwords could be saved in shell history. This script uses interactive prompts to avoid this issue.

### ✅ Best Practices

- Use strong, unique passwords
- Don't reuse passwords across documents
- Store passwords securely (use a password manager)
- Run on trusted systems
- Verify the encrypted file before deleting the original
- Keep backups of important documents

## Customization

### Encryption Strength

The script uses AES-256 encryption by default. To change the encryption level, modify line 219:

```bash
# Current: 256-bit encryption
qpdf --encrypt "$user_password" "$owner_password" 256 --modify=none -- "$source_file" "$output_file"

# For 128-bit encryption:
qpdf --encrypt "$user_password" "$owner_password" 128 --modify=none -- "$source_file" "$output_file"
```

### Permission Levels

The script uses `--modify=none` by default. Other options:

```bash
--modify=all          # Allow all modifications
--modify=annotate     # Allow annotations only
--modify=form         # Allow form filling only
--modify=assembly     # Allow page assembly only
--modify=none         # No modifications (default)
```

Additional permissions can be added:
```bash
--print=full          # Allow full printing
--print=low           # Allow low-resolution printing
--print=none          # No printing

--extract=y           # Allow text/graphics extraction
--extract=n           # Prevent extraction
```

## Troubleshooting

### "qpdf is not installed"
Install qpdf using your package manager (see Requirements section).

### "File does not appear to be a PDF"
Ensure your input file is a valid PDF. Check with:
```bash
file your-file.pdf
```

### "Permission denied"
Ensure you have:
- Read permission on the source file
- Write permission on the destination directory

### "Failed to encrypt PDF"
Check qpdf output for specific errors. Common issues:
- Source PDF may be corrupted
- Source PDF may already be encrypted
- Insufficient disk space

## Contributing

Improvements and suggestions are welcome! Key areas for contribution:
- Additional encryption options
- Batch processing support
- Configuration file support
- GUI wrapper

## License

This script is provided as-is for free use and modification.

## Changelog

### Version 1.0 (Current)
- Initial release
- AES-256 encryption support
- Interactive password confirmation
- Comprehensive input validation
- Color-coded feedback
- File type verification
- Path expansion support
- Memory protection for passwords

## Author

Created for secure PDF encryption workflows.

## Acknowledgments

- Built with [qpdf](https://github.com/qpdf/qpdf) by Jay Berkenbilt
- Inspired by the need for simple, secure PDF encryption

---

**Note**: Always test the encrypted PDF before deleting the original to ensure it works as expected!
***

# Creating a desktop file
### Create an interactive script:

```bash
sudo nvim /usr/local/bin/qpdf_tool.sh
```

**Paste the following:**

```bash
#!/bin/bash
# Encrypt your pdf files using qpdf!
set -euo pipefail  # Exit on error, undefined variables, and pipe failures

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Display banner
clear
echo -e "${CYAN}"
cat << "EOF"
  ┌────────────────────────────────────┐
  │                                    │
  │                     __     ___     │
  │                    /\ \  /'___\    │
  │      __   _____    \_\ \/\ \__/    │
  │    /'__`\/\ '__`\  /'_` \ \ ,__\   │
  │   /\ \L\ \ \ \L\ \/\ \L\ \ \ \_/   │
  │   \ \___, \ \ ,__/\ \___,_\ \_\    │
  │    \/___/\ \ \ \/  \/__,_ /\/_/    │
  │         \ \_\ \_\                  │
  │          \/_/\/_/                  │
  │                                    │
  └────────────────────────────────────┘      
EOF
echo -e "${NC}"
echo -e "${GREEN}Welcome to PDF Encryption Tool${NC}"
echo "Secure your PDF files with password protection using qpdf"
echo "=========================================================="
echo

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

# Check if required commands are installed
for cmd in qpdf file; do
    if ! command -v "$cmd" &> /dev/null; then
        error "$cmd is not installed. Please install it first."
        exit 1
    fi
done

# Function to encrypt a single PDF
encrypt_pdf() {

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

# Get filename with validation loop
while true; do
    echo "Enter filename (omit extension):"
    read -r filename

    if [[ -z "$filename" ]]; then
        error "Filename cannot be empty. Please enter a valid filename."
        continue
    fi
    
    # All validations passed
    break
done

# Sanitize filename (remove/replace unsafe characters)
filename=$(echo "$filename" | tr -d '\n\r' | tr -cd '[:alnum:]._-' | tr ' ' '_')

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
    return 0
else
    # Clear password variables from memory even on failure
    unset owner_password
    unset user_password
    
    error "Failed to encrypt PDF. Check qpdf output above."
    return 1
fi
}

# Run first encryption
encrypt_pdf

# Main program loop (only after first encryption)
while true; do
    echo
    echo "=========================================================="
    echo "PDF Encryption Menu:"
    echo "  (0) Exit"
    echo "  (1) Encrypt more files"
    echo "=========================================================="
    read -p "Choose an option: " choice
    
    case $choice in
        0)
            echo
            success "Thank you for using PDF Encryption Tool!"
            exit 0
            ;;
        1)
            echo
            encrypt_pdf
            ;;
        *)
            error "Invalid option. Please choose 0 or 1."
            ;;
    esac
done

```

***

### Create a `.desktop` file

**1 - Make sure the script is executable:**

```bash
sudo chmod +x /usr/local/bin/qpdf_tool.sh
```

**2 - Create the `.desktop` file:**

```bash
sudo nvim /usr/share/applications/qpdf_tool.desktop
```

**3 - Paste the following:**

```bash
[Desktop Entry]
Name=PDF Encryption Tool
Comment=Interactively encrypt pdf files using qpdf
Exec=gnome-terminal -- /usr/local/bin/qpdf_tool.sh
Icon=utilities-terminal  # Or path to a custom icon, e.g., /usr/share/icons/hicolor/48x48/apps/archiver.png
Terminal=false  # We launch our own terminal, so this is false
Type=Application
Categories=Utility;Security;
StartupNotify=true
```

**4 - Make the `.desktop` file executable:**

```bash
sudo chmod +x /usr/share/applications/qpdf_tool.desktop
```

5 - **Place and Test**:

- **On Desktop**: Copy the .desktop file to your Desktop folder (~/Desktop/), or right-click desktop > "Create Launcher" in some DEs, and point to the script with terminal options.
- **In Menu**: It should appear in your applications menu (search for "Encrypt Files with 7z"). Log out/in or run update-desktop-database if needed.
- Click it: Terminal opens, script runs interactively (you'll see prompts and can type inputs).
