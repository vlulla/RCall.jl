"""
RCall.jl's type `Sxp` mirrors the R symbolic expression record `SEXPREC` in R API.
These are represented by a pointer `Ptr{S<:Sxp}` (which is called `SEXP` in R API).
"""
@compat abstract type Sxp end # SEXPREC
# @compat SxpPtr{S<:Sxp} = Ptr{S} # SEXP
const SxpPtrInfo = UInt32 # sxpinfo_struct

"R Sxp header: a pointer to this is used for unknown types."
immutable SxpHead <: Sxp # SEXPREC_HEADER
    info::SxpPtrInfo
    attrib::Ptr{SxpHead}
    gc_next::Ptr{SxpHead}
    gc_prev::Ptr{SxpHead}
end
const UnknownSxp = SxpHead

@compat abstract type VectorSxp <: Sxp end
@compat abstract type VectorAtomicSxp <: VectorSxp end
@compat abstract type VectorNumericSxp <: VectorAtomicSxp end
@compat abstract type VectorListSxp <: VectorSxp end
@compat abstract type PairListSxp <: Sxp end
@compat abstract type FunctionSxp <: Sxp end


"R NULL value"
immutable NilSxp <: PairListSxp   # type tag 0
    head::SxpHead
end
# const Ptr{NilSxp} = Ptr{NilSxp}

"R pairs (cons) list cell"
immutable ListSxp <: PairListSxp  # type tag 2
    head::SxpHead
    car::Ptr{UnknownSxp}
    cdr::Ptr{UnknownSxp}
    tag::Ptr{UnknownSxp}
end
# const ListSxpPtr = Ptr{ListSxp}

"R function closure"
immutable ClosSxp <: FunctionSxp  # type tag 3
    head::SxpHead
    formals::Ptr{ListSxp}
    body::Ptr{UnknownSxp}
    env::Ptr{UnknownSxp}
end
# const ClosSxpPtr = Ptr{ClosSxp}

"R environment"
immutable EnvSxp <: Sxp  # type tag 4
    head::SxpHead
    frame::Ptr{UnknownSxp}
    enclos::Ptr{UnknownSxp}
    hashtab::Ptr{UnknownSxp}
end
# const EnvSxpPtr = Ptr{EnvSxp}

"R promise"
immutable PromSxp <: Sxp  # type tag 5
    head::SxpHead
    value::Ptr{UnknownSxp}
    expr::Ptr{UnknownSxp}
    env::Ptr{UnknownSxp}
end
# const PromSxpPtr = Ptr{PromSxp}

"R function call"
immutable LangSxp <: PairListSxp  # type tag 6
    head::SxpHead
    car::Ptr{UnknownSxp}
    cdr::Ptr{UnknownSxp}
    tag::Ptr{UnknownSxp}
end
# const LangSxpPtr = Ptr{LangSxp}

"R special function"
immutable SpecialSxp <: FunctionSxp  # type tag 7
    head::SxpHead
end
# const SpecialSxpPtr = Ptr{SpecialSxp}

"R built-in function"
immutable BuiltinSxp <: FunctionSxp  # type tag 8
    head::SxpHead
end
# const BuiltinSxpPtr = Ptr{BuiltinSxp}

"R character string"
immutable CharSxp <: VectorAtomicSxp     # type tag 9
    head::SxpHead
    length::Cint
    truelength::Cint
end
# const CharSxpPtr = Ptr{CharSxp}

"R symbol"
immutable SymSxp <: Sxp   # type tag 1
    head::SxpHead
    name::Ptr{CharSxp}
    value::Ptr{UnknownSxp}
    internal::Ptr{UnknownSxp}
end
# const SymSxpPtr = Ptr{SymSxp}

"R logical vector"
immutable LglSxp <: VectorNumericSxp     # type tag 10
    head::SxpHead
    length::Cint
    truelength::Cint
end
# const LglSxpPtr = Ptr{LglSxp}

