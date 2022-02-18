:delay 3

# defaul dns
:global someDns "114.114.114.114"

:global newIP [/ipv6 address get [find interface=bridge advertise=yes] address]
:set newIP [:pick $newIP 0 ([:len $newIP]-3)]

:log info message="ipv6 address found: $newIP"

:global newIpLen [:len $newIP]

if ( $newIpLen > 5 ) do={
    # update dns
    :global newDnsSetting "$newIP,$someDns"
    :log info message="update dns to $newDnsSetting"
    /ip dns set allow-remote-requests=yes servers="$newDnsSetting"
    
}
