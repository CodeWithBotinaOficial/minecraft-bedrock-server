# 🎮 Minecraft Bedrock Server - Docker Compose

A production-ready, portable Minecraft Bedrock Edition server using Docker, with **Playit.gg** for free internet exposure.

## 📋 Features

- ✅ **Minecraft Bedrock Server 1.21.131.1** (locked version for stability)
- ✅ **Custom world support** - Import your existing worlds
- ✅ **Playit.gg integration** - Free internet exposure without port forwarding
- ✅ **Docker Compose** - Easy deployment and management
- ✅ **Resource limits** - Won't consume all host resources
- ✅ **Health checks** - Auto-restart on failure
- ✅ **Persistent data** - Worlds and configs survive container restarts
- ✅ **GitHub ready** - Clone and run on any device

---

## 🖥️ System Requirements

### Minimum:
- **CPU**: 2 cores
- **RAM**: 2GB
- **Storage**: 5GB free space
- **OS**: Linux, macOS, or Windows with Docker

### Recommended:
- **CPU**: 4+ cores
- **RAM**: 4GB+
- **Storage**: 10GB+ (SSD preferred)

---

## 🚀 Quick Start

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/yourusername/minecraft-bedrock-server.git
cd minecraft-bedrock-server
```

### 2️⃣ Prepare Your Custom World (Optional)

If you want to use your existing Minecraft world:

#### **Export from Windows 10/11 Minecraft:**
1. Open Minecraft Bedrock Edition
2. Click the **Edit** icon (✏️) next to your world
3. Scroll down in the **Game** menu
4. Click **Export World**
5. Save the `.mcworld` file

#### **Extract and Place:**
```bash
# Create worlds directory
mkdir -p worlds

# Rename .mcworld to .zip
mv YourWorld.mcworld YourWorld.zip

# Extract
unzip YourWorld.zip -d worlds/YourWorld

# Remove the zip file
rm YourWorld.zip
```

Your structure should look like:
```
worlds/
└── YourWorld/
    ├── db/
    ├── level.dat
    ├── levelname.txt
    └── ... (other world files)
```

#### **Update Configuration:**
Edit `docker-compose.yml` and change:
```yaml
LEVEL_NAME: "YourWorld"  # Must match your world folder name
```

### 3️⃣ Create Required Directories

```bash
mkdir -p data worlds backups playit behavior_packs resource_packs
```

### 4️⃣ Configure Environment Variables (REQUIRED)

```bash
# Copy the example file
cp .env.example .env

# Edit with your preferences
nano .env  # or use your preferred editor (vim, code, etc.)
```

**Important settings to configure:**
- `LEVEL_NAME` - Must match your world folder name (if using custom world)
- `SERVER_NAME` - Your server's display name
- `MAX_PLAYERS` - Maximum concurrent players
- `MINECRAFT_VERSION` - Locked to 1.21.131.1 by default
- `CPU_LIMIT` / `MEMORY_LIMIT` - Adjust based on your hardware

### 5️⃣ Start the Server

```bash
docker compose up -d
```

### 6️⃣ Setup Playit.gg Tunnel

#### **First-time setup:**

1. **Start the services:**
```bash
docker compose up -d
```

2. **Check Playit.gg logs to get the claim URL:**
```bash
docker compose logs -f playit
```

3. **You'll see output like:**
```
Visit https://playit.gg/login?claim_key=XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
```

4. **Open the URL in your browser:**
   - Create an account or log in to Playit.gg
   - Claim your agent
   - Add a tunnel with these settings:
     - **Protocol**: UDP
     - **Local Port**: `19132`
     - **Local IP**: Leave default (localhost)

5. **You'll receive a public address like:**
```
XX.tcp.ply.gg:47XXX  (for display)
XX.ip.gl.ply.gg:47XXX  (actual connection address)
```

6. **Share the connection address with your friends!**

#### **To persist your configuration (optional):**
After claiming, you can find your secret key in `./playit/playit.toml`.
Copy the `secret_key` value to your `.env` file:
```bash
PLAYIT_SECRET=your-secret-key-here
```

This way, if you recreate the container, you won't need to claim again.

---

## 🎯 Usage

### Start the Server
```bash
docker compose up -d
```

### Stop the Server
```bash
docker compose down
```

### View Logs
```bash
# All services
docker compose logs -f

# Just Minecraft server
docker compose logs -f minecraft-bedrock

