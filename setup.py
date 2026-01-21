from setuptools import setup, find_packages

setup(
    name="aiesda",
    version="0.1.0",
    description="Artificial Intelligence based Earth System Data Assimilation",
    author="gibies",
    # We define the sub-packages within the aiesda namespace
    packages=["aiesda.pylib", "aiesda.pydic", "aiesda.scripts", "aiesda.jobs"],
    # We map those namespaces to your physical folder names
    package_dir={
        "aiesda.pylib": "pylib",
        "aiesda.pydic": "pydic",
        "aiesda.scripts": "scripts",
        "aiesda.jobs": "jobs",
        "aiesda.nml": "nml",
        "aiesda.yaml": "yaml",
    },
    # This handles the non-python files (yml, nml) if needed later
    include_package_data=True,
    install_requires=[
        "numpy>=1.22.4",
        "torch>=1.12.0",
        "pyyaml>=6.0",
        "xarray",
        "netCDF4"
        "matplotlib>=3.5.0",
        # Note: JEDI/SABER/NCAR components are usually 
        # provided by the HPC environment modules.
    ],
    python_requires=">=3.9",
)

