
/*
  Prótesis simple para pata delantera de perro
  Concepto paramétrico para OpenSCAD

  IMPORTANTE:
  - Modelo conceptual / prototipo.
  - No usar directamente en un animal sin validación de un veterinario
    y/o especialista en ortesis y prótesis veterinarias.
  - Ajustar todas las medidas al muñón real y añadir acolchado adecuado.
*/

$fn = 96;

// =============================
// PARÁMETROS PRINCIPALES (mm)
// =============================

// Manguito / cuff
cuff_height       = 65;
cuff_inner_d      = 55;
cuff_wall         = 4;
cuff_gap          = 16;   // abertura lateral para colocar el manguito

// Conector
connector_d       = 24;
connector_h       = 18;

// Tubo
tube_outer_d      = 20;
tube_inner_d      = 14;
tube_length       = 150;

// Agujeros de regulación
hole_d            = 4;
hole_spacing      = 18;
hole_count        = 5;

// Base inferior SIN FORMA DE PIE
base_d            = 34;
base_h            = 10;

// Separaciones para vista explotada
explode            = 0;   // 0 = montada, 1 = explotada
explode_gap        = 18;

// =============================
// CÁLCULOS
// =============================

e1 = explode * explode_gap;
e2 = explode * explode_gap * 2;
e3 = explode * explode_gap * 3;


// =============================
// MÓDULOS
// =============================

module cuff() {
    difference() {
        // cuerpo exterior
        cylinder(h = cuff_height, d = cuff_inner_d + 2*cuff_wall);

        // hueco interior
        translate([0,0,-1])
            cylinder(h = cuff_height + 2, d = cuff_inner_d);

        // abertura lateral
        translate([
            -(cuff_inner_d + 2*cuff_wall),
            -cuff_gap/2,
            -1
        ])
            cube([
                2*(cuff_inner_d + 2*cuff_wall),
                cuff_gap,
                cuff_height + 2
            ]);
    }

    // dos pequeñas orejetas para imaginar cierres de velcro
    for (z = [18, 42]) {
        translate([
            (cuff_inner_d/2 + cuff_wall - 1),
            -11,
            z
        ])
            cube([10, 22, 8], center=false);
    }
}


module connector() {
    difference() {
        cylinder(h = connector_h, d = connector_d);

        // alojamiento del tubo
        translate([0,0,-1])
            cylinder(h = connector_h + 2, d = tube_outer_d + 0.5);
    }
}


module tube() {
    difference() {
        cylinder(h = tube_length, d = tube_outer_d);

        // tubo hueco
        translate([0,0,-1])
            cylinder(h = tube_length + 2, d = tube_inner_d);

        // agujeros de ajuste transversales
        for (i = [0 : hole_count-1]) {
            z = 22 + i*hole_spacing;

            translate([-tube_outer_d, 0, z])
                rotate([0,90,0])
                    cylinder(
                        h = 2*tube_outer_d,
                        d = hole_d
                    );
        }
    }
}


module base_pad() {
    // Base circular simple de apoyo: NO tiene forma anatómica de pie
    difference() {
        cylinder(h = base_h, d = base_d);

        // ligero alojamiento para el tubo
        translate([0,0,base_h-5])
            cylinder(h = 6, d = tube_outer_d + 0.6);
    }
}


// =============================
// ENSAMBLAJE
// =============================

module prosthesis() {
    // Base
    base_pad();

    // Tubo
    translate([0,0,base_h + e1])
        tube();

    // Conector
    translate([
        0,
        0,
        base_h + tube_length + e2
    ])
        connector();

    // Manguito
    translate([
        0,
        0,
        base_h + tube_length + connector_h + e3
    ])
        cuff();
}

prosthesis();
