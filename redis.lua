    local redis = require "resty.redis"  
    --local jim_db_cluster = "/redis/cluster/1:1803528818953446384"
	--local ip = "192.168.192.38"
	
	--local jim_db_cluster = "/redis/cluster/196:1796420320792596039"
	--local ip = "10.191.87.217"	
	
	local jim_db_cluster = "/redis/cluster/23:1417694197540"
	local ip = "192.168.192.38"	
	local cacheTime = 60
	local ap_key = "ap_pool_key"
	local filePath = "./conf/ip.lua"
	local ip_pattern = "\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}"
	

    local cache = redis.new()  
    

	local resolver = require "resty.dns.resolver"
	local r, err = resolver:new{
		   nameservers = {"114.114.114.114", "223.5.5.5"},
		   retrans = 5,  -- 5 retransmissions on receive timeout
		   timeout = 2000,  -- 2 sec
	}

	-- if not r then
		-- ngx.say("failed to instantiate the resolver: ", err)
		-- return
	-- end

	-- local answers, err = r:query("www.jd.com", {qtype = r.TYPE_WKS })
	-- if not answers then
		-- ngx.say("failed to query the DNS server: ", err)
		-- return
	-- end

	-- if answers.errcode then
		-- ngx.say("server returned error code: ", answers.errcode,
				-- ": ", answers.errstr)
	-- end

	-- for i, ans in ipairs(answers) do
	    -- if (ans.type == 1) then
		-- ngx.say(ans.name," : ", ans.address)
	    -- end
	-- end	
	
	-- local function get_AP(cache)
		-- local ap_share_ram = ngx.shared.ap_share_ram
		-- local ipData = ap_share_ram:get(ap_key)
		-- ngx.say(ipData)
		-- ap_pool = {}
		-- if not ipData then
			-- ngx.say("no ap_pool\r\n")
			-- local file = io.open(filePath, "r");
			-- assert(file);
			-- ipData = file:read("*a"); -- 读取所有内容
			
			-- ap_share_ram:set(ap_key, ipData, cacheTime);	
			-- file:close();
		-- end
		
		-- local it, err = ngx.re.gmatch(ipData, ip_pattern)
		-- if not it then
			-- ngx.log(ngx.ERR, "error: ", err)
			-- return
		-- end
		-- while true do
			-- local m, err = it()
			-- if err then
				-- ngx.log(ngx.ERR, "error: ", err)
				-- return
			-- end
	 
			-- if not m then
				-- -- no match found (any more)
				-- break
			-- end
	 
			-- -- found a match
			-- ngx.say(m[0])
			-- table.insert(ap_pool, m[0])
		-- end
		-- while true do
			-- local i = math.ceil(math.random(1 , table.getn(ap_pool)))
			-- ngx.say(i)
			-- local ok, err = cache.connect(cache, ap_pool[i], 5360)
			-- if not ok then
			   -- table.remove(ap_pool, i)
			-- else
				-- ap_share_ram:set(ap_key, ipData);
				-- break
			-- end
		-- end
		-- return ok
	-- end
    -- function stringToTable(str) 
       -- if not str then
            -- if type(str) == "table" then
				-- return str
		    -- else
			   -- local ret = loadstring("return "..str)()  
			   -- return ret  
		    -- end
	   -- else
		   -- local ret = {}
		   -- return ret
	   -- end
    -- end  
	

	function sz_T2S(_t)  
        local string =  ""
		for key, value in ipairs(_t) do      
          string= string.."\n"..value 
		end  
		return string
	end 

	local function get_ip_pool()
	   	local res = ngx.location.capture('/getAp2Jd/getIp', {
			method = ngx.HTTP_GET,
			body = body,
		});
		ngx.say(res.body);
		return res.body
	end
	
	local function get_AP(cache)
		local ap_share_ram = ngx.shared.ap_share_ram
		local ipData = ap_share_ram:get(ap_key)
		ngx.say(ipData)
		local ap_pool = {}
		if not ipData then
			-- ngx.say("no ap_pool\r\n")
			-- local file = io.open(filePath, "r");
			-- assert(file);
			-- ipData = file:read("*a"); -- 读取所有内容	
			-- file:close();
			ipData = get_ip_pool()
			if not ipData then
				ngx.say("failed to get ip pool data")  
				return  	
			end
		end
		local it, err = ngx.re.gmatch(ipData, ip_pattern)
		if not it then
			ngx.log(ngx.ERR, "error: ", err)
			return
		end
		while true do
			local m, err = it()
			if err then
				ngx.log(ngx.ERR, "error: ", err)
				return
			end
	 
			if not m then
				-- no match found (any more)
				break
			end
	 
			-- found a match
			-- ngx.say(m[0])
			table.insert(ap_pool, m[0])
		end
			
		ap_share_ram:set(ap_key, sz_T2S(ap_pool), cacheTime);		
		
		
		while true do
			if ap_pool ~=nil and next(ap_pool) ~=nil then  
				local i = math.ceil(math.random(1 , table.getn(ap_pool)))
				ngx.say(i)
				ngx.say(ap_pool[i])
				local ok, err = cache.connect(cache, ap_pool[i], 5360)
				if not ok then
				   table.remove(ap_pool, i)
				else
					ap_share_ram:set(ap_key, sz_T2S(ap_pool), cacheTime);
					return ok
				end
			else 
				ap_share_ram:delete(ap_key);
				return nil
			end
		end
	end
	
	

	
	-- local m,err = ngx.re.match(res.body, "\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}")
    -- if m then
		-- ngx.say(m[0]);
    -- else
       -- if err then
           -- ngx.log(ngx.ERR, "error: ", err)
           -- return
       -- end
	
       -- ngx.say("match not found")
    -- end
	
	-- local i = math.ceil(math.random(1 , table.getn(ap_pool)))
	-- ngx.say(i)
    -- local ok, err = cache.connect(cache, ip, 5360)    
    -- cache:set_timeout(60000)  
	-- if not ok then  
	-- ngx.say("failed to connect:", err)  
	-- return  
    -- end 
  
    cache:set_timeout(600) 
	local con = get_AP(cache)
	if con == nil then  
		ngx.say("failed to connect: jimdb")  
		return  
	end 	
	
	local auth, err = cache:auth(jim_db_cluster) 
	if not auth then 
		ngx.log(ngx.ERR,"failed to authenticate the jimdb cluster:"..jim_db_cluster, err)
		return cache:close()
	end	
      
    res, err = cache:set("dog", "an aniaml2")  
    if not res then  
            ngx.say("failed to set dog: ", err)  
            return  
    end  
      
    ngx.say("&nbsp&nbsp&nbsp&nbsp&nbsp&nbspset result: ", res)  
      
    local res, err = cache:get("dog")  
    if not res then  
            ngx.say("failed to get dog: ", err)  
            return  
    end  
      
    if res == ngx.null then  
            ngx.say("dog not found.")  
            return  
    end  
      
    ngx.say("dog: ", res) 
	-- cache:init_pipeline()
	-- cache:set("cat", "Marry")
	-- cache:set("horse", "Bob")
	-- cache:get("cat")
	-- cache:get("horse")
	-- local results, err = cache:commit_pipeline()
	-- if not results then
		-- ngx.say("failed to commit the pipelined requests: ", err)
		-- return
	-- end

	-- for i, res in ipairs(results) do
		-- if type(res) == "table" then
			-- if res[1] == false then
				-- ngx.say("failed to run command ", i, ": ", res[2])
			-- else
				-- -- process the table value
			-- end
		-- else
			-- -- process the scalar value
		-- end
	-- end	
      
      
    local ok, err = cache:set_keepalive(10000, 100)
      
	if not ok then
		ngx.say("failed to set keepalive: ", err)
		return
	 end 