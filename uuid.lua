local ffi = require "ffi"
ffi.cdef[[
	typedef unsigned char uuid_t[16];
	void uuid_generate(uuid_t out);
	void uuid_unparse(const uuid_t uu, char *out);
]]

local uuid = ffi.load("libuuid")

if uuid then
   local uuid_t = ffi.new("uuid_t")
   local uuid_out = ffi.new("char[64]")
   uuid.uuid_generate(uuid_t)
   uuid.uuid_unparse(uuid_t, uuid_out)
   result = ffi.string(uuid_out)
   ngx.say(result)
else
	ngx.say("load uuid failed!")
end
