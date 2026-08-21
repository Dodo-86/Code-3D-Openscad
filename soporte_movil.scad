// Soporte para movil - OpenSCAD
// Unidades: mm
$fn = 64;

ancho = 80;
fondo = 95;
alto_trasero = 95;
grosor = 6;
angulo = 18;
tope_alto = 14;
tope_fondo = 12;
canal_ancho = 16;
canal_alto = 10;

module base() {
    cube([ancho, fondo, grosor], center=false);
}

module respaldo() {
    translate([0, fondo - 28, grosor])
        rotate([angulo, 0, 0])
            cube([ancho, grosor, alto_trasero], center=false);
}

module tope() {
    difference() {
        translate([0, 8, grosor])
            cube([ancho, tope_fondo, tope_alto], center=false);

        translate([ancho/2 - canal_ancho/2, 6, grosor])
            cube([canal_ancho, tope_fondo + 5, canal_alto], center=false);
    }
}

module soporte_movil() {
    union() {
        base();
        respaldo();
        tope();
    }
}

soporte_movil();

// Exportacion:
// 1. Pulsa F6.
// 2. File -> Export -> Export as STL.
// Modifica las medidas superiores para adaptar el soporte.
