require "CSInit.lua"

--============================================================================--

local function sectionsForTopOfDialog( f, _ )
	return {
			-- Section for the top of the dialog.
			{
				title = LOC "$$$/CustomMetadata/PluginManager=Custom Metadata Sample",
				f:row {
					spacing = f:control_spacing(),

					f:static_text {
						title = LOC "$$$/CustomMetadata/Title1=Click the button to find out more about Adobe",
						fill_horizontal = 1,
					},

					f:push_button {
						width = 150,
						title = LOC "$$$/CustomMetadata/ButtonTitle=Connect to Adobe",
						enabled = true,
						action = function()
							LrHttp.openUrlInBrowser( CSInit.URL )
						end,
					},
				},
				f:row {
					f:static_text {
						title = LOC "$$$/CustomMetadata/Title2=Global default value for displayImage: ",
					},
					f:static_text {
						title = CSInit.currentDisplayImage,
						fill_horizontal = 1,
					},
				},
			},
		}
end

return {
	sectionsForTopOfDialog = sectionsForTopOfDialog,
}