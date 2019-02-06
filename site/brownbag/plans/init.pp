plan brownbag () {
  apply_prep('all')

  apply('dashboard') {
    include brownbag::dashboard
  }

  apply('agents') {
    class{ brownbag::telegraf:
      influx_host => get_targets('dashboard')[0].name
    }
  }
}
