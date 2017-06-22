Red [
	Title:   "Gaussian Filter tests "
	Author:  "Francois Jouen"
	File: 	 %Gaussian2.red
	Needs:	 'View
]


; last Red Master required!
#include %../../libs/redcv.red ; for redCV functions
margins: 10x10
img1: rcvLoadImage %../../images/baboon.jpg
dst:  rcvCreateImage img1/size


; ***************** Test Program ****************************
view win: layout [
		title "Gaussian Filter"
		origin margins space margins
		button 60 "Source" 		[rcvCopyImage img1 dst]	
		button 50 "3x3" 	   	[knl: rcvMakeGaussian 3x3 rcvFilter2D img1 dst knl 0] 
		button 50 "5x5" 		[knl: rcvMakeGaussian 5x5 rcvFilter2D img1 dst knl 0]
		button 50 "7x7"  		[knl: rcvMakeGaussian 7x7 rcvFilter2D img1 dst knl 0]
		button 50 "9x9"  		[knl: rcvMakeGaussian 9x9 rcvFilter2D img1 dst knl 0]
		button 60 "11x11"  		[knl: rcvMakeGaussian 11x11 rcvFilter2D img1 dst knl 0]
		button 60 "Quit" 		[rcvReleaseImage img1 rcvReleaseImage dst Quit]
		return 
		canvas: base 512x512 dst	
		do [rcvCopyImage img1 dst]
]
