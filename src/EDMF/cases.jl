#### Cases

export Case
export BOMEX
export TRMM_LBA

"""
    Case

An abstract case, which encompasses
all EDMF benchmark cases.
"""
abstract type Case end

"""
    BOMEX

The Barbados Oceanographic Meteorological
Experiment (BOMEX).

Reference:
  Kuettner, Joachim P., and Joshua Holland.
  "The BOMEX project." Bulletin of the American
  Meteorological Society 50.6 (1969): 394-403.
"""
struct BOMEX <: Case end

"""
    BOMEX

Continental deep convection case based on the Large scale
Biosphere-Atmosphere experiment with data from the Tropical
Rain Measurement (TRMM-LBA).

Reference:
  Grabowski, et al. (2006). Daytime convective development over land:
  A model683intercomparison based on lba observations.
  Quarterly Journal of the Royal684Meteorological Society,132(615), 317–344.
"""
struct TRMM_LBA <: Case end

