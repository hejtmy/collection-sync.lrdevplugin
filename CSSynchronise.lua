local LrLogger = import 'LrLogger'
local LrDialogs = import 'LrDialogs'
local LrFunctionContext = import 'LrFunctionContext'
local LrTasks = import 'LrTasks'

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
			local str = folder .. collection .. recursive
			local catalog = import "LrApplication".activeCatalog()
			local folders = catalog:getFolders()
			local names = {}
			for k, v in ipairs(folders) do
				names[#names+1] = v:getName()
			end
			local message = table.concat(names,"\n")
			LrDialogs.message( "Title", message, "info" );
		end)
	end)
end