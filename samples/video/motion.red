Red [
	Title:   "Test image operators and camera Red VID "
	Author:  "Francois Jouen"
	File: 	 %motion.red
	Needs:	 'View
]

{Based on
Collins, R., Lipton, A., Kanade, T., Fijiyoshi, H., Duggins, D., Tsin, Y., Tolliver, D., Enomoto,
N., Hasegawa, O., Burt, P., Wixson, L.: A system for video surveillance and monitoring. Tech.
rep., Carnegie Mellon University, Pittsburg, PA (2000)}


; required libs
#include %../../libs/tools/rcvTools.red
#include %../../libs/core/rcvCore.red
#include %../../libs/math/rcvStats.red	
#include %../../libs/imgproc/rcvImgProc.red

iSize: 320x240
prevImg: rcvCreateImage iSize
currImg: rcvCreateImage iSize
nextImg: rcvCreateImage iSize
d1: rcvCreateImage iSize
d2: rcvCreateImage iSize
r1: rcvCreateImage iSize
r2: rcvCreateImage iSize


margins: 10x10
threshold: 32
cam: none ; for camera object

to-text: function [val][form to integer! 0.5 + 128 * any [val 0]]


processCam: does [
	rcv2gray/average nextImg currImg	; transforms to grayscale since, we don't need color
	rcvAbsdiff  prevImg currImg d1		; difference between previous and current image
	rcvAbsdiff  currImg nextImg d2		; difference between current and next image
	rcvAnd d1 d2 r1						; AND differences
	rcv2BWFilter r1 r2 threshold 		; Applies B&W Filter to ANDed image
	prevImg: currImg					; previous image contains now the current image
	currImg: nextImg					; current image contains the next image				
	camImg: cam/image					; should work in red future version
	nextImg: rcvResizeImage camImg iSize; resize camera image ;cam/image
	; Gaussian blurring
	rcvGaussianFilter nextImg nextImg 3x3 1.0
	cam/image: none						; it's works				
	recycle
]



view win: layout [
		title "Motion Detection"
		origin margins space margins
		text "Motion " 50 
		motion: field 70 rate 0:0:1 on-time [
			z: rcvCountNonZero r2
			face/text: form z
		]
		text "Camera Size" 
		cSize: field 80
		onoff: button "Start/Stop" 85 on-click [
				either cam/selected [
					cam/selected: none
					canvas/rate: none
					motion/rate: none
					canvas/image: black
				][
					cam/selected: cam-list/selected
					camImg: to-image cam
					currImg: rcvResizeImage camImg iSize; 
					prevImg: rcvCreateImage iSize 
					nextImg: rcvCreateImage iSize
					d1: rcvCreateImage iSize
					d2: rcvCreateImage iSize
					r1: rcvCreateImage iSize
					r2: rcvCreateImage iSize
					canvas/image: r2
					canvas/rate: 0:0:0.04;  max 1/25 fps in ms
					motion/rate: 0:0:0.04
					cSize/text: form currImg/size
					]
			]
		pad 160x0
		btnQuit: button "Quit" 60x24 on-click [
			rcvReleaseImage prevImg
            rcvReleaseImage currImg
            rcvReleaseImage nextImg
            rcvReleaseImage d1
            rcvReleaseImage d2
            rcvReleaseImage r1
            rcvReleaseImage r2
			quit]
		return
		cam: camera iSize
		canvas: base iSize rate 0:0:1 on-time [processCam]
		return
		text 40 "Select" 
		cam-list: drop-list 270 on-create [face/data: cam/data]
		text "Threshold" 60
		sl1: slider 200 [filter/text: to-text sl1/data threshold: to integer! filter/data]
		filter: field 35 "32" 
		do [cam-list/selected: 1 motion/rate: canvas/rate: none sl1/data: 0.32 ]
]
	
	


