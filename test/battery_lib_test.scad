/* [General Parameters] */
// The names of the battery to generate
Battery_Names = ["AA", "9V", "CR2032"];

// Display all supported battery names?
Display_Battery_Names = false;



/* [Advanced] */
// The value to use for creating the model preview (lower is faster)
Preview_Quality_Value = 32;

// The value to use for creating the final model render (higher is more detailed)
Render_Quality_Value = 128;



include<battery_lib/battery_lib.scad>



module Generate(index=0)
{
    battery_name = Battery_Names[index];
    
    echo();
    echo();
    echo();
    echo("-----------------------------------------");
    echo(str("Parameters for a '", battery_name, "' battery:"));

    supported = BatteryLib_BatteryNameIsValid(battery_name);
    echo(supported=supported);
    if (supported)
    {
        echo(str("Battery Type: ", BatteryLib_Type(battery_name)));
        echo(str("Body Diameter: ", BatteryLib_BodyDiameter(battery_name)));
        echo(str("Total Diameter: ", BatteryLib_TotalDiameter(battery_name)));
        echo(str("Body Width: ", BatteryLib_BodyWidth(battery_name)));
        echo(str("Total Width: ", BatteryLib_TotalWidth(battery_name)));
        echo(str("Body Length: ", BatteryLib_BodyLength(battery_name)));
        echo(str("Total Length: ", BatteryLib_TotalLength(battery_name)));
        echo(str("Body Height: ", BatteryLib_BodyHeight(battery_name)));
        echo(str("Total Height: ", BatteryLib_TotalHeight(battery_name)));
        echo(str("Cathode Diameter: ", BatteryLib_CathodeDiameter(battery_name)));
        echo(str("Cathode Height: ", BatteryLib_CathodeHeight(battery_name)));
        echo(str("Anode Diameter: ", BatteryLib_AnodeDiameter(battery_name)));
        echo(str("Anode Height: ", BatteryLib_AnodeHeight(battery_name)));
        echo(str("Terminal Distance: ", BatteryLib_TerminalDistance(battery_name)));
        echo(str("Envelope: ", BatteryLib_Envelope(battery_name)));

        x_offset = BatteryLib_TotalWidth(battery_name)/2;
        translate([x_offset, 0, 0])
            BatteryLib_GenerateBatteryModel(battery_name);
    }
    
    else
    {
        echo(str ("'", battery_name, "; is not a supported battery name"));
    }
    
    if (index < len(Battery_Names) - 1)
    {
        x_offset = BatteryLib_TotalWidth(battery_name) + 10;
        translate([x_offset, 0, 0])
        Generate(index + 1);
    }
}



// Global parameters
iota = 0.001;
$fn = $preview ? Preview_Quality_Value : Render_Quality_Value;



// Generate the model
Generate();
    
if (Display_Battery_Names)
{
    echo(str("All supported rectangular battery names: ", BatteryLib_Valid_Rectangle_Battery_Names));
    echo(str("All supported tube battery names: ", BatteryLib_Valid_Tube_Battery_Names));
    echo(str("All supported button battery names: ", BatteryLib_Valid_Button_Battery_Names));
}
