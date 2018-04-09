function getCurrentScene() -- 
	return obslua.obs_frontend_get_current_scene()
end

function getSceneName(Sc)
	return obslua.obs_source_get_name(Sc)
end

function getSceneList()
	local tbl = {}
	local cleanup = obslua.obs_frontend_get_scenes()
	for i, v in ipairs(cleanup) do
		local name = getSceneName(v)
		tbl[name] = v
	end
	obslua.source_list_release(cleanup) -- Deal with memory leaks as this don't work
	return tbl
end

function setCurrentScene(Sc)
	obslua.obs_frontend_set_current_scene(Sc)
end

local gLastSwitchTime = 0
local gDebug = 0

function checkForSwitch()
	obslua.remove_current_callback()
	local currentScName = getSceneName(getCurrentScene())
	local now = os.time(os.date("!*t"))
	local sceneList = getSceneList()
	if string.find(currentScName, "@AS@") then
		if gDebug == 1 then
			print("current sc is acceptable")
		end
		local timeS = tonumber(string.match(currentScName, "@AS@(%d+)"))
		if now - timeS > gLastSwitchTime then
			if gDebug == 1 then
				print("it is time to")
			end
			local firstMatchName = nil
			local firstMatch = nil
			local hasSeen = 0
			for name, scene in pairs(sceneList) do
				if string.find(name, "@AS@") then 
					if gDebug == 1 then
						print(name)
					end
					if not firstMatch then
						firstMatch = scene
						firstMatchName = name
					end
					if hasSeen > 0 then
						if gDebug == 1 then
							print("switch to other scene")
						end
						setCurrentScene(scene)
						local ntimeS = tonumber(string.match(name, "@AS@(%d+)"))
						obslua.timer_add(checkForSwitch, ntimeS * 1000 + 1000)
						gLastSwitchTime = now
						return
					end
					if name == currentScName then
						hasSeen = 1
					end
				end
			end
			if gDebug == 1 then
				print("switch to firstseen scene")
			end
			setCurrentScene(firstMatch)
			local ntimeS = tonumber(string.match(firstMatchName, "@AS@(%d+)"))
			obslua.timer_add(checkForSwitch, ntimeS * 1000 + 1000)
			gLastSwitchTime = now
		end
	end
	--print("Waiting for next app scene")
	obslua.timer_add(checkForSwitch, 3000)
end

checkForSwitch()