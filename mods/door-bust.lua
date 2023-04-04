-- name: Door Bust
-- description: Door Bust v1.2\nBy \\#ec7731\\Agent X\\#dcdcdc\\\n\nThis mod adds busting down doors by slide kicking into them, flying doors can deal damage to other players and normal doors will respawn after 10 seconds.

gGlobalSyncTable.excludeLevels = false

define_custom_obj_fields({
    oDoorDespawnedTimer = 'u32',
    oDoorBuster = 'u32'
})

local function approach_number(current, target, inc, dec)
    if current < target then
        current = current + inc
        if current > target then
            current = target
        end
    else
        current = current - dec
        if current < target then
            current = target
        end
    end
    return current
end

local function on_or_off(value)
    if value then return "\\#00ff00\\ON" end
    return "\\#ff0000\\OFF"
end

--- @param m MarioState
local function active_player(m)
    local np = gNetworkPlayers[m.playerIndex]
    if m.playerIndex == 0 then
        return true
    end
    if not np.connected then
        return false
    end
    if np.currCourseNum ~= gNetworkPlayers[0].currCourseNum then
        return false
    end
    if np.currActNum ~= gNetworkPlayers[0].currActNum then
        return false
    end
    if np.currLevelNum ~= gNetworkPlayers[0].currLevelNum then
        return false
    end
    if np.currAreaIndex ~= gNetworkPlayers[0].currAreaIndex then
        return false
    end
    return is_player_active(m)
end

local function lateral_dist_between_object_and_point(obj, pointX, pointZ)
    if obj == nil then return 0 end
    local dx = obj.oPosX - pointX
    local dz = obj.oPosZ - pointZ

    return math.sqrt(dx * dx + dz * dz)
end

local function if_then_else(cond, if_true, if_false)
    if cond then return if_true end
    return if_false
end

local function s16(num)
    num = math.floor(num) & 0xFFFF
    if num >= 32768 then return num - 65536 end
    return num
end

--- @param o Object
local function bhv_broken_door_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oInteractType = INTERACT_DAMAGE
    o.oIntangibleTimer = 0
    o.oGraphYOffset = -5
    o.oDamageOrCoinValue = 2
    obj_scale(o, 0.85)

    o.hitboxRadius = 80
    o.hitboxHeight = 100
    o.oGravity = 3
    o.oFriction = 0.8
    o.oBuoyancy = 1

    o.oVelY = 50
end

--- @param o Object
local function bhv_broken_door_loop(o)
    if o.oForwardVel > 10 then
        object_step()
        if o.oForwardVel < 30 then
            o.oInteractType = 0
        end
    else
        cur_obj_update_floor()
        o.oFaceAnglePitch = approach_number(o.oFaceAnglePitch, -0x4000, 0x500, 0x500)
    end

    o.header.gfx.angle.y = o.header.gfx.angle.y + 0x8000

    obj_flicker_and_disappear(o, 300)
end

local id_bhvBrokenDoor = hook_behavior(nil, OBJ_LIST_GENACTOR, true, bhv_broken_door_init, bhv_broken_door_loop)

--- @param m MarioState
--- @param o Object
local function should_push_or_pull_door(m, o)
    local dx = o.oPosX - m.pos.x
    local dz = o.oPosZ - m.pos.z

    local dYaw = s16(o.oMoveAngleYaw - atan2s(dz, dx))

    return if_then_else(dYaw >= -0x4000 and dYaw <= 0x4000, 0x00000001, 0x00000002)
end

