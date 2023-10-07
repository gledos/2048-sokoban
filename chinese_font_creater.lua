-- title:   chinese font creater
-- author:  gledos <cngledos@gmail.com>
-- desc:
-- site:    website link
-- license:
-- version: 0.1
-- script:  lua

-- VARIABLES
kanji_data = {
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0}
}

kanji = { -- https://littlelimit.net/misaki.htm     7px font
  ["国"] = "FEBA92BA96BAFE", -- misaki
  ["産"] = "10FE247E5C48BE", -- misaki
  ["洋"] = "943E881C88BE88", -- misaki
  ["免"] = "38C87C547C2ACE", -- JiZhi-bitmap-8.bdf
  ["费"] = "28FE2AFEC454EE", -- JiZhi-bitmap-8.bdf
  ["开"] = "FE2424FE2424C4", -- JiZhi-bitmap-8.bdf
  ["源"] = "BE24AE2EA4B6CC", -- JiZhi-bitmap-8.bdf
  ["的"] = "48EEB2EAAAA2E6", -- JiZhi-bitmap-8.bdf
  ["奇"] = "107C287E24542C", -- gledos
  ["幻"] = "202EC2522252F4", -- JiZhi-bitmap-8.bdf
  ["计"] = "4404DE44446444", -- JiZhi-bitmap-8.bdf
  ["算"] = "486EB47C44FE48", -- JiZhi-bitmap-8.bdf
  ["机"] = "5CF454F4D45466", -- JiZhi-bitmap-8.bdf
  ["神"] = "48FE2A7EEA7E48", -- JiZhi-bitmap-8.bdf
  ["9152"] = "485EDEDA7E48B6",
  ["64B2"] = "6AFE547EDC48F6",
  ["79E1"] = "EA5EE84AEAD44A",
  ["test"] = "00000000000000"
}

h2b_table = {
  ["0"] = "0000", ["1"] = "0001", ["2"] = "0010", ["3"] = "0011",
  ["4"] = "0100", ["5"] = "0101", ["6"] = "0110", ["7"] = "0111",
  ["8"] = "1000", ["9"] = "1001", ["A"] = "1010", ["B"] = "1011",
  ["C"] = "1100", ["D"] = "1101", ["E"] = "1110", ["F"] = "1111"
}

-- FUNCTIONS
local function draw()
  for i = 1, 7, 1 do
    for j = 1, 7, 1 do
      -- trace("test", 15) -- dev log
      if kanji_data[i][j] == 1 then
        rect((j - 1) * 10 + 5, (i - 1) * 10 + 5, 9, 9, 5)
        pix(j + 80, i + 5, 5)                             -- 1x
        rect((j - 1) * 2 + 80, (i - 1) * 2 + 15, 2, 2, 5) -- 2x
      end
    end
  end
end

function binary_to_hex(binary_array) -- Poe
  local binary_string = ""
  local hex_string = ""

  for i, row in ipairs(binary_array) do
    for j, value in ipairs(row) do
      binary_string = binary_string .. value
    end
  end

  for i = 1, #binary_string, 4 do
    local binary_chunk = string.sub(binary_string, i, i + 3)
    local decimal_value = tonumber(binary_chunk, 2)
    local hex_value = string.format("%X", decimal_value)
    hex_string = hex_string .. hex_value
  end

  return hex_string
end

function hex2binary(hex) -- https://love2d.org/forums/viewtopic.php?t=84988&start=10 （ivan）
  return hex:upper():gsub(".", h2b_table)
end

