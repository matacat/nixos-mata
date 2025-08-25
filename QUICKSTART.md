# 🚀 Hướng dẫn cài đặt nhanh

## ⚠️ QUAN TRỌNG: Chỉ chạy trên máy NixOS!

Script `install.sh` **chỉ có thể chạy trên máy Linux/NixOS**, không phải Windows.

## 📋 Các bước thực hiện:

### 1️⃣ Trên máy NixOS (máy phụ):

```bash
# Clone repository
git clone https://github.com/matacat/nixos-mata.git
cd nixos-mata

# Kiểm tra nội dung
ls -la

# Chạy script cài đặt (chỉ trên NixOS)
chmod +x install.sh
./install.sh

# Apply configuration
sudo nixos-rebuild switch --flake /etc/nixos#dell-nixos

# Reboot
sudo reboot
```

### 2️⃣ Nếu chưa có NixOS:

1. **Download NixOS ISO**: https://nixos.org/download.html
2. **Tạo USB boot** với Rufus hoặc Balena Etcher
3. **Boot từ USB** và cài đặt NixOS minimal
4. **Sau đó** mới clone repo này và chạy script

### 3️⃣ Cài đặt thủ công (nếu script không hoạt động):

```bash
# Trên máy NixOS
cd nixos-mata

# Copy files
sudo cp flake.nix /etc/nixos/
sudo cp -r hosts modules /etc/nixos/
sudo cp home.nix /etc/nixos/

# Generate hardware config
sudo nixos-generate-config --show-hardware-config > /tmp/hw.nix
sudo mv /tmp/hw.nix /etc/nixos/hosts/dell-5548/hardware-configuration.nix

# Copy dotfiles
mkdir -p ~/.config/hypr ~/.config/waybar
cp dotfiles/hyprland.conf ~/.config/hypr/
cp dotfiles/waybar-config.json ~/.config/waybar/config

# Build and switch
sudo nixos-rebuild switch --flake /etc/nixos#dell-nixos
```

## 🔧 Troubleshooting:

### Lỗi "command not found":
- Đảm bảo bạn đang trên máy Linux/NixOS
- Đảm bảo đã `chmod +x install.sh`
- Thử chạy: `bash install.sh`

### Lỗi "permission denied: /etc/nixos":
Script cần quyền sudo để truy cập /etc/nixos:
```bash
# Thử lại với sudo cho các lệnh cần thiết
sudo bash install.sh

# Hoặc chạy thủ công từng bước
chmod +x manual-install.sh
./manual-install.sh  # Sẽ hiển thị từng lệnh để copy-paste
```

### Script không chạy được:
```bash
# Chạy script thủ công - step by step
./manual-install.sh

# Hoặc copy từng lệnh từ script và chạy riêng
cat install.sh  # Xem nội dung và chạy từng lệnh
```

## 📱 Liên hệ:
Nếu gặp vấn đề, hãy paste log lỗi để được hỗ trợ!
