#!/usr/bin/perl

@words = qw(hola como estas mi nombre es joc trabajo en el cert me gusta la buena vida y las mujeres sabrosas);

# $num = 1000000;

# foreach $i (0 .. $num) {
#     $j = @words[int(rand($#words))];
#     print($j. ' ');
# }

@wordsII = qw(Padre nuestro,
que estás en el cielo,
santificado sea tu Nombre;
venga a nosotros tu reino;
hágase tu voluntad
en la tierra como en el cielo.

Danos hoy nuestro pan de cada día;
perdona nuestras ofensas,
como también nosotros perdonamos
a los que nos ofenden;
no nos dejes caer en la tentación,
y líbranos del mal. Amén.);

foreach $word (@wordsII) {
    print(ucfirst(lc($word)).' ');
}