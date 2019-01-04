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
	collection.catalog:withWriteAccessDo('copytingPhotosToCollection', function(context)
		collection:addPhotos(photos)
	end,
	{timeout=3, callback=function() 
		LrDialogs.message( "Title", "Photos failed to copy", "info" ) 
	end})
end

CSSynchronise.RecursiveFolderSync = function(context, topFolder, rootFolderPath, rootCollectionPath)
	outputToLog("folder name " .. topFolder:getPath())
	local folders = topFolder:getChildren()
	outputToLog("number of children" .. #folders)
	if #folders == 0 then  -- if we are int he lowest folder
		relativeFolderName = string.gsub(topFolder:getPath(), rootFolderPath, "")
		outputToLog(relativeFolderName)
		--relative to the topFolder
	else -- else we recusively go deeper
		for f = 1, #folders do
			CSSynchronise.RecursiveFolderSync(context, folders[f], rootFolderPath, rootCollectionPath)
		end
	end
end