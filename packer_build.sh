#!/bin/bash
set -x
# Usage function to display help
usage() {
    echo "Usage: $0 -v <os_version> -c <cpus> -m <memory> -d <disk_size> -h <headless>"
    echo "       $0 --os-version <os_version> --cpus <cpus> --memory <memory> --disk-size <disk_size> --headless <headless>"
    echo "  -os, --os-version <os_version>   : Ubuntu version (e.g., 24.04)"
    echo "  -c, --cpus <cpus>               : Number of CPUs"
    echo "  -m, --memory <memory>           : Memory size (in MB)"
    echo "  -d, --disk-size <disk_size>     : Disk size (in MB)"
    echo "  -h, --headless <headless>       : Headless mode (true/false)"
    exit 1
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -os|--os-version) os_version="$2"; shift ;;
        -c|--cpus) cpus="$2"; shift ;;
        -m|--memory) memory="$2"; shift ;;
        -d|--disk-size) disk_size="$2"; shift ;;
        -h|--headless) headless="$2"; shift ;;
        -*|--*) echo "Unknown option: $1" ; usage ;;
    esac
    shift
done

# Check if all parameters are provided
if [ -z "$os_version" ] || [ -z "$cpus" ] || [ -z "$memory" ] || [ -z "$disk_size" ] || [ -z "$headless" ]; then
    usage
fi

cd "packer/$os_version" && packer init . && packer build \
                                                -var "os_version=$os_version" \
                                                -var "cpus=$cpus" \
                                                -var "memory=$memory" \
                                                -var "disk_size=$disk_size" \
                                                -var "headless=$headless"