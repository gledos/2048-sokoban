-- title:   chinese font preview
-- author:  gledos <cngledos@gmail.com>
-- desc:
-- site:    website link
-- license:
-- version: 0.1
-- script:  lua

-- VARIABLES
kanji = { -- https://littlelimit.net/misaki.htm     7px font
  ["国"] = "FEBA92BA96BAFE", -- 56FD
  ["産"] = "10FE247E5C48BE", -- 7523
  ["洋"] = "943E881C88BE88", -- 6D0B
  ["开"] = "007C287C284800", -- gledos
  ["9152"] = "485EDEDA7E48B6",
  ["64B2"] = "6AFE547EDC48F6",
  ["79E1"] = "EA5EE84AEAD44A"
}

h2b_table = {
  ["0"] = "0000", ["1"] = "0001", ["2"] = "0010", ["3"] = "0011",
  ["4"] = "0100", ["5"] = "0101", ["6"] = "0110", ["7"] = "0111",
  ["8"] = "1000", ["9"] = "1001", ["A"] = "1010", ["B"] = "1011",
  ["C"] = "1100", ["D"] = "1101", ["E"] = "1110", ["F"] = "1111"
}

-- FUNCTIONS
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

-- GAMELOOP
function TIC()
  cls(15)

  -- trace(get_byte_count("国産洋"), 15)

  draw_kanji_line("国産洋国産洋国産洋国産洋国産洋国産洋", 0, 0)

  -- string.sub("国産洋", 1, 1)

  draw_kanji("64B2", 8, 8)
  -- draw_kanji("産", 8, 0)
  -- draw_kanji("洋", 16, 0)
  -- draw_kanji("9152", 24, 0)
  -- draw_kanji("64B2", 32, 0)

end
