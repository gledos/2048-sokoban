-- title:   2048 sokoban
-- author:  gledos <cngledos@gmail.com>
-- desc:  2048 + sokoban game, just only 2 level demo game.
-- site:  website link
-- license:
-- version: 0.1
-- script:  lua

-- VARIABLES
-- directions = {
--   {x = 0, y =-1}, -- up
--   {x = 0, y = 1}, -- down
--   {x =-1, y = 0}, -- left
--   {x = 1, y = 0}  -- right
-- }

map_list = {}
map_attribute = {}
map = 1

map_list[1] = { -- demo map
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, -- 0: map wall
  {1, 0, 0, 3, 4, 5, 6, 7, 8, 9,10,11,12, 0, 0, 1}, -- 1: map space
  {1, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, -- 2: null
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, -- 3: cube 2
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, -- 4: cube 4
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, -- 5: cube 8
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, -- 6: cube 16…
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, --
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}  --
}

map_attribute[1] = {
  x = 9,
  y = 7,
  target = 1,
  endless_mode = {15, 8},
  create_num_mode = false
}

map_list[2] = { -- level 1
  {2, 2, 1, 1, 1, 2, 2, 2}, -- 0: map wall
  {2, 2, 1,12, 1, 2, 2, 2}, -- 1: map space
  {2, 2, 1, 0, 1, 1, 1, 1}, -- 2: null
  {1, 1, 1,12, 0,12,12, 1}, -- 3: cube 2
  {1,12, 0,12,12, 1, 1, 1}, -- 4: cube 4
  {1, 1, 1, 1, 0, 1, 2, 2}, -- 5: cube 8
  {2, 2, 2, 1,12, 1, 2, 2}, -- 6: cube 16…
  {2, 2, 2, 1, 1, 1, 2, 2}  --
}

map_attribute[2] = {
  x = 5,
  y = 4,
  target = 4,
  endless_mode = nil,
  create_num_mode = false
}

map_list[999] = {
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, --
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, --
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, --
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, --
  {1, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 1}, --
  {1, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 1}, --
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, --
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99, 1}, --
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}  --
}

map_attribute[999] = {
  x = 5,
  y = 4,
  target = 999,
  endless_mode = nil,
  create_num_mode = true
}

num_cube = {
  number =       {0, 0,  2,  4,  8, 16, 32, 64,128,256,512,1024,2048},
  number_color = {0, 0, 08, 08, 12, 12, 12, 12, 12, 08, 08,  08,  08},
  color =        {0, 0, 12, 11, 10, 09, 08, 01, 02, 03, 04,  05,  06},
  create_time = 4
}

player = {
  x = map_attribute[map].x,
  y = map_attribute[map].y,
  move = true,
  target = map_attribute[map].target,
  cube_2048 = 0
}

kenew_yago = {
  up = false,
  down = false,
  left = false,
  right = false
}

-- FUNCTIONS
function darw()
  for my, value in pairs(map_list[map]) do
    for mx, value in pairs(map_list[map][my]) do
      if (map_list[map][my][mx] == 0) -- darw map space
      then
        rect((mx - 1) * 15 + 1, (my - 1) * 15 + 1, 13, 13, 0)
      elseif (map_list[map][my][mx] == 1) -- darw map wall
      then
        spr(2, (mx - 1) * 15, (my - 1) * 15, 00, 1, 0, 0, 2, 2)
        -- rect((mx - 1) * 15, (my - 1) * 15, 13, 13, 7)
      elseif (map_list[map][my][mx] >= 3) -- darw number cube
      then
        rect((mx - 1) * 15 + 1, (my - 1) * 15 + 1, 13, 13, num_cube.color[map_list[map][my][mx]])
        print(tostring(num_cube.number[map_list[map][my][mx]]),
          mx * 15 - (7 + 2 * string.len(tostring(num_cube.number[map_list[map][my][mx]]))),
          my * 15 - 10, num_cube.number_color[map_list[map][my][mx]], false, 1, true)
        if map_list[map][my][mx] == 12
        then
          rect((mx - 1) * 15 + 1, (my - 1) * 15  + 1, 13, 13, num_cube.color[12])
          spr(0, (mx - 1) * 15, (my - 1) * 15, 00, 1, 0, 0, 2, 2) -- darw 1024 number
        end
        if map_list[map][my][mx] == 13
        then
          rect((mx - 1) * 15 + 1, (my - 1) * 15 + 1, 13, 13, num_cube.color[13])
          spr(32, (mx - 1) * 15, (my - 1) * 15, 00, 1, 0, 0, 2, 2) -- darw 2048 number
        end
      end
    end
  end
  if map_attribute[map].endless_mode -- darw endless mode cube
  then
    spr(34, (map_attribute[map].endless_mode[1] - 1) * 15,
    (map_attribute[map].endless_mode[2] - 1) * 15, 00, 1, 0, 0, 2, 2)
  end
  rect((player.x - 1) * 15 + 1, (player.y - 1) * 15 + 1, 13, 13, 9) -- darw player
  print("@", player.x * 15 - 10, player.y * 15 - 10, 5)
