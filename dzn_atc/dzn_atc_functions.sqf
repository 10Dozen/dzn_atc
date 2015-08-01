//

dzn_atc_fnc_getVehicleDisplayName = {
	// Return display name of given classname of vehicle
	// "B_Heli_Transport_01_camo_F" call dzn_atc_fnc_getVehicleDisplayName
	// 0: STRING 	- classname
	// RETURN:		displayed name
	
	private["_class","_item","_CName", "_DName"];
	
	_class = _this;
	
	_item = (( "configName(_x) == _class") configClasses  (configFile >> "CfgVehicles")) select 0;
	_CName = configName(_item);
	_DName = getText(configFile >> "CfgVehicles" >> _CName >> "displayName");
	
	_DName
};

KK_fnc_setVelocityModelSpaceVisual = {
    private "_o";
    _o = _this select 0;
    _o setVelocity (
        _o modelToWorldVisual (_this select 1) vectorDiff (
            _o modelToWorldVisual [0,0,0]
        )
    );
};

dzn_atc_fnc_getPilotClassByPlayerSide = {
	// Return pilot for player's side
	private ["_id"];
	
	_id = switch (side player) do {
		case west: { 0 };
		case east: { 1 };
		case resistance: { 2 };
		case civilian: { 3 };
	};

	(dzn_atc_pilotsPerSide select _id)
};

dzn_atc_fnc_spawnAirTaxiVehicle = {
	// [@VehicleClass, @Position[ call dzn_atc_fnc_spawnAirTaxiVehicle


};


dzn_atc_fnc_callAirTaxi = {
	if (dzn_atc_useCustomPlacement) then {
		openMap [true, false];
		
		["dzn_atc_clickForSpawn", "onMapSingleClick", {
			if (_pos distance (getPosASL player) < dzn_atc_customPlacementMinDist) exitWith {
				player sideChat format ["Air Taxi Request Cancelled: Too close to player position! Place start point out of %1 m raidus.", dzn_atc_customPlacementMinDist];
			};
			
			private ["_veh","_allowed"];
			
			_allowed = true;
			{
				if (_pos in _x) exitWith {
					_allowed = false;
				};
			} forEach dzn_atc_customRestrictedLocs;
			if !(_allowed) exitWith {
				player sideChat "Air Taxi Request Cancelled: Chosen position is in restricted area!";
			};
			
			
			_veh = createVehicle [_this, _pos, [], 0, "FLY"];			
			_veh setDir ([_veh, player] call BIS_fnc_dirTo);			
			[_veh, [0,20,0]] call KK_fnc_setVelocityModelSpaceVisual;
			
			player moveInDriver _veh;			
			openMap [false, false];
			
			["dzn_atc_clickForSpawn", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
			
			["dzn_atc_noCrewHandler_" + str(round(time)), "onEachFrame", {
				private ["_ehId","_grp","_veh","_newDriver"];
				_ehId = _this select 0;
				_veh = _this select 1;
				
				if (driver _veh != player && canMove _veh) then {
					_grp = createGroup (side player);
					
					_newDriver = _grp createUnit [call dzn_atc_fnc_getPilotClassByPlayerSide, [0,0,0], [], 0, "NONE"];				
					if (dzn_atc_useCustomerPilotGear) then { _newDriver spawn dzn_atc_customPilotsGear; };
					
					_newDriver assignAsDriver _veh;
					_newDriver moveInDriver _veh;				
					
					_newDriver doMove [0,0,0];
					
					[_ehId, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
				};			
			}, ["dzn_atc_noCrewHandler_" + str(round(time)), _veh]] call BIS_fnc_addStackedEventHandler;	
			
			
		}, _this] call BIS_fnc_addStackedEventHandler;
	};
};
