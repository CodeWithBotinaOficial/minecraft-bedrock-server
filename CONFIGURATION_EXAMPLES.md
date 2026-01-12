# MINECRAFT BEDROCK SERVER - CONFIGURATION EXAMPLES

This file contains example `.env` configurations for different use cases.
Copy the relevant section to your `.env` file and customize as needed.

## ============================================================================
## EXAMPLE 1: PERFORMANCE SERVER (High-end hardware)
## ============================================================================
# Optimized for maximum performance with powerful hardware
# Suitable for: Dedicated servers, high player count

MINECRAFT_VERSION=1.21.131.1
SERVER_NAME=High Performance Bedrock Server
MAX_PLAYERS=30
VIEW_DISTANCE=16
TICK_DISTANCE=8
GAMEMODE=survival
DIFFICULTY=hard
ALLOW_CHEATS=false
ONLINE_MODE=true

# High resource allocation
CPU_LIMIT=8.0
CPU_RESERVATION=4.0
MEMORY_LIMIT=8G
MEMORY_RESERVATION=4G

# Performance optimizations
MAX_THREADS=0  # Auto-detect all cores
SERVER_AUTHORITATIVE_MOVEMENT=server-auth-with-rewind

## ============================================================================
## EXAMPLE 2: LOW-END SERVER (Budget hardware)
## ============================================================================
# Optimized for low-resource systems
# Suitable for: Old laptops, Raspberry Pi, shared hosting

MINECRAFT_VERSION=1.21.131.1
SERVER_NAME=Lightweight Bedrock Server
MAX_PLAYERS=5
VIEW_DISTANCE=8
TICK_DISTANCE=4
GAMEMODE=survival
DIFFICULTY=normal
ALLOW_CHEATS=false
ONLINE_MODE=true

# Conservative resource limits
CPU_LIMIT=2.0
CPU_RESERVATION=1.0
MEMORY_LIMIT=2G
MEMORY_RESERVATION=1G

# Performance optimizations for low-end
MAX_THREADS=2
PLAYER_IDLE_TIMEOUT=15  # Kick idle players faster

## ============================================================================
## EXAMPLE 3: CREATIVE BUILD SERVER
## ============================================================================
# Optimized for creative building with friends
# Suitable for: Creative projects, building competitions

MINECRAFT_VERSION=1.21.131.1
SERVER_NAME=Creative Build Server
MAX_PLAYERS=15
VIEW_DISTANCE=14
TICK_DISTANCE=6
GAMEMODE=creative
DIFFICULTY=peaceful
ALLOW_CHEATS=true
ONLINE_MODE=true
ALLOW_LIST=true  # Whitelist only

# Medium resources
CPU_LIMIT=4.0
CPU_RESERVATION=2.0
MEMORY_LIMIT=4G
MEMORY_RESERVATION=2G

# Creative-specific settings
DEFAULT_PLAYER_PERMISSION_LEVEL=operator
PLAYER_IDLE_TIMEOUT=0  # Never kick idle players

## ============================================================================
## EXAMPLE 4: PRIVATE FAMILY SERVER
## ============================================================================
# Safe, private server for family and close friends
# Suitable for: Family gaming, small friend groups

MINECRAFT_VERSION=1.21.131.1
SERVER_NAME=Family Bedrock Server
MAX_PLAYERS=8
VIEW_DISTANCE=12
TICK_DISTANCE=4
GAMEMODE=survival
DIFFICULTY=easy
ALLOW_CHEATS=false
ONLINE_MODE=true
ALLOW_LIST=true  # Family members only

# Moderate resources
CPU_LIMIT=3.0
CPU_RESERVATION=1.5
MEMORY_LIMIT=3G
MEMORY_RESERVATION=1.5G

# Family-friendly settings
DEFAULT_PLAYER_PERMISSION_LEVEL=member
PLAYER_IDLE_TIMEOUT=60  # 1 hour timeout

## ============================================================================
## EXAMPLE 5: HARDCORE SURVIVAL SERVER
## ============================================================================
# Challenging survival experience
# Suitable for: Experienced players, hardcore mode

MINECRAFT_VERSION=1.21.131.1
SERVER_NAME=Hardcore Survival Server
MAX_PLAYERS=10
VIEW_DISTANCE=12
TICK_DISTANCE=4
GAMEMODE=survival
DIFFICULTY=hard
ALLOW_CHEATS=false
ONLINE_MODE=true

# Standard resources
CPU_LIMIT=4.0
CPU_RESERVATION=2.0
MEMORY_LIMIT=4G
MEMORY_RESERVATION=2G

# Hardcore settings
SERVER_AUTHORITATIVE_MOVEMENT=server-auth  # Prevent exploits
SERVER_AUTHORITATIVE_BLOCK_BREAKING=true
CORRECT_PLAYER_MOVEMENT=true

## ============================================================================
## EXAMPLE 6: PUBLIC COMMUNITY SERVER
## ============================================================================
# Open server for public community
# Suitable for: Public servers, community events

