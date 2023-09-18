#powershell.exe -ExecutionPolicy Unrestricted
$detfile = @()
$Sfilepath = @()
$Sfile = @()
conda activate obj
Import-Csv C:\Users\labgrprattenborg\Desktop\Pradeep\code\obj_det\yolov5\batchdetect_chunks.csv |`
    ForEach-Object {
        $detfile += $_.detfile
        $Sfilepath += $_.filepath
        $Sfile += $_.source
}

# $filenames = "1","2", "3", "4", "5","6","7"
#$ifilepath = "E:\remove_stillness\"
$detfilepath = "C:\Users\labgrprattenborg\Desktop\Pradeep\code\obj_det\yolov5\"
$extension1 = ".py"
$extension2 = ".mp4"
$ext3 = ".csv"

###### For single folder
#ForEach($det in $detfile){
#    ForEach($source in $Sfile){
        #Convert using ffmpeg
        # ffmpeg -i $filepath$file$extension -codec:v libtheora -qscale:v 7 -codec:a libvorbis -qscale:a 5 $filepath$file.ogv
        # ffmpeg -ss 08:00:00 -i $ifilepath$ifile$extension -t 4:00:00 -c copy $ofilepath$ofile$extension
#        python $detfilepath$det$extension1 --weights yolov5s.engine --source $ifilepath$source$extension2 --device 0 --save-txt --nosave
#        Rename-Item -Path "C:\Users\labgrprattenborg\Desktop\Pradeep\code\obj_det\yolov5\log_file.csv" -NewName $source$ext3
#    }  
#}


#####For multiple folders #####
ForEach($det in $detfile){
    For(($i=0); $i -le $Sfilepath.Length;){
        For(($j=0); $j -le $Sfile.Length;){
        #Convert using ffmpeg
        # ffmpeg -i $filepath$file$extension -codec:v libtheora -qscale:v 7 -codec:a libvorbis -qscale:a 5 $filepath$file.ogv
            $k=$Sfilepath[$i++]
            $l=$Sfile[$j++]
            python $detfilepath$det$extension1 --weights yolov5s.engine --source $k$l$extension2 --device 0 --save-txt --nosave
            Rename-Item -Path "C:\Users\labgrprattenborg\Desktop\Pradeep\code\obj_det\yolov5\log_file.csv" -NewName $l$ext3
            Start-Sleep -Seconds 1.5
        }

    }
}