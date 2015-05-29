-- Copyright (c) 2015 Seal Wang <sealwang@gmail.com>
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

local zmq = require "zmq"

local x = os.clock()

local N=tonumber(arg[1] or 100)

local ctx = zmq.init(1)

local s = ctx:socket(zmq.REQ)

s:connect("tcp://localhost:5555")

for i=1,N do
	s:send("13501906954 0000000001")
	local data, err = s:recv()
	if data then
		print(data)
	else
		print("s:recv() error:", err)
	end

	s:send("13501906954 0000000002")
	local data, err = s:recv()
	
        s:send("13501906954 0000000003 A")
	local data, err = s:recv()

        s:send("13501906954 0000000003")
	local data, err = s:recv()

	s:send("13501906954 0000000003 D")
	local data, err = s:recv()

        s:send("13501906954 0000000003")
	local data, err = s:recv()
end

s:close()
ctx:term()

print(string.format("time %.2f", os.clock() - x))
