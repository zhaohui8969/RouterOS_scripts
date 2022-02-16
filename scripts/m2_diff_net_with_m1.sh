:global m1Net [/ip address get [/ip address find where interface=pppoe-m1 ] network]
:put "m1 net $m1Net"
/interface pppoe-client enable [/interface pppoe-client find where name=pppoe-m2]
:delay 10
:global m2Net [/ip address get [/ip address find where interface=pppoe-m2 ] network]
:put "m2 net $m2Net"
:global retryCount 0
:global netSame
:set netSame ($m1Net = $m2Net)
:global exitLoop (! $netSame)
:while (! $exitLoop) do={
    :put same
    /interface pppoe-client enable [/interface pppoe-client find where name=pppoe-m2]
    :set retryCount ($retryCount + 1)
    :delay 10
    :set m2Net [/ip address get [/ip address find where interface=pppoe-m2 ] network]
    :put "m2 net $m2Net"
    :set netSame ($m1Net = $m2Net)
    :set exitLoop (! $netSame)
    :if ($retryCount > 10) do={
        :put "no more retry"
        :set exitLoop true
    }
}
