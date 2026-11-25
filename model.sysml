package Hydrogen_4p_m1__4__1__1_ {
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
            attribute value : Real = 16;
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
            doc /* expression: -sqrt(10)*r*sqrt(1 - u^2)*(r^2/8 - 5*r/2 + 10)*exp(-r/4)/(640*sqrt(pi)) */
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
            doc /* expression: -(r^8/491520 - r^7/20480 + 7*r^6/15360 - r^5/960 + r^4/384 + r^3/48 + r^2/8 + r/2 + 1)*exp(-r/2) + 1 */
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