end

function darw_finish(a)
  if a == "win"
  then
    cls(0)
    print("You win!", 20, 90, 5)
    print("All 2048 is created.", 20, 100, 5)
    print("Type Space bar to next level...", 20, 110, 5)
  end
end

function move_player(dx, dy)
  player.move = true
  player.x = player.x + dx
  player.y = player.y + dy
  if map_list[map][player.y][player.x] >= 3
  then
    if map_list[map][player.y + dy][player.x + dx] == 0 then
      map_list[map][player.y + dy][player.x + dx] = map_list[map][player.y][player.x]
      map_list[map][player.y][player.x] = 0
    elseif map_list[map][player.y + dy][player.x + dx] == map_list[map][player.y][player.x] then
      map_list[map][player.y + dy][player.x + dx] = map_list[map][player.y][player.x] + 1
      map_list[map][player.y][player.x] = 0
    end
  end
  if map_list[map][player.y][player.x] ~= 0 then
    player.x = player.x - dx
    player.y = player.y - dy
  end
end

function create_num_cube() -- random create number cube [2]
  map_space = {}
  for my, value in pairs(map_list[map]) do
    for mx, value in pairs(map_list[map][my]) do
      if (map_list[map][my][mx] == 0) then
        map_space[#map_space + 1] = {mx, my}
      end
    end
  end
  for i, v in ipairs(map_space) do
    if overlap(player.x, player.y, v[1], v[2])
    then
      table.remove(map_space, i)
    end
  end
  -- print(map_space[1], 10, 10, 9) -- dev log
  random_loc = math.random(1, #map_space)
  new_x = map_space[random_loc][1]
  new_y = map_space[random_loc][2]
  -- print(new_x, 10, 20, 9) -- dev log
  -- print(new_y, 10, 30, 9) -- dev log
  num_cube.create_time = num_cube.create_time - 1
  if num_cube.create_time == 0
  then
    map_list[map][new_y][new_x] = 3
    num_cube.create_time = 4
  end
end

function overlap(ax, ay, bx, by)
  if ax == bx
  then
    if ay == by
    then
      return true
    end
  end
  return false
end

-- GAMELOOP
function TIC()

  cls(15)
  darw()

  if player.move
  then
    if key(58)
    then
      move_player(0, -1)
      if map_attribute[map].create_num_mode
      then
        create_num_cube()
      end
      player.move = false
    elseif key(59)
    then
      move_player(0, 1)
      if map_attribute[map].create_num_mode
      then
        create_num_cube()
      end
      player.move = false
    elseif key(60)
    then
      move_player(-1, 0)
      if map_attribute[map].create_num_mode
      then
        create_num_cube()
      end
      player.move = false
    elseif key(61)
    then
      move_player(1, 0)
      if map_attribute[map].create_num_mode
      then
        create_num_cube()
      end
      player.move = false
    end
  elseif not key()
  then
    player.move = true
  end

  for my, value in pairs(map_list[map]) do
    for mx, value in pairs(map_list[map][my]) do
      if (map_list[map][my][mx] == 13)
      then
        player.cube_2048 = player.cube_2048 + 1
      end
    end
  end

  if map_attribute[map].endless_mode
  then
    if overlap(player.x, player.y, map_attribute[map].endless_mode[1], map_attribute[map].endless_mode[2])
    then
      map = 999
    end
  end

  if player.cube_2048 == player.target
  then
    darw_finish("win")
    player.move = false
    if key(48) -- rebuild map
    then
      map = map + 1
      player.x = map_attribute[map].x
      player.y = map_attribute[map].y
      player.move = true
      player.target = map_attribute[map].target
    end
  end

  player.cube_2048 = 0

end
