#!/bin/bash
# Set library path for XGBoost to find libomp
export DYLD_LIBRARY_PATH="/Users/rupeshpanwar/homebrew/opt/libomp/lib:$DYLD_LIBRARY_PATH"

# Activate virtual environment
source .venv/bin/activate

echo "✅ Environment configured with libomp path"
echo "✅ Virtual environment activated"
echo ""
echo "You can now run Python scripts and notebooks with XGBoost support"
