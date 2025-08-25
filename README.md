# NixOS Configuration for Dell Inspiron 5548

Cấu hình NixOS tối ưu cho laptop Dell Inspiron 5548 với Hyprland window manager, hỗ trợ tiếng Việt và các tính năng laptop như quản lý pin, brightness, audio.

## 📋 Thông tin hệ thống

- **Laptop**: Dell Inspiron 5548
- **OS**: NixOS 23.11
- **Window Manager**: Hyprland (Wayland)
- **Terminal**: Ghostty
- **Status Bar**: Waybar
- **Editor**: Neovim (qua Home Manager)
- **Audio**: PipeWire
- **Graphics**: Intel HD Graphics 5500

## 🏗️ Cấu trúc thư mục

```
nixos-dell-5548/
├── flake.nix                    # Flake chính
├── flake.lock                   # Lock file
├── home.nix                     # Home Manager configuration
├── install.sh                   # Script cài đặt
├── hosts/
│   └── dell-5548/
│       ├── configuration.nix    # Host-specific config
│       └── hardware-configuration.nix
├── modules/
│   ├── desktop/
│   │   └── hyprland.nix        # Hyprland WM config
│   └── system/
│       ├── audio.nix           # PipeWire audio
│       ├── bluetooth.nix       # Bluetooth config
│       ├── fonts.nix           # Font configuration
│       ├── graphics.nix        # Intel graphics
│       └── power.nix           # TLP power management
└── dotfiles/
    ├── hyprland.conf           # Hyprland config
    └── waybar-config.json      # Waybar config
```

## 🚀 Cài đặt

### Cách 1: Clone từ GitHub (Khuyến nghị)

```bash
# Clone repository
git clone https://github.com/yourusername/nixos-dell-5548.git
cd nixos-dell-5548

# Chạy script cài đặt
chmod +x install.sh
./install.sh

# Apply configuration
sudo nixos-rebuild switch --flake /etc/nixos#dell-nixos
```

### Cách 2: Cài đặt thủ công

1. Copy files vào đúng vị trí:
```bash
sudo cp flake.nix /etc/nixos/
sudo cp -r hosts modules /etc/nixos/
sudo cp home.nix /etc/nixos/
```

2. Copy dotfiles:
```bash
mkdir -p ~/.config/hypr ~/.config/waybar
cp dotfiles/hyprland.conf ~/.config/hypr/
cp dotfiles/waybar-config.json ~/.config/waybar/config
```

3. Generate hardware config:
```bash
sudo nixos-generate-config --show-hardware-config > /tmp/hw.nix
sudo mv /tmp/hw.nix /etc/nixos/hosts/dell-5548/hardware-configuration.nix
```

4. Build và switch:
```bash
sudo nixos-rebuild switch --flake /etc/nixos#dell-nixos
```

## ⌨️ Phím tắt chính

| Phím tắt | Chức năng |
|----------|----------|
| `Super + Q` | Mở terminal (Ghostty) |
| `Super + R` | App launcher (Wofi) |
| `Super + E` | File manager |
| `Super + C` | Đóng window |
| `Super + V` | Toggle floating |
| `Super + F` | Fullscreen |
| `Super + 1-0` | Switch workspace |
| `Super + Shift + 1-0` | Move window to workspace |
| `Super + S` | Screenshot |
| `Alt + Shift` | **Switch keyboard US ↔ VN** |
| `Fn + F11/F12` | Brightness control |
| `Fn + F1/F2/F3` | Volume control |

## 🔧 Tính năng đã cấu hình

### ✅ Laptop Support
- [x] Intel HD Graphics 5500 với hardware acceleration
- [x] Brightness control (Fn keys + brightnessctl)
- [x] Audio với PipeWire (Fn keys)
- [x] Power management với TLP
- [x] Bluetooth
- [x] WiFi NetworkManager
- [x] Touchpad với tap-to-click

### ✅ Desktop Environment
- [x] Hyprland Wayland compositor
- [x] Waybar status bar với Vietnamese số
- [x] Wofi application launcher
- [x] Mako notifications
- [x] Screenshot với grim/slurp
- [x] Lock screen với swaylock

### ✅ Localization
- [x] US + Vietnamese keyboard layouts
- [x] Vietnam timezone (Asia/Ho_Chi_Minh)
- [x] Vietnamese locale settings
- [x] Vietnamese fonts (Noto CJK)

### ✅ Development Tools
- [x] Git, GCC, Make
- [x] Ghostty terminal
- [x] Neovim (via Home Manager)
- [x] Essential CLI tools

## 🔄 Quản lý hệ thống

### Update hệ thống
```bash
# Update flake inputs
sudo nix flake update /etc/nixos

# Rebuild system
sudo nixos-rebuild switch --flake /etc/nixos#dell-nixos
```

### Dọn dẹp
```bash
# Xóa các generation cũ
sudo nix-collect-garbage -d

# Optimize store
nix-store --optimize
```

### Rollback nếu có lỗi
```bash
# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback
```

## 🎨 Tùy chỉnh

### Thêm packages
Edit `hosts/dell-5548/configuration.nix`:
```nix
environment.systemPackages = with pkgs; [
  # Existing packages...
  firefox
  code
  # Your packages here
];
```

### Thay đổi Hyprland config
Edit `~/.config/hypr/hyprland.conf` và reload:
```bash
hyprctl reload
```

### Tùy chỉnh Waybar
Edit `~/.config/waybar/config` và restart waybar:
```bash
killall waybar && waybar &
```

## 🐛 Troubleshooting

### Hyprland không start
1. Check logs: `journalctl -u display-manager`
2. Switch to TTY: `Ctrl+Alt+F2`
3. Restart display manager: `sudo systemctl restart greetd`

### Audio không hoạt động
```bash
# Check PipeWire status
systemctl --user status pipewire

# Restart audio services
systemctl --user restart pipewire pipewire-pulse
```

### Brightness không điều chỉnh được
```bash
# Check backlight devices
ls /sys/class/backlight/

# Manual brightness control
brightnessctl set 50%
```

### WiFi không kết nối
```bash
# Check NetworkManager
sudo systemctl status NetworkManager

# Scan networks
nmcli dev wifi

# Connect to network
nmcli dev wifi connect "SSID" password "password"
```

## 📝 Notes

- Configuration được tối ưu cho Dell Inspiron 5548 với Intel HD Graphics 5500
- Hỗ trợ đầy đủ tiếng Việt với Telex/VNI input methods
- Power management được cấu hình cho laptop (TLP)
- Tất cả dotfiles được quản lý declarative
- Sử dụng Flakes cho reproducible builds

## 🤝 Contributing

Nếu bạn có cải tiến hoặc fix bugs, hãy tạo PR!

## 📄 License

MIT License - Sử dụng tự do cho mục đích cá nhân và thương mại.
