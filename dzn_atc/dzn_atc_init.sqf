// AIR TAXI!!
if (isDedicated || !hasInterface) exitWith {};


// Properties
dzn_atc_onlyLeader 		= 		false;
dzn_atc_vehiclesList		= [
							"B_Heli_Transport_01_camo_F"
							,"B_Heli_Transport_01_F"
							// ,"B_Heli_Light_01_stripped_F"
							// ,"B_Heli_Light_01_F"
							,"B_Heli_Light_01_armed_F"
							,"I_Heli_Transport_02_F"
							,"I_Heli_light_03_F"
							// ,"I_Heli_light_03_unarmed_F"
							// ,"O_Heli_Light_02_unarmed_F"
];

dzn_atc_exitPoint			= 		[0,0,0];	// Pos3d of vehicle exit point (where to vehicles will fly from player). It can be an object - use (getPosASL OBJECT) instead

dzn_atc_useCustomPlacement	=		true; // Allow players to choose spawn point of vehicle directry on the map
dzn_atc_customPlacementMinDist =		300; // Minimum distance from player position to nearest position for custom placement
dzn_atc_customRestrictedLocs	=		[]; // List of locations restricted to spawn vehicles

dzn_atc_placementPoint		=		[0,0,0];	// Pos3d of vehicle spawn point, if custom placement isn't chosen



dzn_atc_pilotsPerSide 		= [
							"B_Helipilot_F"	// West
							,"O_helipilot_F"	// East
							,"I_helipilot_F"	// Indep
							,"C_man_pilot_F"	// Civilian
];

// Custom pilot gear code to execute: _this = unit 
dzn_atc_useCustomerPilotGear		=	false;
dzn_atc_customPilotsGear 		= 	{};







// Init
call compile preProcessFileLineNumbers "dzn_atc\dzn_atc_functions.sqf";
call compile preProcessFileLineNumbers "dzn_atc\dzn_atc_menus.sqf";

if (dzn_atc_onlyLeader) then {
	if (player == leader (group player)) then {
		[player,"dzn_atc_commMenu"] call BIS_fnc_addCommMenuItem;
	};
} else {
	[player,"dzn_atc_commMenu"] call BIS_fnc_addCommMenuItem;
};


if isNil {player getVariable "dzn_atc_openedMenu"} then {
	player setVariable ["dzn_atc_openedMenu", false];	
	["dzn_atc_checkMenu", "onEachFrame", {
		if (player getVariable "dzn_atc_openedMenu") then {
			player setVariable ["dzn_atc_openedMenu", false];
			showCommandingMenu "#USER:dzn_atc_menu";
		};
		
		if !isNil {player getVariable "dzn_atc_called"} then {
			_classname = player getVariable "dzn_atc_called";
			player setVariable ["dzn_atc_called", nil];
			
			_classname call dzn_atc_fnc_callAirTaxi;
		};
	}] call BIS_fnc_addStackedEventHandler;	
};


