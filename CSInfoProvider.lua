local LrHttp = import 'LrHttp'

require "CSInit.lua"

--============================================================================--

local function sectionsForTopOfDialog( f, _ )
	
	local testInclude = function()
		local result = f:static_text {
			title ="asldkaůskj",
		}
		return result
	end

	local singleTree = function()
		return f:static_text {
			title = "One Sync Tree",
		}
	end

	local includedTrees = function() -- doesn't work
		section = {}
		for i = 1, 5 do
			section[#section+1] = singleTree()
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