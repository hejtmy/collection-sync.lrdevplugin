local LrHttp = import 'LrHttp'
local LrView = import 'LrView'
local LrPrefs = import 'LrPrefs'
local LrLogger = import 'LrLogger'
local bind = LrView.bind

require "CSInit.lua"
require "CSHelpers.lua"
require "CSSynchronise.lua"

local syncLogger = LrLogger('syncLogger')
syncLogger:enable( "print" ) -- Pass either a string or a table of actions.
local function outputToLog( message )
	syncLogger:trace( message )
end

--============================================================================--
local prefs = import 'LrPrefs'.prefsForPlugin() 

local function sectionsForTopOfDialog( f, propertyTable )
	
	local singleTree = function(syncTree, services)
		for i,k in pairs(syncTree) do outputToLog(i .. k)	end
		local view = f:row {
				f:static_text {
					title = syncTree.rootFolder,
					fill_horizontal = 1,
				},
				f:static_text {
					title = syncTree.rootCollection,
					fill_horizontal = 1,
				},
				f:push_button {
					title = LOC "$$$/CollectionSync/SyncButton=Sync now",
					enabled = true,
					action = function()
						CSSynchronise.FolderToCollectionSync(syncTree.rootFolder, syncTree.rootCollection, 1) 
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
			section[#section+1] = singleTree(syncTree, services)
		end
		return section
	end

	result = {
				exportPresetFields = {
					{key = 'test_value', default = 'nothing test' },	
					{key = "test_table", default = {{title="nothing", value=1},{title="nothing 2", value=2}}},
				},
			-- Section for the top of the dialog.
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
				f:push_button {
					width = 150,
					title = LOC "$$$/CollectionSync/ButtonTitle=Clear All",
					enabled = true,
					action = function()
						prefs.syncTrees = {}
					end,
				},
		}
		return {result}
end

return {
	sectionsForTopOfDialog = sectionsForTopOfDialog,
}