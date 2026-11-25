"""Check a compiled branch against the Schrödinger and angular-momentum eigenproblems."""
import json
import sys
from pathlib import Path

import sympy as sp
from sympy.physics.hydrogen import R_nl


def verify(folder):
    model = json.loads((folder / "model.json").read_text())
    graph = json.loads((folder / "model.symbolic.json").read_text())
    assert not graph["errors"]
    nodes = {node["id"]: node for node in model["nodes"]}
    assert all(node["op"] != "custom" for node in nodes.values())
    q = graph["quantum"]
    n = nodes["radial"]["params"]["n"]
    ell, m = (nodes["basis"]["params"][k] for k in ("ell", "m"))
    mass = sp.Rational(str(nodes["kinetic"]["params"]["mass"]))
    charge = sp.Rational(str(nodes["potential"]["params"]["charge"]))
    r, u = sp.Symbol("r", positive=True), sp.Symbol("u", real=True)

    def expr(text):
        return sp.sympify(text, locals={"r": r, "u": u}, rational=True)

    R, Y = expr(q["radial"]["expression"]), expr(q["angular"]["expression"])
    E = expr(q["energy"]["scalar"])
    radial_laplacian = sp.diff(r*r*sp.diff(R, r), r)/r**2 - ell*(ell+1)*R/r**2
    assert sp.simplify(-radial_laplacian/(2*mass) - charge*R/r - E*R) == 0
    angular_op = -sp.diff((1-u*u)*sp.diff(Y, u), u) + m*m*Y/(1-u*u)
    assert sp.simplify(angular_op - ell*(ell+1)*Y) == 0
    assert E == -mass*charge**2/(2*n*n)
    assert sp.simplify(R - R_nl(n, ell, r, mass*charge)) == 0
    assert sp.integrate(sp.expand(R**2)*r*r, (r, 0, sp.oo)).simplify() == 1
    assert sp.simplify(2*sp.pi*sp.integrate(sp.expand(Y**2), (u, -1, 1))) == 1
    cdf = expr(q["density"]["cdf"])
    assert cdf.subs(r, 0) == 0 and sp.limit(cdf, r, sp.oo) == 1
    assert sp.simplify(sp.diff(cdf, r) - r*r*R*R) == 0
    assert sp.simplify(expr(q["density"]["density"]) - (R*Y)**2) == 0
    print(f"{model['branch']} verified", flush=True)


if __name__ == "__main__":
    for folder in sys.argv[1:] or [Path(__file__).resolve().parents[1]]:
        verify(Path(folder))
