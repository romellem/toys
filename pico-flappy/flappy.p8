pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- game constants
local gravity = 0.3 -- acceleration due to gravity
local jump_speed = -4 -- upward speed when jumping
local player_radius = 4 -- radius of the main player

-- game state
local playery = 64 -- initial y position of the main player
local playeryspeed = 0 -- vertical speed of the main player
local game_over_flag = false

-- constants
local pillar_width = 8
local pillar_gap_min = 32
local pillar_gap_variation = 32
local pillar_speed = 1

-- variables
local pillars = {}
local pillars_on_screen = false
local score = -1

function game_over()
  game_over_flag = true
end

function check_collisions()
  for i, pillar in ipairs(pillars) do
    -- check collision with top pillar
    if player_radius > pillar.x and 0 - player_radius < pillar.x + pillar_width then
      if playery - player_radius < pillar.top_y or playery + player_radius > pillar.bottom_y then
        game_over()
        return
      end
    end
    
    -- check collision with bottom pillar
    if player_radius > pillar.x and 0 - player_radius < pillar.x + pillar_width then
      if playery + player_radius > pillar.bottom_y and playery - player_radius < pillar.bottom_y + pillar_height then
        game_over()
        return
      end
    end
  end
end

function spawn_pillars()
  score = score + 1
  local gap_size = max(pillar_gap_min, 2 * player_radius) + rnd(pillar_gap_variation)
  local pillar_top_y = 16 + player_radius + rnd(80 - gap_size - 2 * player_radius)
  local pillar_bottom_y = pillar_top_y + gap_size
  add(pillars, {x=128, top_y=pillar_top_y, bottom_y=pillar_bottom_y})
  pillars_on_screen = true
end

function move_pillars()
  for i,pillar in ipairs(pillars) do
    pillar.x = pillar.x - pillar_speed
  end
  if pillars[1].x + pillar_width < 0 then
    deli(pillars, 1)
    pillars_on_screen = false
  end
end

function draw_pillars()
  for i,pillar in ipairs(pillars) do
    rectfill(pillar.x, 0, pillar.x + pillar_width, pillar.top_y, 7)
    rectfill(pillar.x, pillar.bottom_y, pillar.x + pillar_width, 128, 7)
  end
end

function reset_game()
  if btnp(5) then -- 5 is the index for the "x" key
    playery = 64
    playeryspeed = 0
    pillars = {}
    pillars_on_screen = false
    score = -1
    game_over_flag = false
  end
end

function print_score()
  print(score, 112, 2, 11)
end

function _init()
  score = -1
  spawn_pillars()
end

function _update()
  check_collisions()

  if game_over_flag then
    reset_game()
    return
  end
  
  if not pillars_on_screen then
    spawn_pillars()
  end
  move_pillars()

  -- handle input
  if btnp(⬆️) then
    playeryspeed = jump_speed
  end

  -- update player position
  playery += playeryspeed
  playeryspeed += gravity

  -- constrain player to screen bounds
  if playery < player_radius then
    playery = player_radius
    playeryspeed = 0
  elseif playery > 128 - player_radius then
    playery = 128 - player_radius
    playeryspeed = 0
  end
end

function _draw()
  if game_over_flag then
    print("game over", (128-48)/2, 40, 8)
    print("press ❎ to restart", (128-96)/2, 52, 8)
    return
  end

  cls() -- clear the screen

  -- draw player
  circfill(player_radius, playery, player_radius, 12)

  draw_pillars()
  
  if score > -1 then
    print_score()
  end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000077777777700000000000000000000000000000000000000000000000000000000000000000000000000bb00000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000b00000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000b00000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000b00000000000000
0000000000000000000000000000077777777700000000000000000000000000000000000000000000000000000000000000000000000000bbb0000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000ccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000ccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__sfx__
000100001005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001005010050000000000010050100500000000000130501305000000000001305013050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 01424344

