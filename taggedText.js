<html>
<head>
<style>
.miscue
{
 font-weight: bold;
 color: red;
}
</style>
<script>
var miscues = [0, 4, 7];
// Make this magic happen
var words = document.getElementById(‘passagetext’).innerHTML.split(/ +/);  // Split paragraph value by one or more spaces

// Start building the formatting text.
var formattedtext = ‘’;  
for(var i=0; i<words.length; i++)
{
 // Figure out if current word is a miscue.
 var isMiscue = false;
 for(var j=0; j<miscues.length; j++)
 {
   if(i == miscues[j])
  {  
    isMiscue = true;
    break;
   }
 }

 // If miscue, wrap word with a span that is style with class misue
 if(isMiscue)
 {
   formattedText += ‘<span class=”miscue”>’+words[i]+’</span> ‘;
 }
 else
 {
   formattedText += words[i]+’ ‘;
 }
}

// Put the newly formatted string back into passage
document.getElementById(‘passagetext’).innerHTML = formattedText;
</script>
</head>
<body>

<p id=”passagetext”>This is the first paragraph. This is the second sentence.</p>
</body>
</html>