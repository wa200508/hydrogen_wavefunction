package Hydrogen_1s_ground_state {
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

        part radius : Block {
            doc /* Electron radius (a₀) | gamma */
            attribute shape : Real = 3;
            attribute value : Real = 1;
            attribute min : Real = 0;
            attribute max : Real = 1;
            attribute mean : Real = 0;
            attribute sigma : Real = 1;
            attribute lambda : Real = 2;
            attribute p : Real = 0.5;
            attribute r : Real = 3.9;
            attribute a : Real = 2;
            attribute b : Real = 2;
            attribute steps : Real = 12;
        }

        part inside : Block {
            doc /* Inside probe sphere? | less */
            attribute value : Real = 1;
            attribute min : Real = 0;
            attribute max : Real = 1;
            attribute mean : Real = 0;
            attribute sigma : Real = 1;
            attribute lambda : Real = 1;
            attribute p : Real = 0.5;
            attribute r : Real = 3.9;
            attribute a : Real = 2;
            attribute default_b : Real = 2;
            attribute steps : Real = 12;
            port x : ~Signal;
            doc /* x: First operand: a symbolic random variable. Default: 1/2. */
            port b : ~Signal;
            doc /* b: Second operand. The inspector default is used when unconnected. Default: 2. */
        }

        part insideTap : Block {
            doc /* Inside = 1, outside = 0 | tap */
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
            doc /* Visualization observes inside.output. */
        }

        part radialTap : Block {
            doc /* Radial probability (a₀) | tap */
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
            doc /* Visualization observes radius.output. */
        }

        part probe : Block {
            doc /* Probe radius (a₀) | constant */
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
        }

        part psi : Block {
            doc /* 1s amplitude (a₀⁻³ᐟ²) | custom */
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
            port x : ~Signal;
            doc /* x: Input variable x. Its wire carries a symbolic random variable; the default is used when unconnected. Default: 1/2. */
            doc /* expression: exp(-x)/sqrt(pi) */
        }

        connect radius.output to inside.x;
        connect probe.output to inside.b;
        connect probe.output to psi.x;
    }
}
