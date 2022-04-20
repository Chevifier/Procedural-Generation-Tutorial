extends CSGCombiner

var integrity = 3
var index = 0

func interact():
	integrity -= 1
	if integrity <= 0:
		Data.items["wood"] += 1
		Data.removed_trees.append(index)
		queue_free()
