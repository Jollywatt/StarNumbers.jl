# StarNumbers.jl
Esoteric “star” number system, inspired by discussion on _>implying we can discuss mathematics_.

```julia
julia> using StarNumbers

julia> e = one(StarNumber{3}) # mult. identity of 'trinumber' system
StarNumber{3}: 1

julia> e, -2e, -(-e)
(1, -2, --1)
```

Star numbers are like several copies of the non-negative real line glued together at zero.
Unary minus then becomes a group operation of order ``n``, instead of order two as it is usually.

```julia
julia> -2e * -3
StarNumber{3}: --6

julia> 1/ans
StarNumber{3}: -0.16666666666666666

julia> -inv(ans)
StarNumber{3}: 6.0
```

Star numbers of any “sign” have multiple additive inverses of different sign.

```julia
julia> 4e + 3e
StarNumber{3}: 7

julia> 4e - 3e
StarNumber{3}: 1

julia> -4e + 3e
StarNumber{3}: -1

julia> -4(-e) + 3e
StarNumber{3}: --1
```


## Symbolic arithmetic

You can use `SymPy.jl` for integration with `python`’s symbolic engine.

```julia
julia> using SymPy

julia> @syms x
(x,)

julia> 3x*e
             ⎛⎧1  for x < 0       ⎞
StarNumber{3}⎜⎨            , 3⋅│x│⎟
             ⎝⎩0  otherwise       ⎠

```

Notice that the first argument, the sign, depends on the sign of ``x``, while the magnitude is always positive.
Expressions are simpler if we assume that ``x > 0``, like so:

```julia
julia> @syms x::positive k::integer
(x, k)

julia> 3x*e
StarNumber{3}(0, 3⋅x)
```

Even the sign can be symbolic:

```julia
julia> StarNumber{7}(k, x)
StarNumber{7}(k mod 7, x)

julia> 1 - ans
             ⎛⎧      0        for x < 1         ⎞
StarNumber{7}⎜⎨                        , │x - 1│⎟
             ⎝⎩(k + 1) mod 7  otherwise         ⎠
```

***Verifying distributivity***

```julia
julia> A, B, C = [StarNumber{5}(sign, coeff) for (sign, coeff) in zip(
           symbols("x y z", integer=true),
           symbols("a b c", positive=true),
       )]
3-element Vector{StarNumber{5}}:
 StarNumber{5}(x mod 5, a)
 StarNumber{5}(y mod 5, b)
 StarNumber{5}(z mod 5, c)

julia> A*(B + C)
             ⎛⎧(x + y) mod 5  for b > c           ⎞
StarNumber{5}⎜⎨                        , a⋅│b - c│⎟
             ⎝⎩(x + z) mod 5  otherwise           ⎠

julia> A*B + A*C
             ⎛⎧(x + y) mod 5  for a⋅b > a⋅c           ⎞
StarNumber{5}⎜⎨                            , a⋅│b - c│⎟
             ⎝⎩(x + z) mod 5    otherwise             ⎠

```

***Verifying inverses***

```julia
julia> 1/A
             ⎛           1⎞
StarNumber{5}⎜4⋅x mod 5, ─⎟
             ⎝           a⎠

julia> ans*A
StarNumber{5}: 1
```
