extends CSGCombiner

var integrity = 3
var index = 0

func interact():
	integrity -= 1
	if integrity <= 0:
		Inventory.items["wood"] += 1
		Inventory.removed_trees_index.append(index)
		queue_free()
