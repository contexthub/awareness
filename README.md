# Awareness (Context Rule) Sample app

The Awareness sample app introduces you to the contextual rule features of the ContextHub Developer Portal.

### Table of Contents

1. **[Purpose](#purpose)**
2. **[ContextHub Use Case](#contexthub-use-case)**
3. **[Background](#background)**
4. **[Getting Started](#getting-started)**
5. **[Setting Up Context Rules](#creating-a-new-context)**
6. **[Triggering a Context](#triggering-a-context)**
7. **[Sample Code](#sample-code)**
8. **[Usage](#usage)**
  - **[Working with Events](#working-with-events)**
  - **[Working with Console](#working-with-console)**
  - **[Working with Beacons](#working-with-beacons)**
  - **[Working with Geofences](#working-with-geofences)**
  - **[Working with Push](#working-with-push)**
  - **[Working with Vault](#working-with-vault)**
  - **[Working with HTTP](#working-with-http)**
  - **[Working with Tick](#working-with-tick)**
9. **[Final Words](#final-words)**

## Purpose
This sample application will show you how to use the provided contextual objects in a context rule via custom events and set off running those context rules via triggered events in the ContextHub SDK

## ContextHub Use Case
In this sample application, we use ContextHub to write context rules in the developer portal so you can learn to interact with the different objects available to you after an event has been triggered. These context rules are triggered by custom events defined by you, the developer, and can be triggered with an API command that allows you to send your own data structures similar to those seen in pre-defined events like beacon_in/beacon_out. This gives you additional flexibility over the payload property as you can define your own events for your own application.

## Background
The heart and true purpose of ContextHub involves creating contextual experiences which can be changed without redeploying your application to the app store, allowing far greater developer flexibility during development. In ContextHub, this power is best expressed in context rules, little snippets of JavaScript which are evaluated when every event is fired and allows for the creation of new contextual elements, send push notification to devices, store data in the vault, log a message to the console or fire a webhook to your own or other web services. You will be shown examples of how to use each of these objects in your own context rules to speed up development when using ContextHub.

## Getting Started
1. Get started by either forking or cloning the Awareness repo. Visit [GitHub Help](https://help.github.com/articles/fork-a-repo) if you need help.
2. Go to [ContextHub](http://app.contexthub.com) and create a new Awareness application.
3. Find the app id associated with the application you just created. Its format looks something like this: `13e7e6b4-9f33-4e97-b11c-79ed1470fc1d`.
4. Open up your Xcode project and put the app id into the `[ContextHub registerWithAppId:]` method call.
5. Build and run the project in the simulator (push features require running on a provisioned iOS device, see [NotifyMe](https://github.com/contexthub/notify-me) sample app on how to setup push notifications).

## Setting Up Context Rules
1. Contexts let you change how the server will respond to events triggered by devices. The real power of ContextHub comes from collecting and reacting these events to perform complex actions. Let's go ahead and create a new context.
2. Click on "Contexts" tab, then click the "New Context" button to start making a new context rule.
3. Included in the Xcode project are several contexts in the `Contexts` folder which contains the context rules needed to make each section work. Go ahead and name this new context "Beacon Event", with an event type "beacon_event", then copy and paste the associated JavaScript into the code text box then click save. Make sure that the event type matches the name of the file exactly, as this is how ContextHub matches events to context rules.
4. Do this for the remaining JavaScript files, and you should have 8 new contexts you just saved in the developer portal.

## Triggering a Context
1. Now back on your device, you should be able to tap on the row "Event" to trigger a custom event.
2. In the developer portal, click on "Contexts" at the top again to refresh the page. You should now see the event you just triggered under "Latest Events". Tap "View" to see the data sent in an event.
3. Inside the popup, you'll see that each event always has a name and associated context package related to the device that sent it.
3. Now back on your device, tap on "Console" and type in a message. This should generate a console_event, which inside the context rule will log a your message to the logs. (Note: there is a CCHLog class which exists which does the same thing without needing a context rule).
4. Click on "Logs" at the top to see your logs. Refresh the page after 5 seconds if you are not seeing this message immediately.
5. The console_event context rule extracts the message sent in the data to be passed to `console.log()` to log a message.
6. You can do the same with beacons, geofences, push, vault, and http. Events will be triggered, causing a context rule to fire, and messages to be logged in the logs section of ContextHub.

## Testing a Context
1. In addition to triggering a context rule from the app, you can also test a context directly in the developer portal.
2. Go to "Contexts", and edit a context rule you have already created.
3. Click on "Test Your Context" to expand the test area which will show a list of your latest events as well as a box with the latest event.
4. Click on an event to have it appear in the box next to it.
5. Then click "Test" to have the context execute. You will then see either "true" indicating it was executed successfully or an error message from how the context rule was written or the result of the context.
6. Testing your context makes it possible to debug changes to your rule before saving them for production.

## Sample Code
In this sample, each view controller calls `{[CCHSensorPipeline sharedInstance] triggerEvent:]` with custom data to trigger a custom event to be fired in ContextHub, which when paired with a matching context rule with the same event type, causes that context rule to be evaluated. Events fired in this manner have a data field filled with your JSON-serializable data structure, along with the usual context package detailing information about the device which generated the event. A context rule is then evaluated with either a `true` indicating everything worked ok or an error message if the rule was written incorrectly.

## Usage

##### Working with Events
```javascript
// Accessing event data
var eventName = event.name
var eventData = event.data
var eventPayload = event.payload
var eventCreatedAt = event.createdAt

// Accessing data about device that generated the event
var deviceName = event.context[2].device_context.name
var deviceID = event.context[2].device_context.device_id
var deviceType = event.context[2].device_context.type
var deviceModel = event.context[2].device_context.model
var systemName = event.context[2].device_context.system_name
var systemVersion = event.context[2].device_context.system_version
```

##### Working with Console
```javascript
// Logging a message
console.log("This is a console message")
```

##### Working with Beacons
##### Creating
```javascript
// Creating a beacon
var newBeacon = {}
newBeacon.name = "New beacon"
newBeacon.uuid = "7EA016FB-B7C4-43B0-9FCC-AAB391AE1722"
newBeacon.major = 100
newBeacon.minor = 1
newBeacon.tags = "beacon-tag"
beacon.create(newBeacon.tags, newBeacon.name, newBeacon.uuid, newBeacon.major, newBeacon.minor)
console.log("Created beacon '" + newBeacon.name + "'")
```

##### Retrieving by tag
```javascript
// Retrieving a beacon by tags
var beaconsFoundByTag = beacon.tagged("beacon-tag")

if (beaconsFoundByTag.length > 0) {
    var firstBeacon = beaconsFoundByTag[0]
    
    if (firstBeacon) {
        console.log("Listing data from first beacon with tag 'beacon-tag'")
        console.log("Found by 'beacon-tag' beacon id: " + firstBeacon.id)
        console.log("Found by 'beacon-tag' beacon name: " + firstBeacon.name)
        console.log("Found by 'beacon-tag' beacon UUID: " + firstBeacon.uuid)
        console.log("Found by 'beacon-tag' beacon major: " + firstBeacon.major)
        console.log("Found by 'beacon-tag' beacon minor: " + firstBeacon.minor)
        console.log("Found by 'beacon-tag' beacon tags: " + firstBeacon.tags)
    }
}
```

##### Retrieving by ID
```javascript
// Retrieving a beacon by ID
var beaconID = 1500
var beaconFoundByID = beacon.find(beaconID)
        
if (beaconFoundByID) {
    console.log("Listing data from beacon with id: " + beaconID)
    console.log("Found by 'ID' beacon name: " + beaconFoundByID.name)
    console.log("Found by 'ID' beacon UUID: " + beaconFoundByID.uuid)
    console.log("Found by 'ID' beacon major: " + beaconFoundByID.major)
    console.log("Found by 'ID' beacon minor: " + beaconFoundByID.minor)
    console.log("Found by 'ID' beacon tags: " + beaconFoundByID.tags)
}
```

##### Updating
```javascript
// Updating a beacon
var beaconID = 1500
var updatedBeacon = {}
updatedBeacon.name = "Update beacon"
updatedBeacon.uuid = "E004D972-7BB7-47C8-9DCE-E091CB103500"
updatedBeacon.major = 200
updatedBeacon.minor = 2
updatedBeaconTags = "beacon-tag,beacon2-tag"
beacon.update(beaconID, JSON.stringify(updatedBeacon), updatedBeaconTags)
```

##### Deleting
```javascript
// Deleting a beacon
var beaconID = 1500
beacon.destroy(beaconID)
```

##### Working with Geofences
##### Creating
```javascript
// Creating a geofence
var newGeofence = {}
newGeofence.name = "New geofence"
newGeofence.latitude = 29
newGeofence.longitude = -95
newGeofence.radius = 500
newGeofence.tags = "geofence-tag"
geofence.create(newGeofence.tags, newGeofence.name, newGeofence.latitude, newGeofence.longitude, newGeofence.radius)
```

##### Retrieving by tag
```javascript
// Retrieving a geofence by tags
var geofencesFoundByTag = geofence.tagged("geofence-tag")

if (geofencesFoundByTag > 0) {
    var firstGeofence = geofencesFoundByTag[0]
    
    if (firstGeofence) {
        console.log("Found by 'geofence-tag' geofence name: " + firstGeofence.name)
        console.log("Found by 'geofence-tag' geofence latitude: " + firstGeofence.latitude)
        console.log("Found by 'geofence-tag' geofence longitude: " + firstGeofence.longitude)
        console.log("Found by 'geofence-tag' geofence radius: " + firstGeofence.radius)
        console.log("Found by 'geofence-tag' geofence tags: " + firstGeofence.tags)
    }
}
```

##### Retrieving by ID
```javascript
// Retrieving a geofence by ID
var geofenceID = 1500
var geofenceFoundbyID = geofence.find(geofenceID)
        
if (beaconFoundByID) {
    console.log("Found by 'geofence-tag' geofence name: " + geofenceFoundbyID.name)
    console.log("Found by 'geofence-tag' geofence latitude: " + geofenceFoundbyID.latitude)
    console.log("Found by 'geofence-tag' geofence longitude: " + geofenceFoundbyID.longitude)
    console.log("Found by 'geofence-tag' geofence radius: " + geofenceFoundbyID.radius)
    console.log("Found by 'geofence-tag' geofence tags: " + geofenceFoundbyID.tags)
}
```

##### Updating
```javascript
// Updating a geofence
var geofenceID = 1500
var updatedGeofence = {}
updatedGeofence.name = "Updated geofence"
updatedGeofence.latitude = -28
updatedGeofence.longitude = 90
updatedGeofence.radius = 1000
updatedGeofenceTags = "geofence-tag,geofence2-tag"
geofence.update(geofenceID, JSON.stringify(updatedGeofence), updatedGeofenceTags)
```

##### Deleting
```javascript
// Deleting a geofence
var geofenceID = 1500
geofence.destroy(geofenceID)
```

##### Working with Push
##### Sending Foreground Push
```javascript
// Sending foreground pushes via different identifiers
var token = "71962e3cbc7dfa91e8bec21b532b69c211a55453a1407299bb78f931c7e8f7ec"
var deviceId = "BC903204-51C1-4DF6-92E8-F5A5DE00E26E"
var alias = "Jeff's iPhone 5"
var arrayOfTags = = new Array()
arrayOfTags.push("device-tag")

// Sending foreground push via token
push.sendToToken(token, "Sending message using token")

// Sending foreground push via device id
push.sendToDeviceId(deviceId, "Sending message using device id")

// Sending foreground push via alias
push.sendToAlias(alias, "Sending message using alias")

// Sending foreground push via tags
push.sendToTags(arrayOfTags, "Sending message using tags")
```

##### Sending Background Push
```javascript
// Sending background pushes via different identifiers
var token = "71962e3cbc7dfa91e8bec21b532b69c211a55453a1407299bb78f931c7e8f7ec"
var deviceId = "BC903204-51C1-4DF6-92E8-F5A5DE00E26E"
var alias = "Jeff's iPhone 5"
var arrayOfTags = = new Array()
arrayOfTags.push("device-tag")

var data = { "payload": {"age": "25", "height": "6.25"} }
var sound = ""

// Sending background push via token
push.sendBackgroundToToken(token, JSON.stringify(data), sound)

// Sending background push via device id
push.sendBackgroundToDeviceId(deviceId, JSON.stringify(data), sound)

// Sending background push via alias
push.sendBackgroundToAlias(alias, JSON.stringify(data), sound)

// Sending background push via tags
push.sendBackgroundToTags(arrayOfTags, JSON.stringify(data), sound)
```

##### Working with Vault
##### Creating
```javascript
// Creating a vault item
var newVaultItem = {}
newVaultItem.name = "Michael Austin"
newVaultItem.currentPosition = "Account Executive"
newVaultItem.height = "6.42"
newVaultItem.age = "36"
newVaultItem.nicknames = ["The Closer", "The Warrior", "Catcher of Big Fish"]
newVaultItem.kids = {"Jason": "6", "Molly": "5"}
var newVaultItemTags = "vault-tag"
vault.create(JSON.stringify(newVaultItem), newVaultItemTags)
```

##### Retrieving by tag
```javascript
// Retrieving a vault item by tags
var vaultItemsFoundByTag = vault.tagged("vault-tag")

if (vaultItemsFoundByTag.length > 0) {
    var firstVaultItem = vaultItemsFoundByTag.length[0]
    
    if (firstVaultItem) {
        console.log("Listing data from first vault item with tag 'vault-tag'")
        console.log("Found by 'vault-tag' vault name: " + firstVaultItem.data.name)
        console.log("Found by 'vault-tag' vault id: " + firstVaultItem.vault_info.id)
        console.log("Found by 'vault-tag' vault currentPosition: " + firstVaultItem.data.currentPosition)
        console.log("Found by 'vault-tag' vault height: " + firstVaultItem.data.height)
        console.log("Found by 'vault-tag' vault age: " + firstVaultItem.data.age)
        console.log("Found by 'vault-tag' vault nicknames: " + firstVaultItem.data.nicknames)
        console.log("Found by 'vault-tag' vault kids: " + JSON.stringify(firstVaultItem.data.kids))
        console.log("Found by 'vault-tag' vault tags: " + firstVaultItem.vault_info.tags)
    }
}
```

##### Retrieving by ID
```javascript
// Retrieving a vault item by ID
var vaultItemID = "EEAC6622-DA55-410A-9E31-99D2840D11DA"
var vaultItemFoundByID = vault.find(vaultItemID)

if (vaultItemFoundByID) {
    console.log("Found by 'ID' vault name: " + vaultItemFoundByID.data.name)
    console.log("Found by 'ID' vault id: " + vaultItemFoundByID.vault_info.id)
    console.log("Found by 'ID' vault currentPosition: " + vaultItemFoundByID.data.currentPosition)
    console.log("Found by 'ID' vault height: " + vaultItemFoundByID.data.height)
    console.log("Found by 'ID' vault age: " + vaultItemFoundByID.data.age)
    console.log("Found by 'ID' vault nicknames: " + vaultItemFoundByID.data.nicknames)
    console.log("Found by 'ID' vault kids: " + JSON.stringify(vaultItemFoundByID.data.kids))
    console.log("Found by 'ID' vault tags: " + vaultItemFoundByID.vault_info.tags)
}
```

##### Updating
```javascript
// Updating a vault item
var vaultItemID = "EEAC6622-DA55-410A-9E31-99D2840D11DA"
var updatedVaultItem = {}
updatedVaultItem.name = "Jim Houston"
updatedVaultItem.currentPosition = "CIO"
updatedVaultItem.height = "5.82"
updatedVaultItem.age = "41"
updatedVaultItem.nicknames = ["All Knowing", "Watch Dog"]
updatedVaultItem.kids = {"Madison": "8", "Amelia": "7"}
updatedVaultItemTags = "vault-tag,vault2-tag"
vault.update(vaultItemID, JSON.stringify(updatedVaultItem), updatedVaultItemTags)
```

##### Deleting
```javascript
// Deleting a vault item
var vaultItemID = "EEAC6622-DA55-410A-9E31-99D2840D11DA"
vault.destroy(vaultItemID)
```

##### Contains
```javascript
// Retrieving an item that contains a value
var containsValue = "Michael"
var vaultFoundByContainsArray = vault.contains(containsValue)
        
if (vaultFoundByContainsArray.length > 0) {
    var vaultItemFoundByContains = vaultFoundByContainsArray[0]
    
    if (vaultItemFoundByContains) {
        console.log("Found by 'contains' vault name: " + vaultItemFoundByContains.data.name)
        console.log("Found by 'contains' vault currentPosition: " + vaultItemFoundByContains.data.currentPosition)
        console.log("Found by 'contains' vault height: " + vaultItemFoundByContains.data.height)
        console.log("Found by 'contains' vault age: " + vaultItemFoundByContains.data.age)
        console.log("Found by 'contains' vault nicknames: " + vaultItemFoundByContains.data.nicknames)
        console.log("Found by 'contains' vault kids: " + JSON.stringify(vaultItemFoundByContains.data.kids))
        console.log("Found by 'contains' vault tags: " + vaultItemFoundByContains.vault_info.tags)
    } else {
        console.log("Could not get first vault item from vaultFoundByContainsArray")
    }
}
```

##### KeyPath
```javascript
// Retrieving an item with a matching key path
var key_path = "name"
var value = "Jim Houston"
var vaultFoundByKeyPathArray = vault.key_path(key_path, value)

if (vaultFoundByKeyPathArray.length > 0) {
    var vaultItemFoundByKeyPath = vaultFoundByKeyPathArray[0]
    
    if (vaultItemFoundByKeyPath) {
        console.log("Found by 'key_path' vault name: " + vaultItemFoundByKeyPath.data.name)
        console.log("Found by 'key_path' vault currentPosition: " + vaultItemFoundByKeyPath.data.currentPosition)
        console.log("Found by 'key_path' vault height: " + vaultItemFoundByKeyPath.data.height)
        console.log("Found by 'key_path' vault age: " + vaultItemFoundByKeyPath.data.age)
        console.log("Found by 'key_path' vault nicknames: " + vaultItemFoundByKeyPath.data.nicknames)
        console.log("Found by 'key_path' vault kids: " + JSON.stringify(vaultItemFoundByKeyPath.data.kids))
        console.log("Found by 'key_path' vault tags: " + vaultItemFoundByKeyPath.vault_info.tags)
    } else {
        console.log("Could not get first vault item from vaultFoundByKeyPathArray")
    }
} else {
    console.log("No vault items exist in vault at key_path " + key_path + " with value " + value)
}
```

##### Working with HTTP
##### HTTP GET
```javascript
// Send a HTTP GET request
var getURL = "http://requestb.in/vx1hdkvx"
var getURLParams = { "message": "get message from http webhook!" }
http.get(getURL, JSON.stringify(getURLParams))
```

##### HTTP POST
```javascript
// Send a HTTP POST request
var postURL = "http://requestb.in/vx1hdkvx"
var postBody = { "message": "post message from http webhook!" }
var postHeaders = { "Content-Type": "application/json"}
http.post(postURL, JSON.stringify(postBody), JSON.stringify(postHeaders))
```

##### Working With Tick
```javascript
// Event type: "tick"
// Context rule is automatically executed once every minute
console.log("Tick!")
```

## Final Words

That's it! Hopefully this sample application showed you that working with context rules in ContextHub can lead to more contextually aware applications in a shorter period of development time.