"""Generate exact meridian amplitudes and enclosed radial probabilities, in atomic units."""
import sympy as s

def expressions(n,l,m):
    r=s.Symbol('r',positive=True)
    u=s.Symbol('u',real=True)
    q=2*r/n
    normalization=(s.Rational(2,n)**3*s.factorial(n-l-1)/(2*n*s.factorial(n+l)))**s.Rational(1,2)
    radial=normalization*q**l*s.assoc_laguerre(n-l-1,2*l+1,q)*s.exp(-r/n)
    ang=s.sqrt((2*l+1)*s.factorial(l-m)/(4*s.pi*s.factorial(l+m)))*s.assoc_legendre(l,m,u)
    # Integrate each polynomial term of r²R² from r to infinity analytically.
    poly=s.Poly(s.expand(r**2*(radial*s.exp(r/n))**2),r)
    rate=s.Rational(2,n)
    tail=sum(c*s.factorial(k)/rate**(k+1)*sum((rate*r)**j/s.factorial(j) for j in range(k+1))
             for (k,),c in poly.terms())
    assert s.simplify(tail.subs(r,0))==1
    return r,u,radial*ang,1-s.exp(-rate*r)*s.expand(tail)
