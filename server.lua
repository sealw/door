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

permission = {}

function load_permission() 
    --permission["13501906954 0000000001"] = 1
    for line in io.lines("permission.dat") do
        _, _, key, act = string.find(line, "(%d* %d*) (%a)")
        permission[key] = (act == "A" and 1 or nil)
    end
end

function check(s)
    if permission[s] then return true end
    return false
end

local zmq = require"zmq"

function server()
    load_permission()

    local ctx = zmq.init(3)
    local receiver = ctx:socket(zmq.REP)
    receiver:bind("tcp://*:5555")

    local publisher = ctx:socket(zmq.PUB)
    publisher:bind("tcp://*:5556")
 
    while true do
        req = receiver:recv()
        if check(req) then 
            receiver:send("OK")
            publisher:send(req)
        else
           receiver:send("DENY")
        end
    end
end 

server()
