package Hydrogen_3d_m2__3__2__2_ {
    private import ScalarValues::*;
    doc /* Engine: symbolic-distributions/v2. Ports denote symbolic random variables; numerical evaluation occurs only at visualization taps. */

    port def Signal {
        out item value : Real;
    }

    part def Block {
        port output : Signal;
    }

    item def QuantumValue;
    port def QuantumSignal { out item value : QuantumValue; }
    part def QuantumBlock { port output : QuantumSignal; }

    part model {
        attribute visualizationDrawCount : Integer = 10000;
        attribute iterations : Integer = 1;
        attribute visualizationSeed : Integer = 42;

        part kinetic : QuantumBlock {
            doc /* Kinetic energy | kinetic */
            attribute mass : Real = 1;
        }

        part potential : QuantumBlock {
            doc /* Coulomb potential | coulomb */
            attribute charge : Real = 1;
        }

        part H : QuantumBlock {
            doc /* Hamiltonian | hamiltonian */
            port kinetic : ~QuantumSignal;
            doc /* kinetic: Required Kinetic energy output. Default: required. */
            port potential : ~QuantumSignal;
            doc /* potential: Required Coulomb potential output. Default: required. */
        }

        part basis : QuantumBlock {
            doc /* Angular momentum | angularBasis */
            attribute ell : Real = 2;
            attribute m : Real = 2;
        }

        part radial : QuantumBlock {
            doc /* Radial eigenproblem | radialEigen */
            attribute n : Real = 3;
            port H : ~QuantumSignal;
            doc /* H: Required Hamiltonian output. Default: required. */
            port basis : ~QuantumSignal;
            doc /* basis: Required Angular momentum output. Default: required. */
        }

        part angular : QuantumBlock {
            doc /* Angular eigenproblem | angularEigen */
            port basis : ~QuantumSignal;
            doc /* basis: Required Angular momentum output. Default: required. */
        }

        part psi : QuantumBlock {
            doc /* Stationary state | eigenstate */
            port R : ~QuantumSignal;
            doc /* R: Required Radial eigenproblem output. Default: required. */
            port Y : ~QuantumSignal;
            doc /* Y: Required Angular eigenproblem output. Default: required. */
        }

        part normalized : QuantumBlock {
            doc /* Normalize state | normalizeState */
            port state : ~QuantumSignal;
            doc /* state: Required Stationary state output. Default: required. */
        }

        part density : QuantumBlock {
            doc /* Born density | born */
            port state : ~QuantumSignal;
            doc /* state: Required Normalize state output. Default: required. */
        }

        part energy : Block {
            doc /* Eigenenergy | eigenenergy */
            port radial : ~QuantumSignal;
            doc /* radial: Required Radial eigenproblem output. Default: required. */
        }

        part sphere : Block {
            doc /* Sphere probability | sphereMass */
            attribute radius : Real = 9;
            port density : ~QuantumSignal;
            doc /* density: Required Born density output. Default: required. */
        }

        part field : Block {
            doc /* Position density | tap */
            doc /* Visualization observes density.output. */
        }

        part insideTap : Block {
            doc /* Enclosed probability | tap */
            doc /* Visualization observes sphere.output. */
        }

        connect kinetic.output to H.kinetic;
        connect potential.output to H.potential;
        connect H.output to radial.H;
        connect basis.output to radial.basis;
        connect basis.output to angular.basis;
        connect radial.output to psi.R;
        connect angular.output to psi.Y;
        connect psi.output to normalized.state;
        connect normalized.output to density.state;
        connect radial.output to energy.radial;
        connect density.output to sphere.density;
    }
}
