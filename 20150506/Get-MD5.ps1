Function Get-MD5HashCode {
    Param(
        $Path
    )
    $MD5 = new-object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
    $Hash = [System.BitConverter]::ToString($MD5.ComputeHash([System.IO.File]::ReadAllBytes($Path)))
    $Hash
}


Get-MD5HashCode("C:\Temp\1command_Lines_snippets.txt")
Get-MD5HashCode("C:\Temp\2command_Lines_snippets.txt")
