#!/bin/bash

# ============================================================================
# MINECRAFT BEDROCK SERVER - QUICK START SCRIPT
# ============================================================================
# This script helps you set up the Minecraft Bedrock server quickly
# Run: chmod +x setup.sh && ./setup.sh
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ============================================================================
# BANNER
# ============================================================================
clear
echo -e "${BLUE}"
echo "════════════════════════════════════════════════════════════════════════════════"
echo "    🎮 MINECRAFT BEDROCK SERVER - SETUP SCRIPT"
echo "════════════════════════════════════════════════════════════════════════════════"
echo -e "${NC}"

# ============================================================================
# CHECK PREREQUISITES
# ============================================================================
print_info "Checking prerequisites..."

if ! command_exists docker; then
    print_error "Docker is not installed!"
    echo "Please install Docker: https://docs.docker.com/get-docker/"
    exit 1
fi
print_success "Docker found: $(docker --version)"

if ! command_exists docker-compose && ! docker compose version >/dev/null 2>&1; then
    print_error "Docker Compose is not installed!"
    echo "Please install Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi
print_success "Docker Compose found: $(docker compose version)"

# ============================================================================
# CREATE DIRECTORY STRUCTURE
# ============================================================================
print_info "Creating directory structure..."

mkdir -p data worlds backups playit resource_packs behavior_packs

print_success "Directories created"

# ============================================================================
# SETUP ENVIRONMENT FILE
# ============================================================================
if [ ! -f .env ]; then
    print_info "Creating .env file from template..."
    cp .env.example .env
    print_success ".env file created"
    print_warning "Please edit the .env file to configure your server"
else
    print_warning ".env file already exists, skipping..."
fi

# ============================================================================
# CONFIGURATION WIZARD (Optional)
# ============================================================================
echo ""
read -p "Would you like to configure the server now? (y/n): " configure

if [[ $configure == "y" || $configure == "Y" ]]; then
    echo ""
    print_info "Server Configuration"
    echo "────────────────────────────────────────────────────────────────────────────────"
    
    # Server Name
    read -p "Server Name [My Bedrock Server]: " server_name
    server_name=${server_name:-My Bedrock Server}
    sed -i "s/^SERVER_NAME=.*/SERVER_NAME=$server_name/" .env
    
    # Max Players
    read -p "Maximum Players [10]: " max_players
    max_players=${max_players:-10}
    sed -i "s/^MAX_PLAYERS=.*/MAX_PLAYERS=$max_players/" .env
    
    # Gamemode
    echo ""
    echo "Select Game Mode:"
    echo "1) Survival"
    echo "2) Creative"
    echo "3) Adventure"
    read -p "Choice [1]: " gamemode_choice
    gamemode_choice=${gamemode_choice:-1}
    case $gamemode_choice in
        1) gamemode="survival" ;;
        2) gamemode="creative" ;;
        3) gamemode="adventure" ;;
        *) gamemode="survival" ;;
    esac
    sed -i "s/^GAMEMODE=.*/GAMEMODE=$gamemode/" .env
    
    # Difficulty
    echo ""
    echo "Select Difficulty:"
    echo "1) Peaceful"
    echo "2) Easy"
    echo "3) Normal"
    echo "4) Hard"
    read -p "Choice [3]: " difficulty_choice
    difficulty_choice=${difficulty_choice:-3}
    case $difficulty_choice in
        1) difficulty="peaceful" ;;
        2) difficulty="easy" ;;
        3) difficulty="normal" ;;
        4) difficulty="hard" ;;
        *) difficulty="normal" ;;
    esac
    sed -i "s/^DIFFICULTY=.*/DIFFICULTY=$difficulty/" .env
    
    # Resource Limits
    echo ""
    read -p "CPU Limit (cores) [4.0]: " cpu_limit
    cpu_limit=${cpu_limit:-4.0}
    sed -i "s/^CPU_LIMIT=.*/CPU_LIMIT=$cpu_limit/" .env
    
    read -p "Memory Limit (e.g., 4G) [4G]: " memory_limit
    memory_limit=${memory_limit:-4G}
    sed -i "s/^MEMORY_LIMIT=.*/MEMORY_LIMIT=$memory_limit/" .env
    
    print_success "Configuration saved!"
