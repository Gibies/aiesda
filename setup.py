from setuptools import setup, find_packages
import os

def parse_requirements(filename):
    """
    Helper to read requirements.txt. 
    Filters out comments, empty lines, and specific JEDI/DA 
    blocks if they are handled by Docker/HPC modules.
    """
    requirements = []
    if os.path.exists(filename):
        with open(filename, "r") as f:
            for line in f:
                line = line.strip()
                # Skip comments, empty lines, and Block headers
                if not line or line.startswith("#") or "BLOCK" in line:
                    continue
                # Optional: Skip specific libs you know are provided by JEDI modules
                if any(x in line for x in ["ufo", "saber", "ioda"]):
                    continue
                requirements.append(line)
    return requirements

with open("VERSION", "r") as f:
    version = f.read().strip()

setup(
    name="aiesda",
    version=version,
    description="Artificial Intelligence based Earth System Data Assimilation",
    author="gibies",
    # Define the hierarchy
    packages=["aiesda", "aiesda.pylib", "aiesda.pydic", "aiesda.scripts"],

    # Mapping namespaces to physical directories
    package_dir={
        "aiesda.pylib": "pylib",
        "aiesda.pydic": "pydic",
        "aiesda.scripts": "scripts",
    },

    # Ensuring configs are bundled into the versioned build
    package_data={
        "aiesda": ["nml/*.nml", "yaml/*.yml", "jobs/*.sh", "palette/*"],
    },
    include_package_data=True,
    zip_safe=False,
    install_requires=parse_requirements("requirements.txt"),
    python_requires=">=3.9",
)




