-- this is a brainfuck interpreter in luau, roblox's version of lua. ( https://github.com/Roblox/luau )

local bf = { }

function bf.New ()
	local arr = {
		memory  = {[0]=0};
		pointer = 0;
	}

	function arr:execute (code: string)
		local skip: boolean = false
		local characters = string.split(code, "")
		local index: number = 0
		
		local print_buffer = ""
		
		local last_lb_index: number = nil

		local function store ()
			if self.memory[self.pointer] == nil then
				self.memory[self.pointer] = 0
			end
		end

		coroutine.wrap(function()

			while true do
				index += 1
				store()

				if index > #characters then break end

				local character: string = characters[index]

				if character == "]" then skip = false end
				if skip and not character == "]" then continue end

				if character == ">" then
					self.pointer += 1
					continue
				end

				if character == "<" then
					self.pointer -= 1
					continue
				end

				if character == "+" then
					self.memory[self.pointer] += 1
					continue
				end

				if character == "-" then
					self.memory[self.pointer] -= 1
					continue
				end

				if character == "." then
					print_buffer ..= string.char(self.memory[self.pointer])
					continue
				end

				if character == "[" then
					last_lb_index = index
					if self.memory[self.pointer] == 0 then
						skip = true
						continue
					end
				end

				if character == "]" then
					if self.memory[self.pointer] == 0 then
						continue
					end

					index = last_lb_index
					continue
				end
				
				if character == "?" then -- debug tool
					print(self.memory[self.pointer])
				end
				
				if character == ";" then -- wait
					wait()
				end
			end
			print(print_buffer)

		end)()
	end

	return arr
end

return bf
