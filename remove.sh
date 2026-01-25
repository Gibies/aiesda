#!/bin/bash
# ==============================================================================
# AIESDA Version-Specific Cleanup Utility (remove.sh)
# ==============================================================================

PROJECT_NAME="aiesda"
BUILD_ROOT="${HOME}/build"
MODULE_PATH="${HOME}/modulefiles"

# 1. Determine Target Version
if [ -z "$1" ]; then
    if [ -f "VERSION" ]; then
        TARGET_VERSION=$(cat VERSION | tr -d '[:space:]' | sed 's/\.0\+/\./g')
    else
        echo "❌ ERROR: No version specified. Usage: ./remove.sh 2026.1"
        exit 1
    fi
else
    TARGET_VERSION=$1
fi

echo "🧹 Starting surgical cleanup for ${PROJECT_NAME} v${TARGET_VERSION}..."
# We check for both the Docker Image and the JEDI-specific build/module paths
JEDI_IMAGE="${PROJECT_NAME}_jedi:${TARGET_VERSION}"
JEDI_BUILD="${BUILD_ROOT}/jedi_build_${TARGET_VERSION}"

echo ""
echo "❓ JEDI Component Detected (v${TARGET_VERSION})"
read -p "Do you also want to remove the associated JEDI Docker image and bridge? (y/N): " confirm_jedi

############################################################################

# 2. Interactive JEDI Cleanup
if [[ "$confirm_jedi" =~ ^[yY]$ ]]; then
    # Remove Docker Image
    if command -v docker &>/dev/null; then
        IMAGE_ID=$(docker images -q "$JEDI_IMAGE")
        if [ -n "$IMAGE_ID" ]; then
            echo "🐳 Removing Docker image: $JEDI_IMAGE"
            docker rmi -f "$IMAGE_ID"
        fi
    fi

    # Remove JEDI Build Dir (the bridge/bin folder)
    if [ -d "$JEDI_BUILD" ]; then
        echo "📂 Removing JEDI bridge directory: $JEDI_BUILD"
        rm -rf "$JEDI_BUILD"
    fi

    # Remove JEDI Modulefile
    JEDI_MOD="${MODULE_PATH}/jedi/${TARGET_VERSION}"
    if [ -f "$JEDI_MOD" ]; then
        echo "📋 Removing JEDI modulefile: $JEDI_MOD"
        rm -f "$JEDI_MOD"
        rmdir "$(dirname "$JEDI_MOD")" 2>/dev/null
    fi
    echo "✅ JEDI components removed."
else
    echo "⏭️  Skipping JEDI cleanup. JEDI assets remain intact."
fi

############################################################################

# 3. Remove Specific AIESDA Build Directory
SPECIFIC_BUILD="${BUILD_ROOT}/${PROJECT_NAME}_build_${TARGET_VERSION}"
if [ -d "$SPECIFIC_BUILD" ]; then
    echo "📂 Removing AIESDA build directory: $SPECIFIC_BUILD"
    rm -rf "$SPECIFIC_BUILD"
    echo "✅ AIESDA build cleared."
fi

############################################################################

# 4. Remove AIESDA Modulefile
SPECIFIC_MODULE="${MODULE_PATH}/${PROJECT_NAME}/${TARGET_VERSION}"
if [ -f "$SPECIFIC_MODULE" ]; then
    echo "📋 Removing AIESDA modulefile: $SPECIFIC_MODULE"
    rm -f "$SPECIFIC_MODULE"
    rmdir "$(dirname "$SPECIFIC_MODULE")" 2>/dev/null
fi

############################################################################

echo "------------------------------------------------------------"
echo "✨ Cleanup for v${TARGET_VERSION} complete."
echo "------------------------------------------------------------"





#!/bin/bash
# ==============================================================================
# AIESDA Version-Specific Cleanup Utility
# Usage: ./remove.sh [VERSION]
# ==============================================================================

PROJECT_NAME="aiesda"
BUILD_ROOT="${HOME}/build"
MODULE_PATH="${HOME}/modulefiles"

# 1. Determine Target Version
if [ -z "$1" ]; then
    # Fallback: Try to read from VERSION file if no argument provided
    if [ -f "VERSION" ]; then
        TARGET_VERSION=$(cat VERSION | tr -d '[:space:]' | sed 's/\.0\+/\./g')
    else
        echo "❌ ERROR: No version specified. Usage: ./clean_install.sh 2026.1"
        exit 1
    fi
else
    TARGET_VERSION=$1
fi

echo "🧹 Starting surgical cleanup for ${PROJECT_NAME} v${TARGET_VERSION}..."

# 2. Remove Specific Build Directory
SPECIFIC_BUILD="${BUILD_ROOT}/${PROJECT_NAME}_build_${TARGET_VERSION}"
if [ -d "$SPECIFIC_BUILD" ]; then
    echo "📂 Removing build directory: $SPECIFIC_BUILD"
    rm -rf "$SPECIFIC_BUILD"
    echo "✅ Build directory cleared."
else
    echo "ℹ️  No build directory found for v${TARGET_VERSION}."
fi

# 3. Remove Specific Modulefile
SPECIFIC_MODULE="${MODULE_PATH}/${PROJECT_NAME}/${TARGET_VERSION}"
if [ -f "$SPECIFIC_MODULE" ]; then
    echo "📋 Removing modulefile: $SPECIFIC_MODULE"
    rm -f "$SPECIFIC_MODULE"
    # Clean up empty parent directory if it's the last version
    rmdir "$(dirname "$SPECIFIC_MODULE")" 2>/dev/null
    echo "✅ Modulefile removed."
else
    echo "ℹ️  No modulefile found for v${TARGET_VERSION}."
fi

# 4. Docker Image Cleanup (Version Specific)
if command -v docker &>/dev/null; then
    # Look for the image with the specific version tag
    IMAGE_ID=$(docker images -q "${PROJECT_NAME}_jedi:${TARGET_VERSION}")
    
    if [ -n "$IMAGE_ID" ]; then
        echo "🐳 Removing Docker image: ${PROJECT_NAME}_jedi:${TARGET_VERSION}"
        docker rmi -f "$IMAGE_ID"
        echo "✅ Docker image cleared."
    else
        echo "ℹ️  No Docker image found for tag :${TARGET_VERSION}."
    fi
fi

echo "------------------------------------------------------------"
echo "✨ Cleanup for v${TARGET_VERSION} complete."
echo "------------------------------------------------------------"
