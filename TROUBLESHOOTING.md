# TROUBLESHOOTING GUIDE

Common issues and solutions for the Minecraft Bedrock Server

## ============================================================================
## DOCKER & CONTAINER ISSUES
## ============================================================================

### ❌ Error: "pull access denied for playit/playit"

**Problem:** The Playit.gg Docker image name is incorrect.

**Solution:** 
Update your `.env` file:
```bash
PLAYIT_IMAGE=playitcloud/playit:latest
```

**Alternative images:**
- `playitcloud/playit:latest` - Official (recommended)
- `pepaondrugs/playitgg-docker:latest` - Community image with 50K+ pulls
- `wisdomsky/playit-docker-web:latest` - Includes Web UI (port 8008)

Then restart:
```bash
docker compose down
docker compose pull
docker compose up -d
```

---

### ❌ Error: "version is obsolete"

**Problem:** Docker Compose warning about version field.

**Solution:** This is just a warning and can be safely ignored. Docker Compose v2+ doesn't require the `version` field, but it's kept for backwards compatibility.

To remove the warning, you can delete the first line `version: '3.8'` from `docker-compose.yml`, but it's not necessary.

---

### ❌ Container keeps restarting

**Check logs:**
```bash
docker compose logs minecraft-bedrock
```

**Common causes:**

1. **Port already in use:**
```bash
# Check if port 19132 is in use
sudo lsof -i :19132
# or
sudo netstat -tulpn | grep 19132
```

**Solution:** Change port in `.env`:
```bash
HOST_PORT=19133  # Use different port
```

2. **Insufficient memory:**
Check if you have enough RAM:
```bash
docker stats
```

**Solution:** Reduce memory limit in `.env`:
```bash
MEMORY_LIMIT=2G
MEMORY_RESERVATION=1G
```

3. **Invalid world folder:**
Make sure `LEVEL_NAME` in `.env` matches your world folder name exactly.

---

### ❌ Cannot connect to container

**Check container status:**
```bash
docker compose ps
```

**Check if healthy:**
```bash
docker inspect minecraft-bedrock-server --format='{{.State.Health.Status}}'
```

If unhealthy, check logs:
```bash
docker compose logs --tail=100 minecraft-bedrock
```

---

## ============================================================================
## MINECRAFT SERVER ISSUES
## ============================================================================

### ❌ Can't connect from Minecraft client

**1. Verify server is running:**
```bash
docker compose ps
# Should show "Up" and "healthy"
```

**2. Check server version matches client:**
Your Minecraft Bedrock client must be version `1.21.131.1`.

To change server version, edit `.env`:
```bash
MINECRAFT_VERSION=1.21.131.1
```

Then restart:
```bash
docker compose restart minecraft-bedrock
```

**3. Try direct connection first (LAN):**
Find your local IP:
```bash
# Linux/Mac
ip addr show | grep inet

# Or
hostname -I
```

Connect in Minecraft: `<your-local-ip>:19132`

**4. Check firewall:**
```bash
# Ubuntu/Debian
sudo ufw status
sudo ufw allow 19132/udp

# Fedora/RHEL
sudo firewall-cmd --add-port=19132/udp --permanent
sudo firewall-cmd --reload
```

---

### ❌ World not loading

**1. Verify world folder exists:**
```bash
ls -la worlds/
```

**2. Check LEVEL_NAME matches folder name:**
```bash
# In .env file
LEVEL_NAME=YourWorldName  # Must match folder name EXACTLY
```

**3. Check permissions:**
```bash
chmod -R 755 worlds/
```

**4. Verify world files are valid:**
Your world folder should contain:
- `db/` directory
- `level.dat` file
- `levelname.txt` file

**5. Check server logs:**
```bash
docker compose logs minecraft-bedrock | grep -i world
```

---

### ❌ Server is laggy / slow

**1. Reduce view distance:**
Edit `.env`:
```bash
VIEW_DISTANCE=8  # Lower from 12
TICK_DISTANCE=4  # Keep at 4
```

**2. Reduce max players:**
```bash
MAX_PLAYERS=5  # Lower from 10
```

**3. Check host resources:**
```bash
# Check CPU and RAM usage
docker stats

# Check disk I/O
iostat -x 1
```

**4. Move to SSD:**
If using HDD, performance will be significantly better on SSD.

**5. Increase resource limits (if you have spare resources):**
```bash
CPU_LIMIT=6.0
MEMORY_LIMIT=6G
```

---

## ============================================================================
## PLAYIT.GG ISSUES
## ============================================================================

### ❌ Playit.gg tunnel not working

**1. Check if Playit container is running:**
```bash
docker compose ps playit
```

**2. Check Playit logs:**
```bash
docker compose logs -f playit
```

**3. Get claim URL:**
If you see a claim URL, visit it in your browser to claim the tunnel.

**4. Verify tunnel is claimed:**
```bash
ls -la playit/
cat playit/playit.toml
```

You should see a `secret_key` in the file.

**5. Restart Playit:**
```bash
docker compose restart playit
```

---

### ❌ Friends can't connect via Playit.gg

**1. Verify tunnel configuration:**
Log into https://playit.gg and check:
- Protocol: UDP
- Local Port: 19132
- Status: Active/Connected

