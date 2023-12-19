using SpecialFunctions

function parallelMutualImpedance(f, lλ, dλ)
    η = 120π
    λ = 3e8 / f
    k = 2π / λ
    d = dλ * λ
    l = lλ * λ
    
    u0 = k * d
    u1 = k * (sqrt(d^2 + l^2) + l)
    u2 = k * (sqrt(d^2 + l^2) - l)

    Rm = η / 4π * (2 * cosint(u0) - cosint(u1) - cosint(u2))
    Xm = - η / 4π * (2 * sinint(u0) - sinint(u1) - sinint(u2))

    return Rm, Xm
end