plan brownbag::server (
  TargetSpec $nodes,
  String $database = 'bolt',
  String $username = 'bolt',
  String $password = 'hunter2',
) {

  $influx_host = get_targets('graf')[0].name
  $influx_url = "http://${influx_host}:8086"

  apply_prep($nodes)

  return apply($nodes) {
    class { 'telegraf':
      hostname => $facts['hostname'],
      outputs  => {
          'influxdb' => [
              {
                  'urls'     => [ $influx_url ],
                  'database' => $database,
                  'username' => $username,
                  'password' => $password,
              }
          ]
      },
    }

    telegraf::input{ 'cpu':
      options => [{ 'percpu' => true, 'totalcpu' => true, }]
    }

    ['disk', 'io', 'net', 'swap', 'system', 'mem', 'processes', 'kernel' ].each |$plug| {
      telegraf::input{ $plug:
       options => [{}]}
    }
  }

}


