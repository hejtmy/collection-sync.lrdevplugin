local LrLogger = import 'LrLogger'
local LrDialogs = import 'LrDialogs'
local LrFunctionContext = import 'LrFunctionContext'
local LrTasks = import 'LrTasks'
local LrProgressScope = import 'LrProgressScope'

require 'CSMessages.lua'
require 'helpers.lua'
require 'CSHelpers.lua'

local syncLogger = LrLogger('syncLogger')
syncLogger:enable( "print" ) -- Pass either a string or a table of actions.
local function outputToLog( message )
	syncLogger:trace( message )
end

CSSynchronise = {}

CSSynchronise.FolderToCollectionSync = function(folder, collection, recursive)
	LrTasks.startAsyncTask(function()
		LrFunctionContext.callWithContext( "showCustomDialogWithMultipleBind", function( context )
			local syncFolder = CSHelpers.findFolder(context, folder, recursive)
			-- needs to establish, if the folder is the top level
			if syncFolder ~= nil then
				if recursive then
					outputToLog(syncFolder:getPath())
					CSSynchronise.RecursiveFolderSync(context, syncFolder, syncFolder:getPath(), collection)
				else 
					local syncCollection = CSHelpers.findOrCreateCollectionTree(context, collection, false)
					CSSynchronise.CopyPhotosFromFolderToCollection(context, syncFolder, syncCollection)
				end
			end
		end)
	end)
end

CSSynchronise.CopyPhotosFromFolderToCollection = function(context, folder, collection)
	local photos = folder:getPhotos(false) -- don't includeChildren
	local total = #photos
	local completed = 0
	local catalog = collection.catalog

	local folderProgressScope = LrProgressScope{
		title = "Copyting photos from folders" .. folder:getPath(),
		caption = "Updatting " .. total .. " photos." ,
	}
	for i = 1, total do
		local photo = photos[i]
		folderProgressScope:setPortionComplete(completed, total)
		folderProgressScope:setCaption("Updated " .. tostring(completed) .. " of " .. tostring(total) .. " photos")
		catalog:withWriteAccessDo('copyingPhotosToCollection', function()
			-- removes virtual copies
			if photo:getRawMetadata('isVirtualCopy') ~= true then collection:addPhotos(photo) end
		end)
		LrTasks.yield()
		completed = completed + 1
		outputToLog(completed)
	end
	folderProgressScope:done()
end

CSSynchronise.CopyPhotoProlongedAction = function(context, progress)

end

CSSynchronise.RecursiveFolderSync = function(context, folder, rootFolderPath, rootCollectionPath)
	outputToLog("folder name " .. folder:getPath())
	local folders = folder:getChildren()
	if #folders == 0 then  -- if we are int he lowest folder
		relativeFolderName = string.gsub(folder:getPath(), rootFolderPath, "")
		relativeFolderName = string.gsub(relativeFolderName, "\\", "/") -- OS sensitive solution?
		relativeCollectionName = rootCollectionPath .. relativeFolderName
		local syncCollection = CSHelpers.findOrCreateCollectionTree(context, relativeCollectionName, false)
		CSSynchronise.CopyPhotosFromFolderToCollection(context, folder, syncCollection, progresScope)
	else -- else we recusively go deeper
		for f = 1, #folders do
			CSSynchronise.RecursiveFolderSync(context, folders[f], rootFolderPath, rootCollectionPath)
		end
	end
end