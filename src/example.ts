// Example TypeScript file with linting violations

// no-var violations - should use let or const
var name = "Alice";
var age = 25;

// prefer-const violation - never reassigned
let greeting = "Hello";

// eqeqeq violation - using loose equality
if (name == "Alice") {
  console.log(greeting);
}

// no-var and eqeqeq combined
var score = 100;
if (score != 50) {
  console.log("Score is not 50");
}

console.log(name, age, score);