"R integer vector"
immutable IntSxp <: VectorNumericSxp     # type tag 13
    head::SxpHead
    length::Cint
    truelength::Cint
end
# const IntSxpPtr = Ptr{IntSxp}

"R real vector"
immutable RealSxp <: VectorNumericSxp    # type tag 14
    head::SxpHead
    length::Cint
    truelength::Cint
end
# const RealSxpPtr = Ptr{RealSxp}

"R complex vector"
immutable CplxSxp <: VectorNumericSxp    # type tag 15
    head::SxpHead
    length::Cint
    truelength::Cint
end
# const CplxSxpPtr = Ptr{CplxSxp}

"R vector of character strings"
immutable StrSxp <: VectorListSxp     # type tag 16
    head::SxpHead
    length::Cint
    truelength::Cint
end
# const PtStrSxpPtr = Ptr{StrSxp}

"R dot-dot-dot object"
immutable DotSxp <: Sxp     # type tag 17
    head::SxpHead
end
# const DotSxpPtr = Ptr{DotSxp}

"R \"any\" object"
immutable AnySxp <: Sxp     # type tag 18
    head::SxpHead
end
# const AnySxpPtr = Ptr{AnySxp}

"R list (i.e. Array{Any,1})"
immutable VecSxp <: VectorListSxp     # type tag 19
    head::SxpHead
    length::Cint
    truelength::Cint
end
# const VecSxpPtr = Ptr{VecSxp}

"R expression vector"
immutable ExprSxp <: VectorListSxp    # type tag 20
    head::SxpHead
    length::Cint
    truelength::Cint
end
# const ExprSxpPtr = Ptr{ExprSxp}

"R byte code"
immutable BcodeSxp <: Sxp   # type tag 21
    head::SxpHead
end
# const BcodeSxpPtr = Ptr{BcodeSxp}

"R external pointer"
immutable ExtPtrSxp <: Sxp  # type tag 22
    head::SxpHead
    ptr::Ptr{Void}
    prot::Ptr{Void}
    tag::Ptr{UnknownSxp}
end
# const ExtPtrSxpPtr = Ptr{ExtPtrSxp}

"R weak reference"
immutable WeakRefSxp <: Sxp  # type tag 23
    head::SxpHead
end
# const WeakRefSxpPtr = Ptr{WeakRefSxp}

"R byte vector"
immutable RawSxp <: VectorAtomicSxp      # type tag 24
    head::SxpHead
    length::Cint
    truelength::Cint
end
# const RawSxpPtr = Ptr{RawSxp}

"R S4 object"
immutable S4Sxp <: Sxp      # type tag 25
    head::SxpHead
end
# const S4SxpPtr = Ptr{S4Sxp}


# @compat const VectorSxpPtr{S<:VectorSxp} = Ptr{S}
# @compat const VectorAtomicSxpPtr{S<:VectorAtomicSxp} = Ptr{S}
# @compat const VectorNumericSxpPtr{S<:VectorNumericSxp} = Ptr{S}
# @compat const VectorPtr{ListSxp}{S<:VectorListSxp} = Ptr{S}
# @compat const PairPtr{ListSxp}{S<:PairListSxp} = Ptr{S}
# @compat const FunctionSxpPtr{S<:FunctionSxp} = Ptr{S}


"""
An `RObject` is a Julia wrapper for an R object (known as an "S-expression" or "SEXP"). It is stored as a pointer which is protected from the R garbage collector, until the `RObject` itself is finalized by Julia. The parameter is the type of the S-expression.

When called with a Julia object as an argument, a corresponding R object is constructed.

```julia_skip
julia> RObject(1)
RObject{IntSxp}
[1] 1

julia> RObject(1:3)
RObject{IntSxp}
[1] 1 2 3

julia> RObject(1.0:3.0)
RObject{RealSxp}
[1] 1 2 3
```
"""

