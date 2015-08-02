// MENU
waitUNtil {time  > 1 };

private["_unitName","_menuLine"];

dzn_atc_menu = [["Air Taxi Call",false]];

{
	_unitName = _x call dzn_atc_fnc_getVehicleDisplayName;
	_menuLine = [ 
		_unitName
		,[(2 + _forEachIndex)]
		,""
		,-5
		,[["expression", format ['player setVariable ["dzn_atc_called", "%1"];', _x] ]]
		,"1"
		,"1"
	];
	dzn_atc_menu pushBack _menuLine;	
} forEach dzn_atc_vehiclesList;
