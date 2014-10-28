﻿#NoEnv

#Include %A_ScriptDir%\Yunit\Yunit.ahk
#Include %A_ScriptDir%\Yunit\Window.ahk
#Include %A_ScriptDir%\Yunit\StdOut.ahk
#include lib\Windy\Mony.ahk
#include lib\Windy\Recty.ahk

#Warn All
;#Warn LocalSameAsGlobal, Off
#SingleInstance force


ReferenceVersion := "0.2.4"
debug := 1

Yunit.Use(YunitStdOut, YunitWindow).Test(_BaseTestSuite, MonyTestSuite)
Return

ExitApp

class MonyTestSuite2
{
	Begin() {
		Global debug
		this.obj := new Mony(debug)
		this.monCount := 2
		this.mon1Width := 1920
		this.mon1Height := 1080
		this.mon2Width := 1600
		this.mon2Height := 1200
		
		this.monvirtWidth := this.mon1Width + this.mon2Width
		this.monvirtHeight := this.mon2Height
    }

    CoordTrans() {
		x := this.obj.monCoordAbsToRel(10,10)
		Yunit.assert(x.monID == 1)
		Yunit.assert(x.x == 10)
		Yunit.assert(x.y == 10)
    	x := this.obj.monCoordAbsToRel(1930,10)
		Yunit.assert(x.monID == 2)
		Yunit.assert(x.x == 10)
		Yunit.assert(x.y == 10)
		y := this.obj.monCoordRelToAbs(1, 10, 10)
		Yunit.assert(y.x == 10)
		Yunit.assert(y.y == 10)
		y := this.obj.monCoordRelToAbs(2, 10, 10)
		Yunit.assert(y.x == 1930)
		Yunit.assert(y.y == 10)
    	return
    }

	End()  {
        this.remove("obj")
		this.obj := 
    }
}

class MonyTestSuite
{
	Begin() {
		Global debug
		this.obj := new Mony(debug)
		this.monCount := 2
		this.mon1Width := 1920
		this.mon1Height := 1080
		this.mon2Width := 1600
		this.mon2Height := 1200
		
		this.monvirtWidth := this.mon1Width + this.mon2Width
		this.monvirtHeight := this.mon2Height
    }

    identify(){
    	this.obj.identify(250,"00FF00",400)
    }
		
	VirtualScreenSize() {
		rect := this.obj.virtualScreenSize()
		rectMon2 := this.obj.monBoundary(2)
		Yunit.assert(rect.x == 0)
		Yunit.assert(rect.y == 0)
		Yunit.assert(rect.w == this.monvirtWidth)
		Yunit.assert(rectMon2.w == this.monvirtWidth)
		Yunit.assert(rect.h == this.monvirtHeight)
		Yunit.assert(rectMon2.h == this.monvirtHeight)
	}

    CoordTrans() {
		x := this.obj.monCoordAbsToRel(10,10)
		Yunit.assert(x.monID == 1)
		Yunit.assert(x.x == 10)
		Yunit.assert(x.y == 10)
    	x := this.obj.monCoordAbsToRel(1930,10)
		Yunit.assert(x.monID == 2)
		Yunit.assert(x.x == 10)
		Yunit.assert(x.y == 10)
		y := this.obj.monCoordRelToAbs(1, 10, 10)
		Yunit.assert(y.x == 10)
		Yunit.assert(y.y == 10)
		y := this.obj.monCoordRelToAbs(2, 10, 10)
		Yunit.assert(y.x == 1930)
		Yunit.assert(y.y == 10)
    	return
    }
	
	MonCount() {
		Yunit.assert(this.obj.monCount == this.monCount)
	}

	MonGetFromMouse() {	
		MouseGetPos,x_back,y_back 
		MouseMove,10,10
		mon := this.obj.monGetFromMouse()
		Yunit.assert(mon == 1)
		rect := this.obj.monSize(1)
		MouseMove,rect.w+10,10
		mon := this.obj.monGetFromMouse()
		Yunit.assert(mon == 2)
		MouseMove,x_back, y_back
	}

	MonGetFromCoord() {
		mon := this.obj.monGetFromCoord(10,10)
		Yunit.assert(mon == 1)
		rect := this.obj.monSize(1)
		mon := this.obj.monGetFromCoord(rect.w+10,10)
		Yunit.assert(mon == 2)
	}
	
	MonSize() {
		rect := this.obj.monSize(1)
		Yunit.assert(rect.w == this.mon1Width)
		Yunit.assert(rect.h == this.mon1Height)	
		rect := this.obj.monSize(2)
		Yunit.assert(rect.w == this.mon2Width)
		Yunit.assert(rect.h == this.mon2Height)
	}
	
	MonBoundary() {
		rect1 := this.obj.monBoundary(1)
		Yunit.assert(rect1.w == this.mon1Width)
		Yunit.assert(rect1.h == this.mon1Height)	
		rect2 := this.obj.monBoundary(2)
		Yunit.assert(rect2.x == rect1.w)
		Yunit.assert(rect2.y == rect2.y)
		Yunit.assert(rect2.w == rect1.w + this.mon2Width)
		Yunit.assert(rect2.h == this.mon2Height)
	}

	MonCenter() {
		pt1 := this.obj.monCenter(1)
		Yunit.assert(pt1.x == this.mon1Width/2)
		Yunit.assert(pt1.y == this.mon1Height/2)
		pt2 := this.obj.monCenter(2)
		Yunit.assert(pt2.x == (this.mon1Width+(this.mon2Width/2)))
		Yunit.assert(pt2.y == this.mon2Height/2)
	}
	
	MonNextPrev() {
		monNxt := this.obj.monNext(1)
		Yunit.assert(monNxt == 2)
		monNxt := this.obj.monNext(this.monCount, 0)
		Yunit.assert(monNxt == this.monCount)
		monNxt := this.obj.monNext(this.monCount, 1)
		Yunit.assert(monNxt == 1)
		
		monPrv := this.obj.monPrev(2)
		Yunit.assert(monPrv == 1)
		monPrv := this.obj.monPrev(1, 0)
		Yunit.assert(monPrv == 1)
		monPrv := this.obj.monPrev(1, 1)
		Yunit.assert(monPrv == this.monCount)
	}

	MonScale() {
		Yunit.assert(this.obj.monScaleX(1,1) == 1)
		Yunit.assert(this.obj.monScaleY(1,1) == 1)
		Yunit.assert(this.obj.monScaleX(2,2) == 1)
		Yunit.assert(this.obj.monScaleY(2,2) == 1)
	}
		    		
	End() {
        this.remove("obj")
		this.obj := 
    }
}

class _BaseTestSuite {
    Begin() {
		Global debug
		this.obj := new Mony(debug)
	}
	
	Version() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		Global ReferenceVersion
		Yunit.assert(this.obj._version == ReferenceVersion)
		OutputDebug % ">>>>[" A_ThisFunc "]>>>>"
	}

	End() {
		this.remove("obj")
		this.obj := 
	}
}