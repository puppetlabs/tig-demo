class brownbag::dashboard (
  String $grafana_password = $brownbag::params::grafana_password,
  String $grafana_user = $brownbag::params::grafana_user,
  String $grafana_url = $brownbag::params::grafana_url,
  String $influx_password = $brownbag::params::influxdb_password,
  String $influx_database = $brownbag::params::influxdb_database,
  String $influx_username = $brownbag::params::influxdb_user,

) inherits ::brownbag::params {
  class { 'grafana':
    cfg => {
      app_mode => 'production',
      server   => {
        http_port     => 8080,
      },
      security => {
        admin_user => $grafana_user,
        admin_password => $grafana_password,
      },
      database => {
        type          => 'sqlite3',
        host          => '127.0.0.1:3306',
        name          => 'grafananana',
      },
    },
  }

  class {'influxdb': }
  influx_database{$influx_database:
    superuser => $influx_username,
    superpass => $influx_password
  }

  grafana_datasource { 'influxdb':
    require           => Influx_database['bolt'],
    grafana_url       => $grafana_url,
    grafana_user      => $grafana_user,
    grafana_password  => $grafana_password,
    type              => 'influxdb',
    url               => 'http://localhost:8086',
    user              => $influx_username,
    password          => $influx_password,
    database          => $influx_database,
    access_mode       => 'proxy',
    is_default        => true,
  }

  grafana_dashboard { 'telegraf':
    grafana_url       => $grafana_url,
    grafana_user      => $grafana_user,
    grafana_password  => $grafana_password,
    content           => template('brownbag/dashboards/telegraf.json')
  }
}