--- @param m MarioState
local function mario_update(m)
    if active_player(m) == 0 or (gGlobalSyncTable.excludeLevels and (gNetworkPlayers[0].currLevelNum == LEVEL_BBH or gNetworkPlayers[0].currLevelNum == LEVEL_HMC)) then return end

    local door = nil
    if m.playerIndex == 0 then
        door = obj_get_first(OBJ_LIST_SURFACE)
        while door ~= nil do
            if get_id_from_behavior(door.behavior) == id_bhvDoor or get_id_from_behavior(door.behavior) == id_bhvStarDoor or get_id_from_behavior(door.behavior) == id_bhvDoorWarp then
                if door.oDoorDespawnedTimer > 0 then
                    door.oDoorDespawnedTimer = door.oDoorDespawnedTimer - 1
                else
                    door.oPosY = door.oHomeY
                end
            end

            door = obj_get_next(door)
        end
    end

    door = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvDoor)
    local starDoor = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvStarDoor)
    local warpDoor = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvDoorWarp)
    local targetDoor = door
    if warpDoor ~= nil or starDoor ~= nil then
        if dist_between_objects(m.marioObj, starDoor) < dist_between_objects(m.marioObj, door) then
            targetDoor = starDoor
        elseif dist_between_objects(m.marioObj, warpDoor) < dist_between_objects(m.marioObj, door) or door == nil then
            targetDoor = warpDoor
        else
            targetDoor = door
        end
    end

    if targetDoor ~= nil then
        local dist = 200
        if m.action == ACT_LONG_JUMP and m.forwardVel <= -70 then dist = 1000 end

        if (m.action == ACT_SLIDE_KICK or m.action == ACT_SLIDE_KICK_SLIDE or m.action == ACT_JUMP_KICK or (m.action == ACT_LONG_JUMP and m.forwardVel <= -80)) and dist_between_objects(m.marioObj, targetDoor) < dist then
            local model = E_MODEL_CASTLE_CASTLE_DOOR

            if get_id_from_behavior(targetDoor.behavior) ~= id_bhvStarDoor then
                -- just make obj_get_model_extended dammit
                if obj_has_model_extended(targetDoor, E_MODEL_CASTLE_DOOR_1_STAR) ~= 0 then
                    model = E_MODEL_CASTLE_DOOR_1_STAR
                elseif obj_has_model_extended(targetDoor, E_MODEL_CASTLE_DOOR_3_STARS) ~= 0 then
                    model = E_MODEL_CASTLE_DOOR_3_STARS
                elseif obj_has_model_extended(targetDoor, E_MODEL_CCM_CABIN_DOOR) ~= 0 then
                    model = E_MODEL_CCM_CABIN_DOOR
                elseif obj_has_model_extended(targetDoor, E_MODEL_HMC_METAL_DOOR) ~= 0 then
                    model = E_MODEL_HMC_METAL_DOOR
                elseif obj_has_model_extended(targetDoor, E_MODEL_HMC_WOODEN_DOOR) ~= 0 then
                    model = E_MODEL_HMC_WOODEN_DOOR
                elseif obj_has_model_extended(targetDoor, E_MODEL_BBH_HAUNTED_DOOR) ~= 0 then
                    model = E_MODEL_BBH_HAUNTED_DOOR
                elseif obj_has_model_extended(targetDoor, E_MODEL_CASTLE_METAL_DOOR) ~= 0 then
                    model = E_MODEL_CASTLE_METAL_DOOR
                elseif obj_has_model_extended(targetDoor, E_MODEL_CASTLE_CASTLE_DOOR) ~= 0 then
                    model = E_MODEL_CASTLE_CASTLE_DOOR
                elseif obj_has_model_extended(targetDoor, E_MODEL_HMC_HAZY_MAZE_DOOR) ~= 0 then
                    model = E_MODEL_HMC_HAZY_MAZE_DOOR
                elseif obj_has_model_extended(targetDoor, E_MODEL_CASTLE_GROUNDS_METAL_DOOR) ~= 0 then
                    model = E_MODEL_CASTLE_GROUNDS_METAL_DOOR
                elseif obj_has_model_extended(targetDoor, E_MODEL_CASTLE_KEY_DOOR) ~= 0 then
                    model = E_MODEL_CASTLE_KEY_DOOR
                end
            else
                model = E_MODEL_CASTLE_STAR_DOOR_8_STARS
            end

            if m.forwardVel >= 30 or (m.action == ACT_LONG_JUMP and m.forwardVel <= -70) then
                play_sound(SOUND_GENERAL_BREAK_BOX, m.marioObj.header.gfx.cameraToObject)
                targetDoor.oDoorDespawnedTimer = 339
                targetDoor.oPosY = 9999
                spawn_triangle_break_particles(30, 138, 1, 4)
                spawn_non_sync_object(
                    id_bhvBrokenDoor,
                    model,
                    targetDoor.oPosX, targetDoor.oHomeY, targetDoor.oPosZ,
                    --- @param o Object
                    function(o)
                        o.oDoorBuster = gNetworkPlayers[m.playerIndex].globalIndex
                        o.oForwardVel = 80
                        set_mario_particle_flags(m, PARTICLE_TRIANGLE, 0)
                        play_sound(SOUND_ACTION_HIT_2, m.marioObj.header.gfx.cameraToObject)
                    end
                )
                if get_id_from_behavior(targetDoor.behavior) == id_bhvDoorWarp then
                    m.interactObj = targetDoor
                    m.usedObj = targetDoor
                    m.actionArg = should_push_or_pull_door(m, targetDoor)

                    level_trigger_warp(m, WARP_OP_WARP_DOOR)
                else
                    if targetDoor.oBehParams >> 24 == 50 and m.action == ACT_LONG_JUMP and m.forwardVel <= -80 then
                        set_mario_action(m, ACT_THROWN_BACKWARD, 0)
                        m.forwardVel = -300
                        m.faceAngle.y = -0x8000
                        m.vel.y = 20
                        m.pos.x = -200
                        m.pos.y = 2350
                        m.pos.z = 4900
                    elseif m.playerIndex == 0 then
                        set_camera_shake_from_hit(SHAKE_SMALL_DAMAGE)
                    end
                end
            end
        end

        if lateral_dist_between_object_and_point(m.marioObj, -200, 6977) < 10 and gNetworkPlayers[m.playerIndex].currLevelNum == LEVEL_CASTLE and m.action == ACT_THROWN_BACKWARD then
            set_mario_action(m, ACT_HARD_BACKWARD_AIR_KB, 0)
            m.hurtCounter = 4 * 4
            play_character_sound(m, CHAR_SOUND_ATTACKED)
            spawn_triangle_break_particles(20, 138, 3, 4)
            stop_background_music(SEQ_LEVEL_INSIDE_CASTLE)
        end
    end

    if gNetworkPlayers[m.playerIndex].currLevelNum == LEVEL_CASTLE and m.action == ACT_HARD_BACKWARD_AIR_KB and m.prevAction == ACT_THROWN_BACKWARD then
        m.actionTimer = m.actionTimer + 1
        m.invincTimer = 30
        set_camera_shake_from_hit(SHAKE_MED_DAMAGE)
        play_sound(SOUND_GENERAL_METAL_POUND, m.marioObj.header.gfx.cameraToObject)
        if m.actionTimer == 6 then
            djui_chat_message_create("\\#fbfb7d\\Lakitu:\\#ffffff\\ OH SH-")
        end
    end
end

--- @param m MarioState
--- @param o Object
local function allow_interact(m, o)
    if get_id_from_behavior(o.behavior) == id_bhvBrokenDoor and gNetworkPlayers[m.playerIndex].globalIndex == o.oDoorBuster then return false end
    return true
end


local function on_exclude_levels_command(msg)
    gGlobalSyncTable.excludeLevels = not gGlobalSyncTable.excludeLevels
    djui_chat_message_create("Exclude Levels status: " .. on_or_off(gGlobalSyncTable.excludeLevels))
    return true
end

hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ALLOW_INTERACT, allow_interact)

if network_is_server() then
    hook_chat_command("exclude-levels", "to toggle excluding problematic levels in Door Bust or not", on_exclude_levels_command)
end