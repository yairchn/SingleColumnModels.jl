##### Entrainment-Detrainment models

abstract type EntrDetrModel end

struct BOverW2{FT} <: EntrDetrModel
  ε_factor::FT
  δ_factor::FT
end

"""
    compute_entrainment_detrainment!

Define entrainment and detrainment fields

 - `tmp[:ε_model, k, i]`
 - `tmp[:δ_model, k, i]`

 for all `k` and all `i`
"""
function compute_entrainment_detrainment! end

function compute_entrainment_detrainment!(grid::Grid{FT}, UpdVar, tmp, q, params, model::BOverW2) where FT
  gm, en, ud, sd, al = allcombinations(q)
  Δzi = grid.Δzi
  k_1 = first_interior(grid, Zmin())
  @inbounds for i in ud
    zi = UpdVar[i].cloud.base
    @inbounds for k in over_elems_real(grid)
      buoy = tmp[:buoy, k, i]
      w = q[:w, k, i]
      if grid.zc[k] >= zi
        detr_sc = 4.0e-3 + 0.12 *abs(min(buoy,0.0)) / max(w * w, 1e-2)
      else
        detr_sc = FT(0)
      end
      entr_sc = 0.12 * max(buoy, FT(0) ) / max(w * w, 1e-2)
      tmp[:ε_model, k, i] = entr_sc * model.ε_factor
      tmp[:δ_model, k, i] = detr_sc * model.δ_factor
    end
    tmp[:ε_model, k_1, i] = 2 * Δzi
    tmp[:δ_model, k_1, i] = FT(0)
  end
end

function compute_cv_entr!(grid::Grid{FT}, q, tmp, tmp_O2, ϕ, ψ, cv, tke_factor) where FT
  gm, en, ud, sd, al = allcombinations(q)
  @inbounds for k in over_elems_real(grid)
    tmp_O2[cv][:entr_gain, k] = FT(0)
    @inbounds for i in ud
      Δϕ = q[ϕ, k, i] - q[ϕ, k, en]
      Δψ = q[ψ, k, i] - q[ψ, k, en]
      tmp_O2[cv][:entr_gain, k] += tke_factor*q[:a, k, i] * abs(q[:w, k, i]) * tmp[:δ_model, k, i] * Δϕ * Δψ
    end
    tmp_O2[cv][:entr_gain, k] *= tmp[:ρ_0, k]
  end
end
