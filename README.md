# PDF Encryption Tool

A secure, user-friendly Bash script for encrypting PDF files using qpdf with AES-256 encryption.

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
sudo apt-get install qpdf file
```

#### macOS (Homebrew)
```bash
brew install qpdf
```

#### Fedora/RHEL/CentOS
```bash
sudo dnf install qpdf file
```

#### Arch Linux
```bash
sudo pacman -S qpdf file
```

## Installation

1. Download the script:
```bash
curl -O https://github.com/spidersalt/pdf_encryption
```

2. Make it executable:
```bash
chmod +x qpdf.sh
```

3. (Optional) Move to a directory in your PATH:
```bash
sudo mv qpdf.sh /usr/local/bin/qpdf-encrypt
```

## Usage

### Basic Usage

Run the script:
```bash
./qpdf.sh
```

The script will interactively prompt you for:

1. **Source PDF file path** - Path to the PDF you want to encrypt
2. **Destination path** - Where to save the encrypted PDF
3. **Output filename** - Name for the encrypted file (without .pdf extension)
4. **OWNER password** - Full control password (can decrypt and modify)
5. **USER password** - Limited access password (view with restrictions)

### Example Session

```bash
./qpdf.sh

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
