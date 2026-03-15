extends Node

var _node_components: Dictionary

func deregister_all_components() -> void:
	_node_components.clear()

func deregister_component(node: Node, component: Variant):
	var type_name = component.get_script().get_global_name()
	if !_node_components.has(node):
		return
	_node_components[node].erase(type_name)

func register_component(node: Node, component: Variant):
	var type_name = component.get_script().get_global_name()
	if !_node_components.has(node):
		_node_components[node] = {}
	_node_components[node][type_name] = component

func get_component(node: Node, component_type: Variant):
	if !_node_components.has(node):
		return null
		
	if node.is_queued_for_deletion():
		return null
		
	var type_name = component_type.get_global_name()

	if !_node_components[node].has(type_name):
		return null
		
	if _node_components[node][type_name] == null:
		_node_components[node].erase(type_name)
		return null
		
	return _node_components[node][type_name]

func get_all_components_of_type(component_type: Variant) -> Array[Variant]:
	var list: Array[Variant]
	var type_name = component_type.get_global_name()

	for node in _node_components:
		if node == null:
			_node_components.erase(node)
			continue
			
		if _node_components[node].has(type_name):
			if _node_components[node][type_name] == null:
				_node_components[node].erase(type_name)
			else:
				list.push_back(_node_components[node][type_name])
	
	return list
