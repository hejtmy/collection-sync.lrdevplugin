local LrLogger = import 'LrLogger'
local LrDialogs = import 'LrDialogs'

local syncLogger = LrLogger('syncLogger')
syncLogger:enable( "print" ) -- Pass either a string or a table of actions.
local function outputToLog( message )
	syncLogger:trace( message )
end

CSSynchronise = {}

CSSynchronise.FolderToCollectionSync = function(folder, collection, recursive)
	local str = folder .. collection .. recursive
	LrDialogs.message( "Title", str, "info" );
end