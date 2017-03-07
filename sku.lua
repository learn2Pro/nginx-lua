	local sku = ngx.var.sku_id
	local pattern = "\\d+"
	local http_pattern= "\\w{32}"
	
	local rid = ngx.now()*1000;
	-- ngx.say(rid);	

	-- ngx.say(ngx.now())
	-- tradeÒ³ÇÀ¹º
	local res = ngx.location.capture('/skuDetail/newSubmitEasybuyOrder.action?callback=easybuysubmit&skuId='..sku..'&num=1&gids=&ybIds=&did=&_='..rid, 
	{
		method = ngx.HTTP_GET,
		body = body,
	});
	
	res = ngx.location.capture('/shopping/order/getEasyOrderInfo.action?rid='..rid,
	{
		method = ngx.HTTP_GET,
		body = body,
	});
	
	
	res = ngx.location.capture('/shopping/order/submitOrder.action?submitOrderParam.eid=HJUJ3DHSHVA3F6U22HYQA5N7YU3QPME4OAECU77RPJINOWD6PL2LSRXFAGAVIBG76T53JBZBZISOZKFYBOCOAXL7QY&submitOrderParam.trackID=1lCyyfrZg0iIiGDY9gw_40zlc0LgT-ZbxJx0EIX_VfJsXIra4jXDc_CXPd1mX2tvzkwqryhPalOLXVI7u83bdsHgqgrq4c8a7rG0hOxC1b5w&submitOrderParam.fp=88b9d15dfacaaa2895296a7215c9bc53',
	{
		method = ngx.HTTP_GET,
		body = body,
	});

	-- ×ÔÓªÒ³ÃæÇÀ¹º
	-- res = ngx.location.capture('/itemShowBtn?skuId='..sku..'&callback=jsonp'..rid..'&_='..ngx.now()*1000, {
		-- method = ngx.HTTP_GET,
		-- body = body,
	-- });
	-- --ngx.say(res.body)
	-- local m, err = ngx.re.match(res.body , http_pattern, "jomi")
    -- if m then
    -- else
        -- if err then
            -- ngx.log(ngx.ERR, "error: ", err)
            -- return
        -- end
        -- ngx.say("match not found")
    -- end
	-- --ngx.say(m[0])
	-- res = ngx.location.capture('/user_routing?skuId='..sku..'&sn='..m[0]..'&from=pc', {
		-- method = ngx.HTTP_GET,
		-- body = body,
	-- });
	-- --ngx.say(res.body)
	
	-- res = ngx.location.capture('/captcha.html?rid='..math.random()..'&from=pc&skuId='..sku..'&sn='..m[0], {
		-- method = ngx.HTTP_GET,
		-- body = body,
	-- });
	-- --ngx.say(res.body)
		
						-- -- res = ngx.location.capture('/addToCart.html?rcd=1&pid='..sku..'&pc=1&nr=1&rid='..rid..'&em=', {
							-- -- method = ngx.HTTP_GET,
							-- -- body = body,
						-- -- });

						-- -- ngx.req.set_header("Content-Type", "text/html;charset=utf8");
						-- -- ngx.req.set_header("Accept", "text/html");	
						-- -- ngx.req.set_header("Host", "trade.jd.com");	
						-- -- '/koFail.html#none'
						-- -- '/seckill/seckill.action?skuId='..sku..'&num=1&rid='..m[0]..'#none'

	-- res = ngx.location.capture('/seckill/seckill.action?skuId='..sku..'&num=1&rid='..rid..'#none', {
		-- method = ngx.HTTP_GET,
		-- body = body,
	-- });
	
	-- res = ngx.location.capture('/seckill/submitOrder.action?skuId='..sku, {
		-- method = ngx.HTTP_GET,
		-- body = body,
	-- });
	ngx.say(res.body)
	-- ngx.say(ngx.now())
	
	
	
		   
		   
		   