# Just Playit.gg
docker compose logs -f playit
```

### Restart the Server
```bash
docker compose restart minecraft-bedrock
```

### Update Server Version

Edit your `.env` file:
```bash
MINECRAFT_VERSION=1.21.140.0  # Change to desired version
```

Then:
```bash
docker compose pull
docker compose up -d
```

---

## 📁 Project Structure

```
minecraft-bedrock-server/
├── docker-compose.yml       # Main configuration
├── .env.example             # Environment template
├── .gitignore              # Git exclusions
├── README.md               # This file
├── data/                   # Server data (auto-created)
│   ├── server.properties
│   ├── permissions.json
│   ├── allowlist.json
│   └── worlds/            # Active world
├── worlds/                # Custom worlds (place here)
│   └── YourWorld/
├── playit/                # Playit.gg config (auto-created)
└── backups/               # Backups (manual/auto)
```

---

## ⚙️ Configuration

### ⚠️ Important: All configuration is done via `.env` file

**DO NOT modify `docker-compose.yml` directly**. All settings are controlled through the `.env` file.

### Server Settings

Edit your `.env` file to customize these settings:

| Variable | Default | Description |
|----------|---------|-------------|
| `SERVER_NAME` | My Bedrock Server | Server name visible to players |
| `LEVEL_NAME` | Bedrock level | World folder name to load |
| `MINECRAFT_VERSION` | 1.21.131.1 | Server version (must match client) |
| `GAMEMODE` | survival | survival, creative, adventure |
| `DIFFICULTY` | normal | peaceful, easy, normal, hard |
| `MAX_PLAYERS` | 10 | Maximum concurrent players |
| `VIEW_DISTANCE` | 12 | Render distance (5-32 chunks) |
| `TICK_DISTANCE` | 4 | Simulation distance (4-12 chunks) |
| `ALLOW_CHEATS` | false | Enable/disable commands |
| `ONLINE_MODE` | true | Require Xbox Live auth |
| `CPU_LIMIT` | 4.0 | Maximum CPU cores |
| `MEMORY_LIMIT` | 4G | Maximum RAM |

**See `.env.example` for ALL available options (60+ configuration variables)**

### Resource Limits

Adjust in your `.env` file:
```bash
# Maximum resources
CPU_LIMIT=4.0           # Max CPU cores
MEMORY_LIMIT=4G         # Max RAM

# Reserved resources
CPU_RESERVATION=2.0     # Guaranteed CPU cores
MEMORY_RESERVATION=2G   # Guaranteed RAM
```

---

## 🔧 Advanced Configuration

### Allowlist (Whitelist)

1. Set `ALLOW_LIST=true` in your `.env` file
2. Edit `data/allowlist.json`:
```json
[
  {
    "ignoresPlayerLimit": false,
    "name": "PlayerName",
    "xuid": "1234567890123456"
  }
]
```
3. Restart server

### Operators (Admin)

Edit `data/permissions.json`:
```json
[
  {
    "permission": "operator",
    "xuid": "1234567890123456"
  }
]
```

### Custom Server Properties

After first run, edit `data/server.properties` directly.

---

## 💾 Backup & Restore

### Manual Backup
```bash
# Stop server
docker compose down

# Create backup
tar -czf backups/backup-$(date +%Y%m%d-%H%M%S).tar.gz data/

# Start server
docker compose up -d
```

### Restore from Backup
```bash
# Stop server
docker compose down

# Remove current data
rm -rf data/

# Extract backup
tar -xzf backups/backup-YYYYMMDD-HHMMSS.tar.gz

# Start server
docker compose up -d
```

---

## 🐛 Troubleshooting

### Server won't start
```bash
# Check logs
docker compose logs minecraft-bedrock

# Common issues:
# 1. Port 19132 already in use
# 2. Insufficient permissions on data/ directory
# 3. Invalid world folder name
```

### Can't connect from Minecraft client
1. Verify server is running: `docker compose ps`
2. Check Playit.gg tunnel is active: `docker compose logs playit`
3. Ensure client version matches server version (1.21.131.1)
4. Try direct LAN connection first: `<your-local-ip>:19132`

### World not loading
1. Check `LEVEL_NAME` matches your folder name exactly
2. Verify world files exist in `worlds/YourWorld/`
3. Check permissions: `chmod -R 755 worlds/`

### Playit.gg tunnel not working
```bash
# Restart Playit container
docker compose restart playit

# Reclaim tunnel
docker compose logs playit  # Get new claim URL
```

### Performance issues
1. Reduce `VIEW_DISTANCE` (try 8-10)
2. Reduce `MAX_PLAYERS`
3. Increase resource limits in `docker-compose.yml`
4. Check host system resources: `htop` or `docker stats`

---

## 🔒 Security Best Practices

1. **Enable allowlist** for private servers
2. **Keep `ONLINE_MODE: true`** to require Xbox authentication
3. **Regular backups** - Automate with cron
4. **Update regularly** - Change `VERSION` and redeploy
5. **Monitor logs** for suspicious activity
6. **Limit operators** - Only trusted players

---

## 📝 Environment Variables Reference

See `.env.example` for all available options.

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

---

## 📜 License

MIT License - See LICENSE file for details

---

## 🙏 Acknowledgments

- [itzg/docker-minecraft-bedrock-server](https://github.com/itzg/docker-minecraft-bedrock-server)
- [Playit.gg](https://playit.gg) for free tunneling service
- Minecraft Bedrock community

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/minecraft-bedrock-server/issues)
- **Discord**: [Your Discord Server]
- **Documentation**: [Minecraft Bedrock Wiki](https://minecraft.wiki/)

---

## 🎮 Happy Mining! ⛏️
