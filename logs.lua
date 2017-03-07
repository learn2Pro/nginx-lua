local redis = require "resty.redis"
local red = redis:new()

red:set_timeout(1000) -- 1 sec
local id = ngx.var.id
local key ="logs"
if id then
        key = "logs"..id
end

local ok, err = red:connect("23.106.148.101", 6379)
if not ok then
        ngx.say("failed to connect: ", err)
        return
end

local res, err = red:auth("banwagong-redis")
if not res then
        ngx.say("failed to authenticate: ", err)
        return
end

local res, err = red:get(key)
if not res then
        ngx.say("failed to get logs: ", err)
        return
end

if res == ngx.null then
        ngx.say("logs not found.")
        return
end

ngx.say(res)
local ok, err = red:set_keepalive(10000, 10)

if not ok then
        ngx.say("failed to set keepalive: ", err)
        return
end