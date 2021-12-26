// Battery modeling library
//
// Simplifies (for me, anyway) generating models of and for common battery types.
//
// Share and enjoy!
//
// 27 Mar 2021 - Brad Kartchner - v1.0
//  Supports standard tube and rectangle batteries.
//
// 18 Apr 2021 - Brad Kartchner - v1.1
// Added support for many common button batteries and cleaned up the implementation

include<tabletools_lib/tabletools_lib.scad>

// Include battery parameter files
include<battery_parameters/button_batteries.scad>
include<battery_parameters/rectangle_batteries.scad>
include<battery_parameters/tube_batteries.scad>



// These battery dimensions are based mostly on dimensions found in Wikipedia
// articles for each battery, along with some actual measurements.  They're
// accurate for the batteries I have, but may need some tweaking to account
// for variations between manufacturers.
BATTERYLIB_BATTERY_PARAMETERS =
concat
(
    BATTERYLIB_TUBE_BATTERY_PARAMETERS,
    BATTERYLIB_RECTANGLE_BATTERY_PARAMETERS,
    BATTERYLIB_BUTTON_BATTERY_PARAMETERS
);

BatteryLib_Valid_Battery_Names = [ for (x = BATTERYLIB_BATTERY_PARAMETERS) x[0] ];

// This is a bit of a hack.  It would be nice if this was calculated 
// automatically, but I'm not smart enough to figure that out
BatteryLib_Valid_Battery_Types = 
[
    "button",
    "rectangle",
    "tube",
];



// Checks if a given battery name is recognized by the library
// Returns true if it is, false otherwise
function BatteryLib_BatteryNameIsValid(battery_name) =
    TableToolsLib_Lookup(battery_name, BATTERYLIB_BATTERY_PARAMETERS) != undef;



// Generate a model of a specified battery
module BatteryLib_GenerateBatteryModel(battery_name)
{
    // Tube batteries
    if (BatteryLib_Type(battery_name) == "tube")
        _BatteryLib_GenerateTubeBattery(battery_name);
    
    // Rectangle batteries
    else if (BatteryLib_Type(battery_name) == "rectangle")
        _BatteryLib_GenerateRectangleBattery(battery_name);

    // Anything else is assumed to be a button battery
    // (invalid battery types will automatically be caught and reported)
    else
        _BatteryLib_GenerateButtonBattery(battery_name);
}



// Retrieve the type of a specified battery
function BatteryLib_Type(battery_name) =
    _BatteryLib_ReturnIfBatteryNameIsValid(battery_name, TableToolsLib_Lookup("type", TableToolsLib_Lookup(battery_name, BATTERYLIB_BATTERY_PARAMETERS)));



// Retrieve the body diameter of a specified battery
// This really only applies to tube and button batteries
// For rectangle batteries, the larger of the width and length dimensions is
// returned
function BatteryLib_BodyDiameter(battery_name) =
    BatteryLib_Type(battery_name) == "tube" || BatteryLib_Type(battery_name) == "button"
        ? _BatteryLib_RetrieveParameter(battery_name, "diameter")
        : max(BatteryLib_BodyWidth(battery_name), BatteryLib_BodyLength(battery_name));



// Retrieve the diameter of a specified battery
// This is just syntactic sugar for the previous function
function BatteryLib_Diameter(battery_name) =
    BatteryLib_BodyDiameter(battery_name);



// Retrieve the width of a specified battery
function BatteryLib_BodyWidth(battery_name) =
    BatteryLib_Type(battery_name) == "tube" || BatteryLib_Type(battery_name) == "button" 
        ? _BatteryLib_RetrieveParameter(battery_name, "diameter")
        : _BatteryLib_RetrieveParameter(battery_name, "width");



// Retrieve the width of a specified battery
// For now, this is just syntactic sugar for the previous function
function BatteryLib_TotalWidth(battery_name) =
    BatteryLib_BodyWidth(battery_name);



