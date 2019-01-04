--[[----------------------------------------------------------------------------

Info.lua
Summary information for Flickr sample plug-in

--------------------------------------------------------------------------------

ADOBE SYSTEMS INCORPORATED
 Copyright 2007 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE: Adobe permits you to use, modify, and distribute this file in accordance
with the terms of the Adobe license agreement accompanying it. If you have received
this file from a source other than Adobe, then your use, modification, or distribution
of it requires the prior written permission of Adobe.

------------------------------------------------------------------------------]]

return {

	LrSdkVersion = 8.0,
	LrSdkMinimumVersion = 8.0, -- minimum SDK version required by this plug-in

	LrToolkitIdentifier = 'com.hejtmy.lightroom.collection-sync',
	LrPluginName = LOC "$$$/CollectionSync/PluginName=Collection Sync",
	LrPluginInfoProvider = 'CSInfoProvider.lua',
	LrLibraryMenuItems = {
		{
			title = LOC "$$$/Collection Sync/CustomDialog=Folder Collection Synchronise",
			file = "CSFolderCollectionDialog.lua"
		},
	},
	VERSION = { major=0, minor=1, revision=0, build=0 },
}
