# GUIDTest
Example project that shows how writing to a GUID field on an ArcGIS Server backed by MS SQLServer will fail.

# ERROR description
The error happens when trying to save a feature on a layer which includes a GUID field (eg. referencing a GlobalID field in a related table / layer). It only appears to fail when saving to an ArcGIS server backed by MS Sql Server. I haven't tested this code against a local geodatabase, just two different online layers. I believe this is the same error discussed in https://geonet.esri.com/message/92192, which was fixed in 10.2.3, but it has reappeared in Quartz (v 100.0) for iOS.

# INSTALLATION

Clone (or fork) and run `pod install`. Build and run on simulator or device. The app does not require a hardware device.

# USAGE

The app displays a map. Tapping on a point in the map will give the user to create a feature at the tapped location. The user is prompted to choose which feature service the feature should be saved to. Selecting the 'Working' option will save to a feature service on AGOL (which we believe is backed by PostgreSQL). This will write a GUID string (of the format "{8B4D4B7B-0853-4FB4-8DB1-DB490E5E4808}") to the selected service.

However, selecting the "FAILING" option, will write to a Geodata deployed ArcGIS Server backed by MS SQLServer 2016. Writing the same string to a GUID file on this server will fail. An error description will be printed in the console. No error message will be shown to the user. The error will say "Setting of value for RunarGuid failed" with the error code 400.

For reference, several methods of setting the field are supplied as comments in the code, to show the alternative methods I have tried. All methods will produce the same error.

I hope you are able to discover (and fix) the problem. Please do not hesitate to contact me about questions to the code or the ArcGIS environment.

Runar Svendsen
runar.svendsen@geodata.no
