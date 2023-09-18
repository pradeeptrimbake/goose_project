#powershell.exe -ExecutionPolicy Unrestricted
$InTime = @()
$Duration = @()
$OutName = @()

# $filenames = "1","2", "3", "4", "5","6","7"
$ifilepath = "F:\20220808\"
$ofilepath = "F:\20220808\"
$filename = "boat_session_6165.mp4"
$extension = ".mp4"

Import-Csv C:\Users\labgrprattenborg\Desktop\Pradeep\code\chopping_scripts\chunks.csv |`
    ForEach-Object {
        $InTime += $_.Start_Time
        $Duration += $_.diff
        $OutName += $_.output
}


For(($i=0); $i -le $InTime.Length;){
    For(($j=0); $j -le $Duration.Length;){
        For(($o=0); $o -le $OutName.Length;){
            #Convert using ffmpeg
            # ffmpeg -i $filepath$file$extension -codec:v libtheora -qscale:v 7 -codec:a libvorbis -qscale:a 5 $filepath$file.ogv
            $k=$InTime[$i++]
            $l=$Duration[$j++]
            $m=$OutName[$o++]
            if ($l -gt 20.04) {
                ffmpeg -ss $k -i $ifilepath$filename -t $l -c copy $ofilepath$m$extension}
         }
     }
}

