https://support.xbox.com/en-US/help/hardware-network/connect-network/server-connectivity-xbox-app-displays-blocked  

Install the XBox console companion so you can verify the actual network status  
These are also available vis the MS Store and via the Xbox App (once you have installed that one)
```
 winget install --name "Xbox Console Companion"
 winget install --name "Xbox"
 winget install --name "Xbox Identity Provider"
 winget install --name "Xbox TCUI"
 ```
 
 Open `Xbox Console Compantion` (not the XBox app) and go to  
 `Settings 'gear' icon => Network`
 

Enable the adapter and set it to the currently known good teredo server
```
netsh int teredo set state enterpriseclient win1910.ipv6.microsoft.com 
```

If teredo is enabled properly you'll see
```
netsh int teredo show state
Teredo Parameters
---------------------------------------------
Type                    : enterpriseclient
Server Name             : win1910.ipv6.microsoft.com.
Client Refresh Interval : 30 seconds
Client Port             : unspecified
State                   : qualified
Client Type             : teredo client
Network                 : managed
NAT                     : cone
NAT Special Behaviour   : UPNP: Yes, PortPreserving: Yes
Local Mapping           : 192.168.0.218:52865
External NAT Mapping    : 23.88.128.149:52865
```

Now set the services that XBox multiplayer depends on on via `services.msc`
```
Service name	Default startup type
IKE and AuthIP IPsec Keying Modules | Automatic (Delayed Start)
IP Helper                           | Automatic
Xbox Live Auth Manager              | Manual
Xbox Live Networking Service        | Manual
```

You are done when you see in `Xbox Console Compantion :: Settings :: Network` that
* Xbox Multiplayer :: NAT type :: Open
* Xbox Multiplayer :: Server Connectivity :: Connected
