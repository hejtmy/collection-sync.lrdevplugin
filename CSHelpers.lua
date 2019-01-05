local LrDialogs = import 'LrDialogs'
local LrLogger = import 'LrLogger'
local LrTasks = import 'LrTasks'

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

CSHelpers.findOrCreateCollectionTree = function(context, collection, isTopLevel)
	LrDialogs.attachErrorDialogToFunctionContext( context )
	local catalog = import "LrApplication".activeCatalog()
	collectionsNames = Helpers.mysplit(collection, '/')
	local syncCollection = nil
	-- Gets immediately collections in case we are in the topLevel
	for iCollection = 1, #collectionsNames do
		name = collectionsNames[iCollection]
		local isSet = isTopLevel or iCollection ~= #collectionsNames
		catalog:withWriteAccessDo('creatingCollectionSet', function( context ) 
			syncCollection = CSHelpers.getOrCreateCollectionOrSet(catalog, syncCollection, name, isSet)
		end ) 
	end
	return syncCollection
end


CSHelpers.getCollectionOrSet = function(catalog, isSet)
	if isSet then return catalog:getChildCollectionsSets() else return catalog:getChildCollections() end
end

CSHelpers.getOrCreateCollectionOrSet = function(catalog, parent, name, isSet)
	if isSet then return catalog:createCollectionSet(name, parent, true) else return catalog:createCollection(name, parent, true) end
end


CSHelpers.getPublishingServices = function()
	LrTasks.startAsyncTask(function()
		local catalog = import "LrApplication".activeCatalog()
		local services = catalog:getPublishServices()
		local items = {}
		for i = 1, #services do
			local service = services[i]
			outputToLog(service:getName())
			items[#items+1] = {title=service:getName(), value=service.localIdentifier}
		end
		return items
	end)
end