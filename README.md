# Teletask Downloader
A Linux CLI-Script for downloading Tele-Task Playlists with
- session support (wget) - you have to enter tele-task credentials to access protected content
- automatic merging of slides and tutor's voice (ffmpeg)
- automatic link grabbing out of playlists (grep with many RegEx)

## Tele-Task
https://www.tele-task.de/

Online Lessons, recorded at Hasso-Plattner Institute Potsdam (Germany)

## Usage
sh teletask.sh <series overview page> [<workingdir (default: tele-task)>]

make the file executable by: chmod +x teletask.sh
after that, call it through ./teletask.sh

workingdirectory parameter is fully optional

## Templates
- Operating Systems 1 (german) WT 16/17 - see bs1
- Operating Systems 2 (german) ST 17 - see bs2
- Big Data Analytics (german) WT 16/17 - see bigdata
- Internet Security: Weaknesses and Targets (english) WT 16/17 - see isec
- Prozessorientierte Informationssysteme - see pois (with new URL schema)

## Update of Oktober 2017
Former Tele-Task Beta goes public. Old URLs remain working, they will be redirected. The URL schema had had to be adapted.

## Restrictions
Please do not host the videos anywhere else publicly reachable (there might be copyright laws)
