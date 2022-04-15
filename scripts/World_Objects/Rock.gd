extends CSGCombiner

var integrity = 5
var index = 0

func interact():
	integrity -= 1
	if integrity <= 0:
		Inventory.items["rocks"] += 1
		Inventory.removed_rocks_index.append(index)
		queue_free()
