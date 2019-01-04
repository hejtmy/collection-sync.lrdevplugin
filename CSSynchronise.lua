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
			local syncCollection = CSHelpers.findOrCreateCollectionTree(context, collection, 0)
			if syncFolder ~= nil then
				message = "Folder present"
				LrDialogs.message( "Title", message, "info" );
			end
		end)
	end)
end
