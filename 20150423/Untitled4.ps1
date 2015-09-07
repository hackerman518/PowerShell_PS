Get-WmiObject -Class $classname -ComputerName $computer -Namespace $namespace |
    Select-Object * -ExcludeProperty PSComputerName, Scope, Path, Options, ClassPath, Properties, SystemProperties, Qualifiers, Site, Container |
    Format-List -Property [a-z]*