function split_string_to_char_array(str) -- 将中英混合的字符串切分为单个字符组成的数组（Poe 生成的代码）
  local char_array = {}  -- 存储切分后的字符数组
  local index = 1  -- 当前字符在字符串中的索引

  while index <= #str do
    local byte = string.byte(str, index)  -- 获取当前字符的 ASCII 值

    if byte >= 0xC0 and byte <= 0xFD then
      -- 当前字符是多字节 UTF-8 字符
      local char_bytes = {string.byte(str, index, index + utf8_char_bytes(byte) - 1)}
      local char = string.char(table.unpack(char_bytes))
      table.insert(char_array, char)
      index = index + utf8_char_bytes(byte)
    else
      -- 当前字符是单字节 ASCII 字符
      local char = string.sub(str, index, index)
      table.insert(char_array, char)
      index = index + 1
    end
  end

  return char_array
end

-- 辅助函数：根据首字节获取 UTF-8 字符的字节数
function utf8_char_bytes(byte)
  if byte >= 0xC0 and byte <= 0xDF then
    return 2
  elseif byte >= 0xE0 and byte <= 0xEF then
    return 3
  elseif byte >= 0xF0 and byte <= 0xF7 then
    return 4
  elseif byte >= 0xF8 and byte <= 0xFB then
    return 5
  elseif byte >= 0xFC and byte <= 0xFD then
    return 6
  end
  return 1  -- 默认为单字节字符
end

function draw_kanji(character, x, y)
  local binary = hex2binary(kanji[character])

  for i = 1, 7, 1 do
    for j = 1, 8, 1 do
      -- trace("test", 15) -- dev log
      if string.sub(binary, (i - 1) * 8 + j, (i - 1) * 8 + j) == "1"
      then
        pix(j + x, i + y, 5)
      end
    end
  end
end

function draw_kanji_line(paragraph, x, y)
  for i = 1, #split_string_to_char_array(paragraph), 1 do
    -- trace("test"..i, 15) -- dev log
    draw_kanji(split_string_to_char_array(paragraph)[i], (i - 1) * 8 + x, y)
  end
end

BINDS={}function BINDS:bind(a,b,c,d)if c==nil then c=false else assert(type(c)=="boolean","isContinuous must be nil or a boolean")end;if d==nil then d=false else assert(type(d)=="boolean","isKeyboard must be nil or a boolean")end;assert(a~=nil and b~=nil,"keyCode and func must not be nil")assert(type(a)=="number","keyCode must be a number")assert(type(b)=="function","func must be a function")assert(a%1==0 and a>=0,"keyCode must be a positive integer")table.insert(self,{key=a,exec=b,onKeyboard=d,isContinuous=c})end;function BINDS:loop()for e,f in ipairs(self)do if f.onKeyboard then if f.isContinuous then if key(f.key)then f.exec()end else if keyp(f.key)then f.exec()end end else if f.isContinuous then if btn(f.key)then f.exec()end else if btnp(f.key)then f.exec()end end end end end
-- https://github.com/Kozova1/TIC80-Lua-Libs/blob/master/libBindKey/libBindKeyMini.lua



-- GAMELOOP
function TIC()

  mouse_x, mouse_y, mouse_left, mouse_middle, mouse_right, mouse_scrollx, mouse_scrolly = mouse()

  cls(15)
  draw()
  rectb(3, 3, 73, 73, 12) -- 框体

  if mouse_left and mouse_x > 4 and mouse_x <= 72 and mouse_y > 4 and mouse_y <= 72 then
    kanji_data[(mouse_y + 5)//10][(mouse_x + 5)//10] = 1
  end

  if mouse_right and mouse_x > 4 and mouse_x <= 72 and mouse_y > 4 and mouse_y <= 72 then
    kanji_data[(mouse_y + 5)//10][(mouse_x + 5)//10] = 0
  end

  kanji["test"] = binary_to_hex(kanji_data)
  print(binary_to_hex(kanji_data), 100, 7, 12)

  draw_kanji_line("免费开源", 80, 60)
  draw_kanji("test", 112, 60)
  draw_kanji_line("的奇幻计算机", 120, 60)

  if btn(4) then
    trace(binary_to_hex(kanji_data), 15)
    exit()
  end
end
