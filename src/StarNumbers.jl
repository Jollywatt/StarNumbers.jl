module StarNumbers

using SymPy
# import_from(sympy, (:Mod,))
# simplify doesn't reduce mod expressions as much as this does
harshsimplify(a) = simplify(simplify(a + 1) - 1)
_mod(a::Real, b::Real) = mod(a, b)
_mod(a, b) = sympy.Mod(a, b)

export StarNumber

struct StarNumber{n} <: Number
	sign
	coeff
	function StarNumber{n}(sign, coeff) where n
		sign += sympy.Piecewise((1, Lt(coeff, 0)), (0, true))
		sign = harshsimplify(_mod(sign, n))
		coeff = simplify(abs(coeff))
		new{n}(N(sign), N(coeff))
	end
end

Base.sign(a::StarNumber) = a.sign
Base.abs(a::StarNumber) = a.coeff

Base.convert(::Type{StarNumber{n}}, a::Union{Real,Sym}) where n = StarNumber{n}(0, a)
Base.promote_rule(::Type{StarNumber{n}}, ::Type{<:Real}) where n = StarNumber{n}
Base.promote_rule(::Type{Sym}, ::Type{StarNumber{n}}) where n = StarNumber{n}


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
		# dom, sub = Gt(a.coeff, b.coeff) ? (a, b) : (b, a)
		sign = sympy.Piecewise((a.sign, Gt(a.coeff, b.coeff)), (b.sign, true))
		coeff = abs(a.coeff - b.coeff)
	end
	StarNumber{n}(sign, coeff)
end
Base.:-(a::StarNumber{n}) where n = StarNumber{n}(a.sign + 1, a.coeff)
Base.:-(a::StarNumber, b::StarNumber) = a + (-b)


## Printing

function Base.show(io::IO, a::StarNumber)
	if sign(a) isa Integer && abs(a) isa Real
		# use compact notation (eg `StarNumber{3}: --7`) for basic types
		print(io, typeof(a), ": ", "-"^sign(a), abs(a))
	else
		# use full notation (eg `StarNumber{3}(2, 7)`) for all other types, incl. symbolic
		head = sympy.Function(repr(typeof(a))) # dummy function for printing
		print(io, sympy.pretty(head(sign(a), abs(a)))) # use sympy's pretty printing
	end
end


end # module
