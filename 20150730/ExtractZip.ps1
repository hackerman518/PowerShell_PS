How to Extract ZIP Files Using PowerShell

We have seen this question asked numerous times on Stack Overflow and forums alike but most of the time people recommend using the PowerShell Community Extensions or a legacy command line application. Truth be told, its not actually all that hard to do in PowerShell.

$shell = new-object -com shell.application
$zip = $shell.NameSpace(“C:\howtogeeksite.zip”)

foreach($item in $zip.items())
{
    $shell.Namespace(“C:\temp\howtogeek”).copyhere($item)
}

Hardcoding values isn’t really ideal so lets make it into a quick function.

function Expand-ZIPFile($file, $destination)
{
$shell = new-object -com shell.application
$zip = $shell.NameSpace($file)
foreach($item in $zip.items())
{
$shell.Namespace($destination).copyhere($item)
}
}

Then we can simply use the function like this:

Expand-ZIPFile –File “C:\howtogeeksite.zip” –Destination “C:\temp\howtogeek”

Remember to add this  to your Windows PowerShell profile, so that you don’t need third-party libraries for functionality that is already included out of the box.
