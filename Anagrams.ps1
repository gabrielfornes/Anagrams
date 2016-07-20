$web = Invoke-WebRequest -Uri 'http://anagram-solver.net/gabriel' -Method Get
$web = $web.Links

$PattersToDiscard = 'http://crossword-solver.org', 'http://anagram-solver.net/', 'http://itunes.apple.com/', 'mailto:anagrams@utsire.com', 'http://www.gnu.org/copyleft/fdl.html', 'http://en.wikipedia.org/wiki/Wikipedia', 'http://twitter.com/share', 'partial=1">Click here</A>'


$AllAnagrams = @()
$AllLinks = @()

foreach ( $item in $web )
{
  
  $String = $PattersToDiscard | ForEach-Object { Select-String -InputObject $item -Pattern $_ }
  if ($String.Pattern -eq $null)
  {  
    $ParseText = ((((($item -split '@{innerHTML=')[1]) -split ';') -split 'href=') -replace '}').Trim()
    $Anagram = $ParseText[0]
    $Link = $ParseText[7]
    
    $AllAnagrams += $Anagram
    $AllLinks += $Link
  }
  
}

do
{
  $NumOK         = $true
  Clear-Host

  Write-Output 'All the anagrams of ""'
  for ($i = 0; $i -lt ($AllAnagrams.Count); $i++)
  {
    Write-Output "$i : $($AllAnagrams[$i])"
  }
  try
  {
    [int]$Choice = Read-Host 'Which word do you want to open?(write a number)'
  }
  catch
  {
    $NumOK = $false
  }
  
  

  $DefaultBrower = Get-Item 'HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice' | Out-String
  $DefaultBrower = ($DefaultBrower -split 'Progid :').Trim()[1]

  Write-Output "http://anagram-solver.net$($AllLinks[$Choice])"
  if ($DefaultBrower -eq 'ChromeHTML')
  {
    Start-Process Chrome "http://anagram-solver.net$($AllLinks[$Choice])"    
  }

  elseif ($DefaultBrower -eq 'FirefoxURL')
  {
    Start-Process firefox "http://anagram-solver.net$($AllLinks[$Choice])"
  }

  else 
  {
    Start-Process -PSPath 'C:\Program Files\Internet Explorer\iexplore.exe' "http://anagram-solver.net$($AllLinks[$Choice])"
  }
  
}
until (($Choice -lt ($AllAnagrams.Count) -and $NumOK))