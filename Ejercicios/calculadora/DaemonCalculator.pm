#!/usr/bin/perl

use strict;
#use warnings;
#use diagnostics;

use 5.014; # Para usar say

package DaemonCalculator;

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

1;

=head1 NAME

DaemonCalculator - Funciones necesarias para una calculadora hecha por el mismisimo diablo.

=head1 SYNOPSIS

    require DaemonCalculator;
    say DaemonCalculator::brackets(split / /, @input_expression)

=head1 DESCRIPTION

Este modulo hospeda a todas las funciones que fueron creadas para poder
implementar la calculadora del diablo que trabaja con recursividad.

=head2 Methods

=over 12

=item C<hierarchical>

Desarrolla las expresiones que contienen factorial, potencia, raiz,
multiplicacion, division, suma y resta.

Regresa el arreglo de la expresion ya simplificada.

=item C<brackets>

Desarrolla las expresiones que contienen parentesis, factorial, potencia, raiz,
multiplicacion, division, suma y resta.

Regresa el arreglo de la expresion ya simplificada.

=back

=head1 LICENSE

Este modulo fue desarrollado bajo la licencia LG.
Ver B<LG>.

=head1 AUTHOR

Svare - L<https://github.com/Svare/Perl>

=head1 SEE ALSO

L<https://www.ashleymadison.com/>, L<https://www.plentyofcheats.com/>

=cut