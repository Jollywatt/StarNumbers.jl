module StarNumbers

export StarNumber

struct StarNumber{n} <: Number
	sign
	coeff
	function StarNumber{n}(sign, coeff) where n
		new{n}(mod(sign + (coeff < 0), n), abs(coeff))
	end
end

Base.show(io::IO, a::StarNumber) = print(io, "-"^(iszero(a.coeff) ? 0 : a.sign), a.coeff)

Base.show(io::IO, ::MIME"text/plain", a::StarNumber) = print(io, typeof(a), ": ", a)

Base.convert(::Type{StarNumber{n}}, a::Real) where n = StarNumber{n}(0, a)
Base.promote_rule(::Type{StarNumber{n}}, ::Type{<:Real}) where n = StarNumber{n}

## Multiplication, division

Base.:*(a::StarNumber{n}, b::StarNumber{n}) where n = StarNumber{n}(a.sign + b.sign, a.coeff*b.coeff)
Base.inv(a::StarNumber{n}) where n = StarNumber{n}(-a.sign, inv(a.coeff))
Base.:/(a::StarNumber, b::StarNumber) = a*inv(b)

Base.:^(a::StarNumber{n}, p::Integer) where n = StarNumber{n}(p*a.sign, a.coeff^p)

## Addition, subtraction

function Base.:+(a::StarNumber{n}, b::StarNumber{n}) where n
	if a.sign == b.sign
		sign = a.sign
		coeff = a.coeff + b.coeff
	else
		dom, sub = a.coeff >= b.coeff ? (a, b) : (b, a)
		sign = dom.sign
		coeff = dom.coeff - sub.coeff
	end
	StarNumber{n}(sign, coeff)
end
Base.:-(a::StarNumber{n}) where n = StarNumber{n}(a.sign + 1, a.coeff)
Base.:-(a::StarNumber, b::StarNumber) = a + (-b)


end # module