type RObject{S<:Sxp}
    p::Ptr{S}
    # used for pre-defined constants
    function (::Type{RObject{S}}){S}()
        new{S}(C_NULL)
    end
    function (::Type{RObject{S}}){S}(p::Ptr{S})
        preserve(p)
        r = new{S}(p)
        finalizer(r, release)
        r
    end
    # SymSxps are not garbage collected, so preserve not necessary.
    (::Type{RObject{S}}){S}(p::Ptr{SymSxp}) = new{S}(p)
end


RObject{S<:Sxp}(p::Ptr{S}) = RObject{S}(p)
RObject(x::RObject) = x

"""
Element types of R vectors.
"""
eltype(::Type{LglSxp}) = Cint
eltype(::Type{IntSxp}) = Cint
eltype(::Type{RealSxp}) = Float64
eltype(::Type{CplxSxp}) = Complex128
eltype(::Type{CharSxp}) = UInt8
eltype(::Type{RawSxp}) = UInt8

eltype(::Type{StrSxp}) = Ptr{CharSxp}
eltype(::Type{VecSxp}) = Ptr{UnknownSxp}
eltype(::Type{ExprSxp}) = Ptr{UnknownSxp}

eltype{S<:Sxp}(s::Ptr{S}) = eltype(S)
eltype{S<:Sxp}(s::RObject{S}) = eltype(S)


"""
Prevent garbage collection of an R object. Object can be released via `release`.

This is slower than `protect`, as it requires searching an internal list, but
more flexible.
"""
preserve{S<:Sxp}(p::Ptr{S}) = ccall((:R_PreserveObject,libR), Void, (Ptr{S},), p)

"""
Release object that has been gc protected by `preserve`.
"""
release{S<:Sxp}(p::Ptr{S}) = ccall((:R_ReleaseObject,libR),Void,(Ptr{S},),p)
release{S<:Sxp}(r::RObject{S}) = release(r.p)

"""
Stack-based protection of garbage collection of R objects. Objects are
released via `unprotect`. Returns the same pointer, allowing inline use.

This is faster than `preserve`, but more restrictive. Really only useful
inside functions.
"""
protect{S<:Sxp}(p::Ptr{S}) = ccall((:Rf_protect,libR), Ptr{S}, (Ptr{S},), p)

"""
Release last `n` objects gc-protected by `protect`.
"""
unprotect(n::Integer) = ccall((:Rf_unprotect,libR), Void, (Cint,), n)

"""
The SEXPTYPE number of a `Sxp`

Determined from the trailing 5 bits of the first 32-bit word. Is
a 0-based index into the `info` field of a `SxpHead`.
"""
sexpnum(h::SxpHead) = h.info & 0x1f
sexpnum{S<:Sxp}(p::Ptr{S}) = sexpnum(unsafe_load(p))

"vector of R Sxp types"
const typs = [NilSxp,SymSxp,ListSxp,ClosSxp,EnvSxp,
              PromSxp,LangSxp,SpecialSxp,BuiltinSxp,CharSxp,
              LglSxp,Void,Void,IntSxp,RealSxp,
              CplxSxp,StrSxp,DotSxp,AnySxp,VecSxp,
              ExprSxp,BcodeSxp,ExtPtrSxp,WeakRefSxp,RawSxp,
              S4Sxp]

for (i,T) in enumerate(typs)
    if T != Void
        @eval sexpnum(::Type{$T}) = $(i-1)
    end
end


"""
Convert a `Ptr{UnknownSxp}` to an approptiate `Ptr{S<:Sxp}`.
"""
function sexp(p::Ptr{UnknownSxp})
    typ = sexpnum(p)
    0 ≤ typ ≤ 10 || 13 ≤ typ ≤ 25 || error("Unknown SEXPTYPE $typ")
    styp = typs[typ+1]
    Ptr{styp}(p)
end
sexp{S<:Sxp}(s::Ptr{S}) = s
sexp(r::RObject) = r.p

sexp{S<:Sxp}(::Type{S},s::Ptr{S}) = s
sexp{S<:Sxp}(::Type{S},r::RObject{S}) = r.p
