# Overview

This specification contains details on interactions between a digital decanter and remote devices over the HTTP protocol.

A single decanter can be powered by many devices and a device can connect to many devices.


# Best Practices

## Authentication

Any request but the authorization request itself requires providing an access token as a bearer token. To authenticate a request, place the bearer token to the request's header.

To obtain an access token, send a [POST /api/1/device](#tag/Authentication/operation/register_device) request with a secret provided with the decanter on a physical medium.

The workflow of authentication is given in the sequence diagram below.

```mermaid
%%{init: {'theme': 'base', 'themeVariables': { 'activationBorderColor': 'black', 'primaryColor': 'white', 'primaryBorderColor': 'black', 'background': 'white'}}}%%
sequenceDiagram
    actor User
    participant Device
    participant Decanter
    User-)+Device: Secret
    Device-)+Decanter: Secret
    Decanter-)Decanter: Register a new device
    Decanter--)-Device: Access token
    Device--)-User: Decanter paired
```

To revoke an access token, send a [DELETE /api/1/device](l#tag/Authentication/operation/delete_device) request.


## Changing Temperature

To change the temperature of  wine, send a [POST /api/1/temperature](#tag/Temperature/operation/set_temperature) with desired temperature and intensity update reports (optional). The decanter will emit reports on temperature updates and  the final report after the process is complete.

```mermaid
%%{init: {'theme': 'base', 'themeVariables': { 'activationBorderColor': 'black', 'primaryColor': 'white', 'primaryBorderColor': 'black', 'background': 'white', 'noteBkgColor': 'white', 'noteBorderColor': 'black'}}}%%
sequenceDiagram
    actor User
    participant Device
    participant Decanter
    User-)+Device: Temperature
    Device-)+Decanter: Temperature, CallbackUrl URL, [Update rate]
    Decanter-)Decanter: Start temperature change
    Decanter--)-Device: Success report
    Device--)-User: Indication of the change started
    Note over Device,Decanter: Temperature change process
    opt if Update rate is specified
      loop Update rate
      Decanter--)+Device: Update report
      Device--)-User: Indication of temperature
      end
    end
    Decanter--)+Device: Complete report
    Device--)-User: Indication of completion
```


## Decantation

To decant wine, send a [POST /api/1/decantation](#tag/Decantation/operation/start_decantation). The decanter will emit a report after the process is complete.

```mermaid
%%{init: {'theme': 'base', 'themeVariables': { 'activationBorderColor': 'black', 'primaryColor': 'white', 'primaryBorderColor': 'black', 'background': 'white', 'noteBkgColor': 'white', 'noteBorderColor': 'black'}}}%%
sequenceDiagram
    actor User
    participant Device
    participant Decanter
    User-)+Device: Request
    Device-)+Decanter: Request
    Decanter-)Decanter: Start decantation
    Decanter--)-Device: Success report
    Device--)-User: Indication of the decantation started
    Note over Device,Decanter: Decantation process
    Decanter--)+Device: Complete report
    Device--)-User: Indication of completion
```