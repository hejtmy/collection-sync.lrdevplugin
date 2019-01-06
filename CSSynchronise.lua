local LrLogger = import 'LrLogger'
local LrDialogs = import 'LrDialogs'
local LrTasks = import 'LrTasks'
local LrProgressScope = import 'LrProgressScope'
local LrFunctionContext = import 'LrFunctionContext'

require 'CSMessages.lua'
require 'helpers.lua'
require 'CSHelpers.lua'

local syncLogger = LrLogger('syncLogger')
syncLogger:enable( "print" ) -- Pass either a string or a table of actions.
local function outputToLog( message )
	syncLogger:trace( message )
end

CSSynchronise = {}

CSSynchronise.StartSync = function(rootFolder, rootCollection, publishService, rootPublish, recursive)
	LrTasks.startAsyncTask(function()
		LrFunctionContext.callWithContext( "showCustomDialogWithMultipleBind", function( context )
			local syncFolder = CSHelpers.findFolder(context, rootFolder, recursive)
			-- needs to establish, if the folder is the top level
			if syncFolder ~= nil then
				if recursive then
					CSSynchronise.RecursiveFolderSync(context, syncFolder, syncFolder:getPath(), rootCollection, publishService, rootPublish)
				else 
					local syncCollection = CSHelpers.findOrCreateCollectionTree(context, rootCollection, false)
					CSSynchronise.CopyPhotosFromFolderToCollection(context, syncFolder, syncCollection)
				end
			end
		end)
	end)
end

CSSynchronise.CopyPhotosFromFolder = function(context, folder, collection, publishService, publishCollection)
	local photos = folder:getPhotos(false) -- don't includeChildren
	local total = #photos
	local catalog = collection.catalog
	local folderProgressScope = LrProgressScope{
		title = "Copying photos from folders" .. folder:getPath(),
		caption = "Updatting " .. total .. " photos." ,
	}
	folderProgressScope:setCancelable(true)
	for completed = 1, total do
		if folderProgressScope:isCanceled() then break end
		local photo = photos[completed]
		folderProgressScope:setPortionComplete(completed, total)
		folderProgressScope:setCaption("Updated " .. tostring(completed) .. " of " .. tostring(total) .. " photos")
		catalog:withWriteAccessDo('copyingPhotosToCollection', function(context)
			if photo:getRawMetadata('isVirtualCopy') ~= true then collection:addPhotos({photo}) end
			end,{timeout=5})
		LrTasks.yield()
	end
	folderProgressScope:done()
end

CSSynchronise.RecursiveFolderSync = function(context, folder, rootFolderPath, rootCollectionPath, publishServiceName, rootPublishPath)
	local folders = folder:getChildren()
	if #folders == 0 then  -- if we are int he lowest folder
		local relativeFolderName = CSHelpers.relativeFolderName(folder, rootFolderPath)
		local relativeCollectionName = rootCollectionPath .. relativeFolderName
		local relativePublishName = rootPublishPath .. relativeFolderName
		local syncCollection = CSHelpers.findOrCreateCollectionTree(context, relativeCollectionName, false)
		local publishCollection = CSHelpers.findOrCreatePublishTree(context, publishServiceName, relativePublishName, false)
		CSSynchronise.CopyPhotosFromFolder(context, folder, syncCollection, progresScope, publishService, publishRoot )
	else -- else we recusively go deeper
		for f = 1, #folders do
			CSSynchronise.RecursiveFolderSync(context, folders[f], rootFolderPath, rootCollectionPath, publishServiceName, rootPublishPath)
		end
	end
end