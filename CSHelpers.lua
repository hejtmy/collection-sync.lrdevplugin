local LrDialogs = import 'LrDialogs'
local LrLogger = import 'LrLogger'
local LrTasks = import 'LrTasks'
local catalog = import "LrApplication".activeCatalog()

local syncLogger = LrLogger('syncLogger')
syncLogger:enable( "print" ) -- Pass either a string or a table of actions.
local function outputToLog( message )
	syncLogger:trace( message )
end

CSHelpers = {}

CSHelpers.findFolder = function(context, folder, recursive)
	LrDialogs.attachErrorDialogToFunctionContext( context )
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

CSHelpers.relativeFolderName = function(folder, rootFolderPath)
	local name = string.gsub(folder:getPath(), rootFolderPath, "")
	name = string.gsub(name, "\\", "/") -- OS sensitive solution?
	return name
end

CSHelpers.findOrCreateCollectionTree = function(context, collectionPath, isTopLevel)
	LrDialogs.attachErrorDialogToFunctionContext( context )
	collectionsNames = Helpers.mysplit(collectionPath, '/')
	local syncCollection = nil
	-- Gets immediately collections in case we are in the topLevel
	for iCollection = 1, #collectionsNames do
		name = collectionsNames[iCollection]
		local isSet = isTopLevel or iCollection ~= #collectionsNames
		LrTasks.yield()
		catalog:withWriteAccessDo('creatingCollectionSet', function( context ) 
			syncCollection = CSHelpers.getOrCreateCollectionOrSet(catalog, syncCollection, name, isSet)
		end ) 
	end
	return syncCollection
end

CSHelpers.findOrCreatePublishTree = function(context, publishServiceName, collectionPath, isTopLevel)
	LrDialogs.attachErrorDialogToFunctionContext( context )
	-- Gets immediately collections in case we are in the topLevel
	local publishService = CSHelpers.getPublishService(context, publishServiceName)
	if publishService == nil then return nil end
	local collectionsNames = Helpers.mysplit(collectionPath, '/')
	outputToLog(#collectionsNames)
	local publishCollection = nil
	for iCollection = 1, #collectionsNames do
		local name = collectionsNames[iCollection]
		local isSet = isTopLevel or iCollection ~= #collectionsNames
		LrTasks.yield()
		catalog:withWriteAccessDo('creatingCollectionSet', function( context ) 
			publishCollection = CSHelpers.getOrCreatePublishCollectionOrSet(publishService, publishCollection, name, isSet)
		end ) 
	end
	return publishCollection
end

CSHelpers.getCollectionOrSet = function(catalog, isSet)
	if isSet then return catalog:getChildCollectionsSets() else return catalog:getChildCollections() end
end

CSHelpers.getOrCreateCollectionOrSet = function(catalog, parent, name, isSet)
	if isSet then 
		return catalog:createCollectionSet(name, parent, true) 
	else 
			return catalog:createCollection(name, parent, true) 
		end
end

CSHelpers.getOrCreatePublishCollectionOrSet = function(service, parent, name, isSet)
	if isSet then 
		return service:createPublishedCollectionSet(name, parent, true)
	else 
		return service:createPublishedCollection(name, parent, true) 
	end
end

CSHelpers.getPublishingServices = function()
	LrTasks.startAsyncTask(function()
		local services = catalog:getPublishServices()
		local items = {}
		for i = 1, #services do
			local service = services[i]
			-- outputToLog(service:getName())
			-- service:getName(), value=service.localIdentifier}
		end
		return items
	end)
end

CSHelpers.getPublishService = function(context, name)
	outputToLog("Trying to find" .. name)
	local services = catalog:getPublishServices()
	local service = nil
	for i = 1, #services do
		service = services[i]
		if service:getName() == name then	
			outputToLog("Service found")
			break
		end
	end
	return service
end