#!/bin/bash

echo "=========================================="
echo "POSTGRESQL PARTITIONING PLAYGROUND"
echo "RUNNING ALL EVIDENCE SCRIPTS"
echo "=========================================="

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if PostgreSQL is ready
check_postgres() {
    echo -e "${BLUE}Checking PostgreSQL connection...${NC}"
    PGPASSWORD="postgres" psql -h localhost -p 5432 -U postgres -d partitions_db -c "SELECT 1;" > /dev/null 2>&1
    return $?
}

# Function to run evidence script with error handling
run_evidence_script() {
    local script_name=$1
    local description=$2
    
    echo ""
    echo -e "${YELLOW}=========================================="
    echo -e "RUNNING: $description"
    echo -e "===========================================${NC}"
    
    if [ -f "$script_name" ]; then
        if bash "$script_name"; then
            echo -e "${GREEN}✓ $description completed successfully${NC}"
        else
            echo -e "${RED}✗ $description failed with exit code $?${NC}"
            return 1
        fi
    else
        echo -e "${RED}✗ Script not found: $script_name${NC}"
        return 1
    fi
    
    echo ""
    echo -e "${BLUE}Press Enter to continue or Ctrl+C to stop...${NC}"
    read -r
}

# Main execution
echo -e "${BLUE}Starting PostgreSQL Partitioning Evidence Collection...${NC}"
echo ""

# Check PostgreSQL connection
if ! check_postgres; then
    echo -e "${RED}✗ PostgreSQL is not accessible. Please ensure:${NC}"
    echo "1. Docker container is running (run './run.sh' first)"
    echo "2. PostgreSQL is fully initialized"
    echo "3. Database 'partitions_db' exists"
    echo ""
    echo "To start the database, run: ./run.sh"
    exit 1
fi

echo -e "${GREEN}✓ PostgreSQL connection established${NC}"
echo ""

# Track execution results
failed_scripts=()
successful_scripts=()

# Run each evidence script
echo -e "${YELLOW}Starting evidence collection for all partitioning strategies...${NC}"
echo ""

# 1. Range Partitioning Evidence
if run_evidence_script "evidence_user_range.sh" "Range Partitioning Evidence"; then
    successful_scripts+=("Range Partitioning")
else
    failed_scripts+=("Range Partitioning")
fi

# 2. List Partitioning Evidence
if run_evidence_script "evidence_user_list.sh" "List Partitioning Evidence"; then
    successful_scripts+=("List Partitioning")
else
    failed_scripts+=("List Partitioning")
fi

# 3. Hash Partitioning Evidence
if run_evidence_script "evidence_user_hash.sh" "Hash Partitioning Evidence"; then
    successful_scripts+=("Hash Partitioning")
else
    failed_scripts+=("Hash Partitioning")
fi

# 4. Multilevel Partitioning Evidence
if run_evidence_script "evidence_user_multilevel.sh" "Multilevel Partitioning Evidence"; then
    successful_scripts+=("Multilevel Partitioning")
else
    failed_scripts+=("Multilevel Partitioning")
fi

# Final summary
echo ""
echo -e "${YELLOW}=========================================="
echo -e "EXECUTION SUMMARY"
echo -e "===========================================${NC}"

if [ ${#successful_scripts[@]} -gt 0 ]; then
    echo -e "${GREEN}Successful Evidence Collections (${#successful_scripts[@]}/4):${NC}"
    for script in "${successful_scripts[@]}"; do
        echo -e "${GREEN}  ✓ $script${NC}"
    done
fi

if [ ${#failed_scripts[@]} -gt 0 ]; then
    echo -e "${RED}Failed Evidence Collections (${#failed_scripts[@]}/4):${NC}"
    for script in "${failed_scripts[@]}"; do
        echo -e "${RED}  ✗ $script${NC}"
    done
fi

echo ""
if [ ${#failed_scripts[@]} -eq 0 ]; then
    echo -e "${GREEN}🎉 ALL EVIDENCE SCRIPTS COMPLETED SUCCESSFULLY! 🎉${NC}"
    echo ""
    echo -e "${BLUE}Summary of what was demonstrated:${NC}"
    echo "1. Range Partitioning - Partitioned by ranges of values (explicit and derived keys)"
    echo "2. List Partitioning - Partitioned by discrete lists of values (regions and domains)"
    echo "3. Hash Partitioning - Partitioned by hash function for even distribution"
    echo "4. Multilevel Partitioning - Combined range and hash partitioning (27 total partitions each)"
    echo ""
    echo -e "${BLUE}Each strategy showed:${NC}"
    echo "• Partition existence and structure"
    echo "• Performance differences with and without partition keys"
    echo "• Partition pruning demonstrations"
    echo "• Data distribution across partitions"
    echo ""
    echo -e "${GREEN}All tables contain 1000+ records distributed across 27+ partitions!${NC}"
    exit 0
else
    echo -e "${RED}Some evidence scripts failed. Please check the output above for details.${NC}"
    exit 1
fi