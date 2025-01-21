-- 獲取適配的 HTTP 請求函數
local function getHttpRequest()
    if syn and syn.request then
        return syn.request, "Synapse Z"
    elseif getexecutorname and getexecutorname() == "Swift" then
        return request, "Swift"
    else
        error("未檢測到支持的 HTTP 請求函數，請使用 Swift 或 Synapse Z")
    end
end

local httpRequest, injectorName = getHttpRequest()

-- 發送請求到伺服器
local scriptResponse = httpRequest({
    Url = "https://haihai.hihihub.workers.dev/",
    Method = "GET",
    Headers = {
        ["User-Agent"] = injectorName,
        ["X-Auth-Token"] = "EWE"
    }
})

-- 檢查伺服器返回的狀態
if scriptResponse.StatusCode == 200 then
    -- 檢查伺服器返回的腳本內容
    if not scriptResponse.Body or scriptResponse.Body == "" then
        error("伺服器返回的腳本內容為空！")
    end

    -- 加載並執行伺服器返回的腳本
    local scriptFunction, loadError = loadstring(scriptResponse.Body)
    if not scriptFunction then
        error("腳本加載失敗：" .. tostring(loadError))
    end

    local success, execError = pcall(scriptFunction)
    if not success then
        error("腳本執行失敗：" .. tostring(execError))
    end
else
    error("伺服器返回錯誤狀態：" .. scriptResponse.StatusCode)
end
