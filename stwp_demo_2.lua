-- title: demo 233
-- author: Skeptim and ChatGPT and gledos
-- desc: Demonstrating rotation of a square sprite using two triangles
-- script: lua

local sin = math.sin
local cos = math.cos

-- Initialize variables
local fd = { -- floppy_disk
    x = 8,
    y = 0,
    h = 32,
    l = 32
}

local x, y, z = 120, 68, 0 -- Position
local angx, angy, angz = 0, 0, 0 -- Rotation angles
local u1, v1 -- UV coordinates for corner 1, top left        <^
local u2, v2 -- UV coordinates for corner 2, top right       ^>
local u3, v3 -- UV coordinates for corner 3, bottom right   _>
local u4, v4 -- UV coordinates for corner 4, bottom left    <_
local scale = 4 -- Scale factor

-- LIBRARYS

-- libBindKey
BINDS = {}
function BINDS:bind(keyCode, func, isContinuous, isKeyboard)
    -- Typechecking
    if isContinuous == nil then
        isContinuous = false
    else
        assert(type(isContinuous) == "boolean", "isContinuous must be nil or a boolean")
    end
    if isKeyboard == nil then
        isKeyboard = false
    else
        assert(type(isKeyboard) == "boolean", "isKeyboard must be nil or a boolean")
    end
    assert(keyCode ~= nil and func ~= nil, "keyCode and func must not be nil")
    assert(type(keyCode) == "number", "keyCode must be a number")
    assert(type(func) == "function", "func must be a function")
    assert(keyCode % 1 == 0 and keyCode >= 0, "keyCode must be a positive integer")
    table.insert(self, {
        key = keyCode,
        exec = func,
        onKeyboard = isKeyboard,
        isContinuous = isContinuous
    })
end

function BINDS:loop()
    for k, keyBind in ipairs(self) do
        if keyBind.onKeyboard then
            if keyBind.isContinuous then
                if key(keyBind.key) then
                    keyBind.exec()
                end
            else
                if keyp(keyBind.key) then
                    keyBind.exec()
                end
            end
        else
            if keyBind.isContinuous then
                if btn(keyBind.key) then
                    keyBind.exec()
                end
            else
                if btnp(keyBind.key) then
                    keyBind.exec()
                end
            end
        end
    end
end

-- libGui
GUI = {}
DEFAULT_STYLE = {
    button = {
        color = 2,
        border = {
            color = 11,
            on = true
        }
    },
    label = {
        color = 12,
        fixed = false,
        scale = 1,
        smallfont = false
    },
    rect = {
        color = 15,
        border = {
            on = true,
            color = 12
        }
    }
}
function GUI:doBtnClick(mouseX, mouseY, mouseLeft, mouseMiddle, mouseRight)
    for i = 1, #self do
        local obj = self[i]
        if obj.type == 'button' then
            if mouseX >= obj.x and mouseX <= obj.x + obj.w then
                if mouseY >= obj.y and mouseY <= obj.y + obj.h then
                    if mouseLeft then
                        obj.leftClicked()
                    end
                    if mouseMiddle then
                        obj.middleClicked()
                    end
                    if mouseRight then
                        obj.rightClicked()
                    end
                end
            end
        end
    end
end
function GUI:loop(mx, my, ml, mm, mr)
    -- Draw all elements
    for i = 1, #self do
        local obj = self[i]
        if obj.type == 'button' then
            rect(obj.x + 1, obj.y, obj.w + 1, obj.h, obj.style.button.color)
            if obj.style.button.border.on then
                rectb(obj.x, obj.y - 1, obj.w + 3, obj.h + 2, obj.style.button.border.color)
            end
            print(obj.txt, obj.x + 1, obj.y + 1)
        elseif obj.type == 'label' then
            print(obj.txt, obj.x, obj.y, obj.style.label.color, obj.style.label.fixed, obj.style.label.scale,
                obj.style.label.smallfont)
        elseif obj.type == 'rect' then
            if obj.style.rect.border.on then
                rectb(obj.x, obj.y, obj.w, obj.h, obj.style.rect.border.color)
            end
            rect(obj.x + 1, obj.y + 1, obj.w - 2, obj.h - 2, obj.style.rect.color)
        end
    end
    -- Handle button onClick events
    GUI:doBtnClick(mx, my, ml, mm, mr)
end
function GUI:button(text, x, y, leftOnClick, middleOnClick, rightOnClick, styleTable)
    if styleTable == nil then
        styleTable = DEFAULT_STYLE
    end
    if leftOnClick == nil then
        leftOnClick = function()
        end
    end
    if middleOnClick == nil then
        middleOnClick = function()
        end
    end
    if rightOnClick == nil then
        rightOnClick = function()
        end
    end
    table.insert(self, {
        txt = text,
        x = x,
        y = y,
        w = print(text, -800000, -80000),
        h = 7,
        style = styleTable,
        leftClicked = leftOnClick,
        middleClicked = middleOnClick,
        rightClicked = rightOnClick,
        type = 'button'
    })
end
function GUI:label(text, x, y, styleTable)
    if styleTable == nil then
        styleTable = DEFAULT_STYLE
    end
    table.insert(self, {
        txt = text,
        x = x,
        y = y,
        style = styleTable,
        type = 'label'
    })
end
function GUI:rect(x, y, w, h, styleSheet)
    if styleSheet == nil then
        styleSheet = DEFAULT_STYLE
    end
    assert(x ~= nil and y ~= nil and w ~= nil and h ~= nil, "None of the parameters x,y,w,h can be null")
    table.insert(self, {
        x = x,
        y = y,
        h = h,
        w = w,
        style = styleSheet,
        type = 'rect'
    })
