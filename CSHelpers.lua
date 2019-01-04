local LrDialogs = import 'LrDialogs'
local LrLogger = import 'LrLogger'

local syncLogger = LrLogger('syncLogger')
syncLogger:enable( "print" ) -- Pass either a string or a table of actions.
local function outputToLog( message )
	syncLogger:trace( message )
end

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

CSHelpers.findCollection = function(context, folder, isSet)
	LrDialogs.attachErrorDialogToFunctionContext( context )
	local catalog = import "LrApplication".activeCatalog()
	collectionsArr = Helpers.mysplit(folder, '/')
	local syncCollection = nil
	-- Gets immediately collections in case we are in the topLevel
	if #collectionsArr == 1 then collections = catalog:getChildCollections() else collections = catalog:getChildCollectionSets() end
	for iCollection = 1, #collectionsArr do
		topCollection = collectionsArr[iCollection]
		outputToLog('topCollection-' .. topCollection )
		syncCollection = nil
		for k, v in ipairs(collections) do
			if v:getName() == topCollection then
				outputToLog('collectionName-' .. v:getName())
				syncCollection = v
				-- flows to collections in case we are in the last "set" 
				if iCollection == #collectionsArr-1 then collections = v:getChildCollections() else collections = v:getChildCollectionSets() end
				break
			end
		end
		if syncCollection == nil then 
			-- create collection set if not last or if isSet is 1
			-- create collection if last
		end
	end
	return syncCollection
end