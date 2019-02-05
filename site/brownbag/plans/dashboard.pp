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
          name          => 'grafana',
        },
      },

      # TODO This isn't working yet
      http_conn_validator { 'grafana-conn-validator' :
        host     => 'localhost',
        port     => '3000',
        use_ssl  => false,
        test_url => '/public/img/grafana_icon.svg',
        require  => Class['grafana'],
      }
      -> grafana_datasource { 'influxdb':
        grafana_url       => 'http://localhost:3000',
        grafana_user      => 'admin',
        grafana_password  => '5ecretPassw0rd',
        type              => 'influxdb',
        url               => 'http://localhost:8080',
        user              => 'admin',
        password          => 'boltIsAwesome',
        database          => 'graphite',
        access_mode       => 'proxy',
        is_default        => true,
        json_data         => template('path/to/additional/config.json'),
      }
    }

    class {'influxdb': }
  }
}