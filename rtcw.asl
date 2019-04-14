state("WolfSP")
{
	string16 bsp : 0x13D4, 0x8;
	byte cs : 0x26F4, 0x0;
	int client_status: "WolfSP.exe", 0xB24EE0;
	float camera_x: "WolfSP.exe", 0xDA9D3C;
}

startup 
{
	settings.Add("mission1", true, "Mission 1");
	settings.Add("/escape1.bsp", true, "Escape!", "mission1");
	settings.Add("/escape2.bsp", true, "Castle Keep", "mission1");
	settings.Add("/tram.bsp", true, "Tram Ride", "mission1");
	
	settings.Add("mission2", true, "Mission 2");
	settings.Add("/village1.bsp", true, "Village", "mission2");
	settings.Add("/crypt1.bsp", true, "Catacombs", "mission2");
	settings.Add("/crypt2.bsp", true, "Crypt", "mission2");
	settings.Add("/church.bsp", true, "The Defiled Church", "mission2");
	settings.Add("/boss1.bsp", true, "Tomb", "mission2");
	
	settings.Add("mission3", true, "Mission 3");
	settings.Add("/forest.bsp", true, "Forest Compound", "mission3");
	settings.Add("/rocket.bsp", true, "Rocket Base", "mission3");
	settings.Add("/baseout.bsp", true, "Radar Installation", "mission3");
	settings.Add("/assault.bsp", true, "Air Base Assault", "mission3");

	settings.Add("mission4", true, "Mission 4");
	settings.Add("/sfm.bsp", true, "Kugelstadt", "mission4");
	settings.Add("/factory.bsp", true, "The Bombed Factory", "mission4");
	settings.Add("/trainyard.bsp", true, "The Trainyards", "mission4");
	settings.Add("/swf.bsp", true, "Secret Weapons Facility", "mission4");

	settings.Add("mission5", true, "Mission 5");
	settings.Add("/norway.bsp", true, "Ice Station Norway", "mission5");
	settings.Add("/xlabs.bsp", true, "X-Labs", "mission5");
	settings.Add("/boss2.bsp", true, "Super Solider", "mission5");

	settings.Add("mission6", true, "Mission 6");
	settings.Add("/dam.bsp", true, "Bramburg Dam", "mission6");
	settings.Add("/village2.bsp", true, "Paderborn Village", "mission6");
	settings.Add("/chateau.bsp", true, "Chateau Schufstaffel", "mission6");
	settings.Add("/dark.bsp", true, "Unhallowed Ground", "mission6");
	
	settings.Add("mission7", true, "Mission 7");
	settings.Add("/dig.bsp", true, "The Dig", "mission7");
	settings.Add("/castle.bsp", true, "Return to Castle Wolfenstein", "mission7");
	settings.Add("/end.bsp", true, "Heinrich", "mission7");
	
	Action<string> DebugOutput = (text) => {
		print("[RTCW Autosplitter] "+text);
	};
	vars.DebugOutput = DebugOutput;
}

init
{
	vars.visited = new List<String>();
	vars.firstcs = true;
	vars.running = true;
	vars.loadStarted = false;
}

exit
{
	vars.running = false;
}

reset
{
}

start
{
	if (current.bsp == "/cutscene1.bsp" && current.cs == 1 && old.cs == 0) {
		vars.DebugOutput("Timer started");
		vars.firstcs = true;
		vars.visited.Clear();
		vars.visited.Add("/cutscene1.bsp");
		vars.visited.Add("/escape1.bsp");
		return true;
	}
}

split
{
	if(current.bsp != old.bsp) {
		vars.DebugOutput("Map changed to " + current.bsp);
		if(settings[current.bsp] && !vars.visited.Contains(current.bsp))
		{
			vars.DebugOutput("Map change valid.");
			vars.visited.Add(current.bsp);
			vars.firstcs = true;
			return true;
		}
		else
		{
			vars.DebugOutput("Map change ignored.");
		}
	}
	
	if (current.bsp == "/end.bsp" && current.cs == 1 && old.cs == 0) {
		if(vars.firstcs == false) {
			vars.DebugOutput("Second cutscene.");
			return true;
		}
		if(vars.firstcs == true) {
			vars.firstcs = false;
			vars.DebugOutput("First cutscene.");
		}
	}
}

update
{
	if(current.client_status != 8 && current.client_status != 1)
	{
		vars.loadStarted = true;
	}
	else
	{	
		if(current.camera_x != 0)
		{
			vars.loadStarted = false;
		}
	}
}

isLoading
{	 
	return vars.loadStarted;
}