fi

# ============================================================================
# CUSTOM WORLD IMPORT (Optional)
# ============================================================================
echo ""
read -p "Do you have a custom world to import? (y/n): " import_world

if [[ $import_world == "y" || $import_world == "Y" ]]; then
    echo ""
    print_info "Custom World Import"
    echo "────────────────────────────────────────────────────────────────────────────────"
    print_warning "Make sure your .mcworld file is in this directory"
    
    read -p "Enter the .mcworld filename (or path): " world_file
    
    if [ -f "$world_file" ]; then
        world_name=$(basename "$world_file" .mcworld)
        print_info "Extracting world: $world_name"
        
        # Rename to .zip and extract
        cp "$world_file" "$world_name.zip"
        unzip -q "$world_name.zip" -d "worlds/$world_name"
        rm "$world_name.zip"
        
        # Update .env with world name
        sed -i "s/^LEVEL_NAME=.*/LEVEL_NAME=$world_name/" .env
        
        print_success "World imported: $world_name"
        print_info "Updated LEVEL_NAME in .env to: $world_name"
    else
        print_error "File not found: $world_file"
        print_warning "You can manually extract your world later to ./worlds/"
    fi
fi

# ============================================================================
# PULL DOCKER IMAGES
# ============================================================================
echo ""
read -p "Pull Docker images now? (y/n): " pull_images

if [[ $pull_images == "y" || $pull_images == "Y" ]]; then
    print_info "Pulling Docker images..."
    docker compose pull
    print_success "Images pulled successfully"
fi

# ============================================================================
# START SERVER
# ============================================================================
echo ""
read -p "Start the server now? (y/n): " start_server

if [[ $start_server == "y" || $start_server == "Y" ]]; then
    print_info "Starting Minecraft Bedrock Server..."
    docker compose up -d
    
    echo ""
    print_success "Server started!"
    
    # Wait a bit for containers to start
    sleep 3
    
    # Show status
    print_info "Container Status:"
    docker compose ps
    
    echo ""
    print_info "To view logs: docker compose logs -f"
    print_info "To stop server: docker compose down"
    
    # Playit.gg setup reminder
    echo ""
    print_warning "📡 PLAYIT.GG SETUP REQUIRED"
    echo "────────────────────────────────────────────────────────────────────────────────"
    print_info "Run this command to get your Playit.gg claim URL:"
    echo -e "${YELLOW}docker compose logs playit${NC}"
    echo ""
    print_info "Then visit the claim URL in your browser to get your public address"
fi

# ============================================================================
# FINAL INFORMATION
# ============================================================================
echo ""
echo -e "${GREEN}"
echo "════════════════════════════════════════════════════════════════════════════════"
echo "    ✅ SETUP COMPLETE!"
echo "════════════════════════════════════════════════════════════════════════════════"
echo -e "${NC}"

echo ""
print_info "📝 NEXT STEPS:"
echo ""
echo "1. Wait for server to fully start (check with: docker compose logs -f minecraft-bedrock)"
echo ""
echo "2. Setup Playit.gg tunnel:"
echo "   docker compose logs playit"
echo "   Visit the claim URL and configure your tunnel"
echo ""
echo "3. Connect to your server:"
echo "   - Local: <your-ip>:19132"
echo "   - Internet: <playit-address> (from step 2)"
echo ""
echo "4. Useful commands:"
echo "   docker compose up -d          # Start server"
echo "   docker compose down           # Stop server"
echo "   docker compose restart        # Restart server"
echo "   docker compose logs -f        # View logs"
echo "   docker compose ps             # Check status"
echo ""

print_info "📖 Documentation:"
echo "   - README.md                   # Full documentation"
echo "   - TROUBLESHOOTING.md          # Common issues"
echo "   - CONFIGURATION_EXAMPLES.md   # Pre-made configs"
echo ""

print_success "Happy mining! ⛏️"
echo ""
