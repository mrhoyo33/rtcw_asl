state("WolfSP", "1.42d"){
	string16 bsp : 0x13D4, 0x8;
	byte cs : 0x26F4, 0x0;
	int client_status: 0xB24EE0;
	float camera_x: "WolfSP.exe", 0xDA9D3C;
	
	float xpos : "WolfSP.exe", 0x5F8Da4;
	float ypos : "WolfSP.exe", 0x5F8Da8;
	float zpos : "WolfSP.exe", 0x5F8Dac;
	
	int finish: "qagamex86.dll", 0x57D7D0, 0x42c; 
}

startup {
	
	settings.Add("cat_all", true, "Full game");
	
	settings.Add("chaptersOnly", false, "Chapters");
	settings.Add("cat_chap1", false, "Ominous Rumors + Dark Secret", "chaptersOnly");
	settings.Add("cat_chap2", false, "Weapons of Vengeance", "chaptersOnly");
	settings.Add("cat_chap3", false, "Deadly Designs", "chaptersOnly");
	settings.Add("cat_chap4", false, "Deathshead's Playground", "chaptersOnly");
	settings.Add("cat_chap5", false, "Return Engagement + Operation Resurrection", "chaptersOnly");

	settings.Add("missionsFirstChapters", false, "Firsts Missions Chapters");
	settings.Add("miss_chap_1", false, "Escape", "missionsFirstChapters");
	settings.Add("miss_chap_2", false, "Forest", "missionsFirstChapters");
	settings.Add("miss_chap_3", false, "SFM", "missionsFirstChapters");
	settings.Add("miss_chap_4", false, "Norway", "missionsFirstChapters");
	settings.Add("miss_chap_5", false, "Dam", "missionsFirstChapters");

	Action<string> DebugOutput = (text) => {
		print("[RTCW Autosplitter] " + text);
	};
	vars.DebugOutput = DebugOutput;
}

init{
	vars.firstcs = true;
	vars.running = true;
	vars.loadStarted = false;
	vars.bsp_list = new List<String>();
	vars.visited = new List<String>();
}

exit{
	vars.running = false;
}

reset{}

start{	

	if(settings["miss_chap_1"]) vars.bsp_list.Add("/escape1.bsp");
	if(settings["miss_chap_2"]) vars.bsp_list.Add("/forest.bsp");
	if(settings["miss_chap_3"]) vars.bsp_list.Add("/sfm.bsp");
	if(settings["miss_chap_4"]) vars.bsp_list.Add("/norway.bsp");
	if(settings["miss_chap_5"]) vars.bsp_list.Add("/dam.bsp");

	if(settings["cat_all"] || settings["cat_chap1"]){
		vars.bsp_list.Add("/escape1.bsp");
		vars.bsp_list.Add("/escape2.bsp");
		vars.bsp_list.Add("/tram.bsp");
		vars.bsp_list.Add("/village1.bsp");
		vars.bsp_list.Add("/crypt1.bsp");
		vars.bsp_list.Add("/crypt2.bsp");
		vars.bsp_list.Add("/church.bsp");
		vars.bsp_list.Add("/boss1.bsp");
	}
	
	if(settings["cat_all"] || settings["cat_chap2"]){
		vars.bsp_list.Add("/forest.bsp");
		vars.bsp_list.Add("/rocket.bsp");
		vars.bsp_list.Add("/baseout.bsp");
		vars.bsp_list.Add("/assault.bsp");
	}
	
	if(settings["cat_all"] | settings["cat_chap3"]){
		vars.bsp_list.Add("/sfm.bsp");
		vars.bsp_list.Add("/factory.bsp");
		vars.bsp_list.Add("/trainyard.bsp");
		vars.bsp_list.Add("/swf.bsp");
	}

	if(settings["cat_all"] || settings["cat_chap4"]){
		vars.bsp_list.Add("/norway.bsp");
		vars.bsp_list.Add("/xlabs.bsp");
		vars.bsp_list.Add("/boss2.bsp");
	}

	if(settings["cat_all"] || settings["cat_chap5"]){ 
		vars.bsp_list.Add("/dam.bsp");
		vars.bsp_list.Add("/village2.bsp");
		vars.bsp_list.Add("/chateau.bsp");
		vars.bsp_list.Add("/dark.bsp");
		vars.bsp_list.Add("/dig.bsp");
		vars.bsp_list.Add("/castle.bsp");
		vars.bsp_list.Add("/end.bsp");
	}

	if(settings["cat_all"]){
		if (current.bsp == "/cutscene1.bsp" && current.cs == 1 && old.cs == 0) {
			vars.DebugOutput("Timer started");
			vars.firstcs = true;
			vars.visited.Clear();
			vars.visited.Add("/cutscene1.bsp");
			vars.visited.Add("/escape1.bsp");
			return true;
		}
	}
	if(settings["cat_chap1"] || settings["miss_chap_1"]){
		if (current.bsp == "/escape1.bsp" && old.bsp != "/escape1.bsp") {
			vars.DebugOutput("Timer started");
			vars.firstcs = true;
			vars.visited.Clear();
			vars.visited.Add("/escape1.bsp");
			return true;
		}
	}
	if(settings["cat_chap2"] || settings["miss_chap_2"]){
		if (current.bsp == "/forest.bsp" && old.bsp != "/forest.bsp") {
			vars.DebugOutput("Timer started");
			vars.firstcs = true;
			vars.visited.Clear();
			vars.visited.Add("/forest.bsp");
			return true;
		}
	}
	if(settings["cat_chap3"] || settings["miss_chap_3"]){
		if (current.bsp == "/sfm.bsp" && old.bsp != "/sfm.bsp") {
			vars.DebugOutput("Timer started");
			vars.firstcs = true;
			vars.visited.Clear();
			vars.visited.Add("/sfm.bsp");
			return true;
		}
	}
	if(settings["cat_chap4"] || settings["miss_chap_4"]){
		if (current.bsp == "/norway.bsp" && old.bsp != "/norway.bsp") {
			vars.DebugOutput("Timer started");
			vars.firstcs = true;
			vars.visited.Clear();
			vars.visited.Add("/norway.bsp");
			return true;
		}
	}
	if(settings["cat_chap5"] || settings["miss_chap_5"]){
		if (current.bsp == "/dam.bsp" && old.bsp != "/dam.bsp") {
			vars.DebugOutput("Timer started");
			vars.firstcs = true;
			vars.visited.Clear();
			vars.visited.Add("/dam.bsp");
			return true;
		}
	}
}

