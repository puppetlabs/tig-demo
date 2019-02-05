plan brownbag::dashboard (TargetSpec $nodes) {
  $nodes.apply_prep

  return apply($nodes) {
    user { 'bolt':
      ensure   => present,
      password => 'bolt',

    }

    class { 'grafana':
      cfg => {
        app_mode => 'production',
        server   => {
          http_port     => 8080,
        },
        security => {
          admin_user => 'bolt',
          admin_password => 'boltIsAwesome',
        },
        database => {
          type          => 'sqlite3',
          host          => '127.0.0.1:3306',
          name          => 'grafananana',
        },
      },
    }

    class {'influxdb': }
    influx_database{"bolt":
      # TODO: probaly want to create another user
      superuser => 'bolt',
      superpass => 'hunter2'
    }

    grafana_datasource { 'influxdb':
      require           => Influx_database['bolt'],
      grafana_url       => 'http://localhost:8080',
      grafana_user      => 'bolt',
      grafana_password  => 'boltIsAwesome',
      type              => 'influxdb',
      url               => 'http://localhost:8086',
      user              => 'bolt',
      password          => 'hunter2',
      database          => 'bolt',
      access_mode       => 'proxy',
      is_default        => true,
      #json_data         => template('path/to/additional/config.json'),
    }


  }
}
