plan brownbag::dashboard (TargetSpec $nodes) {
  $nodes.apply_prep

  return apply($nodes) {
    user { 'bolt':
      ensure   => present,
      password => 'bolt',

    }

    $gurl = 'http://localhost:8080'
    $guser = 'bolt'
    $gpass = 'boltIsAwesome'

    class { 'grafana':
      cfg => {
        app_mode => 'production',
        server   => {
          http_port     => 8080,
        },
        security => {
          admin_user => $guser,
          admin_password => $gpass,
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
      grafana_url       => $gurl,
      grafana_user      => $guser,
      grafana_password  => $gpass,
      type              => 'influxdb',
      url               => 'http://localhost:8086',
      user              => 'bolt',
      password          => 'hunter2',
      database          => 'bolt',
      access_mode       => 'proxy',
      is_default        => true,
    }

    grafana_dashboard { 'telegraf':
      grafana_url       => $gurl,
      grafana_user      => $guser,
      grafana_password  => $gpass,
      content           => template('brownbag/dashboards/telegraf.json')
    }
  }
}
