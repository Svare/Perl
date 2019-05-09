#!/usr/bin/perl

##############################################
### Developer: Pacheco Franco Jesús Enrique ##
### Date: May 07-09, 2019 ####################
### Assignment: Exercise 03 Round 03 #########
### Description: calculadora brutal ##########
##############################################

use strict;
use 5.014; # Para usar say

use Data::Dumper;
use Switch;

sub index_of {

    map {
        @_[$_] eq @_[0] ? return ($_ - 1) : 1;
    } (1..scalar(@_)-1);

    return undef;

}

sub index_operator {

    # Recibe los dos operadores y el arreglo sobre el cual buscar
    # Regresa (indice, operador)

    my $op1 = shift;
    my $op2 = shift;

    my $index_op1 = index_of($op1, @_);
    my $index_op2 = index_of($op2, @_);

    if(defined $index_op1 && defined $index_op2) {
        ($index_op1 < $index_op2) ? return ($index_op1, $op1) : return ($index_op2, $op2);
    } elsif (!defined $index_op1 && !defined $index_op2) {
        return undef;
    } else {
        (!defined $index_op1) ? return ($index_op2, $op2) : return ($index_op1, $op1);
    }

}

sub operator_index {

    my $heuristic = shift;              # top izq ó top derecha
    my $number = shift;                 # numero de operadores a buscar
    my @operators = @_[0..$number-1];   # arreglo con los operadores a buscar
    my $index = undef;                  # indice del operador encontrado

    map {

        my $current_index = index_of($_, @_[$number..$#_]);

        if(defined $current_index) {
            if(!defined $index) {

                $index = $current_index;

            } else {

                $index = ($heuristic eq 'left') ?
                    ($index > $current_index) ? 
                        $current_index 
                        : 
                        $index 
                    : 
                    ($index > $current_index) ? 
                        $index 
                        : 
                        $current_index;

            }
        }


    } @operators;

    return $index;

}

sub prev_open_bracket {

    # Busca el parentesis mas proximo a la izquierda dada una posicion dentro de un arreglo
    # prev_open_bracket($pos, @str_array)
    # prev_open_bracket(5, ('6', '2', '(', '5', '6', '0')) retornaria 2

    my $i = @_[0] - 1;
    my @tmp = @_[1..scalar(@_)];

    while($i ge 0) {
        @tmp[$i] eq '(' ? return $i : 1;
        $i--;
    }

    return undef;

}

sub pow {
    my $tmp = $_[0];
    map {
        $tmp *= $_[0];
    } 0..$_[1]-2;
    return $tmp;
}

sub fact {
    return (@_[0] <= 1) ? 1 : @_[0]*fact(@_[0]-1);
}

sub trigonometric {

    my $index = operator_index('right', 4, 'sin', 'cos', 'tan', 'cotan', @_);

    if(!defined $index || scalar(@_) eq 1) { # Caso base, si ya no hay * ó / ó la lista tiene un elemento
        return @_;
    } else {
        
        my $result;

        if(@_[$index] eq 'sin') {
            $result = sin(@_[$index + 1]);
        } elsif(@_[$index] eq 'cos') {
            $result = cos(@_[$index + 1]);
        } elsif(@_[$index] eq 'tan') {
            $result = sin(@_[$index + 1]) / cos(@_[$index + 1]);
        } elsif(@_[$index] eq 'cotan') {
            $result = 1 / (sin(@_[$index + 1]) / cos(@_[$index + 1]));
        } else {
            say "Have no idea wtf it's happening";
        }

        if(scalar(@_) eq 2) {                                               # Solo hay una operacion
            trigonometric(($result));
        } elsif($index eq 1) {                                              # Al principio
            trigonometric(($result, (@_[$index+2..$#_])));
        } elsif($index eq $#_) {                                            # Al Final
            trigonometric(((@_[0..$index-1]), $result));
        } else {                                                            # En Medio
            trigonometric(((@_[0..$index-1]), $result, (@_[$index+2..$#_])));
        }

    }

}

sub factorial {

    my $index = index_of('!', @_);

    if(!defined $index || scalar(@_) eq 1) { # Caso base, si ya no hay * ó / ó la lista tiene un elemento
        return @_;
    } else {

        my $result = fact(@_[$index-1]);

        if(scalar(@_) eq 2) {                                               # Solo hay una operacion
            factorial(($result));
        } elsif($index eq 1) {                                              # Al principio
            factorial(($result, (@_[$index+1..$#_])));
        } elsif($index eq $#_) {                                            # Al Final
            factorial(((@_[0..$index-2]), $result));
        } else {                                                            # En Medio
            factorial(((@_[0..$index-2]), $result, (@_[$index+1..$#_])));
        }

    }

}

sub pot_sqrt {

    # Recibe el arreglos de la expresion
    # Regresa un arreglo con todas las potencias y racies ya calculadas

    (my $index, my $op) = index_operator('^', '¬', @_);

    if(!defined $index || scalar(@_) eq 1) { # Caso base, si ya no hay * ó / ó la lista tiene un elemento
        return @_;
    } else {

        my $result = (@_[$index] eq '^') ? pow(@_[$index-1], @_[$index+1]) : @_[$index+1] ** (1/@_[$index-1]);

        if(scalar(@_) eq 3) {                                               # Solo hay una operacion con dos operandos
            pot_sqrt(($result));
        } elsif($index eq 1) {                                              # Al principio
            pot_sqrt(($result, (@_[$index+2..$#_])));
        } elsif($index eq $#_ - 1) {                                        # Al Final
            pot_sqrt(((@_[0..$index-2]), $result));
        } else {                                                            # En Medio
            pot_sqrt(((@_[0..$index-2]), $result, (@_[$index+2..$#_])));
        }

    }

}

sub mult_div {

    # Recibe el arreglos de la expresion
    # Regresa un arreglo con todas las multiplicaciones y divisiones ya calculadas

    (my $index, my $op) = index_operator('*', '/', @_);

    if(!defined $index || scalar(@_) eq 1) { # Caso base, si ya no hay * ó / ó la lista tiene un elemento
        return @_;
    } else {

        my $result = (@_[$index] eq '*') ? @_[$index-1] * @_[$index+1] : @_[$index-1] / @_[$index+1];

        if(scalar(@_) eq 3) {                                               # Solo hay una operacion con dos operandos
            mult_div(($result));
        } elsif($index eq 1) {                                              # Al principio
            mult_div(($result, (@_[$index+2..$#_])));
        } elsif($index eq $#_ - 1) {                                        # Al Final
            mult_div(((@_[0..$index-2]), $result));
        } else {                                                            # En Medio
            mult_div(((@_[0..$index-2]), $result, (@_[$index+2..$#_])));
        }

    }

}

sub add_sub {

    if(scalar(@_) eq 1) {
        return @_[0];
    } else {

        my $result = (@_[1] eq '+') ? @_[0] + @_[2] : @_[0] - @_[2];

        if(scalar(@_) eq 3) {
            add_sub(($result));
        } else {
            add_sub(($result, (@_[3..$#_])));
        }

    }

}

sub arithmetic {
    return add_sub(mult_div(pot_sqrt(factorial(@_))));
}

sub hierarchical {
    return add_sub(mult_div(pot_sqrt(trigonometric(factorial(@_)))));
}

sub brackets {

    my $closing_bracket_index = index_of(')', @_);

    if(!defined $closing_bracket_index) { # Caso base ya no hay parentesis que cierra ya acabe
        return hierarchical(@_); # Ultima pasada con aritmethic para que regrese un unico valor
    } else {

        my $opening_bracket_index = prev_open_bracket($closing_bracket_index, @_);
        my @between_brackets = @_[$opening_bracket_index+1..$closing_bracket_index-1];

        if($opening_bracket_index eq 0 && $closing_bracket_index eq $#_) { # ( ... )
            brackets(@between_brackets);
        } elsif($opening_bracket_index eq 0 && $closing_bracket_index ne $#_) { # ( ... ) ...
            brackets((hierarchical(@between_brackets), (@_[$closing_bracket_index+1..$#_])));
        } elsif($opening_bracket_index ne 0 && $closing_bracket_index eq $#_) { # ... ( ... )
            brackets(((@_[0..$opening_bracket_index-1]), hierarchical(@between_brackets)));
        } else { # ... ( ... ) ...
            brackets(((@_[0..$opening_bracket_index-1]), hierarchical(@between_brackets), (@_[$closing_bracket_index+1..$#_])));
        }

    }

}

if (defined $ARGV[0]) { # Usar ""
    say brackets(split / /, $ARGV[0]);
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

            say "Resultado: " . arithmetic(@operation_lst);

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

            say "Resultado: " . pow(@operation_lst[0], @operation_lst[2]);

        }

        case 10 { # Factorial

            print("\nOperación (# !): ");
            @operation_lst = split(/\s+/, <STDIN>);
            
            say "Resultado: " . fact(@operation_lst[0]);

        }

    }

}

# say brackets(qw(2 ¬ ( -1 * ( 3 ^ 5 * ( sin ( 30 ) - 100 ) ) ) + cos ( 60 )));