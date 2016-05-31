function clearChat()
	local i = 0
	while i < 200 do
		outputChatBox("")
		i = i + 1
	end
end

bindKey("b", "down", "chatbox", "OOC")