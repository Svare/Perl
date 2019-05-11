#!/usr/bin/perl

use strict;         # Para evitar ambiguedades
use 5.014;          # Para usar say
use Data::Dumper;   # Para debug
use Switch;         # Para switch

require DaemonCalculator;

if (defined $ARGV[0]) { # Usar ""
    say DaemonCalculator::brackets(split / /, $ARGV[0]);
} else {

    print("\nSelecciona una Opción\n\n");

    print("\t1.- Seno\n");
    print("\t2.- Coseno\n");
    print("\t3.- Tangente\n");
    print("\t4.- Cotangente\n");
    print("\t5.- Aritmeticas (+,-,*,/,^,¬,!)\n");
    print("\t6.- Porcentage\n");
    print("\t7.- Modulo\n");
    print("\t8.- Raíz\n");
    print("\t9.- Potencia\n");
    print("\t10.- Factorial\n");

    print("\nOpción: ");
    my $option = <STDIN>;
    chomp $option;

    my $value;
    my $operation;
    my @operation_lst;

    switch($option) {

        case 1 { # Seno

            print("\nValor (#): ");
            $value = <STDIN>;
            chomp $value;

            say "Resultado: " . sin($value);

        }

        case 2 { # Coseno

            print("\nValor (#): ");
            $value = <STDIN>;
            chomp $value;

            say "Resultado: " . cos($value);

        }

        case 3 { # Tangente

            print("\nValor (#): ");
            $value = <STDIN>;
            chomp $value;

            say "Resultado: " . sin($value)/cos($value);

        }

        case 4 { # Cotangente

            print("\nValor (#): ");
            $value = <STDIN>;
            chomp $value;

            say "Resultado: " . 1/(sin($value)/cos($value));

        }

        case 5 { # Aritmeticas (no necesita "")

            print("\nOperación: ");
            @operation_lst = split(/\s+/, <STDIN>);

            say "Resultado: " . DaemonCalculator::arithmetic(@operation_lst);

        }

        case 6 { # Porcentaje

            print("\nOperación (% # #): ");
            @operation_lst = split(/\s+/, <STDIN>);

            say "Resultado: " . ((@operation_lst[1]/100)*@operation_lst[2]);

        }

        case 7 { # Modulo

            print("\nOperación (# % #): ");
            @operation_lst = split(/\s+/, <STDIN>);

            say "Resultado: " . @operation_lst[0] % @operation_lst[2];
        }

        case 8 { # Raíz

            print("\nOperación (# ¬ #): ");
            @operation_lst = split(/\s+/, <STDIN>);

            say "Resultado: " . @operation_lst[2] ** (1/@operation_lst[0]);
        }

        case 9 { # Potencia

            print("\nOperación (# ^ #): ");
            @operation_lst = split(/\s+/, <STDIN>);

            say "Resultado: " . DaemonCalculator::pow(@operation_lst[0], @operation_lst[2]);

        }

        case 10 { # Factorial

            print("\nOperación (# !): ");
            @operation_lst = split(/\s+/, <STDIN>);
            
            say "Resultado: " . DaemonCalculator::fact(@operation_lst[0]);

        }

    }

}