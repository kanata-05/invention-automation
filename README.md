# Arch Linux Automated Installation Script
# aka invention-automation

---

This repository contains a script designed to automate the installation of Arch Linux. The script takes care of partitioning the disk, formatting the filesystem, installing the base system, configuring essential settings, and setting up a desktop environment of your choice. It is tailored for UEFI systems and assumes the installation on a single drive (e.g., `/dev/sda`).

## Features

- **Automatic Disk Partitioning**: Creates a GPT partition table, an EFI system partition, and a root partition.
- **Filesystem Formatting**: Formats the partitions with appropriate filesystems (FAT32 for EFI and ext4 for root).
- **Base System Installation**: Installs the essential base packages for Arch Linux.
- **Timezone and Locale Configuration**: Sets the system timezone and locale.
- **Hostname and Network Configuration**: Configures the hostname and network settings.
- **User Creation**: Creates a new user with sudo privileges.
- **Bootloader Installation**: Installs and configures GRUB as the bootloader.
- **Desktop Environment Setup**: Installs and configures a desktop environment (Plasma by default).
- **Network Management**: Installs and enables NetworkManager.

## Prerequisites

- Arch Linux installation medium (USB/DVD)
- Internet connection

## Usage

### Step 1: Download the Script

Boot into the Arch Linux live environment and download the script using `curl`:

```bash
curl -O https://raw.githubusercontent.com/kanata-05/invention-automation/main/install.sh
```

### Step 2: Make the Script Executable

Change the permissions of the script to make it executable:

```bash
chmod +x install.sh
```

### Step 3: Edit the Script (Optional)

Open the script in a text editor to adjust the variables at the top to suit your preferences:

```bash
nano install.sh
```

You can customize the following variables:

- `DISK`: The target disk for installation (default: `/dev/sda`)
- `HOSTNAME`: The desired hostname for your system
- `USERNAME`: The name of the new user to be created
- `PASSWORD`: The password for the new user
- `ROOT_PASSWORD`: The root user's password
- `TIMEZONE`: Your timezone (default: `America/New_York`)
- `LOCALE`: The system locale (default: `en_US.UTF-8`)
- `KEYMAP`: The keyboard layout (default: `us`)
- `DESKTOP_ENV`: The desktop environment to install (default: `plasma`)

### Step 4: Run the Script

Execute the script to start the automated installation process:

```bash
./install.sh
```

### Step 5: Post-Installation

Once the script completes, your system will reboot into the newly installed Arch Linux environment. Log in with the user credentials you set in the script.

## Example Configuration

Below is an example of the configuration section of the script:

```bash
# Variables
DISK="/dev/sda"
HOSTNAME="archlinux"
USERNAME="user"
PASSWORD="password"
ROOT_PASSWORD="rootpassword"
TIMEZONE="America/New_York"
LOCALE="en_US.UTF-8"
KEYMAP="us"
DESKTOP_ENV="plasma"
```

## Script Details

The script performs the following steps:

1. **System Clock**: Synchronizes the system clock with `timedatectl set-ntp true`.
2. **Disk Partitioning**: Uses `parted` to create a GPT partition table, an EFI partition, and a root partition.
3. **Filesystem Formatting**: Formats the EFI partition as FAT32 and the root partition as ext4.
4. **Mounting Partitions**: Mounts the root partition to `/mnt` and the EFI partition to `/mnt/boot`.
5. **Base System Installation**: Installs the base system using `pacstrap`.
6. **Generating fstab**: Generates the filesystem table with `genfstab`.
7. **Chroot Configuration**: Configures the system within a chroot environment:
   - Sets the timezone and hardware clock.
   - Configures locale settings.
   - Sets the hostname and updates `/etc/hosts`.
   - Sets root password and creates a new user with sudo privileges.
   - Installs and configures GRUB as the bootloader.
   - Installs and enables NetworkManager.
   - Installs and configures a desktop environment.
8. **Unmounting Partitions**: Unmounts all partitions.
9. **Rebooting**: Reboots the system into the newly installed Arch Linux environment.

## Notes

- **Review the Script**: Ensure you review the script thoroughly before running it, especially if you are using it on a system with existing data.
- **Customization**: The script can be customized for different hardware configurations and preferences.

## Contributing

Contributions are welcome! If you have suggestions for improvements, additional features, or bug fixes, please submit an issue or a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

If you have any questions or need further assistance, feel free to open an issue on this repository.
