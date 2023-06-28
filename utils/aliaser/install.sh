#!/bin/bash

# Source the aliaser.sh file to make log functions accessible
source aliaser.sh
export ALI_DIR=~/dotfiles/utils/aliaser
install_aliaser_dev() {
  # Check if jq is installed
  if ! command -v jq &> /dev/null; then
    log_info "jq is not installed, attempting to install..."
    sudo apt-get install jq
    if command -v jq &> /dev/null; then
      log_info "jq installed successfully! 😊"
    else
      log_err "Failed to install jq. 😞 Please install it manually and re-run this script."
      exit 1
    fi
  else
    log_verb "jq is already installed 👍"
  fi

  # Create necessary directories and files
  log_info "Creating necessary directories and files..."
  mkdir -p ~/.dotfiles/utils/aliaser
  touch ~/.dotfiles/utils/aliaser/aliases.json
  [[ ! -e ~/.dotfiles/utils/aliaser/aliases.json ]] && echo '{}' > ~/.dotfiles/utils/aliaser/aliases.json
  cp aliaser.sh ~/.dotfiles/utils/aliaser/
  chmod +x ~/.dotfiles/utils/aliaser/aliaser.sh
  log_info "Directories and files created successfully! 📁"

  # Symlink to local bin directory
  log_info "Creating symlink to local bin directory..."
  ln -sf ~/.local/share/aliaser/aliaser.sh ~/.local/bin/aliaser
  log_info "Symlink created successfully! 🔗"

  # Check if aliaser.sh is already sourced in .bashrc
  if grep -q "aliaser.sh" ~/.bashrc; then
    log_verb "aliaser.sh is already sourced in .bashrc 🔄"
  else
    log_info "Adding source command to .bashrc..."
    echo "" >> ~/.bashrc
    echo "# Start of aliaser init code" >> ~/.bashrc
    echo "source ~/.local/share/aliaser/aliaser.sh" >> ~/.bashrc
    echo "# End of aliaser init code" >> ~/.bashrc
    log_info "aliaser.sh has been sourced in .bashrc 👌"
  fi

  log_info "Installation completed successfully! 🎉 Please restart your terminal or run 'source ~/.bashrc'."
}

install_aliaser() {
  # Check if jq is installed
  if ! command -v jq &> /dev/null; then
    log_info "jq is not installed, attempting to install..."
    sudo apt-get install jq
    if command -v jq &> /dev/null; then
      log_info "jq installed successfully! 😊"
    else
      log_err "Failed to install jq. 😞 Please install it manually and re-run this script."
      exit 1
    fi
  else
    log_verb "jq is already installed 👍"
  fi

  # Create necessary directories and files
  log_info "Creating necessary directories and files..."
  mkdir -p ~/.local/share/aliaser
  touch ~/.local/share/aliaser/aliases.json
  [[ ! -e ~/.local/share/aliaser/aliases.json ]] && echo '{}' > ~/.local/share/aliaser/aliases.json
  cp aliaser.sh ~/.local/share/aliaser/
  chmod +x ~/.local/share/aliaser/aliaser.sh
  log_info "Directories and files created successfully! 📁"

  # Symlink to local bin directory
  log_info "Creating symlink to local bin directory..."
  ln -sf ~/.local/share/aliaser/aliaser.sh ~/.local/bin/aliaser
  log_info "Symlink created successfully! 🔗"

  # Check if aliaser.sh is already sourced in .bashrc
  if grep -q "aliaser.sh" ~/.bashrc; then
    log_verb "aliaser.sh is already sourced in .bashrc 🔄"
  else
    log_info "Adding source command to .bashrc..."
    echo "" >> ~/.bashrc
    echo "# Start of aliaser init code" >> ~/.bashrc
    echo "source ~/.local/share/aliaser/aliaser.sh" >> ~/.bashrc
    echo "# End of aliaser init code" >> ~/.bashrc
    log_info "aliaser.sh has been sourced in .bashrc 👌"
  fi

  log_info "Installation completed successfully! 🎉 Please restart your terminal or run 'source ~/.bashrc'."
}

uninstall_aliaser() {
  # Remove the aliaser from .bashrc
  log_info "Removing aliaser from .bashrc..."
  sed -i '/# Start of aliaser init code/,/# End of aliaser init code/d' ~/.bashrc
  log_info "Removed aliaser from .bashrc 👋"

  # Delete the symlink from local bin directory
  log_info "Deleting symlink from local bin directory..."
  rm ~/.local/bin/aliaser
  log_info "Symlink deleted successfully! 🔗"

  # Remove necessary directories and files
  log_info "Deleting necessary directories and files..."
  rm -rf ~/.local/share/aliaser
  log_info "Directories and files deleted successfully! 📁"

  log_info "Uninstallation completed successfully! 🎉 Please restart your terminal or run 'source ~/.bashrc'."
}

# Call the functions based on passed argument
if [ "$1" == "uninstall" ]; then
  uninstall_aliaser
else
  install_aliaser
fi