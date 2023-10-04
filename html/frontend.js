const calculator = document.getElementById('calculator');
const display = document.getElementById('display');
const buttons = [
  '7', '8', '9', '/',
  '4', '5', '6', '*',
  '1', '2', '3', '-',
  '0', '.', '=', '+'
];

let currentRow;

buttons.forEach((button, index) => {
  if (index % 4 === 0) { // Start a new row every 4 buttons
    currentRow = document.createElement('tr');
    calculator.appendChild(currentRow);
  }
  
  const buttonElement = document.createElement('button');
  const cell = document.createElement('td');
  
  buttonElement.textContent = button;
  cell.appendChild(buttonElement);
  currentRow.appendChild(cell);
  
  buttonElement.addEventListener('click', () => {
    // Handle button click
    console.log(button);
  });
});

