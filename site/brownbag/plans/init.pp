plan brownbag (
  Integer $count = 2) {

  if empty(get_targets('dashboard')) {
    $nodes = run_task("floaty::get", 'localhost',
      platform=>"centos-7-x86_64",
      count=> $count).first['nodes']
    add_to_group($nodes[0], 'dashboard')
    add_to_group($nodes, 'agents')
  } else {
    $nodes = get_targets('agents').map |$t| { $t.name }
  }

  $dashboard_host = get_targets('dashboard')[0].name

  apply_prep('all')

  apply('dashboard') {
    include brownbag::dashboard
  }

  apply('agents') {
    class{ brownbag::telegraf:
      influx_host => $dashboard_host
    }
  }

  return({
    'grafana_dashboard' => "http://${dashboard_host}:8080",
    'nodes' => $nodes })
}
