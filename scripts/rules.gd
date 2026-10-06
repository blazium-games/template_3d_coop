extends RefCounted

var class_pools := {"runner": 80, "anchor": 120}

func pool_for(kind: String) -> int:
	return int(class_pools.get(kind, 0))

func apply_hit(from_role: String, kind: String, amount: int) -> String:
	if from_role != "host":
		return "rejected"
	if not class_pools.has(kind):
		return "unknown"
	if amount <= 0:
		return "rejected"
	class_pools[kind] = maxi(int(class_pools[kind]) - amount, 0)
	return "applied"

func reset_raid() -> void:
	class_pools = {"runner": 80, "anchor": 120}

static var picked := ""

func roster_ok(kind: String) -> bool:
	return kind == "runner" or kind == "anchor"

func take_roster(kind: String) -> bool:
	if not roster_ok(kind):
		return false
	picked = kind
	return true

func raid_ready() -> bool:
	return roster_ok(picked)

func revive(kind: String) -> String:
	var runner_left: int = int(class_pools.get("runner", 0))
	var anchor_left: int = int(class_pools.get("anchor", 0))
	if runner_left <= 0 and anchor_left <= 0:
		return "rejected"
	if not class_pools.has(kind):
		return "rejected"
	if int(class_pools[kind]) > 0:
		return "skipped"
	class_pools[kind] = 40
	return "revived"
