class brownbag::telegraf (
  String $influx_host,
  String $password = $brownbag::params::influxdb_password,
  String $database = $brownbag::params::influxdb_database,
  String $username = $brownbag::params::influxdb_user,
) inherits ::brownbag::params {

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
