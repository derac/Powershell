# quick and dirty ~20 minute script to parse out the youtube links from a saved facebook wall. (right click save as...)

# autoscroll fb page - run this in the address bar (or dev tools) - chrome removes the javascript: part for some reason when pasted in the address bar, so you have to retype it
#javascript:var scroll_interval = window.setInterval(sroll_down, 1000);function sroll_down(){window.scrollTo(0,document.body.scrollHeight);}
#javascript:window.clearInterval(scroll_interval, 1000)

# youtube link examples
#https://l.facebook.com/l.php?u=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3D9TMLD9qhT6g%26feature%3Dshare%26fbclid%3DIwAR0zfSjHFYt3kDPVysdrQlByyhNvlIMGM2aV6bDqD2Z2EGwGraGgHSlLgBY&amp;h=AT3cAKHCRUkgzPOeUiLH-h459DPSDmiTo3ahtA92kiWOEgn1bSCrwk8qbarTj3nx33tzKCshHpu6VoHn_ERafa_89s40ZWWsBuKQrPQI6Uh3a2s3QvdkPpaIN46XOs9ty1tdFv-tvw
#https://l.facebook.com/l.php?u=https%3A%2F%2Fyoutu.be%2Fu_Q7oCy9-yQ%3Ffbclid%3DIwAR2cqc8xtwvVMrDrChk6xx2uQkOPIsFASoA_3cRcP2OiEC2Ut2h-m07VOcI&amp;h=AT3yZ2qN2oDbQdvHr1yT57LAJjkRBq8V-4F7TH_QFWNBAhO13JWsu7CRbldKLt3MPicGWkiddf_by5nYM25ShxaCUlByIO2lDSl6fXISxhbIRSgmBbG13pAU6W4-rJxhkgMKGqeHpA

#put the path to your facebook page output here
$split_file = ".\Firstname Lastname.html"
$importPath = "C:\temp\split.html"
$playlist_out_file = ".\playlist.txt"

(Get-Content $split_file) -replace ("<","`r`n") | Set-Content $importPath 

$pattern = "be%2F(.*?)%3Ffb"
$pattern2 = "v%3D(.*?)%"

$file = Get-Content $importPath

$playlist_start = "http://www.youtube.com/watch_videos?video_ids="
$playlist_array = @()

# output playlist
foreach ($line in $file) {
    $result = ([regex]::match($line, $pattern).Groups[1].Value)
    if ($result) {
        $playlist_array += $result
    }
    $result = ([regex]::match($line, $pattern2).Groups[1].Value)
    if ($result) {
        $playlist_array += $result
    }
}

$playlist_array = $playlist_array | sort -Unique

# playlists can only have 50 entries
$c = 0
$playlist = $playlist_start
foreach ($v in $playlist_array) {
    if ($v.Length -eq 11) {
        $c += 1
        $playlist += $v + ","
    }
    if ($c -eq 50) {
        $playlist += "`r`n$playlist_start"
        $c = 0
    }
}

$playlist | Out-File $playlist_out_file