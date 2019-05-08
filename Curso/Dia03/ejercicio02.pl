#!/usr/bin/perl

##############################################
### Developer: Pacheco Franco Jesús Enrique ##
### Date: May 06, 2019 #######################
### Assignment: Exercise 02 Round 03 #########
### Description: nmap report plotter #########
##############################################

sub get_date {

    @date = localtime(time);

    $date[5] += 1900;
    $date[4] ++;

    if($date[4] < 10) {
        $date[4] = "0$date[4]";
    }

    if($date[3] < 10) {
        $date[3] = "0$date[3]";
    }

    return "$date[5]-$date[4]-$date[3] $date[2]:$date[1]:$date[0]\n";

}


$output_log = "cambios.log";
open $log, '>>', $output_log or die "No se pudo abrir el archivo $output_log: $!";

print("\nSelecciona una Opción:\n\n");
print("\t1.- Borrar Archivo\n");
print("\t2.- Renombrar Archivo\n");
print("\t3.- Crear Directorio\n");
print("\t4.- Borrar Directorio Vacío\n");
print("\t5.- Cambiar Permisos a Archivo\n");
print("\t6.- Cambiar Permisos a Archivos\n\n");

print("Opción: ");
$option = <STDIN>;
chomp($option);

if($option eq 1) { # Borrar Archivo
    print("Nombre: ");
    $name = <STDIN>;
    chomp($name);

    unlink($name);

    $date = &get_date;
    print $log "Se Borro: $name - $date\n";

} elsif($option eq 2) { # Renombrar Archivo
    print("Nombre: ");
    $name = <STDIN>;
    chomp($name);
    print("Nuevo nombre: ");
    $new_name = <STDIN>;
    chomp($new_name);

    rename($name, $new_name);

    $date = &get_date;
    print $log "Se Renombró: $name a $new_name - $date\n";

}elsif($option eq 3) { # Crear Directorio
    print("Nombre: ");
    $name = <STDIN>;
    chomp($name);
    print("Permisos: ");
    $permissions = <STDIN>;
    chomp($permissions);

    mkdir($name, oct($permissions));

    $date = &get_date;
    print $log "Se Creó: $name - $date\n";

}elsif($option eq 4) { # Borrar Directorio Vacío
    print("Nombre: ");
    $name = <STDIN>;
    chomp($name);

    rmdir($name);

    $date = &get_date;
    print $log "Se Borró: $name - $date\n";

}elsif($option eq 5) { # Cambiar Permisos a Archivo

    print("Nombre: ");
    $name = <STDIN>;
    chomp($name);
    print("Permisos: ");
    $permissions = <STDIN>;
    chomp($permissions);

    chmod(oct($permissions), $name);

    $date = &get_date;
    print $log "Se Cambiaron Permisos: $name a $permissions - $date\n";

}elsif($option eq 6) { # Cambiar Permisos a Archivos
    print("Nombres(,): ");
    $names = <STDIN>;
    chomp($names);
    print("Permisos: ");
    $permissions = <STDIN>;
    chomp($permissions);
    

    chmod(oct($permissions), split /,/, $names);

    $date = &get_date;
    print $log "Se Cambiaron Permisos: $names a $permissions - $date\n";

}else {
    print("Opción no Válida!!!\n");
}

close($log);