extends CSGCombiner

var integrity = 5
var index = 0

func interact():
	integrity -= 1
	if integrity <= 0:
		Data.items["rocks"] += 1
		Data.removed_rocks.append(index)
		queue_free()
