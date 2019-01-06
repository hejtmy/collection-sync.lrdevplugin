local prefs = import 'LrPrefs'.prefsForPlugin() 

CSInit = {
	DefaultFolder = "Photos/Boardgames/",
	DefaultCollection = "Boardgames/",
	recursive = 1,
	TutorialURL = "https://github.com/hejtmy/collection-sync.lrdevplugin",
	syncTrees = {
		{rootFolder = "", rootCollection="", publishService="", rootPublish=""},
		{rootFolder = "", rootCollection="", publishService="", rootPublish=""},
	},
}