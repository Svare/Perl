
$history = "\n";

print "Calculadora\n";
print("     1.- Suma\n");
print("     2.- Resta\n");
print("     3.- Multiplica\n");
print("     4.- Divide\n");

while(1){
print('opcion: ');
$opcion = <stdin>;
print('a: ');
$a = <stdin>;
$a =~ s/^\s+|\s+$//g;
print('b: ');
$b = <stdin>;
$b =~ s/^\s+|\s+$//g;

if($opcion == 1) {
    print($a + $b);
    $res = $a + $b;
    $history .= "Sumando $a + $b = $res\n";
} elsif($opcion == 2) {
    print($a - $b);
    $res = $a - $b;
    $history .= "Restando $a - $b = $res\n";
}elsif($opcion == 3) {
    print($a*$b);
    $res = $a * $b;
    $history .= "Multiplicando $a * $b = $res\n";
}elsif($opcion== 4) {
    print($a/$b);
    $res = $a / $b;
    $history .= "Dividiendo $a / $b = $res\n";
}
    print($history)
}