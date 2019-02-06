# Puppet Bolt TIG Stack Demo

A demo using [Puppet Bolt](https://puppet.com/docs/bolt) to configure and deploy metrics visualization using [Telegraf](https://forge.puppet.com/puppet/telegraf), [InfluxDB](https://forge.puppet.com/quadriq/influxdb), and [Grafana](https://forge.puppet.com/puppet/grafana), all via [Puppet Modules](https://puppet.com/docs/puppet/6.2/modules_fundamentals.html). This is for a [VBrownBag](https://www.youtube.com/channel/UCaZf13iWhwnBdpIkrEmHLbA) presentation.

## Setup

To run the demo you will:

* [Install Bolt](https://puppet.com/docs/bolt/latest/bolt_installing.html)

Then:
```
bolt puppetfile install
/opt/puppetlabs/bolt/bin/gem install toml-rb
```

Add node hostnames to the `inventory.yaml` file:
```
---
groups:
  - name: dashboard
    nodes: ["grafananana.com"]
  - name: agents
    nodes: ["grafananana.com","agent-example.com"]
config:
  ssh:
    host-key-check: false
```

You only need one node to be in 'dashboard' and one or more nodes in 'agents'.

## Usage

Run the bolt plan:
```
bolt plan run brownbag
```

## More Resources

* [Bolt Project](https://github.com/puppetlabs/bolt)
* [Bolt Documentation](https://puppet.com/docs/bolt/latest/bolt.html)
* [Tasks Hands-on Lab](https://github.com/puppetlabs/tasks-hands-on-lab#puppet-tasks-hands-on-lab)
* [Puppet Learning VM](https://learn.puppet.com/course/puppet-orchestration-bolt-and-tasks)
* Bolt Slack Channel: #bolt on https://puppetcommunity.slack.com