split
{
	if(current.bsp != old.bsp) {
		vars.DebugOutput("Map changed to " + current.bsp);
		if(vars.bsp_list.Contains(current.bsp) && !vars.visited.Contains(current.bsp)){
			vars.DebugOutput("Map change valid.");
			vars.visited.Add(current.bsp);
			vars.firstcs = true;
			return true;
		}
		else vars.DebugOutput("Map change ignored.");
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
	
	if(settings["cat_chap1"]){
		if (current.bsp == "/boss1.bsp" && current.cs == 1 && old.cs == 0) {
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
	
	if(settings["cat_chap2"]){
		if (current.bsp == "/assault.bsp" && current.cs == 1 && old.cs == 0) {
			if(vars.firstcs == true) {
				vars.firstcs = false;
				vars.DebugOutput("First cutscene.");
				return true;
			}
		}
	}
	
	if(settings["cat_chap3"]){
		if (current.bsp == "/swf.bsp" && current.cs == 1 && old.cs == 0) {
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
	
	// cords:  current.xpos >= 1454.0 && old.xpos < 1454.0 && current.xpos <= 1500.0 && old.xpos > 1300.0
	if(settings["cat_chap4"] && current.bsp == "/boss2.bsp"){
		if(current.xpos >= 1454.0 && old.xpos < 1454.0 && current.xpos <= 1500.0 && old.xpos > 1300.0) return true;
	}
	
	// cords:  old.xpos >= -3662.0 && current.xpos < -3662.0 && current.ypos >= 850.0  && 
	if(settings["miss_chap_1"] && current.bsp == "/escape1.bsp"){
		if(current.finish != 0) return true;
	}
	
	// cords:  current.xpos == -4800.0 && current.ypos == -896.0 && current.zpos == 256.0
	if (settings["miss_chap_2"] && current.bsp == "/forest.bsp" && current.cs == 1 && old.cs == 0) {
		if(vars.firstcs == true) return true;
		
	}
	
	// cords:  current.zpos <= -153.0 && old.xpos <= -850.0 && current.ypos >= 2150.0 &&
	if(settings["miss_chap_3"] && current.bsp == "/sfm.bsp"){
		if(current.finish != 0) return true;
	}
	
	// cords:  current.ypos >= -1450.0 && current.xpos <= -7998.0 &&
	if(settings["miss_chap_4"] && current.bsp == "/norway.bsp"){
		if(current.finish != 0) return true;
	}
	
	// cords: no ( trigger is diagonally )
	if(settings["miss_chap_5"] && current.bsp == "/dam.bsp"){
		if(current.finish != 0) return true;
	}
}

update{
	
	if(current.client_status != 8 && current.client_status != 1) vars.loadStarted = true;
	else{	
		if(current.camera_x != 0) vars.loadStarted = false;
	}
}

isLoading{	 
	return vars.loadStarted;
}
