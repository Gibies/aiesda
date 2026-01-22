#!/bin/bash
# --- 1. Configuration ---
VERSION="0.1.0"
PROJECT_NAME="aiesda"
PROJECT_ROOT=$(pwd)
BUILD_DIR="${HOME}/build/${PROJECT_NAME}_build_${VERSION}"
MODULE_FILE="${HOME}/modulefiles/${PROJECT_NAME}/${VERSION}"
REQUIREMENTS="${PROJECT_ROOT}/requirement.txt"
AIESDA_INSTALLED_ROOT="${BUILD_DIR}"

# --- 2. Block Definition ---
NATIVE_BLOCKS=(
    "Numerical and Data Handling"
    "Geospatial Visualization"
    "AI and Deep Learning"
    "Meteorological Specifics"
    "Configuration and Logging Libraries"
    "ECMWF Anemoi and Related Stack"
)

COMPLEX_BLOCKS=(
    "NCAR Legacy Graphics and I/O"
    "JCSDA JEDI and Related Stack"
)

echo "🚀 Starting Sequential Block-Wise Installation..."

# Optimized Helper: Surgical extraction between markers
get_req_block() {
    local block_name=$1
    if [ -f "$REQUIREMENTS" ]; then
        sed -n "/# === BLOCK: ${block_name} ===/,/# === END BLOCK ===/p" "$REQUIREMENTS" | \
            sed "/# ===/d; /^#/d; /^\s*$/d; s/[[:space:]]*#.*//g"
    fi
}

# --- 3. Dependency Management Loop ---
echo "🐍 Upgrading pip..."
python3 -m pip install --user --upgrade pip --break-system-packages

for block in "${NATIVE_BLOCKS[@]}"; do
    echo "📦 Installing block: [$block]..."
    PKGS=$(get_req_block "$block")
    if [ ! -z "$PKGS" ]; then
        python3 -m pip install --user $PKGS --break-system-packages
    fi
done

# Check Complex Blocks
DA_MISSING=0
for block in "${COMPLEX_BLOCKS[@]}"; do
    echo "🔍 Checking complex block: [$block]..."
    PKGS=$(get_req_block "$block")
    for pkg in $PKGS; do
        lib=$(echo $pkg | sed 's/py//' | cut -d'=' -f1 | cut -d'>' -f1 | tr -d '[:space:]')
        if ! python3 -c "import $lib" &>/dev/null; then
            echo "❌ $lib not found."
            DA_MISSING=1
        fi
    done
done

# --- 4. WSL/Laptop Docker Fallback ---
if [ $DA_MISSING -eq 1 ]; then
    echo "🐳 Complex libraries missing. Building Docker Fallback..."
    if command -v docker &>/dev/null; then
        cat << EOF > Dockerfile
FROM jcsda/docker-gnu-openmpi-dev:latest
WORKDIR /home/aiesda
COPY requirement.txt .
RUN pip3 install --no-cache-dir -r requirement.txt --break-system-packages
ENV PYTHONPATH="/home/aiesda/lib/aiesda/pylib:/home/aiesda/lib/aiesda/pydic:\${PYTHONPATH}"
ENV PATH="/home/aiesda/lib/aiesda/scripts:/home/aiesda/lib/aiesda/jobs:\${PATH}"
EOF
        docker build -t aiesda_da:latest .
        ! grep -q "aida-run" ~/.bashrc && echo "alias aida-run='docker run -it --rm -v \$(pwd):/home/aiesda aiesda_da:latest'" >> ~/.bashrc
    fi
fi

# --- 5. Build and Module Generation ---
echo "🏗️ Building Python package..."
rm -rf "${BUILD_DIR}"
python3 setup.py build --build-base "${BUILD_DIR}"

AIESDA_INTERNAL_LIB="${BUILD_DIR}/lib/aiesda"
mkdir -p "${AIESDA_INTERNAL_LIB}"
for asset in nml yaml jobs scripts pydic; do
    [ -d "${PROJECT_ROOT}/$asset" ] && cp -rp "${PROJECT_ROOT}/$asset" "${AIESDA_INTERNAL_LIB}/"
done

mkdir -p $(dirname "${MODULE_FILE}")
cat << EOF > "${MODULE_FILE}"
#%Module1.0
## AIESDA v${VERSION}

if { [is-loaded jedi] == 0 } {
    module load jedi/1.5.0
}

set version      ${VERSION}
set aiesda_root  ${AIESDA_INSTALLED_ROOT}

setenv           AIESDA_VERSION  ${VERSION}
setenv           AIESDA_ROOT     \$aiesda_root/lib/aiesda
setenv           AIESDA_NML      \$aiesda_root/lib/aiesda/nml
setenv           AIESDA_YAML     \$aiesda_root/lib/aiesda/yaml

prepend-path     PYTHONPATH      \$aiesda_root/lib/aiesda/pylib
prepend-path     PYTHONPATH      \$aiesda_root/lib/aiesda/pydic
prepend-path     PATH            \$aiesda_root/lib/aiesda/scripts
prepend-path     PATH            \$aiesda_root/lib/aiesda/jobs
EOF


echo "------------------------------------------------------------"
echo "✅ Installation Complete!"
echo "   Module: ${PROJECT_NAME}/${VERSION}"
echo "------------------------------------------------------------"


if { [is-loaded jedi] == 0 } {
    module load jedi/1.5.0
}

###########################################################

# --- 5. Testing Environment ---
# We use a subshell to test so we don't mess up the current terminal
(
    # Try to find and source modules if available
    [ -f /usr/share/modules/init/bash ] && source /usr/share/modules/init/bash

    if command -v module >/dev/null 2>&1; then
        module use ${HOME}/modulefiles
        module load aiesda/${VERSION}
        echo "🧪 Testing module load..."
	# 2. Check environment variables
	echo $AIESDA_NML
	# 3. Check Python resolution
        python3 -c "import aidaconf; print('✅ Success! aidaconf found at:', aidaconf.__file__)"
    else
        echo "⚠️  Note: 'module' command not found. Environment module created but not tested."
        echo "   To fix: sudo apt install environment-modules"
    fi
)

