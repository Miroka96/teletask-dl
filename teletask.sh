#!/bin/bash

echo "usage: sh teletask.sh <series overview page> [<workingdir (default: tele-task)>]"
echo -n "Username: "
read user
echo -n "Password: "
read -s password
echo

seriespage=$1
loginpage=https://www.tele-task.de/mytt/login/
workingdir=tele-task
if [ "$2" != "" ]
then workingdir=$2
fi

cookie=cookie.txt

mkdir -p  "$workingdir"
cd "$workingdir"
echo "Working Directory: $workingdir"

wget -q --save-cookies $cookie --keep-session-cookies --delete-after --post-data "username=$user&password=$password&remember_me=on" $loginpage
if [ ! -e $cookie ]
then
	echo "no cookie created - login failed"
	exit
fi

# old tele-task format (in case it will ever be used again
# lectures=$(wget -qO - --load-cookies=$cookie "$seriespage" | grep -o "/archive/video/html5/[0-9]*/" | uniq)

lectures=$(wget -qO - --load-cookies=$cookie "$seriespage" | grep -o "/lecture/video/[0-9]*/" | uniq)

for videopage in $lectures
do 
	echo
	echo "html5 videopage found: $videopage"

	videos=$(wget -qO - --load-cookies=$cookie "https://www.tele-task.de${videopage}" | egrep -o "https?://\S*/(video|desktop)\.mp4")

	for video in $videos
	do
		outputfolder=.$(echo "$video" | grep -o "media/\S*\.mp4$" | grep -o "/.*/")
		break
	done

	if [ -e "${outputfolder}lecture.mp4" ]
	then 
		if [ ! -e "${outputfolder}video.mp4" ] && [ ! -e "${outputfolder}desktop.mp4" ]
		then
			echo "lecture.mp4 has already been successfully created"
			continue
		fi
		echo "lecture.mp4 has already been created but maybe not successful - will be overwritten"
	fi
	
	for video in $videos:
	do
		echo "video found: $video"
	done
	echo "videos will be downloaded to: $workingdir/$outputfolder"

	mkdir -p "$outputfolder"

	unset desktopmp4
	unset videomp4
	for video in $videos
	do
		outputfile=.$(echo "$video" | grep -o "media/\S*\.mp4$" | grep -o "/.*/\S*\.mp4")

		echo "$outputfile" | grep "desktop.mp4$" >/dev/null
		if [ $? -eq 0 ]
		then 
			desktopmp4="$outputfile"
		else
			echo "$outputfile" | grep "video.mp4$" >/dev/null
			if [ $? -eq 0 ]
			then 
				videomp4="$outputfile"
			fi
		fi
		if [ -e "$outputfile" ] && [ ! -e "$outputfile.succ" ]
		then
			rm "$outputfile"
		fi
		wget -q --show-progress --no-clobber -O "$outputfile" "$video"
		touch "$outputfile.succ"
	done
	if [ $videomp4 = "" ] || [ $desktopmp4 = "" ]
	then 
		echo "either desktop.mp4 or video.mp4 could not be found - skipping this videopage"
		continue
	fi

	ffmpeg -y -loglevel info -hide_banner -i "$desktopmp4" -i "$videomp4" -c:v copy -c:a copy -strict experimental -map 0:v:0 -map 1:a:0 "${outputfolder}lecture.mp4"
	if [ $? -eq 0 ]
	then
		rm "$desktopmp4"
		rm "$desktopmp4.succ"
		rm "$videomp4"
		rm "$videomp4.succ"
	fi

done
rm $cookie
