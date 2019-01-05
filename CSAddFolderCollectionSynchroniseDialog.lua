local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrPrefs = import 'LrPrefs'
local LrView = import 'LrView'

require "CSInit.lua"
require "CSSynchronise.lua"

local bind = LrView.bind -- shortcut for bind() method

local prefs = import 'LrPrefs'.prefsForPlugin() 

local AddSyncTreeToPrefs = function(propertyTable)
	syncTrees = prefs.syncTrees
	if syncTrees == nil then syncTrees = {} end
	local syncTree = {rootFolder = propertyTable.rootFolder, rootCollection = propertyTable.rootCollection}
	table.insert(syncTrees, syncTree)
	prefs.syncTrees = syncTrees
end

function folderCollectionView()
	LrFunctionContext.callWithContext( "showCustomDialogWithMultipleBind", function( context )
		local f = LrView.osFactory()
		local properties = LrBinding.makePropertyTable( context )
		local content = f:view{
			bind_to_object = properties,
			title="Folder to Collection synchronisation",
			fill_horizontal = 1,
			f:row {
				f:static_text{
					title="Which folder root to sychronise?",
				},
				f:edit_field{
					value = bind 'rootFolder',
				},
				f:checkbox{
					title="Include subfolders",
					value = true,
				},
			},
			f:row {
				f:static_text{
					title="Into which collection root to sychronise?",
				},
				f:edit_field{
					value = bind 'rootCollection',
				},
			},
			f:row{
				f:push_button{
					title = "Add to prefs",
					action = function() 
							AddSyncTreeToPrefs(properties)
						end, -- needs to bind the checkbox
				}
			}
		}
		LrDialogs.presentModalDialog {
			title = "Custom Dialog Multiple Bind",
			contents = content
		}
	end)
end

folderCollectionView()