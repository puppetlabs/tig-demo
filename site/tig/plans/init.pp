plan tig(
  TargetSpec $dashboard,
  TargetSpec $agents
) {

  [$dashboard, $agents].apply_prep

  apply($dashboard) {
    include tig::dashboard
  }

  $dashboard_host = $dashboard.get_targets[0].name

  apply($agents) {
    class{ tig::telegraf:
      influx_host => $dashboard_host
    }
  }

  return('grafana_dashboard' => "http://${dashboard_host}:8080")
}
