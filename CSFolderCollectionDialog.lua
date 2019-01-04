local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'

function folderCollectionView()
	LrFunctionContext.callWithContext( "showCustomDialogWithMultipleBind", function( context )
		local f = LrView.osFactory()
		local content = f:view{
			title="Folder to Collection synchronisation",
			fill_horizontal = 1,
			f:row {
				f:static_text{
					title="Which folder to sychronise?",
				},
				f:checkbox{
					title="Include subfolders",
					value = 1,
				},
			},
			f:row {
				f:static_text{
					title="Which collection to sychronise?",
				},
				f:checkbox{
					title="Include subfolders",
					value = 1,
				},
			},
		}
		
		LrDialogs.presentModalDialog {
			title = "Custom Dialog Multiple Bind",
			contents = content
		}
		
	end)
end

folderCollectionView()