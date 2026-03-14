extends Node

var _node_components: Dictionary
func register_component(node: Node, component_class: Variant):
	if !_node_components.has(node):
		_node_components[node] = {}
	_node_components[node][typeof(component_class)] = component_class

func get_component(node: Node, component_class: Variant):
	if !_node_components.has(node):
		return null
	var type = typeof(component_class)
	if !_node_components[node].has(type):
		return null
	return _node_components[node][type]
