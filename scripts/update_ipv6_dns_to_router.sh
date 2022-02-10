
:delay 3

# defaul dns
:global someDns "114.114.114.114"

:global newIP [/ipv6 address get [find interface=bridge advertise=yes] address]
:set newIP [:pick $newIP 0 ([:len $newIP]-3)]

:log info message="ipv6 address found: $newIP"

:global newIpLen [:len $newIP]

:global PREFIX2IP6 do={
    :return [:toip6 [:pick $1 0 [:find $1 "/" 0]]];
};

if ( $newIpLen > 5 ) do={
    # update dns
    :global newDnsSetting "$someDns,$newIP"
    :log info message="update dns to $newDnsSetting"
    /ip dns set allow-remote-requests=yes servers="$newDnsSetting"
    
    # update firewall rules
    /ipv6 firewall address-list remove [/ipv6 firewall address-list find list="script_insite_allow"]

    # get new ipv6 prefix 
    :global newIpV6Prefix [/ipv6 pool get [find name=ipv6] prefix]

    # get user conf allow site UIE-64
    :global userConfUIEList [/ipv6 firewall address-list find list="user_conf_allow_site_UIE" disabled=no]

    :foreach eachConfUIE in=$userConfUIEList do={
        :global newSiteIpV6Addr ([$PREFIX2IP6 $newIpV6Prefix] | [$PREFIX2IP6 [/ipv6 firewall address-list get $eachConfUIE address]])
        :log info message="add firewall rule allow for site $newSiteIpV6Addr"
        /ipv6 firewall address-list add list=script_insite_allow address=$newSiteIpV6Addr
    }
}
