local LrHttp = import 'LrHttp'
local LrView = import 'LrView'
local LrPrefs = import 'LrPrefs'
local LrLogger = import 'LrLogger'
local bind = LrView.bind

require "CSInit.lua"
require "CSHelpers.lua"
require "CSSynchronise.lua"
require "CSDialogs.lua"

local syncLogger = LrLogger('syncLogger')
syncLogger:enable( "print" ) -- Pass either a string or a table of actions.
local function outputToLog( message )
	syncLogger:trace( message )
end

--============================================================================--
local prefs = import 'LrPrefs'.prefsForPlugin() 

local function sectionsForTopOfDialog( f, propertyTable )
	
	local singleTree = function(syncTree, services, i)
		local view = f:row {
				f:static_text {
					title = syncTree.rootFolder,
					fill_horizontal = 1,
				},
				f:static_text {
					title = syncTree.rootCollection,
					fill_horizontal = 1,
				},
				f:static_text {
					title = syncTree.publishService,
					fill_horizontal = 1,
				},
				f:static_text {
					title = syncTree.rootPublish,
					fill_horizontal = 1,
				},
				f:push_button {
					title = LOC "$$$/CollectionSync/SyncButton=Sync now",
					enabled = true,
					action = function()
						CSSynchronise.StartSync(syncTree.rootFolder, syncTree.rootCollection, syncTree.publishService, syncTree.rootPublish, 1)
					end,
				},
				f:push_button {
					title = LOC "$$$/CollectionSync/DeleteSyncTree=Delete tree",
					enabled = true,
					action = function()
						prefs.syncTrees[i] = nil
					end,
				},
			}
		return view
	end

	local includedTrees = function() -- doesn't work
		section = {}
		local services = CSHelpers.getPublishingServices()
		for i = 1, #prefs.syncTrees do
			local syncTree = prefs.syncTrees[i]
			section[#section+1] = singleTree(syncTree, services, i)
		end
		return section
	end

	result = {
		title = LOC "$$$/CollectionSync/PluginManager=Collection sync settings",
		f:row {
			spacing = f:control_spacing(),

			f:static_text {
				title = LOC "$$$/CollectionSync/Title1=Here is going to be some text",
				fill_horizontal = 1,
			},
			f:push_button {
				width = 150,
				title = LOC "$$$/CollectionSync/ButtonTitle=Tutorial",
				enabled = true,
				action = function()
					LrHttp.openUrlInBrowser( CSInit.TutorialURL )
				end,
			},
		},
		f:row {
			f:static_text {
				title = LOC "$$$/CollectionSync/Pair=Added pairs: ",
			},
		},
		f:group_box{
			fill_horizontal = 1,
			unpack(includedTrees())
		},
		f:row{
			f:push_button {
				width = 150,
				title = LOC "$$$/CollectionSync/ButtonTitle=Add",
				enabled = true,
				action = function()
					CSDialogs.AddFolderCollectionView()
				end,
			},
			f:push_button {
				width = 150,
				title = LOC "$$$/CollectionSync/ButtonTitle=Clear All",
				enabled = true,
				action = function()
					prefs.syncTrees = {}
				end,
			},
		},
	}
	return {result}
end

return {
	sectionsForTopOfDialog = sectionsForTopOfDialog,
}