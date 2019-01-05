local LrLogger = import 'LrLogger'
local LrDialogs = import 'LrDialogs'
local LrFunctionContext = import 'LrFunctionContext'
local LrTasks = import 'LrTasks'

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
	-- removes virtual copies
	collection.catalog:withWriteAccessDo('copytingPhotosToCollection', function(context)
			for _, photo in ipairs(photos) do
				outputToLog(photo:getRawMetadata('isVirtualCopy'))
				if photo:getRawMetadata('isVirtualCopy') == false then
					collection:addPhotos(photo)
				end
			end
		end,
		{timeout=5, callback=function() 
		LrDialogs.message( "Title", "Photos failed to copy", "info" ) 
	end})
end

CSSynchronise.RecursiveFolderSync = function(context, folder, rootFolderPath, rootCollectionPath)
	outputToLog("folder name " .. folder:getPath())
	local folders = folder:getChildren()
	outputToLog("number of children" .. #folders)
	if #folders == 0 then  -- if we are int he lowest folder
		relativeFolderName = string.gsub(folder:getPath(), rootFolderPath, "")
		relativeFolderName = string.gsub(relativeFolderName, "\\", "/") -- OS sensitive solution?
		relativeCollectionName = rootCollectionPath .. relativeFolderName
		local syncCollection = CSHelpers.findOrCreateCollectionTree(context, relativeCollectionName, false)
		CSSynchronise.CopyPhotosFromFolderToCollection(context, folder, syncCollection)
	else -- else we recusively go deeper
		for f = 1, #folders do
			CSSynchronise.RecursiveFolderSync(context, folders[f], rootFolderPath, rootCollectionPath)
		end
	end
end