MINECRAFT_VERSION=1.21.131.1
SERVER_NAME=Public Community Server
MAX_PLAYERS=20
VIEW_DISTANCE=12
TICK_DISTANCE=4
GAMEMODE=survival
DIFFICULTY=normal
ALLOW_CHEATS=false
ONLINE_MODE=true
ALLOW_LIST=false  # Anyone can join

# Higher resources for public server
CPU_LIMIT=6.0
CPU_RESERVATION=3.0
MEMORY_LIMIT=6G
MEMORY_RESERVATION=3G

# Anti-grief settings
SERVER_AUTHORITATIVE_MOVEMENT=server-auth
DEFAULT_PLAYER_PERMISSION_LEVEL=visitor
PLAYER_IDLE_TIMEOUT=20

## ============================================================================
## EXAMPLE 7: MINIGAME SERVER
## ============================================================================
# Server for custom minigames and adventures
# Suitable for: Custom maps, adventure modes

MINECRAFT_VERSION=1.21.131.1
SERVER_NAME=Minigame Server
MAX_PLAYERS=16
VIEW_DISTANCE=10
TICK_DISTANCE=4
GAMEMODE=adventure
DIFFICULTY=normal
ALLOW_CHEATS=true  # For minigame commands
ONLINE_MODE=true

# Medium resources
CPU_LIMIT=4.0
CPU_RESERVATION=2.0
MEMORY_LIMIT=4G
MEMORY_RESERVATION=2G

# Minigame-specific
DEFAULT_PLAYER_PERMISSION_LEVEL=member
TEXTUREPACK_REQUIRED=true  # Force resource packs

## ============================================================================
## EXAMPLE 8: TESTING/DEVELOPMENT SERVER
## ============================================================================
# Server for testing mods, addons, and configurations
# Suitable for: Developers, addon creators

MINECRAFT_VERSION=LATEST  # Always use latest version
SERVER_NAME=Development Test Server
MAX_PLAYERS=3
VIEW_DISTANCE=10
TICK_DISTANCE=4
GAMEMODE=creative
DIFFICULTY=peaceful
ALLOW_CHEATS=true
ONLINE_MODE=false  # Easier testing without auth

# Low resources for testing
CPU_LIMIT=2.0
CPU_RESERVATION=1.0
MEMORY_LIMIT=2G
MEMORY_RESERVATION=1G

# Development settings
LOG_LEVEL=VERBOSE
CONTENT_LOG_FILE_ENABLED=true
ENABLE_ROLLING_LOGS=true

## ============================================================================
## EXAMPLE 9: LAN PARTY SERVER
## ============================================================================
# Local network server for LAN parties
# Suitable for: Local events, no internet required

MINECRAFT_VERSION=1.21.131.1
SERVER_NAME=LAN Party Server
MAX_PLAYERS=12
VIEW_DISTANCE=14
TICK_DISTANCE=6
GAMEMODE=survival
DIFFICULTY=normal
ALLOW_CHEATS=true  # For LAN party fun
ONLINE_MODE=false  # No internet authentication needed

# Good resources for LAN
CPU_LIMIT=4.0
CPU_RESERVATION=2.0
MEMORY_LIMIT=4G
MEMORY_RESERVATION=2G

# LAN-specific
PLAYIT_NETWORK_MODE=bridge  # Don't use host network
PLAYER_IDLE_TIMEOUT=0

## ============================================================================
## EXAMPLE 10: ROLEPLAY SERVER
## ============================================================================
# Server for roleplay and storytelling
# Suitable for: RP communities, story-driven gameplay

MINECRAFT_VERSION=1.21.131.1
SERVER_NAME=Roleplay Adventure Server
MAX_PLAYERS=15
VIEW_DISTANCE=12
TICK_DISTANCE=4
GAMEMODE=adventure
DIFFICULTY=normal
ALLOW_CHEATS=true  # For RP commands
ONLINE_MODE=true
ALLOW_LIST=true

# Medium-high resources
CPU_LIMIT=5.0
CPU_RESERVATION=2.5
MEMORY_LIMIT=5G
MEMORY_RESERVATION=2.5G

# RP-specific
DEFAULT_PLAYER_PERMISSION_LEVEL=member
TEXTUREPACK_REQUIRED=true
PLAYER_IDLE_TIMEOUT=0  # Don't kick during RP

## ============================================================================
## NOTES
## ============================================================================

# Resource Allocation Guidelines:
# - Low-end:     1-2 CPU cores, 1-2GB RAM, 5-8 players
# - Medium:      2-4 CPU cores, 2-4GB RAM, 8-15 players
# - High-end:    4-8 CPU cores, 4-8GB RAM, 15-30 players
# - Enterprise:  8+ CPU cores, 8GB+ RAM, 30+ players

# View Distance Impact:
# - 5-8:   Low resources, close render distance
# - 10-12: Balanced, recommended for most servers
# - 14-16: High resources, beautiful vistas
# - 18+:   Very high resources, use only on powerful hardware

# Tick Distance Impact:
# - 4:     Recommended, balanced simulation
# - 6:     Higher, more realistic but resource-intensive
# - 8+:    Very high, only for powerful servers

# Network Mode (Playit.gg):
# - host:   Easier setup, shares host network (recommended)
# - bridge: Better isolation, requires port configuration