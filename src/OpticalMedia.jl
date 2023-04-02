# optical material
abstract type AbstractOpticalMaterial end

struct LinearMaterial <: AbstractOpticalMaterial
    relative_permittivity::Some{Function}
    relative_permeability::Some{Function}
    magnetoelectric_susceptibility::Some{Function}
end

"""
    LinearMaterial(relative_permittivity,relative_permeability,magnetoelectric_susceptibility)

Define `LinearMaterial`. Each funtion specify 
"""
function LinearMaterial(relative_permittivity,relative_permeability,magnetoelectric_susceptibility)
    for fname in (:relative_permittivity, :relative_permeability, :magnetoelectric_susceptibility)
        @eval begin
            if !isnothing($fname) || precompile($fname, (Unitful.Length,))
                @error "Unitful.Length value should be able to be a input of $fname"
            end
        end
    end
    new(relative_permittivity,relative_permeability,magnetoelectric_susceptibility)
end

function NonMagneticMaterial(relative_permittivity)
    relative_permeability = nothing
    magnetoelectric_susceptibility = nothing
    LinearMaterial(relative_permittivity,relative_permeability,magnetoelectric_susceptibility)
end

function MagneticMaterial(relative_permittivity,relative_permeability)
    magnetoelectric_susceptibility = nothing
    LinearMaterial(relative_permittivity,relative_permeability,magnetoelectric_susceptibility)
end

"""
    relative_permittivity(material::LinearMaterial, vacuum_wavelength)

Return relative_permittivity in the specific `vacuum_wavelength`.
"""
function relative_permittivity end

"""
    relative_permeability(material::LinearMaterial, vacuum_wavelength)

Return relative_permeability in the specific `vacuum_wavelength`.
"""
function relative_permeability end

"""
    magnetoelectric_susceptiblity(material::LinearMaterial, vacuum_wavelength)

Return magnetoelectric_susceptiblity in the specific `vacuum_wavelength`.
"""
function magnetoelectric_susceptibility end

for (fname, default_output) in ((:relative_permittivity, 1.0), (:relative_permeability, 1.0), (:magnetoelectric_susceptibility, 0.0))
    @eval $fname(material::LinearMaterial, vacuum_wavelength::Unitful.Length) = isnothing(material.$fname) ? default_output : material.$fname(vacuum_wavelength)
end

# optical media: collection of optical material with its position
# use structArray?
abstract type AbstractOpticalMedia end

struct UniformGridMedia <: AbstractOpticalMedia
    resolution::AbstractVector{Unitful.Length}
    material_grid::AbstractArray{Int16}
    material_list::AbstractVector{AbstractOpticalMaterial}
end

function UniformGridMedia(resolution)
    @assert length(resolution) "The length of the resolution and the specified size by `dims`"
    material_grid = zeros(Int16, )
    new(resolution)
end