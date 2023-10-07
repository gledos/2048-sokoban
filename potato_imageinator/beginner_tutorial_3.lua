-- title:   TIC-80 Beginner Tutorial #3 - rect() and rectb() Functions
-- author:  Potato Imaginator
--[[
  desc:     rect() and rectb() Functions In this video ,
  I show how to use rect() and rectb() functions for
  filled rectangles and rectangles with border respectively

  NOTE: a%b is modulo operator ( Remainder of 'a' when divided by 'b' )
]]
-- site:    https://www.youtube.com/watch?v=E0ur_EQdMfs
-- license:
-- version:
-- script:  lua

-- VARIABLES


-- LIBRARYS
BINDS={}function BINDS:bind(a,b,c,d)if c==nil then c=false else assert(type(c)=="boolean","isContinuous must be nil or a boolean")end;if d==nil then d=false else assert(type(d)=="boolean","isKeyboard must be nil or a boolean")end;assert(a~=nil and b~=nil,"keyCode and func must not be nil")assert(type(a)=="number","keyCode must be a number")assert(type(b)=="function","func must be a function")assert(a%1==0 and a>=0,"keyCode must be a positive integer")table.insert(self,{key=a,exec=b,onKeyboard=d,isContinuous=c})end;function BINDS:loop()for e,f in ipairs(self)do if f.onKeyboard then if f.isContinuous then if key(f.key)then f.exec()end else if keyp(f.key)then f.exec()end end else if f.isContinuous then if btn(f.key)then f.exec()end else if btnp(f.key)then f.exec()end end end end end

-- FUNCTIONS


-- STARTUP
function BOOT()
  -- Put your bootup code here

end

-- GAMELOOP
function TIC()
  -- # Code inside TIC() runs ~60 times per second.
  -- Handle inputs, update game state

  cls() -- Clear the screen
  -- Render graphics, characters, objects, backgrounds, etc.
end
