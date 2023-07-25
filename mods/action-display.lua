-- name: Action Display
-- description: Action Display\nBy \\#ec7731\\Agent X\\#dcdcdc\\\n\nThis mod renders your action to the screen.

local djui_hud_set_resolution,djui_hud_set_font,djui_hud_set_color,djui_hud_print_text,math_floor = djui_hud_set_resolution,djui_hud_set_font,djui_hud_set_color,djui_hud_print_text,math.floor

local gActionTable = {
    [ACT_UNINITIALIZED] = "ACT_UNINITIALIZED",
    [ACT_IDLE] = "ACT_IDLE",
    [ACT_START_SLEEPING] = "ACT_START_SLEEPING",
    [ACT_SLEEPING] = "ACT_SLEEPING",
    [ACT_WAKING_UP] = "ACT_WAKING_UP",
    [ACT_PANTING] = "ACT_PANTING",
    [ACT_HOLD_PANTING_UNUSED] = "ACT_HOLD_PANTING_UNUSED",
    [ACT_HOLD_IDLE] = "ACT_HOLD_IDLE",
    [ACT_HOLD_HEAVY_IDLE] = "ACT_HOLD_HEAVY_IDLE",
    [ACT_STANDING_AGAINST_WALL] = "ACT_STANDING_AGAINST_WALL",
    [ACT_COUGHING] = "ACT_COUGHING",
    [ACT_SHIVERING] = "ACT_SHIVERING",
    [ACT_IN_QUICKSAND] = "ACT_IN_QUICKSAND",
    [ACT_UNKNOWN_0002020E] = "ACT_UNKNOWN_0002020E",
    [ACT_CROUCHING] = "ACT_CROUCHING",
    [ACT_START_CROUCHING] = "ACT_START_CROUCHING",
    [ACT_STOP_CROUCHING] = "ACT_STOP_CROUCHING",
    [ACT_START_CRAWLING] = "ACT_START_CRAWLING",
    [ACT_STOP_CRAWLING] = "ACT_STOP_CRAWLING",
    [ACT_SLIDE_KICK_SLIDE_STOP] = "ACT_SLIDE_KICK_SLIDE_STOP",
    [ACT_SHOCKWAVE_BOUNCE] = "ACT_SHOCKWAVE_BOUNCE",
    [ACT_FIRST_PERSON] = "ACT_FIRST_PERSON",
    [ACT_BACKFLIP_LAND_STOP] = "ACT_BACKFLIP_LAND_STOP",
    [ACT_JUMP_LAND_STOP] = "ACT_JUMP_LAND_STOP",
    [ACT_DOUBLE_JUMP_LAND_STOP] = "ACT_DOUBLE_JUMP_LAND_STOP",
    [ACT_FREEFALL_LAND_STOP] = "ACT_FREEFALL_LAND_STOP",
    [ACT_SIDE_FLIP_LAND_STOP] = "ACT_SIDE_FLIP_LAND_STOP",
    [ACT_HOLD_JUMP_LAND_STOP] = "ACT_HOLD_JUMP_LAND_STOP",
    [ACT_HOLD_FREEFALL_LAND_STOP] = "ACT_HOLD_FREEFALL_LAND_STOP",
    [ACT_AIR_THROW_LAND] = "ACT_AIR_THROW_LAND",
    [ACT_TWIRL_LAND] = "ACT_TWIRL_LAND",
    [ACT_LAVA_BOOST_LAND] = "ACT_LAVA_BOOST_LAND",
    [ACT_TRIPLE_JUMP_LAND_STOP] = "ACT_TRIPLE_JUMP_LAND_STOP",
    [ACT_LONG_JUMP_LAND_STOP] = "ACT_LONG_JUMP_LAND_STOP",
    [ACT_GROUND_POUND_LAND] = "ACT_GROUND_POUND_LAND",
    [ACT_BRAKING_STOP] = "ACT_BRAKING_STOP",
    [ACT_BUTT_SLIDE_STOP] = "ACT_BUTT_SLIDE_STOP",
    [ACT_HOLD_BUTT_SLIDE_STOP] = "ACT_HOLD_BUTT_SLIDE_STOP",
    [ACT_WALKING] = "ACT_WALKING",
    [ACT_HOLD_WALKING] = "ACT_HOLD_WALKING",
    [ACT_TURNING_AROUND] = "ACT_TURNING_AROUND",
    [ACT_FINISH_TURNING_AROUND] = "ACT_FINISH_TURNING_AROUND",
    [ACT_BRAKING] = "ACT_BRAKING",
    [ACT_RIDING_SHELL_GROUND] = "ACT_RIDING_SHELL_GROUND",
    [ACT_HOLD_HEAVY_WALKING] = "ACT_HOLD_HEAVY_WALKING",
    [ACT_CRAWLING] = "ACT_CRAWLING",
    [ACT_BURNING_GROUND] = "ACT_BURNING_GROUND",
    [ACT_DECELERATING] = "ACT_DECELERATING",
    [ACT_HOLD_DECELERATING] = "ACT_HOLD_DECELERATING",
    [ACT_BEGIN_SLIDING] = "ACT_BEGIN_SLIDING",
    [ACT_HOLD_BEGIN_SLIDING] = "ACT_HOLD_BEGIN_SLIDING",
    [ACT_BUTT_SLIDE] = "ACT_BUTT_SLIDE",
    [ACT_STOMACH_SLIDE] = "ACT_STOMACH_SLIDE",
    [ACT_HOLD_BUTT_SLIDE] = "ACT_HOLD_BUTT_SLIDE",
    [ACT_HOLD_STOMACH_SLIDE] = "ACT_HOLD_STOMACH_SLIDE",
    [ACT_DIVE_SLIDE] = "ACT_DIVE_SLIDE",
    [ACT_MOVE_PUNCHING] = "ACT_MOVE_PUNCHING",
    [ACT_CROUCH_SLIDE] = "ACT_CROUCH_SLIDE",
    [ACT_SLIDE_KICK_SLIDE] = "ACT_SLIDE_KICK_SLIDE",
    [ACT_HARD_BACKWARD_GROUND_KB] = "ACT_HARD_BACKWARD_GROUND_KB",
    [ACT_HARD_FORWARD_GROUND_KB] = "ACT_HARD_FORWARD_GROUND_KB",
    [ACT_BACKWARD_GROUND_KB] = "ACT_BACKWARD_GROUND_KB",
    [ACT_FORWARD_GROUND_KB] = "ACT_FORWARD_GROUND_KB",
    [ACT_SOFT_BACKWARD_GROUND_KB] = "ACT_SOFT_BACKWARD_GROUND_KB",
    [ACT_SOFT_FORWARD_GROUND_KB] = "ACT_SOFT_FORWARD_GROUND_KB",
    [ACT_GROUND_BONK] = "ACT_GROUND_BONK",
    [ACT_DEATH_EXIT_LAND] = "ACT_DEATH_EXIT_LAND",
    [ACT_JUMP_LAND] = "ACT_JUMP_LAND",
    [ACT_FREEFALL_LAND] = "ACT_FREEFALL_LAND",
    [ACT_DOUBLE_JUMP_LAND] = "ACT_DOUBLE_JUMP_LAND",
    [ACT_SIDE_FLIP_LAND] = "ACT_SIDE_FLIP_LAND",
    [ACT_HOLD_JUMP_LAND] = "ACT_HOLD_JUMP_LAND",
    [ACT_HOLD_FREEFALL_LAND] = "ACT_HOLD_FREEFALL_LAND",
    [ACT_QUICKSAND_JUMP_LAND] = "ACT_QUICKSAND_JUMP_LAND",
    [ACT_HOLD_QUICKSAND_JUMP_LAND] = "ACT_HOLD_QUICKSAND_JUMP_LAND",
    [ACT_TRIPLE_JUMP_LAND] = "ACT_TRIPLE_JUMP_LAND",
    [ACT_LONG_JUMP_LAND] = "ACT_LONG_JUMP_LAND",
    [ACT_BACKFLIP_LAND] = "ACT_BACKFLIP_LAND",
    [ACT_JUMP] = "ACT_JUMP",
    [ACT_DOUBLE_JUMP] = "ACT_DOUBLE_JUMP",
    [ACT_TRIPLE_JUMP] = "ACT_TRIPLE_JUMP",
    [ACT_BACKFLIP] = "ACT_BACKFLIP",
    [ACT_STEEP_JUMP] = "ACT_STEEP_JUMP",
    [ACT_WALL_KICK_AIR] = "ACT_WALL_KICK_AIR",
    [ACT_SIDE_FLIP] = "ACT_SIDE_FLIP",
    [ACT_LONG_JUMP] = "ACT_LONG_JUMP",
    [ACT_WATER_JUMP] = "ACT_WATER_JUMP",
    [ACT_DIVE] = "ACT_DIVE",
    [ACT_FREEFALL] = "ACT_FREEFALL",
    [ACT_TOP_OF_POLE_JUMP] = "ACT_TOP_OF_POLE_JUMP",
    [ACT_BUTT_SLIDE_AIR] = "ACT_BUTT_SLIDE_AIR",
    [ACT_FLYING_TRIPLE_JUMP] = "ACT_FLYING_TRIPLE_JUMP",
    [ACT_SHOT_FROM_CANNON] = "ACT_SHOT_FROM_CANNON",
    [ACT_FLYING] = "ACT_FLYING",
    [ACT_RIDING_SHELL_JUMP] = "ACT_RIDING_SHELL_JUMP",
    [ACT_RIDING_SHELL_FALL] = "ACT_RIDING_SHELL_FALL",
    [ACT_VERTICAL_WIND] = "ACT_VERTICAL_WIND",
    [ACT_HOLD_JUMP] = "ACT_HOLD_JUMP",
    [ACT_HOLD_FREEFALL] = "ACT_HOLD_FREEFALL",
    [ACT_HOLD_BUTT_SLIDE_AIR] = "ACT_HOLD_BUTT_SLIDE_AIR",
    [ACT_HOLD_WATER_JUMP] = "ACT_HOLD_WATER_JUMP",
    [ACT_TWIRLING] = "ACT_TWIRLING",
    [ACT_FORWARD_ROLLOUT] = "ACT_FORWARD_ROLLOUT",
    [ACT_AIR_HIT_WALL] = "ACT_AIR_HIT_WALL",
    [ACT_RIDING_HOOT] = "ACT_RIDING_HOOT",
    [ACT_GROUND_POUND] = "ACT_GROUND_POUND",
    [ACT_SLIDE_KICK] = "ACT_SLIDE_KICK",
    [ACT_AIR_THROW] = "ACT_AIR_THROW",
    [ACT_JUMP_KICK] = "ACT_JUMP_KICK",
    [ACT_BACKWARD_ROLLOUT] = "ACT_BACKWARD_ROLLOUT",
    [ACT_CRAZY_BOX_BOUNCE] = "ACT_CRAZY_BOX_BOUNCE",
    [ACT_SPECIAL_TRIPLE_JUMP] = "ACT_SPECIAL_TRIPLE_JUMP",
    [ACT_BACKWARD_AIR_KB] = "ACT_BACKWARD_AIR_KB",
    [ACT_FORWARD_AIR_KB] = "ACT_FORWARD_AIR_KB",
    [ACT_HARD_FORWARD_AIR_KB] = "ACT_HARD_FORWARD_AIR_KB",
    [ACT_HARD_BACKWARD_AIR_KB] = "ACT_HARD_BACKWARD_AIR_KB",
    [ACT_BURNING_JUMP] = "ACT_BURNING_JUMP",
    [ACT_BURNING_FALL] = "ACT_BURNING_FALL",
    [ACT_SOFT_BONK] = "ACT_SOFT_BONK",
    [ACT_LAVA_BOOST] = "ACT_LAVA_BOOST",
    [ACT_GETTING_BLOWN] = "ACT_GETTING_BLOWN",
    [ACT_THROWN_FORWARD] = "ACT_THROWN_FORWARD",
    [ACT_THROWN_BACKWARD] = "ACT_THROWN_BACKWARD",
    [ACT_WATER_IDLE] = "ACT_WATER_IDLE",
    [ACT_HOLD_WATER_IDLE] = "ACT_HOLD_WATER_IDLE",
    [ACT_WATER_ACTION_END] = "ACT_WATER_ACTION_END",
    [ACT_HOLD_WATER_ACTION_END] = "ACT_HOLD_WATER_ACTION_END",
    [ACT_DROWNING] = "ACT_DROWNING",
    [ACT_BACKWARD_WATER_KB] = "ACT_BACKWARD_WATER_KB",
    [ACT_FORWARD_WATER_KB] = "ACT_FORWARD_WATER_KB",
    [ACT_WATER_DEATH] = "ACT_WATER_DEATH",
    [ACT_WATER_SHOCKED] = "ACT_WATER_SHOCKED",
    [ACT_BREASTSTROKE] = "ACT_BREASTSTROKE",
    [ACT_SWIMMING_END] = "ACT_SWIMMING_END",
    [ACT_FLUTTER_KICK] = "ACT_FLUTTER_KICK",
    [ACT_HOLD_BREASTSTROKE] = "ACT_HOLD_BREASTSTROKE",
    [ACT_HOLD_SWIMMING_END] = "ACT_HOLD_SWIMMING_END",
    [ACT_HOLD_FLUTTER_KICK] = "ACT_HOLD_FLUTTER_KICK",
    [ACT_WATER_SHELL_SWIMMING] = "ACT_WATER_SHELL_SWIMMING",
    [ACT_WATER_THROW] = "ACT_WATER_THROW",
    [ACT_WATER_PUNCH] = "ACT_WATER_PUNCH",
    [ACT_WATER_PLUNGE] = "ACT_WATER_PLUNGE",
    [ACT_CAUGHT_IN_WHIRLPOOL] = "ACT_CAUGHT_IN_WHIRLPOOL",
    [ACT_METAL_WATER_STANDING] = "ACT_METAL_WATER_STANDING",
    [ACT_HOLD_METAL_WATER_STANDING] = "ACT_HOLD_METAL_WATER_STANDING",
    [ACT_METAL_WATER_WALKING] = "ACT_METAL_WATER_WALKING",
    [ACT_HOLD_METAL_WATER_WALKING] = "ACT_HOLD_METAL_WATER_WALKING",
    [ACT_METAL_WATER_FALLING] = "ACT_METAL_WATER_FALLING",
    [ACT_HOLD_METAL_WATER_FALLING] = "ACT_HOLD_METAL_WATER_FALLING",
    [ACT_METAL_WATER_FALL_LAND] = "ACT_METAL_WATER_FALL_LAND",
    [ACT_HOLD_METAL_WATER_FALL_LAND] = "ACT_HOLD_METAL_WATER_FALL_LAND",
    [ACT_METAL_WATER_JUMP] = "ACT_METAL_WATER_JUMP",
    [ACT_HOLD_METAL_WATER_JUMP] = "ACT_HOLD_METAL_WATER_JUMP",
    [ACT_METAL_WATER_JUMP_LAND] = "ACT_METAL_WATER_JUMP_LAND",
    [ACT_HOLD_METAL_WATER_JUMP_LAND] = "ACT_HOLD_METAL_WATER_JUMP_LAND",
    [ACT_DISAPPEARED] = "ACT_DISAPPEARED",
    [ACT_INTRO_CUTSCENE] = "ACT_INTRO_CUTSCENE",
    [ACT_STAR_DANCE_EXIT] = "ACT_STAR_DANCE_EXIT",
    [ACT_STAR_DANCE_WATER] = "ACT_STAR_DANCE_WATER",
    [ACT_FALL_AFTER_STAR_GRAB] = "ACT_FALL_AFTER_STAR_GRAB",
    [ACT_READING_AUTOMATIC_DIALOG] = "ACT_READING_AUTOMATIC_DIALOG",
    [ACT_READING_NPC_DIALOG] = "ACT_READING_NPC_DIALOG",
    [ACT_STAR_DANCE_NO_EXIT] = "ACT_STAR_DANCE_NO_EXIT",
    [ACT_READING_SIGN] = "ACT_READING_SIGN",
    [ACT_JUMBO_STAR_CUTSCENE] = "ACT_JUMBO_STAR_CUTSCENE",
    [ACT_WAITING_FOR_DIALOG] = "ACT_WAITING_FOR_DIALOG",
    [ACT_DEBUG_FREE_MOVE] = "ACT_DEBUG_FREE_MOVE",
    [ACT_STANDING_DEATH] = "ACT_STANDING_DEATH",
    [ACT_QUICKSAND_DEATH] = "ACT_QUICKSAND_DEATH",
    [ACT_ELECTROCUTION] = "ACT_ELECTROCUTION",
    [ACT_SUFFOCATION] = "ACT_SUFFOCATION",
    [ACT_DEATH_ON_STOMACH] = "ACT_DEATH_ON_STOMACH",
    [ACT_DEATH_ON_BACK] = "ACT_DEATH_ON_BACK",
    [ACT_EATEN_BY_BUBBA] = "ACT_EATEN_BY_BUBBA",
    [ACT_END_PEACH_CUTSCENE] = "ACT_END_PEACH_CUTSCENE",
    [ACT_CREDITS_CUTSCENE] = "ACT_CREDITS_CUTSCENE",
    [ACT_END_WAVING_CUTSCENE] = "ACT_END_WAVING_CUTSCENE",
    [ACT_PULLING_DOOR] = "ACT_PULLING_DOOR",
    [ACT_PUSHING_DOOR] = "ACT_PUSHING_DOOR",
    [ACT_WARP_DOOR_SPAWN] = "ACT_WARP_DOOR_SPAWN",
    [ACT_EMERGE_FROM_PIPE] = "ACT_EMERGE_FROM_PIPE",
    [ACT_SPAWN_SPIN_AIRBORNE] = "ACT_SPAWN_SPIN_AIRBORNE",
    [ACT_SPAWN_SPIN_LANDING] = "ACT_SPAWN_SPIN_LANDING",
    [ACT_EXIT_AIRBORNE] = "ACT_EXIT_AIRBORNE",
    [ACT_EXIT_LAND_SAVE_DIALOG] = "ACT_EXIT_LAND_SAVE_DIALOG",
    [ACT_DEATH_EXIT] = "ACT_DEATH_EXIT",
    [ACT_UNUSED_DEATH_EXIT] = "ACT_UNUSED_DEATH_EXIT",
    [ACT_FALLING_DEATH_EXIT] = "ACT_FALLING_DEATH_EXIT",
    [ACT_SPECIAL_EXIT_AIRBORNE] = "ACT_SPECIAL_EXIT_AIRBORNE",
    [ACT_SPECIAL_DEATH_EXIT] = "ACT_SPECIAL_DEATH_EXIT",
    [ACT_FALLING_EXIT_AIRBORNE] = "ACT_FALLING_EXIT_AIRBORNE",
    [ACT_UNLOCKING_KEY_DOOR] = "ACT_UNLOCKING_KEY_DOOR",
    [ACT_UNLOCKING_STAR_DOOR] = "ACT_UNLOCKING_STAR_DOOR",
    [ACT_ENTERING_STAR_DOOR] = "ACT_ENTERING_STAR_DOOR",
    [ACT_SPAWN_NO_SPIN_AIRBORNE] = "ACT_SPAWN_NO_SPIN_AIRBORNE",
    [ACT_SPAWN_NO_SPIN_LANDING] = "ACT_SPAWN_NO_SPIN_LANDING",
    [ACT_BBH_ENTER_JUMP] = "ACT_BBH_ENTER_JUMP",
    [ACT_BBH_ENTER_SPIN] = "ACT_BBH_ENTER_SPIN",
    [ACT_TELEPORT_FADE_OUT] = "ACT_TELEPORT_FADE_OUT",
    [ACT_TELEPORT_FADE_IN] = "ACT_TELEPORT_FADE_IN",
    [ACT_SHOCKED] = "ACT_SHOCKED",
    [ACT_SQUISHED] = "ACT_SQUISHED",
    [ACT_HEAD_STUCK_IN_GROUND] = "ACT_HEAD_STUCK_IN_GROUND",
    [ACT_BUTT_STUCK_IN_GROUND] = "ACT_BUTT_STUCK_IN_GROUND",
    [ACT_FEET_STUCK_IN_GROUND] = "ACT_FEET_STUCK_IN_GROUND",
    [ACT_PUTTING_ON_CAP] = "ACT_PUTTING_ON_CAP",
    [ACT_HOLDING_POLE] = "ACT_HOLDING_POLE",
    [ACT_GRAB_POLE_SLOW] = "ACT_GRAB_POLE_SLOW",
    [ACT_GRAB_POLE_FAST] = "ACT_GRAB_POLE_FAST",
    [ACT_CLIMBING_POLE] = "ACT_CLIMBING_POLE",
    [ACT_TOP_OF_POLE_TRANSITION] = "ACT_TOP_OF_POLE_TRANSITION",
    [ACT_TOP_OF_POLE] = "ACT_TOP_OF_POLE",
    [ACT_START_HANGING] = "ACT_START_HANGING",
    [ACT_HANGING] = "ACT_HANGING",
    [ACT_HANG_MOVING] = "ACT_HANG_MOVING",
    [ACT_LEDGE_GRAB] = "ACT_LEDGE_GRAB",
    [ACT_LEDGE_CLIMB_SLOW_1] = "ACT_LEDGE_CLIMB_SLOW_1",
    [ACT_LEDGE_CLIMB_SLOW_2] = "ACT_LEDGE_CLIMB_SLOW_2",
    [ACT_LEDGE_CLIMB_DOWN] = "ACT_LEDGE_CLIMB_DOWN",
    [ACT_LEDGE_CLIMB_FAST] = "ACT_LEDGE_CLIMB_FAST",
    [ACT_GRABBED] = "ACT_GRABBED",
    [ACT_IN_CANNON] = "ACT_IN_CANNON",
    [ACT_TORNADO_TWIRLING] = "ACT_TORNADO_TWIRLING",
    [ACT_BUBBLED] = "ACT_BUBBLED",
    [ACT_PUNCHING] = "ACT_PUNCHING",
    [ACT_PICKING_UP] = "ACT_PICKING_UP",
    [ACT_DIVE_PICKING_UP] = "ACT_DIVE_PICKING_UP",
    [ACT_STOMACH_SLIDE_STOP] = "ACT_STOMACH_SLIDE_STOP",
    [ACT_PLACING_DOWN] = "ACT_PLACING_DOWN",
    [ACT_THROWING] = "ACT_THROWING",
    [ACT_HEAVY_THROW] = "ACT_HEAVY_THROW",
    [ACT_PICKING_UP_BOWSER] = "ACT_PICKING_UP_BOWSER",
    [ACT_HOLDING_BOWSER] = "ACT_HOLDING_BOWSER",
    [ACT_RELEASING_BOWSER] = "ACT_RELEASING_BOWSER",
}

local function on_hud_render()
    djui_hud_set_resolution(RESOLUTION_N64)

    local text = gActionTable[gMarioStates[0].action] or "ACT_???"

    djui_hud_set_font(FONT_HUD)
    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_print_text("SPD " .. tostring(math.floor(gMarioStates[0].forwardVel)):gsub("-", "M"), 24, 32, 1)

    djui_hud_set_font(FONT_TINY)
    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_print_text(text, 24, 48, 1)
end

hook_event(HOOK_ON_HUD_RENDER, on_hud_render)