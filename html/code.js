window.onload = function() {

//alert("Working");
console.log("AWS Taschenrechner geladen!")

var select = document.getElementById('endpoint');

config.forEach(function(item) {
    var option = document.createElement('option');
    option.value = item.value;
    option.text = item.name;
    select.appendChild(option);    
});

formats = [
	
	{name:'Dezimal', value:'DEC'},
	{name:'Hexadezimal', value:'HEX'},
	{name:'Binaer', value:'BIN'},
	{name:'Octadezimal', value:'OCT'}

];

var format_picker = document.getElementById('format');
formats.forEach(function(item) {
    var option = document.createElement('option');
    option.value = item.value;
    option.text = item.name;
    format_picker.appendChild(option);    
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
  x: document.getElementById('x').value,
  y: document.getElementById('y').value,
  operation: document.getElementById('operator').value,
  format: document.getElementById('format').value
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
  .then(data => {document.getElementById('Ergebnis').innerHTML="= "+data;}) 
  .catch(error => {document.getElementById('errors').innerHTML=error+"&#128530;";});
}
