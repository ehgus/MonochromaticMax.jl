
abstract type OpticalMaterial end

struct LinearMaterial <: OpticalMaterial
    ϵᵣ_fun::Some{Function}
    μᵣ_fun::Some{Function}
    α_fun::Some{Function}
end

"""
    LinearMaterial(ϵᵣ_fun,μᵣ_fun,α_fun)

Define `LinearMaterial`. Each funtion specify 
"""
function LinearMaterial(ϵᵣ_fun,μᵣ_fun,α_fun)
    if !isnothing(ϵᵣ_fun) || precompile(ϵᵣ_fun,(Unitful.Length,))
        @error "Unitful value should be able to be a input of ϵᵣ_fun"
    end
    if !isnothing(μᵣ_fun) || precompile(μᵣ_fun,(Unitful.Length,))
        @error "Unitful value should be able to be a input of μᵣ_fun"
    end
    if !isnothing(α_fun) || precompile(α_fun,(Unitful.Length,))
        @error "Unitful value should be able to be a input of α_fun"
    end
    new(ϵᵣ_fun,μᵣ_fun,α_fun)
end

function NonMagneticMaterial(ϵᵣ_fun)
    μᵣ_fun = nothing
    α_fun = nothing
    LinearMaterial(ϵᵣ_fun,μᵣ_fun,α_fun)
end

function MagneticMaterial(ϵᵣ_fun,μᵣ_fun)
    α_fun = nothing
    LinearMaterial(ϵᵣ_fun,μᵣ_fun,α_fun)
end

"""
    relative_permittivity(material::LinearMaterial, vacuum_wavelength)

Return relative_permittivity in the specific `vacuum_wavelength`.
"""
function relative_permittivity(material::LinearMaterial, vacuum_wavelength::Unitful.Length)
    ϵᵣ = isnothing(ϵᵣ_fun) ? 1 : ϵᵣ_fun(vacuum_wavelength)
    return ϵᵣ
end

"""
    relative_permeability(material::LinearMaterial, vacuum_wavelength)

Return relative_permeability in the specific `vacuum_wavelength`.
"""
function relative_permeability(material::LinearMaterial, vacuum_wavelength::Unitful.Length)
    ϵᵣ = isnothing(ϵᵣ_fun) ? 1 : ϵᵣ_fun(vacuum_wavelength)
    return μᵣ_fun(vacuum_wavelength)
end

"""
    magnetoelectric_susceptiblity(material::LinearMaterial, vacuum_wavelength)

Return magnetoelectric_susceptiblity in the specific `vacuum_wavelength`.
"""
function magnetoelectric_susceptiblity(material::LinearMaterial, vacuum_wavelength::Unitful.Length)
    return α_fun(vacuum_wavelength)
end
