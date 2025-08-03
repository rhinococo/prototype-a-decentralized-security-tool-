# it7i_prototype_a_dec.rb
# A decentralized security tool dashboard prototype

# Modules and dependencies
require 'tty-table'
require 'colorize'
require 'json'

# Configuration
CONFIG = {
  nodes: ['node1', 'node2', 'node3'],
  security_modules: ['firewall', 'antivirus', 'ids']
}

# Security Node class
class SecurityNode
  attr_accessor :name, :status, :modules

  def initialize(name)
    @name = name
    @status = 'online'
    @modules = {}
  end

  def add_module(module_name)
    @modules[module_name] = 'enabled'
  end

  def remove_module(module_name)
    @modules.delete(module_name)
  end

  def to_json
    {
      name: @name,
      status: @status,
      modules: @modules
    }.to_json
  end
end

# Dashboard class
class Dashboard
  attr_accessor :nodes

  def initialize
    @nodes = CONFIG[:nodes].map { |node| SecurityNode.new(node) }
  end

  def add_module_to_all_nodes(module_name)
    @nodes.each { |node| node.add_module(module_name) }
  end

  def remove_module_from_all_nodes(module_name)
    @nodes.each { |node| node.remove_module(module_name) }
  end

  def display_dashboard
    table = TTY::Table.new header: ['Node', 'Status', 'Modules']
    @nodes.each do |node|
      modules = node.modules.keys.join(', ')
      table << [node.name, node.status, modules]
    end
    puts table
  end

  def to_json
    {
      nodes: @nodes.map(&:to_json)
    }.to_json
  end
end

# Initialize dashboard
dashboard = Dashboard.new

# Add security modules to all nodes
CONFIG[:security_modules].each do |module_name|
  dashboard.add_module_to_all_nodes(module_name)
end

# Display dashboard
puts 'Decentralized Security Tool Dashboard:'.colorize(:green)
dashboard.display_dashboard

# Export dashboard to JSON
puts "Exporting dashboard to JSON: #{dashboard.to_json}".colorize(:blue)