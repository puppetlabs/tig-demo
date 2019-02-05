plan brownbag::server (
  TargetSpec $nodes,
  String $influx_url = 'http://d65ysovmaoaff97.delivery.puppetlabs.net:8086',
  String $database = 'bolt',
  String $username = 'bolt',
  String $password = 'hunter2',
) {

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
      options => [{
                  'percpu'   => true,
                  'totalcpu' => true,
      }]
    }

    telegraf::input{ 'disk': }
    telegraf::input{ 'io': }
    telegraf::input{ 'net': }
    telegraf::input{ 'swap': }
    telegraf::input{ 'system': }


  }
}


