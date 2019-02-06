class brownbag::telegraf (
  $influx_host,
  String $database = 'bolt',
  String $username = 'bolt',
  String $password = 'hunter2',
) {

  $influx_url = "http://${influx_host}:8086"


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
