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


var url = document.getElementById('endpoint').value;
console.log("shooting request @aws lambda: "+url);

var select = document.getElementById('endpoint');
var option = select.options[select.selectedIndex].text;
console.log("Option:"+option)


var keys=0;
config.forEach(function(e) {
if (e.name == option) keys = e.keys;
});


data = {
  format: document.getElementById('format').value
};

data[ keys[0] ] =  document.getElementById('x').value;
data[ keys[1] ] =  document.getElementById('y').value;
data[ keys[2] ] =  document.getElementById('operator').value;

console.log("Format: "+ JSON.stringify(data));


var enableCORS = document.getElementById('enable_cors');

if(enableCORS.checked) {
// Define the CORS proxy URL
// https://nordicapis.com/10-free-to-use-cors-proxies/
url = 'https://corsproxy.io/?' + encodeURIComponent(url);
console.log("Using CORS Proxy:"+url);
}

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
  .then(data => {document.getElementById('Ergebnis').innerHTML="= "+ data;}) 
  .catch(error => {document.getElementById('errors').innerHTML=error+"&#128530;";});
}
