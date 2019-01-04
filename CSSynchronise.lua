local LrLogger = import 'LrLogger'
local LrDialogs = import 'LrDialogs'
local LrFunctionContext = import 'LrFunctionContext'
local LrTasks = import 'LrTasks'

require 'CSMessages.lua'
require 'helpers.lua'

local syncLogger = LrLogger('syncLogger')
syncLogger:enable( "print" ) -- Pass either a string or a table of actions.
local function outputToLog( message )
	syncLogger:trace( message )
end

CSSynchronise = {}

CSSynchronise.FolderToCollectionSync = function(folder, collection, recursive)
	LrTasks.startAsyncTask(function()
		LrFunctionContext.callWithContext( "showCustomDialogWithMultipleBind", function( context )
			LrDialogs.attachErrorDialogToFunctionContext( context )
			local catalog = import "LrApplication".activeCatalog()
			local folders = catalog:getFolders()
			outputToLog('splitting')
			folderArr = Helpers.mysplit(folder, '/')
			local syncFolder = nil
			for iFolder = 1, #folderArr do
				topFolder = folderArr[iFolder]
				outputToLog('topFolder-' .. topFolder)
				syncFolder = nil
				for k, v in ipairs(folders) do
					outputToLog('folderName-' .. v:getName())
					if v:getName() == topFolder then
						syncFolder = v
						folders = v:getChildren()
						break
					end
				end
				if syncFolder == nil then error(CSMessages.folderNotFound) end
			end
			message = "Folder present"
			LrDialogs.message( "Title", message, "info" );
		end)
	end)
end