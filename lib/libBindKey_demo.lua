-- title:   libBindKey_demo
-- author:  Kozova1
-- desc:    short description
-- site:    https://github.com/Kozova1/TIC80-Lua-Libs/blob/master/libBindKey/libBindKeyMini.lua
-- license: MIT License
-- version:
-- script:  lua

-- VARIABLES
t = 0
player = {
  x = 96,
  y = 24
}

-- LIBRARYS
BINDS={}function BINDS:bind(a,b,c,d)if c==nil then c=false else assert(type(c)=="boolean","isContinuous must be nil or a boolean")end;if d==nil then d=false else assert(type(d)=="boolean","isKeyboard must be nil or a boolean")end;assert(a~=nil and b~=nil,"keyCode and func must not be nil")assert(type(a)=="number","keyCode must be a number")assert(type(b)=="function","func must be a function")assert(a%1==0 and a>=0,"keyCode must be a positive integer")table.insert(self,{key=a,exec=b,onKeyboard=d,isContinuous=c})end;function BINDS:loop()for e,f in ipairs(self)do if f.onKeyboard then if f.isContinuous then if key(f.key)then f.exec()end else if keyp(f.key)then f.exec()end end else if f.isContinuous then if btn(f.key)then f.exec()end else if btnp(f.key)then f.exec()end end end end end

-- FUNCTIONS
function player:move_up()
  player.y = player.y - 1
end

function player:move_down()
  player.y = player.y + 1
end

function player:move_left()
  player.x = player.x - 1
end

function player:move_right()
  player.x = player.x + 1
end

-- STARTUP
function BOOT()
  -- Put your bootup code here
  BINDS:bind(0, player.move_up, true, false)
  BINDS:bind(1, player.move_down, true, false)
  BINDS:bind(2, player.move_left, true, false)
  BINDS:bind(3, player.move_right, true, false)
end

-- GAMELOOP
function TIC()
  BINDS:loop()

  cls(13)
  spr(1 + t % 60 // 30 * 2, player.x, player.y, 14, 3, 0, 0, 2, 2)
  t = t + 1
end
