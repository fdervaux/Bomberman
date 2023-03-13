playerImagetable = playdate.graphics.imagetable.new('images/character-table-32-32.png')
envImagetable = playdate.graphics.imagetable.new('images/env-table-16-16.png')

function bit(p)
    return 2 ^ (p - 1) -- 1-based indexing
end

function hasbit(x, p)
    return x % (p + p) >= p
end

function hasGroup(mask, group)
    return hasbit(mask, bit(group))
end

-- collision groups
collisionGroup = {
    p1 = 1,
    p2 = 2,
    bomb = 3,
    item = 4,
    block = 5,
    ignoreP1 = 6,
    ignoreP2 = 7,
    explosion = 8
}

function getPositionAtCoordonate(i, j)
    return (i - 1) * 16 + 8 + 16 * 5, (j - 1) * 16 + 8
end

function getCoordonateAtPosition(x, y)
    return math.floor((x - 8 - 16 * 5) / 16 + 1 + 0.5), math.floor((y - 8) / 16 + 1 + 0.5)
end

function containsClass(list, type)
    for _, value in pairs(list) do
        if value:isa(type) then
            return true
        end
    end
    return false
end

function getObjectOfClass(list, type)
    for _, value in pairs(list) do
        if value:isa(type) then
            return value
        end
    end
    return nil
end

function indexOfItem(list, item)
    for i = 0, #list, 1 do
        if list[i] == item then
            return i
        end
    end
    return nil
end

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end
