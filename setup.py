from setuptools import setup

setup(
    name="aiesda",
    version="0.1.0",
    description="Artificial Intelligence based Earth System Data Assimilation",
    author="NCMRWF",
    # Since your files are in the root, we list them as modules
    py_modules=["ailib", "aidaconf", "aidadic", "dynlib"],
    install_requires=[
        "numpy>=1.22.4",
        "pandas>=1.5.0",
        "xarray>=2022.3.0",
        "torch>=1.12.0",
        "pyyaml>=6.0",
        "matplotlib>=3.5.0",
        # Note: JEDI/SABER/NCAR components are usually 
        # provided by the HPC environment modules.
    ],
    python_requires=">=3.9",
)
