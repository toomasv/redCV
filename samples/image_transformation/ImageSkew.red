Red [	Title:   "Rotate image"	Author:  "Francois Jouen"	File: 	 %imageSkew.red	Needs:	 'View]; required libs#include %../../libs/core/rcvCore.red#include %../../libs/matrix/rcvMatrix.red#include %../../libs/tools/rcvTools.red#include %../../libs/imgproc/rcvImgProc.redmargins: 10x10isize: 512x512x: 0y: 0drawBlk: []canvas: noneloadImage: does [	canvas/image: none	drawBlk: []	tmp: request-file	if not none? tmp [		canvas/draw: none		img1: rcvLoadImage tmp		canvas/image: img1		img1: to-image canvas	; force image size to 512x512		iSize: img1/size		centerXY: iSize / 2		canvas/image: none		rot: 0.0		drawBlk: rcvSkewImage 0.5 0x0 x y img1		canvas/draw: drawBlk	]]; ***************** Test Program ****************************view win: layout [		title "Skew Image"		origin margins space margins		button 60 "Load"	[loadImage]		sl1: slider 230		[sz/text: form to integer! face/data * 180 							 if cbx/data [x:  face/data * 180.0 ] [x: 0] drawBlk/7: x							 if cby/data [y:  face/data * 180.0] [y: 0] drawBlk/8: y							 ]		sz: field 30 "0"		text "Degrees"		button 60 "Quit"	[Quit]		return 		cbx: check "Skew X"	    cby: check "Skew Y"		return 		canvas: base iSize black draw drawBlk			do [ sl1/data: 0.0 cbx/data: true]]