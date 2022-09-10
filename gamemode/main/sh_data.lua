
oz.data = oz.data or {}
oz.data.cache = oz.data.cache or {}

file.CreateDir("ozymandias")

function oz.data.Create(dataKey, dataValue)

	local path = "ozymandias/"

	file.CreateDir(path)

	if (dataValue != "" and dataValue != nil) then

		file.Write(path .. dataKey .. ".txt", util.TableToJSON({dataValue}))

		oz.data.cache[dataKey] = dataValue

		return path

	end

end

function oz.data.Get(dataKey)

	if(oz.data.cache[dataKey] != nil) then

		return oz.data.cache[dataKey]

	end

	local path = "ozymandias/"

	local content = file.Read(path .. dataKey .. ".txt", "DATA" )

	if (content) then

		local decodedData = pcall(util.JSONToTable, content)

		if (decodedData) then

			local data = decodedData[1]

			if (data != nil) then

				return data

			end

		end

	end

end

function oz.data.Delete(dataKey)

	local path = "ozymandias/"

	local content = file.Read(path .. dataKey .. ".txt", "DATA")

	if (content) then

		file.Delete(path .. dataKey .. ".txt")
		oz.data.cache[dataKey] = nil
		return true

	end

	return false

end