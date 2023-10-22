local CODE_PROPERTIES = {Loop = true, Wait = 5000, Diffcheck = 15000}
local ghraw, codeChanged, chunk = 'https://raw.githubusercontent.com/Thekuca/thekuca_coderunner/main/code.lua', false, ''

local function loadujKod(raw)
    load(raw)()
    if CODE_PROPERTIES.Loop then
        CreateThread(function()
            while CODE_PROPERTIES.Loop do
                if codeChanged then break end
                Wait(CODE_PROPERTIES.Wait)
                load(chunk)()
            end
        end)
    end
end

CreateThread(function()
    PerformHttpRequest(ghraw, function(err, raw)
        chunk = raw
        loadujKod(raw)
    end)
end)

CreateThread(function()
    while true do
        Wait(CODE_PROPERTIES.Diffcheck)
        PerformHttpRequest(ghraw, function(err, raw)
            if chunk ~= raw then
                codeChanged = true
                Wait(CODE_PROPERTIES.Wait + 100)
                chunk = raw
                loadujKod(raw)
            end
        end)
    end
end)
