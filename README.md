Battery Library for OpenSCAD
Created by Brad Kartchner (kartchnb@gmail.com)

This library is designed to make it easier to create designs incorporating 
common batteries.

Currently, batteries are organized in three separate "types":
   1) "Tube" batteries (e.g. AA, C, D, 18650, etc)
   2) "Rectangle" batteries (currently, ony 9V batteries)
   3) "Button", coin, or watch batteries (e.g. CR2032, AG4, etc)

Methods are provided to access dimensions for the batteries and to generate
models of them.



-------------------------------------------------------------------------------
METHODS
The library provides the following methods:

BatteryLib_GenerateBatteryModel(battery_name)
   Generates a model of the specified battery.



-------------------------------------------------------------------------------
FUNCTIONS
The library provides the following functions:

BatteryLib_BatteryNameIsValid(battery_name)
   Returns true if the battery name supplied is supported by the library.

BatteryLib_Type(battery_name)
   Returns the "type" of the specified battery 
   (currently "tube", "rectangle", or "button").

BatteryLib_BodyDiameter(battery_name)
   Returns the diameter of the specified battery.
   For tube and button batteries, this is simply the diameter of the battery body.
   For rectangle batteries, this is the larger of the body width or length.

BatteryLib_TotalDiameter(battery_name)
   Synonym for BatteryLib_BodyDiameter().  Not sure why.

BatteryLib_BodyWidth(battery_name)
   Returns the width of the battery body.
   For rectangle batteries, this is the width of the battery body.
   For tube and button batteries, this is the body diameter.

BatteryLib_TotalWidth(battery_name)
   Returns the total outside width of the battery.
   This is currently a synonym for BatteryLib_BodyWidth().

BatteryLib_BodyLength(battery_name)
   Returns the length of the battery body.
   For rectangle batteries, this is the length of the battery body.
   For tube and button batteries, this is the body diameter.
   
BatteryLib_TotalLength(battery_name)
    Returnes the total length of the battery body

BatteryLib_BodyHeight(battery_name)
   Returns the height of the battery body.

BatteryLib_TotalHeight(battery_name)
   Returns the total height of the battery, including anode and cathode.

BatteryLib_CathodeDiameter(battery_name)
   Returns the diameter of the cathode of the battery.

BatteryLib_CathodeHeight(battery_name)
   Returns the height of the cathode of the battery.

BatteryLib_AnodeDiameter(battery_name)
   Returns the diameter of the anode of the battery.

BatteryLib_AnodeHeight(battery_name)
   Returns the height of the anode of the battery.

BatteryLib_TerminalDistance(battery_name)
   For rectangle batteries, this returns the horizontal distance between the 
   center of the anode and cathode of the battery.
   For tube and button batteries, it simply returns the body height of the battery.

BatteryLib_Envelope(battery_name)
   Returns a cubic envelope that completely encompasses the specified battery
   (as [X, Y, Z]).


-------------------------------------------------------------------------------
VARIABLES

The current library version can be retrieved, as a string, with the following variable:

BatteryLib_Version



The names of the batteries supported by this library can be retrieved by accessing 
the following variables

BatteryLib_Valid_Battery_Names - All valid battery names

BatteryLib_Valid_Button_Battery_Names - All valid button battery names

BatteryLib_Valid_Rectangle_Battery_Names - All valid rectangle battery names

BatteryLib_Valid_Tube_Battery_Names - All valid tube battery names

These can easily be displayed using echo() and str()
for example:
   echo(str("All supported battery names: ", BatteryLib_Valid_Battery_Names));