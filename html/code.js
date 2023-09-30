window.onload = function() {

//alert("Working");
console.log("AWS Taschenrechner geladen!")

// Profile für Lambda Funcs
/*
config = [
{name: "Boris", value:"https://9vr1h31s14.execute-api.eu-central-1.amazonaws.com/default/calcuply", key1:'x',key2:'y'},

{name: "Benny", value:"https://buk7qq6u09.execute-api.eu-central-1.amazoname.com/default/taschenrechner",key1:"p_1",key2:"p_2"}
];
*/

var select = document.getElementById('endpoint');

config.forEach(function(item) {
    var option = document.createElement('option');
    option.value = item.value;
    option.text = item.name;
    select.appendChild(option);    
});
}

function shoot() {
document.getElementById('Ergebnis').innerHTML="";
document.getElementById('errors').innerHTML="";


var url = document.getElementById('endpoint').value 
console.log("shooting request @aws lambda: "+url)

//var option = select.options[select.selectedIndex].text;;
//console.log("Option:"+option)

const data = {
  p_1: document.getElementById('x').value,
  p_2: document.getElementById('y').value,
  operation: document.getElementById('operator').value
};

fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(data),
  })
  .then(response => {
    if (!response.ok) {
      return response.text().then(errorText => {
        throw new Error(`Failed with status ${response.status}, ${response.statusText}: ${errorText}`);
      });
    }
    return response.json();
  })
  .then(data => {document.getElementById('Ergebnis').innerHTML=data;}) 
  .catch(error => {document.getElementById('errors').innerHTML=error;});

}
