-- title:   eXit
-- author:
-- desc:
-- site:
-- license:
-- version: 0.1
-- script:  lua

-- VARIABLES


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
