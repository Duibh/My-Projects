import java.util.*;

class Calculator{

    public static int choice;
    public static double numOne;
    public static double numTwo;
    public static double result;

    public static void main (String[] args){
	calcChoice();
    }

    public static void resultingOutput(){
	System.out.println("\nFirst number: " + numOne + "\nSecond number: " + numTwo + "\nResult: " + result + "\n");
	clearAndWait();
    }


    public static void clearAndWait(){
	Scanner s = new Scanner(System.in);
	System.out.println("\nPress enter to continue...");
	s.nextLine();
	System.out.print("\033\143"); 
	calcChoice();
    }

    public static void calcChoice(){
	Scanner scan = new java.util.Scanner(System.in);
	System.out.println("\nChoose your arithmethic method:\n1. Addition\n2. Subtraction\n3. Multiplication\n4. Division\n5. Exit\n");
	try {
	    choice = scan.nextInt();
	}
	catch (Exception e) {
	    System.out.println("\nError: Invalid input! Try again.");
	    clearAndWait();
	}
	if (choice == 5){
	    System.out.println("\nGood Bye.");
	    System.exit(0);
	}
	else{
	    switch (choice){
		case 1:
		case 2:
		case 3:
		case 4:
		    System.out.println("\nChoose your first number: ");
		    numOne = scan.nextDouble();
		    System.out.println("\nChoose your second number: ");
		    numTwo = scan.nextDouble();
		    if (choice == 1){
			result = numOne + numTwo;
			resultingOutput();
		    }
		    else if (choice == 2){
			result = numOne - numTwo;
			resultingOutput();
		    }
		    else if (choice == 3){
			result = numOne * numTwo;
			resultingOutput();
		    }
		    else if (choice == 4){
			result = numOne / numTwo;
			resultingOutput();
		    }
		default:
		    System.out.println("\nError: Invalid input! Try again.");
		    clearAndWait();
	    }
	}
    }
}
