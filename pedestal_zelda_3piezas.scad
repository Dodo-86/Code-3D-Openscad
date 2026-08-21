// ============================================================
// PEDESTAL RECTANGULAR HUECO DE 3 PIEZAS
// Inspiración: pedestal de fantasía / templo antiguo
// Pensado para impresión 3D y electrónica interna
//
// Archivo: pedestal_zelda_3piezas.scad
// Unidades: milímetros
// ============================================================

$fn = 64;


// ============================================================
// PARÁMETROS
// ============================================================

// ---------- Base ----------
base_x = 120;
base_y = 80;
base_z = 20;

// ---------- Cuerpo central ----------
cuerpo_x = 70;
cuerpo_y = 60;
cuerpo_z = 100;

// ---------- Tapa ----------
tapa_x = 100;
tapa_y = 70;
tapa_z = 15;

// ---------- Grosor de paredes ----------
pared = 3;

// ---------- Encajes ----------
encaje_x = 58;
encaje_y = 48;
encaje_z = 4;

// Tolerancia para impresión 3D
holgura = 0.30;

// ---------- Paso de cables ----------
cable_diam_inferior = 12;
cable_diam_lateral = 10;

// ---------- Vista ----------
modo_explotado = true;
separacion = 25;


// ============================================================
// MÓDULOS AUXILIARES
// ============================================================

// Caja rectangular hueca abierta arriba y abajo
module tubo_rectangular(x, y, z, espesor) {
    difference() {
        cube([x, y, z], center = true);

        cube([
            x - 2 * espesor,
            y - 2 * espesor,
            z + 2
        ], center = true);
    }
}


// Marco rectangular decorativo
module marco_rectangular(x, y, z, ancho) {
    difference() {
        cube([x, y, z], center = true);

        cube([
            x - 2 * ancho,
            y - 2 * ancho,
            z + 2
        ], center = true);
    }
}


// Encaje hueco
module anillo_encaje(x, y, z, espesor) {
    difference() {
        cube([x, y, z], center = true);

        cube([
            x - 2 * espesor,
            y - 2 * espesor,
            z + 2
        ], center = true);
    }
}


// ============================================================
// PIEZA 1 - BASE HUECA
// ============================================================

module base() {
    difference() {
        union() {
            // Cuerpo exterior de la base
            cube([
                base_x,
                base_y,
                base_z
            ], center = true);

            // Marco superior decorativo
            translate([
                0,
                0,
                base_z / 2 + 2
            ])
            marco_rectangular(
                base_x - 10,
                base_y - 10,
                4,
                5
            );
        }

        // Hueco interior
        translate([
            0,
            0,
            pared
        ])
        cube([
            base_x - 2 * pared,
            base_y - 2 * pared,
            base_z
        ], center = true);

        // Rebaje para recibir el cuerpo
        translate([
            0,
            0,
            base_z / 2 - encaje_z / 2
        ])
        cube([
            encaje_x + 2 * holgura,
            encaje_y + 2 * holgura,
            encaje_z + 0.5
        ], center = true);

        // Paso inferior para cables
        translate([
            0,
            0,
            -base_z / 2
        ])
        cylinder(
            h = pared * 4,
            d = cable_diam_inferior,
            center = true
        );

        // Salida frontal de cable
        translate([
            0,
            -base_y / 2,
            -base_z / 4
        ])
        rotate([90, 0, 0])
        cylinder(
            h = pared * 4,
            d = cable_diam_inferior,
            center = true
        );
    }
}


// ============================================================
// PIEZA 2 - CUERPO CENTRAL HUECO
// ============================================================

module cuerpo() {
    difference() {
        union() {
            // Columna hueca
            tubo_rectangular(
                cuerpo_x,
                cuerpo_y,
                cuerpo_z,
                pared
            );

            // Moldura inferior
            translate([
                0,
                0,
                -cuerpo_z / 2 + 5
            ])
            marco_rectangular(
                cuerpo_x + 8,
                cuerpo_y + 8,
                5,
                4
            );

            // Moldura superior
            translate([
                0,
                0,
                cuerpo_z / 2 - 5
            ])
            marco_rectangular(
                cuerpo_x + 8,
                cuerpo_y + 8,
                5,
                4
            );

            // Encaje inferior macho
            translate([
                0,
                0,
                -cuerpo_z / 2 - encaje_z / 2
            ])
            anillo_encaje(
                encaje_x,
                encaje_y,
                encaje_z,
                pared
            );

            // Encaje superior macho
            translate([
                0,
                0,
                cuerpo_z / 2 + encaje_z / 2
            ])
            anillo_encaje(
                encaje_x,
                encaje_y,
                encaje_z,
                pared
            );
        }

        // Hueco central continuo
        cube([
            cuerpo_x - 2 * pared,
            cuerpo_y - 2 * pared,
            cuerpo_z + encaje_z * 4
        ], center = true);

        // Paso lateral para USB / alimentación
        translate([
            cuerpo_x / 2,
            0,
            -cuerpo_z / 3
        ])
        rotate([0, 90, 0])
        cylinder(
            h = pared * 5,
            d = cable_diam_lateral,
            center = true
        );
    }
}


// ============================================================
// PIEZA 3 - TAPA SUPERIOR HUECA
// ============================================================

module tapa() {
    difference() {
        union() {
            // Volumen exterior
            cube([
                tapa_x,
                tapa_y,
                tapa_z
            ], center = true);

            // Marco superior decorativo
            translate([
                0,
                0,
                tapa_z / 2 + 1.5
            ])
            marco_rectangular(
                tapa_x - 8,
                tapa_y - 8,
                3,
                5
            );
        }

        // Hueco interior
        translate([
            0,
            0,
            -pared
        ])
        cube([
            tapa_x - 2 * pared,
            tapa_y - 2 * pared,
            tapa_z
        ], center = true);

        // Rebaje inferior para el encaje
        translate([
            0,
            0,
            -tapa_z / 2 + encaje_z / 2
        ])
        cube([
            encaje_x + 2 * holgura,
            encaje_y + 2 * holgura,
            encaje_z + 0.5
        ], center = true);
    }
}


// ============================================================
// MONTAJE
// ============================================================

module pedestal_montado() {
    // Base
    translate([
        0,
        0,
        base_z / 2
    ])
    base();

    // Cuerpo
    translate([
        0,
        0,
        base_z + cuerpo_z / 2
    ])
    cuerpo();

    // Tapa
    translate([
        0,
        0,
        base_z + cuerpo_z + tapa_z / 2
    ])
    tapa();
}


// ============================================================
// VISTA EXPLOTADA
// ============================================================

module pedestal_explotado() {
    // Base
    translate([
        0,
        0,
        base_z / 2
    ])
    base();

    // Cuerpo
    translate([
        0,
        0,
        base_z +
        separacion +
        cuerpo_z / 2
    ])
    cuerpo();

    // Tapa
    translate([
        0,
        0,
        base_z +
        cuerpo_z +
        separacion * 2 +
        tapa_z / 2
    ])
    tapa();
}


// ============================================================
// SALIDA
// ============================================================

if (modo_explotado) {
    pedestal_explotado();
} else {
    pedestal_montado();
}


// ============================================================
// EXPORTACIÓN INDIVIDUAL A STL
// ============================================================
//
// Para exportar una sola pieza, comenta la salida anterior y
// descomenta únicamente una de estas líneas:
//
// base();
// cuerpo();
// tapa();
//
// Después usa F6 y:
// File -> Export -> Export as STL
//
