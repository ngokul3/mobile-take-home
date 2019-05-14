## Resource File populate

Resource files  routes.csv, airport.csv and airline.csv are manually converted to JSON. These JSON files are added as resource to Xcode. Name of these resource files are configuratble in plist. Code looks at plist in the runtime and populates the corresponding model objects.

## Airport Code / Name search controller

User can enter airport code if he known or, can look up airport by clicking lens image in the text field. This will take user to AirportLocationViewController. This ViewController has option to search by Airport code or Airport name.


## Map View Controller

On select of a code from AirportLocationVC, airport code is populated into corresponding From or To text field. 
User can enter airport code in lower or upper case.

## Data Structure

Lazy property airportGraph will frame Graph object in the runtime. This happens lazily, and also comes with an advantage that graph object constructed only once. 


## Shortest Route

Program uses Dijkstra's algorithm to calculate shortest route.

## Unit Tests

Please check unit tests to run through different cases. 
