# StarNumbers.jl
Esoteric “star” number system, inspired by discussion on _>implying we can discuss mathematics_.

```julia
julia> using StarNumbers

julia> i = one(StarNumber{3}) # mult. identity of 'trinumber' system
StarNumber{3}: 1

julia> i, -2i, -(-i)
(1, -2, --1)
```

Star numbers are like several copies of the non-negative real line glued together at zero, similar to a star shape in the complex plane.

```julia
julia> -2i * -3i
StarNumber{3}: --6

julia> 1/ans
StarNumber{3}: -0.16666666666666666

julia> -inv(ans)
StarNumber{3}: 6.0
```

Star numbers of any “sign” have multiple additive inverses of different sign.

```julia
julia> 4i + 3i
StarNumber{3}: 7

julia> 4i - 3i
StarNumber{3}: 1

julia> -4i + 3i
StarNumber{3}: -1

julia> -4(-i) + 3i
StarNumber{3}: --1
```
