let rec factorial
=fun n -> if n < 1 then 1 else n * (factorial (n-1));;

factorial 5;;
print_int (factorial 5);;
