#! python3
"""
Bharat Forecast System Interface
Created on Mon Jan 19 2026
@author: gibies
"""
import numpy
import xarray
import aidadic

class BharatInterface:
    """
    Interface for NCMRWF's Bharat Forecast System.
    Handles high-resolution global/regional standardized output.
    """
    def __init__(self, config=None):
        self.config = config or {}
        self.levels = numpy.array(aidadic.bharat_levels)
        self.res = self.config.get('res', 0.125) # Standard Bharat resolution

    def prepare_state(self, raw_output):
        """Standardizes Bharat system data for JEDI ingestion."""
        mapping = {v: k for k, v in aidadic.bharat_jedi_var_mapping.items()}
        standardized_ds = raw_output.rename(mapping)

        # Coordinate Standardization
        if 'level' in standardized_ds.coords:
            standardized_ds = standardized_ds.rename({'level': 'lev'})
        elif 'vertical' in standardized_ds.coords:
            standardized_ds = standardized_ds.rename({'vertical': 'lev'})

        # Enforce exact pressure levels from aidadic
        if len(standardized_ds.lev) == len(self.levels):
            standardized_ds['lev'] = self.levels

        return standardized_ds
