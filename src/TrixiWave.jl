module TrixiWave

# Write your package code here.

using Trixi
import Trixi.con2cons, Trixi.cons2prim, Trixi.min_max_speed_davis
import Trixi.flux, Trixi.cons2entropy, Trixi.max_abs_speeds

struct WaveEquation1D{RealT<:Real} <: Trixi.AbstractEquations{1, # number of spatial dimensions
                                                              2} # number of primary variables, i.e. scalar
    speed_of_wave::RealT
    function WaveEquation1D(c::Real=1.0)
        return new{typeof(c)}(c)
    end
end

function Trixi.varnames(::typeof(cons2cons), ::WaveEquation1D)
    return ("Π", "Ψ")
end

function Trixi.varnames(::typeof(cons2prim), ::WaveEquation1D)
    return ("Π", "Ψ")
end

# Calculate 1D flux for a single point
@inline function Trixi.flux(u, orientation::Integer,
                            equations::WaveEquation1D)
    Π, Ψ = u
    return SVector(equations.speed_of_wave^2 * Ψ, Π)
end

function initial_condition_standing_wave(x, t, equations::WaveEquation1D)
    L = 10.0
    n = 2
    Π = 0.0
    Ψ = (2n * π / L) * cospi(2n * x[1] / L)
    return SVector(Π, Ψ)
end

# Calculate maximum wave speed for local Lax-Friedrichs-type dissipation
@inline function Trixi.max_abs_speed_naive(u_ll, u_rr, orientation::Int,
                                           equations::WaveEquation1D)
    return λ_max = equations.speed_of_wave
end

@inline have_constant_speed(::WaveEquation1D) = True()

@inline function Trixi.max_abs_speeds(equations::WaveEquation1D)
    return equations.speed_of_wave
end

@inline function min_max_speed_naive(u_ll, u_rr, orientation::Integer,
                                     equations::WaveEquation1D)
    return min_max_speed_davis(u_ll, u_rr, orientation, equations)
end

@inline function Trixi.min_max_speed_davis(u_ll, u_rr, orientation::Integer,
                                           equations::WaveEquation1D)
    λ_min = -equations.speed_of_wave
    λ_max = equations.speed_of_wave

    return λ_min, λ_max
end

# Convert conservative variables to primitive
@inline Trixi.cons2prim(u, ::WaveEquation1D) = u
@inline Trixi.cons2cons(u, ::WaveEquation1D) = u
@inline Trixi.cons2entropy(u, ::WaveEquation1D) = u

end