// Retrieve the length (in the y dimension) of a specified battery
function BatteryLib_BodyLength(battery_name) =
    BatteryLib_Type(battery_name) == "tube" || BatteryLib_Type(battery_name) == "button"
        ? _BatteryLib_RetrieveParameter(battery_name, "diameter") 
        : _BatteryLib_RetrieveParameter(battery_name, "length");



// Retrieve the body height (in the z dimension) of a specified battery
function BatteryLib_BodyHeight(battery_name) =
        _BatteryLib_RetrieveParameter(battery_name, "height");



// Retrieve the total height of a specified battery (including the anode and
// cathode)
function BatteryLib_TotalHeight(battery_name) =
    BatteryLib_Type(battery_name) == "tube" 
        ? BatteryLib_BodyHeight(battery_name) + BatteryLib_AnodeHeight(battery_name) + BatteryLib_CathodeHeight(battery_name) 
        : BatteryLib_Type(battery_name) == "rectangle" 
            ? BatteryLib_BodyHeight(battery_name) + max(BatteryLib_AnodeHeight(battery_name), BatteryLib_CathodeHeight(battery_name))
            : BatteryLib_BodyHeight(battery_name);



// Retrieve the diameter of the cathode of a specified battery
function BatteryLib_CathodeDiameter(battery_name) =
    BatteryLib_Type(battery_name) == "tube" || BatteryLib_Type(battery_name) == "rectangle" 
        ? _BatteryLib_RetrieveParameter(battery_name, "cathode diameter") 
        : _BatteryLib_RetrieveParameter(battery_name, "diameter");



// Retrieve the height of the cathode of a specified battery
function BatteryLib_CathodeHeight(battery_name) =
    BatteryLib_Type(battery_name) == "tube" || BatteryLib_Type(battery_name) == "rectangle" 
        ? _BatteryLib_RetrieveParameter(battery_name, "cathode height") 
        : 0;



// Retrieve the diameter of the anode of a specified battery
function BatteryLib_AnodeDiameter(battery_name) =
    BatteryLib_Type(battery_name) == "tube" || BatteryLib_Type(battery_name) == "rectangle" 
        ? _BatteryLib_RetrieveParameter(battery_name, "anode diameter") 
        : _BatteryLib_RetrieveParameter(battery_name, "diameter");



// Retrieve the height of the anode of a specified battery
function BatteryLib_AnodeHeight(battery_name) =
    BatteryLib_Type(battery_name) == "tube" || BatteryLib_Type(battery_name) == "rectangle" 
        ? _BatteryLib_RetrieveParameter(battery_name, "anode height") 
        : 0;



// Retrieve the horizontal distance between the anode and cathode of a
// specified battery
// This really only applies to rectangle (e.g. 9V) batteries
// For tube and button batteries, this just returns the body height as a sort of sane
// alternative
function BatteryLib_TerminalDistance(battery_name) =
    BatteryLib_Type(battery_name) == "rectangle"
        ? _BatteryLib_RetrieveParameter(battery_name, "terminal distance")
        : BatteryLib_Body_Height(battery_name);



// Retrieve the dimensions of the dimensions of a cube completely enveloping
// a specified battery [x, y, z]
function BatteryLib_Envelope(battery_name) =
    [BatteryLib_Width(battery_name), BatteryLib_Length(battery_name), BatteryLib_Height(battery_name)];






//-----------------------------------------------------------------------------
// "Private" functions



// Retrieve the parameters specific to a specified battery
function _BatteryLib_RetrieveParameter(battery_name, key) =
	_BatteryLib_ReturnIfBatteryNameIsValid(battery_name, TableToolsLib_Lookup(key, TableToolsLib_Lookup(battery_name, BATTERYLIB_BATTERY_PARAMETERS)));



// Return the specified value if the battery name is valid
function _BatteryLib_ReturnIfBatteryNameIsValid(battery_name, value) =
    BatteryLib_BatteryNameIsValid(battery_name)
    ? value
    : assert(false, str("Battery name \"", battery_name, "\" is not currently supported by battery_lib"));
