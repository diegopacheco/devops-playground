#!/bin/bash

echo "=========================================="
echo "POSTGRESQL PARTITIONING PLAYGROUND"
echo "DOCKER COMPOSE STARTUP SCRIPT"
echo "=========================================="

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if Docker is running
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}✗ Docker is not installed or not in PATH${NC}"
        return 1
    fi
    
    if ! docker info &> /dev/null; then
        echo -e "${RED}✗ Docker daemon is not running${NC}"
        return 1
    fi
    
    return 0
}

# Function to check if docker-compose is available
check_docker_compose() {
    if command -v docker-compose &> /dev/null; then
        COMPOSE_CMD="docker-compose"
        return 0
    elif docker compose version &> /dev/null; then
        COMPOSE_CMD="docker compose"
        return 0
    else
        echo -e "${RED}✗ Neither 'docker-compose' nor 'docker compose' is available${NC}"
        return 1
    fi
}

# Function to wait for PostgreSQL to be ready
wait_for_postgres() {
    echo -e "${BLUE}Waiting for PostgreSQL to be ready...${NC}"
    
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if PGPASSWORD="postgres" psql -h localhost -p 5432 -U postgres -d partitions_db -c "SELECT 1;" &> /dev/null; then
            echo -e "${GREEN}✓ PostgreSQL is ready!${NC}"
            return 0
        fi
        
        echo -e "${YELLOW}Attempt $attempt/$max_attempts: PostgreSQL not ready yet, waiting 2 seconds...${NC}"
        sleep 2
        ((attempt++))
    done
    
    echo -e "${RED}✗ PostgreSQL failed to become ready within $((max_attempts * 2)) seconds${NC}"
    return 1
}

# Function to show running containers
show_container_status() {
    echo ""
    echo -e "${BLUE}Container Status:${NC}"
    docker ps --filter "name=postgres-partitions" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

# Function to show connection information
show_connection_info() {
    echo ""
    echo -e "${GREEN}=========================================="
    echo -e "PostgreSQL Connection Information:"
    echo -e "==========================================${NC}"
    echo "Host: localhost"
    echo "Port: 5432"
    echo "Database: partitions_db"
    echo "Username: postgres"
    echo "Password: postgres"
    echo ""
    echo -e "${BLUE}To connect manually:${NC}"
    echo "psql -h localhost -p 5432 -U postgres -d partitions_db"
    echo ""
    echo -e "${BLUE}To run evidence scripts:${NC}"
    echo "./run-all.sh"
    echo ""
    echo -e "${BLUE}Individual evidence scripts:${NC}"
    echo "./evidence_user_range.sh"
    echo "./evidence_user_list.sh"
    echo "./evidence_user_hash.sh"
    echo "./evidence_user_multilevel.sh"
}

# Function to cleanup on script exit
cleanup() {
    echo ""
    echo -e "${YELLOW}Script interrupted. Container will continue running in background.${NC}"
    echo -e "${BLUE}To stop the container later, run: $COMPOSE_CMD down${NC}"
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Main execution
echo -e "${BLUE}Starting PostgreSQL 17 Partitioning Playground...${NC}"
echo ""

# Check prerequisites
echo -e "${BLUE}Checking prerequisites...${NC}"

if ! check_docker; then
    echo -e "${RED}Please install Docker and ensure it's running${NC}"
    exit 1
fi

if ! check_docker_compose; then
    echo -e "${RED}Please install docker-compose${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker is available and running${NC}"
echo -e "${GREEN}✓ Docker Compose command: $COMPOSE_CMD${NC}"

# Check if required files exist
required_files=("docker-compose.yml" "init.sql")
missing_files=()

for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -gt 0 ]; then
    echo -e "${RED}✗ Missing required files:${NC}"
    for file in "${missing_files[@]}"; do
        echo -e "${RED}  - $file${NC}"
    done
    exit 1
fi

echo -e "${GREEN}✓ All required files are present${NC}"
echo ""

# Stop any existing containers
echo -e "${BLUE}Stopping any existing containers...${NC}"
$COMPOSE_CMD down --remove-orphans

# Start the containers
echo -e "${BLUE}Starting PostgreSQL container...${NC}"
if $COMPOSE_CMD up -d; then
    echo -e "${GREEN}✓ Container started successfully${NC}"
else
    echo -e "${RED}✗ Failed to start container${NC}"
    exit 1
fi

# Show container status
show_container_status

# Wait for PostgreSQL to be ready
if wait_for_postgres; then
    echo -e "${GREEN}✓ Database initialization completed${NC}"
else
    echo -e "${RED}✗ Database initialization failed${NC}"
    echo ""
    echo -e "${BLUE}Container logs:${NC}"
    docker logs postgres-partitions --tail 20
    exit 1
fi

# Show connection information
show_connection_info

# Show database summary
echo -e "${BLUE}Database Summary:${NC}"
PGPASSWORD="postgres" psql -h localhost -p 5432 -U postgres -d partitions_db -c "
SELECT 'Tables Created' as info, COUNT(*) as count 
FROM information_schema.tables 
WHERE table_schema = 'public' AND table_name LIKE 'user_%'
UNION ALL
SELECT 'Total Partitions', COUNT(*) 
FROM pg_tables 
WHERE schemaname = 'public' AND tablename LIKE '%_p%';
"

echo ""
echo -e "${GREEN}🎉 PostgreSQL Partitioning Playground is ready! 🎉${NC}"
echo ""
echo -e "${YELLOW}What's been set up:${NC}"
echo "• PostgreSQL 17 running in Docker"
echo "• 4 different partitioning strategies:"
echo "  - Range partitioning (user_range_v1, user_range_v2)"
echo "  - List partitioning (user_list_v1, user_list_v2)"  
echo "  - Hash partitioning (user_hash_v1, user_hash_v2)"
echo "  - Multilevel partitioning (user_multilevel_v1, user_multilevel_v2)"
echo "• 1000+ records inserted per table across 27+ partitions each"
echo "• Evidence scripts ready to demonstrate partition performance"
echo ""
echo -e "${GREEN}Next steps:${NC}"
echo "1. Run './run-all.sh' to execute all evidence scripts"
echo "2. Or run individual evidence scripts as needed"
echo "3. Connect directly to PostgreSQL for manual exploration"
echo ""
echo -e "${BLUE}The container will continue running until you stop it with:${NC}"
echo "$COMPOSE_CMD down"