local LrDialogs = import 'LrDialogs'

CSHelpers = {}

CSHelpers.findFolder = function(context, folder, recursive)
	LrDialogs.attachErrorDialogToFunctionContext( context )
	local catalog = import "LrApplication".activeCatalog()
	local folders = catalog:getFolders()
	folderArr = Helpers.mysplit(folder, '/')
	local syncFolder = nil
	for iFolder = 1, #folderArr do
		topFolder = folderArr[iFolder]
		-- outputToLog('topFolder-' .. topFolder)
		syncFolder = nil
		for k, v in ipairs(folders) do
			-- outputToLog('folderName-' .. v:getName())
			if v:getName() == topFolder then
				syncFolder = v
				folders = v:getChildren()
				break
			end
		end
		if syncFolder == nil then error(CSMessages.folderNotFound) end
	end
	return syncFolder
end