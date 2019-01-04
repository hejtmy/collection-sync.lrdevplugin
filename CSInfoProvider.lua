local LrHttp = import 'LrHttp'

require "CSInit.lua"

--============================================================================--

local function sectionsForTopOfDialog( f, _ )
	return {
			-- Section for the top of the dialog.
			{
				title = LOC "$$$/Collection Sync/PluginManager=Collection sync settings",
				f:row {
					spacing = f:control_spacing(),

					f:static_text {
						title = LOC "$$$/CollectionSync/Title1=Here is going to be some text",
						fill_horizontal = 1,
					},

					f:push_button {
						width = 150,
						title = LOC "$$$/Collection Sync/ButtonTitle=Tutorial",
						enabled = true,
						action = function()
							LrHttp.openUrlInBrowser( CSInit.TutorialURL )
						end,
					},
				},

				f:row {
					f:static_text {
						title = LOC "$$$/CustomMetadata/Pair=Added pairs: ",
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
			},
		}
end

return {
	sectionsForTopOfDialog = sectionsForTopOfDialog,
}