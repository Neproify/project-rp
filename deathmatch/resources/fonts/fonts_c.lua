function getFont(file, size, bold, quality)
	if not size then size = 9 end
	if not bold then bold = false end
	if not quality then quality = "antialiased" end
	return DxFont(file, size, bold, quality)
end