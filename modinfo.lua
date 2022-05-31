-- This information tells other players more about the mod
name = "Special Saddles"
description = "特殊鞍具，更加贵也更加强力的鞍具，为您的后期养牛生活增添乐趣\n(Special Saddles, more expensive and more powerful saddles, add fun to your later cattle life)"
author = "howieshen and pinkmollies and ryuu "
version = "1.1.1"

-- This is the URL name of the mod's thread on the forum; the part after the ? and before the first & in the url
-- Example:
-- http://forums.kleientertainment.com/showthread.php?19505-Modders-Your-new-friend-at-Klei!
-- becomes
-- 19505-Modders-Your-new-friend-at-Klei!
-- forumthread = "25059-Download-Sample-Mods"

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- Only compatible with Don't Starve Together
dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true

all_clients_require_mod = true

--This let's the game know that this mod doesn't need to be listed in the server's mod listing
client_only_mod = false

--These tags allow the server running this mod to be found with filters from the server listing screen
server_filter_tags = {"special_saddles"}


configuration_options = {
    {
        name = "language",
        label = "翻译/translation",
        hover = "选择游戏语言Choose a Game language",
        options = {
            {description = "English", data = "en"},
            {description = "中文", data = "zh"},
        },
        default = "zh",
    },
}