#powershell.exe -ExecutionPolicy Unrestricted
$InName = @()
$OutName = @()

# $filenames = "1","2", "3", "4", "5","6","7"
$ifilepath = "Z:\NiR_SwimAviary_2022-08-08\"
$ofilepath = "F:\20220808\"
$extension = ".mp4"

Import-Csv F:\20220808\trial.csv |`
    ForEach-Object {
        $InName += $_.InName
        $OutName += $_.OutName
}

# $my = Import-Csv F:\20220808\trial.csv 
     
        
# $filenames = "1","2", "3", "4", "5","6","7"
#$ifilepath = "Z:\NiR_SwimAviary_2022-08-08\"
#$ofilepath = "F:\20220808\"
#$extension = ".mp4"

For(($i=0); $i -le $InName.Length;){
    For(($j=0); $j -le $OutName.Length;){
        #Convert using ffmpeg
        # ffmpeg -i $filepath$file$extension -codec:v libtheora -qscale:v 7 -codec:a libvorbis -qscale:a 5 $filepath$file.ogv
        $k=$InName[$i++]
        $l=$OutName[$j++]
        ffmpeg -ss 08:00:00 -i $ifilepath$k -t 00:00:30 -c copy $ofilepath$l
    }

}