**2. Give them the correct address:**
The address should look like: `XX.ip.gl.ply.gg:47XXX`

**3. Some ISPs block Playit.gg domains:**
This is a known limitation of the free tier. 

**Solutions:**
- Try from different network (mobile data)
- Upgrade to Playit.gg Premium ($3/month) for custom domain
- Use alternative: CloudFlare Tunnels (requires cloudflared on client)

**4. Check if using IPv6:**
Some Playit addresses use IPv6. Ensure friends have IPv6 connectivity.

---

### ❌ Playit tunnel disconnects frequently

**1. Check internet stability:**
Unstable internet can cause disconnections.

**2. Increase container restart delay:**
Edit `docker-compose.yml` (advanced):
```yaml
restart_policy:
  condition: on-failure
  delay: 10s
  max_attempts: 5
```

**3. Check logs for errors:**
```bash
docker compose logs --tail=200 playit
```

---

## ============================================================================
## PERMISSION ISSUES
## ============================================================================

### ❌ Permission denied errors

**1. Fix directory permissions:**
```bash
sudo chown -R $USER:$USER data/ worlds/ backups/ playit/
chmod -R 755 data/ worlds/ backups/ playit/
```

**2. Check Docker permissions:**
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Log out and back in for changes to take effect
```

**3. Run with correct UID/GID (advanced):**
Add to `.env`:
```bash
PUID=1000  # Your user ID (run: id -u)
PGID=1000  # Your group ID (run: id -g)
```

---

## ============================================================================
## BACKUP & RESTORE ISSUES
## ============================================================================

### ❌ Backup failed

**1. Check disk space:**
```bash
df -h
```

**2. Ensure backup directory exists:**
```bash
mkdir -p backups/
chmod 755 backups/
```

**3. Manual backup:**
```bash
docker compose down
tar -czf backups/backup-$(date +%Y%m%d-%H%M%S).tar.gz data/
docker compose up -d
```

---

### ❌ Restore not working

**1. Stop server first:**
```bash
docker compose down
```

**2. Backup current data (just in case):**
```bash
mv data/ data.old/
```

**3. Extract backup:**
```bash
tar -xzf backups/your-backup.tar.gz
```

**4. Fix permissions:**
```bash
chmod -R 755 data/
```

**5. Start server:**
```bash
docker compose up -d
```

---

## ============================================================================
## UPGRADE & UPDATE ISSUES
## ============================================================================

### ❌ Server won't start after update

**1. Check version compatibility:**
Ensure client and server versions match.

**2. Clear old data (if necessary):**
```bash
docker compose down
docker compose rm -f
docker volume prune
docker compose up -d
```

**3. Rebuild containers:**
```bash
docker compose down
docker compose build --no-cache
docker compose up -d
```

---

### ❌ Version mismatch

**Error:** "Client version X doesn't match server version Y"

**Solution:** Update `.env` to match your client version:
```bash
MINECRAFT_VERSION=1.21.131.1  # Match your client
```

Then:
```bash
docker compose down
docker compose pull
docker compose up -d
```

---

## ============================================================================
## NETWORKING ISSUES
## ============================================================================

### ❌ DNS resolution problems

**1. Test DNS inside container:**
```bash
docker compose exec minecraft-bedrock ping -c 3 google.com
```

**2. Use Google DNS:**
Edit `docker-compose.yml` and add to minecraft-bedrock service:
```yaml
dns:
  - 8.8.8.8
  - 8.8.4.4
```

---

### ❌ IPv6 issues

**Disable IPv6 if causing problems:**

In `.env`:
```bash
SERVER_PORTV6=0  # Disable IPv6 port
```

---

## ============================================================================
## PERFORMANCE OPTIMIZATION
## ============================================================================

### 🚀 Optimize for low-end hardware

```bash
# .env configuration
VIEW_DISTANCE=6
TICK_DISTANCE=4
MAX_PLAYERS=5
MAX_THREADS=2
CPU_LIMIT=2.0
MEMORY_LIMIT=2G
```

### 🚀 Optimize for high-end hardware

```bash
# .env configuration
VIEW_DISTANCE=16
TICK_DISTANCE=8
MAX_PLAYERS=30
MAX_THREADS=0  # Auto-detect
CPU_LIMIT=8.0
MEMORY_LIMIT=8G
```

---

## ============================================================================
## GETTING HELP
## ============================================================================

If none of these solutions work:

1. **Collect information:**
```bash
# Get all logs
docker compose logs > debug.log

# Get system info
docker version >> debug.log
docker compose version >> debug.log
uname -a >> debug.log
```

2. **Check GitHub Issues:**
https://github.com/yourusername/minecraft-bedrock-server/issues

3. **Ask for help:**
Create a new issue with:
- Your `.env` configuration (remove sensitive info)
- Full logs from `docker compose logs`
- Steps to reproduce the problem
- Your system information

---

## ✅ Still having issues?

Remember to:
- ✅ Check Docker logs: `docker compose logs`
- ✅ Verify `.env` configuration
- ✅ Ensure versions match (client vs server)
- ✅ Test locally before remote connection
- ✅ Check firewall and network settings