end

-- FUNCTIONS
function part_time()
    if not before_sinY then
        before_sinY = -0.1
    end
    if before_sinY > sinY then
        part_switch("B")
    end
    if before_sinY < sinY then
        part_switch("A")
    end
    before_sinY = sinY
end

function part_switch(type)
    if type == "A" then
        u1, v1 = fd.A_part.u1, fd.A_part.v1
        u2, v2 = fd.A_part.u2, fd.A_part.v2
        u3, v3 = fd.A_part.u3, fd.A_part.v3
        u4, v4 = fd.A_part.u4, fd.A_part.v4
    end
    if type == "B" then
        u1, v1 = fd.B_part.u1, fd.B_part.v1
        u2, v2 = fd.B_part.u2, fd.B_part.v2
        u3, v3 = fd.B_part.u3, fd.B_part.v3
        u4, v4 = fd.B_part.u4, fd.B_part.v4
    end
end

local function square_sprite_rotation(x, y, z, angx, angy, angz, chromakey, scale, u1, v1, u2, v2, u3, v3, u4, v4)

    -- Calculate rotation matrices
    sinX, cosX = sin(angx), cos(angx)
    sinY, cosY = sin(angy), cos(angy)
    sinZ, cosZ = sin(angz), cos(angz)

    -- Define the vertices of the first triangle
    local vertices1 = {{
        x = -8 * scale,
        y = -8 * scale,
        z = 0
    }, {
        x = 8 * scale,
        y = -8 * scale,
        z = 0
    }, {
        x = -8 * scale,
        y = 8 * scale,
        z = 0
    }}

    -- Apply rotation matrices to the vertices of the first triangle
    for _, vertex in ipairs(vertices1) do
        local x, y, z = vertex.x, vertex.y, vertex.z

        -- Apply rotation around x-axis
        local newY = y * cosX - z * sinX
        local newZ = y * sinX + z * cosX
        y, z = newY, newZ

        -- Apply rotation around y-axis
        local newX = x * cosY + z * sinY
        newZ = -x * sinY + z * cosY
        x, z = newX, newZ

        -- Apply rotation around z-axis
        newX = x * cosZ - y * sinZ
        newY = x * sinZ + y * cosZ
        x, y = newX, newY

        vertex.x, vertex.y, vertex.z = x, y, z
    end

    -- Define the vertices of the second triangle (symmetric to the first triangle)
    local vertices2 = {{
        x = 8 * scale,
        y = -8 * scale,
        z = 0
    }, {
        x = -8 * scale,
        y = 8 * scale,
        z = 0
    }, {
        x = 8 * scale,
        y = 8 * scale,
        z = 0
    }}

    -- Apply rotation matrices to the vertices of the second triangle
    for _, vertex in ipairs(vertices2) do
        local x, y, z = vertex.x, vertex.y, vertex.z

        -- Apply rotation around x-axis
        local newY = y * cosX - z * sinX
        local newZ = y * sinX + z * cosX
        y, z = newY, newZ

        -- Apply rotation around y-axis
        local newX = x * cosY + z * sinY
        newZ = -x * sinY + z * cosY
        x, z = newX, newZ

        -- Apply rotation around z-axis
        newX = x * cosZ - y * sinZ
        newY = x * sinZ + y * cosZ
        x, y = newX, newY

        vertex.x, vertex.y, vertex.z = x, y, z
    end

    -- Draw the rotated triangles to form a square sprite using ttri
    local v1_1, v2_1, v3_1 = vertices1[1], vertices1[2], vertices1[3]
    local v1_2, v2_2, v3_2 = vertices2[1], vertices2[2], vertices2[3]

    -- Draw first triangle
    ttri(v1_1.x + x, v1_1.y + y, v2_1.x + x, v2_1.y + y, v3_1.x + x, v3_1.y + y, u1, v1, u2, v2, u4, v4, 0, chromakey,
        v1_1.z, v2_1.z, v3_1.z)

    -- Draw second triangle
    ttri(v1_2.x + x, v1_2.y + y, v2_2.x + x, v2_2.y + y, v3_2.x + x, v3_2.y + y, u2, v2, u4, v4, u3, v3, 0, chromakey,
        v1_2.z, v2_2.z, v3_2.z)
end

local function AB_part_create(name)
    name.A_part = {
        u1 = name.x,          v1 = name.y,
        u2 = name.x + name.l, v2 = name.y,
        u3 = name.x + name.l, v3 = name.y + name.h,
        u4 = name.x,          v4 = name.y + name.h
    }
    name.B_part = {
        u1 = name.A_part.u1 + name.l, v1 = name.A_part.v1,
        u2 = name.A_part.u2 + name.l, v2 = name.A_part.v2,
        u3 = name.A_part.u3 + name.l, v3 = name.A_part.v3,
        u4 = name.A_part.u4 + name.l, v4 = name.A_part.v4
    }
end

function BOOT()
    AB_part_create(fd)
end

function TIC()
    cls(1)

    -- Update rotation angles based on input
    -- if btn(0) then
        -- angx = angx + 0.05
    -- end
    -- if btn(1) then
        -- angy = angy + 0.05
    -- end
    -- if btn(2) then
        -- angz = angz + 0.05
    -- end
    -- if btn(3) then
        -- scale = scale + 0.05
    -- end

    angy = angy + 0.05

    square_sprite_rotation(x, y, z, angx, angy, angz, 10, scale, u1, v1, u2, v2, u3, v3, u4, v4)
    part_time()
end
