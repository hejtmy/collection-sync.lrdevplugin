local LrHttp = import 'LrHttp'

require "CSInit.lua"
require "CSHelpers.lua"

--============================================================================--

local function sectionsForTopOfDialog( f, _ )
	
	local singleTree = function(services)
		local view = f:row {
				f:edit_field {
					value = "One Sync Tree",
				},
				f:static_text {
					title = services
				},
				f:popup_menu{
					items = services
				}
			}
		return view
	end

	local includedTrees = function() -- doesn't work
		section = {}
		local services = CSHelpers.getPublishingServices()
		for i = 1, #CSInit.syncTrees do
			section[#section+1] = singleTree(services)
		end
		return section
	end

	result = {
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
				f:row{
					f:static_text {
						title = CSInit.DefaultFolder,
						fill_horizontal = 1,
					},
					f:static_text {
						title = CSInit.DefaultCollection,
						fill_horizontal = 1,
					},
				},
				f:group_box{
					fill_horizontal = 1,
					unpack(includedTrees())
				}
		}
		return {result}
end

return {
	sectionsForTopOfDialog = sectionsForTopOfDialog,
}