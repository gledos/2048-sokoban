-- title:   2048 sokoban
-- author:  gledos <cngledos@gmail.com>
-- desc:    2048 + sokoban game, just only 2 level demo game.
-- site:    website link
-- license:
-- version: 0.3
-- script:  lua

-- VARIABLES

map_list = {}
map_attribute = {}
map = 1

map_list[1] = { -- demo map
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, -- 0: map space
  {1, 0, 0, 3, 4, 5, 6, 7, 8, 9,10,11,12, 0, 0, 1}, -- 1: map wall
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
  {2, 2, 1, 1, 1, 2, 2, 2}, -- 0: map space
  {2, 2, 1,12, 1, 2, 2, 2}, -- 1: map wall
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

map_list[3] = { -- level 2
  {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
  {2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 2, 2},
  {2, 2, 2, 1, 1, 1, 0, 0, 0, 1, 1, 1},
  {2, 2, 2, 1, 0,10,11, 9,11, 9,11, 1},
  {2, 2, 2, 1, 0, 0, 0, 0, 0, 0, 0, 1},
  {2, 2, 2, 1, 0, 0, 0, 1, 1, 1, 1, 1},
  {2, 2, 2, 1, 1, 1, 1, 1, 2, 2, 2, 2}
}

map_attribute[3] = {
  x = 9,
  y = 3,
  target = 2,
  endless_mode = nil,
  create_num_mode = false
}

map_list[999] = {
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, --
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, --
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, --
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,80, 1}, --
  {1, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 1}, --
  {1, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 1}, --
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, --
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, --
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
  cube_2048 = 0,
  directions = {
    up =    {x = 0, y =-1}, -- up
    down =  {x = 0, y = 1}, -- down
    left =  {x =-1, y = 0}, -- left
    right = {x = 1, y = 0}, -- right
    way =   nil
  }
}

button_pressed = false -- 按钮是否被按下的状态变量

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
      elseif (map_list[map][my][mx] >= 3) and (map_list[map][my][mx] <= 13) -- darw number cube
      then
        rect((mx - 1) * 15 + 1, (my - 1) * 15 + 1, 13, 13, num_cube.color[map_list[map][my][mx]])
        print(tostring(num_cube.number[map_list[map][my][mx]]),
          mx * 15 - (7 + 2 * string.len(tostring(num_cube.number[map_list[map][my][mx]]))),
          my * 15 - 10, num_cube.number_color[map_list[map][my][mx]], false, 1, true)
        if map_list[map][my][mx] == 12 -- darw 1024 number
        then
          rect((mx - 1) * 15 + 1, (my - 1) * 15  + 1, 13, 13, num_cube.color[12])
          spr(00, (mx - 1) * 15, (my - 1) * 15, 00, 1, 0, 0, 2, 2)
        end
        if map_list[map][my][mx] == 13 -- darw 2048 number
        then
          rect((mx - 1) * 15 + 1, (my - 1) * 15 + 1, 13, 13, num_cube.color[13])
          spr(32, (mx - 1) * 15, (my - 1) * 15, 00, 1, 0, 0, 2, 2)
        end
      end
      if map_list[map][my][mx] == 80 -- darw item X
      then
        spr(04, (mx - 1) * 15, (my - 1) * 15, 00, 1, 0, 0, 2, 2)
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
  if map_list[map][player.y][player.x] == 80 then -- item X
    map_list[map][player.y][player.x] = 0
    for my, value in pairs(map_list[map]) do
      for mx, value in pairs(map_list[map][my]) do
        if (map_list[map][my][mx] >= 3) and (map_list[map][my][mx] <= 12)
        then
          map_list[map][my][mx] = map_list[map][my][mx] + 1
        end
      end
    end
  end
  if (map_list[map][player.y][player.x] >= 3) and (map_list[map][player.y][player.x] <= 13) -- 推箱子相关
  then
    if map_list[map][player.y + dy][player.x + dx] == 0 then
      map_list[map][player.y + dy][player.x + dx] = map_list[map][player.y][player.x]
      map_list[map][player.y][player.x] = 0
    elseif map_list[map][player.y + dy][player.x + dx] == map_list[map][player.y][player.x] -- 合成相关
    then
      map_list[map][player.y + dy][player.x + dx] = map_list[map][player.y][player.x] + 1
      map_list[map][player.y][player.x] = 0
    end
  end
  if map_list[map][player.y][player.x] ~= 0 then -- 行走相关
    player.x = player.x - dx
    player.y = player.y - dy
  end
end

function random_cube_list(a)
  if a == 1
  then
    return 80
  elseif a >= 13
  then
    return 4
  else
    return 3
  end
end

function create_num_cube() -- random create number cube [2]
  if map_attribute[map].create_num_mode
  then
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
      map_list[map][new_y][new_x] = random_cube_list(math.random(1, 20))
      num_cube.create_time = 4
    end
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

  mouse_x, mouse_y, mouse_left, mouse_middle, mouse_right, mouse_scrollx, mouse_scrolly = mouse()
  cls(15)
  darw()

  if player.move
  then
    if player.directions.way == "up"
    then
      move_player(0, -1)
      create_num_cube()
      player.move = false
    elseif player.directions.way == "down"
    then
      move_player(0, 1)
      create_num_cube()
      player.move = false
    elseif player.directions.way == "left"
    then
      move_player(-1, 0)
      create_num_cube()
      player.move = false
    elseif player.directions.way == "right"
    then
      move_player(1, 0)
      create_num_cube()
      player.move = false
    end
  elseif not key() and not mouse_left
  then
    player.move = true
    button_pressed = true
  end

  --     +----+--------------+----+ --+
  --     |  \ |      1       | /  |  46px
  --     +----+--------------+----+ --+
  --     |  4 |              | 2  |
  --     +----+--------------+----+
  --     |  / |      3       | \  |
  --     +----+--------------+----+

  if key(58) or key(23)
  or
    player.move and mouse_left and mouse_x >= 46 and mouse_x <= 193 and mouse_y >= 0 and mouse_y <= 45
  then
    player.directions.way = "up"
  elseif key(59) or key(19)
  or
    player.move and mouse_left and mouse_x >= 46 and mouse_x <= 193 and mouse_y >= 90 and mouse_y <= 135
  then
    player.directions.way = "down"
  elseif key(60) or key(01)
  or
    player.move and mouse_left and mouse_x >= 0 and mouse_x <= 45 and mouse_y >= 0 and mouse_y <= 135
  then
    player.directions.way = "left"
  elseif key(61) or key(04)
  or
    player.move and mouse_left and mouse_x >= 194 and mouse_x <= 239 and mouse_y >= 0 and mouse_y <= 135
  then
    player.directions.way = "right"
  else
    player.directions.way = nil
  end

  player.cube_2048 = 0

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
      player.x = map_attribute[map].x
      player.y = map_attribute[map].y
      player.target = map_attribute[map].target
    end
  end

  if player.cube_2048 == player.target
  then
    darw_finish("win")
    player.move = false
    if key(48) -- next map
    then
      map = map + 1
      player.x = map_attribute[map].x
      player.y = map_attribute[map].y
      player.target = map_attribute[map].target
      player.move = true
    end
  end

end
