/* [General Parameters] */
// The name of the battery to generate
Battery_Name = "AA";

// Display all supported battery names?
Display_Battery_Names = false;



/* [Advanced] */
// The value to use for creating the model preview (lower is faster)
Preview_Quality_Value = 32;

// The value to use for creating the final model render (higher is more detailed)
Render_Quality_Value = 128;



include<battery_lib/battery_lib.scad>



module Generate()
{
    echo();
    echo();
    echo();
    echo("-----------------------------------------");
    echo(str("Parameters for a '", Battery_Name, "' battery:"));

    supported = BatteryLib_BatteryNameIsValid(Battery_Name);
    echo(supported=supported);
    if (supported)
    {
        echo(str("Battery Type: ", BatteryLib_Type(Battery_Name)));
        echo(str("Body Diameter: ", BatteryLib_BodyDiameter(Battery_Name)));
        echo(str("Total Diameter: ", BatteryLib_TotalDiameter(Battery_Name)));
        echo(str("Body Width: ", BatteryLib_BodyWidth(Battery_Name)));
        echo(str("Total Width: ", BatteryLib_TotalWidth(Battery_Name)));
        echo(str("Body Length: ", BatteryLib_BodyLength(Battery_Name)));
        echo(str("Total Length: ", BatteryLib_TotalLength(Battery_Name)));
        echo(str("Body Height: ", BatteryLib_BodyHeight(Battery_Name)));
        echo(str("Total Height: ", BatteryLib_TotalHeight(Battery_Name)));
        echo(str("Cathode Diameter: ", BatteryLib_CathodeDiameter(Battery_Name)));
        echo(str("Cathode Height: ", BatteryLib_CathodeHeight(Battery_Name)));
        echo(str("Anode Diameter: ", BatteryLib_AnodeDiameter(Battery_Name)));
        echo(str("Anode Height: ", BatteryLib_AnodeHeight(Battery_Name)));
        echo(str("Terminal Distance: ", BatteryLib_TerminalDistance(Battery_Name)));
        echo(str("Envelope: ", BatteryLib_Envelope(Battery_Name)));

        BatteryLib_GenerateBatteryModel(Battery_Name);
    }
    
    else
    {
        echo(str ("'", Battery_Name, "; is not a supported battery name"));
    }
    
    if (Display_Battery_Names)
    {
        echo(str("All supported rectangular battery names: ", BatteryLib_Valid_Rectangle_Battery_Names));
        echo(str("All supported tube battery names: ", BatteryLib_Valid_Tube_Battery_Names));
        echo(str("All supported button battery names: ", BatteryLib_Valid_Button_Battery_Names));
    }
}



// Global parameters
iota = 0.001;
$fn = $preview ? Preview_Quality_Value : Render_Quality_Value;



// Generate the model
Generate();
