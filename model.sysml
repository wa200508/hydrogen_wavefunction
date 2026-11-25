package Hydrogen_3p_m0__3__1__0_ {
    private import ScalarValues::*;
    doc /* Engine: symbolic-distributions/v2. Ports denote symbolic random variables; numerical evaluation occurs only at visualization taps. */

    port def Signal {
        out item value : Real;
    }

    part def Block {
        port output : Signal;
    }

    part model {
        attribute visualizationDrawCount : Integer = 10000;
        attribute iterations : Integer = 1;
        attribute visualizationSeed : Integer = 42;

        part probe : Block {
            doc /* Radius r (a₀) | constant */
            attribute value : Real = 9;
            attribute min : Real = 0;
            attribute max : Real = 1;
            attribute mean : Real = 0;
            attribute sigma : Real = 1;
            attribute lambda : Real = 1;
            attribute p : Real = 0.5;
            attribute r : Real = 3.9;
            attribute a : Real = 2;
            attribute b : Real = 2;
            attribute steps : Real = 12;
        }

        part polar : Block {
            doc /* cos θ | constant */
            attribute value : Real = 0.5;
            attribute min : Real = 0;
            attribute max : Real = 1;
            attribute mean : Real = 0;
            attribute sigma : Real = 1;
            attribute lambda : Real = 1;
            attribute p : Real = 0.5;
            attribute r : Real = 3.9;
            attribute a : Real = 2;
            attribute b : Real = 2;
            attribute steps : Real = 12;
        }

        part psi : Block {
            doc /* Meridian amplitude | custom */
            attribute value : Real = 1;
            attribute min : Real = 0;
            attribute max : Real = 1;
            attribute mean : Real = 0;
            attribute sigma : Real = 1;
            attribute lambda : Real = 1;
            attribute p : Real = 0.5;
            attribute default_r : Real = 3.9;
            attribute a : Real = 2;
            attribute b : Real = 2;
            attribute steps : Real = 12;
            port r : ~Signal;
            doc /* r: Input variable r. Its wire carries a symbolic random variable; the default is used when unconnected. Default: 3.9. */
            port u : ~Signal;
            doc /* u: Input variable u. Its wire carries a symbolic random variable; the default is used when unconnected. Default: 0. */
            doc /* expression: sqrt(2)*r*u*(4 - 2*r/3)*exp(-r/3)/(54*sqrt(pi)) */
        }

        part sphere : Block {
            doc /* P(inside sphere) | custom */
            attribute value : Real = 1;
            attribute min : Real = 0;
            attribute max : Real = 1;
            attribute mean : Real = 0;
            attribute sigma : Real = 1;
            attribute lambda : Real = 1;
            attribute p : Real = 0.5;
            attribute default_r : Real = 3.9;
            attribute a : Real = 2;
            attribute b : Real = 2;
            attribute steps : Real = 12;
            port r : ~Signal;
            doc /* r: Input variable r. Its wire carries a symbolic random variable; the default is used when unconnected. Default: 3.9. */
            doc /* expression: -(4*r^6/6561 - 4*r^5/2187 + 2*r^4/243 + 4*r^3/81 + 2*r^2/9 + 2*r/3 + 1)*exp(-2*r/3) + 1 */
        }

        part field : Block {
            doc /* Orbital density | tap */
            attribute value : Real = 1;
            attribute min : Real = 0;
            attribute max : Real = 1;
            attribute mean : Real = 0;
            attribute sigma : Real = 1;
            attribute lambda : Real = 1;
            attribute p : Real = 0.5;
            attribute r : Real = 3.9;
            attribute a : Real = 2;
            attribute b : Real = 2;
            attribute steps : Real = 12;
            doc /* Visualization observes psi.output. */
        }

        part enclosed : Block {
            doc /* Enclosed probability | tap */
            attribute value : Real = 1;
            attribute min : Real = 0;
            attribute max : Real = 1;
            attribute mean : Real = 0;
            attribute sigma : Real = 1;
            attribute lambda : Real = 1;
            attribute p : Real = 0.5;
            attribute r : Real = 3.9;
            attribute a : Real = 2;
            attribute b : Real = 2;
            attribute steps : Real = 12;
            doc /* Visualization observes sphere.output. */
        }

        connect probe.output to psi.r;
        connect probe.output to sphere.r;
        connect polar.output to psi.u;
    }
}
